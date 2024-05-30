// ignore_for_file: use_build_context_synchronously

import 'dart:convert';


import 'package:cookin/pages/recipe_generate_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<Uint8List> convertTextToImage(
  String prompt,
  BuildContext context
) async {
  Uint8List imageData = Uint8List(0);


    const baseUrl = 'https://api.stability.ai';
  final url = Uri.parse(
      '$baseUrl/v1alpha/generation/stable-diffusion-512-v2-0/text-to-image');

  // Make the HTTP POST request to the Stability Platform API
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization':
          //add ypur secreat key here
          'Bearer sk-kSC2cMNwciQ2Mze1p3lBqfRWPmXRKYny5MscQyaZS6b0LVf1',
      'Accept': 'image/png',
    },
    body: jsonEncode({
      'cfg_scale': 7,
      "sampler": "K_DPM_2_ANCESTRAL",
      'height': 512,
      'width': 512,
      'samples': 1,
      'steps': 30,
      'text_prompts': [
        {
          'text': 'Image of $prompt',
          'weight': 1,
        }
      ],
    }),
  );
  if (response.statusCode == 200) {
      // Check if the response contains image data
      if (response.bodyBytes.isNotEmpty) {
        try{
          imageData = (response.bodyBytes);
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateRecipeScreen(recipeNameImage: imageData),));
        
        return response.bodyBytes; // Return the image data
      } 
      catch(e){
    print(e);
  }
      }
      else {
        print('No image data found in the response');
       // Return null if no image data is found
      }
    } 
    return imageData;  
}
