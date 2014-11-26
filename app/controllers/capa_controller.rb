class CapaController < ApplicationController
  
  layout "capa"
  skip_before_filter :authenticate_user!
  skip_before_filter :esta_ativo

  def index
  end

  def show
  end

  def nao_ativo

  end
end
