import 'package:evently/onboarding/onboarding_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static List<OnboardingModel> onboardingList = List.generate(
    3,
    (index) => getItem(index),
  );

  static List<String> images = ['1', '2', '3'];

  static List<String> titles = [
    'Find Events That Inspire You',
    'Effortless Event Planning',
    'Connect with Friends & Share Moments',
  ];

  static List<String> desc = [
    "Dive into a world of events crafted to fit your unique interests. Whether you're into live music, art workshops, professional networking, or simply discovering new experiences, we have something for everyone. Our curated recommendations will help you explore, connect, and make the most of every opportunity around you.",
    "Take the hassle out of organizing events with our all-in-one planning tools. From setting up invites and managing RSVPs to scheduling reminders and coordinating details, we’ve got you covered. Plan with ease and focus on what matters – creating an unforgettable experience for you and your guests.",
    "Make every event memorable by sharing the experience with others. Our platform lets you invite friends, keep everyone in the loop, and celebrate moments together. Capture and share the excitement with your network, so you can relive the highlights and cherish the memories.",
  ];

  static OnboardingModel getItem(int index) {
    return OnboardingModel(
      imgName: images[index],
      title: titles[index],
      description: desc[index],
    );
  }

  static void onboardingComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboarding_complete', true);
  }
}
