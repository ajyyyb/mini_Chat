import 'package:chat_jasoo/services/auth/auth_servise.dart';
import 'package:chat_jasoo/components/my_button.dart';
import 'package:chat_jasoo/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Scale animation (for the text to grow and shrink)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Color animation (for the text to change color)
    _colorAnimation = ColorTween(begin: Colors.black, end: Colors.blue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Slide animation (for slight horizontal movement)
    _offsetAnimation = Tween<Offset>(begin: Offset(-0.5, 0), end: Offset(0.5, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Fade animation (for fields and text)
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Login method
  void login(BuildContext context) async {
    final authServise = AuthServise();

    try {
      await authServise.signInWithEmailPassword(_emailController.text, _pwController.text);
    } catch (e) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flash Chat text with combined animations (scale, color, and movement)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: SlideTransition(
                    position: _offsetAnimation,
                    child: Text(
                      "⚡️Flash Chat",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _colorAnimation.value,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
            
            // Welcome back message with fade animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                "Siz kaira keldiniz , sizdi sagyndyk !",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 25),
            
            // Email textfield with fade animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: MyTextfield(
                hintText: "Email",
                obscureText: false,
                controller: _emailController,
              ),
            ),
            const SizedBox(height: 10),

            // Password textfield with fade animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: MyTextfield(
                hintText: "Password",
                obscureText: true,
                controller: _pwController,
              ),
            ),
            const SizedBox(height: 25),

            // Login button with fade animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: MyButton(
                text: "Login",
                onTap: () => login(context),
              ),
            ),
            const SizedBox(height: 25),

            // Register now with fade animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Siz kattalgansyzby? ",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Janny kataluu",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
