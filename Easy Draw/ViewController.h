//
//  ViewController.h
//  Easy Draw
//
//  Created by Vlad Melnyk on 23.06.17.
//  Copyright © 2017 VM. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString* const XMLParserListDataNameKey = @"listdata";

static NSString* const lessonDataIdKey = @"_id";
static NSString* const lessonDataRateKey = @"rate";
static NSString* const lessonDataOrderKey = @"order";
static NSString* const lessonDataStepsKey = @"steps";
static NSString* const lessonDataBlackKey = @"black";
static NSString* const lessonDataLockKey = @"lock";
static NSString* const lessonDataDiamondKey = @"diamond";
static NSString* const lessonDataNameKey = @"name";


static NSString* const pathToFileWithLockNameKey = @"lock.txt";


typedef enum{
    FileTypeArray = 0,
    FileTypeDictionary,
    FileTypeString,
} FileType;



@interface ViewController : UIViewController


- (NSMutableArray*) parseLessonsFromXMLFileWithName:(NSString*) name;
- (NSDictionary*) lessonFromArray:(NSArray*) array withNumber:(NSInteger) number;


- (NSString*) pathToFileWithName:(NSString*) name;
- (void) createFileWithPath:(NSString*) path andFileType:(FileType) clasification;
- (id) getInformationFromFileWithPath:(NSString *)path andFileClasification:(FileType)clasification;




- (NSString*) pathToLessonWithNumber:(NSString*) number;
- (NSString*) changeNumber:(NSInteger) number;
@end

