import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CropDoctor extends StatefulWidget {
  const CropDoctor({super.key});

  @override
  State<CropDoctor> createState() => _CropDoctorState();
}

class _CropDoctorState extends State<CropDoctor> {
  final SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  bool isListening = false;
  TextEditingController wordSpoken = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  void onSpeechResult(result) {
    setState(() {
      wordSpoken.text = result.recognizedWords;
    });
  }

  void startListening() async {
    if (speechEnabled && !isListening) {
      await speechToText.listen(
        onResult: onSpeechResult,
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.dictation,
        )
      );
      setState(() {
        isListening = true;
      });
    }
  }

  void stopListening() async {
    if (isListening) {
      await speechToText.stop();
      setState(() {
        isListening = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 200, 0, 0.8),
        title: Text('Crop Doctor'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: Container()),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: wordSpoken,
                      style: TextStyle(fontSize: 16),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Enter your problem',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        suffixIcon: IconButton(
                          onPressed: isListening ? stopListening : startListening,
                          icon: isListening ? Icon(Icons.mic_off) : Icon(Icons.mic),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(shape: CircleBorder()),
                  child: Icon(Icons.arrow_upward),
                ),
              ],
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
