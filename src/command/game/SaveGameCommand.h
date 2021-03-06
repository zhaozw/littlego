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
#import "CommandBase.h"


// -----------------------------------------------------------------------------
/// @brief The SaveGameCommand class is responsible for saving the current
/// game to the archive.
///
/// SaveGameCommand delegates its task to the GTP engine via the "savesgf" GTP
/// command. If a game with the same name already exists, it is overwritten. If
/// an error occurs, SaveGameCommand displays an alert view.
///
/// SaveGameCommand makes sure that the resulting .sgf file includes all moves
/// of the game. If the user currently views an old board position,
/// SaveGameCommand temporarily re-synchronizes the GTP engine with the full
/// game, then after the archive has been created it synchronizes the GTP
/// engine back to the current board position.
///
/// SaveGameCommand executes synchronously.
// -----------------------------------------------------------------------------
@interface SaveGameCommand : CommandBase
{
}

- (id) initWithSaveGame:(NSString*)aGameName;

/// @brief The name under which the current game should be saved. This is not
/// the file name!
@property(nonatomic, retain) NSString* gameName;

@end
