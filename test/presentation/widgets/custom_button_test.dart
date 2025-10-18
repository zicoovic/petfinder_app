import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petfinder_app/presentation/widgets/custom_button.dart';

/// ============================================================================
/// WIDGET TESTING EXPLAINED - CustomButton
/// ============================================================================
///
/// WHAT IS WIDGET TESTING?
/// - Tests UI components (widgets) in isolation
/// - Verifies widgets render correctly
/// - Tests user interactions (taps, scrolls, etc.)
/// - Checks if widgets display correct text, icons, colors
///
/// DIFFERENCE FROM UNIT TESTS:
/// - Unit Tests: Test pure logic (functions, classes)
/// - Widget Tests: Test UI components (buttons, text, layouts)
/// - Widget tests use Flutter's widget testing framework
///
/// KEY WIDGET TESTING CONCEPTS:
/// 1. WidgetTester: Tool to interact with widgets (tap, enter text, scroll)
/// 2. Finders: Locate widgets in the widget tree (find.text, find.byType)
/// 3. Matchers: Check widget properties (findsOneWidget, findsNothing)
/// 4. pumpWidget(): Renders the widget for testing
/// 5. pump(): Rebuilds the widget after state changes
///
/// HOW WIDGET TESTS WORK:
/// 1. Create a test widget
/// 2. Render it with pumpWidget()
/// 3. Find widgets using finders (find.text, find.byIcon)
/// 4. Interact with widgets (tester.tap)
/// 5. Verify results (expect widget exists, text matches, etc.)
///
/// REAL WORLD BENEFIT:
/// Without tests: Manually open app, click button, check if it works
/// With tests: Run flutter test → Instantly knows if button works
/// ============================================================================

