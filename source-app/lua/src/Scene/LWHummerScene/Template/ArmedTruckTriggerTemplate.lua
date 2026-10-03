local ArmedTruckTriggerTemplate = BaseClass("LWHummerSceneConfigTemplate")

function ArmedTruckTriggerTemplate:__init()
  self.id = 0
  self.type = 0
  self.prefabPath = ""
  self.buffId = 0
  self.monsterSpawnPoints = {}
  self.monsterTimeInterval = 0
  self.monsterSpace = 0
  self.battleOverTime = 0
  self.buffIcon = ""
  self.showTime = 0
  self.zombiePool = {}
end

function ArmedTruckTriggerTemplate:__delete()
  self.id = nil
  self.type = nil
  self.prefabPath = nil
  self.buffId = nil
  self.monsterSpawnPoints = nil
  self.monsterTimeInterval = nil
  self.monsterSpace = nil
  self.battleOverTime = nil
  self.buffIcon = nil
  self.showTime = nil
  self.zombiePool = nil
end

function ArmedTruckTriggerTemplate:InitData(cfg)
  if cfg == nil then
    return
  end
  self.id = cfg:getValue("id")
  self.type = cfg:getValue("type")
  self.prefabPath = cfg:getValue("prefab_path")
  self.buffId = cfg:getValue("buff_id")
  local monster_spawn_points = cfg:getValue("monster_spawn_points")
  if monster_spawn_points and checktable(monster_spawn_points) and #monster_spawn_points == 2 then
    for i = 1, 2 do
      local cfg = monster_spawn_points[i]
      local split = string.split(cfg, "|")
      table.insert(self.monsterSpawnPoints, {
        tonumber(split[1]),
        tonumber(split[2])
      })
    end
  end
  self.monsterTimeInterval = cfg:getValue("monster_time_interval")
  self.monsterSpace = cfg:getValue("monster_space")
  self.battleOverTime = cfg:getValue("battle_over_time")
  self.buffIcon = cfg:getValue("buff_icon")
  self.showTime = tonumber(cfg:getValue("show_time"))
  self.zombiePool = cfg:getValue("zombie_pool")
end

function ArmedTruckTriggerTemplate:GetRandomZombieId()
  local zombieId = table.randomArrayValue(self.zombiePool)
  return zombieId
end

return ArmedTruckTriggerTemplate
