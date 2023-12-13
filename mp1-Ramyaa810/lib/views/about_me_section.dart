part of '../main.dart';

class AboutMeSection extends StatelessWidget {
  final String name;
  final String jobTitle;
  final String bio;
  final String profilePic;

  const AboutMeSection(this.name, this.jobTitle, this.bio, this.profilePic,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final width = (screenWidth / 3);
    const commonTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 35,
      fontFamily: 'Mooli'
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                profilePic,
                width: 150,
                height: 150,
              ),
            ],
          ),
          SizedBox(
            width: width,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: commonTextStyle),
                Text(jobTitle, style: commonTextStyle),
                Text(bio, style: commonTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
