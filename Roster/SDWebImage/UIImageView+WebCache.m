/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "DDProgressView.h"
#import <objc/runtime.h>

static char const * const PBInfoKey = "PBInfoKey";

@implementation UIImageView (WebCache)

@dynamic pbInfo;

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 progressBarInfo:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progressBarInfo:(ProgressBarInfo *)progressBarInfo
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    self.pbInfo = progressBarInfo;
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure progressBarInfo:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure progressBarInfo:(ProgressBarInfo *)progressBarInfo;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    self.pbInfo = progressBarInfo;
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
}

#endif

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    self.image = image;
    [self setNeedsLayout];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
    [self setNeedsLayout];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgress:(double)progress
{
    if (progress > 0) {
        
        if (self.pbInfo != nil && self.pbInfo.hidden == YES)
        {
            return;
        }
        
        DDProgressView *progressView = nil;
        
        if ([self viewWithTag:SDWEBIMAGE_UIVIEW_PROGRESS_TAG] == nil)
        {
            float progressViewWidth = self.frame.size.width * SDWEBIMAGE_UIVIEW_PROGRESS_WIDTH;
            
            // Check if pbInfo is set
            if (self.pbInfo == nil)
            {
                self.pbInfo = [[ProgressBarInfo alloc] init];
            }
            
            // Check if frame is default, which we don't want
            if (CGRectIsEmpty(self.pbInfo.frame))
            {
                self.pbInfo.frame = CGRectMake((self.frame.size.width - progressViewWidth) / 2, self.frame.size.height * SDWEBIMAGE_UIVIEW_PROGRESS_Y, progressViewWidth, 5);
            }
            
            // Alloc the progressbar
            progressView = [[DDProgressView alloc] initWithFrame:self.pbInfo.frame innerSpacing:self.pbInfo.innerspacing];
            progressView.tag = SDWEBIMAGE_UIVIEW_PROGRESS_TAG;
            // Set the properties from the pbinfo object
            progressView.outerColor = self.pbInfo.outerColor;
            progressView.innerColor = self.pbInfo.innerColor;
            progressView.hidden = self.pbInfo.hidden;
                        
            [self addSubview:progressView];
        } else
        {
            progressView = (DDProgressView *)[self viewWithTag:SDWEBIMAGE_UIVIEW_PROGRESS_TAG];
        }
        
        progressView.progress = progress;
        
        if (progress == 1)
        {
            [progressView removeFromSuperview];
        }
    }
}

#pragma mark - Progressbar info getter/settr

- (ProgressBarInfo *)pbInfo
{
    return objc_getAssociatedObject(self, PBInfoKey);
}

- (void)setPbInfo:(ProgressBarInfo *)pbInfo
{
    objc_setAssociatedObject(self, PBInfoKey, pbInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
