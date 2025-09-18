// Edge Function pour vérifier l'expiration des repas - FoodSave
// Standards NYTH - Zero Compromise

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.0";

interface Meal {
  id: string;
  title: string;
  merchant_id: string;
  available_until: string;
  status: string;
  remaining_quantity: number;
}

interface Notification {
  user_id: string;
  title: string;
  message: string;
  type: string;
  data: object;
}

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
};

serve(async (req) => {
  // Gérer les requêtes CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders, status: 200 });
  }

  try {
    // Initialiser le client Supabase avec les variables d'environnement
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
    
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    console.log('🔍 Démarrage de la vérification d\'expiration des repas...');

    // Obtenir l'heure actuelle
    const now = new Date();
    const nowISO = now.toISOString();

    // 1. Trouver les repas expirés qui sont encore marqués comme disponibles
    const { data: expiredMeals, error: expiredError } = await supabase
      .from('meals')
      .select('id, title, merchant_id, available_until, status, remaining_quantity')
      .eq('status', 'available')
      .lt('available_until', nowISO);

    if (expiredError) {
      console.error('❌ Erreur lors de la récupération des repas expirés:', expiredError);
      throw expiredError;
    }

    console.log(`📊 ${expiredMeals?.length || 0} repas expirés trouvés`);

    // 2. Mettre à jour le statut des repas expirés
    if (expiredMeals && expiredMeals.length > 0) {
      const expiredIds = expiredMeals.map((meal: Meal) => meal.id);
      
      const { error: updateError } = await supabase
        .from('meals')
        .update({ status: 'expired', updated_at: nowISO })
        .in('id', expiredIds);

      if (updateError) {
        console.error('❌ Erreur lors de la mise à jour des repas expirés:', updateError);
        throw updateError;
      }

      console.log(`✅ ${expiredIds.length} repas marqués comme expirés`);

      // 3. Créer des notifications pour les commerçants
      const notifications: Notification[] = expiredMeals.map((meal: Meal) => ({
        user_id: meal.merchant_id,
        title: 'Repas expiré',
        message: `Votre repas "${meal.title}" a expiré et n'est plus disponible à la vente.`,
        type: 'meal_expired',
        data: {
          meal_id: meal.id,
          meal_title: meal.title,
          expired_at: nowISO,
          remaining_quantity: meal.remaining_quantity
        }
      }));

      if (notifications.length > 0) {
        const { error: notificationError } = await supabase
          .from('notifications')
          .insert(notifications);

        if (notificationError) {
          console.error('❌ Erreur lors de la création des notifications:', notificationError);
        } else {
          console.log(`📱 ${notifications.length} notifications créées pour les commerçants`);
        }
      }
    }

    // 4. Trouver les repas qui expirent dans moins de 2 heures (pour alertes préventives)
    const twoHoursFromNow = new Date(now.getTime() + 2 * 60 * 60 * 1000).toISOString();
    
    const { data: soonToExpireMeals, error: soonError } = await supabase
      .from('meals')
      .select('id, title, merchant_id, available_until, remaining_quantity')
      .eq('status', 'available')
      .gt('available_until', nowISO)
      .lt('available_until', twoHoursFromNow)
      .gt('remaining_quantity', 0);

    if (soonError) {
      console.error('❌ Erreur lors de la récupération des repas bientôt expirés:', soonError);
      throw soonError;
    }

    console.log(`⏰ ${soonToExpireMeals?.length || 0} repas expirent dans moins de 2h`);

    // 5. Créer des notifications préventives pour les repas qui expirent bientôt
    if (soonToExpireMeals && soonToExpireMeals.length > 0) {
      // Vérifier qu'on n'a pas déjà envoyé d'alerte récemment pour ces repas
      const { data: recentAlerts } = await supabase
        .from('notifications')
        .select('data')
        .eq('type', 'meal_expiring_soon')
        .gte('created_at', new Date(now.getTime() - 3 * 60 * 60 * 1000).toISOString()); // dernières 3h

      const recentlyAlertedMealIds = recentAlerts?.map(
        (alert) => alert.data?.meal_id
      ).filter(Boolean) || [];

      const newAlerts: Notification[] = soonToExpireMeals
        .filter((meal: Meal) => !recentlyAlertedMealIds.includes(meal.id))
        .map((meal: Meal) => {
          const expiresAt = new Date(meal.available_until);
          const hoursLeft = Math.ceil((expiresAt.getTime() - now.getTime()) / (1000 * 60 * 60));
          
          return {
            user_id: meal.merchant_id,
            title: 'Repas bientôt expiré',
            message: `Votre repas "${meal.title}" expire dans ${hoursLeft}h. ${meal.remaining_quantity} portion(s) restante(s).`,
            type: 'meal_expiring_soon',
            data: {
              meal_id: meal.id,
              meal_title: meal.title,
              expires_at: meal.available_until,
              hours_left: hoursLeft,
              remaining_quantity: meal.remaining_quantity
            }
          };
        });

      if (newAlerts.length > 0) {
        const { error: alertError } = await supabase
          .from('notifications')
          .insert(newAlerts);

        if (alertError) {
          console.error('❌ Erreur lors de la création des alertes préventives:', alertError);
        } else {
          console.log(`🚨 ${newAlerts.length} alertes préventives créées`);
        }
      }
    }

    // 6. Nettoyer les anciennes notifications (plus de 30 jours)
    const thirtyDaysAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000).toISOString();
    
    const { error: cleanupError } = await supabase
      .from('notifications')
      .delete()
      .lt('created_at', thirtyDaysAgo)
      .eq('is_read', true);

    if (cleanupError) {
      console.error('❌ Erreur lors du nettoyage des anciennes notifications:', cleanupError);
    } else {
      console.log('🧹 Nettoyage des anciennes notifications terminé');
    }

    // 7. Statistiques finales
    const stats = {
      timestamp: nowISO,
      expired_meals_count: expiredMeals?.length || 0,
      soon_to_expire_count: soonToExpireMeals?.length || 0,
      notifications_sent: (expiredMeals?.length || 0) + (soonToExpireMeals?.length || 0),
      status: 'success'
    };

    console.log('📈 Statistiques de la vérification:', stats);

    return new Response(
      JSON.stringify({
        success: true,
        message: 'Vérification d\'expiration des repas terminée avec succès',
        data: stats
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200
      }
    );

  } catch (error) {
    console.error('💥 Erreur fatale lors de la vérification d\'expiration:', error);
    
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message,
        timestamp: new Date().toISOString()
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500
      }
    );
  }
});