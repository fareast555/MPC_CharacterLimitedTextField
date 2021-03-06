# MPC_CharacterLimitedTextField
Limits text input to a defined output width, accounting for emoji and special input languages such as Japanese or Chinese.

This repository is an Objective-C Xcode project that contains the class files and that will allow you to demo the input field. Give it a try!

![Text Limited](https://github.com/fareast555/MPC_CharacterLimitedTextField/blob/master/textLimited.png)

The MPC_CharacterLimitedTextField is UITextField subclass that allows the user to enter characters only up to a specified output width. This class is useful if you want to input names, short descriptions, and so on that will be displayed in a label of limited width. For example, you may want to input a string in one view that will be displayed in a UITableViewCell on one line with limited horizontal space. This class allows you to specify exactly how many points of horizontal width your display label will have as well as the expected output font and size, and this textfield will do the rest. 

This text field is not based on character count, which breaks down with emoji, other languages -- not all languages are of the same width -- and languages such as Japanese that require a two-step input process. This class is based solely on length, so it will allow any character type up to an output length you specify in your view controller.

Using the callbackIsImmediate flag, you can receive a delegate callback for each character as typed. If set to NO, the class will return the final string to the delegate when the user clicks the keyboard return key.


## Requirements

* iOS 9.0+
* ARC

## Installation

Download this repo and find the MPC_CharacterLimitedTextField{.h/.m} files or

### [CocoaPods](https://cocoapods.org/)

````ruby
# For latest release, add this to your podfile
pod 'MPC_CharacterLimitedTextField', '~> 1.1.0'
````

<h3>To use as a subclass in Storyboard (read below for alternatives):</h3>


1. Import the .h file into the class that will have the IBOutlet for the target UITextField.

2. In Storyboard > Identity Inspector > Custom Class, select the MPC_CharacterLimitedTextField class from the pull down. 

3. Create an IBOutlet from storyboard to your view controller.

4. To get delegate callbacks, add the delegate protocol. For example:
  ```objectivec
   @interface ViewController ()\<MPC_CharacterDelimitedTextFieldDelegate>
``` 

5. Set the delegate in viewDidLoad:
  ```objectivec
   self.inputTextField.MPC_TextFieldDelegate = self;
```

6. In viewDidLoad, tell the class the maximum width your output label will be, and give the font and size you will be using. For example, to specify an output label width of 180 points across, at a system font size of 14, medium weight: 
 ```objectivec
   [self.inputTextField outPutTextFitToLabelWithWidth:180 
    fontWithSize:[UIFont systemFontOfSize14  weight:UIFontWeightMedium]];
```

7. Use self.inputTextField.callbackIsImmediate = YES; to get a callback with each character tapped. NO to only get a callback when the user presses "return" on the keyboard (or resigns first responder);

8. Implemement the delegate methods (see below)


<h3>Delegate:</h3>
The MPC_CharacterDelimitedTextFieldDelegate has four callback methods. Only one is required.

 ```objectivec
   @required
   - (void) MPC_UserDidEnterText:(NSString *)updatedText MPC_textField:(MPC_CharacterLimitedTextField *)MPC_textField;
   @optional
    - (void) MPC_TextFieldWillBeginEditing:(MPC_CharacterLimitedTextField *)MPC_textField;
    - (void) MPC_InputDoesNotExceedTextField:(MPC_CharacterLimitedTextField *)MPC_textField;
    - (void) MPC_InputDidExceedTextField:(MPC_CharacterLimitedTextField *)MPC_textField;
```


The optional methods are there to advise you of main events. MPC_InputDidExceedTextField may be useful if you have a just-in-time visual cue that you want to show when the user is trying to enter text that goes beyond the maximum length. 

<h3>To cast on an existing UITextField Storyboard IBOutlet:</h3>

1. Add a property of this class. 
 ```objectivec
    @property (weak, nonatomic) IBOutlet UITextField *textField; //Your existing text field
    @property (strong, nonatomic) MPC_CharacterDelimitedTextField *MPC_textField;
```

2. In Storyboard > Identity Inspector > Custom Class, select the MPC_CharacterLimitedTextField class from the pull down.

To cast this class on an existing UITextField, if you create a MPC_CharacterLimitedTextField property called MPC_textField (for example), you could use it to cast your existing UITextField: 
 ```objectivec
  self.MPC_textField = (MPC_CharacterLimitedTextField *)self.textField;
```


Hope you find this class useful!
