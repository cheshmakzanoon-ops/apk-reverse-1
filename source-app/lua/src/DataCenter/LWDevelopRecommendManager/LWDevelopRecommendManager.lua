local LWDevelopRecommendManager = BaseClass("LWDevelopRecommendManager")
local LWDevelopRecommendPowerConfigTemplate = require("DataCenter/LWDevelopRecommendManager/LWDevelopRecommendPowerConfigTemplate")
local LWDevelopScoreConfigTemplate = require("DataCenter/LWDevelopRecommendManager/LWDevelopScoreConfigTemplate")
LWDevelopRecommendManager.Class = {
  SSS = 1,
  S = 2,
  A = 3,
  B = 4,
  C = 5
}
LWDevelopRecommendManager.FirstRedKey = "DevelopRecommendFirstRed"
LWDevelopRecommendManager.DurationRedKey = "DevelopRecommendDurationRed"

function LWDevelopRecommendManager:__init()
end

function LWDevelopRecommendManager:GetRecommendPowerConfigTemplate()
  self:TryInitConfigTemplate()
  local mainLv = DataCenter.BuildManager.MainLv
  local openDay = UITimeManager:GetInstance():GetOpenServerDay()
  if self.recPowerConfigTemplateDict ~= nil then
    for i, v in pairs(self.recPowerConfigTemplateDict) do
      if v:IsHqLevelValid(mainLv) and v:IsServerOpenDayValid(openDay) then
        return v
      end
    end
  end
end

function LWDevelopRecommendManager:GetRecommendPowerValue(sourceType)
  local template = self:GetRecommendPowerConfigTemplate()
  if template ~= nil then
    return template:GetRecommendPowerValue(sourceType)
  end
  return -1
end

function LWDevelopRecommendManager:GetClassByPowerSourceType(sourceType)
  local recommendPower = self:GetRecommendPowerValue(sourceType)
  local myPower = DataCenter.PlayerPowerDataManager:GetValByPowerSourceType(sourceType)
  if myPower >= recommendPower * 1.0 then
    return LWDevelopRecommendManager.Class.SSS
  elseif myPower >= recommendPower * 0.95 then
    return LWDevelopRecommendManager.Class.S
  elseif myPower >= recommendPower * 0.75 then
    return LWDevelopRecommendManager.Class.A
  elseif myPower >= recommendPower * 0.6 then
    return LWDevelopRecommendManager.Class.B
  else
    return LWDevelopRecommendManager.Class.C
  end
end

function LWDevelopRecommendManager:TryInitConfigTemplate()
  if table.IsNullOrEmpty(self.recPowerConfigTemplateDict) then
    self.recPowerConfigTemplateDict = {}
    LocalController:instance():visitTable(TableName.RecommendDevelopPower, function(id, lineData)
      local item = LWDevelopRecommendPowerConfigTemplate.New()
      item:InitData(lineData)
      table.insert(self.recPowerConfigTemplateDict, item)
    end)
  end
  if table.IsNullOrEmpty(self.devScoreConfigTemplateDict) then
    self.devScoreConfigTemplateDict = {}
    LocalController:instance():visitTable(TableName.DevelopScore, function(id, lineData)
      local item = LWDevelopScoreConfigTemplate.New()
      item:InitData(lineData)
      table.insert(self.devScoreConfigTemplateDict, item)
    end)
  end
end

function LWDevelopRecommendManager:GetScoreByPowerSourceType(sourceType)
  local recommendPower = self:GetRecommendPowerValue(sourceType)
  local myPower = DataCenter.PlayerPowerDataManager:GetValByPowerSourceType(sourceType)
  if 0 < recommendPower then
    return myPower / recommendPower
  end
  return 0
end

