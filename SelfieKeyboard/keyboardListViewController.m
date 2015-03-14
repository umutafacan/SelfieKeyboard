//
//  keyboardListViewController.m
//  SelfieKeyboard
//
//  Created by umut on 02/03/15.
//  Copyright (c) 2015 Umut Afacan. All rights reserved.
//

#import "keyboardListViewController.h"
#import "KeyboardEditViewController.h"

@interface keyboardListViewController ()

@property (strong,nonatomic) NSMutableArray *keyboardList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation keyboardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *keyboardArray = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"KeyboardList"];
    
    if (keyboardArray) {
        [Singleton sharedInstance].arrayKeyboardList = keyboardArray;
    }else
    {
        KeyboardModel *keyboard1 = [KeyboardModel new];
        [keyboard1 setKeyboardName:@"First Keyboard" andID:0];

        KeyboardModel *keyboard2 = [KeyboardModel new];
        [keyboard2 setKeyboardName:@"Second Keyboard" andID:1];
        
        KeyboardModel *keyboard3 = [KeyboardModel new];
        [keyboard3 setKeyboardName:@"Third Keyboard" andID:2];
        
        [Singleton sharedInstance].arrayKeyboardList  = @[keyboard1, keyboard2, keyboard3 ];
        
        [[NSUserDefaults standardUserDefaults] rm_setCustomObject:[Singleton sharedInstance].arrayKeyboardList forKey:@"KeyboardList"];
        
    }
    
    _keyboardList = [[NSMutableArray alloc]initWithArray:[Singleton sharedInstance].arrayKeyboardList];
    
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView setEditing:YES animated:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"keyboardCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    KeyboardModel *keyboard = [_keyboardList objectAtIndex:indexPath.row];
    NSLog(@"Keyboard %@, id %d",keyboard.keyboardName,keyboard.keyboardID);
    
    cell.textLabel.text = keyboard.keyboardName;
    cell.showsReorderControl=YES;
    [cell setEditing:YES];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _keyboardList.count;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    KeyboardModel *stringToMove = [self.keyboardList objectAtIndex:sourceIndexPath.row];
    
    [self.keyboardList removeObjectAtIndex:sourceIndexPath.row];
    [self.keyboardList insertObject:stringToMove atIndex:destinationIndexPath.row];
   
    
    [[NSUserDefaults standardUserDefaults] rm_setCustomObject:self.keyboardList forKey:@"KeyboardList"];
    [Singleton sharedInstance].arrayKeyboardList = self.keyboardList;
    
    NSLog(@"Keyboard List %@",self.keyboardList);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"detailPush"])
    {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        KeyboardEditViewController *newVc = segue.destinationViewController;
        
        KeyboardModel *keyboard = [_keyboardList objectAtIndex:indexPath.row];
        newVc.textNameOfKeyboard = keyboard.keyboardName;
        newVc.keyboardID = keyboard.keyboardID;
    }
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
