#import "TopPanel.h"
#import "GWDesktopManager.h"

@implementation TopPanel

- (instancetype)initForManager:(GWDesktopManager *)manager {
    self = [super initWithFrame:NSMakeRect(0, 0, 100, 30)];
    if (self) {
        _manager = manager;
        [self setAutoresizingMask:NSViewWidthSizable];
        [self setNeedsDisplay:YES];

        // Listen for global menu changes
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(menuChanged:)
                                                     name:@"NgSTEPGlobalMenuChanged"
                                                   object:nil];
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    [[NSColor controlBackgroundColor] set];
    NSRectFill(rect);
}

- (void)tile {
    NSRect screen = [[NSScreen mainScreen] frame];
    CGFloat height = 30.0;
    [self setFrame:NSMakeRect(0, screen.size.height - height, screen.size.width, height)];
    [self setNeedsDisplay:YES];
}

// Render incoming menu items
- (void)menuChanged:(NSNotification *)note {
    NSMenu *menu = note.object;

    // Clear previous subviews
    for (NSView *v in [self subviews]) {
        [v removeFromSuperview];
    }

    // Render each top-level menu item as a button
    CGFloat x = 10;
    for (NSMenuItem *item in [menu itemArray]) {
        NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(x, 5, 80, 20)];
        [button setTitle:[item title]];
        [button setBezelStyle:NSRoundedBezelStyle];
        [button sizeToFit];
        [button setTarget:item.target];
        [button setAction:item.action];
        [self addSubview:button];
        x += button.frame.size.width + 8;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
