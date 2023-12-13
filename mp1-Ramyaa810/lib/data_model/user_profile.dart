import 'package:cs442_mp1/data_model/Education.dart';
import 'package:cs442_mp1/data_model/Volunteer.dart';

import 'skills_info.dart';
import 'Experience.dart';

class UserProfile {
  final String name;
  final String jobTitle;
  final String bio;
  final String profilePic;
  final String subBio;  
  final List<Skills> skills;
  final List<Experience> experiences;
  final List<Volunteer> volunteers;
  final List<Education> educations;
  final List<String> titles;

  UserProfile(
      {required this.name,
      required this.jobTitle,
      required this.bio,
      required this.profilePic,
      required this.subBio,
      required this.skills,
      required this.experiences,
      required this.volunteers,
      required this.educations,
      required this.titles});
}
