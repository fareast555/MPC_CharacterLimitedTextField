# MPC_CharacterLimitedTextField
Limits text input to a defined output width, accounting for emoji and special input languages such as Japanese or Chinese.


The MPC_CharacterLimitedTextField is UITextField subclass that will only allow the user to enter characters up to a point specified in the parent class. This class is useful if you want to input names, short descriptions, and so on that will be displayed in a label of limited width. For example, you may want to input a string in one view that will be displayed in a UITableViewCell on one line with limited horizontal space. This class allows you to specify exactly how many pixels of horizontal display space you have, and this field will do the rest. 

This text field is not based on character count, which breaks down with emoji, other languages -- not all languages are of the same width -- and languages such as Japanese that require a two-step input process. This class is based solely on length, so it will allow any character type up to an output length specifid by the user.

You also have the option of setting the <span style=“color:green” callbackIsImmediate> </span> flag to YES to recieve callbacks for each character as typed. If set to NO, the class will return the final string to the delegate.

This class is designed to be subclassed in Storyboard, but can also be used with an existing Storyboard textfield by casting onto the Textfield.


<h3>To use as a subclass in Storyboard (read below for alternatives):</h3>

1. Locate and copy the MPC_CharacterLimitedTextField.h and .m files. in this repo (or from the downloaded / cloned repo) at: MPC_NotificationDemo > MPC_NotificationFiles

2. Import the .h file into the class that has the IBOutlet for the target UITextField.

3. I



<h3>Delegate:</h3>

Pass nil as the image argument if you want only text.

Pass nil for the background color if you want the default burgundy color

Pass nil for the text color for white text

**Don't forget to display the view after creating it. The view is added to the view hierarchy when instantiated and is not deallocated until after it has been displayed 

