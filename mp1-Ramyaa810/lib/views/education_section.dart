part of '../main.dart';

class EducationSection extends StatelessWidget {
  final List<Education> educations;
  final String title;
  const EducationSection(this.educations, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
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
        SizedBox(
          height: 200.0,
          child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: educations.length,
              itemBuilder: (BuildContext context, int index) {
                final data = educations[index];
                return Container(
                    width: 300,
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                data.logo,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(data.institute,
                                  style: const TextStyle(
                                      fontSize: 18.0, color: Colors.white)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(data.gpa.toString(),
                                  style: const TextStyle(
                                      fontSize: 18.0, color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ));
              }),
        ),
      ],
    );
  }
}
