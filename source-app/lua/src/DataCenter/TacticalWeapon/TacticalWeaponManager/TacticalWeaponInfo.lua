local TacticalWeaponInfo = BaseClass("TacticalWeaponInfo")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local Localization = CS.GameEntry.Localization

function TacticalWeaponInfo:__init()
  self.id = 0
  self.level = 0
  self.maxLevel = 0
  self.skillInfos = {}
  self.propertyData = nil
  self.power = 0
  self.equips = {}
  self.upgradeProgress = 0
  self.template = nil
  self.levelTemplate = nil
  self.progress = 0
end

function TacticalWeaponInfo:__delete()
  self.id = nil
  self.level = nil
  self.maxLevel = nil
  self.skillInfos = nil
  self.propertyData = nil
  self.power = nil
  self.equips = nil
  self.upgradeProgress = nil
  self.template = nil
  self.levelTemplate = nil
  self.progress = nil
end

function TacticalWeaponInfo:UpdateProperty(properties)
  if table.IsNullOrEmpty(properties) then
    return
  end
  if self.propertyData == nil then
    self.propertyData = HeroPropertyData.New()
  end
  for k, v in pairs(properties) do
    local effectId = tonumber(k)
    local effectValue = tonumber(v)
    self.propertyData:SetProperty(effectId, effectValue)
  end
end

function TacticalWeaponInfo:UpdateSkillInfoExtra()
  if not self.skillInfos then
    return
  end
  local extraStar = DataCenter.TacticalWeaponManager:GetMainWeaponSkillStarExtra()
  for i, skillInfo in ipairs(self.skillInfos) do
    if skillInfo and skillInfo.skillId ~= self.originSkillId + extraStar then
      local newSkillInfo = SkillInfo.New()
      newSkillInfo:CreateFromTemplate(self.originSkillId + extraStar, true, 1)
      self.skillInfos = {}
      table.insert(self.skillInfos, newSkillInfo)
    end
  end
end

function TacticalWeaponInfo:UpdateInfo(message)
  if message == nil then
    return
  end
  if message.id ~= nil then
    self.id = message.id
    self.template = DataCenter.TacticalWeaponTemplateManager:GetTemplate(self.id)
    self.maxLevel = 0
    if self.template ~= nil then
      self.maxLevel = self.template.maxLevel
    end
  end
  if message.lv ~= nil then
    self.level = message.lv
    if self.template then
      self.levelTemplate = self:GetLevelTemplate(self.level)
    end
  end
  if message.skill ~= nil and message.skillLevel then
    self.originSkillId = message.skill
    local extraStar = DataCenter.TacticalWeaponManager:GetMainWeaponSkillStarExtra()
    local skillInfo = SkillInfo.New()
    skillInfo:CreateFromTemplate(message.skill + extraStar, true, message.skillLevel)
    self.skillInfos = {}
    table.insert(self.skillInfos, skillInfo)
  end
  if not table.IsNullOrEmpty(message.props) then
    self:UpdateProperty(message.props)
  end
  if message.power ~= nil then
    self.power = message.power
  end
  if message.exp ~= nil then
    self.progress = message.exp
  end
  if message.chipLv ~= nil then
    self.chipLv = message.chipLv
  end
  if message.chipExp ~= nil then
    self.chipExp = message.chipExp
  end
  if message.oldChipGroup ~= nil then
    self.oldChipGroup = message.oldChipGroup
  end
end

function TacticalWeaponInfo:GetUnlockChipGroup()
  return self.oldChipGroup or 1
end

function TacticalWeaponInfo:CalculateLevel(addSkillStar)
  if self.template then
    self.levelTemplate = self:GetLevelTemplate(self.level)
    self.skillInfos = {}
    if self.levelTemplate then
      self.skillInfos = self.levelTemplate:GetSkillInfos(addSkillStar)
    end
  end
end

