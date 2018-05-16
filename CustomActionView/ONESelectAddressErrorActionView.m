//
//  ONESelectAddressErrorActionView.m
//  ONESelectAddressModule
//
//  Created by cailianqing on 2018/4/16.
//

#import "ONESelectAddressErrorActionView.h"

// 适配
static CGFloat ONESelectAddressErrorActionSheetLineSpacing = 1.0;
static CGFloat ONESelectAddressErrorActionSheetItemHeight = 48.0;
static CGFloat ONESelectAddressErrorActionSheetTitleSpacing = 15.0;
static CGFloat ONESelectAddressErrorActionSheetTitleFontSize = 13.0;
static CGFloat ONESelectAddressErrorActionSheetItemTitleFontSize = 15.0;
static CGFloat ONESelectAddressErrorActionSheetButtonTitleFontSize = 14.0;
static CGFloat ONESelectAddressErrorActionSheetItemContainerViewTag = 1001;
static CGFloat ONESelectAddressErrorActionSheetIphoneXExtraBottomSpacing = 34.0;
static NSString *const ONESelectAddressErrorActionSheetItemReuseIdentifier = @"ONESelectAddressErrorActionSheetItemReuseIdentifier";
#define IS_IPHONE_X    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 颜色配置
#define ONESELECTADDRESS_ERROR_ACTIONVIEW_BACKGROUNDCOLOR [UIColor colorWithRed: 230.0f/255.0f green: 230.0f/255.0f blue: 230.0f/255.0f alpha: 1.0f]
#define ONESELECTADDRESS_ERROR_ACTIONVIEW_BUTTON_TITLECOLOR [UIColor colorWithRed: 102/255. green: 102/255. blue: 102/255. alpha: 1]

#pragma mark -
#pragma mark - actionView元素
@implementation ONESelectAddressErrorActionItem
/**
 便捷创建方法
 */
+ (instancetype)actionSheetViewItemWithTag: (NSInteger)tag
                                 itemTitle: (NSString *)itemTitle
                                 itemImage: (UIImage *)itemImage {
    ONESelectAddressErrorActionItem *item = [ONESelectAddressErrorActionItem new];
    item.tag = tag;
    item.itemTitle = itemTitle;
    item.itemImage = itemImage;
    return item;
}
@end

#pragma mark -
#pragma mark - actionView
@interface ONESelectAddressErrorActionView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL isShown;
@property (nonatomic,strong) UITableView *itemList;
@property (nonatomic, assign) CGFloat actionSheetHeight;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *actionSheetView;
@property (nonatomic, copy) NSArray<ONESelectAddressErrorActionItem *> *items;
/** 相关回调 */
@property (nonatomic, copy) ONESelectAddressErrorActionViewButtonBlock cancelBlock;
@property (nonatomic, copy) ONESelectAddressErrorActionViewButtonBlock destructiveBlock;
@property (nonatomic, copy) ONESelectAddressErrorActionViewDidSelectedItemBlock didSelectedItemBlock;
@end

@implementation ONESelectAddressErrorActionView
#pragma mark -
#pragma mark - actionView初始化方法
- (void)dealloc{
    _itemList.delegate = nil;
    _itemList.dataSource = nil;
}

+ (instancetype)actionSheetViewWithTitle: (NSString *)title
                             cancelTitle: (NSString *)cancelTitle
                        destructiveTitle: (NSString *)destructiveTitle
                                   items: (NSArray<ONESelectAddressErrorActionItem *> *)items
                        didSelectedBlock: (ONESelectAddressErrorActionViewDidSelectedItemBlock)didSelectedBlock
                             cancelBlock: (ONESelectAddressErrorActionViewButtonBlock)cancelBlock
                        destructiveBlock: (ONESelectAddressErrorActionViewButtonBlock)destructiveBlock {
    return [[self alloc] initWithTitle: title
                           cancelTitle: cancelTitle
                      destructiveTitle: destructiveTitle
                                 items: items
                      didSelectedBlock: didSelectedBlock
                           cancelBlock: cancelBlock
                      destructiveBlock: destructiveBlock];
}

