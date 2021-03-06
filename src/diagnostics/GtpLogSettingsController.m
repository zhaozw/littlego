// -----------------------------------------------------------------------------
// Copyright 2011-2013 Patrick Näf (herzbube@herzbube.ch)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// -----------------------------------------------------------------------------


// Project includes
#import "GtpLogSettingsController.h"
#import "GtpCommandModel.h"
#import "GtpLogModel.h"
#import "../main/ApplicationDelegate.h"
#import "../ui/TableViewCellFactory.h"
#import "../ui/TableViewSliderCell.h"
#import "../ui/UiUtilities.h"


// -----------------------------------------------------------------------------
/// @brief Enumerates the sections presented in the "Gtp Log Settings" table
/// view.
// -----------------------------------------------------------------------------
enum GtpLogSettingsTableViewSection
{
  SettingsSection,
  ClearLogSection,
  ResetCannedCommandsSection,
  MaxSection
};

// -----------------------------------------------------------------------------
/// @brief Enumerates items in the SettingsSection.
// -----------------------------------------------------------------------------
enum SettingsSectionItem
{
  LogSizeItem,
  MaxSettingsSectionItem
};

// -----------------------------------------------------------------------------
/// @brief Enumerates items in the ClearLogSection.
// -----------------------------------------------------------------------------
enum ClearLogSectionItem
{
  ClearLogItem,
  MaxClearLogSectionItem
};

// -----------------------------------------------------------------------------
/// @brief Enumerates items in the ClearLogSection.
// -----------------------------------------------------------------------------
enum ResetCannedCommandsSectionItem
{
  ResetCannedCommandsItem,
  MaxResetCannedCommandsSectionItem
};


// -----------------------------------------------------------------------------
/// @brief Class extension with private properties for GtpLogSettingsController.
// -----------------------------------------------------------------------------
@interface GtpLogSettingsController()
@property(nonatomic, retain) GtpLogModel* logModel;
@property(nonatomic, retain) GtpCommandModel* commandModel;
@end


@implementation GtpLogSettingsController

// -----------------------------------------------------------------------------
/// @brief Convenience constructor. Creates a GtpLogSettingsController instance
/// of grouped style.
// -----------------------------------------------------------------------------
+ (GtpLogSettingsController*) controller
{
  GtpLogSettingsController* controller = [[GtpLogSettingsController alloc] initWithStyle:UITableViewStyleGrouped];
  if (controller)
    [controller autorelease];
  return controller;
}

// -----------------------------------------------------------------------------
/// @brief Deallocates memory allocated by this GtpLogSettingsController object.
// -----------------------------------------------------------------------------
- (void) dealloc
{
  self.logModel = nil;
  self.commandModel = nil;
  [super dealloc];
}

// -----------------------------------------------------------------------------
/// @brief Called after the controller’s view is loaded into memory, usually
/// to perform additional initialization steps.
// -----------------------------------------------------------------------------
- (void) viewDidLoad
{
  [super viewDidLoad];
  self.logModel = [ApplicationDelegate sharedDelegate].gtpLogModel;
  self.commandModel = [ApplicationDelegate sharedDelegate].gtpCommandModel;
  self.navigationItem.title = @"GTP Settings";
}

// -----------------------------------------------------------------------------
/// @brief Exists for compatibility with iOS 5. Is not invoked in iOS 6 and can
/// be removed if deployment target is set to iOS 6.
// -----------------------------------------------------------------------------
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return [UiUtilities shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDataSource protocol method.
// -----------------------------------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
  return MaxSection;
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDataSource protocol method.
// -----------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
  switch (section)
  {
    case SettingsSection:
      return MaxSettingsSectionItem;
    case ClearLogSection:
      return MaxClearLogSectionItem;
    case ResetCannedCommandsSection:
      return MaxResetCannedCommandsSectionItem;
    default:
      assert(0);
      break;
  }
  return 0;
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDataSource protocol method.
// -----------------------------------------------------------------------------
- (NSString*) tableView:(UITableView*)tableView titleForFooterInSection:(NSInteger)section
{
  if (ResetCannedCommandsSection == section)
    return @"Discards the current list of predefined commands and restores the factory default list that is shipped with the app.";
  else
    return nil;
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDataSource protocol method.
// -----------------------------------------------------------------------------
- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  UITableViewCell* cell = nil;
  switch (indexPath.section)
  {
    case SettingsSection:
    {
      switch (indexPath.row)
      {
        case LogSizeItem:
          cell = [TableViewCellFactory cellWithType:SliderCellType tableView:tableView];
          TableViewSliderCell* sliderCell = (TableViewSliderCell*)cell;
          [sliderCell setDelegate:self actionValueDidChange:nil actionSliderValueDidChange:@selector(logSizeDidChange:)];
          sliderCell.descriptionLabel.text = @"GTP log size";
          sliderCell.slider.minimumValue = gtpLogSizeMinimum;
          sliderCell.slider.maximumValue = gtpLogSizeMaximum;
          sliderCell.value = self.logModel.gtpLogSize;
          break;
        default:
          assert(0);
          break;
      }
      break;
    }
    case ClearLogSection:
    {
      switch (indexPath.row)
      {
        case ClearLogItem:
          cell = [TableViewCellFactory cellWithType:DefaultCellType tableView:tableView];
          cell.textLabel.text = @"Clear GTP log";
          cell.accessoryType = UITableViewCellAccessoryNone;
          break;
        default:
          assert(0);
          break;
      }
      break;
    }
    case ResetCannedCommandsSection:
    {
      switch (indexPath.row)
      {
        case ResetCannedCommandsItem:
          cell = [TableViewCellFactory cellWithType:DefaultCellType tableView:tableView];
          cell.textLabel.text = @"Reset predefined commands";
          cell.accessoryType = UITableViewCellAccessoryNone;
          break;
        default:
          assert(0);
          break;
      }
      break;
    }
    default:
      assert(0);
      break;
  }
  return cell;
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDelegate protocol method.
// -----------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  CGFloat height = tableView.rowHeight;
  if (SettingsSection == indexPath.section && LogSizeItem == indexPath.row)
    height = [TableViewSliderCell rowHeightInTableView:tableView];
  return height;
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDelegate protocol method.
// -----------------------------------------------------------------------------
- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

  if (ClearLogSection == indexPath.section && ClearLogItem == indexPath.row)
    [self.logModel clearLog];
  else if (ResetCannedCommandsSection == indexPath.section && ResetCannedCommandsItem == indexPath.row)
    [self.commandModel resetToFactorySettings];
}

// -----------------------------------------------------------------------------
/// @brief Reacts to the user changing the GTP log size.
// -----------------------------------------------------------------------------
- (void) logSizeDidChange:(id)sender
{
  TableViewSliderCell* sliderCell = (TableViewSliderCell*)sender;
  self.logModel.gtpLogSize = sliderCell.value;
}

@end
