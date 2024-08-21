import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MarketPrices extends StatefulWidget {
  const MarketPrices({super.key});

  @override
  State<MarketPrices> createState() => _MarketPricesState();
}

class _MarketPricesState extends State<MarketPrices> {

  late String data;

  Future<String> getData() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://agmarknet.gov.in/SearchCmmMkt.aspx?Tx_Commodity=281&Tx_State=AP&Tx_District=13&Tx_Market=0&DateFrom=12-Aug-2024&DateTo=12-Aug-2024&Fr_Date=12-Aug-2024&To_Date=12-Aug-2024&Tx_Trend=0&Tx_CommodityHead=Alasande+Gram&Tx_StateHead=Andhra+Pradesh&Tx_DistrictHead=Chittor&Tx_MarketHead=--Select--',
        )
      );
      return res.body;
    }catch (e) {
      throw e.toString();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 200, 0, 0.8),
        title: Text('Market Prices'),
        centerTitle: true,
      ),
      body: Center(
        child: Text("This page is under maintanance."),
      ),
    );
  }
}