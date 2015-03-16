// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Param.m instead.

#import "_Param.h"

const struct ParamAttributes ParamAttributes = {
	.isParent = @"isParent",
	.message = @"message",
	.nickname = @"nickname",
	.room = @"room",
	.uuid = @"uuid",
};

@implementation ParamID
@end

@implementation _Param

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Param" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Param";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Param" inManagedObjectContext:moc_];
}

- (ParamID*)objectID {
	return (ParamID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isParentValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isParent"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic isParent;

- (BOOL)isParentValue {
	NSNumber *result = [self isParent];
	return [result boolValue];
}

- (void)setIsParentValue:(BOOL)value_ {
	[self setIsParent:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsParentValue {
	NSNumber *result = [self primitiveIsParent];
	return [result boolValue];
}

- (void)setPrimitiveIsParentValue:(BOOL)value_ {
	[self setPrimitiveIsParent:[NSNumber numberWithBool:value_]];
}

@dynamic message;

@dynamic nickname;

@dynamic room;

@dynamic uuid;

@end

