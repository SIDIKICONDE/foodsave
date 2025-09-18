import 'package:supabase_flutter/supabase_flutter.dart';
import 'lib/config/supabase_config.dart';

/// Test simple de connexion Supabase
/// 
/// Ce fichier permet de tester rapidement la connexion à Supabase
/// sans avoir besoin de lancer toute l'application Flutter.
Future<void> main() async {
  print('=== TEST DE CONNEXION SUPABASE ===');
  print('');
  
  try {
    // Initialiser Supabase
    print('🔄 Initialisation de Supabase...');
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
    print('✅ Supabase initialisé avec succès');
    
    // Tester la connexion
    print('');
    print('🔄 Test de connexion...');
    
    final client = Supabase.instance.client;
    print('✅ Client Supabase créé');
    
    // Tester une requête simple (healthcheck)
    print('');
    print('🔄 Test de requête...');
    
    // Vérifier si les tables existent en essayant de récupérer la structure
    try {
      final response = await client
          .from('shops')
          .select('count')
          .limit(1);
      
      print('✅ Table "shops" accessible');
      print('📊 Réponse: $response');
    } catch (e) {
      print('⚠️  Table "shops" non trouvée ou non accessible: $e');
      print('💡 Vous devez déployer le SQL dans Supabase Dashboard');
    }
    
    print('');
    print('=== CONFIGURATION ACTUELLE ===');
    print('URL: ${SupabaseConfig.supabaseUrl}');
    print('Anon Key: ${SupabaseConfig.supabaseAnonKey.substring(0, 20)}...');
    print('Tables à vérifier: shops, baskets_map, user_favorites, proximity_notifications, search_history');
    
  } catch (e) {
    print('❌ Erreur lors du test: $e');
    print('');
    print('🔧 Vérifiez:');
    print('1. Que vos clés Supabase sont correctes');
    print('2. Que votre projet Supabase existe');
    print('3. Que vous avez une connexion internet');
  }
  
  print('');
  print('=== FIN DU TEST ===');
}