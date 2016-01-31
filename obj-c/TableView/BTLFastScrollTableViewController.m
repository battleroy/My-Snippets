//
//  BTLFastScrollTableViewController.m
//  Test
//
//  Created by Admin on 1/31/16.
//  Copyright (c) 2016 BSU. All rights reserved.
//

#import "BTLFastScrollTableViewController.h"
#import <UIImageView+AFNetworking.h>
#import <objc/runtime.h>

@interface NSObject (Associating)

@property (nonatomic, retain) id associatedObject;

@end

@implementation NSObject (Associating)

- (id)associatedObject
{
    return objc_getAssociatedObject(self, @selector(associatedObject));
}

- (void)setAssociatedObject:(id)associatedObject
{
    objc_setAssociatedObject(self,
                             @selector(associatedObject),
                             associatedObject,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface BTLFastScrollTableViewController ()
@property (nonatomic, strong) NSArray *imageUrls; // of NSURL
@end

@implementation BTLFastScrollTableViewController

#pragma mark - Properties

- (NSArray *)imageUrls
{
    if (!_imageUrls) {
        NSMutableArray *urls = [NSMutableArray new];
        
        for (NSUInteger index = 0; index < 100; ++index)
        {
            [urls addObject:[NSString stringWithFormat:
                                  @"http://dummyimage.com/300.png/%06X/%06X&text=%d",
                                  arc4random() % 0xFFFFFF,
                                  arc4random() % 0xFFFFFF,
                                  index + 1]];
        }
        
        _imageUrls = urls;
    }
    return _imageUrls;
}

#pragma mark - VCL

static NSString * const cellIdentifier = @"My Cell";
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageUrls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    static UIImage *placeholderImage;
    static dispatch_once_t placeholderToken;
    dispatch_once(&placeholderToken, ^{
        placeholderImage = [UIImage imageNamed:@"loading.png"];
    });
    NSURL *imageUrl = [NSURL URLWithString:self.imageUrls[indexPath.row]];
    
    // предпочтение ячейкам, которые сейчас на экране
    
    /***********************************************************************
    [cell.imageView cancelImageRequestOperation];
    [cell.imageView setImageWithURL:imageUrl placeholderImage:placeholderImage];
    ************************************************************************/
    
    // даем скачаться всем картинкам, но устанавливаем только те, для которых переиспользованная ячейка валидна
    
    // /*******************************************************************************
    cell.imageView.associatedObject = imageUrl;
    __weak UIImageView *weakImageView = cell.imageView;
    [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:imageUrl]
                          placeholderImage:placeholderImage
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if ([weakImageView.associatedObject isEqual:imageUrl])
            weakImageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [self logError:error];
    }];
    // /*******************************************************************************/
    
    return cell;
}

- (void)logError:(NSError *)error
{
    NSLog(@"Error. Description: %@. Failure reason: %@.", error.localizedDescription, error.localizedFailureReason);
}


@end