void main() {
  // Helper function to wrap widgets with MaterialApp
  // This is needed because many Flutter widgets require MaterialApp context
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

  group('CustomButton Widget Tests', () {
    /// ========================================================================
    /// TEST 1: Button renders with text
    /// ========================================================================
    /// SCENARIO: Create a button with text "Click Me"
    /// EXPECTED: Button should appear with the text
    /// ========================================================================
    testWidgets('should display button with correct text',
        (WidgetTester tester) async {
      // ARRANGE & ACT: Render the widget
      await tester.pumpWidget(
        makeTestableWidget(
          CustomButton(
            text: 'Click Me',
            onPressed: () {},
          ),
        ),
      );

      // ASSERT: Check if text appears
      expect(find.text('Click Me'), findsOneWidget);

      // Check if button exists
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    /// ========================================================================
    /// TEST 2: Button tap triggers callback
    /// ========================================================================
    /// SCENARIO: User taps the button
    /// EXPECTED: onPressed callback should be called
    /// ========================================================================
    testWidgets('should call onPressed when tapped',
        (WidgetTester tester) async {
      // ARRANGE: Track if button was pressed
      bool wasPressed = false;

      await tester.pumpWidget(
        makeTestableWidget(
          CustomButton(
            text: 'Tap Me',
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      );

      // ACT: Tap the button
      await tester.tap(find.byType(CustomButton));
      await tester.pump(); // Rebuild widget after tap

      // ASSERT: Check callback was called
      expect(wasPressed, true);
    });

    /// ========================================================================
    /// TEST 3: Loading state shows spinner
    /// ========================================================================
    /// SCENARIO: Button is in loading state
    /// EXPECTED: Should show CircularProgressIndicator, hide text
    /// ========================================================================
    testWidgets('should show loading indicator when isLoading is true',
        (WidgetTester tester) async {
      // ARRANGE & ACT: Render button with isLoading: true
      await tester.pumpWidget(
        makeTestableWidget(
          CustomButton(
            text: 'Submit',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      );

      // ASSERT: Should show loading spinner
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Should NOT show text when loading
      expect(find.text('Submit'), findsNothing);
    });

    /// ========================================================================
    /// TEST 4: Loading state disables button
    /// ========================================================================
    /// SCENARIO: Button is loading, user tries to tap
    /// EXPECTED: onPressed should NOT be called (button disabled)
    /// ========================================================================
    testWidgets('should not call onPressed when loading',
        (WidgetTester tester) async {
      // ARRANGE: Track button presses
      bool wasPressed = false;

      await tester.pumpWidget(
        makeTestableWidget(
          CustomButton(
            text: 'Submit',
            onPressed: () {
              wasPressed = true;
            },
            isLoading: true, // Button is loading
          ),
        ),
      );

      // ACT: Try to tap the button
      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      // ASSERT: Callback should NOT be called
      expect(wasPressed, false);
    });

    /// ========================================================================
    /// TEST 5: Button with icon
    /// ========================================================================
    /// SCENARIO: Button has text + icon
    /// EXPECTED: Both text and icon should appear
    /// ========================================================================
    testWidgets('should display icon when provided',
        (WidgetTester tester) async {
      // ARRANGE & ACT: Render button with icon
      await tester.pumpWidget(
        makeTestableWidget(
          CustomButton(
            text: 'Start',
            onPressed: () {},
            icon: const Icon(Icons.play_arrow),
          ),
        ),
      );

      // ASSERT: Should show both text and icon
      expect(find.text('Start'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    /// ========================================================================
    /// TEST 6: Custom colors
    /// ========================================================================
    /// SCENARIO: Button with custom background and text colors
    /// EXPECTED: Button should use custom colors
    /// ========================================================================
    testWidgets('should apply custom colors', (WidgetTester tester) async {
      // ARRANGE & ACT: Render button with custom colors
      await tester.pumpWidget(
        makeTestableWidget(
          CustomButton(
            text: 'Custom',
            onPressed: () {},
            backgroundColor: Colors.red,
            textColor: Colors.white,
          ),
        ),
      );

      // ASSERT: Find the ElevatedButton
      final elevatedButton =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      // Check button style has custom background
      expect(
        elevatedButton.style?.backgroundColor?.resolve({}),
        Colors.red,
      );
    });

    /// ========================================================================
    /// TEST 7: Button without icon
    /// ========================================================================
    /// SCENARIO: Button created without icon parameter
    /// EXPECTED: No icon should appear, only text
    /// ========================================================================
    testWidgets('should not display icon when not provided',
        (WidgetTester tester) async {
      // ARRANGE & ACT: Render button without icon
      await tester.pumpWidget(
        makeTestableWidget(
          CustomButton(
            text: 'No Icon',
            onPressed: () {},
          ),
        ),
      );

      // ASSERT: Text exists, but no icon
      expect(find.text('No Icon'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });

    /// ========================================================================
    /// TEST 8: Button state transition (normal → loading → normal)
    /// ========================================================================
    /// SCENARIO: Button changes from normal to loading to normal
    /// EXPECTED: UI updates correctly for each state
    /// ========================================================================
    testWidgets('should transition between loading and normal states',
        (WidgetTester tester) async {
      // ARRANGE: Create stateful wrapper to change loading state
      bool isLoading = false;

      await tester.pumpWidget(
        makeTestableWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return CustomButton(
                text: 'Submit',
                onPressed: () {
                  setState(() {
                    isLoading = !isLoading;
                  });
                },
                isLoading: isLoading,
              );
            },
          ),
        ),
      );

      // ASSERT 1: Initially shows text, no spinner
      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // ACT 1: Tap button (triggers loading)
      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      // ASSERT 2: Now shows spinner, no text
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);

      // ACT 2: Tap again (back to normal) - should NOT work while loading
      // So we need to manually update state for this test
      await tester.pumpWidget(
        makeTestableWidget(
          CustomButton(
            text: 'Submit',
            onPressed: () {},
            isLoading: false,
          ),
        ),
      );

      // ASSERT 3: Back to showing text
      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}

/// ============================================================================
/// WHAT YOU LEARNED - Widget Testing Basics
/// ============================================================================
///
/// 1. WIDGET TESTER:
///    - pumpWidget() = Renders widget for testing
///    - pump() = Rebuilds widget after state change
///    - tap() = Simulates user tap
///
/// 2. FINDERS:
///    - find.text('Hello') = Finds widget with text "Hello"
///    - find.byType(CustomButton) = Finds widget by type
///    - find.byIcon(Icons.add) = Finds widget with icon
///
/// 3. MATCHERS:
///    - findsOneWidget = Expects exactly 1 widget found
///    - findsNothing = Expects 0 widgets found
///    - findsNWidgets(3) = Expects exactly 3 widgets found
///
/// 4. WRAPPING WIDGETS:
///    - Many widgets need MaterialApp parent
///    - Use helper function makeTestableWidget()
///    - Provides theme, navigation context, etc.
///
/// 5. TESTING CALLBACKS:
///    - Create bool variable to track if callback called
///    - Pass callback that sets variable to true
///    - After action, check if variable is true
///
/// 6. TESTING STATE CHANGES:
///    - Use StatefulBuilder for dynamic state
///    - Call pump() after state changes
///    - Verify UI updates correctly
///
/// ============================================================================
/// REAL WORLD EXAMPLE:
/// ============================================================================
///
/// Bug Report: "Submit button still clickable during loading!"
///
/// WITHOUT TESTS:
/// - Manually test by clicking during loading
/// - Hard to reproduce consistently
/// - Time-consuming
///
/// WITH TESTS:
/// - Run: flutter test test/presentation/widgets/custom_button_test.dart
/// - Test "should not call onPressed when loading" fails
/// - Found the bug instantly!
///
/// Widget tests = UI safety net! 🎨
/// ============================================================================
