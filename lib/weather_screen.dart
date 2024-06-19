import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secret.dart';
import 'package:intl/intl.dart';

//Si jamais je veux switch entre StatelesWidget et StatefulWidget
//Je peux refractor
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  //late double temp; n'est pas possible car la fonction build
  // s'execute avant notre fonction async

  //utiliser "late" lorsque vous savez que la variable sera initialisée
  //avant son utilisation, mais pas nécessairement au moment de sa déclaration.
  //Cela peut être utile dans des situations où l'initialisation de la variable
  //dépend de conditions qui ne sont pas connues
  //au moment de la déclaration, mais qui seront déterminées plus tard
  //(moi) EVITE les warnings ou erreur de compilation si je ne l'initialise pas de suite
  //double temp = 0;
  //bool isLoading = false;

  //Lorsqu'une fonction est marquée avec le mot-clé "async",

  //toujours avoir un generic type, pour les future, stream
  //c'est une bonne pratique
  Future<Map<String, dynamic>> getCurrentWeather() async {

    try {
      /*setState(() {
        isLoading = true;
      });*/
      String cityName = 'La Possession, RE';
      //difference de uri et de url
      //Url est une sous categorie de URI

      //Le mot-clé "await" est utilisé dans Dart pour attendre
      //l'achèvement d'une opération asynchrone.
      //l'utilisation de "await" avec la fonction "http.get"
      //permet d'attendre que la requête HTTP soit terminée
      //et que la réponse soit reçue avant de continuer l'exécution du code suivant.
      final result = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );
      //if (result.statusCode == 200) alternative
      final data = jsonDecode(result.body);
      if (data['cod'] != '200') {
        //throw termine la fonction comme un return
        throw 'Une erreur s\'est produit';
      }
      //print(result); indique simple que c'est un objet response
      //print(result.body);

      //Pour rebuild le widget nécessaire lorsque la données est disponible
      /*setState(() {
        //kelvin to celcius
        temp = data['list'][0]['main']['temp'] - 273.15;
        isLoading = false;
      });*/

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  //RAPPEL
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //parce que je suis sous android (moi)
        centerTitle: true,
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        //obliger d'utiliser la propriete "actions"
        //si je veux mettre des icones (en general) à droite de l'appbar
        actions: [
          /*GestureDetector(
            onTap: () {
              print('refresh');
            },
            child: const Icon(Icons.refresh),
          ),*/

          //Pour avoir le flash effect & l'effet sonore
          /*InkWell(
            onTap: () {
              print('refresh');
            },
            child: const Icon(Icons.refresh),
          ),*/
          //Pour avoir le flash effect, l'effet sonore & le padding
          IconButton(
            onPressed: () {
              //setState pour un seul StatefulWidget
              //setState est local comme Scaffold set l'ui pour une page
              //setState local state management
              setState((){
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      /*
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
      */
      body: FutureBuilder(
        future: weather,
        //future: getCurrentWeather(),
        //La classe "AsyncSnapshot<dynamic>" gére les données asynchrones,
        //souvent utilisée avec des widgets comme FutureBuilder ou StreamBuilder.
        //Elle encapsule les données provenant d'une opération asynchrone
        //et fournit des informations sur l'état de cette opération,
        //telles que si elle est en cours, réussie ou a échoué, ainsi que les données elles-mêmes.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //Creates an adaptive progress indicator that is a
            // [CupertinoActivityIndicator] in iOS and [CircularProgressIndicator] in
            // material theme/non-iOS. Donc sur android
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          //Lorsque vous déclarez une variable comme "final",
          //cela signifie que sa valeur ne peut pas être modifiée une fois qu'elle a été initialisée.

          //Difference entre final & const
          //la valeur de la variable "final" peut être calculée à l'exécution.
          //Les variables "const" doivent être initialisées avec des valeurs
          //constantes et ne peuvent pas être initialisées avec des valeurs calculées à l'exécution.

          //moi) peut faire des calcul avec une variable final contrairement à const
          //finalVariable * 2; // OK | constVariable * 2; // Erreur de compilation
          //valeur non-constante utilisée dans une expression constante
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'] - 273.15;
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                //Pour aligner à gauche tous les widget
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //***********//
                  // Main Card //
                  //***********//
                  //si on utilise que des propiete comme width & height
                  // alors on privilegie SizedBox
                  SizedBox(
                    // double.infinity prend toute la largeur possible
                    //equivalent 100% en HTML
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      //moi
                      /*shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),*/
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      //"ClipRRect" est utilisée pour découper les enfants (widgets)
                      //selon une forme rectangulaire avec des coins arrondis.
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        //Pour avoir l'effet de flou sur la carte
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${currentTemp != 0 ? currentTemp.toStringAsFixed(2) : currentTemp.toStringAsFixed(0)} °C',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              /*Image.network(
                                'http://openweathermap.org/img/w/${currentWeatherData["weather"][0]["icon"]}.png',
                                scale: 0.45,
                              ),*/
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  //************************//
                  // weather forecast cards //
                  //************************//
                  const SizedBox(
                    height: 20,
                  ),
                  //Pour override la position d'un widget en particulier
                  //align le widget à gauche

                  //le widget "Container" dispose de la mm propriete
                  /*const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Weather Forecast',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),*/
                  const Text(
                    'Hourly Forecast',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  //Rendre un widget scrollable
                  /*SingleChildScrollView(
                    //Change la direction où l'utilisateur peut scroll
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        //*************************//
                        //     ancienne version    //
                        //*************************//
                        //moi
                        /*Card(
                          elevation: 10,
                          //moi
                          /*shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),*/
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          //"ClipRRect" est utilisée pour découper les enfants (widgets)
                          //selon une forme rectangulaire avec des coins arrondis.
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '03:00',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.cloud,
                                  size: 32,
                                ),
                                Text(
                                  '300 °C',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),*/

                        //Pas besoin de {}, pour un widget
                        //sinon, for (var i = 1; i < 6; i++)...[plusieurs widget]
                        //si dans la boucle for il y a plusieurs widget
                        for (var i = 1; i < 6; i++)
                          HourlyForecastItem(
                            //The substring of this string from start, inclusive, to end, exclusive.
                            hour: data['list'][i]['dt_txt'].substring(11, 16),
                            icon: data['list'][i]['weather'][0]['main'] ==
                                        'Clouds' ||
                                    data['list'][i]['weather'][0]['main'] ==
                                        'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            temperature:
                                '${(data['list'][i]['main']['temp'] - 273.15).toStringAsFixed(0)} °C',
                          ),
                      ],
                    ),
                  ),*/
                  //ListView c'est pour un column qui est scrollable

                  //ListView.builder permet ici de lazy load, bien quand il ya bcp d'element à render
                  //càd load au fur et à mesure que l'on scroll
                  //les éléments de la liste doivent être générés à la volée.

                  //ListView.builder crée des éléments de liste uniquement
                  // lorsque cela est nécessaire, booste la performances,
                  //car il ne construit que les éléments visibles à l'écran
                  //et recycle les éléments qui ne le sont pas.

                  //itemCount spécifie le nombre total d'éléments dans la liste.
                  //itemBuilder est une fonction qui prend un contexte et un index en entrée
                  //et renvoie le widget à afficher à cet index de la liste.
                  //Cette fonction est appelée à chaque fois qu'un élément de la liste doit être rendu.

                  //ListView.builder par défault prend toute la place
                  //prends tout l'écran, donc il faut restrict ici la height
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        // comme une boucle for par default
                        // la list commence à 0 c'est pour ça que je fais +1
                        final hourlyForecast = data['list'][index + 1];
                        final hourlySky = hourlyForecast['weather'][0]['main'];
                        final hourlyTemp = '${(hourlyForecast['main']['temp'] - 273.15).toStringAsFixed(0)} °C';
                        final time = DateTime.parse(hourlyForecast['dt_txt']);

                        return HourlyForecastItem(
                            //moi//hour: hourlyForecast['dt_txt'].substring(11, 16),
                            //Format la date avec le package intl, recommandé
                            //DateFormat('custom format')
                            hour: DateFormat.Hm().format(time),
                            icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            temperature: hourlyTemp);
                      },
                    ),
                  ),
                  //*************************//
                  // additional information //
                  //*************************//
                  const SizedBox(
                    height: 16,
                  ),
                  /*const Placeholder(
                  //fallbackHeight different de Height
                  //sans indiquer un child il va prendre la valeur de la propriete
                  //si un child est set alors le widget parent (placeholder) va prendre
                  // l'espace requis que le child a besoin
                  fallbackHeight: 150,
                ),*/
                  const Text(
                    'Additional information',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    //Placez l'espace libre uniformément entre les enfants
                    //ainsi que la moitié de cet espace avant et après le premier et le dernier enfant.
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.air,
                        label: 'Wind speed',
                        value: currentWindSpeed.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currentPressure.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
