//
//  ComposeViewController.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/13/21.
//

#import "ComposeViewController.h"
#import "DetailsViewController.h"
#import "ReviewModel.h"
#import "Parse/Parse.h"

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *commentView;
@property (weak, nonatomic) IBOutlet UITextField *ratingField;
@property (weak, nonatomic) IBOutlet UITextField *difficultyField;
@property NSDecimalNumber *numberOfReviews;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentView.delegate = self;
    self.commentView.text = @"Write a comment...";
    self.commentView.textColor = [UIColor lightGrayColor];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.textColor == [UIColor lightGrayColor]) {
        textView.text = nil;
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write a comment...";
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (IBAction)cancelReview:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)submitReview:(id)sender {
    ReviewModel *newReview = [ReviewModel postReview:self.ratingField.text
                                      withDifficulty:self.difficultyField.text
                                        withClassObj:self.classObj
                                         withComment:self.commentView.text
                                      withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
    }];
    
    [newReview saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            self.commentView.text = @"";
            
            [self dismissViewControllerAnimated:true completion:nil];
                        
            [self.delegate didSubmitReview:newReview];
        }
    }];
}

@end
