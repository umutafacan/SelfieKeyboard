//
//  KeyboardCollectionViewCell.h
//  SelfieKeyboard
//
//  Created by umut on 13/03/15.
//  Copyright (c) 2015 Umut Afacan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  KeyboardCollectionViewCell;

@protocol KeyboardCollectionViewCellDelegate <NSObject>


-(void)pushToDetail:(KeyboardCollectionViewCell *) sender;

@end

@interface KeyboardCollectionViewCell : UICollectionViewCell
{

}
@property (weak, nonatomic) id<KeyboardCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *buttonKeyboard;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property int photoID;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (IBAction)pushToEditPage:(id)sender;

@end
