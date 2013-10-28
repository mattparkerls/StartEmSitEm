//
//  ViewController.m
//  StartEmSitEm
//
//  Created by Matthew Parker on 10/28/13.
//  Copyright (c) 2013 Matthew Parker. All rights reserved.
//

#define espnUserID   @"mattparkerls"
#define espnPassword @"Fg837bht"


#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize enteredPlayerName = _enteredPlayerName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*dispatch_async(Queue, ^){
        NSData* data = [NSData datacContentsOfURL:espnAPIURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)withObject:data waitUntilDone:YES];
    }*/
	

}

/*- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* statArray = [json objectForKey:@"loans"]; //2
    
    NSLog(@"stats: %@", statArray); //3
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)emailTextField {
    
    [emailTextField resignFirstResponder];
    return YES;
    
}

- (IBAction)getStats:(id)sender {
    self.enteredPlayerName = self.playerName.text;
    self.statResults.text = @"";
    NSString *restCallString = [NSString stringWithFormat:@"http://api.espn.com/v1/sports/football/nfl/athletes/1?_accept=text/xml&apikey=b9xt4kdk7gfn9bztw6364etd"];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
    
    // we will want to cancel any current connections
    if( currentConnection)
    {
        [currentConnection cancel];
        currentConnection = nil;
        self.apiReturnJSONData = nil;
    }
    
    currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    
    // If the connection was successful, create the XML that will be returned.
    self.apiReturnJSONData = [NSMutableData data];
    
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    [self.apiReturnJSONData setLength:0];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    [self.apiReturnJSONData appendData:data];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    NSLog(@"URL Connection Failed!");
    currentConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // create our XML parser with the return data from the connection
    xmlParser = [[NSXMLParser alloc] initWithData:self.apiReturnJSONData];
    
    // setup the delgate (see methods below)
    
    [xmlParser setDelegate:self];
    
    // start parsing. The delgate methods will be called as it is iterating through the file.
    [xmlParser parse];
    currentConnection = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary *)attributeDict {
    
    // Log the error - in this case we are going to let the user pass but log the message
    if( [elementName isEqualToString:@"Error"])
    {
        NSLog(@"Web API Error!");
    }
    
    // Pull out the elements we care about.
    if( [elementName isEqualToString:@"StatusNbr"] ||
       [elementName isEqualToString:@"HygieneResult"])
    {
        self.currentElement = [[NSString alloc] initWithString:elementName];
    }
}

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {
    
    if([self.currentElement isEqualToString:@"StatusNbr"])
    {
        self.statusNbr = [string intValue];
        self.currentElement = nil;
    }
    else if([self.currentElement isEqualToString:@"HygieneResult"])
    {
        self.hygieneResult = [[NSString alloc] initWithString:string];
        self.currentElement = nil;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    
    // Determine what we are going to display in the label
    if([self.hygieneResult isEqualToString:@"Spam Trap"])
    {
        self.statResults.text = @"Dangerous email, please correct";
    }
    else if(self.statusNbr >= 300)
    {
        self.statResults.text = @"Invalid email, please re-enter";
    }
    else
    {
        self.statResults.text = @"Thank you for your submission";
        self.statResults.text = _hygieneResult;
        //Debugger(self.statResults.text= _hygieneResult);
        
    }
    
    self.apiReturnJSONData = nil;
}

@end
