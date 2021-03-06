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
#import "ScoringSettingsController.h"
#import "../main/ApplicationDelegate.h"
#import "../play/model/ScoringModel.h"
#import "../ui/TableViewCellFactory.h"
#import "../ui/UiUtilities.h"

// Constants
NSString* markDeadStonesIntelligentlyText = @"Mark dead stones intelligently";


// -----------------------------------------------------------------------------
/// @brief Enumerates the sections presented in the "Scoring" user preferences
/// table view.
// -----------------------------------------------------------------------------
enum ScoringTableViewSection
{
  ScoreWhenGameEndsSection,
  ScoringSection,
  MaxSection
};

// -----------------------------------------------------------------------------
/// @brief Enumerates items in the ScoreWhenGameEndsSection.
// -----------------------------------------------------------------------------
enum ScoreWhenGameEndsSectionItem
{
  ScoreWhenGameEndsItem,
  MaxScoreWhenGameEndsSectionItem
};

// -----------------------------------------------------------------------------
/// @brief Enumerates items in the ScoringSection.
// -----------------------------------------------------------------------------
enum ScoringSectionItem
{
  AskGtpEngineForDeadStonesItem,
  MarkDeadStonesIntelligentlyItem,
  InconsistentTerritoryMarkupTypeItem,
  MaxScoringSectionItem
};


// -----------------------------------------------------------------------------
/// @brief Class extension with private properties for
/// ScoringSettingsController.
// -----------------------------------------------------------------------------
@interface ScoringSettingsController()
@property(nonatomic, assign) ScoringModel* scoringModel;
@end


@implementation ScoringSettingsController

// -----------------------------------------------------------------------------
/// @brief Convenience constructor. Creates a ScoringSettingsController instance
/// of grouped style.
// -----------------------------------------------------------------------------
+ (ScoringSettingsController*) controller
{
  ScoringSettingsController* controller = [[ScoringSettingsController alloc] initWithStyle:UITableViewStyleGrouped];
  if (controller)
    [controller autorelease];
  return controller;
}

// -----------------------------------------------------------------------------
/// @brief Deallocates memory allocated by this ScoringSettingsController
/// object.
// -----------------------------------------------------------------------------
- (void) dealloc
{
  self.scoringModel = nil;
  [super dealloc];
}

// -----------------------------------------------------------------------------
/// @brief Called after the controller’s view is loaded into memory, usually
/// to perform additional initialization steps.
// -----------------------------------------------------------------------------
- (void) viewDidLoad
{
  [super viewDidLoad];

  ApplicationDelegate* delegate = [ApplicationDelegate sharedDelegate];
  self.scoringModel = delegate.scoringModel;
  
  self.title = @"Scoring settings";
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
    case ScoreWhenGameEndsSection:
      return MaxScoreWhenGameEndsSectionItem;
    case ScoringSection:
      return MaxScoringSectionItem;
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
  if (ScoreWhenGameEndsSection == section)
    return @"Turn this on to automatically activate scoring mode when the game ends.";
  else if (ScoringSection == section)
    return @"The style to mark inconsistent territory. This is territory where something about the dead or alive state of neighbouring stones is inconsistent, thus making it impossible to determine whether the territory is black, white or neutral. For instance, the territory has neighbouring stones of both colors, but both colors are marked dead.";
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
    case ScoreWhenGameEndsSection:
    {
      cell = [TableViewCellFactory cellWithType:SwitchCellType tableView:tableView];
      UISwitch* accessoryView = (UISwitch*)cell.accessoryView;
      accessoryView.enabled = YES;
      cell.textLabel.text = @"Score when game ends";;
      accessoryView.on = self.scoringModel.scoreWhenGameEnds;
      [accessoryView addTarget:self action:@selector(toggleScoreWhenGameEnds:) forControlEvents:UIControlEventValueChanged];
      break;
    }
    case ScoringSection:
    {
      switch (indexPath.row)
      {
        case AskGtpEngineForDeadStonesItem:
        case MarkDeadStonesIntelligentlyItem:
        {
          cell = [TableViewCellFactory cellWithType:SwitchCellType tableView:tableView];
          UISwitch* accessoryView = (UISwitch*)cell.accessoryView;
          accessoryView.enabled = YES;
          if (AskGtpEngineForDeadStonesItem == indexPath.row)
          {
            cell.textLabel.text = @"Find dead stones";
            accessoryView.on = self.scoringModel.askGtpEngineForDeadStones;
            [accessoryView addTarget:self action:@selector(toggleAskGtpEngineForDeadStones:) forControlEvents:UIControlEventValueChanged];
          }
          else
          {
            cell.textLabel.text = markDeadStonesIntelligentlyText;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.numberOfLines = 0;
            accessoryView.on = self.scoringModel.markDeadStonesIntelligently;
            [accessoryView addTarget:self action:@selector(toggleMarkDeadStonesIntelligently:) forControlEvents:UIControlEventValueChanged];
          }
          break;
        }
        case InconsistentTerritoryMarkupTypeItem:
        {
          cell = [TableViewCellFactory cellWithType:Value1CellType tableView:tableView];
          cell.textLabel.text = @"Inconsistent territory";
          cell.detailTextLabel.text = [self inconsistentTerritoryMarkupTypeAsString:self.scoringModel.inconsistentTerritoryMarkupType];
          break;
        }
        default:
        {
          assert(0);
          break;
        }
      }
      break;
    }
    default:
    {
      assert(0);
      break;
    }
  }

  return cell;
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDelegate protocol method.
// -----------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  NSString* cellText;
  switch (indexPath.row)
  {
    case MarkDeadStonesIntelligentlyItem:
      cellText = markDeadStonesIntelligentlyText;
      break;
    default:
      return tableView.rowHeight;
  }
  return [UiUtilities tableView:tableView
            heightForCellOfType:SwitchCellType
                       withText:cellText
         hasDisclosureIndicator:false];
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDelegate protocol method.
// -----------------------------------------------------------------------------
- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

  switch (indexPath.section)
  {
    case ScoringSection:
    {
      if (InconsistentTerritoryMarkupTypeItem == indexPath.row)
        [self pickInconsistentTerritoryMarkupType];
      break;
    }
    default:
    {
      break;
    }
  }
}

