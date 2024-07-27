import 'package:excuse_generator/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Translate extends StatefulWidget {
  const Translate({super.key});
  @override
  State<Translate> createState() => _TranslateState();
}

class _TranslateState extends State<Translate> {
  // final String apiKey = dotenv.env['API_KEY'] ?? '';
  //  late final GenerativeModel _model;
  // late final ChatSession _chatSession;
  bool isResultVisible = false;
  TextEditingController textEditingController = TextEditingController();
  String generatedResult = '';
  @override
  // void initState() {
  //   super.initState();
  //   _model = GenerativeModel(
  //     model: "gemini-pro",
  //     apiKey: const String.fromEnvironment('api_key'),
  //   );
  //   _chatSession = _model.startChat();
  // }
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> generateExcuse(String input) async {
    try {
      // if (apiKey.isEmpty) {
      //   print('No \$API_KEY environment variable');
      // }
      // The Gemini 1.5 models are versatile and work with both text-only and multimodal prompts
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyByl2f_YmX-d0styqSY5n_JQJ8vqWJAMsk',
      );
      final content = [
        Content.text(
            'Generate a precise and reasonable excuse for the text in less than 15 words: {$input}')
      ];
      final response = await model.generateContent(content);
      print(response.text);
      setState(() {
        generatedResult = response.text ?? 'No response received';
        isResultVisible = true;
      });
    } catch (e) {
      setState(() {
        generatedResult = 'Error generating excuse: $e';
        isResultVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void removeFocus() {
      FocusScope.of(context).unfocus();
    }

    void showResult() {
      generateExcuse(textEditingController.text);

      removeFocus();
    }

    void clearResult() {
      setState(() {
        isResultVisible = false;
        generatedResult = '';
        textEditingController.clear();
        removeFocus();
      });
    }

    return GestureDetector(
      onTap: removeFocus,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'AI Excuse Generator',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          fillColor: Theme.of(context).colorScheme.secondary,
                          filled: true,
                          label: const Text(
                            'Input your need for an Excuse \n (e.g. I came late to work)',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Montserrat',
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      //Powered by Gemini
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            "svg/google-gemini-icon.svg",
                            height: 20,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Powered by Gemini',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: MyButton(
                          icon: const Icon(
                            Icons.get_app,
                            size: 16,
                            color: Colors.white,
                          ),
                          onTap: showResult,
                          buttonName: 'Generate',
                          buttonColor:
                              Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: MyButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 16,
                            color: Colors.white,
                          ),
                          onTap: clearResult,
                          buttonName: 'Clear Result',
                          buttonColor: Colors.red.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // const Text(
                //   'Generated Excuse:',
                //   style: TextStyle(
                //     fontFamily: 'Montserrat',
                //     fontSize: 16,
                //   ),
                // ),
                // const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                    height: 50.0, // Space above and below the divider
                  ),
                ),
                // Result box
                Visibility(
                  visible: isResultVisible,
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Column(
                            children: [
                              Text(
                                // 'Text generated',
                                generatedResult,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
