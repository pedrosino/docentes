class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :unidades

  attr_accessor :current_user

  def admin?
    tipo == 'a'
  end

  def pode_criar_edital?
    tipo == 'p' || admin?
  end

  def pode_publicar_normas?
    tipo == 'p' || tipo == 'u' || admin?
  end

  def pode_publicar_resultado?
    tipo == 'p' || tipo == 'd' || admin?
  end

  def pode_criar_area?
    tipo == 'p' || tipo == 'u' || admin?
  end

  def pode_criar_unidade?
    tipo == 'p' || admin?
  end
end