// -----------------------------------------------------------------------------
/// @brief Reacts to a tap gesture on the "Score when game ends" switch. Writes
/// the new value to the appropriate model.
// -----------------------------------------------------------------------------
- (void) toggleScoreWhenGameEnds:(id)sender
{
  UISwitch* accessoryView = (UISwitch*)sender;
  self.scoringModel.scoreWhenGameEnds = accessoryView.on;
}

// -----------------------------------------------------------------------------
/// @brief Reacts to a tap gesture on the "Find dead stones" switch. Writes
/// the new value to the appropriate model.
// -----------------------------------------------------------------------------
- (void) toggleAskGtpEngineForDeadStones:(id)sender
{
  UISwitch* accessoryView = (UISwitch*)sender;
  self.scoringModel.askGtpEngineForDeadStones = accessoryView.on;
}

// -----------------------------------------------------------------------------
/// @brief Reacts to a tap gesture on the "Mark dead stones intelligently"
/// switch. Writes the new value to the appropriate model.
// -----------------------------------------------------------------------------
- (void) toggleMarkDeadStonesIntelligently:(id)sender
{
  UISwitch* accessoryView = (UISwitch*)sender;
  self.scoringModel.markDeadStonesIntelligently = accessoryView.on;
}

// -----------------------------------------------------------------------------
/// @brief Displays ItemPickerController to allow the user to pick a new value
/// for the InconsistentTerritoryMarkupType property.
// -----------------------------------------------------------------------------
- (void) pickInconsistentTerritoryMarkupType
{
  NSMutableArray* itemList = [NSMutableArray arrayWithCapacity:0];
  [itemList addObject:[self inconsistentTerritoryMarkupTypeAsString:InconsistentTerritoryMarkupTypeDotSymbol]];
  [itemList addObject:[self inconsistentTerritoryMarkupTypeAsString:InconsistentTerritoryMarkupTypeFillColor]];
  [itemList addObject:[self inconsistentTerritoryMarkupTypeAsString:InconsistentTerritoryMarkupTypeNeutral]];
  ItemPickerController* modalController = [ItemPickerController controllerWithItemList:itemList
                                                                                 title:@"Select style"
                                                                    indexOfDefaultItem:self.scoringModel.inconsistentTerritoryMarkupType
                                                                              delegate:self];
  modalController.footerTitle = @"Select neutral to not mark inconsistent territory at all, thus making it look as if it were neutral territory. Select this option if you are confident that you don't need any help picking out inconsistencies.";
  UINavigationController* navigationController = [[UINavigationController alloc]
                                                  initWithRootViewController:modalController];
  navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  [self presentViewController:navigationController animated:YES completion:nil];
  [navigationController release];
}

// -----------------------------------------------------------------------------
/// @brief ItemPickerDelegate protocol method.
// -----------------------------------------------------------------------------
- (void) itemPickerController:(ItemPickerController*)controller didMakeSelection:(bool)didMakeSelection
{
  if (didMakeSelection)
  {
    if (self.scoringModel.inconsistentTerritoryMarkupType != controller.indexOfSelectedItem)
    {
      self.scoringModel.inconsistentTerritoryMarkupType = controller.indexOfSelectedItem;
      NSIndexPath* indexPath = [NSIndexPath indexPathForRow:InconsistentTerritoryMarkupTypeItem inSection:ScoringSection];
      [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                            withRowAnimation:UITableViewRowAnimationNone];
    }
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

// -----------------------------------------------------------------------------
/// @brief Returns a short string for @a markupType that is suitable for display
/// in a cell in the table view managed by this controller.
// -----------------------------------------------------------------------------
- (NSString*) inconsistentTerritoryMarkupTypeAsString:(enum InconsistentTerritoryMarkupType)markupType
{
  switch (markupType)
  {
    case InconsistentTerritoryMarkupTypeDotSymbol:
      return @"Dot symbol";
    case InconsistentTerritoryMarkupTypeFillColor:
      return @"Fill color";
    case InconsistentTerritoryMarkupTypeNeutral:
      return @"Neutral";
    default:
      assert(0);
      break;
  }
  return nil;
}

@end
