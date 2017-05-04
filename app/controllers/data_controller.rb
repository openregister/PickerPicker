require 'openregister'
require 'rubygems'
require 'zip'

class DataController < ApplicationController
  before_filter :initializeRegisters

  def getRegisters
    @mappedRegisters = @registers.map do |register|
      [register.register + ' (' + register.phase + ')', register.register + ':' + register.phase]
    end

    render "registers"
  end

  def getFields()
    @register = session[:register]
    @fields = @register['fields']

    render "fields"
  end

  def saveRegister()
    registerName = params[:registerName].split(':')[0]
    phase = params[:registerName].split(':')[1]

    session[:register] = @registers.select{|r| r.register == registerName && r.phase == phase}[0]

    redirect_to controller: 'data', action: 'getFields'
  end

  def saveField()
    session[:fieldName] = params[:fieldName]
    @register = session[:register]
    @field = session[:fieldName]
    @pickerData = PickerDataService.new().generate(@register['register'], @register['_uri'], @field)

    redirect_to controller: 'data', action: 'preview'
  end

  def preview()
    @register = session[:register]
    @field = session[:fieldName]

    render "preview"
  end

  def download()
    @pickerHtml = File.read(Rails.root.join("app", "assets", "static", "picker.html"))
    @pickerData = File.read(Rails.root.join("app", "assets", "static", "picker-data.json"))

    render "download"
  end

  def downloadZip()
    filesToZip = ["picker.html", "picker-data.json"]
    source = "/Users/karlbaker/RubymineProjects/Firebreak/app/assets/static"
    zipFileName = "code.zip"
    file = Tempfile.new(zipFileName)

    Zip::File.open(file.path, Zip::File::CREATE) do |zipFile|
      filesToZip.each do |filename|
        zipFile.add(filename, source + '/' + filename)
      end
    end

    zip_data = File.read(file.path)
    send_data(zip_data, :type => 'application/zip', :filename => zipFileName)
  end

  def confirmation()
    render "confirmation"
  end

  def summary()
    @register = session[:register]
    @field = session[:fieldName]
    @pickerData = PickerDataService.new().generate(@register['register'], @register['_uri'], @field)

    render "summary"
  end

  def initializeRegisters()
    @registers = OpenRegister.registers :beta
    @registers.concat(OpenRegister.registers :alpha)
    @registers.concat(OpenRegister.registers :discovery)
  end
end
