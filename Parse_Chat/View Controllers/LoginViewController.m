//
//  ViewController.m
//  Parse_Chat
//
//  Created by Myles Block on 6/26/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;


@end

@implementation LoginViewController
//TODO: ADD Alert Controllers for username password incorrect, duplicate user etc.
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}


- (IBAction)registerUser:(id)sender {
    
    // initialize a user object
    if([self.usernameField.text isEqual:@""] || [self.emailField.text isEqual:@""] || [self.passwordField.text isEqual:@""])
    {
        [self triggerAlert];
    }
    else{//Creates new User if fields are entered
        PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.username = self.usernameField.text;
        newUser.email = self.emailField.text;
        newUser.password = self.passwordField.text;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];//transfers to loginSegue
            }
        }];
        
    }
    
}


- (IBAction)loginUser:(id)sender {
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""])
    {
        [self triggerAlert];
    }
    else
    {//Logins new User if fields are correct
        NSString *username = self.usernameField.text;
            NSString *password = self.passwordField.text;
            
            [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
                if (error != nil) {
                    NSLog(@"User log in failed: %@", error.localizedDescription);
                } else {
                    NSLog(@"User logged in successfully");
                    
                    // display view controller that needs to shown after successful login
                    [self performSegueWithIdentifier:@"loginSegue" sender:nil];//transfers to loginSegue
                }
            }];
        
    }
    
}



- (void)triggerAlert {//function for alert controller
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Fields"
                                                                               message:@"Make sure the correct fields are non empty"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                      }];
    
    [alert addAction:cancelAction];//puts all of it together
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
    
}
@end
