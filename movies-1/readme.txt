Questions:
1-Describe an algorithm to predict the ranking that a user U would give to a movie M assuming the user hasn’t already ranked the movie in the dataset:
I suggest an algorithm that predict this ranking as the average ranking of the 10 most similar users to user "U" who have already ranked the movie M.

2-Does your algorithms scale? What factors determine the execution time of your “most_similar” and “popularity_list” algorithms:
It seems that these algorithms does not scale well if number of records in the data increases. Although I designed two auxiliary data structure to help the scalability:
@users: it is a map which contains user as the key and the ratings related to that user as the value.
@movies: it is a map which contains movie as the key and the ratings related to that movie as the value.
I also suggest two versions of the function popularity_list and the second version is more scalable.
Most important factor that determines the execution time for:
the function "most_similar" is the complexity of the algorithm which calculates the similarity between two users (similarity(user1,user2)).
the function "popularity_list" is the complexity of the algorithm which calculates the popularity for a specific movie (popularity(movie_id)).

Functions:
1-function load_data:
  This function is used to load the data from file and store it as an array called "data".
  Each item in the "data" is itself an array [user_id,movie_id,rating,timestamp] constructed from each line of the file.

2-function popularity(movie_id):
  This function returns the popularity of a given movie.
  Popularity of a given movie is calculated as the average ratings for that movie.

3-function popularity_list (and popularity_list2):
  This function calculates the average rating for each movie in the data and generates a list of movies and their popularity.
  Then it sorts the list in decreasing order based on popularity and returns the list.
  Note: To generate this list, my first approach is to call the popularity(movie_id) function for each movie id in the data and ultimately generate the list. But this approach is O(n^2) and extremely slow, because for each movie id to calculate the popularity, the function popularity(movie_id) traverse the whole data. Therefore I created second version of the popularity_list (popularity_list2) which does not use the popularity(movie_id) function and is O(n) and extremely faster than the first version. In the second approach I calculate the sum of rating and the count for each movie id by traversing the whole data just once. After that I calculate the average rating for each movie id by dividing sum of rating by count.

4-function similarity(user1,user2):
  To calculate the similarity between user1 and user2 first this function first obtains the list of movies which they have both rated.
  Then for each common movie it calculates the distance between their ratings as 4-|user1.rating-user2.rating|.
  After that the final similarity is calculated as the average of all these distances.

5-function most_similar(u):
  For each user in the data it calculates the similarity of it with the user "u" and creates a list of similarity.
  Then it sorts the similarity list in decreasing order and returns the list of similar users.
  



