part of '../main.dart';

class ExperienceSection extends StatelessWidget {
  final List<Experience> experiences;

  final String title;
  const ExperienceSection(this.experiences, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columnCount = (screenWidth / 300).floor();

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: experiences.length,
            itemBuilder: (context, index) {
              final project = experiences[index];
              return SizedBox(
                  child: Card(
                    elevation: 4.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100.0,
                          child: Image.asset(
                            project.companyLogo,
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            project.companyName,
                            style: const TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            project.designation,
                            style: const TextStyle(fontSize: 25.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            project.fromTo,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
