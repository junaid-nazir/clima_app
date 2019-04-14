import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';

class Climatic extends StatefulWidget {
  @override
  _ClimaticState createState() => _ClimaticState();
}

class _ClimaticState extends State<Climatic> {

    

    var location = new Location();
    
    

  
    @override
    Widget build(BuildContext context) {
      return new Scaffold(
          appBar: new AppBar(
            title: new Text('Climatic'),
            backgroundColor: Colors.blue,
            actions: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.menu),
                  onPressed: ()=> debugPrint('hey')
                )
            ]
            
          ),
          body: new Stack(
            children:
             <Widget>[
              new Center(
                child: new Image.asset('Images/background.jpg',
                fit: BoxFit.fill,
                height: 677.0
  
                
              )
              ),
              new Container(
                child: updateTempWidget()
                
              ),
            ],
          )
      );
      

    }
        
      
  
   Future<Map> getWeather(String apiId, double lat, double lon) async{

        String weatherUrl = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=${util.apiId}&units=metric';
        http.Response response = await http.get(weatherUrl);
      
        var dec = json.decode(response.body);
        print(dec.toString());
        //dec['main']['temp'] = (dec['main']['temp'] - 273.15).round();
        return dec;
  }

Widget updateTempWidget(){
    return new FutureBuilder(
      future: getLocationAccess(),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
        //where we get all of the json data,we setup widgets

        if(snapshot.hasData){
            Map content = snapshot.data;
            return new Container(
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text((content['main']['temp'].toString())+"°",
                    style: tempStyle()
                    ),
                  ),
                  new ListTile(
                    title: new Text(content["name"],
                    style: textStyle(),),
                  ),
                  new ListTile(
                    title: new Text(content["weather"][0]["main"],
                    style: textStyle(),),
                  )
                ],
              ),
            );
        }
        else{
          return new Container();
        }

    });
  }
  
  TextStyle textStyle(){
  
    return new TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontStyle: FontStyle.normal
  
  
    );
  }
  
  TextStyle tempStyle(){
    return new TextStyle(
        color: Colors.white,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        fontSize: 70.5
        
  
    );

    
  }

     Future<Map> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation =  await location.getLocation();

      
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

   Future<Map> getLocationAccess() async {

          Map data1 = await _getLocation();
          var lat  = data1['latitude'];
          var lon = data1['longitude'];
          Map data =  await getWeather(util.apiId, lat, lon);
          print(data);
          return data;      
  
       
  }

  
}

