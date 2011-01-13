//
//  Draw2D.m
//  Draw_iPad
//
//  Created by Dennis Hübner on 30.11.10.
//  Copyright 2010 huebys inventions. All rights reserved.
//

#import "Draw2D.h"


@implementation Draw2D


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
	return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, 2.0);
	CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
	
	// (neuen) Startpunkt im context festlegen 
	
	CGContextMoveToPoint(context, 0, 50);
	// Zeichne 0000 0100 1110..., 
	// Längen- und Höhenabstand zwischen 2 Werten jeweils 10 pt
	
	// 00000 
	CGContextAddLineToPoint(context, 60, 50);
	
	// 1 
	CGContextAddLineToPoint(context, 60, 40); 
	CGContextAddLineToPoint(context, 70, 40); 
	CGContextAddLineToPoint(context, 70, 50);
	
	// 00 
	CGContextAddLineToPoint(context, 90, 50);

	// 111 
	CGContextAddLineToPoint(context, 90, 40); 
	CGContextAddLineToPoint(context, 120, 40); 
	CGContextAddLineToPoint(context, 120, 50);
	
	// 0...0 
	CGContextAddLineToPoint(context, 310, 50);
	
	// Die folgenden Linien werden nur durch Scrollen sichtbar 
	CGContextAddLineToPoint(context, 310, 40); 
	CGContextAddLineToPoint(context, 330, 40); 
	CGContextAddLineToPoint(context, 330, 50); 
	CGContextAddLineToPoint(context, 370, 50); 
	CGContextAddLineToPoint(context, 370, 40); 
	CGContextAddLineToPoint(context, 400, 40); 
	CGContextAddLineToPoint(context, 400, 50);
	CGContextAddLineToPoint(context, 450, 50);

	// Zeichnet eine Linie entlang des aktuellen Pfads 
	CGContextStrokePath(context);
}


- (void)dealloc {
    [super dealloc];
}


@end
