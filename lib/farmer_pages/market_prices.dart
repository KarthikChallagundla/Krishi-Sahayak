import 'package:flutter/material.dart';

class MarketPrices extends StatefulWidget {
  const MarketPrices({super.key});

  @override
  State<MarketPrices> createState() => _MarketPricesState();
}

class _MarketPricesState extends State<MarketPrices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 200, 0, 0.8),
        title: Text('Market Prices'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('This page is under maintanance.'),
      ),
    );
  }
}