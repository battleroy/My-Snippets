- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Getting attributed string
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.texts[indexPath.row]];
    
    // Setting its attributes
    [attributedText addAttribute:NSFontAttributeName value:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:40.0f] range:NSMakeRange(15, 89)
     ];
    
    CGFloat width = tableView.bounds.size.width; // initial width
    width -= (64 + 8); // adjusting according to gaps between inner views
    width -= 2 * 8; // adjusting according to outer margins
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        context:nil];
    CGFloat height = (ceil(rect.size.height) + 1); // initial height
    height += 2 * 8; // adjusting according to outer margins
    return height;
}
