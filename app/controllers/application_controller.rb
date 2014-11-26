# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  before_filter :esta_ativo

  layout :layout_by_resource

  @@page = 15
  @@cadastrar = true

	

	def layout_by_resource
	  if devise_controller? && resource_name == :user && action_name == "edit"
	    "application"
	  elsif devise_controller? && resource_name == :user && action_name == "new"
	  	"layout_name_for_devise"
	  else
	    "application"
	  end
	end

	def esta_ativo
  	if user_signed_in?
			if current_user.ativo == false
				flash[:info] = "Você não esta mais ativo! Contate o administrador do sistema para reativar sua conta"
				sign_out(current_user)
				redirect_to root_url
			elsif current_user.ativo == true and current_user.mudar_senha == true
				flash[:info] = "Você Precisa Mudar a Sua Senha. Sua Senha Atual é: mudarsenha"
				redirect_to edit_usuario_path(current_user)	
			end
		end
	end

	def after_sign_in_path_for(resource_or_scope)
  	home_index_path
  end

	protected
	rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.home_nao_autorizado_url
  end


end
