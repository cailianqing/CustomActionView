//
//  ONESelectAddressErrorActionView.h
//  ONESelectAddressModule
//
//  Created by cailianiqng on 2018/4/16.
//

#import <UIKit/UIKit.h>
@class ONESelectAddressErrorActionView;
@class ONESelectAddressErrorActionItem;


#pragma mark -
#pragma mark - ActionView
/** 点击回调 */
typedef void(^ONESelectAddressErrorActionViewButtonBlock)(ONESelectAddressErrorActionView *actionSheetView);
typedef void(^ONESelectAddressErrorActionViewDidSelectedItemBlock)(ONESelectAddressErrorActionView *actionSheetView, ONESelectAddressErrorActionItem *item);

#pragma mark action元素
@interface ONESelectAddressErrorActionItem: NSObject
/** 索引 */
@property (nonatomic, assign) NSInteger tag;
/** 标题 */
@property (nonatomic, copy) NSString *itemTitle;
/** 左侧icon */
@property (nonatomic, strong) UIImage *itemImage;

/**
 便捷创建方法
 */
+ (instancetype)actionSheetViewItemWithTag: (NSInteger)tag
                                 itemTitle: (NSString *)itemTitle
                                 itemImage: (UIImage *)itemImage;
@end

@interface ONESelectAddressErrorActionView : UIView
/** 点击item后自动收起 */
@property (nonatomic, assign) BOOL autoDismissWhenClickedItem;
/**
 便捷创建方法
 */
+ (instancetype)actionSheetViewWithTitle: (NSString *)title
                             cancelTitle: (NSString *)cancelTitle
                        destructiveTitle: (NSString *)destructiveTitle
                                   items: (NSArray<ONESelectAddressErrorActionItem *> *)items
                        didSelectedBlock: (ONESelectAddressErrorActionViewDidSelectedItemBlock)didSelectedBlock
                             cancelBlock: (ONESelectAddressErrorActionViewButtonBlock)cancelBlock
                        destructiveBlock: (ONESelectAddressErrorActionViewButtonBlock)destructiveBlock;

- (instancetype)initWithTitle: (NSString *)title
                  cancelTitle: (NSString *)cancelTitle
             destructiveTitle: (NSString *)destructiveTitle
                        items: (NSArray<ONESelectAddressErrorActionItem *> *)items
             didSelectedBlock: (ONESelectAddressErrorActionViewDidSelectedItemBlock)didSelectedBlock
                  cancelBlock: (ONESelectAddressErrorActionViewButtonBlock)cancelBlock
             destructiveBlock: (ONESelectAddressErrorActionViewButtonBlock)destructiveBlock;

/**
 显示
 */
- (void)showInView:(UIView *)view animated:(BOOL)animated;

/**
 隐藏
 */
- (void)dismissWithCompletion:(void(^)(BOOL finished))aCompletion;

@end

#pragma mark -
#pragma mark - NSString分类工具
@interface NSString (ONESelectAddressCalculate)
- (CGFloat)oneSelectAddress_calculateHeightWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font;
@end

#pragma mark -
#pragma mark - UIImage分类工具
@interface UIImage (OneSelectAddressColorConversion)
+ (UIImage *)oneSelectAddress_getImageWithColor:(UIColor *)color;
@end
