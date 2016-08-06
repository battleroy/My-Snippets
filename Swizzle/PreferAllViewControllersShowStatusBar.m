+ (void)load
{
    [super load];
    
    [AppDelegate preferShowStatusBarInAllViewControllers];
}

+ (void)preferShowStatusBarInAllViewControllers
{
    IMP newImplementation = imp_implementationWithBlock(^BOOL(void){
        return NO;
    });
    
    SEL replacingMethodSelector = @selector(prefersStatusBarHidden);
    Method oldMethod = class_getInstanceMethod([UIViewController class], replacingMethodSelector);
    class_replaceMethod([UIViewController class], replacingMethodSelector, newImplementation, method_getTypeEncoding(oldMethod));
}
