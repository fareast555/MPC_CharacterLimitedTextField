//
//  MPC_CharacterLimitedTextField.m

// Created by Mike Critchley on 5/22/16.
// Copyright (c) 2017, Mike Critchley. All rights reserved.

//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

// 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

// 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "MPC_CharacterLimitedTextField.h"

@interface MPC_CharacterLimitedTextField () <UITextFieldDelegate, UITextInputDelegate>
@property (strong, nonatomic) UILabel *sizingField;
@property (nonatomic, assign) CGFloat sizingFieldTargetWidth;

@end

@implementation MPC_CharacterLimitedTextField

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) return nil;
    
    self.delegate = self;
    return self;
}

- (void)outPutTextFitToLabelWithWidth:(CGFloat)width fontWithSize:(UIFont *)font
{
    //Set the properties of the dummy label to be used to test text-fit
    self.sizingFieldTargetWidth = width;
    self.sizingField = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 400, 30)];
    self.sizingField.font = font;
}

- (void) displayTextOnLoad:(NSString *)displayText //Public method
{
    self.text = displayText;
}


- (void)_resignResponderStatus:(NSNotification *)notification
{
    [self resignFirstResponder];
}

- (void)_informDelegateOfTextChange
{
    //Inform the delegate that there has been a change in the ActivtyName text
    [self.MPC_TextFieldDelegate MPC_UserDidEnterText:self.text MPC_textField:self];
}


#pragma mark - UITextFieldDelegateMethods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.MPC_TextFieldDelegate respondsToSelector:@selector(MPC_TextFieldWillBeginEditing:)]) {
        [self.MPC_TextFieldDelegate MPC_TextFieldWillBeginEditing:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self _informDelegateOfTextChange];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //1. Check for 2-stage text entry (eg. Japanese / Chinese).
    // This text change will be handled in the textInputDelegate below
    if (textField.markedTextRange != nil) {
        
        //Set the delegate to received callbacks for 2-stage text entry
        [self setInputDelegate:self];
        return YES;
    }
    
    // 2. Get a full string of what the resulting replacement will yield
    NSString *fullString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    // 3. Check if the text fits the target label
    if (![self _labelDoesEncloseString:fullString]) {
    
        // 4. If not, shave off as many characters as is required to fit
        fullString = [self _decomposeString:fullString];
        
        // 5. Set the label manually
        self.text = fullString;
        
        // 6. Inform delegate
        [self _informDelegateOfTextChange];
        
        //7. Inform delegate text limit exceeded
        if ([self.MPC_TextFieldDelegate respondsToSelector:@selector(MPC_InputDidExceedTextField:)]) {
            [self.MPC_TextFieldDelegate MPC_InputDidExceedTextField:self];
        }
        return NO;
    }
    
    if (self.callbackIsImmediate) {
        [self.MPC_TextFieldDelegate MPC_UserDidEnterText:fullString MPC_textField:self];
    }
    
    //Inform delegate that text is currently in bounds
    if ([self.MPC_TextFieldDelegate respondsToSelector:@selector(MPC_InputDoesNotExceedTextField:)]) {
        [self.MPC_TextFieldDelegate MPC_InputDoesNotExceedTextField:self];
    }
   
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //1. DONE or NEXT button on keyboard has been pressed. Resign 1st responder
    [textField resignFirstResponder];
    
    NSString *finalText = textField.text;
    
    if (![self _labelDoesEncloseString:finalText]) {
        
        // 4. If not, shave off as many characters as is required to fit
        finalText = [self _decomposeString:finalText];
        
        // 5. Set the label manually
        self.text = finalText;
    }
    
    //2. Inform delegate
    [self _informDelegateOfTextChange];
    
    return NO; //Returning NO to prevent adding an extra line to the text field.
}

#pragma mark - Custom methods: Checking if textsize fits and truncation to fit

- (BOOL)_labelDoesEncloseString:(NSString *)string
{
    [self.sizingField setFrame:CGRectMake(0, 0, 400, 30)];
    [self.sizingField setText:string];
    [self.sizingField sizeToFit];
    
    CGFloat resizeWidth = self.sizingField.frame.size.width;
    
    //Return no if the text doesn't fit the label
    if (resizeWidth > self.sizingFieldTargetWidth) {
        return NO;
    }
    
    return YES;
}

- (NSString *)_decomposeString:(NSString *)string //Only called if string does not fit
{
    //1. Create a block ivar to return
    __block NSString *finalString;
    
    //2. Reverse-enumerate the string
    [string enumerateSubstringsInRange:NSMakeRange(0,
                                                   [string length])
                               options:NSStringEnumerationByComposedCharacterSequences | NSStringEnumerationReverse
                            usingBlock:^(NSString *substring,
                                         NSRange substringRange,
                                         NSRange enclosingRange,
                                         BOOL *stop)
     {
        //3. Remove the final character length (to account for emoji/surrogate 16-bit chars etc)
        finalString = [string substringToIndex:[string length] - substring.length];
         
         //4. If the decomposed string now fits the label, stop the emumeration.
         if ([self _labelDoesEncloseString:finalString]) {
              *stop = YES;
        
         } else {
             
             //Call recursively until we get a string that fits
             finalString = [self _decomposeString:finalString];
             
             if ([self _labelDoesEncloseString:finalString]) {
                 *stop = YES;
             }
         }
     }];
    
    //5. Return the truncated string
    return finalString;
}


#pragma mark - UITextInputDelegate 
//These methods handle input of 2-stage input languages such as Japanese or Chinese

- (void)selectionDidChange:(id<UITextInput>)textInput //Called when 2-stage temporary marked text is confirmed
{
    //1. Does this text fit? If so, leave it. Otherwise, cut it.
    if (![self _labelDoesEncloseString:self.text]) {
        self.text = [self _decomposeString:self.text];
    }
    
    //2. Let the delegate know that we have updated the textField
    [self _informDelegateOfTextChange];
}

//Required methods included to silence warnings
- (void)textWillChange:(id<UITextInput>)textInput { }
- (void)selectionWillChange:(id<UITextInput>)textInput { }
- (void)textDidChange:(id<UITextInput>)textInput { }

@end
