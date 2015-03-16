// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Param.h instead.

#import <CoreData/CoreData.h>

extern const struct ParamAttributes {
	__unsafe_unretained NSString *isParent;
	__unsafe_unretained NSString *message;
	__unsafe_unretained NSString *nickname;
	__unsafe_unretained NSString *room;
	__unsafe_unretained NSString *uuid;
} ParamAttributes;

@interface ParamID : NSManagedObjectID {}
@end

@interface _Param : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ParamID* objectID;

@property (nonatomic, strong) NSNumber* isParent;

@property (atomic) BOOL isParentValue;
- (BOOL)isParentValue;
- (void)setIsParentValue:(BOOL)value_;

//- (BOOL)validateIsParent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* message;

//- (BOOL)validateMessage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* nickname;

//- (BOOL)validateNickname:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* room;

//- (BOOL)validateRoom:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* uuid;

//- (BOOL)validateUuid:(id*)value_ error:(NSError**)error_;

@end

@interface _Param (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveIsParent;
- (void)setPrimitiveIsParent:(NSNumber*)value;

- (BOOL)primitiveIsParentValue;
- (void)setPrimitiveIsParentValue:(BOOL)value_;

- (NSString*)primitiveMessage;
- (void)setPrimitiveMessage:(NSString*)value;

- (NSString*)primitiveNickname;
- (void)setPrimitiveNickname:(NSString*)value;

- (NSString*)primitiveRoom;
- (void)setPrimitiveRoom:(NSString*)value;

- (NSString*)primitiveUuid;
- (void)setPrimitiveUuid:(NSString*)value;

@end
