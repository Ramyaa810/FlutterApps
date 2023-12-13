import 'package:flutter/material.dart';
import 'data_model/Education.dart';
import 'data_model/Experience.dart';
import 'data_model/Volunteer.dart';
import 'data_model/skills_info.dart';
import 'data_model/user_profile.dart';

part 'views/bio_section.dart';
part 'views/about_me_section.dart';
part 'views/education_section.dart';
part 'views/skillset_section.dart';
part 'views/experience_section.dart';
part 'views/volunteer_section.dart';

void main() {
  runApp(const MP1());
}

class MP1 extends StatelessWidget {
  const MP1({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = UserProfile(
        name: "Ramya Krishnan",
        jobTitle: "Software Developer",
        bio: "XYZ Company",
        profilePic: "./assets/images/profile.png",
        subBio:
            "As a seasoned technology professional with over 10 years of experience, I have demonstrated my dedication to delivering top-quality software solutions. I am currently pursuing a Master’s degree in Computer Science at the Illinois Institute of Technology, where I aim to broaden my knowledge and skills in software development.",
        skills: [
          Skills(
              title: "Programming Languages",
              skill: ["C#", "Vb.Net", "C/C++", "Python"]),
          Skills(
              title: "Backend Technologies",
              skill: ["MS SQL", "Kafka", "Mongo DB", "Spark", "Hive", "Flask"]),
          Skills(
              title: "Web Development",
              skill: ["ASP.Net", "ADO.Net", "WCF", "WPF", "Web API"]),
          Skills(title: "Testing Tools", skill: ["SOAP UI", "Postman"]),
        ],
        experiences: [
          Experience(
              companyLogo: './assets/images/stateofmissori.png',
              companyName: "XYZ Company",
              designation: ".Net Team Lead",
              fromTo: "June 2023 - Till Date"),
          Experience(
              companyLogo: './assets/images/accenture.png',
              companyName: "Accenture",
              designation: "Associate Manager",
              fromTo: "July 2019 - Aug 2022"),
          Experience(
              companyLogo: './assets/images/infrasoft.png',
              companyName: "Infrasoft Tech",
              designation: "Senior Associate",
              fromTo: "Aug 2017 - July 2019"),
          Experience(
              companyLogo: './assets/images/cognizant.png',
              companyName: "Cognizant",
              designation: "Associate",
              fromTo: "July 2019 - Aug 2022"),
          Experience(
              companyLogo: './assets/images/infosys.png',
              companyName: "Infosys Ltd",
              designation: "Technology Analyst",
              fromTo: "June 2023 - Till Date"),
          Experience(
              companyLogo: './assets/images/congruent.png',
              companyName: "Congruent",
              designation: "Software Engineer",
              fromTo: "Aug 2012 - Oct 2015"),
        ],
        volunteers: [
          Volunteer(
              companyLogo: './assets/images/tedX.png',
              companyName: "TEDxChicago",
              designation: "Attendee Experience",
              fromTo: "Mar 2023 - Till Date"),
          Volunteer(
              companyLogo: './assets/images/mad.png',
              companyName: "Make A Difference",
              designation: "Mentor",
              fromTo: "Aug 2018 - Apr 2021"),
          Volunteer(
              companyLogo: './assets/images/aware.png',
              companyName: "Aware India",
              designation: "Volunteer",
              fromTo: "Mar 2019 - Aug 2020"),
        ],
        educations: [
          Education(
              logo: './assets/images/iit.png',
              institute: "Illinois Institute Of Technology",
              gpa: "3.8 GPA"),
          Education(
              logo: './assets/images/kncet.png',
              institute: "Kongu Collge Of Enginnering And Technology",
              gpa: "3.2 GPA"),
        ],
        titles: [
          'Know Me',
          'Education',
          'Skill Set',
          'Experience',
          'Volunteering'
        ]);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            userProfile.name,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF08d665),
              fontFamily: 'Lobster'
            ),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              './assets/images/background.png',
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black87.withOpacity(0.7),
            ),
            ListView(
              scrollDirection: Axis.vertical,
              children: [
                AboutMeSection(
                  userProfile.name,
                  userProfile.jobTitle,
                  userProfile.bio,
                  userProfile.profilePic,
                ),
                BioSection(userProfile.subBio, userProfile.titles[0]),
                EducationSection(userProfile.educations, userProfile.titles[1]),
                SizedBox(
                  height: 300,
                  child: SkillsetSection(
                      userProfile.skills, userProfile.titles[2]),
                ),
                ExperienceSection(
                    userProfile.experiences, userProfile.titles[3]),
                VolunteerSection(userProfile.volunteers, userProfile.titles[4]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
