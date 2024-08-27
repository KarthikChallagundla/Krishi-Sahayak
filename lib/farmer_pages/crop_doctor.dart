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
      print(wordSpoken.text);
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
    List<Map<String, dynamic>> doctorsData = [
      {
        'name': 'Mohanji',
        'spec': 'Humanitarian',
        'imgUrl': 'https://media.licdn.com/dms/image/v2/C4D03AQEtNUrR5KVwww/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1607404908045?e=2147483647&v=beta&t=VrV3HMhg_QSwfTVYSD7P7cP4eFg9VxgvYK6EI6tPGLQ',
      },
      {
        'name': 'Dr. Sailesh Rao',
        'spec': 'Climate Healers and Producer',
        'imgUrl': 'https://www.hua.edu/wp-content/uploads/2020/10/Dr.S.Rao_-e1611335977452.jpg',
      },
      {
        'name': 'Dr. Shireen Kassam',
        'spec': 'Haematologist and Founder',
        'imgUrl': 'https://www.vegansociety.com/sites/default/files/shireen.jpg',
      },
      {
        'name': 'Dr. Nandita Shah',
        'spec': 'Founder and Director, SHARAN India',
        'imgUrl': 'https://sharan-india.org/wp-content/uploads/drnandita83bt2-e1648803196533.jpg',
      },
      {
        'name': 'Gowri Shankar',
        'spec': 'Founder and CEO, Faborg',
        'imgUrl': '',
      },
      {
        'name': 'Dr. Rupa Shah',
        'spec': 'MBBS, Lifestyle Medicine Expert',
        'imgUrl': 'https://scontent.fhyd11-3.fna.fbcdn.net/v/t39.30808-1/292311378_466739732121955_5396999152597341672_n.jpg?stp=dst-jpg_p200x200&_nc_cat=109&ccb=1-7&_nc_sid=f4b9fd&_nc_ohc=-pM160LF-soQ7kNvgGdYM3a&_nc_ht=scontent.fhyd11-3.fna&oh=00_AYBhoVX__7pUdMcHDIlPCmjkeuoiXHIUn6XnTdQBWWzPOA&oe=66C102BD',
      },
      {
        'name': 'Dr. Manilal Valliyate',
        'spec': 'CEO, PETA India',
        'imgUrl': 'https://awbi.gov.in/uploads/boardmember/170367414081Dr%20Manilal%20Valliyate.jpg',
      },
    ];

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
            Expanded(
              child: ListView.builder(
                itemCount: doctorsData.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(10.0),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: (doctorsData[index]['imgUrl'].toString().isNotEmpty)
                                ? NetworkImage(doctorsData[index]['imgUrl'])
                                : null,
                            child: (doctorsData[index]['imgUrl'].toString().isEmpty)
                                ? Text('No Image', style: TextStyle(fontSize: 12))
                                : null,
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctorsData[index]['name'],
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  doctorsData[index]['spec'],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10,),
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
