//
//  DetailsViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import "DetailsViewController.h"
#import "ReviewCell.h"


@interface DetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *classCode;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *reviews;

@end

@implementation DetailsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 170;
    
    //self.classCode.text = self.class.title;
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
      ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
//    ClassModel *class = [[ClassModel alloc] initWithDictionary:self.classes[indexPath.row]];
//    cell.classCode.text = class.code;
//
      return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.reviews.count;
}

@end
