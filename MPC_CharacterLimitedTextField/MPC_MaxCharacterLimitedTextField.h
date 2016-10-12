//
//  MPC_MaxCharacterDelimitedTextField.h
//  Commigo
//
//  Created by Michael Critchley on 5/22/16.
//  Copyright © 2016 Michael Critchley. All rights reserved.
/*
 This text entry field harvests text of any language, including emojis and 2-stage entry languages such as Japanese. This class tests for size fit (vs. character count) and thus REQUIRES the width of the target label as well as the size and if possible font/weight that will be used in the target label.
 
 1. Subclass your UITextView in storyboard to this class, and create an IBOutlet to its view controller
 
 2. Implement the delegate methods, observe the protocol, and set the MPC_TextFieldDelegate
 
 3. Set the width of the target label to which you wish to limit the text length and also set the font as closely as possible to the font that will be used in the target label with the public method. Eg:

 [self.MPC_textField configureSizingLabelWithWidth:176 fontWithSize:[UIFont systemFontOfSize:13.5 weight:UIFontWeightMedium]];
 
 4. Set the callbackIsImmediate BOOL to YES if you want a callback for every character input.
 
 Hope you find the class useful! 
*/

#import <UIKit/UIKit.h>

@class MPC_MaxCharacterLimitedTextField;

@protocol MPC_MaxCharacterLimitedTextFieldDelegate <UITextFieldDelegate>
@required
- (void) MPC_UserDidEnterText:(NSString *)updatedText MPC_textField:(MPC_MaxCharacterLimitedTextField *)MPC_textField;

@optional
- (void) MPC_TextFieldWillBeginEditing:(MPC_MaxCharacterLimitedTextField *)MPC_textField;
- (void) MPC_InputDoesNotExceedTextField:(MPC_MaxCharacterLimitedTextField *)MPC_textField;
- (void) MPC_InputDidExceedTextField:(MPC_MaxCharacterLimitedTextField *)MPC_textField;
@end


@interface MPC_MaxCharacterLimitedTextField : UITextField

@property (assign, nonatomic) BOOL callbackIsImmediate;
@property (weak, nonatomic) id<MPC_MaxCharacterLimitedTextFieldDelegate>MPC_TextFieldDelegate;

- (void) displayTextOnLoad:(NSString *)displayText;
- (void) outPutTextFitToLabelWithWidth:(CGFloat)width fontWithSize:(UIFont *)font;

@end
