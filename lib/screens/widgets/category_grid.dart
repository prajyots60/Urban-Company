import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 4,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  index == 0
                      ? Icons.spa
                      : index == 1
                          ? Icons.content_cut
                          : index == 2
                              ? Icons.ac_unit
                              : Icons.cleaning_services,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  index == 0
                      ? 'Women\'s Salon'
                      : index == 1
                          ? 'Men\'s Salon'
                          : index == 2
                              ? 'AC Repair'
                              : 'Cleaning',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
