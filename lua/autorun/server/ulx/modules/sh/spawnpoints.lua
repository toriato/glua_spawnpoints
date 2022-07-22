local CATEGORY_NAME = 'Teleport'

-- TODO: sv_spawnpoint_limit

-------------------------------
-- removespawnpoint
-------------------------------
function ulx.removespawnpoint (calling_ply, target_plys)
  local map = sql.SQLStr(game.GetMap())

  -- start transaction
  sql.Begin()

  for _, target_ply in pairs(target_plys) do
    sql.Query('DELETE FROM spawnpoints WHERE account_id = ' .. target_ply:AccountID() .. ' AND map = "' .. map .. '";')
  end

  -- commit transaction
  sql.Commit()

  local err = sql.LastError()
  if err then
    ULib.tsayError(calling_ply, 'Database error, check server console!', true)
    if SERVER then print(err) end
    return
  end

  ulx.fancyLogAdmin(calling_ply, "#A removed #T spawnpoints", target_plys)
end

local removespawnpoint = ulx.command(CATEGORY_NAME, 'ulx removespawnpoint', ulx.removespawnpoint, {'!removespawnpoint', '!removespawn', '!rmspawn'}, true)
removespawnpoint:addParam{type=ULib.cmds.PlayersArg, default='^', ULib.cmds.optional}
removespawnpoint:defaultAccess(ULib.ACCESS_ALL)
removespawnpoint:help('Remove target\'s spawnpoints.')

-------------------------------
-- setspawnpoint
-------------------------------
function ulx.setspawnpoint (calling_ply, target_plys)
  if not calling_ply:IsInWorld() then
    ULib.tsayError(calling_ply, 'Spawnpoint cannot be outside the world!', true)
    return
  end

  local map = sql.SQLStr(game.GetMap())
  local pos = calling_ply:GetPos()
  local eye = calling_ply:EyeAngles()

  -- start transaction
  sql.Begin()

  for _, target_ply in pairs(target_plys) do
    local account_id = target_ply:AccountID()

    -- delete old spawnpoints
    sql.Query('DELETE FROM spawnpoints WHERE account_id = ' .. account_id .. ' AND map = "' .. map .. '";')

    -- insert new spawnpoint
    sql.Query([[
      INSERT INTO spawnpoints 
        (account_id, map, px, py, pz, ep, ey, er)
        VALUES (
          ]] .. account_id .. [[,
          "]] .. map .. [[",
          ]] .. pos.x .. [[,
          ]] .. pos.y .. [[,
          ]] .. pos.z .. [[,
          ]] .. eye.p .. [[,
          ]] .. eye.y .. [[,
          ]] .. eye.r .. [[
        );
    ]])
  end

  -- commit transaction
  sql.Commit()

  local err = sql.LastError()
  if err then
    ULib.tsayError(calling_ply, 'Database error, check server console!', true)
    if SERVER then print(err) end
    return
  end

  ulx.fancyLogAdmin(calling_ply, "#A set #T spawnpoint", target_plys)
end

local setspawnpoint = ulx.command(CATEGORY_NAME, 'ulx setspawnpoint', ulx.setspawnpoint, {'!setspawnpoint', '!setspawn'}, true)
setspawnpoint:addParam{type=ULib.cmds.PlayersArg, default='^', ULib.cmds.optional}
setspawnpoint:defaultAccess(ULib.ACCESS_ALL)
setspawnpoint:help('Set current position as target\'s spawnpoint.')

-------------------------------
-- addspawnpoint
-------------------------------
function ulx.addspawnpoint (calling_ply, target_plys)
  if not calling_ply:IsInWorld() then
    ULib.tsayError(calling_ply, 'Spawnpoint cannot be outside the world!', true)
    return
  end

  local map = sql.SQLStr(game.GetMap())
  local pos = calling_ply:GetPos()
  local eye = calling_ply:EyeAngles()

  -- start transaction
  sql.Begin()

  for _, target_ply in pairs(target_plys) do
    local account_id = target_ply:AccountID()

    -- insert new spawnpoint
    sql.Query([[
      INSERT INTO spawnpoints 
        (account_id, map, px, py, pz, ep, ey, er)
        VALUES (
          ]] .. account_id .. [[,
          "]] .. map .. [[",
          ]] .. pos.x .. [[,
          ]] .. pos.y .. [[,
          ]] .. pos.z .. [[,
          ]] .. eye.p .. [[,
          ]] .. eye.y .. [[,
          ]] .. eye.r .. [[
        );
    ]])
  end

  -- commit transaction
  sql.Commit()

  local err = sql.LastError()
  if err then
    ULib.tsayError(calling_ply, 'Database error, check server console!', true)
    if SERVER then print(err) end
    return
  end

  ulx.fancyLogAdmin(calling_ply, "#A add #T spawnpoint", target_plys)
