#import "WSReviewViewController.h"
#import "Sample-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSReviewViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WSReviewViewControllerDependencyResolver dependencies;

@property (nonatomic, assign) NSUInteger movieID;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<Review *> *reviews;

@end

@implementation WSReviewViewController

- (instancetype)initWithDependencies:(WSReviewViewControllerDependencyResolver)dependencies movieID:(NSUInteger)movieID {
    self = [super init];
    
    if (self) {
        self.dependencies = dependencies;
        self.movieID = movieID;
    }
    
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ReviewTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ReviewTableViewCell class])];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 140;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Reviews";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[[self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                                              [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                                              [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]]];
    
    [self.dependencies.reviewManager getReviewsFor:self.movieID completion:^(ReviewPage * _Nullable page) {
        if (!page) {
            return;
        }
        
        self.reviews = page.results;
        [self.tableView reloadData];
    }];
}

#pragma pragma - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReviewTableViewCell class]) forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ReviewTableViewCell class]]) {
        ReviewTableViewCell *reviewCell = (ReviewTableViewCell *)cell;
        Review *review = self.reviews[indexPath.row];
        ReviewTableViewCellViewModel *viewModel = [[ReviewTableViewCellViewModel alloc] initWithReview:review];
        [reviewCell bindWithViewModel:viewModel];
    }
    
    return cell;
}

@end

NS_ASSUME_NONNULL_END
