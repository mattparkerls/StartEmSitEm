//
//  ViewController.h
//  StartEmSitEm
//
//  Created by Matthew Parker on 10/28/13.
//  Copyright (c) 2013 Matthew Parker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSURLConnectionDataDelegate, UITextFieldDelegate, NSURLConnectionDelegate, NSXMLParserDelegate>
{
    NSURLConnection *currentConnection;
    NSXMLParser *xmlParser;
    //NSDictionary *json;
    
}

- (IBAction)getStats:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *statResults;
@property (weak, nonatomic) IBOutlet UITextField *playerName;
@property (retain, nonatomic) NSMutableData *apiReturnJSONData;
@property (copy, nonatomic) NSString *enteredPlayerName;
@property (nonatomic) NSInteger statusNbr;
@property (copy, nonatomic) NSString *hygieneResult;
@property (copy, nonatomic) NSString *currentElement;

//@property (weak, nonatomic) IBOutlet UITextField *playerName;
//@property (weak, nonatomic) IBOutlet UILabel *statResults;

@end
