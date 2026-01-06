import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  // 🎨 Couleurs MyTaskLink
  static const Color bluePrimary = Color(0xFF2E5BFF);
  static const Color greenAccent = Color(0xFF00D285);
  static const Color textDark = Color(0xFF0A1931);
  static const Color background = Color(0xFFF4F7FA);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _drawerHeader(),

          _simpleItem(
            context,
            icon: Icons.home_outlined,
            title: 'Accueil',
            onTap: () => Navigator.pop(context),
          ),

          _expandableSection(
            icon: Icons.note_outlined,
            title: 'Notes',
            children: [
              _subItem(context, 'Ajouter une note', Icons.add),
              _subItem(context, 'Liste des notes', Icons.list_alt_outlined),
            ],
          ),

          _expandableSection(
            icon: Icons.check_circle_outline,
            title: 'Tâches',
            children: [
              _subItem(context, 'Nouvelle tâche', Icons.add_task_outlined),
              _subItem(
                context,
                'Liste des tâches',
                Icons.playlist_add_check_outlined,
              ),
            ],
          ),

          _expandableSection(
            icon: Icons.contacts_outlined,
            title: 'Contacts',
            children: [
              _subItem(context, 'Ajouter un contact', Icons.person_add_alt_outlined),
              _subItem(context, 'Liste des contacts', Icons.list_alt_outlined),
            ],
          ),

          const Divider(),

          _simpleItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Paramètres',
            onTap: () {},
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // 🔗 Header avec logo
  Widget _drawerHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
      color: bluePrimary.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ Logo
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              'images/logo.png',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'MyTaskLink',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Notes • Tâches • Contacts',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: textDark.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  // 📁 Section déroulante
  Widget _expandableSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: textDark),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
      ),
      childrenPadding: const EdgeInsets.only(left: 16),
      children: children,
    );
  }

  // 📄 Sous-menu
  Widget _subItem(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        size: 18,
        color: textDark.withOpacity(0.7),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: textDark.withOpacity(0.7),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  // 📌 Item simple
  Widget _simpleItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textDark),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
      ),
      onTap: onTap,
    );
  }
}