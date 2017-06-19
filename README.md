# WeatherSTRV #

As that the main functionality of the app is to provide weather data and as that this weather service directly depends on the location, I decided to implement a ServicesManager that handles the communication between the WeatherServices and LocationServices classes. This ServicesManager have a shared instance that could be used in any part of the app.

In order for a view controller to use the ServicesManager services, it has to:
- Implement the ServicesManagerSubscriberDelegate and the needed service corresponding delegate (either ServicesManagerWeatherDelegate, ServicesManagerForecastDelegate or both)  to insure that the vc will subscribe to the ServiceManager triggered notifications

Moreover, the subscribed vc can request an on demand get weather or forecast data without waiting for the notification to be automatically triggered.

All requirements have been implemented.

Thanks
Cheers,
Eldesouky