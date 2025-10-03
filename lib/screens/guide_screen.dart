// lib/screens/guide_screen.dart
import 'package:flutter/material.dart';
import 'package:farmiq_app/utils/constants.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Farming Journey', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          children: [
            const Text(
              'Getting Started with FarmIQ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 24),
            GuideTimelineStep(
              imagePath: 'assets/images/calculator.png',
              stepNumber: '1',
              title: 'Learn & Plan Smarter',
              description:
              "Use our tools to make informed decisions. Get instant answers from Farmy, explore disease guides, and use the Crop Calculator to plan your season.",
              button1Text: 'Ask Farmy',
              button2Text: 'Open Calculator',
              isFirst: true,
            ),
            GuideTimelineStep(
              imagePath: 'assets/images/community.png',
              stepNumber: '2',
              title: 'Connect & Collaborate',
              description:
              "You're not alone. Join our Community Chat to connect with fellow farmers, share experiences, and ask for advice.",
              button1Text: 'Join the Conversation',
            ),
            GuideTimelineStep(
              imagePath: 'assets/images/vegetables.png',
              stepNumber: '3',
              title: 'Buy & Sell Directly',
              description:
              "Take control of your finances. Purchase quality supplies from our Store and list your harvest on our marketplace to reach more buyers.",
              button1Text: 'Visit the Store',
              button2Text: 'Sell Your Products',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

class GuideTimelineStep extends StatelessWidget {
  final String imagePath;
  final String stepNumber;
  final String title;
  final String description;
  final String button1Text;
  final String? button2Text;
  final bool isFirst;
  final bool isLast;

  const GuideTimelineStep({
    super.key,
    required this.imagePath,
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.button1Text,
    this.button2Text,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The Timeline Column (Line and Circle)
          SizedBox(
            width: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Top line (invisible for the first item)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst ? Colors.transparent : Colors.grey.shade300,
                  ),
                ),
                // The circle with the step number
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      stepNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                // Bottom line (invisible for the last item)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // The Content Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: Card(
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // Center the content
                        children: [
                          Image.asset(
                            imagePath,
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center, // Center the buttons
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                child: Text(button1Text, style: const TextStyle(color: Colors.white)),
                              ),
                              if (button2Text != null)
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  child: Text(button2Text!, style: const TextStyle(color: Colors.white)),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}