function TacticalWeaponInfo:CreateFromTemplate(id, level, progress, initProperties, skillInfoList, addSkillStar)
  if id == nil or id < 0 then
    return
  end
  self.id = id
  self.template = DataCenter.TacticalWeaponTemplateManager:GetTemplate(self.id)
  self.maxLevel = 0
  if self.template ~= nil then
    self.maxLevel = self.template.maxLevel
  else
    return false
  end
  self.level = level
  self.power = 0
  self.progress = progress or 0
  self.levelTemplate = self:GetLevelTemplate(self.level)
  if skillInfoList then
    self.skillInfos = skillInfoList
  else
    self:CalculateLevel(addSkillStar)
  end
  local skillInfos = self:GetSkillInfos()
  if not table.IsNullOrEmpty(skillInfos) then
    for _, v in pairs(skillInfos) do
      self.power = self.power + v:GetPower()
    end
  end
  if self.propertyData == nil then
    self.propertyData = HeroPropertyData.New()
  end
  if initProperties then
    self:UpdateProperty(initProperties)
  else
    local properties = self:CollectBaseEffects(self.progress)
    for __, v in pairs(properties) do
      self.propertyData:SetProperty(v.id, v.value)
    end
    local _50098 = self.propertyData:GetProperty(50081) * (1 + self.propertyData:GetProperty(50087))
    self.propertyData:SetProperty(50098, _50098)
    local _50099 = self.propertyData:GetProperty(50082) * (1 + self.propertyData:GetProperty(50088))
    self.propertyData:SetProperty(50099, _50099)
    local _50100 = self.propertyData:GetProperty(50083) * (1 + self.propertyData:GetProperty(50089))
    self.propertyData:SetProperty(50100, _50100)
    local hp = self.propertyData:GetProperty(50081) * (1 + self.propertyData:GetProperty(50087)) * (self.propertyData:GetProperty(50090) + self.propertyData:GetProperty(50091) / 10000)
    local atk = self.propertyData:GetProperty(50082) * (1 + self.propertyData:GetProperty(50088)) * (self.propertyData:GetProperty(50090) + self.propertyData:GetProperty(50092) / 10000)
    local def = self.propertyData:GetProperty(50083) * (1 + self.propertyData:GetProperty(50089)) * (self.propertyData:GetProperty(50090) + self.propertyData:GetProperty(50093) / 10000)
    self.propertyData:SetProperty(50084, hp)
    self.propertyData:SetProperty(50085, atk)
    self.propertyData:SetProperty(50086, def)
  end
  local powerAttrs = TacticalWeaponUtils.PowerAttrs
  for i = 1, #powerAttrs do
    local ratio = DataCenter.EffectNumberTemplateManager:GetEffectNumberPower(powerAttrs[i])
    local attr = self.propertyData:GetProperty(powerAttrs[i])
    self.power = self.power + attr * ratio
  end
  return true
end

function TacticalWeaponInfo:GetProperty(id)
  if self.propertyData == nil then
    return 0
  end
  return self.propertyData:GetProperty(id)
end

function TacticalWeaponInfo:GetPropetyData()
  return self.propertyData
end

function TacticalWeaponInfo:CollectBaseEffects()
  if not self.levelTemplate then
    return {}
  end
  local subTemp = self:GetSubLevelTemplate()
  if subTemp then
    return subTemp:GetAttrs(self.progress)
  end
  return self.levelTemplate:GetAttrs(self.progress)
end

function TacticalWeaponInfo:GetAppearance()
  if not self.template then
    return nil
  end
  local appearance = self.levelTemplate.appearance
  local appearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(appearance)
  if not appearanceTemplate then
    return nil
  end
  return appearanceTemplate.id
end

function TacticalWeaponInfo:IsReachMaxLevel()
  return self.level >= self:GetRealMaxLevel()
end

function TacticalWeaponInfo:GetRealMaxLevel()
  local baseMaxLevel = self.maxLevel
  local scienceAddLevelMax = DataCenter.TacticalWeaponManager:GetMainWeaponMaxLevelExtra()
  return baseMaxLevel + scienceAddLevelMax
end

function TacticalWeaponInfo:GetBaseMaxLevel()
  return self.maxLevel
end

function TacticalWeaponInfo:GetNeedBuilding()
  if not self.levelTemplate then
    return {}
  end
  local subTemp = self:GetSubLevelTemplate()
  if subTemp then
    return subTemp.need_building
  end
  return self.levelTemplate.need_building
end

function TacticalWeaponInfo:HasResItemToUpgrade()
  local lackResItems = {}
  local costRes = self.levelTemplate.cost_resItem
  local subTemp = self:GetSubLevelTemplate()
  if subTemp then
    costRes = subTemp.cost_resItem
  end
  if not table.IsNullOrEmpty(costRes) then
    for __, v in pairs(costRes) do
      local resItemId = tonumber(v.id)
      local needNum = tonumber(v.value)
      local haveCount = DataCenter.ResourceItemDataManager:GetCountByItemId(resItemId)
      if needNum > haveCount then
        local lackResItem = {}
        lackResItem.id = resItemId
        lackResItem.count = needNum
        table.insert(lackResItems, lackResItem)
      end
    end
  end
  if not table.IsNullOrEmpty(lackResItems) then
    return false, lackResItems
  end
  return true, lackResItems
end

function TacticalWeaponInfo:CanUpgradeBuilding()
  if self:IsReachMaxLevel() then
    return false
  end
  local needBuilding = self:GetNeedBuilding()
  if not table.IsNullOrEmpty(needBuilding) then
    for k, v in pairs(needBuilding) do
      local buildingType = tonumber(k)
      local buildingLevel = tonumber(v)
      local buildingInfo = DataCenter.BuildManager:GetFunbuildByItemID(buildingType)
      if buildingInfo == nil or buildingLevel > buildingInfo.level then
        return false
      end
    end
  end
  if not self:HasResItemToUpgrade() then
    return false
  end
  return true
