//
//  Seeder.m
//  Roster
//
//  Created by Mal Curtis on 1/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "Seeder.h"

#import "Unit.h"
#import "Model.h"
#import "Option.h"
#import "Wargear.h"

#import "SpaceMarines.h"
#import "XMLDictionary.h"

@implementation Seeder

+(void)insertSeedData:(NSManagedObjectContext *)context{
    int count = 0;
    for(NSString *name in @[@"WS", @"BS", @"S", @"T", @"W", @"I", @"A", @"Ld", @"Sv"]){
        count++;
        NSLog(@"Inserting char template named: %@", name);
        NSManagedObject *characteristic = [NSEntityDescription insertNewObjectForEntityForName:@"CharacteristicTemplate" inManagedObjectContext:context];
        [characteristic setValue:name forKey:@"name"];
        [characteristic setValue:@"Infantry" forKey:@"type"];
        [characteristic setValue:[NSNumber numberWithFloat:count] forKey:@"sortOrder"];
    }
    count = 0;
    for(NSString *name in @[@"WS", @"BS", @"S", @"F", @"S", @"R", @"I", @"A"]){
        count++;
        NSManagedObject *characteristic = [NSEntityDescription insertNewObjectForEntityForName:@"CharacteristicTemplate" inManagedObjectContext:context];
        [characteristic setValue:name forKey:@"name"];
        [characteristic setValue:@"Vehicle (Walker)" forKey:@"type"];
        [characteristic setValue:[NSNumber numberWithFloat:count] forKey:@"sortOrder"];
    }
    count = 0;
    for(NSString *name in @[@"BS", @"F", @"S", @"R"]){
        count++;
        NSManagedObject *characteristic = [NSEntityDescription insertNewObjectForEntityForName:@"CharacteristicTemplate" inManagedObjectContext:context];
        [characteristic setValue:name forKey:@"name"];
        [characteristic setValue:@"Vehicle" forKey:@"type"];
        [characteristic setValue:[NSNumber numberWithFloat:count] forKey:@"sortOrder"];
    }
    count = 0;
    for(NSString *name in @[@"Range", @"Strength", @"AP", @"Type"]){
        count++;
        NSManagedObject *characteristic = [NSEntityDescription insertNewObjectForEntityForName:@"CharacteristicTemplate" inManagedObjectContext:context];
        [characteristic setValue:name forKey:@"name"];
        [characteristic setValue:@"Weapon" forKey:@"type"];
        [characteristic setValue:[NSNumber numberWithFloat:count] forKey:@"sortOrder"];
    }
    //
    //    SpaceMarines *sp = [[SpaceMarines alloc] init];
    //    sp.managedObjectContext = context;
    //    [sp seed];
    
    [self loadABFiles];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}

