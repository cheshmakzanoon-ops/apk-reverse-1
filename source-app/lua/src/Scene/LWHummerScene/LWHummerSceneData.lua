local LWHummerSceneData = BaseClass("LWHummerSceneData")
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")
local ArmedTruckConfigTemplate = require("Scene.LWHummerScene.Template.ArmedTruckConfigTemplate")
local ArmedTruckTriggerTemplate = require("Scene.LWHummerScene.Template.ArmedTruckTriggerTemplate")
local ArmedTruckBuffTemplate = require("Scene.LWHummerScene.Template.ArmedTruckBuffTemplate")
local ArmedTruckBulletTemplate = require("Scene.LWHummerScene.Template.ArmedTruckBulletTemplate")
local Random = math.random
LWHummerSceneData.ZombiePoolType = {
  Normal = 1,
  Special = 2,
  Drop = 3
}

function LWHummerSceneData:__init()
  local stageId = LuaEntry.DataConfig:TryGetNum("stage_idle_reward", "k4")
  self.rawStageConfigLine = LocalController:instance():getLine(TableName.Armed_truck_config, tonumber(stageId))
  self.stage = ArmedTruckConfigTemplate.New()
  self.stage:InitData(self.rawStageConfigLine)
  self.scenePreZ = 0
  self.sceneIndex = 0
  self.triggers = {}
  self.buffs = {}
  self.bullets = {}
  self.helpHero = {}
end

function LWHummerSceneData:__delete()
  self:OnDestroy()
end

function LWHummerSceneData:OnDestroy()
  self.rawStageConfigLine = nil
  self.stage = nil
  self.scenePreZ = nil
  self.sceneIndex = nil
  self.triggers = nil
  self.buffs = nil
  self.bullets = nil
end

function LWHummerSceneData:GetCameraPath()
  return self.stage.cameraPath
end

function LWHummerSceneData:GetSceneConfigs(startIndex, count)
  local res = {}
  for i = startIndex, startIndex + count - 1 do
    local sceneConfig = self:GetSceneConfigAtIndex(i)
    if sceneConfig ~= nil then
      table.insert(res, sceneConfig)
    end
  end
  return res
end

function LWHummerSceneData:GetSceneConfigAtIndex(index)
  if self.stage ~= nil and self.stage.scenePool ~= nil then
    local scene = table.randomArrayValue(self.stage.scenePool)
    local data = {
      asset = scene.asset,
      index = self.sceneIndex,
      offset = self.scenePreZ,
      sizeZ = scene.sizeZ
    }
    self.sceneIndex = self.sceneIndex + 1
    self.scenePreZ = self.scenePreZ + scene.sizeZ
    return data
  end
end

function LWHummerSceneData:GetInitVerticalSpeed()
  return self.stage.playerVSpeed
end

function LWHummerSceneData:GetMainPlayerResPath()
  return self.stage.playerPath
end

function LWHummerSceneData:GetPlayerBirthPos()
  return self.stage.birthPoint
end

function LWHummerSceneData:GetZombieSpeed()
  return self.stage.zoombieSpeed
end

function LWHummerSceneData:GetRandomZombieSpawnData(type)
  local delta = 5
  local num = 1
  local randomSec = Random(0, 1)
  local pool = self.stage.zombieRandomTimes[type]
  delta = Random(pool[1], pool[2] - 1) + randomSec
  num = pool[3]
  return delta, num
end

function LWHummerSceneData:GetRandomZombieSpawnPos(z)
  local x = Random(self.stage.zombieRandomPoints[1][1], self.stage.zombieRandomPoints[2][1]) + self:GetSceneCenterX()
  local z = Random(self.stage.zombieRandomPoints[1][2], self.stage.zombieRandomPoints[2][2]) + z
  return Vector3.New(x, 0, z)
end

function LWHummerSceneData:GetRandomJumpZombieSpawnPos(playerZ, targetX, index)
  targetX = math.floor(targetX)
  local x = 0
  local z = Random(self.stage.zombieRandomPoints[1][2], self.stage.zombieRandomPoints[2][2]) + playerZ
  if index <= 3 then
    x = Random(self.stage.zombieRandomPoints[1][1] + self:GetSceneCenterX(), targetX)
  else
    x = Random(targetX, self.stage.zombieRandomPoints[2][1] + self:GetSceneCenterX())
  end
  return Vector3.New(x, 0, z)
end

function LWHummerSceneData:GetRandomZombieCfg(type)
  local pool = self.stage.zombiePool[type]
  local zomieId = table.randomArrayValue(pool)
  local meta = DataCenter.PveMonsterTemplateManager:GetTemplate(zomieId)
  return meta
end

function LWHummerSceneData:GetRandomZombieId(type)
  local pool = self.stage.zombiePool[type]
  local zombieId = table.randomArrayValue(pool)
  return zombieId
end

function LWHummerSceneData:GetZombieFlyData()
  return self.stage.zombieFlyTime, self.stage.zombieFlyDistance
end

function LWHummerSceneData:GetSceneCenterX()
  return self.stage.sceneCenterX
end

function LWHummerSceneData:GetTriggerTemplate(id)
  local template = self.triggers[id]
  if template == nil then
    local cfg = LocalController:instance():getLine(TableName.Armed_truck_trigger, tonumber(id))
    template = ArmedTruckTriggerTemplate.New()
    template:InitData(cfg)
    self.triggers[id] = template
  end
  return template
end

