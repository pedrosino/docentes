if defined? FactoryGirl
  #Dir[Rails.root.join('app/helpers/*.rb')].each { |f| require f }
  FactoryGirl::SyntaxRunner.send(:include, ApplicationHelper)
end
