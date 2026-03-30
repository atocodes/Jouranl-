import 'package:flutter/material.dart';

class DeveloperProfileScreen extends StatelessWidget {
  const DeveloperProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.55, // HALF SCREEN
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Small grab handle
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              // Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/ico.jpg", width: 100),
                  const SizedBox(width: 30),
                  Image.asset("assets/imgs/atocodes.jpg", width: 100),
                ],
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                "Behind Journal+",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Scrollable Bio with bold keywords
              Expanded(
                child: SingleChildScrollView(
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: theme.colorScheme.onBackground,
                      ),
                      children: [
                        const TextSpan(
                          text: "I wanted to challenge myself with a ",
                        ),
                        TextSpan(
                          text: "two-day project",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              ", and this app had been on my mind for a long time. I decided to finally do it because I wanted to ",
                        ),
                        TextSpan(
                          text: "distract myself",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              " during a hard time. For the past two days, behind my keyboard, I've been actively pouring my ",
                        ),
                        TextSpan(
                          text: "energy",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              " into this project day and night, making sure I wasn’t thinking about anything else.\n\nIt was partially successful, but I’m still ",
                        ),
                        TextSpan(
                          text: "stuck in those thoughts",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              ". Anyway, at least this project helped me get through those days to some extent, and I’m ",
                        ),
                        TextSpan(
                          text: "grateful",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: " I managed to pull it off in just two days. I hope it ",
                        ),
                        TextSpan(
                          text: "helps you too",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: "."),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text("Ato Codes - Journal+"),
            ],
          ),
        ),
      ),
    );
  }
}