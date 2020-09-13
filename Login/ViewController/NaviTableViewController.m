//
//  NaviTableViewController.m
//  Login
//
//  Created by 이명재 on 2020/08/10.
//  Copyright © 2020 databaseSample. All rights reserved.
//

#import "NaviTableViewController.h"
#import "ViewController.h"
#import "NaviCollectionViewController.h"

@interface NaviTableViewController ()
@property (strong, nonatomic) NSMutableArray *arrAddress;
@end

@implementation NaviTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"메인";
    UIBarButtonItem *loginBtn = [[UIBarButtonItem alloc] initWithTitle:@"로그인"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(moveToLoginVC)];
    [self.navigationItem setRightBarButtonItem:loginBtn];
    
    self.arrAddress = [[NSMutableArray alloc] init];
    [self requestListData];
    
//    NSArray *name = @[@"가",@"나",@"다",@"라"];
//    NSArray *bgColor = @[[UIColor redColor],[UIColor orangeColor],[UIColor blueColor],[UIColor yellowColor]];
//
//    self.arrAddress = [[NSMutableArray alloc] init];
//    for (int i = 0; i < name.count; i++) {
//        NSDictionary *dic = @{@"name":name[i],
//                              @"bgColor":bgColor[i]
//        };
//        [self.arrAddress addObject:dic];
//    }
    
//    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)requestListData {
    NSURL *url = [NSURL URLWithString:@"http://demo1914380.mockable.io/api/list"];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSURLSession *session  = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            NSError *err = nil;
            NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            NSMutableArray *list = responseJson[@"list"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.arrAddress = list;
                [self.tableView reloadData];
            });
        }else{
            NSLog(@"error!");
        }
    }];
    [dataTask resume];
}

- (void)moveToLoginVC {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *vc = (ViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        if (self.arrAddress && self.arrAddress.count > 0) {
            return self.arrAddress.count;
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NaviTableCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"indexPath [section:%ld][row:%ld]",(long)indexPath.section, (long)indexPath.row];
    return cell;
     */
    
    NaviTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NaviTableViewCell class])];
//    if (indexPath.section == 0) {
//        cell.lbName.text = @"Move CollectionView";
//        cell.imgMember.hidden = YES;
//    }else {
//        NSDictionary *dic = [self.arrAddress objectAtIndex:indexPath.row];
//        cell.lbName.text = dic[@"name"];
//        cell.imgMember.backgroundColor = [UIColor yellowColor];
//    }
//
//    return cell;
    
    if (indexPath.section == 0) {
        cell.imgMember.hidden = YES;
        cell.lbName.text = @"Move CollectionView";
    }else{
        if (self.arrAddress && self.arrAddress.count > 0) {
            NSDictionary *dic = [self.arrAddress objectAtIndex:indexPath.row];
            cell.lbName.text = dic[@"name"];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSURL *imgUrl = [NSURL URLWithString:dic[@"logoUrl"]];
                NSData *imgData = [[NSData alloc] initWithContentsOfURL:imgUrl];
                cell.imgMember.image = [UIImage imageWithData:imgData];
            });
            
            
            
//            dispatch_async(dispatch_get_global_queue(0,0), ^{
//                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: dic[@"logoUrl"]]];
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (data == nil) {
//                        cell.imgMember.backgroundColor = [UIColor grayColor];
//                    }else{
//                        cell.imgMember.image = [UIImage imageWithData:data];
//                    }
//                });
//            });
//            cell.imgMember.backgroundColor = dic[@"bgColor"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NaviCollectionViewController *vc = (NaviCollectionViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:NSStringFromClass([NaviCollectionViewController class])];
            [vc bindingData:self.arrAddress];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        NSDictionary *dic = [self.arrAddress objectAtIndex:indexPath.row];
        NSString *url = dic[@"url"];
        UIApplication *app = [UIApplication sharedApplication];
        [app openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"open success!");
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"first section";
    }else{
        return @"second section";
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation NaviTableViewCell

@end
