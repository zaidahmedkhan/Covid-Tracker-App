// import 'dart:convert';
// import 'package:covid_tracker/Models/WorldStatsModel.dart';

// import 'package:covid_tracker/Services/utilities/app_url.dart';
// // import 'package:covid_tracker/view/world_stats.dart';
// import 'package:http/http.dart' as http;

// class StatsServices {
//   Future<WorldStatsModels> fetchWorldStatsRecord() async {
//     final response = await http.get(Uri.parse(AppUrl.baseUrl));

//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       return WorldStatsModels.fromJson(data);
//     } else {
//       return WorldStatsModels();
//       // throw Exception("error");
//     }
//   }
// }

import 'dart:convert';
import 'package:covid_tracker/Models/WorldStatsModel.dart';
import 'package:covid_tracker/Services/utilities/app_url.dart';

import 'package:http/http.dart' as http;

class StatsServices {
  Future<WorldStatsModels> fetchGlobalCovidData() async {
    try {
      final response = await http.get(Uri.parse(AppUrl.globalData));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WorldStatsModels.fromJson(data);
      } else {
        // return WorldStatsModels();
        // Handle errors if the request fails
        throw Exception("Failed to fetch global COVID-19 data");
      }
    } catch (e) {
      throw Exception("Failed to fetch global COVID-19 data");
    }
  }

  Future<List<dynamic>> countriesListApi() async {
    var data;
    final response = await http.get(Uri.parse(AppUrl.globalCountries));

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      return data;
    } else {
      return countriesListApi();
      // Handle errors if the request fails
      // throw Exception("Failed to fetch global COVID-19 data");
    }
  }
}
