// Generated by Apple Swift version 3.0 (swiftlang-800.0.46.2 clang-800.0.38)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import CoreGraphics;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIFont;
@class UIColor;
@class NSCoder;

/**
  Represents the default button for the popup dialog
*/
SWIFT_CLASS("_TtC11PopupDialog17PopupDialogButton")
@interface PopupDialogButton : UIButton
/**
  The font and size of the button title
*/
@property (nonatomic, strong) UIFont * _Nullable titleFont;
/**
  The title color of the button
*/
@property (nonatomic, strong) UIColor * _Nullable titleColor;
/**
  The background color of the button
*/
@property (nonatomic, strong) UIColor * _Nullable buttonColor;
/**
  The separator color of this button
*/
@property (nonatomic, strong) UIColor * _Nullable separatorColor;
/**
  Default appearance of the button
*/
@property (nonatomic, strong) UIFont * _Nonnull defaultTitleFont;
@property (nonatomic, strong) UIColor * _Nonnull defaultTitleColor;
@property (nonatomic, strong) UIColor * _Nonnull defaultButtonColor;
@property (nonatomic, strong) UIColor * _Nonnull defaultSeparatorColor;
/**
  Whether button should dismiss popup when tapped
*/
@property (nonatomic) BOOL dismissOnTap;
/**
  The action called when the button is tapped
*/
@property (nonatomic, readonly, copy) void (^ _Nullable buttonAction)(void);
- (nonnull instancetype)initWithTitle:(NSString * _Nonnull)title dismissOnTap:(BOOL)dismissOnTap action:(void (^ _Nullable)(void))action OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)setupView;
@property (nonatomic, setter=setHighlighted:) BOOL isHighlighted;
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
@end


/**
  Represents a cancel button for the popup dialog
*/
SWIFT_CLASS("_TtC11PopupDialog12CancelButton")
@interface CancelButton : PopupDialogButton
- (void)setupView;
- (nonnull instancetype)initWithTitle:(NSString * _Nonnull)title dismissOnTap:(BOOL)dismissOnTap action:(void (^ _Nullable)(void))action OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


/**
  Represents the default button for the popup dialog
*/
SWIFT_CLASS("_TtC11PopupDialog13DefaultButton")
@interface DefaultButton : PopupDialogButton
- (nonnull instancetype)initWithTitle:(NSString * _Nonnull)title dismissOnTap:(BOOL)dismissOnTap action:(void (^ _Nullable)(void))action OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


/**
  Represents a destructive button for the popup dialog
*/
SWIFT_CLASS("_TtC11PopupDialog17DestructiveButton")
@interface DestructiveButton : PopupDialogButton
- (void)setupView;
- (nonnull instancetype)initWithTitle:(NSString * _Nonnull)title dismissOnTap:(BOOL)dismissOnTap action:(void (^ _Nullable)(void))action OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIImage;
enum PopupDialogTransitionStyle : NSInteger;
@class NSBundle;

/**
  Creates a Popup dialog similar to UIAlertController
*/
SWIFT_CLASS("_TtC11PopupDialog11PopupDialog")
@interface PopupDialog : UIViewController
/**
  The content view of the popup dialog
*/
@property (nonatomic, strong) UIViewController * _Nonnull viewController;
/**
  Whether or not to shift view for keyboard display
*/
@property (nonatomic) BOOL keyboardShiftsView;
- (nonnull instancetype)initWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message image:(UIImage * _Nullable)image buttonAlignment:(UILayoutConstraintAxis)buttonAlignment transitionStyle:(enum PopupDialogTransitionStyle)transitionStyle gestureDismissal:(BOOL)gestureDismissal completion:(void (^ _Nullable)(void))completion;
- (nonnull instancetype)initWithViewController:(UIViewController * _Nonnull)viewController buttonAlignment:(UILayoutConstraintAxis)buttonAlignment transitionStyle:(enum PopupDialogTransitionStyle)transitionStyle gestureDismissal:(BOOL)gestureDismissal completion:(void (^ _Nullable)(void))completion OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
/**
  Replaces controller view with popup view
*/
- (void)loadView;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)dismiss:(void (^ _Nullable)(void))completion;
- (void)addButton:(PopupDialogButton * _Nonnull)button;
- (void)addButtons:(NSArray<PopupDialogButton *> * _Nonnull)buttons;
- (void)tapButtonWithIndex:(NSInteger)index;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil SWIFT_UNAVAILABLE;
@end


