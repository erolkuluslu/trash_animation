import 'dart:math'; // Importing the math library to use the 'pi' constant.

import 'package:flutter/material.dart'; // Importing Flutter's material library for UI components.

class CardHiddenAnimationPage extends StatefulWidget {
  const CardHiddenAnimationPage({Key? key}) : super(key: key); // Constructor

  @override
  State<CardHiddenAnimationPage> createState() =>
      CardHiddenAnimationPageState(); // Creating the state for the widget
}

class CardHiddenAnimationPageState extends State<CardHiddenAnimationPage>
    with TickerProviderStateMixin {
  final cardSize = 150.0; // Setting a fixed size for the card.

  // Defining a Tween for the hole size animation.
  late final holeSizeTween = Tween<double>(
    begin: 0, // Starting size of the hole.
    end: 1.5 * cardSize, // Ending size of the hole (1.5 times the card size).
  );

  // Defining an AnimationController for the hole size animation.
  late final holeAnimationController = AnimationController(
    vsync: this, // Provides a TickerProvider for the controller.
    duration: const Duration(milliseconds: 300), // Duration of the animation.
  );

  // Getter to get the current value of the hole size animation.
  double get holeSize => holeSizeTween.evaluate(holeAnimationController);

  // Defining an AnimationController for the card offset animation.
  late final cardOffsetAnimationController = AnimationController(
    vsync: this, // Provides a TickerProvider for the controller.
    duration: const Duration(milliseconds: 1000), // Duration of the animation.
  );

  // Defining a Tween for the card offset animation with a CurveTween for easing.
  late final cardOffsetTween = Tween<double>(
    begin: 0, // Starting offset.
    end: 2 * cardSize, // Ending offset (2 times the card size).
  ).chain(CurveTween(curve: Curves.easeInBack)); // Adding easing.

  // Defining a Tween for the card rotation animation with a CurveTween for easing.
  late final cardRotationTween = Tween<double>(
    begin: 0, // Starting rotation.
    end: 0.5, // Ending rotation (half a turn).
  ).chain(CurveTween(curve: Curves.easeInBack)); // Adding easing.

  // Defining a Tween for the card elevation animation.
  late final cardElevationTween = Tween<double>(
    begin: 2, // Starting elevation.
    end: 20, // Ending elevation.
  );

  // Getter to get the current value of the card offset animation.
  double get cardOffset =>
      cardOffsetTween.evaluate(cardOffsetAnimationController);

  // Getter to get the current value of the card rotation animation.
  double get cardRotation =>
      cardRotationTween.evaluate(cardOffsetAnimationController);

  // Getter to get the current value of the card elevation animation.
  double get cardElevation =>
      cardElevationTween.evaluate(cardOffsetAnimationController);

  @override
  void initState() {
    // Adding listeners to the animation controllers to update the state.
    holeAnimationController.addListener(() => setState(() {}));
    cardOffsetAnimationController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    // Disposing the animation controllers when the widget is removed from the widget tree.
    holeAnimationController.dispose();
    cardOffsetAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Adding floating action buttons for triggering animations.
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () async {
              // Triggering the hole animation and then the card offset animation.
              holeAnimationController.forward();
              await cardOffsetAnimationController.forward();
              // Reversing the hole animation after a delay.
              Future.delayed(const Duration(milliseconds: 200),
                  () => holeAnimationController.reverse());
            },
            child: const Icon(Icons.remove), // Minus icon.
          ),
          const SizedBox(width: 20), // Spacing between buttons.
          FloatingActionButton(
            onPressed: () {
              // Reversing both animations.
              cardOffsetAnimationController.reverse();
              holeAnimationController.reverse();
            },
            child: const Icon(Icons.add), // Plus icon.
          ),
        ],
      ),
      // Centering the animated content.
      body: Center(
        child: SizedBox(
          height: cardSize * 1.25, // Setting the height of the container.
          width: double.infinity, // Setting the width to fill the parent.
          child: ClipPath(
            clipper: BlackHoleClipper(), // Applying the custom clipper.
            child: Stack(
              alignment: Alignment
                  .bottomCenter, // Aligning children to the bottom center.
              clipBehavior: Clip.none, // Allowing overflow.
              children: [
                // Displaying the hole image.
                SizedBox(
                  width: holeSize, // Setting the size of the hole.
                  child: Image.asset(
                    'images/hole.png', // Path to the hole image.
                    fit: BoxFit.fill, // Filling the container.
                  ),
                ),
                // Positioning the card with animations.
                Positioned(
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(
                          0, cardOffset), // Applying the offset animation.
                      child: Transform.rotate(
                        angle: cardRotation, // Applying the rotation animation.
                        child: Padding(
                          padding:
                              const EdgeInsets.all(20.0), // Adding padding.
                          child: HelloWorldCard(
                            size: cardSize, // Passing the card size.
                            elevation:
                                cardElevation, // Passing the elevation animation value.
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BlackHoleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height / 2); // Moving to the middle of the height.
    path.arcTo(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2), // Centering the arc.
        width: size.width, // Width of the arc.
        height: size.height, // Height of the arc.
      ),
      0,
      pi, // Drawing a half-circle (pi radians).
      true,
    );
    // Using -1000 guarantees the card won't be clipped at the top, regardless of its height.
    path.lineTo(0, -1000); // Drawing a line to the top left outside the bounds.
    path.lineTo(size.width,
        -1000); // Drawing a line to the top right outside the bounds.
    path.close(); // Closing the path.
    return path;
  }

  @override
  bool shouldReclip(BlackHoleClipper oldClipper) =>
      false; // No need to reclip on changes.
}

class HelloWorldCard extends StatelessWidget {
  const HelloWorldCard({
    Key? key,
    required this.size, // Card size.
    required this.elevation, // Card elevation.
  }) : super(key: key);

  final double size; // Card size property.
  final double elevation; // Card elevation property.

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation, // Applying elevation to the card.
      borderRadius: BorderRadius.circular(10), // Setting rounded corners.
      child: SizedBox.square(
        dimension: size, // Setting the card size.
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // Setting rounded corners.
            color: Colors.blue, // Background color.
          ),
          child: const Center(
            child: Text(
              'Hello\nWorld', // Card text.
              textAlign: TextAlign.center, // Center aligning the text.
              style:
                  TextStyle(color: Colors.white, fontSize: 18), // Text style.
            ),
          ),
        ),
      ),
    );
  }
}