+(void)loadABFiles{
    /**
     * Get Races definitions
     */
    NSString *armyPath = [[NSBundle mainBundle] pathForResource:@"warhammer6-40k" ofType:@"def"];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLFile:armyPath];
    NSArray *races = [xmlDoc valueForKey:@"race"];
    NSDictionary *sm;
    
    for (NSDictionary *race in races) {
        if ([[race valueForKey:@"_id"] isEqualToString:@"sm"]) {
            sm = race;
        }
    }
    races = nil;
    xmlDoc = nil;
    
    /**
     * Get Generic definitions
     */
    
    NSString *genPath = [[NSBundle mainBundle] pathForResource:@"general6Dat" ofType:@"dat"];
    xmlDoc = [NSDictionary dictionaryWithXMLFile:genPath];
    NSArray *options = [xmlDoc valueForKey:@"option"];
    NSArray *linkSetsArray = [xmlDoc valueForKey:@"linkset"];
    NSArray *units = [xmlDoc valueForKey:@"unit"];
    
    /**
     * Get Race specific definitions
     */
    NSString *smPath = [[NSBundle mainBundle] pathForResource:@"sm5EDat" ofType:@"dat"];
    xmlDoc = [NSDictionary dictionaryWithXMLFile:smPath];
    options = [options arrayByAddingObjectsFromArray:[xmlDoc valueForKey:@"option"]];
    linkSetsArray = [linkSetsArray arrayByAddingObjectsFromArray:[xmlDoc valueForKey:@"linkset"]];
    units = [units arrayByAddingObjectsFromArray:[xmlDoc valueForKey:@"unit"]];
    
    NSMutableDictionary *linkSets = [NSMutableDictionary dictionary];
    for (NSDictionary *linkset in linkSetsArray) {
        [linkSets setValue:linkset forKey:[linkset valueForKey:@"_id"]];
    }
    NSMutableArray *rootUnits = [NSMutableArray array];
    NSMutableDictionary *otherUnits = [NSMutableDictionary dictionary];
    for (NSDictionary *unit in units) {
        NSArray *tags = [unit valueForKey:@"tag"];
        if(tags == nil){
            continue;
        }
        if([[tags class] isSubclassOfClass:[NSDictionary class]]){
            tags = @[tags];
        }
        BOOL wasAdded = NO;
        for (NSDictionary *tag in tags) {
            if (
                [[tag valueForKey:@"_group"] isEqualToString:@"race"]
                &&
                [[tag valueForKey:@"_tag"] isEqualToString:@"sm"]) {
                [rootUnits addObject:unit];
                wasAdded = YES;
                continue;
            }
        }
        if(wasAdded == YES){
            continue;
        }
        NSLog(@"Adding other unit %@: %@", [unit valueForKey:@"_id"], unit);
        [otherUnits setValue:unit forKey:[unit valueForKey:@"_id"]];
    }
    //    NSLog(@"Root Units %@", rootUnits);
    NSManagedObjectContext *context = [Database context];
    Army *army = [NSEntityDescription insertNewObjectForEntityForName:@"Army" inManagedObjectContext:context];
    
    // Options!
    NSMutableDictionary *wargearMap = [NSMutableDictionary dictionary];
    for (NSDictionary *option in options) {
        if([option objectForKey:@"_infoonly"] && [[option valueForKey:@"_infoonly"] isEqualToString:@"yes"]){
            NSLog(@"SKipping %@, infoonly", [option valueForKey:@"_name"]);
            continue;
        }
        if([option objectForKey:@"_category"] && ![@[@"wargear", @"weapons", @"vehicle"] containsObject:[option valueForKey:@"_category"]]){
            NSLog(@"Skipping %@, category is %@", [option valueForKey:@"_name"], [option valueForKey:@"_category"]);
            continue;
        }
        if([option objectForKey:@"_show"] && [@[@"design"] containsObject:[option valueForKey:@"_show"]]){
            NSLog(@"Skipping %@, show is %@", [option valueForKey:@"_name"], [option valueForKey:@"_show"]);
            continue;
        }
        if([option objectForKey:@"_signature"] && [@[@"combos"] containsObject:[option valueForKey:@"_signature"]]){
            NSLog(@"Skipping %@, signature is %@", [option valueForKey:@"_name"], [option valueForKey:@"_signature"]);
            //continue;
        }
        
        Wargear *wargear = [NSEntityDescription insertNewObjectForEntityForName:@"Wargear" inManagedObjectContext:context];
        wargear.name = [option valueForKey:@"_name"];
        wargear.info = [option valueForKey:@"_description"];
        wargear.abbreviation = [option valueForKey:@"_abbrev"];
        wargear.footnote = [NSNumber numberWithBool:([option objectForKey:@"_footnote"] && [[option valueForKey:@"_footnote"] isEqualToString:@"yes"])];
        [wargearMap setValue:wargear forKey:[option valueForKey:@"_id"]];
    }
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    army.name = [sm valueForKey:@"_name"];
    for (NSDictionary *unit in rootUnits) {
        Unit *newUnit = [NSEntityDescription insertNewObjectForEntityForName:@"Unit" inManagedObjectContext:context];
        newUnit.name = [unit valueForKey:@"_name"];
        newUnit.cost = [NSNumber numberWithInt:[[unit valueForKey:@"_textcost"] integerValue]];
        newUnit.army = army;
        NSArray *tags = [unit valueForKey:@"tag"];
        if(tags == nil){
            tags = @[];
        }
        if([[tags class] isSubclassOfClass:[NSDictionary class]]){
            tags = @[tags];
        }
        for (NSDictionary *tag in tags) {
            if (
                [[tag valueForKey:@"_group"] isEqualToString:@"Group"]
                ) {
                newUnit.classification = [tag valueForKey:@"_tag"];
            }

        }
        
        if([unit valueForKey:@"_textcost"] == nil){
            newUnit.cost = [NSNumber numberWithInt:[[unit valueForKey:@"_cost"] integerValue]*[[unit valueForKey:@"_startsize"] integerValue]];
        }
        [self generateModelForUnit:newUnit wargear:wargearMap other:[otherUnits copy] from:unit costs:unit linksets:linkSets];
    }
    
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}

