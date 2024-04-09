//
//  JKLockView.h
//  LockView
//
//

#import <UIKit/UIKit.h>
@class JKLockView;
@protocol JKLockViewDelegate <NSObject>

@optional
- (void)lockView:(JKLockView *)lockView didFinishPath:(NSString *)path;

@end
@interface JKLockView : UIView
@property (nonatomic, assign) IBOutlet id<JKLockViewDelegate> delegate;

@end
