

Pod::Spec.new do |spec|
spec.name             = 'MPC_CharacterLimitedTextField'
spec.version          = '0.1.0'
spec.summary          = 'A UITextField subclass that limits text input to a defined output width.'
spec.description      = 'This CocoaPod allows you to limit user-inputted text in a UITextField to a specific width. This width will likely be the width of any tableViewCell label you will be printing to. This UITextField subclass accounts for different font widths amd can handle emoji and 2-step input languages such as Japanese or Chinese.'

spec.homepage         = 'https://github.com/fareast555/MPC_CharacterLimitedTextField'
spec.license          = { :type => 'BSD', :file => 'license.txt' }
spec.author           = { 'Mike Critchley' => 'critchley55@yahoo.co.jp' }
spec.source           = { :git => 'https://github.com/fareast555/MPC_CharacterLimitedTextField.git', :tag => spec.version.to_s }


spec.ios.deployment_target = '9.0'
spec.requires_arc = true


spec.source_files = 'MPC_CharacterLimitedTextField/MPC_MaxCharacterLimitedTextField.{h,m}'

spec.frameworks = 'UIKit'
end
