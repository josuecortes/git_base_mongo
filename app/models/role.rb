class Role
  include Colunas
  include Mongoid::Document
  include Mongoid::Timestamps
  include ScopedSearch::Model
  
  field :nome, type: String
  field :sigla, type: String
  field :descricao, type: String

  has_and_belongs_to_many :users
end
