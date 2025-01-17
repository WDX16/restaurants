import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'dart:convert';
import 'package:assignment_2/main.dart'; 
import 'package:assignment_2/favorites.dart';


//Restaurant Page
class RestaurantsScreen extends StatefulWidget {
  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  List<dynamic> restaurants = [];

  @override
  void initState() {
    super.initState();
    loadRestaurants();
  }

class _EventsScreenState extends State<EventsScreen> {
  // Declare a list to store event data
  List<dynamic> events = [];

  // Override the initState method, which is called when the widget is first initialized
  @override
  void initState() {
    super.initState();
    loadEvents(); // Call the loadEvents function to load events data
  }

  // Function to load events data
  Future<void> loadEvents() async { 
    var response;

    // Try to fetch data from an external JSON file hosted on a GitHub repository
    try { 
      response = await http.get(Uri.parse('https://wdx16.github.io/events-json-file/events_json_file.json')); 
    } catch (e) { 
      // If the fetch fails, print an error message and load offline data from a local JSON file
      print('Failed to fetch data from external JSON file. Loading offline data...');
      
      // Load data from the local events JSON file if the app is offline
      final localData = await DefaultAssetBundle.of(context).loadString('assets/events.json');
      
      // Decode the local JSON data and update the events list
      setState(() { 
        events = jsonDecode(localData); 
      });
      return; 
    } 

    // If the response is successful (status code 200), decode the API response
    if (response.statusCode == 200) { 
      setState(() { 
        events = jsonDecode(response.body); // Parse the response body and update events
      });
    } else { 
      // If the response is not successful, loads offline data
      print('Failed to fetch data from external JSON file. Loading offline data...');
      
      // Load data from the local JSON file if API call fails
      final localData = await DefaultAssetBundle.of(context).loadString('assets/events.json');
      
      // Decode the local JSON data and update the events list
      setState(() { 
        events = jsonDecode(localData); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns the children to the left
        children: [
          // Heading for "Restaurants"
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20.0), // Adds space at the top and left
            child: Text(
              'Restaurants', // Display "Restaurants" at the top left
              style: TextStyle(
                fontSize: 32, // Larger font size for heading
                fontWeight: FontWeight.bold,
                // Dynamically changing color based on theme mode
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white  // Dark mode: white text
                    : const Color.fromARGB(255, 5, 5, 5), // Light mode: black text
              ),
            ),
          ),
          Container(
            width: double.infinity, // Ensure it takes the full width of the parent
            height: 2, // Height of the shadow (or you can adjust it)
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 131, 131, 131).withOpacity(0.4), // Shadow color
                  blurRadius: 1, // Blur radius of the shadow
                  offset: Offset(0, 0), // Offset (horizontal, vertical)
                ),
              ],
            ),
          ),
          
          SizedBox(height: 10), // Adds space between the heading and the list

          // Grid of restaurants
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3, // 2 for vertical and 3 for horizontal
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.75, // Adjust aspect ratio for better spacing
              ),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MasterDetailScreen(
                          title: restaurant['name'],                            
                          details: restaurant['description'],
                          imageUrl: restaurant['imageUrl'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: const Color.fromARGB(255, 29, 103, 126), // Change card color to blue accent
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              restaurant['imageUrl'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          restaurant['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white, // Text color to stand out on blue
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Location: ${restaurant['location']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70, //  lighter text for contrast
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () async {
                            await saveFavorite(restaurant['name']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${restaurant['name']} added to favorites!')),
                            );
                          },
                          child: Text('Add to Favorites'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 238, 238, 238), // Change button color to orange
                            minimumSize: Size(150, 40), // Increase button size
                            textStyle: TextStyle(fontSize: 14),
                            foregroundColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : const Color.fromARGB(255, 19, 59, 24), // Change text color based on theme
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