- (instancetype)initWithTitle: (NSString *)title
                  cancelTitle: (NSString *)cancelTitle
             destructiveTitle: (NSString *)destructiveTitle
                        items: (NSArray<ONESelectAddressErrorActionItem *> *)items
             didSelectedBlock: (ONESelectAddressErrorActionViewDidSelectedItemBlock)didSelectedBlock
                  cancelBlock: (ONESelectAddressErrorActionViewButtonBlock)cancelBlock
             destructiveBlock: (ONESelectAddressErrorActionViewButtonBlock)destructiveBlock {
    if (self = [self init]) {
        self.containerView = [[UIView alloc] initWithFrame: self.bounds];
        self.containerView.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0.2];
        [self addSubview: self.containerView];
        
        self.actionSheetView = [[UIView alloc] init];
        self.actionSheetView.backgroundColor = ONESELECTADDRESS_ERROR_ACTIONVIEW_BACKGROUNDCOLOR;
        [self.containerView addSubview: self.actionSheetView];
        
        self.cancelBlock = cancelBlock;
        self.destructiveBlock = destructiveBlock;
        self.didSelectedItemBlock = didSelectedBlock;
        self.items = [NSArray arrayWithArray: items];
        
        _actionSheetHeight = 0;
        const CGFloat kMaxItemCount = 7;
        
        
        if (title && title.length > 0) {
            UILabel *titleLabel = [self generateTitleLabelWithTitle: title];
            [self.actionSheetView addSubview: titleLabel];
            _actionSheetHeight += CGRectGetHeight(titleLabel.frame);
            _actionSheetHeight += ONESelectAddressErrorActionSheetLineSpacing;
        }

        _itemList = [self generateItemListWithFrame: CGRectMake(0, _actionSheetHeight, CGRectGetWidth(self.frame), MIN(kMaxItemCount, items.count) * ONESelectAddressErrorActionSheetItemHeight)];
        [self.actionSheetView addSubview: _itemList];
        _actionSheetHeight += CGRectGetHeight(_itemList.frame);
        _actionSheetHeight += ONESelectAddressErrorActionSheetLineSpacing;

        if (destructiveTitle && destructiveTitle.length > 0) {
            UIButton *destructButton = [self generateButtonWithFrame: CGRectMake(0, _actionSheetHeight, CGRectGetWidth(self.frame), ONESelectAddressErrorActionSheetItemHeight) title: destructiveTitle titleColor: [UIColor colorWithRed: 1 green: 10/255. blue: 10/255. alpha: 1] action: @selector(onDestructive:)];
            [self.actionSheetView addSubview: destructButton];
            _actionSheetHeight += CGRectGetHeight(destructButton.frame);
            _actionSheetHeight += ONESelectAddressErrorActionSheetLineSpacing;
        }
        
        if (cancelTitle || cancelTitle.length > 0) {
            UIButton *cancelButton = [self generateButtonWithFrame: CGRectMake(0, _actionSheetHeight, CGRectGetWidth(self.frame), ONESelectAddressErrorActionSheetItemHeight) title: cancelTitle titleColor: [UIColor colorWithRed: 135/255. green: 135/255. blue: 135/255. alpha: 1] action: @selector(onCancel:)];
            [self.actionSheetView addSubview: cancelButton];
            _actionSheetHeight += CGRectGetHeight(cancelButton.frame);
        }

        if (IS_IPHONE_X) {
            _actionSheetHeight += ONESelectAddressErrorActionSheetIphoneXExtraBottomSpacing;
        }
        
        _actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _actionSheetHeight);
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.autoDismissWhenClickedItem = YES;
        CGRect frame = [UIScreen mainScreen].bounds;
        if (([[UIDevice currentDevice].systemVersion floatValue] < 7.f)) {
            frame.size.height = frame.size.height - 20.0f;
        }
        self.frame = frame;
    }
    return self;
}

#pragma mark -
#pragma mark - 显隐控制方法
- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    if(_isShown) return;
    _isShown = YES;

    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [view addSubview: self];
            self->_containerView.alpha = 1.0;
            self->_actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - self->_actionSheetHeight, CGRectGetWidth(self.frame), self->_actionSheetHeight);
        } completion: nil];
    } else {
        [view addSubview: self];
        _containerView.alpha = 1.0;
        _actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - _actionSheetHeight, CGRectGetWidth(self.frame), _actionSheetHeight);
    }
}

- (void)dismissWithCompletion:(void(^)(BOOL finished))aCompletion
{
    _isShown = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self->_containerView.alpha = 0.0;
        self->_actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), self->_actionSheetHeight);
        
    } completion: ^(BOOL finished) {
        [self removeFromSuperview];
        !aCompletion ?: aCompletion(finished);
    }];
}

#pragma mark -
#pragma mark - UI相关方法
/**
 快捷生成item方法
 */
- (UIButton *)generateItemContent {
    
    UIButton *itemContent = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetWidth(self.frame)/2-60, 0, CGRectGetWidth(self.frame)/2 + 60, ONESelectAddressErrorActionSheetItemHeight)];
    [itemContent setTitleEdgeInsets: UIEdgeInsetsMake(0, 12, 0, 0)];
    itemContent.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    itemContent.tag = ONESelectAddressErrorActionSheetItemContainerViewTag;
    [itemContent setTitleColor:ONESELECTADDRESS_ERROR_ACTIONVIEW_BUTTON_TITLECOLOR  forState: UIControlStateNormal];
    itemContent.titleLabel.font = [UIFont systemFontOfSize:ONESelectAddressErrorActionSheetItemTitleFontSize];
    itemContent.userInteractionEnabled = NO;
    
    return itemContent;
}

