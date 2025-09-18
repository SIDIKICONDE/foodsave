# Script de deploiement pour le projet FoodSave
# Project ID: igbloqlksvbeztcnojqk

Write-Host "=== DEPLOIEMENT FOODSAVE - PROJECT igbloqlksvbeztcnojqk ===" -ForegroundColor Green
Write-Host ""

Write-Host "URL du projet: https://igbloqlksvbeztcnojqk.supabase.co" -ForegroundColor Cyan
Write-Host "Dashboard: https://supabase.com/dashboard/project/igbloqlksvbeztcnojqk" -ForegroundColor Cyan
Write-Host ""

Write-Host "ETAPES A SUIVRE:" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. RECUPERER LA CLE ANONYME:" -ForegroundColor White
Write-Host "   - Le dashboard de votre projet est ouvert dans le navigateur"
Write-Host "   - Allez dans: Settings > API"
Write-Host "   - Copiez la 'anon public' key"
Write-Host ""

Write-Host "2. CONFIGURER LA CLE DANS FLUTTER:" -ForegroundColor White
Write-Host "   - Editez: lib/config/supabase_config.dart"
Write-Host "   - Remplacez 'your-anon-key-here' par votre vraie cle"
Write-Host ""

Write-Host "3. DEPLOYER LES TABLES:" -ForegroundColor White
Write-Host "   - Dans le dashboard, cliquez sur 'SQL Editor'"
Write-Host "   - Copiez-collez le SQL ci-dessous"
Write-Host "   - Cliquez sur 'RUN'"
Write-Host ""

Write-Host "=== SQL A COPIER DANS SUPABASE ===" -ForegroundColor Green
Write-Host ""

# Afficher le contenu SQL
$migrationFile = "supabase/migrations/20240101000000_initial_schema.sql"
if (Test-Path $migrationFile) {
    $sqlContent = Get-Content $migrationFile -Raw
    
    # Remplacer les caractères problématiques pour l'affichage
    $sqlContent = $sqlContent -replace 'Ã©', 'e'
    $sqlContent = $sqlContent -replace 'Ã¨', 'e'  
    $sqlContent = $sqlContent -replace 'Ã ', 'a'
    $sqlContent = $sqlContent -replace 'Ã´', 'o'
    $sqlContent = $sqlContent -replace '%', 'E'
    
    Write-Host $sqlContent -ForegroundColor White
}
else {
    Write-Host "ERREUR: Fichier SQL non trouve" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== APRES LE DEPLOIEMENT ===" -ForegroundColor Yellow
Write-Host ""

Write-Host "4. VERIFIER LES TABLES:" -ForegroundColor White
Write-Host "   - Allez dans 'Table Editor'"
Write-Host "   - Vous devriez voir 5 tables:"
Write-Host "     * shops (magasins)"
Write-Host "     * baskets_map (paniers)"
Write-Host "     * user_favorites (favoris)"
Write-Host "     * proximity_notifications (notifications)"
Write-Host "     * search_history (historique)"
Write-Host ""

Write-Host "5. TESTER DEPUIS FLUTTER:" -ForegroundColor White
Write-Host "   - flutter analyze"
Write-Host "   - flutter run"
Write-Host ""

Write-Host "=== DONNEES DE TEST INCLUSES ===" -ForegroundColor Cyan
Write-Host "- 3 magasins: Boulangerie, Restaurant, Epicerie"
Write-Host "- 3 paniers avec geolocalisation autour de Paris"
Write-Host "- Politiques de securite (RLS) configurees"
Write-Host "- Index optimises pour les performances"
Write-Host ""

$openSettings = Read-Host "Voulez-vous ouvrir la page Settings > API pour recuperer la cle ? (y/N)"
if ($openSettings -eq "y" -or $openSettings -eq "Y") {
    Start-Process "https://supabase.com/dashboard/project/igbloqlksvbeztcnojqk/settings/api"
    Write-Host "Page API Settings ouverte - copiez la 'anon public' key" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== CONFIGURATION ACTUELLE ===" -ForegroundColor Cyan
Write-Host "URL: https://igbloqlksvbeztcnojqk.supabase.co [CONFIGURE]" -ForegroundColor Green
Write-Host "Anon Key: [A CONFIGURER]" -ForegroundColor Yellow
Write-Host "Migration SQL: [PRETE]" -ForegroundColor Green
Write-Host ""
Write-Host "Vous etes pret pour le deploiement final !" -ForegroundColor Green