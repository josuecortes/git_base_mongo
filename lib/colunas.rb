# -*- encoding : utf-8 -*-
module Colunas
	extend ActiveSupport::Concern
	#attr_accessor :name, :type

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

		def set_columns
			excluded_column_names = %w[id created_at updated_at _id _type created_at]
			self.fields.collect{|c| c[1]}.reject{|c| excluded_column_names.include?(c.name) }.each do |c|
				instance_variable_set("@#{c.name}", c.type) unless c.nil?
			end
		end

		def columns
			ary = []
            excluded_column_names = %w[id created_at updated_at _id _type created_at]
			self.fields.collect{|c| c[1]}.reject{|c| excluded_column_names.include?(c.name) }.each do |c|
				ary.append(MongoDBColumn.new(:name => c.name, :type => c.type.to_s.downcase)) unless c.nil?
			end
			return ary
		end
	end
end



