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
    
    self.numberOfReviews = (NSDecimalNumber *)[NSDecimalNumber numberWithInteger:self.reviewsFromDetails.count + 1];
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
    ReviewModel *newReview = [ReviewModel postReview:self.ratingField.text withDifficulty:self.difficultyField.text withClassObj:self.classObj withComment:self.commentView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            self.commentView.text = @"";
            
            NSDecimalNumber *averageRating =  [self calculateAverageRating:self.ratingField.text];
            NSDecimalNumber *averageDifficulty = [self calculateAverageDifficulty:self.difficultyField.text];
            
//            NSLog(@"new reveiw raitng: %@", self.ratingField.text);
//            NSLog(@"new difficulty raitng: %@", self.difficultyField.text);
//            NSLog(@"overall raitng: %@", averageRating);
//            NSLog(@"overall difficulty: %@", averageDifficulty);;
            
            self.classObj.overallRating = [NSString stringWithFormat:@"%@", averageRating];
            self.classObj.overallDifficulty = [NSString stringWithFormat:@"%@", averageDifficulty];
            [self.classObj saveInBackground];
                        
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
    
    [self.delegate didSubmitReview:newReview];
    NSLog(@"rating: %@", newReview.rating);
    NSLog(@"diff: %@", newReview.difficulty);
}

- (NSDecimalNumber *)calculateAverageRating:(NSString *)newRating {
    NSDecimalNumber *totalRating = [NSDecimalNumber decimalNumberWithString:newRating];
    for (ReviewModel *review in self.reviewsFromDetails) {
        NSDecimalNumber *reviewRating = [NSDecimalNumber decimalNumberWithString:review.rating];
        totalRating = [totalRating decimalNumberByAdding:reviewRating];
    }
    NSDecimalNumber *averageRating = [totalRating decimalNumberByDividingBy:self.numberOfReviews];
    NSDecimalNumber *averageRatingRounded = [self roundDecimal:averageRating];
    
    return averageRatingRounded;
}

- (NSDecimalNumber *)calculateAverageDifficulty:(NSString *)newDifficulty {
    NSDecimalNumber *totalDifficulty = [NSDecimalNumber decimalNumberWithString:newDifficulty];
    for (ReviewModel *review in self.reviewsFromDetails) {
        NSDecimalNumber *reviewDifficulty = [NSDecimalNumber decimalNumberWithString:review.difficulty];
        totalDifficulty = [totalDifficulty decimalNumberByAdding:reviewDifficulty];
    }
    NSDecimalNumber *averageDifficulty = [totalDifficulty decimalNumberByDividingBy:self.numberOfReviews];
    NSDecimalNumber *averageDifficultyRounded = [self roundDecimal:averageDifficulty];
    
    return averageDifficultyRounded;
}

- (NSDecimalNumber *)roundDecimal:(NSDecimalNumber *)amount {
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                              scale:2
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    
    NSDecimalNumber *roundedNumber = [amount decimalNumberByRoundingAccordingToBehavior:behavior];
    return roundedNumber;
}

@end
