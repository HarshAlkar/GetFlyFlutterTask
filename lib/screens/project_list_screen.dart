import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dpr_provider.dart';
import '../widgets/project_card.dart';
import '../models/project.dart';
import 'dpr_form_screen.dart';
import 'login_screen.dart';

class ProjectListScreen extends StatelessWidget {
  static const routeName = '/projects';
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<DprProvider>().projects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              context.read<DprProvider>().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName,
                (route) => false,
              );
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 2 : 1,
                childAspectRatio: isWide ? 3.2 : 2.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: projects.length,
              itemBuilder: (context, i) {
                final Project p = projects[i];
                return ProjectCard(
                  project: p,
                  onTap: () => Navigator.of(context).pushNamed(
                    DprFormScreen.routeName,
                    arguments: p,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
