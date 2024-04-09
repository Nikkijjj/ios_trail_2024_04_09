//
//  JKLockView.m
//  LockView
//
//

#import "JKLockView.h"
//const 定义 只读的变量名，在其他的类中不能声明同样的变量名
CGFloat const btnCount = 9;
CGFloat const btnW = 74;
CGFloat const btnH = 74;
CGFloat const viewY = 300;
int const columnCount = 3;
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//匿名扩展（类目的特例） ：可以声明属性
@interface JKLockView ()
@property (nonatomic, strong) NSMutableArray *selectedBtns;
@property (nonatomic, assign) CGPoint currentPoint;
@end

@implementation JKLockView
//创建数组
- (NSMutableArray *)selectedBtns{
    if (_selectedBtns == nil) {
        _selectedBtns = [NSMutableArray array];
    }
    return _selectedBtns;
}
//通过代码创建会调用这个方法
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self AddButton];
    }
    return self;
}
//通过storyboard 或者 xib 文件创建的时候会调用
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self AddButton];
    }
    return self;
}
//布局按钮
- (void)AddButton{
    CGFloat height = 0;
    for (int i = 0; i < btnCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置默认的图片
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        //设置选中的图片
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        btn.tag = i;
        int row = i / columnCount;//第几行
        int column = i % columnCount;//第几列
        //边距
        CGFloat margin = (self.frame.size.width - columnCount * btnW) / (columnCount + 1);
        //x轴
        CGFloat btnX = margin + column * (btnW + margin);
        //y轴
        CGFloat btnY = row * (btnW + margin);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        height = btnH + btnY;
        [self addSubview:btn];
        
    }
    self.frame = CGRectMake(0, viewY, kScreenWidth, height);
}
#pragma mark - 私有方法
- (CGPoint)pointWithTouch:(NSSet *)touches{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    return point;
}
- (UIButton *)buttonWithPoint:(CGPoint)point{
    for (UIButton *btn in self.subviews) {
        //
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}
#pragma mark - 触摸方法
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //1.拿到触摸的点
    CGPoint point = [self pointWithTouch:touches];
    //2.根据触摸的点拿到响应的按钮
    UIButton *btn = [self buttonWithPoint:point];
    //3.设置状态
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectedBtns addObject:btn];//往数组或字典中添加对象的时候，要判断这个对象是否存在
    }
    }
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //1.拿到触摸的点
    CGPoint point = [self pointWithTouch:touches];
    //2.根据触摸的点拿到响应的按钮
    UIButton *btn = [self buttonWithPoint:point];
    //3.设置状态
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectedBtns addObject:btn];
    }else{
        self.currentPoint = point;
    }
    [self setNeedsDisplay];

}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([self.delegate respondsToSelector:@selector(lockView:didFinishPath:)]) {
        NSMutableString *path = [NSMutableString string];
        for (UIButton *btn in self.selectedBtns) {
            [path appendFormat:@"%ld",(long)btn.tag];
        }
        [self.delegate lockView:self didFinishPath:path];
    }
    //清空按钮
    //makeObjectsPerformSelector  向数组中的每一个对象发送方法 setSelected:，方法参数为 NO
    // 清空按钮
    for (UIButton *btn in self.selectedBtns) {
        btn.selected = NO;
    }
    [self.selectedBtns removeAllObjects];
    [self setNeedsDisplay];

    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesEnded:touches withEvent:event];
}
#pragma mark - 绘图
-(void)drawRect:(CGRect)rect{
    if (self.selectedBtns.count == 0) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 8;
    path.lineJoinStyle = kCGLineJoinRound;
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:0.5] set];
    //遍历按钮
    for (int i = 0; i < self.selectedBtns.count; i++) {
        UIButton *button = self.selectedBtns[i];
        if (i == 0) {//设置起点
            [path moveToPoint:button.center];
        }else{//连线
            [path addLineToPoint:button.center];
        }
    }
    [path addLineToPoint:self.currentPoint];
    [path stroke];
}
@end
