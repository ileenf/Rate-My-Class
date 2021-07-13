//
//  HomeViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/12/21.
//

#import "HomeViewController.h"
#import "ClassAPIManager.h"
#import "ClassCell.h"
#import "ClassModel.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *classes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.classes = [[NSMutableArray alloc] init];
    
    [self fetchClasses];
    
}

- (void)fetchClasses {
//    ClassAPIManager *manager = [ClassAPIManager new];
//    NSLog(@"in here first");
//    [manager fetchCurrentClasses:^(NSArray *classes, NSError *error) {
//        NSLog(@"in here");
//
//        if (error){
//
//        } else {
//
//            self.classes = classes;
//            [self.tableView reloadData];
//
//        }
//
//
//    }];
    
    NSURL *url = [NSURL URLWithString:@"https://api.peterportal.org/rest/v0/courses/all"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);

        }
        else {
            NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.classes = dataArray;
            
            //NSLog(@"%@", dataDictionary);

        }
    }];
    
    [task resume];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassCell"];
    
    ClassModel *class = self.classes[indexPath.row];
    
    NSLog(@"%@", class);
    
    cell.className = class.title;
    
    NSLog(@"%@", class.title);
    
    //[cell setClass:class];
    
    return cell;
    
    
    
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classes.count;
}

@end