/**
 快捷生成label方法
 */
- (UILabel *)generateTitleLabelWithTitle: (NSString *)title {
    CGFloat titleHeight = [title oneSelectAddress_calculateHeightWithMaxWidth:CGRectGetWidth(self.frame)
                                                                         font: [UIFont boldSystemFontOfSize: ONESelectAddressErrorActionSheetTitleFontSize]] + ONESelectAddressErrorActionSheetTitleSpacing * 2;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, CGRectGetWidth(self.frame), titleHeight)];
    titleLabel.textColor = [UIColor colorWithRed: 173.0f/255.0f green: 173.0f/255.0f blue: 173.0f/255.0f alpha: 1.0f];
    titleLabel.font = [UIFont boldSystemFontOfSize: ONESelectAddressErrorActionSheetTitleFontSize];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    
    return titleLabel;
}

/**
 快捷生成Button方法
 */
- (UIButton *)generateButtonWithFrame: (CGRect)frame
                                title: (NSString *)title
                           titleColor: (UIColor *)titleColor
                               action: (SEL)action {
    UIButton *button = [[UIButton alloc] initWithFrame: frame];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle: title forState: UIControlStateNormal];
    [button setTitleColor: titleColor forState: UIControlStateNormal];
    [button addTarget: self action: action forControlEvents: UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize: ONESelectAddressErrorActionSheetButtonTitleFontSize];
    [button setBackgroundImage: [UIImage oneSelectAddress_getImageWithColor: [UIColor colorWithWhite: 0.9 alpha: 1]] forState: UIControlStateHighlighted];
    return button;
}

/**
 快捷生成tableView方法
 */
- (UITableView *)generateItemListWithFrame: (CGRect)frame {
    UITableView *tableView = [[UITableView alloc] initWithFrame: frame];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.rowHeight = ONESelectAddressErrorActionSheetItemHeight;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tableView;
}

#pragma mark -
#pragma mark - UITableViewDataSource数据源
- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: ONESelectAddressErrorActionSheetItemReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: ONESelectAddressErrorActionSheetItemReuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *itemContent = [self generateItemContent];
        [cell.contentView addSubview: itemContent];
    }
    
    UIButton *itemContent = (UIButton *)[cell.contentView viewWithTag: ONESelectAddressErrorActionSheetItemContainerViewTag];
    ONESelectAddressErrorActionItem *item = self.items[indexPath.row];
    [itemContent setImage:item.itemImage forState: UIControlStateNormal];
    [itemContent setTitle:item.itemTitle forState: UIControlStateNormal];
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate代理
- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    if (self.autoDismissWhenClickedItem) {
        [self dismissWithCompletion: nil];
    }
    if (self.didSelectedItemBlock) {
        self.didSelectedItemBlock(self, self.items[indexPath.row]);
    }
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark -
#pragma mark - 响应方法
/**
 取消
 */
- (void)onCancel: (UIButton *)item {
    if (self.autoDismissWhenClickedItem) {
        [self dismissWithCompletion: ^(BOOL finished) {
            if (finished && self.cancelBlock) {
                self.cancelBlock(self);
            }
        }];
    } else {
        [self removeFromSuperview];
        if (self.cancelBlock) {
            self.cancelBlock(self);
        }
    }
}

- (void)onDestructive: (UIButton *)item {
    if (self.autoDismissWhenClickedItem) {
        [self dismissWithCompletion: ^(BOOL finished) {
            if (finished && self.destructiveBlock) {
                self.destructiveBlock(self);
            }
        }];
    } else {
        [self removeFromSuperview];
        if (self.destructiveBlock) {
            self.destructiveBlock(self);
        }
    }
}

/**
 点击空白
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView: self];
    if (!CGRectContainsPoint(self.actionSheetView.frame, touchPoint)) {
        [self onCancel: nil];
    }
}

@end

#pragma mark -
#pragma mark - NSString分类工具
@implementation NSString (ONESelectAddressCalculate)
- (CGFloat)oneSelectAddress_calculateHeightWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font {
    if (([[UIDevice currentDevice].systemVersion floatValue] < 7.f)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return ceil([self sizeWithFont: font
                     constrainedToSize: CGSizeMake(maxWidth, MAXFLOAT)
                         lineBreakMode: NSLineBreakByCharWrapping].height);
#pragma clang diagnostic pop
    } else {
        return ceil([self boundingRectWithSize: CGSizeMake(maxWidth, MAXFLOAT)
                                       options: NSStringDrawingUsesLineFragmentOrigin
                                    attributes: @{ NSFontAttributeName: font }
                                       context: nil].size.height);
    }
}
@end

#pragma mark -
#pragma mark - UIImage分类工具
@implementation UIImage (OneSelectAddressColorConversion)
+ (UIImage *)oneSelectAddress_getImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