function LWDevelopRecommendManager:GetMySourceTypeListOrderByClass()
  local res = {}
  for i, v in pairs(PowerOverviewPowerSourceType) do
    table.insert(res, v)
  end
  table.sort(res, function(a, b)
    local classA = self:GetClassByPowerSourceType(a)
    local classB = self:GetClassByPowerSourceType(b)
    if classA ~= classB then
      return classA > classB
    end
    local scoreA = self:GetScoreByPowerSourceType(a)
    local scoreB = self:GetScoreByPowerSourceType(b)
    return scoreA < scoreB
  end)
  return res
end

function LWDevelopRecommendManager:GetScoreConfigTemplateDataBySourceType(sourceType)
  self:TryInitConfigTemplate()
  if self.devScoreConfigTemplateDict == nil then
    return
  end
  for i, v in pairs(self.devScoreConfigTemplateDict) do
    if v:GetSourceType() == sourceType then
      return v
    end
  end
end

function LWDevelopRecommendManager:GetClassIconPath(class)
  if class == self.Class.SSS then
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_dongjifengbao_sss.png"
  elseif class == self.Class.S then
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_dongjifengbao_s.png"
  elseif class == self.Class.A then
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_dongjifengbao_a.png"
  elseif class == self.Class.B then
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_dongjifengbao_b.png"
  else
    return "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_dongjifengbao_c.png"
  end
end

function LWDevelopRecommendManager:UpdatePowerRate(message)
  local uid = message.uid or 0
  if uid ~= LuaEntry.Player:GetUid() then
    return
  end
  self.playerPowerRate = message.powerRate or 0
  self.armyPowerRate = message.armyPowerRate or 0
  self.sciencePowerRate = message.sciencePowerRate or 0
  local powerDetail = message.powerDetail or {}
  self.heroLevelPowerRate = powerDetail.heroLevelPowerRate or 0
  self.heroRankPowerRate = powerDetail.heroRankPowerRate or 0
  self.heroSkillPowerRate = powerDetail.heroSkillPowerRate or 0
  self.heroEquipPowerRate = powerDetail.heroEquipPowerRate or 0
  self.heroHonorPowerRate = powerDetail.heroHonorPowerRate or 0
  self.heroWeaponPowerRate = powerDetail.heroWeaponPowerRate or 0
  self.heroDecoPowerRate = powerDetail.heroDecoPowerRate or 0
  self.weaponChipPowerRate = powerDetail.weaponChipPowerRate or 0
  self.weaponEquipPowerRate = powerDetail.weaponEquipPowerRate or 0
  self.weaponLevelPowerRate = powerDetail.weaponLevelPowerRate or 0
  self.buildingDecoPowerRate = powerDetail.buildingDecoPowerRate or 0
  self.buildingWorkerPowerRate = powerDetail.buildingWorkerPowerRate or 0
end

function LWDevelopRecommendManager:GetPowerRate(sourceType)
  if sourceType == PowerOverviewPowerSourceType.heroLevelPower then
    return self.heroLevelPowerRate or 0
  elseif sourceType == PowerOverviewPowerSourceType.heroRankPower then
    return self.heroRankPowerRate or 0
  elseif sourceType == PowerOverviewPowerSourceType.heroSkillPower then
    return self.heroSkillPowerRate or 0
  elseif sourceType == PowerOverviewPowerSourceType.heroEquipPower then
    return self.heroEquipPowerRate or 0
  elseif sourceType == PowerOverviewPowerSourceType.heroHonorPower then
    return self.heroHonorPowerRate or 0
  elseif sourceType == PowerOverviewPowerSourceType.heroWeaponPower then
    return self.heroWeaponPowerRate or 0
  elseif sourceType == PowerOverviewPowerSourceType.heroDecoPower then
    return self.heroDecoPowerRate or 0
  elseif sourceType == PowerOverviewPowerSourceType.weaponChipPower then
    return self.weaponChipPowerRate or 0
  elseif sourceType == PowerOverviewPowerSourceType.weaponEquipPower then
    return self.weaponEquipPowerRate or 0
  elseif sourceType == PowerOverviewPowerSourceType.weaponLevelPower then
    return self.weaponLevelPowerRate or 0
  elseif sourceType == PowerOverviewPowerSourceType.buildingDecoPower then
    return self.buildingDecoPowerRate or 0
  elseif sourceType == PowerOverviewPowerSourceType.buildingWorkerPower then
    return self.buildingWorkerPowerRate or 0
  elseif sourceType == PowerOverviewPowerSourceType.sciencePower then
    return self.sciencePowerRate or 0
  elseif sourceType == PowerOverviewPowerSourceType.armyPower then
    return self.armyPowerRate or 0
  elseif sourceType == PowerOverviewPowerSourceType.playerPower then
    return self.playerPowerRate or 0
  end
  return -1
