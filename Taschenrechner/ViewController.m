//
//  ViewController.m
//  Taschenrechner
//
//  Created by Rincewind on 27.12.12.
//  Copyright (c) 2012 Rincewind. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize brain=_brain;
@synthesize calcScreen;
@synthesize userIsTyping;


//set instance variables 
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.brain = [[CalculatorBrain alloc] init];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Display the new number on the screen depending on the nachKomma variable
- (IBAction) numberPressed: (id) sender{
    NSString *number = [NSString stringWithFormat:@"%d",[sender tag]];
    if(userIsTyping){
       calcScreen.text = [calcScreen.text stringByAppendingString:number];
       
    }else{
        calcScreen.text=number;
        userIsTyping=YES;
    }
}

//set the operation selected
- (IBAction) operationPressed: (id) sender{
    NSString *operation = [[sender titleLabel] text];
    [self performOperationWithString:operation];
}


-(void) showMessage:(NSString *) message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                message:message
                delegate:self
                cancelButtonTitle:@"OK"
                otherButtonTitles:nil];
    [alert show];

}


//sets a point if there is none already in the display
- (IBAction) afterDot{
    if ([calcScreen.text rangeOfString:@"."].location == NSNotFound && userIsTyping==YES) {
        NSString *komma = @".";
        calcScreen.text = [calcScreen.text stringByAppendingString:komma];
    }else if (userIsTyping==NO){
        calcScreen.text = @"0.";
        userIsTyping=YES;
    }
}

- (IBAction)variablePressed:(id)sender {
    [self.brain setVariableAsOperand: [[sender titleLabel] text]];
}

- (IBAction)evaluatePressed:(id)sender {
    
    [self deleteEquals];
    
    
    //set up testing Dictionary
	NSArray *keys = [NSArray arrayWithObjects:
					 @"x",
					 @"a",
					 @"b",
					 nil];
	
	NSArray *vals = [NSArray arrayWithObjects:
					 [NSNumber numberWithInt:2],
					 [NSNumber numberWithInt:3],
					 [NSNumber numberWithInt:4],
					 nil];
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:vals forKeys:keys];
    
    //perform an = operation
    [self performOperationWithString:@"="];

    
    //adds an Equal sign to the expression if there is none
	if(![[self.brain.internalExpression lastObject] isEqual:@"="])
        [self.brain.internalExpression addObject:@"="];
    
    //evaluate the expression
	double result = [self.brain evaluateExpression:self.brain.internalExpression
                          usingVariableValues:dictionary];
    NSString *term = [self.brain descriptionOfExpression:self.brain.internalExpression];
   
    
    calcScreen.text= [NSString stringWithFormat:@"%@ %g", term, result];
}

-(void) deleteEquals{
    
    NSMutableArray *expr =[NSMutableArray arrayWithArray:self.brain.internalExpression];
    for (int i=0;i<[expr count];i++){
        if ([expr[i] isKindOfClass:[NSString class]]){
            if ([expr[i] isEqualToString:@"="]){
                [expr removeObject:expr[i]];
            }
        }
    }
    self.brain.internalExpression=expr;

}

-(void)performOperationWithString:(NSString *) op{
    if (userIsTyping) {
        self.brain.operand=[calcScreen.text doubleValue];
        userIsTyping = NO;
    }
    
    double result = [self.brain performOperation:op];
    
    if([self.brain variablesInExpression:self.brain.internalExpression] ==nil){
        calcScreen.text=[NSString stringWithFormat:@"%g", result];
    }else{
        NSString *txt = [self.brain descriptionOfExpression:self.brain.internalExpression];
        calcScreen.text=txt;
    }

}

@end
    
