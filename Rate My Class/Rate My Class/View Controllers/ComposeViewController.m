//
//  ComposeViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import "ComposeViewController.h"
#import "ReviewModel.h"
#import "Parse/Parse.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *commentView;
@property (weak, nonatomic) IBOutlet UITextField *ratingField;
@property (weak, nonatomic) IBOutlet UITextField *difficultyField;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)cancelReview:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)submitReview:(id)sender {
    [ReviewModel postReview:self.ratingField.text withDifficulty:self.difficultyField.text withCode: self.classCode withComment:self.commentView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            self.commentView.text = @"";
            NSLog(@"hello");
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
