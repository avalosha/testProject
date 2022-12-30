//
//  OpenCVWrapper.h
//  libraryColorPredominanteLITE
//
//  Created by Mario Xavier Canche Uc on 11/07/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (UIImage *)toResize:(UIImage *)source andWidth:(int)width andHeight:(int)height;
//+ (int) convert:(int*) source andWidth:(int)cols andHeight:(int)rows andK:(int)k;
+ (void) convert:(int*) source andWidth:(int)cols andHeight:(int)rows andK:(int)k andPos:(double**)centroides;

+ (UIImage *)toCenter:(UIImage *)source andWidth:(int)width andHeight:(int)height andWidth2:(int)width2 andHeight2:(int)height2 andWidth_c:(int)width_c andHeight_c:(int)height_c andRot:(int)rot;

+ (void) colorPredominante:(UIImage *)source andCenters:(double**)centroides andPosiciones:(double**)posiciones andK:(int)K;


@end

NS_ASSUME_NONNULL_END