+(void)generateModelForUnit:(Unit*)unit wargear:(NSMutableDictionary*)wargearMap other:(NSDictionary*)otherUnits from:(NSDictionary*)baseDictionary costs:(NSDictionary*)costs linksets:(NSMutableDictionary*)linkSets{
    if(baseDictionary == nil || baseDictionary.count == 0){
        NSLog(@"NOT making model since baseDictionary is nil");
        return;
    }
    NSManagedObjectContext *context = [Database context];
    
    NSLog(@"Creating model with bd %@", baseDictionary);
    Model *model = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:context];
    model.name = [baseDictionary valueForKey:@"_name"];
    model.unit = unit;
    model.cost = [NSNumber numberWithInt:[[costs valueForKey:@"_cost"] integerValue]];
    model.included = [NSNumber numberWithInt:[[baseDictionary valueForKey:@"_startsize"] integerValue]];
    model.max = [NSNumber numberWithInt:[[baseDictionary valueForKey:@"_maxsize"] integerValue] - [model.included integerValue]];
    
    NSLog(@"Creating stats");
    NSMutableArray *stats = [NSMutableArray array];
    for (NSDictionary *stat in [baseDictionary valueForKey:@"statval"]) {
        [stats addObject:@[[stat valueForKey:@"_stat"], [stat valueForKey:@"_value"]]];
    }
    [model addCharacteristics:[stats copy]];
    
    // Base Wargear
    NSArray *links = [baseDictionary valueForKey:@"link"];
    if([[links class] isSubclassOfClass:[NSDictionary class]]){
        links = @[links];
    }
    [self handleLinkSet:links model:model wargear:wargearMap otherUnits:otherUnits unit:unit linksets:linkSets];
    NSArray *linkrefs = [baseDictionary valueForKey:@"linkref"];
    NSLog(@"Finding linkrefs %@", linkrefs);

    if([[linkrefs class] isSubclassOfClass:[NSDictionary class]]){
        linkrefs = @[linkrefs];
    }

    for (NSDictionary *linkref in linkrefs) {
        NSLog(@"Finding linkref %@", linkref);
        NSArray *linkset = [linkSets valueForKey:[linkref valueForKey:@"_id"]];
        if(linkset == nil){
            NSLog(@"Could not find linkset %@", [linkref  valueForKey:@"_id"]);
            continue;
        }
        NSArray *options = [linkset valueForKey:@"option"];
        if([[options class] isSubclassOfClass:[NSDictionary class]]){
            options = @[options];
        }
        [self handleLinkSet:options model:model wargear:wargearMap otherUnits:otherUnits unit:unit linksets:linkSets];
    }
}
+(void)handleLinkSet:(NSArray*)links model:(Model*)model wargear:(NSDictionary*)wargearMap otherUnits:(NSDictionary*)otherUnits unit:(Unit*)unit linksets:(NSMutableDictionary*)linkSets{
    NSManagedObjectContext *context = [Database context];

    for (NSDictionary *link in links) {
        if([link objectForKey:@"_hide"] || [@[@"yes"] containsObject:[link valueForKey:@"_hide"]]){
            continue;
        }
        if(![link objectForKey:@"_nature"] || ![@[@"base", @"auto"] containsObject:[link valueForKey:@"_nature"]]){
            // Not base wargear
//            if([link objectForKey:@"_costtype"] && [@[@"single"] containsObject:[link valueForKey:@"_costtype"]]){
                Option *newOption = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:context];
                Wargear *mappedWargear = [wargearMap valueForKey:[link valueForKey:@"_option"]];
                newOption.cost = [NSNumber numberWithInt:[[link valueForKey:@"_cost"] integerValue]];
                newOption.name = mappedWargear.name;
                newOption.wargear = mappedWargear;
                newOption.model = model;
//            }
            continue;
        }else{
            // Base Option
            NSManagedObject *mappedWargear = [wargearMap valueForKey:[link valueForKey:@"_option"]];
            if(mappedWargear == nil){
                NSLog(@"Mapped wargear for %@ does not exist", [link valueForKey:@"_option"]);
                // Included model?
                NSDictionary *otherUnit = [otherUnits valueForKey:[link valueForKey:@"_option"]];
                if(otherUnit != nil){
                    NSLog(@"New Model found %@ with bd %@", [link valueForKey:@"_option"], otherUnit);
                    if([link objectForKey:@"_nature"] && [@[@"auto"] containsObject:[link valueForKey:@"_nature"]]){
                        [self generateModelForUnit: unit wargear:[wargearMap copy] other:otherUnits from:otherUnit costs:link linksets:linkSets];
                    }
                    
                }else{
                    NSLog(@"Nothing found for %@", [link valueForKey:@"_option"]);
                }
            }else{
                NSLog(@"Mapped wargear for %@ exists", [link valueForKey:@"_option"]);
                
                // Base Wargear
                NSManagedObject *wargearLink = [NSEntityDescription insertNewObjectForEntityForName:@"ModelWargear" inManagedObjectContext:context];
                [wargearLink setValue:model forKey:@"model"];
                [wargearLink setValue:mappedWargear forKey:@"wargear"];
            }
        }
    }

}

@end
