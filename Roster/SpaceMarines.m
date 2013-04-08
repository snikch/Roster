//
//  SpaceMarines.m
//  Roster
//
//  Created by Mal Curtis on 6/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "SpaceMarines.h"
#import "Army.h"
#import "Unit.h"
#import "Model.h"
#import "Wargear.h"
#import "Option.h"

@implementation SpaceMarines

-(id)init{
    if(self = [super init]){
        _elites = [NSMutableDictionary dictionary];
        _wargear = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)seed{
    NSLog(@"Seeding space marines");
    _army = [NSEntityDescription insertNewObjectForEntityForName:@"Army" inManagedObjectContext:self.managedObjectContext];
    
    [_army setValue: @"Space Marines" forKey:@"name"];
    
    NSLog(@"Seeding wargear into army: %@", _army);
    [self seedWargear];
    [self seedElites];
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(void)seedWargear{
    NSDictionary *names = @{@"Assault cannon": @"", @"Astartes grenade launcher": @"", @"Autocannon": @"", @"Auxiliary grenade launcher": @"", @"Bolt pistol": @"", @"Boltgun": @"", @"Conversion beamer": @"", @"Cyclone missile launcher": @"", @"Deathwind launcher": @"", @"Dragonfire bolts": @"", @"Flamer": @"", @"Flamestorm": @"", @"Heavy bolter": @"", @"Heavy flamer": @"", @"Hellfire round": @"", @"Hellfire shell": @"", @"Kraken bolt": @"", @"Lascannon": @"", @"Meltagun": @"", @"Missile Launcher": @"", @"Multi-melta": @"", @"Plasma cannon": @"", @"Plasma gun": @"", @"Plasma pistol": @"", @"Shotgun": @"", @"Sniper rifle": @"", @"Storm bolter": @"", @"Thunderfire cannon": @"", @"Typhoon missile launcher": @"", @"Vengeance round": @"",
    
    @"Terminator armour": @"", @"Power fist": @"", @"Power sword": @"", @"Chainfist": @""};
    
    for(NSString *key in names){
        
        NSManagedObject *wargear = [NSEntityDescription insertNewObjectForEntityForName:@"Wargear" inManagedObjectContext:self.managedObjectContext];
        [wargear setValue:key forKey:@"name"];
        [wargear setValue:_army forKey:@"army"];
        [_wargear setValue:wargear forKey:key];
    }
}

-(void)seedElites{
    /**
     * Terminator Squad
     */
    Unit *unit = [NSEntityDescription insertNewObjectForEntityForName:@"Unit" inManagedObjectContext:self.managedObjectContext];
    [unit setValue:_army forKey:@"army"];
    [unit setValue:@"Terminator Squad" forKey:@"name"];
    [unit setValue:@"Elite" forKey:@"classification"];
    [unit setValue:[NSNumber numberWithInt: 200] forKey:@"cost"];
    
    Model *captain = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:self.managedObjectContext];
    [captain setValue:unit forKey:@"unit"];
    [captain setValue:@"Terminator Sargeant" forKey:@"name"];
    [captain setValue:[NSNumber numberWithInt:25] forKey:@"cost"];
    
    [captain addWargear:[_wargear valueForKey:@"Terminator armour"]];
    [captain addWargear:[_wargear valueForKey:@"Storm bolter"]];
    [captain addWargear:[_wargear valueForKey:@"Power sword"]];

    [captain addCharacteristics:@[@[@"WS",@"4"], @[@"BS", @"4"], @[@"S", @"4"], @[@"T", @"4"], @[@"W", @"1"], @[@"I", @"4"], @[@"A", @"2"],@[@"Ld", @"9"], @[@"Sv", @"2+"]]];
    
    
    Model *terminator  = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:self.managedObjectContext];
    [terminator setValue:unit forKey:@"unit"];
    [terminator setValue:@"Terminator" forKey:@"name"];
    [terminator setValue:[NSNumber numberWithInt:40] forKey:@"cost"];
    [terminator setValue:[NSNumber numberWithInt:5] forKey:@"included"];
    [terminator setValue:[NSNumber numberWithInt:5] forKey:@"max"];
    
    [terminator addWargear:[_wargear valueForKey:@"Terminator armour"]];
    [terminator addWargear:[_wargear valueForKey:@"Storm bolter"]];
    [terminator addWargear:[_wargear valueForKey:@"Power fist"]];
    [terminator addCharacteristics:@[@[@"WS",@"4"], @[@"BS", @"4"], @[@"S", @"4"], @[@"T", @"4"], @[@"W", @"1"], @[@"I", @"4"], @[@"A", @"2"],@[@"Ld", @"9"], @[@"Sv", @"2+"]]];
    
    NSManagedObject *group = [NSEntityDescription insertNewObjectForEntityForName:@"OptionGroup" inManagedObjectContext:self.managedObjectContext];
    [group setValue:terminator forKey:@"model"];
    [group setValue:@"Heavy Weapons" forKey:@"name"];
    
    Option *flamer = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
    [flamer setValuesForKeysWithDictionary:@{@"name": @"Heavy Flamer", @"model": terminator, @"cost": [NSNumber numberWithInt: 5], @"wargear": [_wargear valueForKey:@"Heavy flamer"], @"max": [NSNumber numberWithInt:2]}];
    [flamer replacesWargear:[_wargear valueForKey:@"Storm bolter"]];
    
    Option *assCannon = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
    [assCannon setValuesForKeysWithDictionary:@{@"name": @"Assault Cannon", @"model": terminator, @"cost": [NSNumber numberWithInt: 30], @"wargear": [_wargear valueForKey:@"Assault cannon"], @"max": [NSNumber numberWithInt:2]}];
    [assCannon replacesWargear:[_wargear valueForKey:@"Storm bolter"]];
    
    Option *cyclone = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
    [cyclone setValuesForKeysWithDictionary:@{@"name": @"Cyclone missile launcher", @"model": terminator, @"cost": [NSNumber numberWithInt: 30], @"wargear": [_wargear valueForKey:@"Cyclone missile launcher"], @"max": [NSNumber numberWithInt:2]}];
    
    [flamer addToGroup:group];
    [assCannon addToGroup:group];
    [cyclone addToGroup:group];
    
    Option *chainfist = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
    [chainfist setValuesForKeysWithDictionary:@{@"name": @"Chainfist", @"model": terminator, @"cost": [NSNumber numberWithInt: 5], @"wargear": [_wargear valueForKey:@"Chainfist"]}];
    [chainfist replacesWargear:[_wargear valueForKey:@"Power fist"]];
    
}


@end
