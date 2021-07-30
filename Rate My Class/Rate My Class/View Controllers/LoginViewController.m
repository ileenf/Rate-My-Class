//
//  LoginViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/12/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameLoginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordLoginField;
@property (weak, nonatomic) IBOutlet UITextField *usernameSignupField;
@property (weak, nonatomic) IBOutlet UITextField *passwordSignupField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)handleLogin:(id)sender {
    NSString *username = self.usernameLoginField.text;
    NSString *password = self.passwordLoginField.text;
    
    if ([self.usernameLoginField.text isEqual:@""] || [self.passwordLoginField.text isEqual:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Failed"
                                                                       message:@"Bad or missing username/password"
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *TryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                 style:UIAlertActionStyleCancel
                                                               handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:TryAgainAction];
        
        [self presentViewController:alert animated:YES completion:^{}];
    }
        
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Failed"
                                                                           message:@"Invalid username/password"
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *TryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                     style:UIAlertActionStyleCancel
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                              }];
            [alert addAction:TryAgainAction];
            
            [self presentViewController:alert animated:YES completion:^{
            }];
        } else {
            [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
        }
    }];
}

- (IBAction)handleSignUp:(id)sender {
    PFUser *newUser = [PFUser user];
        
    newUser.username = self.usernameSignupField.text;
    newUser.password = self.passwordSignupField.text;
    
    if ([self.usernameSignupField.text isEqual:@""] || [self.passwordSignupField.text isEqual:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign up Failed"
                                                                       message:@"Bad or missing username/password"
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *TryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                          }];
        [alert addAction:TryAgainAction];
        
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign up Failed"
                                                                               message:@"Already existing username/password"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *TryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                         style:UIAlertActionStyleCancel
                                                                       handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:TryAgainAction];
                
                [self presentViewController:alert animated:YES completion:^{
                }];
            }
        }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