end

local addspawnpoint = ulx.command(CATEGORY_NAME, 'ulx addspawnpoint', ulx.addspawnpoint, {'!addspawnpoint', '!addspawn'}, true)
addspawnpoint:addParam{type=ULib.cmds.PlayersArg, default='^', ULib.cmds.optional}
addspawnpoint:defaultAccess(ULib.ACCESS_ALL)
addspawnpoint:help('Add current position to target\'s spawnpoints.')

-------------------------------
-- removeglobalspawnpoint
-------------------------------
function ulx.removeglobalspawnpoint (calling_ply, target_plys)
  sql.Query('DELETE FROM spawnpoints WHERE account_id IS NULL AND map = "' .. sql.SQLStr(game.GetMap()) .. '";')

  local err = sql.LastError()
  if err then
    ULib.tsayError(calling_ply, 'Database error, check server console!', true)
    if SERVER then print(err) end
    return
  end

  ulx.fancyLogAdmin(calling_ply, "#A removed global spawnpoints", target_plys)
end

local removeglobalspawnpoint = ulx.command(CATEGORY_NAME, 'ulx removeglobalspawnpoint', ulx.removeglobalspawnpoint, {'!removeglobalspawnpoint', '!removegs', '!rmgs'}, true)
removeglobalspawnpoint:defaultAccess(ULib.ACCESS_ADMIN)
removeglobalspawnpoint:help('Remove global spawnpoints.')

-------------------------------
-- setglobalspawnpoint
-------------------------------
function ulx.setglobalspawnpoint (calling_ply)
  if not calling_ply:IsInWorld() then
    ULib.tsayError(calling_ply, 'Spawnpoint cannot be outside the world!', true)
    return
  end

  local map = sql.SQLStr(game.GetMap())
  local pos = calling_ply:GetPos()
  local eye = calling_ply:EyeAngles()

  -- start transaction
  sql.Begin()

  -- delete old spawnpoints
  sql.Query('DELETE FROM spawnpoints WHERE account_id IS NULL AND map = "' .. map .. '";')

  -- insert new spawnpoint
  sql.Query([[
    INSERT INTO spawnpoints 
      (account_id, map, px, py, pz, ep, ey, er)
      VALUES (
        NULL,
        "]] .. map .. [[",
        ]] .. pos.x .. [[,
        ]] .. pos.y .. [[,
        ]] .. pos.z .. [[,
        ]] .. eye.p .. [[,
        ]] .. eye.y .. [[,
        ]] .. eye.r .. [[
      );
  ]])

  -- commit transaction
  sql.Commit()

  local err = sql.LastError()
  if err then
    ULib.tsayError(calling_ply, 'Database error, check server console!', true)
    if SERVER then print(err) end
    return
  end

  ulx.fancyLogAdmin(calling_ply, "#A set global spawnpoint")
end

local setglobalspawnpoint = ulx.command(CATEGORY_NAME, 'ulx setglobalspawnpoint', ulx.setglobalspawnpoint, {'!setglobalspawnpoint', '!setglobalspawn', '!setgs'}, true)
setglobalspawnpoint:defaultAccess(ULib.ACCESS_ADMIN)
setglobalspawnpoint:help('Set current position as global spawnpoint.')

-------------------------------
-- addglobalspawnpoint
-------------------------------
function ulx.addglobalspawnpoint (calling_ply)
  if not calling_ply:IsInWorld() then
    ULib.tsayError(calling_ply, 'Spawnpoint cannot be outside the world!', true)
    return
  end

  local map = sql.SQLStr(game.GetMap())
  local pos = calling_ply:GetPos()
  local eye = calling_ply:EyeAngles()

  -- insert new spawnpoint
  sql.Query([[
    INSERT INTO spawnpoints 
      (account_id, map, px, py, pz, ep, ey, er)
      VALUES (
        NULL,
        "]] .. map .. [[",
        ]] .. pos.x .. [[,
        ]] .. pos.y .. [[,
        ]] .. pos.z .. [[,
        ]] .. eye.p .. [[,
        ]] .. eye.y .. [[,
        ]] .. eye.r .. [[
      );
  ]])

  local err = sql.LastError()
  if err then
    ULib.tsayError(calling_ply, 'Database error, check server console!', true)
    if SERVER then print(err) end
    return
  end

  ulx.fancyLogAdmin(calling_ply, "#A add global spawnpoint")
end

local addglobalspawnpoint = ulx.command(CATEGORY_NAME, 'ulx addglobalspawnpoint', ulx.addglobalspawnpoint, {'!addglobalspawnpoint', '!addglobalspawn', '!addgs'}, true)
addglobalspawnpoint:defaultAccess(ULib.ACCESS_ADMIN)
addglobalspawnpoint:help('Add current position to global spawnpoints.')
