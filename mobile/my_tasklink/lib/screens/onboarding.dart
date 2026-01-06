import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_tasklink/screens/home.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  // 🎨 Couleurs MyTaskLink
  static const Color bluePrimary = Color(0xFF2E5BFF);
  static const Color greenAccent = Color(0xFF00D285);
  static const Color textDark = Color(0xFF0A1931);
  static const Color background = Color(0xFFF4F7FA);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: background,

      pages: [
        PageViewModel(
          title: "Prenez des notes facilement",
          body:
              "Gardez toutes vos idées, mémos et informations importantes au même endroit.",
          image: _iconContainer(Icons.note_outlined),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: "Gérez vos tâches",
          body:
              "Organisez votre quotidien et validez vos tâches en toute simplicité.",
          image: _iconContainer(Icons.check_circle_outline),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: "Retrouvez vos contacts",
          body:
              "Accédez rapidement à vos contacts essentiels, même hors connexion.",
          image: _iconContainer(Icons.contacts_outlined),
          decoration: _pageDecoration(),
        ),
      ],

      showSkipButton: true,
      skip: _textButton("Passer"),
      next: const Icon(Icons.arrow_forward),
      done: _textButton("Commencer"),

      dotsDecorator: DotsDecorator(
        size: const Size(8, 8),
        activeSize: const Size(22, 8),
        activeColor: bluePrimary,
        color: bluePrimary.withOpacity(0.3),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),

      onDone: () {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => const Home(),
    ),
  );
},

    );
  }

  // 🧩 Style commun des pages
  PageDecoration _pageDecoration() {
    return PageDecoration(
      titleTextStyle: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: textDark,
      ),
      bodyTextStyle: GoogleFonts.inter(
        fontSize: 15,
        color: textDark.withOpacity(0.7),
      ),
      contentMargin: const EdgeInsets.symmetric(horizontal: 24),
      imagePadding: const EdgeInsets.only(top: 60),
    );
  }

  // 🔵 Icône centrale arrondie
  Widget _iconContainer(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bluePrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        icon,
        size: 100,
        color: bluePrimary,
      ),
    );
  }

  // ✍️ Boutons texte
  Widget _textButton(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        color: bluePrimary,
      ),
    );
  }
}
