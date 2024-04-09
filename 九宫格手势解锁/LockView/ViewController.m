//
//  ViewController.m
//  LockView
//
//

#import "ViewController.h"
#import "JKLockView.h"
@interface ViewController ()<JKLockViewDelegate>

@end

/*
 常用插件
 在github上查找，然后下载，完成之后运行
 KSImageNamed
 VVDocumenter-Xcode
 ColorSense-for-Xcode-master

 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
//代理方法
- (void)lockView:(JKLockView *)lockView didFinishPath:(NSString *)path{
    if ([path isEqualToString:@"012345678"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码正确" message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码错误" message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
