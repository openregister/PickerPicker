require 'openregister'

class DataController < ApplicationController
  before_filter :initializeRegisters

  def index

  end

  def getRegistersForSelect
    @mappedRegisters = @registers.map do |register|
      [register.register + ' (' + register.phase + ')', register.register + ':' + register.phase]
    end

    render "registersForSelect"
  end

  def getFields()
    @register = session[:register]
    @fields = @register['fields']

    render "fields"
  end

  def saveRegister()
    registerName = params[:registerName].split(':')[0]
    phase = params[:registerName].split(':')[1]

    # @registers = OpenRegister.registers(phase)
    # session[:phase] = params[:registerName]['phase']
    session[:register] = @registers.select{|r| r.register == registerName && r.phase == phase}[0]

    redirect_to controller: 'data', action: 'getFields'
  end

  def initializeRegisters()
    @registers = OpenRegister.registers :discovery
    @registers.concat(OpenRegister.registers :alpha)
    @registers.concat(OpenRegister.registers :beta)
  end
end
