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
    [self seedTroops];
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
    NSDictionary *names = @{
        @"Assault cannon":@{@"c": @{@"Range": @"24\"", @"Strength": @"6", @"AP": @"4", @"Type": @"Heavy 4, Rending"}},
        @"Astartes grenade launcher":@{@"c": @{}},
        @"Autocannon":@{@"c": @{}},
        @"Auxiliary grenade launcher":@{@"c": @{}},
        @"Bolt pistol":@{@"c": @{@"Range": @"12\"", @"Strength": @"4", @"AP": @"5", @"Type": @"Pistol"}},
        @"Boltgun":@{@"c": @{@"Range": @"24\"", @"Strength": @"4", @"AP": @"5", @"Type": @"Raipd Fire"}},
        @"Conversion beamer":@{@"c": @{}},
        @"Cyclone missile launcher":@{@"c": @{}},
        @"Deathwind launcher":@{@"c": @{}},
        @"Dragonfire bolts":@{@"c": @{}},
        @"Flamer":@{@"c": @{@"Range": @"Template", @"Strength": @"4", @"AP": @"5", @"Type": @"Assault 1"}},
        @"Flamestorm":@{@"c": @{}},
        @"Heavy bolter":@{@"c": @{@"Range": @"36\"", @"Strength": @"5", @"AP": @"4", @"Type": @"Heavy 3"}},
        @"Heavy flamer":@{@"c": @{@"Range": @"Template", @"Strength": @"5", @"AP": @"4", @"Type": @"Assault 1"}},
        @"Hellfire round":@{@"c": @{}},
        @"Hellfire shell":@{@"c": @{}},
        @"Kraken bolt":@{@"c": @{}},
        @"Lascannon":@{@"c": @{@"Range": @"48\"", @"Strength": @"9", @"AP": @"2", @"Type": @"Heavy 1"}},
        @"Meltagun":@{@"c": @{@"Range": @"12\"", @"Strength": @"8", @"AP": @"1", @"Type": @"Assault 1, Melta"}},
        @"Missile launcher":@{@"c": @{}},
        @"Multi-melta":@{@"c": @{@"Range": @"24\"", @"Strength": @"8", @"AP": @"1", @"Type": @"Heavy 1, Melta"}},
        @"Plasma cannon":@{@"c": @{@"Range": @"36\"", @"Strength": @"7", @"AP": @"2", @"Type": @"Heavy 1, Blast, Gets Hot!"}},
        @"Plasma gun":@{@"c": @{@"Range": @"24\"", @"Strength": @"7", @"AP": @"2", @"Type": @"Rapid Fire, Gets Hot!"}},
        @"Plasma pistol":@{@"c": @{@"Range": @"12\"", @"Strength": @"7", @"AP": @"2", @"Type": @"Pistol, Gets Hot!"}},
        @"Shotgun":@{@"c": @{}},
        @"Sniper rifle":@{@"c": @{}},
        @"Storm bolter":@{@"c": @{@"Range": @"24\"", @"Strength": @"4", @"AP": @"5", @"Type": @"Assault 2"}},
        @"Thunderfire cannon":@{@"c": @{}},
        @"Typhoon missile launcher":@{@"c": @{}},
        @"Vengeance round":@{@"c": @{}},
    
        @"Terminator armour":@{@"c": @{}},
        @"Power fist":@{@"c": @{}},
        @"Power sword":@{@"c": @{}},
        @"Chainfist":@{@"c": @{}},
        @"Lightning claw":@{@"c": @{}},
        @"Thunder hammer and storm shield":@{@"c": @{}},
        @"Power armour":@{@"c": @{}},
        @"Special issue ammunition":@{@"c": @{}},
        @"Frag and krak grenades":@{@"c": @{}},
        @"Power weapon":@{@"c": @{}},
        @"Melta bombs":@{@"c": @{}},
        @"Combi-melta":@{@"c": @{}},
        @"Combi-flamer":@{@"c": @{}},
        @"Combi-plasma":@{@"c": @{}},
        @"Chainsword":@{@"c": @{}},
        @"Teleport homer": @""};
    for(NSString *key in names){
        
        NSManagedObject *wargear = [NSEntityDescription insertNewObjectForEntityForName:@"Wargear" inManagedObjectContext:self.managedObjectContext];
        [wargear setValue:key forKey:@"name"];
        [wargear setValue:_army forKey:@"army"];
        [_wargear setValue:wargear forKey:key];
    }
}

