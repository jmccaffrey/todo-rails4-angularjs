
module Rack
     class JSONP

        def call(env)
      # remove the callback and _ parameters BEFORE calling the backend, so
      # that caching middleware does not store a copy for each value of the
      # callback parameter
      Rails.logger.debug("here I am!")
      puts "for real"
      request = Rack::Request.new(env)
      callback = request.params.delete(@callback_param)
      puts "callback #{callback}"
      timestamp = request.params.delete(@timestamp_param)
      env['QUERY_STRING'] = env['QUERY_STRING'].split("&").delete_if{|param|
        param =~ /^(#{@timestamp_param}|#{@callback_param})=/
      }.join("&")
      env['rack.jsonp.callback'] = callback
      env['rack.jsonp.timestamp'] = timestamp


      puts "content type #{headers['Content-Type']}"
      status, headers, response = @app.call(env)

      if callback && headers['Content-Type'] =~ /json/i
        response = pad(callback, response)
        headers['Content-Length'] = response.first.bytesize.to_s
        headers['Content-Type'] = 'application/javascript'
      elsif @carriage_return && headers['Content-Type'] =~ /json/i
        # add a \n after the response if this is a json (not JSONP) response
        response = carriage_return(response)
        headers['Content-Length'] = response.first.bytesize.to_s
      end

      [status, headers, response]
    end

    end
end

ActiveSupport.on_load(:active_model_serializers) do
  # Disable for all serializers (except ArraySerializer)
  ActiveModel::Serializer.root = false

  # Disable for ArraySerializer
  ActiveModel::ArraySerializer.root = false
end
