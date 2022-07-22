# glua_spawnpoints
Set multiple spawnpoints that can be specified by player and map.

## Features
- Multiple spawnpoints per map and players
- Multiple global spawnpoints per map
- ULX commands

## Commands (ULX)

### Teleport

#### `ulx/modules/sh/spawnpoints.lua`
- `ulx removespawnpoint [PlayersArg=self]` - Remove target's spawnpoints
- `ulx setspawnpoint [PlayersArg=self]` - Set current position as target's spawnpoint
- `ulx addspawnpoint [PlayersArg=self]` - Add current position to target's spawnpoints
- `ulx removeglobalspawnpoint` - Remove global spawnpoints
- `ulx setglobalspawnpoint` - Set current position as global spawnpoint
- `ulx addglobalspawnpoint` - Add current position to global spawnpoints

## FAQs

## Spawnpoint orders
1. [Brick Point (from Minigame Helpers)](https://steamcommunity.com/sharedfiles/filedetails/?id=121079243)
1. Player spawnpoints
1. Global spawnpoints
1. `info_player_start`

### License?
Don't care, public domain.

### Workshop?
I'm too lazy to do that.

### Is it okay if I upload it myself?
Yeah, I don't mind.
