import 'package:amazonclone/repository/auth_repository.dart';
import 'package:amazonclone/utils/colors.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
            color: BlackColor,
          ),
          IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(Icons.logout),
            color: redColor,
          ),
        ],
      ),
      body: Center(child: Text(ref.watch(userProvider)!.uid)),
    );
  }
}
