require 'openregister'

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

    redirect_to controller: 'data', action: 'summary'
  end

  def summary()
    @register = session[:register]
    @field = session[:fieldName]
    @pickerData = PickerDataService.new().generate(@register['_uri'], @field)

    render "summary"
  end

  def initializeRegisters()
    @registers = OpenRegister.registers :discovery
    @registers.concat(OpenRegister.registers :alpha)
    @registers.concat(OpenRegister.registers :beta)
  end
end