end

function TacticalWeaponInfo:IsReachLevelLimit()
  if not self.levelTemplate then
    return true
  end
  local buildingLimit = self.levelTemplate.need_building
  local subTemp = self:GetSubLevelTemplate()
  if subTemp then
    buildingLimit = subTemp.need_building
  end
  local needBuildingType = 0
  local needBuildingLevel = 0
  if buildingLimit and 2 <= #buildingLimit then
    needBuildingType = buildingLimit[1]
    needBuildingLevel = buildingLimit[2]
  end
  local reachLevelLimit = true
  if 0 < needBuildingType and 0 < needBuildingLevel then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(needBuildingType)
    if buildData then
      reachLevelLimit = needBuildingLevel > buildData.level
    end
  end
  return reachLevelLimit, needBuildingType, needBuildingLevel
end

function TacticalWeaponInfo:GetLevelTemplate(level)
  return DataCenter.TacticalWeaponLevelTemplateManager:GetTemplateByLevel(level)
end

function TacticalWeaponInfo:GetSkillInfos()
  return self.skillInfos or {}
end

function TacticalWeaponInfo:ShowUpgradeRedPoint()
  if not self.levelTemplate then
    return false
  end
  if self:IsReachMaxLevel() then
    return false
  end
  if self:IsReachLevelLimit() then
    return false
  end
  local costRes = self.levelTemplate.cost_resItem
  local progressTotal = self.levelTemplate.progress_total
  local progressAdd = self.levelTemplate.progress_add
  local subTemp = self:GetSubLevelTemplate()
  if subTemp then
    costRes = subTemp.cost_resItem
    progressTotal = subTemp.progress_total
    progressAdd = subTemp.progress_add
  end
  if not table.IsNullOrEmpty(costRes) then
    for __, v in pairs(costRes) do
      local resItemId = tonumber(v.id)
      local needNum = tonumber(v.value)
      local haveCount = DataCenter.ResourceItemDataManager:GetCountByItemId(resItemId)
      if haveCount < math.min((progressTotal - self.progress) / progressAdd, 3) * needNum then
        return false
      end
    end
  end
  return true
end

function TacticalWeaponInfo:ShowRedPoint()
  if self:ShowUpgradeRedPoint() then
    return true
  end
  return false
end

function TacticalWeaponInfo:GetPower(equips)
  local power = self.power
  return power
end

function TacticalWeaponInfo:GetName()
  if not self.template then
    return ""
  end
  return Localization:GetString(self.template.name)
end

function TacticalWeaponInfo:GetSkillPower()
  local power = 0
  local skillInfos = self:GetSkillInfos()
  if not table.IsNullOrEmpty(skillInfos) then
    for _, v in pairs(skillInfos) do
      power = power + v:GetPower()
    end
  end
  return power
end

function TacticalWeaponInfo:GetNextRealTemplate(level)
  local nextConfig = self:GetLevelTemplate(level + 1)
  local curSubLevel
  local isSubLevel, curLevelSubLevelDic = DataCenter.TacticalWeaponLevelTemplateManager:TryGetSubLevelDic(level)
  if isSubLevel then
    for i, v in pairs(curLevelSubLevelDic) do
      if v.progress_total == self.progress + v.progress_add then
        curSubLevel = v.sub_level
        break
      end
    end
    if curSubLevel ~= nil and curSubLevel < 4 then
      return curLevelSubLevelDic[curSubLevel + 1]
    end
  end
  return nextConfig
end

function TacticalWeaponInfo:GetRealTemplateStatic(level, subLevel)
  local config = self:GetLevelTemplate(level)
  local isSubLevel, curLevelSubLevelDic = DataCenter.TacticalWeaponLevelTemplateManager:TryGetSubLevelDic(level)
  if isSubLevel then
    return curLevelSubLevelDic[subLevel]
  else
    return config
  end
end

function TacticalWeaponInfo:GetSubLevelTemplate()
  local subLevel = -1
  local isSubLevel, curLevelSubLevelDic = DataCenter.TacticalWeaponLevelTemplateManager:TryGetSubLevelDic(self.level)
  if isSubLevel then
    for i, v in pairs(curLevelSubLevelDic) do
      if v.progress_total == self.progress + v.progress_add then
        subLevel = v.sub_level
        break
      end
    end
    if -1 < subLevel then
      return curLevelSubLevelDic[subLevel]
    end
  end
  return nil
end

function TacticalWeaponInfo:GetRealTemplate()
  if self:GetSubLevelTemplate() then
    return self:GetSubLevelTemplate()
  end
  return self.levelTemplate
end

return TacticalWeaponInfo
