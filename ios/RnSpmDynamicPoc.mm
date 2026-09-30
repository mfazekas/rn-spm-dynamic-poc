#import "RnSpmDynamicPoc.h"
#if __has_include(<RnSpmDynamicPoc/RnSpmDynamicPoc-Swift.h>)
#import <RnSpmDynamicPoc/RnSpmDynamicPoc-Swift.h>
#else
#import "RnSpmDynamicPoc-Swift.h"
#endif

@implementation RnSpmDynamicPoc

- (NSNumber *)multiply:(double)a b:(double)b {
    return @(a * b);
}

- (NSString *)getVersion {
    UseAlamofire *af = [[UseAlamofire alloc] init];
    UseRiveRuntime *rive = [[UseRiveRuntime alloc] init];
    return [NSString stringWithFormat:@"%@\n%@", [af getVersion], [rive getVersion]];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeRnSpmDynamicPocSpecJSI>(params);
}

+ (NSString *)moduleName
{
  return @"RnSpmDynamicPoc";
}

@end