@interface PopupDialog (SWIFT_EXTENSION(PopupDialog))
@end


@interface PopupDialog (SWIFT_EXTENSION(PopupDialog))
/**
  The button alignment of the alert dialog
*/
@property (nonatomic) UILayoutConstraintAxis buttonAlignment;
/**
  The transition style
*/
@property (nonatomic) enum PopupDialogTransitionStyle transitionStyle;
@end



/**
  The main view of the popup dialog
*/
SWIFT_CLASS("_TtC11PopupDialog24PopupDialogContainerView")
@interface PopupDialogContainerView : UIView
/**
  The background color of the popup dialog
*/
@property (nonatomic, strong) UIColor * _Nullable backgroundColor;
/**
  The corner radius of the popup view
*/
@property (nonatomic) float cornerRadius;
/**
  Enable / disable shadow rendering
*/
@property (nonatomic) BOOL shadowEnabled;
/**
  The shadow color
*/
@property (nonatomic, strong) UIColor * _Nullable shadowColor;
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


/**
  The main view of the popup dialog
*/
SWIFT_CLASS("_TtC11PopupDialog22PopupDialogDefaultView")
@interface PopupDialogDefaultView : UIView
/**
  The font and size of the title label
*/
@property (nonatomic, strong) UIFont * _Nonnull titleFont;
/**
  The color of the title label
*/
@property (nonatomic, strong) UIColor * _Nullable titleColor;
/**
  The text alignment of the title label
*/
@property (nonatomic) NSTextAlignment titleTextAlignment;
/**
  The font and size of the body label
*/
@property (nonatomic, strong) UIFont * _Nonnull messageFont;
/**
  The color of the message label
*/
@property (nonatomic, strong) UIColor * _Nullable messageColor;
/**
  The text alignment of the message label
*/
@property (nonatomic) NSTextAlignment messageTextAlignment;
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC11PopupDialog32PopupDialogDefaultViewController")
@interface PopupDialogDefaultViewController : UIViewController
@property (nonatomic, readonly, strong) PopupDialogDefaultView * _Nonnull standardView;
- (void)loadView;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface PopupDialogDefaultViewController (SWIFT_EXTENSION(PopupDialog))
/**
  The dialog image
*/
@property (nonatomic, strong) UIImage * _Nullable image;
/**
  The title text of the dialog
*/
@property (nonatomic, copy) NSString * _Nullable titleText;
/**
  The message text of the dialog
*/
@property (nonatomic, copy) NSString * _Nullable messageText;
/**
  The font and size of the title label
*/
@property (nonatomic, strong) UIFont * _Nonnull titleFont;
/**
  The color of the title label
*/
@property (nonatomic, strong) UIColor * _Nullable titleColor;
/**
  The text alignment of the title label
*/
@property (nonatomic) NSTextAlignment titleTextAlignment;
/**
  The font and size of the body label
*/
@property (nonatomic, strong) UIFont * _Nonnull messageFont;
/**
  The color of the message label
*/
@property (nonatomic, strong) UIColor * _Nullable messageColor;
/**
  The text alignment of the message label
*/
@property (nonatomic) NSTextAlignment messageTextAlignment;
@end


/**
  The (blurred) overlay view below the popup dialog
*/
SWIFT_CLASS("_TtC11PopupDialog22PopupDialogOverlayView")
@interface PopupDialogOverlayView : UIView
/**
  The blur radius of the overlay view
*/
@property (nonatomic) float blurRadius;
/**
  Turns the blur of the overlay view on or off
*/
@property (nonatomic) BOOL blurEnabled;
/**
  Whether the blur view should allow for
  dynamic rendering of the background
*/
@property (nonatomic) BOOL liveBlur;
/**
  The background color of the overlay view
*/
@property (nonatomic, strong) UIColor * _Nullable color;
/**
  The opacity of the overay view
*/
@property (nonatomic) float opacity;
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

typedef SWIFT_ENUM(NSInteger, PopupDialogTransitionStyle) {
  PopupDialogTransitionStyleBounceUp = 0,
  PopupDialogTransitionStyleBounceDown = 1,
  PopupDialogTransitionStyleZoomIn = 2,
  PopupDialogTransitionStyleFadeIn = 3,
};


@interface UIView (SWIFT_EXTENSION(PopupDialog))
@end


@interface UIViewController (SWIFT_EXTENSION(PopupDialog))
@end

#pragma clang diagnostic pop
