• An MVC iPhone app to help movie fans search movies, store them to favourites and see details about them.
• Created a custom Dependency Injection and achieved persistence storage with User Defaults.
• Developed using UIKit, URLSession. The app was tested using Unit Testing and UI Testing.

Requirements:
1. Search screen:
• This screen consists of 3 sections
    Popular Movies
    Upcoming
    Top Rated

2. Search screen:
• Implement real-time search. After 3 characters are typed the call to the 
  server is done and the results are displayed immediately. 
  Typing another character will make another call with the new keyword. 
  If the previous call hasn’t returned a response, cancel it and return the list only from the current call.
  
3. Favorites screen:
• A list of favorite movies.Clicking on the favorite icon will remove the movie from the favorites list.
  Clicking on a movie poster will open the Details Page for that specific movie.
  The movie list should persist after closing and reopening the app

  
4. Details page:
• The list of movie details: Poster, Name, Genre, Year, Duration, Details, Starring, Directors, Producers, Trailers
  Clicking on the favorites icon in the navigation bar will add the movie to the favorites list.
  Clicking on the share button will open the native share sheet.
  Clicking on a trailer will open the video in an external player (Safari, Youtube app).
