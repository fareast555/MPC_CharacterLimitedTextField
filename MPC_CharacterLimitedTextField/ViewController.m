//
//  ViewController.m
//  MPC_CharacterLimitedTextField
//
//  Created by Michael Critchley on 10/10/16.
//  Copyright © 2016 Michael Critchley. All rights reserved.
//

#import "ViewController.h"
#import "MPC_MaxCharacterDelimitedTextField.h"

@interface ViewController ()<MPC_MaxCharacterDelimitedTextFieldDelegate>

//Storyboard Outlets
@property (weak, nonatomic) IBOutlet MPC_MaxCharacterDelimitedTextField *inputTextField;
@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set the MPC_MaxCharacterDelimitedTextFieldDelegate if you wish to receive callbacks
    self.inputTextField.MPC_TextFieldDelegate = self;
    
    //Instruct the field the maximum size of label you will need.
    [self.inputTextField outPutTextFitToLabelWithWidth:150 fontWithSize:[UIFont systemFontOfSize:13.5 weight:UIFontWeightMedium]];
    
    self.inputTextField.callbackIsImmediate = YES;
    
}

#pragma mark - MPC_MaxCharacterDelimitedTextFieldDelegate Required Methods
- (void) MPC_textFieldWillBeginEditing:(MPC_MaxCharacterDelimitedTextField *)textField
{
    NSLog(@"%s called", __FUNCTION__);
}

//With each character tapped, returns the entire textfield.text value
- (void) userDidEnterText:(NSString *)updatedText MPC_textField:(UITextField *)MPC_textField
{
       self.outputLabel.text = updatedText;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
