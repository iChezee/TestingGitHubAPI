# Swift Assignment
  This Assignment is intended to check your Swift knowledge and general development practices.

# Install
  To compile the project you will need [SwiftLint](https://github.com/realm/SwiftLint) and [SwiftGen](https://github.com/SwiftGen/SwiftGen) installed. Project use system-wide installation so you will need homebrew and two command in your terminal and restaring Xcode after installation.


# The Assignment Trending Repositories:
  Create an iphone (iOS) application that displays the most trending repositories on GitHub that were created in the last day, last week and last month. The user should be able to choose which timeframe they want to view. In the same screen, the list of trending repositories sorted by the number of stars should be shown int a table. Each cell (repository) on the list should contain the following information:
  
    ● The username of the owner and the name of the repository.
    ● The avatar of the owner as a small thumbnail. If no avatar exists, use a default "no avatar" image.
    ● The description for the repository. if there is no description, add some default text to imply that.
    ● The number of stars
  
  Additional Features:
  
    ● The list should allow for infinite scrolling, loading more items when the user reaches the end
    ● When a user taps on a cell, present a detail screen for the repository, with all the former details and 
    these additional ones:
    
      ○ Language, if available
      ○ Number of forks
      ○ Creation date
      ○ a working link to the GitHub page of the repository
  
    ● The user should be able to add a repository to their own favourite list. The favourites repositories are saved 
    locally and are available offline. There should be a Favorite Repositories screen that allows a user to view the 
    favourite repositories, get their details and delete them. Favourited repositories should be shown as such in the 
    main list.
  
  Major Bonus Points:
  
    ● The avatar images should be cached by you somehow, in order to avoid redownloading the same images over and over 
    again.
    ● Create a UI that is better suitable for tablets (as well as the current one for the phone form factor), considering 
    that there's some sort of list
    ● Implement search for each list.
    ● Provide a clear user experience when there is no internet connection.
