//
//  WSReviewViewController.h
//  Sample
//
//  Created by Théophane Rupin on 9/24/18.
//  Copyright © 2018 Scribd. All rights reserved.
//

@import UIKit;

@protocol WSReviewViewControllerDependencyResolver;

NS_ASSUME_NONNULL_BEGIN

@interface WSReviewViewController: UIViewController

- (instancetype)initWithDependencies:(id<WSReviewViewControllerDependencyResolver>)dependencies NS_SWIFT_NAME(init(injecting:));

@end

NS_ASSUME_NONNULL_END
