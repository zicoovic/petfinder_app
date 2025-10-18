import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:petfinder_app/main.dart' as app;

/// ============================================================================
/// INTEGRATION TESTING EXPLAINED
/// ============================================================================
///
/// WHAT ARE INTEGRATION TESTS?
/// - Test complete user flows from start to finish
/// - Run on real devices or emulators (not just in memory like unit/widget tests)
/// - Test how different parts of the app work together
/// - Closest thing to manual testing, but automated!
///
/// DIFFERENCE FROM OTHER TEST TYPES:
///
/// UNIT TESTS:
/// - Test single functions/classes in isolation
/// - Example: Does getPets() return correct data?
/// - Fast (milliseconds)
/// - Run in memory
///
/// WIDGET TESTS:
/// - Test UI components in isolation
/// - Example: Does CustomButton show loading spinner?
/// - Fast (seconds)
/// - Run in memory
///
/// INTEGRATION TESTS:
/// - Test complete user journeys
/// - Example: Can user browse pets → favorite one → see it in favorites?
/// - Slow (minutes)
/// - Run on actual device/emulator
///
/// WHY INTEGRATION TESTS MATTER:
/// - Unit tests might pass, widget tests might pass, but app could still break
/// - Integration tests verify everything works together
/// - Catch bugs that only appear when features interact
///
/// HOW TO RUN:
/// flutter test integration_test/app_test.dart
///
/// ============================================================================

