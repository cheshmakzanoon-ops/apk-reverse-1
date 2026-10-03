local LWHeroUpgradePVEManager = BaseClass("LWHeroUpgradePVEManager", CEventable)

function LWHeroUpgradePVEManager:__init()
end

function LWHeroUpgradePVEManager:__delete()
  self:ClearData()
end

function LWHeroUpgradePVEManager:ClearData()
  self.heroSkillSlot1Map = nil
  self.heroSkillSlot2Map = nil
end

function LWHeroUpgradePVEManager:GetHeroEnergyLevelUpId(heroId)
  local lineData = LocalController:instance():tryGetLine(LuaEntry.Player:GetABTestTableName(TableName.LW_HERO_UPGRADE_NEWBIE), heroId)
  if lineData == nil then
    return nil
  end
  return lineData.hero_newenergy_levelup
end

function LWHeroUpgradePVEManager:GetHeroUpgradeSkillInfoData(heroInfo, realSkillInfo)
  local slot = realSkillInfo:GetSlotIndex()
  if slot ~= 1 and slot ~= 2 then
    return realSkillInfo
  end
  if self.heroSkillSlot1Map == nil then
    self.heroSkillSlot1Map = {}
    self.heroSkillSlot2Map = {}
  end
  local heroId = heroInfo.heroId
  local map = slot == 1 and self.heroSkillSlot1Map or self.heroSkillSlot2Map
  local cacheSkill = map[heroId]
  if cacheSkill == false then
    return realSkillInfo
  end
  if cacheSkill == nil then
    local lineData = LocalController:instance():tryGetLine(LuaEntry.Player:GetABTestTableName(TableName.LW_HERO_UPGRADE_NEWBIE), heroId)
    if lineData == nil then
      map[heroId] = false
      return realSkillInfo
    end
    local newSkillId = slot == 1 and lineData.hero_newattack or lineData.hero_newskill
    if newSkillId == 0 then
      map[heroId] = false
      return realSkillInfo
    end
    local newSkillInfo = heroInfo:CreateNewSkillInfoFormRealSkillInfo(newSkillId, realSkillInfo)
    map[heroId] = newSkillInfo
    return newSkillInfo
  end
  return cacheSkill
end

return LWHeroUpgradePVEManager
