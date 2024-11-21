import 'package:flutter/material.dart'
    show
        Alignment,
        AnimatedDefaultTextStyle,
        AppBar,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Card,
        Center,
        Color,
        Colors,
        Column,
        Container,
        EdgeInsets,
        ElevatedButton,
        FontStyle,
        FontWeight,
        Icon,
        Icons,
        LinearGradient,
        MainAxisAlignment,
        MaterialPageRoute,
        Navigator,
        Offset,
        RoundedRectangleBorder,
        Scaffold,
        Shadow,
        SizedBox,
        StatelessWidget,
        Text,
        TextStyle,
        Widget;
import 'login_page.dart'; // Ensure this is correctly imported

class EntrancePage extends StatelessWidget {
  const EntrancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Swap It'),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1A237E)], // BMW dark blue
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo-like Icon with Shadow
              Icon(
                Icons.swap_horizontal_circle_rounded,
                size: 80,
                color: Colors.blueAccent.shade200, // BMW blue accent
                shadows: [
                  Shadow(
                    blurRadius: 15.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Animated Text with Shadow
              AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.4),
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 300),
                child: const Text('Welcome to the Swap It App'),
              ),
              const SizedBox(height: 8.0),

              // Slogan Text
              Text(
                'Swap, Share, and Shine!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),

              // Card for Button with Gradient and BMW-like Styling
              Card(
                color: Colors.transparent,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1565C0),
                        Color(0xFF42A5F5)
                      ], // BMW blue gradient
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent, // Transparent to show gradient
                      shadowColor: Colors.blueAccent.shade100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Swap Icon with Shadow at the Bottom
              Icon(
                Icons.sync_alt, // Swap-related symbol
                size: 50,
                color: Colors.grey.shade200,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.4),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
