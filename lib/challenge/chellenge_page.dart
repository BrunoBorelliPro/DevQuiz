import 'package:dev_quiz/challenge/challenge_controller.dart';
import 'package:dev_quiz/challenge/widgets/next_button_widget/next_button_widget.dart';
import 'package:dev_quiz/challenge/widgets/question_indicator_widget/question_indicator_widget.dart';
import 'package:dev_quiz/challenge/widgets/quiz_widget/quiz_widget.dart';
import 'package:dev_quiz/shared/models/question_model.dart';
import 'package:flutter/material.dart';

class ChallengePage extends StatefulWidget {
  final List<QuestionModel> questions;

  const ChallengePage({Key? key, required this.questions}) : super(key: key);
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final challengeController = ChallengeController();
  final pageController = PageController();

  @override
  void initState() {
    challengeController.currentPageNotifier.addListener(() {
      setState(() {});
    });
    pageController.addListener(() {
      challengeController.currentPage = pageController.page!.toInt() + 1;
    });
    super.initState();
  }

  void nextPage() {
    if (challengeController.currentPage < widget.questions.length)
      pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<int>(
                valueListenable: challengeController.currentPageNotifier,
                builder: (context, value, _) => QuestionIndicatorWidget(
                  currentPage: value,
                  length: widget.questions.length,
                ),
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: widget.questions
            .map((e) => QuizWidget(
                  question: e,
                  onChange: nextPage,
                ))
            .toList(),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ValueListenableBuilder<int>(
                valueListenable: challengeController.currentPageNotifier,
                builder: (context, value, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (widget.questions.length > value)
                          Expanded(
                              child: NextButtonWidget.white(
                            label: "Pular",
                            onTap: nextPage,
                          )),
                        if (widget.questions.length == value)
                          Expanded(
                              child: NextButtonWidget.darkGreen(
                            label: "Confirmar",
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )),
                      ],
                    ))),
      ),
    );
  }
}
