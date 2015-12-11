//
//  allNotes.h
//  Knote
//
//  Created by Allen X on 11/5/15.
//  Copyright © 2015 Allen X. All rights reserved.
//

#import <Realm/Realm.h>

@interface allNotes : RLMObject
@property(strong,nonatomic) NSString *notesContent;
@property(strong,nonatomic) NSString *notesName;
@property(strong,nonatomic) NSData *notesPic;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<allNotes>
RLM_ARRAY_TYPE(allNotes)
