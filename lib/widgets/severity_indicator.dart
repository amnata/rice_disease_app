import 'package:flutter/material.dart';

class SeverityIndicator extends StatelessWidget {
  final int level;
  
  const SeverityIndicator({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      const Color(0xFF4CAF50),  // Vert - Sain
      const Color(0xFF8BC34A),  // Vert clair - Léger
      const Color(0xFFFFC107),  // Jaune - Modéré
      const Color(0xFFFF9800),  // Orange - Sévère
      const Color(0xFFF44336),  // Rouge - Très sévère
    ];
    
    final List<String> labels = [
      "Sain",
      "< 5%",
      "5-15%",
      "15-30%",
      "> 30%",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Niveau de sévérité EPPO",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 12,
                decoration: BoxDecoration(
                  color: index <= level ? colors[index] : Colors.grey[300],
                  borderRadius: BorderRadius.horizontal(
                    left: index == 0 ? Radius.circular(6) : Radius.zero,
                    right: index == 4 ? Radius.circular(6) : Radius.zero,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels.map((label) {
            return Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
