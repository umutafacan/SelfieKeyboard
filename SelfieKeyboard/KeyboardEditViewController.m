//
//  KeyboardEditViewController.m
//  SelfieKeyboard
//
//  Created by umut on 13/03/15.
//  Copyright (c) 2015 Umut Afacan. All rights reserved.
//

#import "KeyboardEditViewController.h"
#import "KeyboardCollectionViewCell.h"
#import "EditorViewController.h"


@interface KeyboardEditViewController () <KeyboardCollectionViewCellDelegate, EditorViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewKeyboard;


@end

@implementation KeyboardEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionViewKeyboard.delegate=self;
    _collectionViewKeyboard.dataSource=self;
    _labelName.text = _textNameOfKeyboard;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Collection View Delegates
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KeyboardCollectionViewCell *myCell = (KeyboardCollectionViewCell *) [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"KeyboardCell"
                                    forIndexPath:indexPath];
    myCell.photoID =(int)indexPath.row;
    myCell.indexPath = indexPath;
    myCell.delegate=self;
    
    NSString *theImagePath ;
    if ([[[NSUserDefaults standardUserDefaults] dictionaryRepresentation].allKeys containsObject:[NSString stringWithFormat:@"Keyboard_%d_image%d",_keyboardID,(int)indexPath.row]]) {
        // unarchive the value here
       theImagePath= [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:[NSString stringWithFormat:@"Keyboard_%d_image%d",_keyboardID,(int)indexPath.row]];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cache = [paths objectAtIndex:0];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", cache, theImagePath];
     if (  theImagePath  ) {
    UIImage *buttonImage = [UIImage imageWithContentsOfFile:fullPath];

   
        [myCell.imageView setImage:buttonImage];
    }
    else
    {
        [myCell.imageView setBackgroundColor:[UIColor whiteColor]];
    }
    
    
    return myCell;
    
    

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    

    return 8;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


#pragma  mark - Cell Delegates

-(void)pushToDetail:(KeyboardCollectionViewCell *)sender
{
    EditorViewController *editVC = [[EditorViewController alloc]init];
    editVC.photoID = sender.photoID;
    editVC.delegate = self;
    editVC.indexPath = sender.indexPath;
    editVC.keyboardID=_keyboardID;
    //push to new page
    [self.navigationController pushViewController:editVC animated:YES];
    
}

#pragma  mark - EditViewController Delegate

-(void)saveThePhotoWithName:(NSString *)name id:(int)ID indexPath:(NSIndexPath *)indexPath
{

    [_collectionViewKeyboard reloadItemsAtIndexPaths:@[indexPath]];
   
    
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