-(void)seedTroops{
    [self tacticalSquad];
}

-(void)seedElites{
    [self terminatorSquad];
    [self terminatorAssaultSquad];
    [self sternguardVeteranSquad];
}

-(void)tacticalSquad{
    Unit *unit = [NSEntityDescription insertNewObjectForEntityForName:@"Unit" inManagedObjectContext:self.managedObjectContext];
    [unit setValue:_army forKey:@"army"];
    [unit setValue:@"Tactical Squad" forKey:@"name"];
    [unit setValue:@"Troops" forKey:@"classification"];
    [unit setValue:@"Infantry" forKey:@"type"];
    [unit setValue:[NSNumber numberWithInt: 90] forKey:@"cost"];
    
    // Captain
    Model *captain = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:self.managedObjectContext];
    [captain setValue:unit forKey:@"unit"];
    [captain setValue:@"Space Marine Sergeant" forKey:@"name"];
    [captain setValue:[NSNumber numberWithInt:1] forKey:@"included"];
    [captain setValue:[NSNumber numberWithInt:0] forKey:@"max"];
    [captain setValue:[NSNumber numberWithInt:0] forKey:@"cost"];
    
    [captain addMultipleWargear:@[[self wargear:@"Power armour"], [self wargear:@"Bolt pistol"], [self wargear:@"Frag and krak grenades"], [self wargear:@"Boltgun"]]];
    
    [captain addCharacteristics:@[@[@"WS",@"4"], @[@"BS", @"4"], @[@"S", @"4"], @[@"T", @"4"], @[@"W", @"1"], @[@"I", @"4"], @[@"A", @"2"],@[@"Ld", @"9"], @[@"Sv", @"3+"]]];
    
    
    [self replace:@[@"Bolt pistol", @"Boltgun"] on:captain with:@{@"Chainsword": @0, @"Combi-melta": @10, @"Combi-flamer": @10, @"Combi-plasma": @10, @"Storm bolter": @10, @"Plasma pistol": @15, @"Power weapon": @15, @"Power fist": @25} max:1 as:@"Weapons"];
    
    [self newOptionNamed:@"Melta bombs" costing:5 max:1 model:captain wargear:@"Melta bombs" group:nil];
    [self newOptionNamed:@"Teleport homer" costing:15 max:1 model:captain wargear:@"Teleport homer" group:nil];
    
    // Model    
    Model *model  = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:self.managedObjectContext];
    [model setValue:unit forKey:@"unit"];
    [model setValue:@"Space Marine" forKey:@"name"];
    [model setValue:[NSNumber numberWithInt:16] forKey:@"cost"];
    [model setValue:[NSNumber numberWithInt:4] forKey:@"included"];
    [model setValue:[NSNumber numberWithInt:5] forKey:@"max"];
    
    [model addMultipleWargear:@[[self wargear:@"Power armour"], [self wargear:@"Bolt pistol"], [self wargear:@"Frag and krak grenades"], [self wargear:@"Boltgun"]]];
    [model addCharacteristics:@[@[@"WS",@"4"], @[@"BS", @"4"], @[@"S", @"4"], @[@"T", @"4"], @[@"W", @"1"], @[@"I", @"4"], @[@"A", @"1"],@[@"Ld", @"8"], @[@"Sv", @"3+"]]];
    
    // Light Weapons
    NSManagedObject *group = [NSEntityDescription insertNewObjectForEntityForName:@"OptionGroup" inManagedObjectContext:self.managedObjectContext];
    [group setValue:model forKey:@"model"];
    [group setValue:@"Weapons" forKey:@"name"];
    
    Option *flamer = [self newOptionNamed:@"Flamer" costing:0 max:1 model:model wargear:@"Flamer" group:group];
    Option *meltagun = [self newOptionNamed:@"Meltagun" costing:5 max:1 model:model wargear:@"Meltagun" group:group];
    Option *plasmagun = [self newOptionNamed:@"Plasma gun" costing:10 max:1 model:model wargear:@"Plasma gun" group:group];
    [flamer replacesWargear:[self wargear:@"Boltgun"]];
    [meltagun replacesWargear:[self wargear:@"Boltgun"]];
    [plasmagun replacesWargear:[self wargear:@"Boltgun"]];
    
    // Heavy Weapons
    group = [NSEntityDescription insertNewObjectForEntityForName:@"OptionGroup" inManagedObjectContext:self.managedObjectContext];
    [group setValue:model forKey:@"model"];
    [group setValue:@"Heavy Weapons" forKey:@"name"];
    
    Option *heavybolter = [self newOptionNamed:@"Heavy bolter" costing:0 max:1 model:model wargear:@"Heavy bolter" group:group];
    [heavybolter replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *multimelta = [self newOptionNamed:@"Multi-melta" costing:0 max:1 model:model wargear:@"Multi-melta" group:group];
    [multimelta replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *missilelauncher = [self newOptionNamed:@"Missile launcher" costing:0 max:1 model:model wargear:@"Missile launcher" group:group];
    [missilelauncher replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *plasmacannon = [self newOptionNamed:@"Plasma cannon" costing:5 max:1 model:model wargear:@"Plasma cannon" group:group];
    [plasmacannon replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *lascannon = [self newOptionNamed:@"Lascannon" costing:10 max:1 model:model wargear:@"Lascannon" group:group];
    [lascannon replacesWargear:[_wargear valueForKey:@"Boltgun"]];
}

-(void)terminatorSquad{
    /**
     * Terminator Squad
     */
    Unit *unit = [NSEntityDescription insertNewObjectForEntityForName:@"Unit" inManagedObjectContext:self.managedObjectContext];
    [unit setValue:_army forKey:@"army"];
    [unit setValue:@"Terminator Squad" forKey:@"name"];
    [unit setValue:@"Elites" forKey:@"classification"];
    [unit setValue:@"Infantry" forKey:@"type"];
    [unit setValue:[NSNumber numberWithInt: 200] forKey:@"cost"];
    
    Model *captain = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:self.managedObjectContext];
    [captain setValue:unit forKey:@"unit"];
    [captain setValue:@"Terminator Sergeant" forKey:@"name"];
    [captain setValue:[NSNumber numberWithInt:1] forKey:@"included"];
    [captain setValue:[NSNumber numberWithInt:0] forKey:@"max"];
    [captain setValue:[NSNumber numberWithInt:25] forKey:@"cost"];
    
    [captain addWargear:[_wargear valueForKey:@"Terminator armour"]];
    [captain addWargear:[_wargear valueForKey:@"Storm bolter"]];
    [captain addWargear:[_wargear valueForKey:@"Power sword"]];
    
    [captain addCharacteristics:@[@[@"WS",@"4"], @[@"BS", @"4"], @[@"S", @"4"], @[@"T", @"4"], @[@"W", @"1"], @[@"I", @"4"], @[@"A", @"2"],@[@"Ld", @"9"], @[@"Sv", @"2+"]]];
    
    
    Model *terminator  = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:self.managedObjectContext];
    [terminator setValue:unit forKey:@"unit"];
    [terminator setValue:@"Terminator" forKey:@"name"];
    [terminator setValue:[NSNumber numberWithInt:40] forKey:@"cost"];
    [terminator setValue:[NSNumber numberWithInt:4] forKey:@"included"];
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
    [chainfist setValuesForKeysWithDictionary:@{@"name": @"Chainfist", @"model": terminator, @"cost": [NSNumber numberWithInt: 5], @"wargear": [_wargear valueForKey:@"Chainfist"], @"max": [NSNumber numberWithInt:10]}];
    [chainfist replacesWargear:[_wargear valueForKey:@"Power fist"]];
}

-(void)terminatorAssaultSquad{
    Unit *unit = [NSEntityDescription insertNewObjectForEntityForName:@"Unit" inManagedObjectContext:self.managedObjectContext];
    [unit setValue:_army forKey:@"army"];
    [unit setValue:@"Terminator Assault Squad" forKey:@"name"];
    [unit setValue:@"Elites" forKey:@"classification"];
    [unit setValue:@"Infantry" forKey:@"type"];
    [unit setValue:[NSNumber numberWithInt: 200] forKey:@"cost"];
    
    Model *captain = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:self.managedObjectContext];
    [captain setValue:unit forKey:@"unit"];
    [captain setValue:@"Terminator Sergeant" forKey:@"name"];
    [captain setValue:[NSNumber numberWithInt:25] forKey:@"cost"];
    [captain setValue:[NSNumber numberWithInt:1] forKey:@"included"];
    [captain setValue:[NSNumber numberWithInt:0] forKey:@"max"];
    
    [captain addWargear:[_wargear valueForKey:@"Terminator armour"]];
    [captain addWargear:[_wargear valueForKey:@"Lightning claw"]];
    
    [captain addCharacteristics:@[@[@"WS",@"4"], @[@"BS", @"4"], @[@"S", @"4"], @[@"T", @"4"], @[@"W", @"1"], @[@"I", @"4"], @[@"A", @"2"],@[@"Ld", @"9"], @[@"Sv", @"2+"]]];
    
    
    Model *terminator  = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:self.managedObjectContext];
    [terminator setValue:unit forKey:@"unit"];
    [terminator setValue:@"Terminator" forKey:@"name"];
    [terminator setValue:[NSNumber numberWithInt:40] forKey:@"cost"];
    [terminator setValue:[NSNumber numberWithInt:4] forKey:@"included"];
    [terminator setValue:[NSNumber numberWithInt:5] forKey:@"max"];
    
    [terminator addWargear:[_wargear valueForKey:@"Terminator armour"]];
    [terminator addWargear:[_wargear valueForKey:@"Lightning claw"]];
    [terminator addCharacteristics:@[@[@"WS",@"4"], @[@"BS", @"4"], @[@"S", @"4"], @[@"T", @"4"], @[@"W", @"1"], @[@"I", @"4"], @[@"A", @"2"],@[@"Ld", @"9"], @[@"Sv", @"2+"]]];
    
    
    Option *hammer = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
    [hammer setValuesForKeysWithDictionary:@{@"name": @"Thunder hammer and storm shield", @"model": terminator, @"cost": [NSNumber numberWithInt: 0], @"max": [NSNumber numberWithInt: 10], @"wargear": [_wargear valueForKey:@"Thunder hammer and storm shield"]}];
    [hammer replacesWargear:[_wargear valueForKey:@"Lightning claw"]];
    
}

