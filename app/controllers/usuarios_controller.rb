# -*- encoding : utf-8 -*-
class UsuariosController < ApplicationController
	load_and_authorize_resource :class=>"User"
  skip_before_filter :esta_ativo, only: [:edit, :update]
  # GET /usuarios
  # GET /usuarios.json
  def index
    #@usuarios = User.all.order_by([:email, :asc]).paginate(:page => params[:page], :per_page => @@page)
    @usuarios = User.accessible_by(current_ability).order_by([:email, :asc]).paginate(:page => params[:page], :per_page => @@page)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @usuarios }
    end
  end

  # GET /usuarios/new
  # GET /usuarios/new.json
  def new
    @usuario = User.new
    

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @usuario }
    end
  end

  # GET /usuarios/1/edit
  def edit
    @usuario = User.find(params[:id])
  end

  # POST /usuarios
  # POST /usuarios.json
  def create
    @usuario = User.new(params[:user])
    
    respond_to do |format|
      if @usuario.save
        flash[:success] = "Usuario criado com sucesso"
        format.html { redirect_to usuarios_url }
        format.json { render json: @usuario, status: :created, location: @usuario }
      else
        flash[:error] = "Erro ao criar o usuario"
        format.html { render action: "new" }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
        
      end
    end
  end

  # PUT /usuarios/1
  # PUT /usuarios/1.json
  def update
    @usuario = User.find(params[:id])

    respond_to do |format|
      if @usuario.update_attributes(params[:user])
        flash[:success] = "Usuario atualizado com sucesso"
        format.html { redirect_to usuarios_url }
        format.json { head :no_content }
      else
        flash[:error] = "Erro ao atualizar o usuario"
        format.html { render action: "edit" }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.json
  def destroy #  -----------------------------------> DESATIVAR / ATIVAR
    @usuario = User.find(params[:id])
    if @usuario.ativo == true
      @usuario.ativo = false
    else
      @usuario.ativo = true
    end
    if @usuario.save
      flash[:success] = "Operação realizada com sucesso"
    else
      flash[:success] = "Operação não foi realizada"
    end

    respond_to do |format|
      format.html { redirect_to usuarios_url }
      format.json { head :no_content }
    end
  end

  def redefinir_senha
    @usuario = User.find(params[:usuario_id])
    @usuario.password = @usuario.password_confirmation = "mudarsenha"
    if @usuario.save(:validate=>false)
      redirect_to usuarios_url, notice: 'Senha redefinida com sucesso. Nova Senha = mudarsenha'
    else
      redirect_to usuarios_url, alert: 'Senha não foi redefinida, favor checar o cadastro.'
    end
  end

  def permissoes
    @usuario = User.find(params[:usuario_id])
    @roles = Role.all.where(:id.in=>(@usuario.role_ids)).order_by([:nome, :asc])
    @roles_fora = Role.all.where(:id.nin => (@usuario.role_ids)).order_by([:nome, :asc])
      
  end

  def adicionar_permissao
    @usuario = User.find(params[:usuario_id])
    @role = Role.all.where(:id =>(params[:role_id]), :sigla.nin => (["MASTER"]))

    @usuario.roles << @role
    
    respond_to do |format|
      if @usuario.save
        flash[:success] = "Permissão adicionada com sucesso"
        format.html { redirect_to usuarios_path }
        format.json { head :no_content }
      else
        flash[:error] = "Erro ao adicionar permissão"
        format.html { render action: "permissoes" }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  def remover_permissao
    @usuario = User.find(params[:usuario_id])
    @role = @usuario.roles.find(params[:role_id])
    @usuario.roles.delete(@role)
    
    respond_to do |format|
      if @usuario.save
        flash[:success] = "Permissão removida com sucesso"
        format.html { redirect_to usuarios_path }
        format.json { head :no_content }
      else
        flash[:error] = "Erro ao remover permissão"
        format.html { render action: "permissoes" }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end



end