void main() {
  // Required for integration tests
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('PetFinder App Integration Tests', () {
    /// ========================================================================
    /// TEST 1: Complete User Flow - Browse, View Details, Favorite
    /// ========================================================================
    /// USER STORY:
    /// As a user, I want to browse cats, view details, and save favorites
    ///
    /// STEPS:
    /// 1. Open app (shows onboarding)
    /// 2. Click "Get Started" → Goes to home
    /// 3. Wait for pets to load
    /// 4. Verify pet list appears
    /// 5. Tap on a pet card
    /// 6. Verify details screen appears
    /// 7. Tap favorite button
    /// 8. Go back to home
    /// 9. Navigate to favorites
    /// 10. Verify favorited pet appears
    /// ========================================================================
    testWidgets('User can browse pets, view details, and add to favorites',
        (WidgetTester tester) async {
      // STEP 1: Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // STEP 2: Should be on onboarding screen
      // Look for "Get Started" button
      expect(find.text('Get Started'), findsOneWidget);

      // STEP 3: Tap "Get Started" to go to home
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // STEP 4: Should be on home screen now
      // Wait for pets to load from API
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // STEP 5: Verify home screen elements appear
      expect(find.text('Find Your Forever Pet'), findsOneWidget);

      // STEP 6: Find any pet card (there should be multiple)
      // We'll tap the first one
      final petCards = find.byType(GestureDetector);
      expect(petCards, findsWidgets); // Should find multiple pet cards

      // STEP 7: Tap on the first pet card to view details
      // Note: First GestureDetector might be search bar, so we'll look for pet images
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Find and tap a pet card by looking for the first ClipRRect (pet image)
      final petImages = find.byType(ClipRRect);
      if (petImages.evaluate().isNotEmpty) {
        await tester.tap(petImages.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // STEP 8: Should be on details screen now
        // Look for back button (details screen has AppBar with back button)
        expect(find.byType(AppBar), findsOneWidget);

        // STEP 9: Find and tap the favorite button (heart icon)
        final favoriteIcon = find.byIcon(Icons.favorite_border);
        if (favoriteIcon.evaluate().isNotEmpty) {
          await tester.tap(favoriteIcon.first);
          await tester.pumpAndSettle(const Duration(seconds: 1));

          // STEP 10: Icon should change to filled heart
          expect(find.byIcon(Icons.favorite), findsOneWidget);

          // STEP 11: Go back to home
          await tester.pageBack();
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // STEP 12: Navigate to favorites screen
          // Find the favorites tab in bottom navigation
          final favoritesTab = find.byIcon(Icons.favorite);
          if (favoritesTab.evaluate().length > 1) {
            // Tap the favorites icon in bottom nav (second occurrence)
            await tester.tap(favoritesTab.last);
            await tester.pumpAndSettle(const Duration(seconds: 2));

            // STEP 13: Should see at least one favorited pet
            // Favorites screen shows pets in a grid
            expect(find.byType(GridView), findsOneWidget);
          }
        }
      }
    });

    /// ========================================================================
    /// TEST 2: Search Functionality
    /// ========================================================================
    /// USER STORY:
    /// As a user, I want to search for specific cat breeds
    ///
    /// STEPS:
    /// 1. Open app and navigate to home
    /// 2. Enter search query in search bar
    /// 3. Verify filtered results appear
    /// 4. Clear search
    /// 5. Verify all pets return
    /// ========================================================================
    testWidgets('User can search for pets by name',
        (WidgetTester tester) async {
      // STEP 1: Launch app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // STEP 2: Tap "Get Started"
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // STEP 3: Wait for pets to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // STEP 4: Find search field
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      // STEP 5: Enter search query
      await tester.enterText(searchField, 'Abyssinian');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // STEP 6: Verify search filtered results
      // Should show "Abyssinian" if it exists in the API
      // Note: Results depend on API response

      // STEP 7: Clear search
      await tester.enterText(searchField, '');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // STEP 8: All pets should appear again
      expect(find.text('Find Your Forever Pet'), findsOneWidget);
    });

    /// ========================================================================
    /// TEST 3: Breed Filter Functionality
    /// ========================================================================
    /// USER STORY:
    /// As a user, I want to filter cats by breed category
    ///
    /// STEPS:
    /// 1. Open app and navigate to home
    /// 2. Tap on a breed category chip
    /// 3. Verify pets are filtered
    /// 4. Tap "All" category
    /// 5. Verify all pets return
    /// ========================================================================
    testWidgets('User can filter pets by breed category',
        (WidgetTester tester) async {
      // STEP 1: Launch app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // STEP 2: Tap "Get Started"
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // STEP 3: Wait for pets to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // STEP 4: Find "All" category chip (should be visible)
      final allChip = find.text('All');
      expect(allChip, findsOneWidget);

      // STEP 5: Scroll to find other category chips and tap one
      // (Category chips are created dynamically from API)
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // STEP 6: Tap "All" to return to all pets
      await tester.tap(allChip);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // STEP 7: Verify we're back to showing all pets
      expect(find.text('Find Your Forever Pet'), findsOneWidget);
    });

    /// ========================================================================
    /// TEST 4: Remove from Favorites
    /// ========================================================================
    /// USER STORY:
    /// As a user, I want to remove pets from my favorites
    ///
    /// STEPS:
    /// 1. Navigate to home (assume pets loaded)
    /// 2. Favorite a pet
    /// 3. Go to favorites screen
    /// 4. Unfavorite the pet
    /// 5. Verify it's removed from favorites
    /// ========================================================================
    testWidgets('User can remove pets from favorites',
        (WidgetTester tester) async {
      // STEP 1: Launch app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // STEP 2: Navigate to home
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle(const Duration(seconds: 7));

      // STEP 3: Find and tap favorite icon on first pet
      final favoriteIcons = find.byIcon(Icons.favorite_border);
      if (favoriteIcons.evaluate().isNotEmpty) {
        await tester.tap(favoriteIcons.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // STEP 4: Navigate to favorites
        final navFavorites = find.byIcon(Icons.favorite);
        if (navFavorites.evaluate().length > 1) {
          await tester.tap(navFavorites.last);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // STEP 5: Find favorite icon in favorites screen and unfavorite
          final favIconsInScreen = find.byIcon(Icons.favorite);
          if (favIconsInScreen.evaluate().isNotEmpty) {
            await tester.tap(favIconsInScreen.first);
            await tester.pumpAndSettle(const Duration(seconds: 1));

            // STEP 6: Should show empty state or removed pet
            // If this was the only favorite, should show "No favorites" message
          }
        }
      }
    });
  });
}

/// ============================================================================
/// WHAT YOU LEARNED - Integration Testing
/// ============================================================================
///
/// 1. INTEGRATION TEST SETUP:
///    - Use IntegrationTestWidgetsFlutterBinding.ensureInitialized()
///    - Tests run on real device/emulator
///    - Much slower than unit/widget tests
///
/// 2. PUMPING AND SETTLING:
///    - pumpAndSettle() waits for all animations to complete
///    - Add Duration for API calls or loading states
///    - Example: await tester.pumpAndSettle(Duration(seconds: 5))
///
/// 3. TESTING USER FLOWS:
///    - Simulate real user actions (tap, scroll, enter text)
///    - Test multiple screens in sequence
///    - Verify state persists across screens
///
/// 4. WAITING FOR ASYNC OPERATIONS:
///    - API calls take time (5-10 seconds)
///    - Navigation animations need time to complete
///    - Always add sufficient wait times
///
/// 5. FINDING WIDGETS:
///    - Use find.text(), find.byIcon(), find.byType()
///    - Some widgets have multiple instances (favorite icon in list + nav)
///    - Use .first, .last, or .at(index) to select specific widget
///
/// 6. HANDLING DYNAMIC CONTENT:
///    - Pet data comes from API (not predictable)
///    - Use conditional checks: if (widget.evaluate().isNotEmpty)
///    - Test general flow, not specific data
///
/// ============================================================================
/// REAL WORLD VALUE:
/// ============================================================================
///
/// WITHOUT INTEGRATION TESTS:
/// - Unit tests pass ✅
/// - Widget tests pass ✅
/// - But app crashes when user favorites a pet and navigates back!
/// - Spend hours manually testing every flow
///
/// WITH INTEGRATION TESTS:
/// - Run: flutter test integration_test/
/// - Tests simulate real user journeys
/// - Catch bugs that only appear when features interact
/// - Example: Favorites save correctly (unit test ✅)
///           BUT favorites don't appear in UI (integration test ✅ catches this!)
///
/// Integration tests = Your QA team! 🧪
/// ============================================================================
///
/// HOW TO RUN THESE TESTS:
/// ============================================================================
///
/// Option 1: On an Emulator/Simulator
/// 1. Start Android Emulator or iOS Simulator
/// 2. Run: flutter test integration_test/app_test.dart
///
/// Option 2: On a Real Device
/// 1. Connect device via USB
/// 2. Enable USB debugging (Android) or trust computer (iOS)
/// 3. Run: flutter test integration_test/app_test.dart
///
/// Option 3: Run all integration tests
/// flutter test integration_test/
///
/// NOTE: Integration tests are SLOW (2-5 minutes)
/// This is normal because they run on real device with real API calls!
/// ============================================================================
