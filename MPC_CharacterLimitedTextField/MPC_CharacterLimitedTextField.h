//
// MPC_CharacterLimitedTextField.h

// Created by Mike Critchley on 5/22/16.
// Copyright (c) 2017, Mike Critchley. All rights reserved.
 
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
// 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
// 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



/**
 This UITextField subclass harvests text of any language, including emojis and 2-stage entry languages such as Japanese. This class tests for size fit (vs. character count) and thus REQUIRES the width of the target label as well as the size and if possible font/weight that will be used in the target label.
    
 Subclass your UITextField in storyboard to this class, and create an IBOutlet to its view controller. Or you can cast an existing outlet using (MPC_CharacterLimitedTextField *)self.myExistingTextField
 
 Demo app and ReadMe at: https://github.com/fareast555/MPC_CharacterLimitedTextField
*/

#import <UIKit/UIKit.h>

@class MPC_CharacterLimitedTextField;

@protocol MPC_CharacterLimitedTextFieldDelegate <UITextFieldDelegate>
@required
/**
//Sends back the textfield after each user entry is confirmed and set to the textfield.
*/
- (void) MPC_UserDidEnterText:(NSString *)updatedText MPC_textField:(MPC_CharacterLimitedTextField *)MPC_textField;

@optional
/**
//Called when the textfield becomes first responder.
*/
- (void) MPC_TextFieldWillBeginEditing:(MPC_CharacterLimitedTextField *)MPC_textField;

/**
//Pings back each time an entry is within bounds.
*/
- (void) MPC_InputDoesNotExceedTextField:(MPC_CharacterLimitedTextField *)MPC_textField;

/**
//Pings back each time user tries to enter some text that doesn't fit.
*/
- (void) MPC_InputDidExceedTextField:(MPC_CharacterLimitedTextField *)MPC_textField;
@end


@interface MPC_CharacterLimitedTextField : UITextField

/**
 After [[MPC_CharacterLimitedTextField] alloc] init], set self.myField.MPC_TextFieldDelegate = self.
 */
@property (weak, nonatomic) id<MPC_CharacterLimitedTextFieldDelegate>MPC_TextFieldDelegate;

/**
 Set callbackIsImmediate to YES to get an update to the delegate with each character(s) entered. NO will return the textfield when the user presses DONE (SEND etc) on the keyboard.
 */
@property (assign, nonatomic) BOOL callbackIsImmediate;

/**
 Call this public method before the user interacts with the field to set the WIDTH of the textfield you will eventually need to output to. For example, if you are collecting text in one part of your app that is to be displayed in a UITableViewCell with a label whose max width will likely be 175 points or less, with a system font of size 13.5, call: [self.MPC_textField outPutTextFitToLabelWithWidth:176 fontWithSize:[UIFont systemFontOfSize:13.5 weight:UIFontWeightMedium]];
*/
- (void) outPutTextFitToLabelWithWidth:(CGFloat)width fontWithSize:(UIFont *)font;

/**
 Call this public method to pre-load any existing user-generated text you already have.
 This is not placeholder text. To set a placeholder: self.myField.placeholder = @"some text";
*/
- (void) displayTextOnLoad:(NSString *)displayText;



@end
