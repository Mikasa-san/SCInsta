#import "SCICustomFontsViewController.h"

@interface SCICustomFontsViewController () <UITableViewDataSource, UITableViewDelegate, UIFontPickerViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray<NSString *> *items;

@end

NSString const *kCustomFontKey = @"custom_fonts";

///

@implementation SCICustomFontsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadItems];
    
    self.title = @"Custom Fonts";

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.editing = YES;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-22.5, 0, 0, 0);
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.rowHeight = 72;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(addFont)];

    [self.view addSubview:self.tableView];
}


// MARK: - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIListContentConfiguration *cellContentConfig = cell.defaultContentConfiguration;
    
    cellContentConfig.text = self.items[indexPath.row];
    cellContentConfig.textProperties.font = [UIFont fontWithName:self.items[indexPath.row] size:25.0];
    
    cell.contentConfiguration = cellContentConfig;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveItems];
    }
}

- (void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
    toIndexPath:(NSIndexPath *)destinationIndexPath {

    NSString *item = self.items[sourceIndexPath.row];
    [self.items removeObjectAtIndex:sourceIndexPath.row];
    [self.items insertObject:item atIndex:destinationIndexPath.row];
    [self saveItems];
}


// MARK: - UIFontPickerViewControllerDelegate

- (void)fontPickerViewControllerDidPickFont:(UIFontPickerViewController *)fontPicker {
    if (!fontPicker.selectedFontDescriptor) return;
    
    UIFont *font = [UIFont fontWithDescriptor:fontPicker.selectedFontDescriptor size:30.0];
    
    if (![self.items containsObject:font.fontName]) {
        [self.items addObject:font.fontName];
        [self saveItems];
        [self.tableView reloadData];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


// MARK: - Actions

- (void)addFont {
    UIFontPickerViewController *fontPicker = [UIFontPickerViewController new];
    fontPicker.delegate = self;
    
    [self presentViewController:fontPicker animated:YES completion:nil];
}


// MARK: - Storage

- (void)loadItems {
    NSArray *saved = [[NSUserDefaults standardUserDefaults] arrayForKey:kCustomFontKey];
    self.items = saved ? [saved mutableCopy] : [NSMutableArray array];
}

- (void)saveItems {
    [[NSUserDefaults standardUserDefaults] setObject:[self.items copy] forKey:kCustomFontKey];
}

@end
