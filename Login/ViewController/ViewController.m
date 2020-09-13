//
//  ViewController.m
//  Login
//
//  Created by 이명재 on 2020/08/05.
//  Copyright © 2020 databaseSample. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnKakao;
@property (weak, nonatomic) IBOutlet UIButton *btnNaver;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UILabel *ab = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
//    [ab setText:@"테스트"];
//    [self.view addSubview:ab];
//
//    UIView *v = [[UIView alloc] init];
//    [v setFrame:CGRectMake(100, 100, 200, 200)];
//    [v setBackgroundColor:[UIColor colorNamed:@"azure"]];
//    [self.view addSubview:v];
    
    [self.btnLogin setTitle:@"로그인 이동" forState:UIControlStateNormal];
    
    self.navigationItem.title = @"로그인";
}

@end
