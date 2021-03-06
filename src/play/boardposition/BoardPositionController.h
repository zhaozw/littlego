// -----------------------------------------------------------------------------
// Copyright 2013 Patrick Näf (herzbube@herzbube.ch)
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


// Forward declarations
@class BoardPositionTableListViewController;
@class BoardPositionToolbarController;


// -----------------------------------------------------------------------------
/// @brief The BoardPositionController class is responsible for aggregating all
/// child view controllers that are related to managing the board position.
///
/// BoardPositionController is a container view controller. It is used on the
/// iPad only.
// -----------------------------------------------------------------------------
@interface BoardPositionController : UIViewController
{
}

@property(nonatomic, retain) BoardPositionTableListViewController* boardPositionTableListViewController;
@property(nonatomic, retain) BoardPositionToolbarController* boardPositionToolbarController;

@end
