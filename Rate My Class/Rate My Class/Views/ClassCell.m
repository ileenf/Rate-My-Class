//
//  ClassCell.m
//  Rate My Class
//
//  Created by Ileen Fan on 7/12/21.
//

#import "ClassCell.h"
#import "ClassObject.h"

@implementation ClassCell

- (void)setClass:(ClassObject *)currClass {
    _currClass = currClass;

    self.className.text = currClass.classCode;
    self.overallRating.text = currClass.overallRating;
            
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

@end
