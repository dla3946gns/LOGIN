//
//  NaviTableViewController.h
//  Login
//
//  Created by 이명재 on 2020/08/10.
//  Copyright © 2020 databaseSample. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NaviTableViewController : UITableViewController

@end

@interface NaviTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgMember;
@property (weak, nonatomic) IBOutlet UILabel *lbName;

@end

NS_ASSUME_NONNULL_END