-(void)sternguardVeteranSquad{
    Unit *unit = [NSEntityDescription insertNewObjectForEntityForName:@"Unit" inManagedObjectContext:self.managedObjectContext];
    [unit setValue:_army forKey:@"army"];
    [unit setValue:@"Sternguard Veteran Squad" forKey:@"name"];
    [unit setValue:@"Elites" forKey:@"classification"];
    [unit setValue:@"Infantry" forKey:@"type"];
    [unit setValue:[NSNumber numberWithInt: 125] forKey:@"cost"];
    
    Model *captain = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:self.managedObjectContext];
    [captain setValue:unit forKey:@"unit"];
    [captain setValue:@"Space Marine Sergeant" forKey:@"name"];
    [captain setValue:[NSNumber numberWithInt:25] forKey:@"cost"];
    [captain setValue:[NSNumber numberWithInt:1] forKey:@"included"];
    [captain setValue:[NSNumber numberWithInt:0] forKey:@"max"];
    
    [captain addWargear:[_wargear valueForKey:@"Power armour"]];
    [captain addWargear:[_wargear valueForKey:@"Boltgun"]];
    [captain addWargear:[_wargear valueForKey:@"Bolt pistol"]];
    [captain addWargear:[_wargear valueForKey:@"Special issue ammunition"]];
    [captain addWargear:[_wargear valueForKey:@"Frag and krak grenades"]];
    NSLog(@"Caption created");
    
    [captain addCharacteristics:@[@[@"WS",@"4"], @[@"BS", @"4"], @[@"S", @"4"], @[@"T", @"4"], @[@"W", @"1"], @[@"I", @"4"], @[@"A", @"2"],@[@"Ld", @"9"], @[@"Sv", @"3+"]]];
    
    NSManagedObject *group = [NSEntityDescription insertNewObjectForEntityForName:@"OptionGroup" inManagedObjectContext:self.managedObjectContext];
    [group setValue:captain forKey:@"model"];
    [group setValue:@"Weapons" forKey:@"name"];
    
    Option *chainsword = [self newOptionNamed:@"Chainsword" costing:0 max:1 model:captain wargear:@"Chainsword" group:group];
    [chainsword replacesWargear:[_wargear valueForKey:@"Bolt pistol"]];
    [chainsword replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *weapon = [self newOptionNamed:@"Power weapon" costing:15 max:1 model:captain wargear:@"Power weapon" group:group];
    [weapon replacesWargear:[_wargear valueForKey:@"Bolt pistol"]];
    [weapon replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *claw = [self newOptionNamed:@"Lightning claw" costing:15 max:1 model:captain wargear:@"Lightning claw" group:group];
    [claw replacesWargear:[_wargear valueForKey:@"Bolt pistol"]];
    [claw replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *pistol = [self newOptionNamed:@"Plasma pistol" costing:15 max:1 model:captain wargear:@"Plasma pistol" group:group];
    [pistol replacesWargear:[_wargear valueForKey:@"Bolt pistol"]];
    [pistol replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *fist = [self newOptionNamed:@"Power fist" costing:25 max:1 model:captain wargear:@"Power fist" group:group];
    [fist replacesWargear:[_wargear valueForKey:@"Bolt pistol"]];
    [fist replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    [self newOptionNamed:@"Melta bombs" costing:5 max:1 model:captain wargear:@"Melta bombs" group:nil];
    
    
    Model *model  = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:self.managedObjectContext];
    [model setValue:unit forKey:@"unit"];
    [model setValue:@"Veteran" forKey:@"name"];
    [model setValue:[NSNumber numberWithInt:25] forKey:@"cost"];
    [model setValue:[NSNumber numberWithInt:4] forKey:@"included"];
    [model setValue:[NSNumber numberWithInt:5] forKey:@"max"];
    
    [model addWargear:[_wargear valueForKey:@"Power armour"]];
    [model addWargear:[_wargear valueForKey:@"Boltgun"]];
    [model addWargear:[_wargear valueForKey:@"Bolt pistol"]];
    [model addWargear:[_wargear valueForKey:@"Special issue ammunition"]];
    [model addWargear:[_wargear valueForKey:@"Frag and krak grenades"]];
    [model addCharacteristics:@[@[@"WS",@"4"], @[@"BS", @"4"], @[@"S", @"4"], @[@"T", @"4"], @[@"W", @"1"], @[@"I", @"4"], @[@"A", @"2"],@[@"Ld", @"9"], @[@"Sv", @"3+"]]];
    
    
    Option *stormbolter = [self newOptionNamed:@"Storm bolter" costing:5 max:10 model:model wargear:@"Storm bolter" group:nil];
    [stormbolter replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *combimelta = [self newOptionNamed:@"Combi-melta" costing:5 max:10 model:model wargear:@"Combi-melta" group:nil];
    [combimelta replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *combiflamer = [self newOptionNamed:@"Combi-flamer" costing:5 max:10 model:model wargear:@"Combi-flamer" group:nil];
    [combiflamer replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *combiplasma = [self newOptionNamed:@"Combi-plasma" costing:5 max:10 model:model wargear:@"Combi-plasma" group:nil];
    [combiplasma replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    
    group = [NSEntityDescription insertNewObjectForEntityForName:@"OptionGroup" inManagedObjectContext:self.managedObjectContext];
    [group setValue:model forKey:@"model"];
    [group setValue:@"Heavy Weapons" forKey:@"name"];
    
    
    Option *flamer = [self newOptionNamed:@"Flamer" costing:5 max:2 model:model wargear:@"Flamer" group:group];
    [flamer replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *meltagun = [self newOptionNamed:@"Meltagun" costing:5 max:2 model:model wargear:@"Meltagun" group:group];
    [meltagun replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *heavybolter = [self newOptionNamed:@"Heavy bolter" costing:5 max:2 model:model wargear:@"Heavy bolter" group:group];
    [heavybolter replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *multimelta = [self newOptionNamed:@"Multi-melta" costing:5 max:2 model:model wargear:@"Multi-melta" group:group];
    [multimelta replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *missilelauncher = [self newOptionNamed:@"Missile launcher" costing:5 max:2 model:model wargear:@"Missile launcher" group:group];
    [missilelauncher replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *plasmagun = [self newOptionNamed:@"Plasma gun" costing:5 max:2 model:model wargear:@"Plasma gun" group:group];
    [plasmagun replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *plasmacannon = [self newOptionNamed:@"Plasma cannon" costing:5 max:2 model:model wargear:@"Plasma cannon" group:group];
    [plasmacannon replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *heavyflamer = [self newOptionNamed:@"Heavy flamer" costing:10 max:2 model:model wargear:@"Heavy flamer" group:group];
    [heavyflamer replacesWargear:[_wargear valueForKey:@"Boltgun"]];
    Option *lascannon = [self newOptionNamed:@"Lascannon" costing:15 max:2 model:model wargear:@"Lascannon" group:group];
    [lascannon replacesWargear:[_wargear valueForKey:@"Boltgun"]];
       
}

-(Option*)newOptionNamed:(NSString*)name costing:(int)cost max:(int)max model:(NSManagedObject*)model wargear:(NSString*)wargear group:(NSManagedObject*)group{
    Option *option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
    NSLog(@"Created %@", name);
    [option setValuesForKeysWithDictionary:@{
     @"name": name, @"model": model, @"cost": [NSNumber numberWithInt: cost], @"max": [NSNumber numberWithInt: max], @"wargear": [_wargear valueForKey:wargear]
     }];
    if(group != nil){
        [option addToGroup:group];
    }
    return option;
}

-(Wargear*)wargear:(NSString*)name{
    return [_wargear valueForKey:name];
}

-(void)replace:(NSArray*)replacements on:(Model*)model with:(NSDictionary*)values max:(int)max as:(NSString*)name{
    NSManagedObject *group = [NSEntityDescription insertNewObjectForEntityForName:@"OptionGroup" inManagedObjectContext:self.managedObjectContext];
    [group setValue:model forKey:@"model"];
    [group setValue:name forKey:@"name"];
    
    for (NSString *wargearName in values) {
        Option *option = [self newOptionNamed:wargearName
                                      costing:[(NSNumber*)[values valueForKey:wargearName] integerValue]
                                          max:max model:model wargear:wargearName group:group];
        for (NSString *replacementName in replacements) {
            [option replacesWargear:[self wargear:replacementName]];
        }
    }
}


@end