function LWHummerSceneData:GetBuffTemplate(id)
  local template = self.buffs[id]
  if template == nil then
    local cfg = LocalController:instance():getLine(TableName.Armed_truck_buff, tonumber(id))
    template = ArmedTruckBuffTemplate.New()
    template:InitData(cfg)
    self.buffs[id] = template
  end
  return template
end

function LWHummerSceneData:GetBulletTemplate(id)
  local template = self.bullets[id]
  if template == nil then
    local cfg = LocalController:instance():getLine(TableName.Armed_truck_bullet, tonumber(id))
    template = ArmedTruckBulletTemplate.New()
    template:InitData(cfg)
    self.bullets[id] = template
  end
  return template
end

function LWHummerSceneData:GetRandomTriggerSpawnDelta()
  local randomSec = Random(0, 1)
  local delta = Random(self.stage.triggerRandomTime[1], self.stage.triggerRandomTime[2] - 1) + randomSec
  return delta
end

function LWHummerSceneData:GetRandomTrggerSpawnPos(z)
  local x = Random(self.stage.triggerRandomPoints[1][1], self.stage.triggerRandomPoints[2][1]) + self:GetSceneCenterX()
  local z = Random(self.stage.triggerRandomPoints[1][2], self.stage.triggerRandomPoints[2][2]) + z
  return Vector3.New(x, 0, z)
end

function LWHummerSceneData:GetRandomTriggerId()
  local triggerId = table.randomArrayValue(self.stage.triggerPool)
  return triggerId
end

function LWHummerSceneData:GetUnlockHelpHeroList()
  local helpHeroList = {}
  local lv = DataCenter.LWTowerUpStageManager:GetCurStageId()
  local idList = {}
  local allList = DataCenter.ArmyFormationDataManager:GetFormationByType(EnterHeroSquadPanelWay.TowerupJeepAdventure, 1)
  local ownHeroList = {}
  if allList ~= nil and allList.localIndexToHeroDic then
    for k, v in pairs(allList.localIndexToHeroDic) do
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
      if heroData then
        ownHeroList[k] = heroData.heroId
      end
    end
  end
  for i, v in ipairs(self.stage.helpHero) do
    if lv >= v[1] then
      if ownHeroList[i] then
        table.insert(idList, ownHeroList[i])
      else
        table.insert(idList, v[2])
      end
    else
      break
    end
  end
  for i, v in ipairs(idList) do
    local hero = self.helpHero[v]
    if hero == nil then
      local cfg = LocalController:instance():tryGetLine(TableName.Armed_truck_hero, tonumber(v))
      hero = HeroInfo.New()
      hero:UpdateFromTemplate(tonumber(v), nil, nil, nil, nil)
      hero.skillDict = {}
      hero.skillList = {}
      local skillInfo = SkillInfo.New()
      local skillInfoParam = {}
      if cfg then
        skillInfoParam.skillId = tonumber(cfg:getValue("hero_skill_id"))
      else
        local template = DataCenter.HeroTemplateManager:GetTemplate(tonumber(v))
        if template then
          skillInfoParam.skillId = tonumber(template.skills[1])
        end
      end
      skillInfoParam.level = 40
      skillInfoParam.state = 1
      skillInfo:UpdateSkillInfo(skillInfoParam)
      local heroSkillTemplate = DeepCopy(skillInfo.skillTemplateData)
      heroSkillTemplate.pre_cd = DataCenter.HeroParamDataManager.skillPreviewStartDelay
      heroSkillTemplate.attack_interval = 1
      skillInfo.skillTemplateData = heroSkillTemplate
      hero.skillDict[skillInfo.skillId] = skillInfo
      hero.skillList[1] = skillInfo
      self.helpHero[v] = hero
    end
    table.insert(helpHeroList, hero)
  end
  return helpHeroList
end

function LWHummerSceneData:GetRandomDropPath()
  return table.randomArrayValue(Constant.TRUCK_GOODS_ICON_PREFABS)
end

function LWHummerSceneData:GetRewardZombieNum()
  return self.stage.rewardZombieNum
end

function LWHummerSceneData:GetZombieDropTime()
  return self.stage.zombieDropTime
end

function LWHummerSceneData:GetCurDominatorId()
  local appearanceId = DataCenter.DominatorManager:GetCityBuildingShowAppearanceId()
  if self.stage.dominatorBullet[appearanceId] == nil then
    for k, v in pairs(self.stage.dominatorBullet) do
      appearanceId = k
      break
    end
  end
  return appearanceId
end

function LWHummerSceneData:GetCurDominatorPath()
  local path
  local appearanceId = self:GetCurDominatorId()
  if appearanceId then
    path = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), appearanceId, "model_path")
  end
  return path
end

function LWHummerSceneData:GetDominatorBulletId(id)
  return self.stage.dominatorBullet[id]
end

function LWHummerSceneData:GetDominatorSpawnOffset()
  return self.stage.dominatorSpawnZ
end

function LWHummerSceneData:GetDominatorSpawnSpeed()
  return self.stage.dominatorSpawnSpeed
end

function LWHummerSceneData:GetDominatorOffset()
  return self.stage.dominatorRunZ
end

function LWHummerSceneData:GetDominatorAtkCD()
  return self.stage.dominatorAttackCd
end

function LWHummerSceneData:GetBattleMemberScale()
  return self.stage.battleMemberScale
end

function LWHummerSceneData:GetJumpZombieBuffId()
  return self.stage.jumpZombieBuffId
end

return LWHummerSceneData
