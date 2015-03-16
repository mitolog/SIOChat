#import "Param.h"

@interface Param ()

// Private interface goes here.

@end

@implementation Param

// Custom logic goes here.
- (NSString *)paramStr
{
    NSMutableString *mStr = [@""mutableCopy];

    [mStr appendFormat:@"%@%@", (self.room) ? self.room : @"", kWsDataSeparater];
    [mStr appendFormat:@"%@%@", [self.isParent stringValue], kWsDataSeparater];
    [mStr appendFormat:@"%@%@", self.message, kWsDataSeparater];
    [mStr appendFormat:@"%@%@", self.nickname, kWsDataSeparater];
    [mStr appendFormat:@"%@", self.uuid];
    
    return (NSString *)mStr;
}

- (BOOL)setWsArguments:(NSArray*)args
{
    if(!args || ![args isKindOfClass:[NSArray class]] || args.count <=0 ) return NO;

    NSArray *comps = [args[0] componentsSeparatedByString:kWsDataSeparater];

    BOOL result = NO;
    
    // isParent handling
    id isParentArg = comps[1];
    NSNumber *isParentNum = nil;
    if(isParentArg && [isParentArg isKindOfClass:[NSString class]]){
        
        if([(NSString *)isParentArg isEqualToString:@"1"]){
            isParentNum = @YES;
            result = YES;
        }
        else if([(NSString *)isParentArg isEqualToString:@"0"]){
            isParentNum = @NO;
            result = YES;
        }
        
    }else if([isParentArg isKindOfClass:[NSNumber class]]){
        isParentNum = isParentArg;
        result = YES;
    }
    
    self.isParent = isParentNum;
    self.room = comps[0];
    self.message = comps[2];
    self.nickname = comps[3];
    self.uuid = comps[4];
    
    return result;
}

@end
