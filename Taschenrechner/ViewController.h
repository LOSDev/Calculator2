//
//  ViewController.h
//  Taschenrechner
//
//  Created by Rincewind on 27.12.12.
//  Copyright (c) 2012 Rincewind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"


@interface ViewController : UIViewController

@property IBOutlet UITextField *calcScreen;
@property BOOL userIsTyping;
@property CalculatorBrain *brain;
    




- (IBAction) numberPressed: (id) sender;
- (IBAction) operationPressed: (id) sender;
- (IBAction) afterDot;
- (IBAction)variablePressed:(id)sender;
- (IBAction)evaluatePressed:(id)sender;

@end
