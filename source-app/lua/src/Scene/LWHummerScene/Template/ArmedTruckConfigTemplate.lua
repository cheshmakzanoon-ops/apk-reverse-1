local ArmedTruckConfigTemplate = BaseClass("LWHummerSceneConfigTemplate")

function ArmedTruckConfigTemplate:__init()
  self.id = 0
  self.scenePool = {}
  self.sceneCenterX = 0
  self.birthPoint = Vector3(0, 0, 0)
  self.limitWidth = 0
  self.playerVSpeed = 0
  self.playerHSpeed = 0
  self.cameraPath = ""
  self.playerPath = ""
  self.zombieRandomTimes = {}
  self.zombieRandomPoints = {}
  self.zoombieSpeed = 0
  self.zombiePool = {}
  self.zombieFlyTime = 0
  self.zombieFlyDistance = 0
  self.triggerRandomTime = {}
  self.triggerRandomPoints = {}
  self.triggerPool = {}
  self.fingerDownBuff = 0
  self.helpHero = {}
  self.airPrefabPath = ""
  self.airBulletId = 0
  self.rewardZombieNum = 0
  self.zombieDropTime = 0
  self.dominatorBullet = {}
  self.dominatorAttackCd = 0
  self.dominatorSpawnZ = 0
  self.dominatorSpawnSpeed = 0
  self.dominatorRunZ = 0
  self.cameraOffset = Vector3.New(0, 0, 0)
  self.cameraSpeedOffset = Vector3.New(0, 0, 0)
  self.battleMemberScale = 0
  self.widthDrift = 0
  self.jumpZombieBuffId = 0
end

function ArmedTruckConfigTemplate:__delete()
  self.id = nil
  self.scenePool = nil
  self.sceneCenterX = nil
  self.birthPoint = nil
  self.limitWidth = nil
  self.playerVSpeed = nil
  self.playerHSpeed = nil
  self.cameraPath = nil
  self.playerPath = nil
  self.zombieRandomTimes = nil
  self.zombieRandomPoints = nil
  self.zoombieSpeed = nil
  self.zombiePool = nil
  self.zombieFlyTime = nil
  self.zombieFlyDistance = nil
  self.triggerRandomTime = nil
  self.triggerRandomPoints = nil
  self.triggerPool = nil
  self.fingerDownBuff = nil
  self.helpHero = nil
  self.airPrefabPath = nil
  self.airBulletId = nil
  self.rewardZombieNum = nil
  self.zombieDropTime = nil
  self.dominatorBullet = nil
  self.dominatorAttackCd = nil
  self.dominatorSpawnZ = nil
  self.dominatorSpawnSpeed = nil
  self.dominatorRunZ = nil
  self.cameraOffset = nil
  self.cameraSpeedOffset = nil
  self.battleMemberScale = nil
  self.widthDrift = nil
  self.jumpZombieBuffId = nil
end

function ArmedTruckConfigTemplate:InitData(cfg)
  if cfg == nil then
    return
  end
  self.id = cfg:getValue("id")
  local scene_pool = cfg:getValue("scene_pool")
  for i, v in ipairs(scene_pool) do
    local sceneMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Scene), v)
    if sceneMeta ~= nil then
      local sizeZ = sceneMeta:getValue("scene_size") or 66
      local data = {
        asset = sceneMeta:getValue("asset") or "",
        sizeZ = sizeZ
      }
      table.insert(self.scenePool, data)
    end
  end
  self.sceneCenterX = cfg:getValue("scene_center_x")
  local birth_point = cfg:getValue("birth_point")
  self.birthPoint.x = birth_point[1]
  self.birthPoint.z = birth_point[2]
  self.limitWidth = cfg:getValue("limit_width")
  self.playerVSpeed = cfg:getValue("player_vertical_speed")
  self.playerHSpeed = cfg:getValue("player_horizontal_speed")
  self.cameraPath = cfg:getValue("camera_path")
  self.playerPath = cfg:getValue("player_path")
  local zombie_random_times = cfg:getValue("zombie_random_times")
  for _, cfg in ipairs(zombie_random_times) do
    local split = string.split(cfg, "|")
    local data = {}
    for _, v in ipairs(split) do
      table.insert(data, tonumber(v))
    end
    table.insert(self.zombieRandomTimes, data)
  end
  local zombie_random_points = cfg:getValue("zombie_random_points")
  for i = 1, 2 do
    local cfg = zombie_random_points[i]
    local split = string.split(cfg, "|")
    table.insert(self.zombieRandomPoints, {
      tonumber(split[1]),
      tonumber(split[2])
    })
  end
  self.zoombieSpeed = cfg:getValue("zombie_speed")
  local zombie_pool = cfg:getValue("zombie_pool")
  for _, cfg in ipairs(zombie_pool) do
    local split = string.split(cfg, "|")
    local pool = {}
    for _, zombieId in ipairs(split) do
      table.insert(pool, tonumber(zombieId))
    end
    table.insert(self.zombiePool, pool)
  end
  local zombie_fly_data = cfg:getValue("zombie_fly_data")
  self.zombieFlyTime = zombie_fly_data[1]
  self.zombieFlyDistance = zombie_fly_data[2]
  self.triggerRandomTime = cfg:getValue("trigger_random_time")
  local trigger_random_points = cfg:getValue("trigger_random_points")
  for i = 1, 2 do
    local cfg = trigger_random_points[i]
    local split = string.split(cfg, "|")
    table.insert(self.triggerRandomPoints, {
      tonumber(split[1]),
      tonumber(split[2])
    })
  end
  self.triggerPool = cfg:getValue("trigger_pool")
  self.fingerDownBuff = cfg:getValue("finger_down_buff")
  local help_hero = cfg:getValue("help_hero")
  for i, cfg in ipairs(help_hero) do
    local split = string.split(cfg, "|")
    local data = {}
    for i, v in ipairs(split) do
      table.insert(data, tonumber(v))
    end
    table.insert(self.helpHero, data)
  end
  self.airPrefabPath = cfg:getValue("air_prefab_path")
  self.airBulletId = cfg:getValue("air_bullet_id")
  self.rewardZombieNum = cfg:getValue("reward_zombie_num")
  self.zombieDropTime = cfg:getValue("zombie_drop_time")
  local dominator_bullet = cfg:getValue("dominator_bullet")
  for i, cfg in ipairs(dominator_bullet) do
    local split = string.split(cfg, "|")
    self.dominatorBullet[tonumber(split[1])] = tonumber(split[2])
  end
  self.dominatorAttackCd = cfg:getValue("dominator_attack_cd")
  self.dominatorSpawnZ = cfg:getValue("dominator_spawn_z")
  self.dominatorSpawnSpeed = cfg:getValue("dominator_spawn_speed")
  self.dominatorRunZ = cfg:getValue("dominator_run_z")
  local camera_offset = cfg:getValue("camera_offset")
  self.cameraOffset.x = camera_offset[1]
  self.cameraOffset.y = camera_offset[2]
  self.cameraOffset.z = camera_offset[3]
  local camera_speed_offset = cfg:getValue("camera_speed_offset")
  self.cameraSpeedOffset.x = camera_speed_offset[1]
  self.cameraSpeedOffset.y = camera_speed_offset[2]
  self.cameraSpeedOffset.z = camera_speed_offset[3]
  self.battleMemberScale = cfg:getValue("battle_member_scale") or 1.2
  self.widthDrift = cfg:getValue("width_drift") or 0
  self.jumpZombieBuffId = cfg:getValue("jumpZombie_buffId") or 3
end

return ArmedTruckConfigTemplate
