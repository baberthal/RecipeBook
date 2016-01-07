# Uncomment this line to define a global platform for your project
platform :osx, '10.11'
# Uncomment this line if you're using Swift
# use_frameworks!

def testing_pods
  pod 'Expecta', '~> 1.0.0'
end

def shared_pods
  pod 'CocoaLumberjack', '~> 2.2.0'
end


target 'RecipeBook' do
  shared_pods
end

target 'RecipeBookTests' do
  shared_pods
  testing_pods
end

