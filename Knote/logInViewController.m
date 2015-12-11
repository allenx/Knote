//
//  logInViewController.m
//  Knote
//
//  Created by Allen X on 11/1/15.
//  Copyright © 2015 Allen X. All rights reserved.
//

#import "logInViewController.h"
#import "MDButton.h"
#import "userInfo.h"
@interface logInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)logIn:(id)sender;


@end

@implementation logInViewController
@synthesize username;
@synthesize password;

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)dismissKeyboard {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn: (UITextField *)infos {
    if(infos == self.password){
        [infos resignFirstResponder];
    }
    if(infos == self.username){
        [self.password becomeFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logIn:(id)sender {
}


@end