end

function LWDevelopRecommendManager:GetUIMainRedConfigData()
  local res = {}
  local str = LuaEntry.DataConfig:TryGetStr("power_detail", "k1")
  if not string.IsNullOrEmpty(str) then
    local strList = string.split(str, "|")
    if not table.IsNullOrEmpty(strList) then
      for _, v in pairs(strList) do
        local singleStrList = string.split(v, ":")
        if not table.IsNullOrEmpty(singleStrList) and #singleStrList == 2 then
          local levelStr = singleStrList[1]
          local timeStr = singleStrList[2]
          local levelStrList = string.split(levelStr, ",")
          if not table.IsNullOrEmpty(levelStrList) and #levelStrList == 2 then
            local minLevel = checknumber(levelStrList[1])
            local maxLevel = checknumber(levelStrList[2])
            table.insert(res, {
              minLevel = minLevel,
              maxLevel = maxLevel,
              time = checknumber(timeStr)
            })
          end
        end
      end
    end
  end
  return res
end

function LWDevelopRecommendManager:GetEntranceShowLevel()
  if self.entranceShowLevel == nil then
    local redConfigData = self:GetUIMainRedConfigData()
    self.entranceShowLevel = 0
    if redConfigData[1] ~= nil then
      self.entranceShowLevel = redConfigData[1].minLevel
    end
    for i, v in pairs(redConfigData) do
      if v.minLevel < self.entranceShowLevel then
        self.entranceShowLevel = v.minLevel
      end
    end
  end
  return self.entranceShowLevel
end

function LWDevelopRecommendManager:UpdateEntranceRed()
  local hasShownFirst = CS.GameEntry.Setting:GetBool(self.FirstRedKey .. LuaEntry.Player.uid, false)
  if not hasShownFirst then
    CS.GameEntry.Setting:SetBool(self.FirstRedKey .. LuaEntry.Player.uid, true)
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  CS.GameEntry.Setting:SetInt(self.DurationRedKey .. LuaEntry.Player.uid, curTime)
  EventManager:GetInstance():Broadcast(EventId.DevelopRecommendEntranceRedUpdate)
end

function LWDevelopRecommendManager:IsShowEntranceRed()
  local function GetDuration()
    local res = 0
    
    local configData = self:GetUIMainRedConfigData()
    local level = DataCenter.BuildManager.MainLv
    for i, v in pairs(configData) do
      if level >= v.minLevel and level <= v.maxLevel then
        res = v.time * 60 * 60 * 24
        break
      end
    end
    return res
  end
  
  local minShowLevel = DataCenter.LWDevelopRecommendManager:GetEntranceShowLevel()
  if minShowLevel > DataCenter.BuildManager.MainLv then
    return false
  end
  local hasShownFirst = CS.GameEntry.Setting:GetBool(self.FirstRedKey .. LuaEntry.Player.uid, false)
  if not hasShownFirst then
    return true
  end
  local class = self:GetClassByPowerSourceType(PowerOverviewPowerSourceType.playerPower)
  if class == self.Class.C then
    local lastEnterTime = CS.GameEntry.Setting:GetInt(self.DurationRedKey .. LuaEntry.Player.uid, 0)
    if lastEnterTime <= 0 then
      return true
    end
    local duration = GetDuration()
    if duration <= 0 then
      return false
    end
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local isOvered = duration < curTime - lastEnterTime
    return isOvered
  end
  return false
end

return LWDevelopRecommendManager
