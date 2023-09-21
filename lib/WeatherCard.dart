import 'package:flutter/material.dart';

class HourlyForecastItem{
  String? time;
  String? temp;
  String? icon;

  HourlyForecastItem({String? time,String? temp,String? icon}){
    this.icon = icon;
    this.temp = temp;
    this.time = time;
    time ??= "0:00";
    temp ??= "0K";
    icon ??= "cloudy";
  }

  Icon setIcon(){
    Icon icon = const Icon(Icons.cloud);
    switch (this.icon){
      case "Clouds":
        {
          icon = const Icon(Icons.cloud);
          break;
        }
      case "Rain":
        {
          icon = const Icon(Icons.water_drop_outlined);
          break;
        }
      case "Sun":
        {
          icon = const Icon(Icons.sunny);
          break;
        }
      default:
        {
          icon = icon;
        }
    }
    return icon;
  }


  SizedBox createCard(){
    return SizedBox(
      width: 100,
      child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  "$time",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                setIcon(),
                Text(
                  "$temp",
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal
                  ),
                )
              ],
            ),
          )
      ),
    );
  }


}