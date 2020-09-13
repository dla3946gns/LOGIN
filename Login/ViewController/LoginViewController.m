//
//  LoginViewController.m
//  Login
//
//  Created by 이명재 on 2020/08/06.
//  Copyright © 2020 databaseSample. All rights reserved.
//

#import "LoginViewController.h"

#define checkBoxOff [UIImage imageNamed:@"check_off"]
#define checkBoxOn [UIImage imageNamed:@"check_on"]

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbId;
@property (weak, nonatomic) IBOutlet UITextField *tfId;

@property (weak, nonatomic) IBOutlet UILabel *lbPw;
@property (weak, nonatomic) IBOutlet UITextField *tfPw;

@property (weak, nonatomic) IBOutlet UIButton *btnAutoLogin;
@property (weak, nonatomic) IBOutlet UILabel *lbAutoLogin;

@property (weak, nonatomic) IBOutlet UIButton *btnSaveId;
@property (weak, nonatomic) IBOutlet UILabel *lbSaveId;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UILabel *lbResult;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"로그인";
    
    _tfId.delegate = self;
    _tfPw.delegate = self;
    
    self.lbId.text = @"";
    _lbId.text = @"";
    _lbTitle.text = @"로그인";
    
    _lbId.text = @"아이디";
    _tfId.placeholder = @"아이디를 입력하세요";
    _lbPw.text = @"비밀번호";
    _tfPw.placeholder = @"비밀번호를 입력하세요";
    
    [_btnAutoLogin setImage:checkBoxOff forState:UIControlStateNormal];
    _btnAutoLogin.tag = 0;
    _lbAutoLogin.text = @"자동로그인";
    
    [_btnSaveId setImage:checkBoxOff forState:UIControlStateNormal];
    _btnSaveId.tag = 0;
    _lbSaveId.text = @"아이디 저장";
    
    [_btnLogin setTitle:@"로그인" forState:UIControlStateNormal];
    _lbResult.text = @"";
    _lbResult.hidden = YES;
    
    _btnLogin.layer.cornerRadius = 5.0f;
    _btnLogin.layer.borderColor = [UIColor redColor].CGColor;
    _btnLogin.layer.borderWidth = 3.0f;
    
}

- (IBAction)actionLogin:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *userId = _tfId.text;
    
    if (userId && userId.length > 0) {
        NSLog(@"아이디가 있습니다.!");
    }else{
        NSLog(@"아이디가 없습니다.! 아이디를 입력하세요!");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"로그인" message:@"아이디를 입력하세요." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *close = [UIAlertAction actionWithTitle:@"닫기" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:close];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSString *userPw = _tfPw.text;
    if (userPw && userPw.length > 0) {
        NSLog(@"비밀번호가 있습니다.!");
    }else{
        NSLog(@"비밀번호가 없습니다.! 비밀번호를 입력하세요!");
        
        return;
    }
    
    _lbResult.hidden = NO;
    _lbResult.text = [NSString stringWithFormat:@"아이디 : [%@] / 비밀번호 : [%@]",userId,userPw];
    
    NSURL *url = [NSURL URLWithString:@"http://demo1914380.mockable.io/api/login"];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSURLSession *session  = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            NSError *err = nil;
            NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            NSString *name = responseJson[@"userName"];
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.lbResult.text = name;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"로그인" message:[NSString stringWithFormat:@"%@님 환영합니다.!",name] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    return;
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            });
        }else{
            NSLog(@"error!");
        }
    }];
    [dataTask resume];
    
//    [self testSession];
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionAutoLogin:(id)sender {
    if (_btnAutoLogin.tag == 0) {
        _btnAutoLogin.tag = 1;
        [_btnAutoLogin setImage:checkBoxOn forState:UIControlStateNormal];
    }else{
        _btnAutoLogin.tag = 0;
        [_btnAutoLogin setImage:checkBoxOff forState:UIControlStateNormal];
    }
}

- (IBAction)actionSaveId:(id)sender {
    if (_btnSaveId.tag == 0) {
        _btnSaveId.tag = 1;
        [_btnSaveId setImage:checkBoxOn forState:UIControlStateNormal];
    }else{
        _btnSaveId.tag = 0;
        [_btnSaveId setImage:checkBoxOff forState:UIControlStateNormal];
    }
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _tfId) {
        [_tfPw becomeFirstResponder];
    }else{
        [self actionLogin:nil];
    }
    return YES;
}

@end
