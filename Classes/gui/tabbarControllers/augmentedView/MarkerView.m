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

#import "MarkerView.h"
#import "StationCellView.h"

@implementation MarkerView

@synthesize viewTouched, url = _url, popUpView, titleLabel;

- (id)initWithWebView:(PopUpWebView*)webView {
    self = [super init];
    popUpView = webView;
    _percorsoId = nil;
    _stationId = nil;
    return self;
}

//Then, when an event is fired, we log this one and then send it back to the viewTouched we kept, and voilà!!! :)
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    NSLog(@"URL %@", self.url);
    if ([titleLabel.text rangeOfString:@"Stazione "].location != NSNotFound)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _stainInfoArr = [self getDetailInfo:_stationId];
            [self performSelectorOnMainThread:@selector(postGetStationInfo:) withObject:nil waitUntilDone:NO];
        });
    else if ([titleLabel.text rangeOfString:@"Autobus "].location != NSNotFound)
    {
        [popUpView displayAutobusInfo:self.titleLabel.text percorsoId:_percorsoId];
    }
    else
        [popUpView openUrlView:self.url secondo:@""];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {

}

//Touch ended -> showing info view with animation. 
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    
}

- (NSArray *)getDetailInfo:(NSString *)stationId
{
    NSString *url_string = [[NSString alloc] initWithFormat:@"http://geosocialcity.it/webservice/indexpg.php?Stations=%@",
                            stationId
                            ];
      
    url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"URL_STRING %@", url_string);
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_string]];
    
    if(data) {
        NSArray *stationsArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        return stationsArr;
    }
    
    return nil;
}

- (void) postGetStationInfo:(id)sender
{
    [popUpView displayStationInfo:_stainInfoArr title:self.titleLabel.text];
}

@end
