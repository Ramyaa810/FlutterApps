part of '../main.dart';

class BioSection extends StatelessWidget {
  //final UserProfile userProfile;
  final String subBio;
  final String title;

  const BioSection(this.subBio, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    // final textStyle = TitleDesign();
    return Container(
      padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleDesign(),
          ),
          const SizedBox(
            height: 10,
            width: double.infinity
          ),
          Text(subBio,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontStyle: FontStyle.italic)),
        ],
      ),
        )
    );
  }


  TextStyle titleDesign() {
    return const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          );
  }
}
