# Albms
An iPhone application that downloads the top 100 albums from  iTunes and builds a list to 
view details about each album. The user may also go to the iTunes Store to purchase the album.

## Installation

```bash
$ git clone git@github.com:migs647/Albums.git
$ cd Albms
$ open Albms.xcodeproj
```

## Synopsis

Code sample that demonstrates the ability to perform asynchronous image requests on a 
UITableView that utilizes image caching and Core Data to handle the data for potential 
offline viewing.

Included is a networking controller to read iTunes top 100 albums JSON and load up `the best` 
music ever.

## Original Request

- On launch, the user should see a UITableView showing one album per cell. 

- Each cell should display the name of the album, the artist, and the album art (thumbnail image). 

- Tapping on a cell should push another view controller onto the navigation stack where we see a larger image at the top of the screen and the same information that was shown on the cell, plus genre, release date, and copyright info below the image. 

- A button should also be included on this second view that when tapped fast app switches to the album page in the iTunes store. 

- The button should be centered horizontally and pinned 20 points from the bottom of the view and 20 points from the leading and trailing edges of the view. Unlike the first one, this "detail" view controller should NOT use a UITableView for layout.

## Requirements

- Must use storyboards

- Use Autolayout

- Not use any third party libraries

## Tactics

This app utilizes Core Data for a potential to scale up with an NSFetchedResultsController at 
a later date and also have offline viewing. In order for offline viewing to be complete, reachability
would need to be added along with to file system image caching.
