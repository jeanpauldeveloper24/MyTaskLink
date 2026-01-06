import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  // 🎨 Couleurs MyTaskLink
  static const Color bluePrimary = Color(0xFF2E5BFF);
  static const Color greenAccent = Color(0xFF00D285);
  static const Color textDark = Color(0xFF0A1931);
  static const Color background = Color(0xFFF4F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        iconTheme: const IconThemeData(color: textDark),
        title: Text(
          'MyTaskLink',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: textDark,
          ),
        ),
        centerTitle: true,
      ),

      // 👉 Le Drawer sera branché ici plus tard
      drawer: const Drawer(), // placeholder volontaire

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Titre principal
            Text(
              'Bienvenue 👋',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'MyTaskLink vous aide à organiser vos notes, tâches et contacts en toute simplicité.',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: textDark.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 32),

            // 📊 Aperçu des fonctionnalités
            _infoTile(
              icon: Icons.note_outlined,
              title: 'Notes',
              description: 'Centralisez toutes vos idées importantes',
              color: bluePrimary,
            ),

            const SizedBox(height: 16),

            _infoTile(
              icon: Icons.check_circle_outline,
              title: 'Tâches',
              description: 'Planifiez et suivez vos actions quotidiennes',
              color: greenAccent,
            ),

            const SizedBox(height: 16),

            _infoTile(
              icon: Icons.contacts_outlined,
              title: 'Contacts',
              description: 'Gardez vos contacts accessibles hors ligne',
              color: bluePrimary,
            ),

            const Spacer(),

            // ☰ Indication Drawer
            Center(
              child: Text(
                '☰ Utilisez le menu pour naviguer',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: textDark.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧩 Ligne d’information
  Widget _infoTile({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 28,
            color: color,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: textDark.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}