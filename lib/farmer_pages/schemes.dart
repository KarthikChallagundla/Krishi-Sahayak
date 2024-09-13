import 'package:demo_mvp/database/scheme_data.dart';
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

    List<Map<String, dynamic>> schemesData = schemeData;

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
                return !((central && scheme['Type'] == 'Central') || (state && scheme['Type'] == 'State')) ? Container() : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SchemeDetails(scheme: scheme)));
                      },
                      title: Text(scheme['Name'], style: TextStyle(fontWeight: FontWeight.bold),),
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
        title: Text('${scheme['Shortcut']} Details'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: keys.length - 3,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue
                  ),
                  child: Text(keys[index + 3].toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FutureBuilder<String>(
                    future: translateText(scheme[keys[index + 3]], currentLocale.languageCode),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(),);
                      } else if (snapshot.hasError) {
                        return Text(scheme[keys[index + 3]]);
                      } else {
                        return Text(snapshot.data ?? scheme[keys[index + 3]]);
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