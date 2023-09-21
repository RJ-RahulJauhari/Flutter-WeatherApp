
import 'package:flutter/material.dart';
class OtherWeatherStats{
  String? statType;
  double? value;

  OtherWeatherStats({String? statType,double? value}){
    this.statType = statType;
    this.value = value;

    this.statType ??= "N/A";
    this.value ??= -1;
  }

  Icon setIcon(){
    Icon icon = const Icon(Icons.cloud);
    switch (this.statType){
      case "humidity":
        {
          icon = const Icon(Icons.water_drop);
          break;
        }
      case "wind":
        {
          icon = const Icon(Icons.air_outlined);
          break;
        }
      case "pressure":
        {
          icon = const Icon(Icons.beach_access_outlined);
          break;
        }
      default:
        {
          icon = icon;
        }
    }
    return icon;
  }

  SizedBox createStat(){
    return SizedBox(
      width: 100,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            setIcon(),
            SizedBox(
              height: 10,
            ),
            Text(
              "$statType",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "$value",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }

}