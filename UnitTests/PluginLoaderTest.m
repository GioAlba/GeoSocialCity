/*
 * Copyright (C) 2010- Peer internet solutions
 *
 * This file is part of mixare.
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>
 */
//
//  PluginLoaderTest.m
//  Mixare
//
//  Created by Aswin Ly on 12-11-12.
//

#import "PluginLoaderTest.h"
#import "PluginList.h"
#import "DataProcessor.h"

@implementation PluginLoaderTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreatePluginLoader {
    STAssertNotNil([PluginLoader getInstance], @"Singleton not created");
}

- (void)testLoadPluginList {
    PluginLoader *loader = [PluginLoader getInstance];
    [loader addArrayOfPlugins:[[PluginList getInstance] plugins]];
    STAssertNotNil([loader getPluginsFromClassName:@"DataProcessor"], @"Plugins not loaded");
    BOOL check = NO;
    if ([[loader getPluginsFromClassName:@"DataProcessor"][0] conformsToProtocol:@protocol(DataProcessor)]) {
        check = YES;
    }
    STAssertTrue(check, @"Wrong protocol");
}

@end