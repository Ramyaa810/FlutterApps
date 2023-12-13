part of '../main.dart';

class VolunteerSection extends StatelessWidget {
  final List<Volunteer> volunteers;

  final String title;
  const VolunteerSection(this.volunteers, this.title, {super.key});
  static const commonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
  );
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: textStyle,
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: volunteers.length,
            itemBuilder: (BuildContext context, int index) {
              final data = volunteers[index];
              return Container(
                  padding: const EdgeInsets.all(16),
          height: 100,
                //  width: 300,
                  //height: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              data.companyLogo,
                              width: 50,
                              height: 40,
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
                            Text(data.companyName, style: commonTextStyle),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(data.designation.toString(),
                                style: commonTextStyle),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(data.fromTo, style: commonTextStyle),
                        ],
                      ),
                    ],
                  ));
            }),
      ],
    );
  }
}
