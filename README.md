# WeatherSTRV #

WeatherSTRV is a weather app that informs the user with the their current weather details based on their current location. It also provides the user with 7 days weather forecast from his current time.

As that the main functionality of the app is to provide weather data and that this weather service directly depends on the location, I decided to implement a ServicesManager that manages the app services by running the communication between the WeatherServices and LocationServices classes. This ServicesManager have a shared instance that could be used in any part of the app. 

I fetch the weather data using http://openweathermap.org APIs.

In order for a view controller to use the ServicesManager services, it has to:
- Implement the ServicesManagerSubscriberDelegate and the needed service corresponding delegate (either ServicesManagerWeatherDelegate, ServicesManagerForecastDelegate or both)  to insure that the vc will subscribe to the ServiceManager triggered notifications.

Moreover, the subscribed vc can request an on demand get weather or forecast data from the Service Manager shared instance without waiting for the notification to be automatically triggered.

Please feel free to contact me if you had any questions or suggestions.
mahmoud@eldesouky.com

Cheers,
Eldesouky
