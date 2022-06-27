//
//  ChatCell.h
//  Parse_Chat
//
//  Created by Myles Block on 6/26/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *givenChatMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *givenChatUser;

@end

NS_ASSUME_NONNULL_END
