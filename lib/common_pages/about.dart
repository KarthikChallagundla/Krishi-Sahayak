import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 200, 0, 0.8),
        title: Text('About Us'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('About Us', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('Welcome to Krishi Sahayak, your one-stop solution designed to revolutionize the way farmers and agricultural service providers connect and operate. Our app aims to bridge the gap between various stakeholders in the agricultural sector, making it easier for farmers to access essential resources and services.', textAlign: TextAlign.justify,),
              SizedBox(height: 10,),
          
              Text('Our Mission', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('At Krishi Sahayak, our mission is to simplify agricultural operations by providing a platform that seamlessly connects farmers with seed retailers, machinery providers, nearby stores, and crop doctors. We strive to empower farmers with the tools they need to enhance productivity and ensure sustainable agricultural practices.', textAlign: TextAlign.justify,),
              SizedBox(height: 10,),
          
              Text('Our Vision', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('Our vision is to transform the agricultural sector through innovative technology, creating a more efficient and connected ecosystem. We aim to be the leading platform for agricultural resources and services, fostering growth and development in the farming community.', textAlign: TextAlign.justify,),
              SizedBox(height: 10,),
          
              Text('Technology', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('We leverage the power of Flutter for app development, ensuring a smooth and responsive user experience across devices. Our authentication is handled by Firebase, providing secure and reliable user management. Additionally, we integrate with a weather API to provide accurate and timely weather information.', textAlign: TextAlign.justify,),
              SizedBox(height: 10,),
          
              Text('Security', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('We prioritize your security with data encryption at rest and in transit. Our app includes phone number validation to ensure the authenticity of our users. Your data privacy and protection are our top concerns.', textAlign: TextAlign.justify,),
              SizedBox(height: 10,),
          
              Text('Support & feedback', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('We value your feedback and are here to support you. If you have any questions, concerns, or suggestions, please reach out to us at karthikchallagundla18@gmail.com. Your input helps us improve and serve you better.', textAlign: TextAlign.justify,),
              SizedBox(height: 10,),
          
              Text('Future Plans', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('Stay tuned for exciting updates and new features as we continue to enhance our platform to better serve the agricultural community.', textAlign: TextAlign.justify,),
              SizedBox(height: 10,),
          
              Text('Contact Us', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('Have questions or need assistance? Contact us at karthikchallagundla18@gmail.com. We\'re here to help!', textAlign: TextAlign.justify,),
              SizedBox(height: 40,),
            ],
          ),
        ),
      ),
    );
  }
}