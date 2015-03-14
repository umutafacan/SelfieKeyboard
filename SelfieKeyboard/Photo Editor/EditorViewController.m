//
//  ViewController.m
//  GKImagePicker
//
//  Created by Genki Kondo on 9/18/12.
//  Copyright (c) 2012 Genki Kondo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "EditorViewController.h"
#import "GKImagePicker.h"
#import "IQLabelView.h"



@interface EditorViewController () <GKImagePickerDelegate,UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    IBOutlet UIImageView *myImageView;
    GKImagePicker *picker;
    IQLabelView *currentlyEditingLabel;
    NSMutableArray *labels;
    UITapGestureRecognizer *tapGesture;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;
@property (nonatomic, retain) GKImagePicker *picker;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *buttonColorPalette;
@property (nonatomic,strong) NSMutableArray *arrayColor;
@property (nonatomic,strong) UIColor *selectedColor;
@property (nonatomic,strong) UIPickerView *colorPicker;
@property (weak, nonatomic) IBOutlet UIButton *buttonColor;


- (IBAction)handleImageButton:(id)sender;
@end

@implementation EditorViewController

@synthesize picker = _picker;


- (void)viewDidLoad
{
    [super viewDidLoad];
    _colorPicker= [[UIPickerView alloc]initWithFrame:CGRectMake(110,self.view.frame.size.height-200 , 100, 200)];
    _colorPicker.delegate = self;
    _colorPicker.dataSource = self;
    _arrayColor = [[NSMutableArray alloc]initWithObjects:[UIColor whiteColor],[UIColor redColor],[UIColor blueColor],[UIColor blackColor],[UIColor greenColor],[UIColor purpleColor],[UIColor grayColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor darkGrayColor],[UIColor lightGrayColor],[UIColor cyanColor],[UIColor magentaColor],[UIColor brownColor], nil];
    _selectedColor=[UIColor whiteColor];
    
    [_buttonEdit setHidden:YES];
    
    NSString *theImagePath ;
    if ([[[NSUserDefaults standardUserDefaults] dictionaryRepresentation].allKeys containsObject:[NSString stringWithFormat:@"Keyboard_%d_image%d",_keyboardID,_photoID]]) {
        // unarchive the value here
        theImagePath= [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:[NSString stringWithFormat:@"Keyboard_%d_image%d",_keyboardID,_photoID]];
    }
   

    
    if (  theImagePath  ) {
        UIImage *buttonImage = [UIImage imageWithContentsOfFile:theImagePath];
         myImageView.contentMode = UIViewContentModeCenter;
        myImageView.image = buttonImage;
        [self addGestureRecognizer];
    }
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - User interaction methods

- (IBAction)handleImageButton:(id)sender {
    self.picker = [[GKImagePicker alloc] init];
    self.picker.delegate = self;
    self.picker.cropper.cropSize = CGSizeMake(320,320.);   // (Optional) Default: CGSizeMake(320., 320.)
    self.picker.cropper.rescaleImage = YES;                // (Optional) Default: YES
    self.picker.cropper.rescaleFactor = 1.0;               // (Optional) Default: 1.0
    self.picker.cropper.dismissAnimated = YES;              // (Optional) Default: YES
    self.picker.cropper.overlayColor = [UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:0.7];  // (Optional) Default: [UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:0.7]
    self.picker.cropper.innerBorderColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:0.7];   // (Optional) Default: [UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:0.7]
    [self.picker presentPicker];
}

#pragma mark - GKImagePicker delegate methods

- (void)imagePickerDidFinish:(GKImagePicker *)imagePicker withImage:(UIImage *)image {
    myImageView.contentMode = UIViewContentModeCenter;
    myImageView.image = image;
    if (image) {
        [self addGestureRecognizer];
    }
    
}

-(void)addGestureRecognizer
{
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGestureRecognizer:)];
    tapGesture.numberOfTapsRequired=1;
    tapGesture.numberOfTouchesRequired=1;
    tapGesture.delegate=self;
    [myImageView addGestureRecognizer:tapGesture];
    [myImageView setUserInteractionEnabled:YES];

}
-(void)disableGestureRecognizer
{
    for (UITapGestureRecognizer *recognizer in myImageView.gestureRecognizers) {
        [myImageView removeGestureRecognizer:recognizer];
    }

}



