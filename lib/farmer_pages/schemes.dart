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
        backgroundColor: Colors.green.shade600,
        title: Text(
          'Government Schemes',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Section with a gradient background
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade600, Colors.green.shade400],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.account_balance, size: 40, color: Colors.white),
                    Text('Central Schemes',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Switch(
                      value: central,
                      onChanged: (value) {
                        setState(() {
                          central = value;
                        });
                      },
                      activeColor: Colors.white,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.location_city, size: 40, color: Colors.white),
                    Text(
                      'State Schemes',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)
                    ),
                    Switch(
                      value: state,
                      onChanged: (value) {
                        setState(() {
                          state = value;
                        });
                      },
                      activeColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: schemesData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> scheme = schemesData[index];
                return !((central && scheme['Type'] == 'Central') || (state && scheme['Type'] == 'State')) ? Container() : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Image.asset(
                        'assets/govt_logo.png',
                        height: 50,
                        width: 50,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SchemeDetails(scheme: scheme)
                          ),
                        );
                      },
                      title: Text(
                        scheme['Name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18
                        ),
                      ),
                      subtitle: Text(
                        scheme['Type'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
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
        backgroundColor: Colors.green[700],
        title: Text('${scheme['Shortcut']} Details'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[100]!, Colors.green[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: keys.length - 3,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(
                keys[index + 3].toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FutureBuilder<String>(
                    future: translateText(scheme[keys[index + 3]], currentLocale.languageCode),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text(scheme[keys[index + 3]]);
                      } else {
                        return Text(
                          snapshot.data ?? scheme[keys[index + 3]],
                          style: TextStyle(fontSize: 16),
                        );
                      }
                    },
                  ),
                ),
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
