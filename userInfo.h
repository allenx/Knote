//
//  userInfo.h
//  Knote
//
//  Created by Allen X on 11/5/15.
//  Copyright © 2015 Allen X. All rights reserved.
//

#import <Realm/Realm.h>

@interface userInfo : RLMObject
@property(weak, nonatomic) NSString *username;
@property(weak, nonatomic) NSString *password;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<userInfo>
RLM_ARRAY_TYPE(userInfo)
