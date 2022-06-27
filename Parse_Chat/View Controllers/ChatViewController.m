//
//  ChatViewController.m
//  Parse_Chat
//
//  Created by Myles Block on 6/26/22.
//

#import "ChatViewController.h"
#import "Parse/Parse.h"
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *chatMessageField;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (strong, nonatomic) NSArray *postArray;

@end

@implementation ChatViewController


//TODO: Figure out how to get label to show in cell
//TODO: Still need to set label to back info for cellforatRowIndexPath if needed...
//TODO: Check if queryArray is pushed right from PFObject of Arrays



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chatTableView.dataSource = self;//this connects the file to datasource methods
    self.chatTableView.delegate = self;//this helps connect file
    // Do any additional setup after loading the view.
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshView) userInfo:nil repeats:true];//every 1 second it calls the refresh function
    
    
}

- (IBAction)tapSendButton:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_FBU2021"];//creates chatMessage object derived from PFObject
    
    chatMessage[@"text"] = self.chatMessageField.text;//assigns text from field to chatMessage array
    
    
    //Calls saveInBackgrounWithBlock block from PFObject to save and store message
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (succeeded) {
                NSLog(@"The message was saved!");
                NSLog(@"%@", chatMessage[@"text"]);
                self.chatMessageField.text = @"";//clears textField
            } else {
                NSLog(@"Problem saving message: %@", error.localizedDescription);
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

- (void)refreshView {
    PFQuery *query = [PFQuery queryWithClassName:@"Message_FBU2021"];//creates a query with the name Message_FBU2021
//    [query whereKey:@"likesCount" greaterThan:@100];
    query.limit = 20;//query limit

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            [query orderByDescending:@"createdAt"];//order query by createdAt
            self.postArray = posts;
            
            [self.chatTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    

}


//MARK: Delegate Protocols

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];//allows reusing cells
    PFObject *pushedLabel = self.postArray[indexPath.row];
    cell.givenChatMessageLabel.text = pushedLabel[@"text"];//since not defined as a model, have to grab directly
//    NSLog(@"BELOW LIES TEST");
//    NSLog(@"%@", pushedLabel);
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postArray.count;
}

@end
