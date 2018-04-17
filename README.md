# SpaceRace
Space race is a self contained news app about space. Totally non-profit and designed to bring the wonders of space to the masses. Space race automatically generates articles using a combination of web crawlers and rss feed’s and personal curation. Breathtaking photographs are provided by either websites themselves or automatically generated from * [Unsplash](https://unsplash.com).

## Warning

This is a work in progress

### Installing

Make sure you have pods installed. Run ``` $pod install ```

Create a new file, setup.swift. Paste the following into the file. This is to keep my personal keys safe sorry.

```Swift
import Foundation

struct GlobalConstants {
    // Unsplash Api
    static let unsplashClientId = "YOUR_CLIENT_ID_HERE"
    
    // Google Custom Search Api
    static let customSearchEngineKey = "YOUR_CUSTOM_SEARCH_ENGINE_KEY_HERE"
    static let publicApiKey = "YOUR_PUBLIC_API_KEY_HERE"
}
```

If you want to use these values in other areas of the app, simply call the global constant as such :

```Swift
let clientId = GlobalConstants.unsplashClientId
print ("Your unsplash client ID is : ", clientId)
```

You can test if it's working by placing this somewhere where it will run such as ViewDidLoad.
Please also import the google.info.plist, from firebase.

## Built With

* [Firebase](https://firebase.google.com) - Cloud Synchronisation
* [SwiftyJson](https://github.com/SwiftyJSON/SwiftyJSON) - Json Parsing
* [KingFisher](https://github.com/onevcat/Kingfisher) - Asynchronous Image Loading
* [Alamofire](https://github.com/Alamofire/Alamofire) - HTTP Networking
* [Unsplash](https://unsplash.com/developers) - Random Photo generation of Breathtaking Photos from the Unsplash Library.
* [Google CSE](https://developers.google.com/custom-search/) - To attempt to find suitable images to accompany articles.


## Authors

* **Dalton Prescott** - *Main Developer* - [website](http://daltonprescott.com)

## Acknowledgments
* Hat tip to anyone who's code was used
