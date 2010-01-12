class StaticController < ApplicationController
  @@views = {}

  Dir[File.join(File.dirname(__FILE__), "../views/*.erb")].each do |f|
    @@views[File.basename(f, '.erb')] = ERB.new(File.read(f))
  end

  before_start :check_file_exists

  def check_file_exists
    file = params[:file].present? ? params[:file] : 'index'

    if @@views.has_key?(file)
      @template = @@views[file]
      yield
    else
      halt 404
    end
  end

  def respond_with
    [200, {'Content-Type' => 'text/html'}]
  end

  def start
    render @template.result(binding)
    finish
  end
end
