import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class Schemes extends StatefulWidget {
  const Schemes({super.key});

  @override
  State<Schemes> createState() => _SchemesState();
}

class _SchemesState extends State<Schemes> {

  bool central = true;
  bool state = true;

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> schemesData = [
      {
        "NAME": "National mission for sustainable agriculture (Rain fed area development plan)",
        "Scheme": "Central",
        "Theme": "Providing livelihood resources to the farmers in rain fed areas by reduction of risks through integrated agriculture system.",
        "Eligibility": "Farmers should notify and enrolled their details of the crop in the nearby mandal agriculture center.",
        "Crops": "All crops are eligible",
        "Benefits": "Government will provide an amount of 1 lakh excluding cost of construction of ponds, repairs,shortage of polyhouses.",
        "Situation": "Farmers affecting in heavy rainfall in rain fed area can avail this scheme.",
        "Verification": "A team of agriculture management system with leading district agriculture officer.",
      },
      {
        "NAME": "National Mission for Substantial Agriculture (Swayel Health Card Scheme)",
        "SCHEME": "Central",
        "THEME": "Encourage Balaced and Integrated Fertilizer use in health card in 3 years",
        "ELIGIBILITY": "Soil pH level should be in fixed range at a particular region with nutrition management",
        "BENEFITS": "Government will provide farmers in establishing of soil testing laboratories and support harmless fertilizer with subsidy",
        "CROPS": "All crops", 
        "VERIFICATION": "A team of agriculture management system with leading district agriculture officer"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 200, 0, 0.8),
        title: Text('Government Schemes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SwitchListTile(
            value: central,
            onChanged: (value) {
              setState(() {
                central = value;
              });
            },
            title: Text("Central Government Schemes"),
            subtitle: Text("All Over India"),
            activeColor: Colors.green,
          ),
          SwitchListTile(
            value: state,
            onChanged: (value) {
              setState(() {
                state = value;
              });
            },
            title: Text("State Government Schemes"),
            subtitle: Text("Our State Government"),
            activeColor: Colors.green,
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: schemesData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> scheme = schemesData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SchemeDetails(scheme: scheme)));
                      },
                      title: Text(scheme['NAME'], style: TextStyle(fontWeight: FontWeight.bold),),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SchemeDetails extends StatefulWidget {
  final Map<String, dynamic> scheme;
  const SchemeDetails({super.key, required this.scheme});

  @override
  State<SchemeDetails> createState() => _SchemeDetailsState();
}

class _SchemeDetailsState extends State<SchemeDetails> {
  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> scheme = widget.scheme;
    List<String> keys = scheme.keys.toList();
    Locale currentLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 200, 0, 0.8),
        title: Text('${scheme['NAME']} Details'),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.orange),
        child: ListView.builder(
          itemCount: keys.length - 2,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue
                  ),
                  child: Text(keys[index + 2].toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FutureBuilder<String>(
                    future: translateText(scheme[keys[index + 2]], currentLocale.languageCode),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('');
                      } else if (snapshot.hasError) {
                        return Text(scheme[keys[index + 1]]);
                      } else {
                        return Text(snapshot.data ?? 'Translation failed');
                      }
                    },
                  ),
                ),
                SizedBox(height: 10,),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<String> translateText(String message, String translateTo) async {
  GoogleTranslator translator = GoogleTranslator();
  var translation = await translator.translate(message, to: translateTo);
  return translation.text;
}