part of '../main.dart';

class SkillsetSection extends StatelessWidget {
  final List<Skills> skills;

  final String title;
  const SkillsetSection(this.skills, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columnCount = (screenWidth / 300).floor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  columnCount, // Set the number of columns in the grid
            ),
            itemCount: skills.length, // Number of grid items
            itemBuilder: (context, index) {
              final data = skills[index];
              return Card(
                elevation: 4.0,
                margin: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      BulletPointsList(
                          skills:
                              data.skill), // Custom widget for bullet points
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class BulletPointsList extends StatelessWidget {
  final List<String> skills;

  const BulletPointsList({super.key, required this.skills});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: skills.map((point) {
        return BulletPointItem(text: point);
      }).toList(),
    );
  }
}

class BulletPointItem extends StatelessWidget {
  final String text;

  const BulletPointItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•', style: TextStyle(fontSize: 16.0)),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
