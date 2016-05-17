class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :unidades

  attr_accessor :current_user

  def pode_publicar_edital?
    tipo == 'p'
  end

  def pode_publicar_normas?
    tipo == 'p' || tipo == 'u'
  end

  def pode_publicar_resultado?
    tipo == 'p' || tipo = 'd'
  end
end
