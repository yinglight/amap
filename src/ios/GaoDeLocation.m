/********* GaoDeLocation.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapLocationKit/AMapLocationKit.h>
@interface GaoDeLocation : CDVPlugin {
    // Member variables go here.
}

@property(nonatomic,strong)NSString *IOS_API_KEY;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property(nonatomic,strong)NSString *currentCallbackId;
@property (nonatomic, assign) BOOL locatingWithReGeocode;
- (void)getCurrentPosition:(CDVInvokedUrlCommand*)command;
@end

@implementation GaoDeLocation
-(void)pluginInitialize
{
    self.IOS_API_KEY = [[self.commandDelegate settings] objectForKey:@"ios_api_key"];

    [AMapServices sharedServices].apiKey =self.IOS_API_KEY;
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self configLocationManager];

}
- (void)getCurrentPosition:(CDVInvokedUrlCommand*)command
{
    self.currentCallbackId = command.callbackId;
    NSString* argument = command.arguments[0];
    if ([argument isEqualToString: @"start"]) {
        [self.locationManager startUpdatingLocation]; // 持续定位开始
        // [self locateAction]; // 单次定位
    } else if ([argument isEqualToString: @"stop"]) {
        [self.locationManager stopUpdatingLocation];
    } else {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init]; // 初始化AmapLocationManager对象

    [self.locationManager setDelegate: self]; // 初始化AmapLocationManager对象

    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];

    // [self.locationManager setLocationTimeout:6];

    // [self.locationManager setReGeocodeTimeout:3];

    [self.locationManager setLocatingWithReGeocode:YES];

    [self.locationManager setAllowsBackgroundLocationUpdates:YES];

    // 设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
        NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
        [mDict setObject:@"定位成功" forKey:@"status"];
        [mDict setObject:@"" forKey:@"type"];
        [mDict setObject:[NSNumber numberWithDouble:location.coordinate.latitude]  forKey:@"latitude"];
        [mDict setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"longitude"];
        [mDict setObject:[NSString stringWithFormat:@"%g",location.horizontalAccuracy] forKey:@"accuracy"];
        if(reGeocode.country) [mDict setObject:reGeocode.country forKey:@"country"];
        if(reGeocode.province) [mDict setObject:reGeocode.province forKey:@"province"];
        if(reGeocode.city)[mDict setObject:reGeocode.city forKey:@"city"];
        if(reGeocode.citycode)[mDict setObject:reGeocode.citycode forKey:@"citycode"];
        if(reGeocode.district)[mDict setObject:reGeocode.district forKey:@"district"];
        if(reGeocode.adcode)[mDict setObject:reGeocode.adcode forKey:@"adcode"];
        if(reGeocode.formattedAddress)[mDict setObject:reGeocode.formattedAddress forKey:@"address"];
        if(reGeocode.POIName)[mDict setObject:reGeocode.POIName forKey:@"poi"];

        CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:mDict];
        [self.commandDelegate sendPluginResult:commandResult callbackId:self.currentCallbackId];
    } else {
        NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
        [mDict  setObject:@"定位失败" forKey:@"status"];
        //            [mDict  setObject:location.timestamp forKey:@"errcode"]
        CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@"定位失败"];
        [self.commandDelegate sendPluginResult:commandResult callbackId:self.currentCallbackId];
    }
}

- (void)locateAction
{
    //带逆地理的单次定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //定位信息
        NSLog(@"location:%@", location);
        
        //逆地理信息
        if (regeocode)
        {
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict setObject:@"定位成功" forKey:@"status"];
            [mDict setObject:@"" forKey:@"type"];
            [mDict setObject:[NSNumber numberWithDouble:location.coordinate.latitude]  forKey:@"latitude"];
            [mDict setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"longitude"];
            [mDict setObject:[NSString stringWithFormat:@"%g",location.horizontalAccuracy] forKey:@"accuracy"];
            //        [mDict setObject:[NSString stringWithFormat:@"%g",location.bearing] forKey:@"bearing"];
            //        [mDict setObject:@"one2" forKey:@"satellites"];
            if(regeocode.country){
                [mDict setObject:regeocode.country forKey:@"country"];
                [mDict setObject:regeocode.province forKey:@"province"];
                [mDict setObject:regeocode.city forKey:@"city"];
                [mDict setObject:regeocode.citycode forKey:@"citycode"];
                [mDict setObject:regeocode.district forKey:@"district"];
                [mDict setObject:regeocode.adcode forKey:@"adcode"];
                [mDict setObject:regeocode.formattedAddress forKey:@"address"];
                [mDict setObject:regeocode.POIName forKey:@"poi"];
            }

            //        [mDict setObject:
            //         location.timestamp
            //          forKey:@"time"];
            CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:mDict];
            [self.commandDelegate sendPluginResult:commandResult callbackId:self.currentCallbackId];
        }else{
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            [mDict  setObject:@"定位失败" forKey:@"status"];
            //            [mDict  setObject:location.timestamp forKey:@"errcode"]
            CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:mDict];
            [self.commandDelegate sendPluginResult:commandResult callbackId:self.currentCallbackId];
        }
    }];
}
- (void)successWithCallbackID:(NSString *)callbackID messageAsDictionary:(NSDictionary *)message
{
    NSLog(@"message = %@",message);
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:message];
    [commandResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}
@end
