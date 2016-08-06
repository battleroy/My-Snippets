- (void)keyboardWillChangeFrame:(NSNotification *)note
{
//    @property (nonatomic, assign) CGFloat bottomSpaceAccumulator;
//    [center addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    
    CGRect beginRect = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = beginRect.origin.y + beginRect.size.height - (endRect.origin.y + endRect.size.height);
    self.bottomSpaceAccumulator += deltaY;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.bottomSpaceAccumulator, 0.0);
    self.contentScrollView.contentInset = contentInsets;
    self.contentScrollView.scrollIndicatorInsets = contentInsets;
    
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    // Your app might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, self.activeInputView.frame.origin) ) {
//        [self.contentScrollView scrollRectToVisible:self.activeInputView.frame animated:YES];
//    }
}
