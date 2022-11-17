import 'package:http/http.dart' as http;
import 'dart:convert';

/**
 * NetworkHelper class for handling http posts and gets
 * @param url - url to get or post from
 * */
class NetworkHelper{
  NetworkHelper(this.url);
  final String url;
  /*
     * Function to get data from api
     * @param void
     * @return void
     * */
  Future getData() async{
    http.Response response =await http.get(Uri.parse(url));
    if(response.statusCode==200){
      String responseBody=response.body;
      var decodedData=jsonDecode(responseBody);
    return decodedData;}
    else{
      print(response.statusCode);
    }
  }
  /*
     * Function to get object from api for a given id
     * @param int id - id of object
     * @return void
     * */
  Future getObject(int id)async{
    String url = 'https://fakestoreapi.com/products/$id';
    http.Response response =await http.get(Uri.parse(url));
    if(response.statusCode==200){
      String responseBody=response.body;
      var decodedData=jsonDecode(responseBody);
      return decodedData;}
    else{
      print(response.statusCode);
    }
  }
}