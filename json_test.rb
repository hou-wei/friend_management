    require 'net/http'  
    require 'uri'  
    require 'json'  

    ip = "127.0.0.1"
    port = "3000"

    #1. As a user, I need an API to create a friend connection between two email addresses.
    if false
      # params ={
      #   friends:
      #   ['andy@example.com', 'john@example.com'] 
      # }.to_json 

      # params ={
      #   friends:
      #   ['andy@example.com', 'common@example.com'] 
      # }.to_json 

      params ={
        friends:
        ['john@example.com', 'common@example.com'] 
      }.to_json 

      url = "http://#{ip}:#{port}/friend_user/create_friend"
      url = URI.parse(url)  
      req = Net::HTTP::Post.new(url.path,{'Content-Type' => 'application/json'})  
      req.body = params 
      res = Net::HTTP.new(url.host,url.port).start{|http| http.request(req)}  
    
      puts res.body

    end  

    #2. As a user, I need an API to retrieve the friends list for an email address.

    if false
      params ={
        email: 'andy@example.com'
      }.to_json 
      url = "http://#{ip}:#{port}/friend_user/find_friend"
      url = URI.parse(url)  
      req = Net::HTTP::Post.new(url.path,{'Content-Type' => 'application/json'})  
      req.body = params 
      res = Net::HTTP.new(url.host,url.port).start{|http| http.request(req)}  
    
      puts res.body

    end  

    #3. As a user, I need an API to retrieve the common friends list between two email addresses.

    if false
      params ={
        friends:
        ['andy@example.com', 'john@example.com'] 
      }.to_json 
      url = "http://#{ip}:#{port}/friend_user/find_common_friend"
      url = URI.parse(url)  
      req = Net::HTTP::Post.new(url.path,{'Content-Type' => 'application/json'})  
      req.body = params 
      res = Net::HTTP.new(url.host,url.port).start{|http| http.request(req)}  
    
      puts res.body

    end  


    #4. As a user, I need an API to subscribe to updates from an email address.

    if false
      params ={
        requestor: "lisa@example.com", 
        target: "john@example.com"
      }.to_json 
      url = "http://#{ip}:#{port}/friend_user/subscribe_updates"
      url = URI.parse(url)  
      req = Net::HTTP::Post.new(url.path,{'Content-Type' => 'application/json'})  
      req.body = params 
      res = Net::HTTP.new(url.host,url.port).start{|http| http.request(req)}  
    
      puts res.body

    end  

    #5. As a user, I need an API to block updates from an email address.

    if false
      params ={
        requestor: "andy@example.com", 
        target: "john@example.com"
      }.to_json 
      url = "http://#{ip}:#{port}/friend_user/block_updates"
      url = URI.parse(url)  
      req = Net::HTTP::Post.new(url.path,{'Content-Type' => 'application/json'})  
      req.body = params 
      res = Net::HTTP.new(url.host,url.port).start{|http| http.request(req)}  
    
      puts res.body

    end  


    #6. As a user, I need an API to retrieve all email addresses that can receive updates from an email address.
    if false
      params ={
        sender: "john@example.com",
        text: "Hello World! kate@example.com"
      }.to_json 
      url = "http://#{ip}:#{port}/friend_user/retrieve_all_email"
      url = URI.parse(url)  
      req = Net::HTTP::Post.new(url.path,{'Content-Type' => 'application/json'})  
      req.body = params 
      res = Net::HTTP.new(url.host,url.port).start{|http| http.request(req)}  
    
      puts res.body

    end  
