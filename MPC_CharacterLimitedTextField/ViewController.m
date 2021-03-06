//
//  ViewController.m
//  MPC_CharacterLimitedTextField
//
//  Created by Michael Critchley on 10/10/16.
//  Copyright © 2016 Michael Critchley. All rights reserved.
//

#import "ViewController.h"
#import "MPC_CharacterLimitedTextField.h"

@interface ViewController ()<MPC_CharacterLimitedTextFieldDelegate>

//Storyboard Outlets
@property (weak, nonatomic) IBOutlet MPC_CharacterLimitedTextField *inputTextField;
@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageToUser;

@property (nonatomic, assign) CGFloat maximumLabelWidth;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///--------------------------------------
    #pragma - Set the expected width of the view where you will later display the input
    ///--------------------------------------
    self.maximumLabelWidth = 100;
    
    //Set the MPC_MaxCharacterDelimitedTextFieldDelegate if you wish to receive callbacks
    self.inputTextField.MPC_TextFieldDelegate = self;
    
    //Instruct the field the maximum size of label you will need.
    //**CHANGE THIS FONT to the font you will use in the view that will display this input
    [self.inputTextField outPutTextFitToLabelWithWidth:self.maximumLabelWidth
                                          fontWithSize:[UIFont systemFontOfSize:14
                                                                         weight:UIFontWeightMedium]];
    
    // Gets text with each character entered.
    // Comment this out to only get a callback when user hits "Return"
    self.inputTextField.callbackIsImmediate = YES;

    //Configure Demo App UI
    [self _configureLabels];

}

- (void)_configureLabels
{
    self.inputTextField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.inputTextField.layer.borderWidth = 0.5;
    self.inputTextField.layer.cornerRadius = 8.0;
    self.outputLabel.text = @" "; //A space prevents autolayout from collapsing the label
    self.warningLabel.alpha = 0;
    self.warningLabel.text = @"Text field input maximum reached";
    self.messageToUser.text = [NSString stringWithFormat:@"Message being limited to %0.0f points. Go to ViewController.m viewDidLoad to change this width", self.maximumLabelWidth];
}

- (IBAction)screenWasTapped:(id)sender {
    
    [self.inputTextField resignFirstResponder];
}


#pragma mark - MPC_MaxCharacterDelimitedTextFieldDelegate Methods

//This method is triggered when the text field becomes first responder
- (void) MPC_TextFieldWillBeginEditing:(MPC_CharacterLimitedTextField *)MPC_textField
{

}

//This method returns the entire textfield.text value and a reference to the text field.
- (void) MPC_UserDidEnterText:(NSString *)updatedText MPC_textField:(MPC_CharacterLimitedTextField *)MPC_textField
{
    if ([updatedText isEqualToString:@""]) {
        updatedText = @" "; //Maintains height of textfield in view
    }
    self.outputLabel.text = updatedText;
}

//This method does not mean there is room in the field. Only that the user has not tried to go over limit.
- (void) MPC_InputDoesNotExceedTextField:(MPC_CharacterLimitedTextField *)MPC_textField
{
    [UIView animateWithDuration:0.5 animations:^{
        self.warningLabel.alpha = 0;
    }];
}

//This method is triggered when the user tries to enter text that is refused as input.
- (void) MPC_InputDidExceedTextField:(MPC_CharacterLimitedTextField *)MPC_textField
{
    if (self.warningLabel.alpha == 0) [self _animateNewText];
    else [self _reanimateText];
}


#pragma mark - UIAnimation of warning label (Bling)
- (void)_animateNewText
{
    //Set the warning label to 0.4 of its current size
    self.warningLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
    
    //Transform animate the label into view
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        
        self.warningLabel.alpha = 1;
        self.warningLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        
    }completion:^(BOOL finished){ }];

}

- (void)_reanimateText
{
    //Fade warning label out and back in
    [UIView animateWithDuration:0.2 animations:^{
        self.warningLabel.alpha = 0.4;
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            self.warningLabel.alpha = 1.0;
        }completion:^(BOOL finished2){ }];
    }];
}




@end
