-- create database table
sql.Query([[
  CREATE TABLE IF NOT EXISTS spawnpoints (
    account_id  NUMBER, 
    map         TEXT NOT NULL,
    px          REAL NOT NULL,
    py          REAL NOT NULL,
    pz          REAL NOT NULL,
    ep          REAL NOT NULL,
    ey          REAL NOT NULL,
    er          REAL NOT NULL
  )
]])

-- remove old hooks
hook.Remove('FinishMove', 'spawnpoints.FinishMove')
hook.Remove('PlayerSelectSpawn', 'spawnpoints.PlayerSelectSpawn')

if table.HasValue({'sandbox'}, engine.ActiveGamemode()) then
  local methods = {
    -- addon: Minigame Helpers (Brick Point)
    -- https://steamcommunity.com/sharedfiles/filedetails/?id=121079243
    function (ply)
      if IsValid(ply.SuperCoolBrickSpawn) then
        local pos = ply.SuperCoolBrickSpawn:GetPos() + Vector(0, 0, 15)
        return {
          px=pos.x, py=pos.y, pz=pos.z,
          ep=0, ey=0, er=0
        }
      end
    end,
  
    -- random spawnpoint from database
    function (ply)
      return sql.QueryRow([[
        SELECT px, py, pz, ep, ey, er
          FROM spawnpoints 
          WHERE
            account_id = ]] .. ply:AccountID() .. [[ AND
            map = "]] .. sql.SQLStr(game.GetMap()) .. [["
          ORDER BY RANDOM() 
          LIMIT 1
      ]])
    end,
  
    -- random global spawnpoint from database
    function (ply)
      return sql.QueryRow([[
        SELECT px, py, pz, ep, ey, er
          FROM spawnpoints 
          WHERE
            account_id IS NULL AND
            map = "]] .. sql.SQLStr(game.GetMap()) .. [["
          ORDER BY RANDOM() 
          LIMIT 1
      ]])
    end,
  
    -- info_player_start
    function ()
      local entities = ents.FindByClass('info_player_start')
      local ent = entities[math.random(#entities)]
      
      if IsValid(ent) then
        local pos = ent:GetPos()
        local eye = ent:EyeAngles()
        return {
          px=pos.x, py=pos.y, pz=pos.z,
          ep=eye.p, ey=eye.y, er=eye.r
        }
      end
    end
  }  

  -- super hacky hack
  -- https://github.com/Facepunch/garrysmod-issues/issues/2447#issuecomment-254019830
  local teleport_queues = {}

  hook.Add('FinishMove', 'SpawnPoint.FinishMove', function (ply)
    local q = teleport_queues[ply]
    if q ~= nil then
      ply:SetPos(Vector(q.px, q.py, q.pz))
      ply:SetEyeAngles(Angle(q.ep, q.ey, q.er))
      teleport_queues[ply] = nil
      return true
    end
  end)

  hook.Add('PlayerSelectSpawn', 'SpawnPoint.PlayerSelectSpawn', function (ply)
    for idx, method in pairs(methods) do
      teleport_queues[ply] = method(ply)
      if teleport_queues[ply] ~= nil then
        break
      end
    end
  end)
end