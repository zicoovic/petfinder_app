import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petfinder_app/core/entities/pet.dart';
import 'package:petfinder_app/presentation/widgets/pet_card_list.dart';

/// ============================================================================
/// WIDGET TESTING EXPLAINED - PetCardList (More Complex Widget)
/// ============================================================================
///
/// WHAT'S DIFFERENT FROM CustomButton?
/// - PetCardList takes a Pet object (complex data)
/// - Has multiple interactive elements (card tap + favorite tap)
/// - Displays dynamic data (pet name, age, gender, distance)
/// - Shows different icons based on state (favorite vs not favorite)
///
/// TESTING CHALLENGES:
/// 1. Multiple callbacks to test (onTap, onFavoriteTap)
/// 2. Dynamic text display (pet info)
/// 3. Conditional rendering (favorite icon changes)
/// 4. Image loading states (we'll mock this)
///
/// WHAT WE'LL LEARN:
/// - Testing widgets with complex data
/// - Testing multiple tap targets in one widget
/// - Verifying correct callback is called
/// - Testing conditional UI (isFavorite true vs false)
/// ============================================================================

void main() {
  Widget makeTestableWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
      child: child,
    );
  }

  // Test data - Sample pets
  const testPetUnfavorited = Pet(
    id: '1',
    name: 'Abyssinian',
    temperament: 'Active, Energetic',
    origin: 'Egypt',
    gender: 'Male',
    age: '2 Years',
    distance: 2.5,
    isFavorite: false,
  );

  const testPetFavorited = Pet(
    id: '2',
    name: 'Bengal',
    temperament: 'Curious, Active',
    origin: 'United States',
    gender: 'Female',
    age: '1 Year',
    distance: 5.0,
    isFavorite: true,
  );

  group('PetCardList Widget Tests', () {
    /// ========================================================================
    /// TEST 1: Displays pet information correctly
    /// ========================================================================
    /// SCENARIO: Render pet card with pet data
    /// EXPECTED: All pet info should be visible (name, gender, age, distance)
    /// ========================================================================
    testWidgets('should display all pet information',
        (WidgetTester tester) async {
      // ARRANGE & ACT: Render pet card
      await tester.pumpWidget(
        makeTestableWidget(
          PetCardList(
            pet: testPetUnfavorited,
            onTap: () {},
            onFavoriteTap: () {},
          ),
        ),
      );

      // ASSERT: Check all text fields are visible
      expect(find.text('Abyssinian'), findsOneWidget); // Pet name
      expect(find.text('Male'), findsOneWidget); // Gender
      expect(find.text('2 Years'), findsOneWidget); // Age
      expect(find.text('2.5 km away'), findsOneWidget); // Distance

      // Check location icon exists
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    /// ========================================================================
    /// TEST 2: Shows empty heart when not favorited
    /// ========================================================================
    /// SCENARIO: Pet is not favorited (isFavorite: false)
    /// EXPECTED: Should show favorite_border icon (empty heart)
    /// ========================================================================
    testWidgets('should show empty heart icon when pet is not favorited',
        (WidgetTester tester) async {
      // ARRANGE & ACT: Render unfavorited pet
      await tester.pumpWidget(
        makeTestableWidget(
          PetCardList(
            pet: testPetUnfavorited,
            onTap: () {},
            onFavoriteTap: () {},
          ),
        ),
      );

      // ASSERT: Should show empty heart
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    /// ========================================================================
    /// TEST 3: Shows filled heart when favorited
    /// ========================================================================
    /// SCENARIO: Pet is favorited (isFavorite: true)
    /// EXPECTED: Should show favorite icon (filled heart)
    /// ========================================================================
    testWidgets('should show filled heart icon when pet is favorited',
        (WidgetTester tester) async {
      // ARRANGE & ACT: Render favorited pet
      await tester.pumpWidget(
        makeTestableWidget(
          PetCardList(
            pet: testPetFavorited,
            onTap: () {},
            onFavoriteTap: () {},
          ),
        ),
      );

      // ASSERT: Should show filled heart
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    /// ========================================================================
    /// TEST 4: Tapping card calls onTap
    /// ========================================================================
    /// SCENARIO: User taps anywhere on the pet card
    /// EXPECTED: onTap callback should be called
    /// ========================================================================
    testWidgets('should call onTap when card is tapped',
        (WidgetTester tester) async {
      // ARRANGE: Track if callback was called
      bool cardWasTapped = false;

      await tester.pumpWidget(
        makeTestableWidget(
          PetCardList(
            pet: testPetUnfavorited,
            onTap: () {
              cardWasTapped = true;
            },
            onFavoriteTap: () {},
          ),
        ),
      );

      // ACT: Tap on the pet name (part of the card)
      await tester.tap(find.text('Abyssinian'));
      await tester.pump();

      // ASSERT: onTap should be called
      expect(cardWasTapped, true);
    });

    /// ========================================================================
    /// TEST 5: Tapping favorite icon calls onFavoriteTap
    /// ========================================================================
    /// SCENARIO: User taps the heart icon
    /// EXPECTED: onFavoriteTap callback should be called, NOT onTap
    /// ========================================================================
    testWidgets('should call onFavoriteTap when heart icon is tapped',
        (WidgetTester tester) async {
      // ARRANGE: Track which callback was called
      bool cardWasTapped = false;
      bool favoriteWasTapped = false;

      await tester.pumpWidget(
        makeTestableWidget(
          PetCardList(
            pet: testPetUnfavorited,
            onTap: () {
              cardWasTapped = true;
            },
            onFavoriteTap: () {
              favoriteWasTapped = true;
            },
          ),
        ),
      );

      // ACT: Tap on the heart icon
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      // ASSERT: Only favorite callback should be called
      expect(favoriteWasTapped, true);
      expect(cardWasTapped, false);
    });

    /// ========================================================================
    /// TEST 6: Handles missing data gracefully
    /// ========================================================================
    /// SCENARIO: Pet has null gender and age
    /// EXPECTED: Should show "Unknown" for missing fields
    /// ========================================================================
    testWidgets('should show "Unknown" for missing gender/age',
        (WidgetTester tester) async {
      // ARRANGE: Pet with null fields
      const petWithMissingData = Pet(
        id: '3',
        name: 'Persian',
        temperament: 'Calm',
        origin: 'Iran',
        gender: null, // Missing
        age: null, // Missing
        distance: 3.0,
        isFavorite: false,
      );

      // ACT: Render pet card
      await tester.pumpWidget(
        makeTestableWidget(
          PetCardList(
            pet: petWithMissingData,
            onTap: () {},
            onFavoriteTap: () {},
          ),
        ),
      );

      // ASSERT: Should show "Unknown" twice (gender + age)
      expect(find.text('Unknown'), findsNWidgets(2));
      expect(find.text('Persian'), findsOneWidget);
    });

    /// ========================================================================
    /// TEST 7: Shows placeholder when no image URL
    /// ========================================================================
    /// SCENARIO: Pet has null imageUrl
    /// EXPECTED: Should show pets icon as placeholder
    /// ========================================================================
    testWidgets('should show placeholder icon when no image URL',
        (WidgetTester tester) async {
      // ARRANGE: Pet without image
      const petNoImage = Pet(
        id: '4',
        name: 'Maine Coon',
        temperament: 'Gentle',
        origin: 'United States',
        imageUrl: null, // No image
        gender: 'Male',
        age: '3 Years',
        distance: 1.5,
        isFavorite: false,
      );

      // ACT: Render pet card
      await tester.pumpWidget(
        makeTestableWidget(
          PetCardList(
            pet: petNoImage,
            onTap: () {},
            onFavoriteTap: () {},
          ),
        ),
      );

      // ASSERT: Should show pets icon as placeholder
      expect(find.byIcon(Icons.pets), findsOneWidget);
    });

    /// ========================================================================
    /// TEST 8: Different pets show different data
    /// ========================================================================
    /// SCENARIO: Render two different pet cards
    /// EXPECTED: Each shows its own unique data
    /// ========================================================================
    testWidgets('should display different data for different pets',
        (WidgetTester tester) async {
      // ARRANGE & ACT: Render two pet cards in a column
      await tester.pumpWidget(
        makeTestableWidget(
          Column(
            children: [
              PetCardList(
                pet: testPetUnfavorited,
                onTap: () {},
                onFavoriteTap: () {},
              ),
              PetCardList(
                pet: testPetFavorited,
                onTap: () {},
                onFavoriteTap: () {},
              ),
            ],
          ),
        ),
      );

      // ASSERT: Both pet names visible
      expect(find.text('Abyssinian'), findsOneWidget);
      expect(find.text('Bengal'), findsOneWidget);

      // Both have different genders
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);

      // Different distances
      expect(find.text('2.5 km away'), findsOneWidget);
      expect(find.text('5.0 km away'), findsOneWidget);

      // Different favorite states
      expect(find.byIcon(Icons.favorite_border), findsOneWidget); // Abyssinian
      expect(find.byIcon(Icons.favorite), findsOneWidget); // Bengal
    });

    /// ========================================================================
    /// TEST 9: Favorite icon changes when pet data changes
    /// ========================================================================
    /// SCENARIO: Pet favorite status changes from false to true
    /// EXPECTED: Icon should change from empty to filled heart
    /// ========================================================================
    testWidgets('should update heart icon when favorite status changes',
        (WidgetTester tester) async {
      // ARRANGE: Start with unfavorited pet
      await tester.pumpWidget(
        makeTestableWidget(
          PetCardList(
            pet: testPetUnfavorited,
            onTap: () {},
            onFavoriteTap: () {},
          ),
        ),
      );

      // ASSERT 1: Initially shows empty heart
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      // ACT: Update to favorited pet
      await tester.pumpWidget(
        makeTestableWidget(
          PetCardList(
            pet: testPetUnfavorited.copyWith(isFavorite: true),
            onTap: () {},
            onFavoriteTap: () {},
          ),
        ),
      );

      // ASSERT 2: Now shows filled heart
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });
  });
}

/// ============================================================================
/// WHAT YOU LEARNED - Testing Complex Widgets
/// ============================================================================
///
/// 1. TESTING WITH COMPLEX DATA:
///    - Create test Pet objects with different states
///    - Test how widget displays different data
///    - Verify all fields render correctly
///
/// 2. MULTIPLE TAP TARGETS:
///    - Widget has 2 GestureDetectors (card + favorite icon)
///    - Test each tap independently
///    - Ensure correct callback is called for each tap
///
/// 3. CONDITIONAL RENDERING:
///    - Icon changes based on isFavorite (border vs filled)
///    - Use findsOneWidget and findsNothing to verify
///    - Test both states (true and false)
///
/// 4. NULL HANDLING:
///    - Test widgets with missing/null data
///    - Verify fallback values display ("Unknown")
///    - Ensure no crashes with null values
///
/// 5. DYNAMIC UPDATES:
///    - Test widget re-rendering with new data
///    - Verify UI updates when pet data changes
///    - Use copyWith() to create modified pet objects
///
/// 6. TESTING LISTS:
///    - Render multiple widgets at once
///    - Verify each shows unique data
///    - Use findsNWidgets(2) when expecting duplicates
///
/// ============================================================================
/// REAL WORLD SCENARIO:
/// ============================================================================
///
/// Bug Report: "Tapping anywhere on pet card favorites it!"
///
/// WITHOUT TESTS:
/// - Manually click different areas of card
/// - Hard to isolate the exact tap target issue
///
/// WITH TESTS:
/// - Test "should call onFavoriteTap when heart icon is tapped" fails
/// - Shows: cardWasTapped = true (should be false)
/// - Found bug: GestureDetectors overlap incorrectly!
///
/// Widget tests catch UI interaction bugs! 🎯
/// ============================================================================
