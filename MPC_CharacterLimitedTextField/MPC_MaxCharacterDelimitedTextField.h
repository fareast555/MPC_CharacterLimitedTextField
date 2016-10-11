//
//  MPC_MaxCharacterDelimitedTextField.h
//  Commigo
//
//  Created by Michael Critchley on 5/22/16.
//  Copyright © 2016 Michael Critchley. All rights reserved.
/*
 This text entry field harvests text of any language, including emojis and 2-stage entry languages such as Japanese. This class tests for size fit (vs. character count) and thus REQUIRES the width of the target label as well as the size and if possible font/weight that will be used in the target label.
 
 1. Subclass your UITextView in storyboard to this class.
 
 2. It is convenient to set a private property to the IBOutlet in your parent class:
 @property (strong, nonatomic) MPC_MaxCharacterDelimitedTextField *MPC_textField;
 
 MPC_MaxCharacterDelimitedTextField *textfield = (MPC_MaxCharacterDelimitedTextField *)self.textField;
 
 3. Once your parent view is called, set the width of the target label to which you wish to limit the text length and also set the font as closely as possible to the font that will be used in the target label with the public method. Eg:

 [self.MPC_textField configureSizingLabelWithWidth:176 fontWithSize:[UIFont systemFontOfSize:13.5 weight:UIFontWeightMedium]];
 
 4. The "MPC_TextFieldDelegate" property provides callbacks to the parent class. 
*/

#import <UIKit/UIKit.h>

@class MPC_MaxCharacterDelimitedTextField;

@protocol MPC_MaxCharacterDelimitedTextFieldDelegate <UITextFieldDelegate>

// ** Tells the parent class (with the IBOutlet) that editing will begin
@required
- (void) MPC_TextFieldWillBeginEditing:(MPC_MaxCharacterDelimitedTextField *)textField;

//With each character tapped, returns the entire textfield.text value
- (void) userDidEnterText:(NSString *)updatedText MPC_textField:(UITextField *)MPC_textField;

@end


@interface MPC_MaxCharacterDelimitedTextField : UITextField

@property (assign, nonatomic) BOOL callbackIsImmediate;
@property (weak, nonatomic) id<MPC_MaxCharacterDelimitedTextFieldDelegate>MPC_TextFieldDelegate;

- (void) displayTextOnLoad:(NSString *)displayText;
- (void) outPutTextFitToLabelWithWidth:(CGFloat)width fontWithSize:(UIFont *)font;

@end
