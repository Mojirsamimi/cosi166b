class MovieData

  def load_data(filename='./ml-100k/u.data')
    datafile = open(filename)
    #three data structure to store the data
    @data=Array.new #array of arrays which stores each line of the the data
    @movies=Hash.new #map that for each unique movie id in the data file, stores its relevant records
    @users=Hash.new #map that for each unique user in the data file, stores its relevant records
    datafile.each_line do |line|
      linedata=line.split(" ").map(&:to_i)
      @data.push(linedata)
      if !@users.has_key?(linedata[0])
        @users[linedata[0]]=[linedata]
      else
        @users[linedata[0]].push(linedata)
      end
      
      if !@movies.has_key?(linedata[1])
        @movies[linedata[1]]=[linedata]
      else
        @movies[linedata[1]].push(linedata)
      end
    end
    datafile.close
  end
  
  #Popularity is defined as the average of ratings for that movie
  def popularity(movie_id)
    #get all records which their movie_id is equal to the argument
    movie_data=@movies[movie_id] 
    
    #return 0 if there is no such a movie in data
    if movie_data.size==0
      return 0
    end
    
    #calculate the average of all ratings for this movie id and return it
    sum=0.0
    movie_data.each do |movie|
      sum+=movie[2]
    end
    return (sum/movie_data.size)  
  end
  
  def popularity_list
    #pop_list is an array of all movie ids and their popularity ([movie_id,popularity])
    if @pop_list==nil     
      @pop_list=Array.new
      @data.each do |itm|
        movie_id=itm[1]
        #if this movie id does not exist in the list, add it to the list
        if @pop_list.index{|x| x[0]==movie_id}==nil 
          @pop_list.push([movie_id,popularity(movie_id)])
        end
      end
      #sort the pop_list array descending based on popularity (average rating)
      @pop_list.sort_by!{|item| -item[1]}
    end
    return @pop_list 
  end
  
  def popularity_list2
      
    if @pop_list==nil     
      #pop_map is a map that contains items with the key "movie_id" and value "[rate_sum,count]". 
      pop_map=Hash.new
      @data.each do |itm|
        if !pop_map.has_key?(itm[1]) #if this movie id does not exist in the map, add it to the map
          pop_map[itm[1]]=[itm[2],1]
        else #if this movie id exist in the map, sum up the existing "rate_sum" with rating of the current item and increase "count" by 1.
          pop_map[itm[1]][0]+=itm[2]
          pop_map[itm[1]][1]+=1
        end
      end
      @pop_list=Array.new
      pop_map.each_pair do |key,value|
        #push each movie id and its average rating to the pop_list. average= rate_sum/count
        @pop_list.push([key,value[0].to_f/value[1]])
      end
      #sort the pop_list array descending based on popularity (average rating)
      @pop_list.sort_by!{|item| -item[1]}
    end
    return @pop_list 
  end
  
  def similarity(user1,user2)
    #retrieves the recorded related to user1 and user2
    #then create an array which contains the movie ids which both user have rated them
    u1=@users[user1]
    u2=@users[user2]
    u1_movies=u1.collect{|itm| itm[1]}
    u2_movies=u2.collect{|itm| itm[1]}
    common_movies=u1_movies & u2_movies
    
    if common_movies.empty?
      return 0
    end
    
    #Similarity is defined as the average of (4 - distance between rating of user 1 and 2) for movie id
    #which the both have rated
    similarity=0.0
    common_movies.each do |movie|
      rating1=u1.rassoc(movie)[2]
      rating2=u2.rassoc(movie)[2]
      similarity+=4-(rating1-rating2).abs
    end
    return similarity/common_movies.size
  end
  
  def most_similar(u)
    sim_list=Array.new
    #for each user in the data we calculate the similarity of it with the user "u"
    #and create a list of similarity
    @users.each_key do |user|
      if user!=u
        sim_list.push([user,similarity(u,user)])
      end
    end
    #sorts the similarity list in decreasing order and returns the top 100
    sim_list.sort_by!{|itm| -itm[1]}
    return sim_list
  end
  attr_accessor:data
end

#gets the filepath for data from user
filename = ARGV.first 
#define the default filepath for data
filename ||= './ml-100k/u.data' 
if !File.exist?(filename)
  puts "Cannot find the data file!"
  exit(0)
end
mov=MovieData.new
mov.load_data(filename)

pop_list=mov.popularity_list
most_sim=mov.most_similar(1)

puts "popularity list first 10"
pop_list.first(10).each do |movie|
  puts movie[0]
end
puts "popularity list last 10"
pop_list.last(10).each do |movie|
  puts movie[0]
end

puts "most similar to user 1, first 10"
most_sim.first(10).each do |user|
  puts user[0]
end
puts "most similar to user 1, last 10"
most_sim.last(10).each do |user|
  puts user[0]
end
