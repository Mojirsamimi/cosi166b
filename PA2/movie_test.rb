class MovieTest
  #adds a tuple [u,m,r,p] to the result array
  def add_to_result(tuple)
    if @result==nil
      @result=Array.new
    end
    @result.push(tuple)
  end
  
  #returns the average predication error
  def mean
    error=0.0
    @result.each do |res|
      error+=(res[2].to_f-res[3].to_f).abs
    end
    return error/@result.size
  end
  
  #t.stddev returns the standard deviation of the error
  def stddev
    m=mean
    variance=0.0
    @result.each do |res|
      variance+=((res[2].to_f-res[3].to_f).abs-m)**2
    end
    variance/=(@result.size-1)
    return Math.sqrt(variance)
  end
  
  #returns the root mean square error of the prediction
  def rms
    return stddev
  end
  
  #returns an array of the predictions in the form [u,m,r,p]
  def to_a
    return @result
  end
end
