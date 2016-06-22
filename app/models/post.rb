class Post < ActiveRecord::Base
  def slug
    (titulo + data.to_s).parameterize
  end
end