-(void)handleGestureRecognizer:(UIGestureRecognizer *)gestRecog
{
    
    [self disableGestureRecognizer];
    
    CGPoint tapPoint = [gestRecog locationOfTouch:0 inView:self.view];
    [currentlyEditingLabel hideEditingHandles];
    CGRect labelFrame = CGRectMake(tapPoint.x,
                                   tapPoint.y-30,
                                   60, 50);
    UITextField *aLabel = [[UITextField alloc] initWithFrame:CGRectMake(tapPoint.x , tapPoint.y-30, 50, 50)];
    [aLabel setClipsToBounds:YES];
    [aLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
    [aLabel setText:@""];
    [aLabel setTextColor:_selectedColor];
    [aLabel sizeToFit];
    
    IQLabelView *labelView = [[IQLabelView alloc] initWithFrame:labelFrame];
    [labelView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    labelView.delegate = self;
    [labelView setShowContentShadow:NO];
    [labelView setTextView:aLabel];
    [labelView setFontName:@"Baskerville-BoldItalic"];
    [labelView setFontSize:21.0];
    [labelView sizeToFit];
    [self.view addSubview:labelView];
    
    currentlyEditingLabel = labelView;
    [labels addObject:labelView];


}

#pragma  mark - Edit Photo Methods
- (IBAction)addLabel
{
    [currentlyEditingLabel hideEditingHandles];
    CGRect labelFrame = CGRectMake(CGRectGetMidX(self.imageView.frame) - arc4random() % 150,
                                   CGRectGetMidY(self.imageView.frame) - arc4random() % 200,
                                   60, 50);
    UITextField *aLabel = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [aLabel setClipsToBounds:YES];
    [aLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
    [aLabel setText:@""];
    [aLabel setTextColor:_selectedColor];
    [aLabel sizeToFit];
    
    IQLabelView *labelView = [[IQLabelView alloc] initWithFrame:labelFrame];
    [labelView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    labelView.delegate = self;
    [labelView setShowContentShadow:NO];
    [labelView setTextView:aLabel];
    [labelView setFontName:@"Baskerville-BoldItalic"];
    [labelView setFontSize:21.0];
    [labelView sizeToFit];
    [self.view addSubview:labelView];
    
    currentlyEditingLabel = labelView;
    [labels addObject:labelView];
}

- (IBAction)saveImage
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        UIImageWriteToSavedPhotosAlbum([self visibleImage], nil, nil, nil);
//        dispatch_async(dispatch_get_main_queue(), ^{
//           
//        });
//    });
    
    
    
    NSString *imageName = [NSString stringWithFormat:@"Keyboard_%d_image%d",_keyboardID,_photoID];
   
    [[Singleton sharedInstance].imageDict addEntriesFromDictionary:@{imageName:[self visibleImage]}];
    
    
    
    NSData *imageData = UIImagePNGRepresentation([self visibleImage]);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.png",imageName]];
    
    [[NSUserDefaults standardUserDefaults] rm_setCustomObject:imagePath forKey:imageName];

    

    
    NSLog((@"pre writing to file"));
    
    if (![imageData writeToFile:imagePath atomically:YES])
    {
        NSLog((@"Failed to cache image data to disk"));
    }
    else
    {
        NSLog((@"the cachedImagedPath is %@",imagePath));
    }
    
    [self.delegate saveThePhotoWithName:imageName id:_photoID indexPath:_indexPath];
   
    
}

- (UIImage *)visibleImage
{
    UIGraphicsBeginImageContextWithOptions(myImageView.bounds.size, YES, myImageView.image.scale);
    NSLog(@"%f", myImageView.frame.origin.y);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), CGRectGetMinX(myImageView.frame), -CGRectGetMinY(myImageView.frame));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *visibleViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return visibleViewImage;
}

#pragma mark - Gesture

- (void)touchOutside:(UITapGestureRecognizer *)touchGesture
{
    [currentlyEditingLabel hideEditingHandles];
}

#pragma mark - IQLabelDelegate
- (void)labelViewDidEndEditing:(IQLabelView *)label
{
    

}

- (void)labelViewDidClose:(IQLabelView *)label
{
    // some actions after delete label
    [labels removeObject:label];
    [self addGestureRecognizer];
}

- (void)labelViewDidBeginEditing:(IQLabelView *)label
{
    // move or rotate begin
}

- (void)labelViewDidShowEditingHandles:(IQLabelView *)label
{
    // showing border and control buttons
    currentlyEditingLabel = label;
}

- (void)labelViewDidHideEditingHandles:(IQLabelView *)label
{
    // hiding border and control buttons
    currentlyEditingLabel = nil;
    [self addGestureRecognizer];
}

- (void)labelViewDidStartEditing:(IQLabelView *)label
{
    // tap in text field and keyboard showing
    currentlyEditingLabel = label;
}

#pragma  mark - Color Picker 
- (IBAction)palette:(id)sender {
    

    [self.view addSubview:_colorPicker];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.numberOfTapsRequired=1;
    gestureRecognizer.delegate = self;
    gestureRecognizer.numberOfTouchesRequired=1;

    [_colorPicker addGestureRecognizer:gestureRecognizer];
    
    
    
}

- (void)pickerViewTapGestureRecognized:(UITapGestureRecognizer*)gestureRecognizer
{
    [_colorPicker removeFromSuperview];
    _buttonColor.backgroundColor = _selectedColor;
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    // return
    return true;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _arrayColor.count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{

    UIView *viewForRow = (UIView *)view;

    if (viewForRow ==  nil) {
        CGRect frame = CGRectMake(0, 0, 80, 32);
        viewForRow = [[UIView alloc]initWithFrame:frame];
        [viewForRow setBackgroundColor:[_arrayColor objectAtIndex:row]];
    }
    
    return viewForRow;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    _selectedColor = [_arrayColor objectAtIndex:row];
    
}
@end
