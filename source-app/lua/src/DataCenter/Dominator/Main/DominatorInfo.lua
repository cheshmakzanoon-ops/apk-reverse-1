local DominatorInfo = BaseClass("DominatorInfo")
local DominatorMainTemplate = require("DataCenter/Dominator/TemplateManager/DominatorMainTemplate")
local DominatorSkillInfo = require("DataCenter/Dominator/Main/DominatorSkillInfo")
local DominatorUtils = require("DataCenter.Dominator.Main.DominatorUtils")
DominatorInfo.State = {
  Locked = -1,
  Free = 0,
  March = 1
}

function DominatorInfo:__init()
  self.uuid = 0
  self.dominatorId = 0
  self.name = ""
  self.rankLv = 0
  self.power = 0
  self.state = -1
  self.skillList = {}
  self.skillDict = {}
  self.handbook = {}
end

function DominatorInfo:__delete()
  self.uuid = nil
  self.dominatorId = nil
  self.name = nil
  self.rankLv = nil
  self.state = nil
  self.power = nil
  self.skillList = nil
  self.skillDict = nil
  self.handbook = nil
end

function DominatorInfo:UpdateInfo(info)
  if not info then
    return
  end
  if info.uuid then
    self.uuid = info.uuid
  end
  if info.dominatorId then
    self.dominatorId = info.dominatorId
  end
  if info.name then
    self.name = info.name
  end
  if info.rankLv then
    self.rankLv = info.rankLv
    local heroInfo = self:GetHeroInfo()
    if heroInfo then
      heroInfo.modelId = self:GetAppearanceId()
      heroInfo.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(heroInfo.modelId)
      heroInfo.rank = self:GetCurRankLv()
    end
  end
  if info.state then
    self.state = info.state
  end
  if info.power then
    self.power = info.power
  end
  if info.skills then
    self.skillList = {}
    self.skillDict = {}
    for _, dt in pairs(info.skills) do
      local skillId = dt.skillId
      local skillData = DominatorSkillInfo.New()
      skillData:SetAddMaxLevel(self.skillMaxLvAdd or 0)
      skillData:UpdateSkillInfo(dt)
      self.skillDict[skillId] = skillData
      self.skillList[skillData:GetSlotIndex()] = skillData
    end
  end
  if info.effect then
    local heroInfo = self:GetHeroInfo()
    if heroInfo then
      heroInfo:UpdateEffect(info.effect)
    end
  end
  if info.handbook then
    self.handbook = info.handbook
  end
end

function DominatorInfo:IsDataValid()
  return true
end

function DominatorInfo:GetMainTemplate()
  return DataCenter.DominatorTemplateManager:GetMainTemplateById(self.dominatorId)
end

function DominatorInfo:GetCurRankLv()
  return self.rankLv
end

function DominatorInfo:GetCurRankId()
  local template = self:GetMainTemplate()
  if template then
    local rankId = template.dominator_star_id + self.rankLv
    return rankId
  end
  return 0
end

function DominatorInfo:IsMaxRank()
  local curRankTemplate = self:GetCurRankTemplate()
  return curRankTemplate ~= nil and curRankTemplate:IsMaxRank()
end

function DominatorInfo:GetCurRankTemplate()
  local curRankId = self:GetCurRankId()
  return DataCenter.DominatorTemplateManager:GetRankTemplateById(curRankId)
end

function DominatorInfo:GetCurRankShowTemplate()
  local curRankTemplate = self:GetCurRankTemplate()
  if curRankTemplate then
    return curRankTemplate:GetRankShowTemplate()
  end
  return nil
end

function DominatorInfo:GetUserName()
  if not string.IsNullOrEmpty(self.name) then
    return self.name
  end
  local mainTemplate = self:GetMainTemplate()
  if mainTemplate ~= nil then
    return mainTemplate:GetName()
  end
  return ""
end

function DominatorInfo:GetPower()
  return self.power
end

function DominatorInfo:GetSkillInfoBySlotIndex(index)
  if self.skillList == nil then
    return nil
  end
  if self.skillList[index] then
    return self.skillList[index]
  end
  return nil
end

function DominatorInfo:GetSkillInfoBySkillId(skillId)
  if self.skillDict == nil then
    return nil
  end
  if self.skillDict[skillId] then
    return self.skillDict[skillId]
  end
  return nil
end

function DominatorInfo:GetSkillInfoBySkillGroupId(skillGroupId)
  if self.skillDict == nil then
    return nil
  end
  for i, v in pairs(self.skillDict) do
    if v:GetGroupId() == skillGroupId then
      return v
    end
  end
  return nil
end

function DominatorInfo:GetAllUnlockSkills()
  if self.skillDict then
    local ret = {}
    for _, v in pairs(self.skillDict) do
      if v.isUnlocked then
        table.insert(ret, v)
      end
    end
    return ret
  end
end

function DominatorInfo:GetSkillUnlockRankByIndex(index)
  local mainTemplate = self:GetMainTemplate()
  if mainTemplate then
    local heroTemplate = mainTemplate:GetHeroTemplate()
    if heroTemplate then
      local skillUnlockRanks = heroTemplate.skills_unlock_rank
      if not table.IsNullOrEmpty(skillUnlockRanks) then
        if skillUnlockRanks[index] then
          return skillUnlockRanks[index]
        end
      else
        return 0
      end
    end
  end
  return 0
end

function DominatorInfo:GetUpgradeRankCostItemNum()
  if self:IsMaxRank() then
    return 0
  end
  local curRankTemplate = self:GetCurRankTemplate()
  if curRankTemplate ~= nil then
    return curRankTemplate.item_cost
  end
  return 0
end

function DominatorInfo:GetCurState()
  return self.state
end

function DominatorInfo:IsUnlocked()
  return self.state > DominatorInfo.State.Locked
end

function DominatorInfo:IsCanOpenFromMainBuilding()
  return self:IsUnlocked()
end

function DominatorInfo:IsShowInTrainScene()
  return self:IsUnlocked()
end

function DominatorInfo:GetAppearanceId()
  local rankTemplate = self:GetCurRankTemplate()
  if rankTemplate then
    return rankTemplate:GetRankShowAppearanceId()
  end
  return 0
end

function DominatorInfo:IsCanUpgradeRank()
  if self:IsMaxRank() or not self:IsUnlocked() then
    return false
  end
  local mainTemplate = self:GetMainTemplate()
  if mainTemplate then
    local itemId = mainTemplate:GetUpgradeRankCostItemId()
    if itemId then
      local haveCount = DataCenter.ItemData:GetItemCount(itemId)
      local costCount = self:GetUpgradeRankCostItemNum()
      if haveCount >= costCount then
        return true
      end
      local commonItemId = DataCenter.DominatorManager:GetCommonRankUpgradeItemId()
      if commonItemId and 0 < commonItemId then
        local commonCostCount = costCount - haveCount
        local commonHaveCount = DataCenter.ItemData:GetItemCount(commonItemId)
        if commonCostCount <= commonHaveCount then
          return true
        end
      end
      return false
    end
  end
  return false
end

function DominatorInfo:GetCanUpgradeSkillCount()
  local res = 0
  if self:IsUnlocked() then
    for i = 1, 5 do
      local skillInfo = self:GetSkillInfoBySlotIndex(i)
      if skillInfo and skillInfo:IsUnlock() and not skillInfo:IsReachMaxLevel() then
        local mainTemplate = self:GetMainTemplate()
        if mainTemplate then
          local skillPointId = mainTemplate:GetSkillUpgradeCostItemId()
          if skillPointId then
            local haveSkillPoint = DataCenter.ItemData:GetItemCount(skillPointId)
            local need = skillInfo:GetUpgradeCostSkillPoint()
            if haveSkillPoint >= need then
              res = res + 1
            end
          end
        end
      end
    end
  end
  return res
end

function DominatorInfo:GetHeroInfo()
  if self.heroInfo == nil then
    local mainTemplate = self:GetMainTemplate()
    self.heroInfo = HeroInfo.New()
    self.heroInfo:UpdateFromMailData(mainTemplate.dominator_id, nil, nil, nil, self:GetCurRankLv())
  end
  return self.heroInfo
end

function DominatorInfo:GetAllEffects()
  local heroInfo = self:GetHeroInfo()
  if heroInfo then
    return heroInfo:GetAllProperty()
  end
end

function DominatorInfo:GetEffect(effectId)
  local heroInfo = self:GetHeroInfo()
  if heroInfo then
    return heroInfo:GetProperty(effectId)
  end
  return 0
end

function DominatorInfo:GetRankLevelAllEffects()
  local res = {}
  local allEffects = self:GetAllEffects()
  if not table.IsNullOrEmpty(allEffects) then
    local curRankTemplate = self:GetCurRankTemplate()
    if curRankTemplate then
      for effectId, value in pairs(allEffects) do
        if curRankTemplate:IsContainsEffect(effectId) then
          table.insert(res, {effectId = effectId, effectValue = value})
        end
      end
    end
  end
  return res
end

function DominatorInfo:GetTrainLevelAllEffects()
  local res = {}
  local allEffects = self:GetAllEffects()
  if not table.IsNullOrEmpty(allEffects) then
    local curTrainLevelTemplates = {}
    local mainTrainGroup = DataCenter.DominatorTemplateManager:GetMainTrainGroupTemplate()
    if mainTrainGroup then
      local info = DataCenter.DominatorManager:GetTrainInfoByGroupId(mainTrainGroup.id)
      if info then
        local curTemplate = info:GetCurLevelTemplate()
        if curTemplate then
          table.insert(curTrainLevelTemplates, curTemplate)
        end
      end
    end
    local normalTrainGroups = DataCenter.DominatorTemplateManager:GetAllNormalTrainGroupTemplates()
    for i, v in pairs(normalTrainGroups) do
      local info = DataCenter.DominatorManager:GetTrainInfoByGroupId(v.id)
      if info then
        local curTemplate = info:GetCurLevelTemplate()
        if curTemplate then
          table.insert(curTrainLevelTemplates, curTemplate)
        end
      end
    end
    for effectId, value in pairs(allEffects) do
      for _, v in pairs(curTrainLevelTemplates) do
        if v:IsContainsEffect(effectId) then
          table.insert(res, {effectId = effectId, effectValue = value})
        end
      end
    end
  end
  return res
end

function DominatorInfo:IsUnlockedBattle()
  if self.state <= DominatorInfo.State.Locked then
    return false
  end
  local mainTemplate = self:GetMainTemplate()
  if not mainTemplate then
    return false
  end
  local lv_limit = mainTemplate.team_limit_level
  local lvTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(lv_limit)
  if not lvTemplate then
    return false
  end
  local groupId = lvTemplate.level_group
  local trainLv = DataCenter.DominatorManager:GetTrainByGroupId(groupId)
  if trainLv <= 0 then
    return false
  end
  return trainLv >= lvTemplate.level_order
end

function DominatorInfo:IsUnlockedBattleForTrial()
  if self.state <= DominatorInfo.State.Locked then
    return false
  end
  return true
end

function DominatorInfo:GetMaxHp()
  local heroInfo = self:GetHeroInfo()
  return heroInfo:GetProperty(HeroEffectDefine.DominatorFinalHp)
end

function DominatorInfo:GetSoldierCapacity()
  local heroInfo = self:GetHeroInfo()
  return heroInfo:GetProperty(HeroEffectDefine.HeroSoldierCapacity)
end

function DominatorInfo:GetSquadIndex()
  return DataCenter.ArmyFormationDataManager:GetDominatorSquadIndex(self.uuid)
end

function DominatorInfo:GetAtkSourceDict()
  local totalFinalValue = math.max(math.floor(self:GetEffect(HeroEffectDefine.DominatorFinalAttack)), 0)
  local mainTrainAddRate = self:GetEffect(HeroEffectDefine.DominatorMainTrainGroupAttackAddRate)
  local rankAddRate = self:GetEffect(HeroEffectDefine.DominatorRankAttackAddRate)
  local rankVal = (self:GetEffect(HeroEffectDefine.DominatorBaseAttack) + self:GetEffect(HeroEffectDefine.DominatorNormalTrainGroupAttack) + self:GetEffect(HeroEffectDefine.DominatorRankAttack)) * rankAddRate + self:GetEffect(HeroEffectDefine.DominatorRankAttack)
  local mainTrainVal = (self:GetEffect(HeroEffectDefine.DominatorBaseAttack) + self:GetEffect(HeroEffectDefine.DominatorNormalTrainGroupAttack) + self:GetEffect(HeroEffectDefine.DominatorRankAttack)) * mainTrainAddRate + self:GetEffect(HeroEffectDefine.DominatorMainTrainGroupAttack)
  local buildVal = self:GetEffect(HeroEffectDefine.DominatorBuildAttack)
  local tacticalWeaponVal = self:GetEffect(HeroEffectDefine.DominatorTacticalWeaponFinalAttack)
  local normalTrainVal = self:GetEffect(HeroEffectDefine.DominatorBaseAttack) + self:GetEffect(HeroEffectDefine.DominatorNormalTrainGroupAttack)
  rankVal = math.max(math.floor(rankVal), 0)
  mainTrainVal = math.max(math.floor(mainTrainVal), 0)
  buildVal = math.max(math.floor(buildVal), 0)
  tacticalWeaponVal = math.max(math.floor(tacticalWeaponVal), 0)
  normalTrainVal = totalFinalValue - (rankVal + mainTrainVal + buildVal + tacticalWeaponVal)
  return {
    rankVal = rankVal,
    normalTrainVal = normalTrainVal,
    mainTrainVal = mainTrainVal,
    buildVal = buildVal,
    tacticalWeaponVal = tacticalWeaponVal
  }
end

function DominatorInfo:GetDefSourceDict()
  local totalFinalValue = math.max(math.floor(self:GetEffect(HeroEffectDefine.DominatorFinalDefence)), 0)
  local mainTrainAddRate = self:GetEffect(HeroEffectDefine.DominatorMainTrainGroupDefenceAddRate)
  local rankAddRate = self:GetEffect(HeroEffectDefine.DominatorRankDefenceAddRate)
  local rankVal = (self:GetEffect(HeroEffectDefine.DominatorBaseDefence) + self:GetEffect(HeroEffectDefine.DominatorNormalTrainGroupDefence) + self:GetEffect(HeroEffectDefine.DominatorRankDefence)) * rankAddRate + self:GetEffect(HeroEffectDefine.DominatorRankDefence)
  local normalTrainVal = self:GetEffect(HeroEffectDefine.DominatorBaseDefence) + self:GetEffect(HeroEffectDefine.DominatorNormalTrainGroupDefence)
  local mainTrainVal = (self:GetEffect(HeroEffectDefine.DominatorBaseDefence) + self:GetEffect(HeroEffectDefine.DominatorNormalTrainGroupDefence) + self:GetEffect(HeroEffectDefine.DominatorRankDefence)) * mainTrainAddRate + self:GetEffect(HeroEffectDefine.DominatorMainTrainGroupDefence)
  local buildVal = self:GetEffect(HeroEffectDefine.DominatorBuildDefence)
  local tacticalWeaponVal = self:GetEffect(HeroEffectDefine.DominatorTacticalWeaponFinalDefence)
  rankVal = math.max(math.floor(rankVal), 0)
  mainTrainVal = math.max(math.floor(mainTrainVal), 0)
  buildVal = math.max(math.floor(buildVal), 0)
  tacticalWeaponVal = math.max(math.floor(tacticalWeaponVal), 0)
  normalTrainVal = totalFinalValue - (rankVal + mainTrainVal + buildVal + tacticalWeaponVal)
  return {
    rankVal = rankVal,
    normalTrainVal = normalTrainVal,
    mainTrainVal = mainTrainVal,
    buildVal = buildVal,
    tacticalWeaponVal = tacticalWeaponVal
  }
end

function DominatorInfo:GetHpSourceDict()
  local totalFinalValue = math.max(math.floor(self:GetEffect(HeroEffectDefine.DominatorFinalHp)), 0)
  local mainTrainAddRate = self:GetEffect(HeroEffectDefine.DominatorMainTrainGroupHpAddRate)
  local rankAddRate = self:GetEffect(HeroEffectDefine.DominatorRankHpAddRate)
  local rankVal = (self:GetEffect(HeroEffectDefine.DominatorBaseHp) + self:GetEffect(HeroEffectDefine.DominatorNormalTrainGroupHp) + self:GetEffect(HeroEffectDefine.DominatorRankHp)) * rankAddRate + self:GetEffect(HeroEffectDefine.DominatorRankHp)
  local normalTrainVal = self:GetEffect(HeroEffectDefine.DominatorBaseHp) + self:GetEffect(HeroEffectDefine.DominatorNormalTrainGroupHp)
  local mainTrainVal = (self:GetEffect(HeroEffectDefine.DominatorBaseHp) + self:GetEffect(HeroEffectDefine.DominatorNormalTrainGroupHp) + self:GetEffect(HeroEffectDefine.DominatorRankHp)) * mainTrainAddRate + self:GetEffect(HeroEffectDefine.DominatorMainTrainGroupHp)
  local buildVal = self:GetEffect(HeroEffectDefine.DominatorBuildHp)
  local tacticalWeaponVal = self:GetEffect(HeroEffectDefine.DominatorTacticalWeaponFinalHp)
  rankVal = math.max(math.floor(rankVal), 0)
  mainTrainVal = math.max(math.floor(mainTrainVal), 0)
  buildVal = math.max(math.floor(buildVal), 0)
  tacticalWeaponVal = math.max(math.floor(tacticalWeaponVal), 0)
  normalTrainVal = totalFinalValue - (rankVal + mainTrainVal + buildVal + tacticalWeaponVal)
  return {
    rankVal = rankVal,
    normalTrainVal = normalTrainVal,
    mainTrainVal = mainTrainVal,
    buildVal = buildVal,
    tacticalWeaponVal = tacticalWeaponVal
  }
end

function DominatorInfo:GetSCSourceDict()
  local trainVal = 0
  local mainTrainInfo = DataCenter.DominatorManager:GetMainTrainGroupInfo()
  if mainTrainInfo then
    local mainTrainLevelTemplate = mainTrainInfo:GetCurLevelTemplate()
    if mainTrainLevelTemplate then
      trainVal = mainTrainLevelTemplate:GetSoldierCapacity()
    end
  end
  local buildVal = self:GetEffect(HeroEffectDefine.AllBuildingLastSoldierCapacity)
  trainVal = math.max(math.floor(trainVal), 0)
  buildVal = math.max(math.floor(buildVal), 0)
  return {trainVal = trainVal, buildVal = buildVal}
end

function DominatorInfo:GetArchiveStateById(id)
  local archiveTemplate = DataCenter.DominatorTemplateManager:GetStoryShowTemplateById(id)
  if archiveTemplate and self.handbook and self.handbook[archiveTemplate.position_num] then
    return self.handbook[archiveTemplate.position_num]
  end
  return DominatorArchiveState.Locked
end

function DominatorInfo:GetArchiveCanUnlockIdList()
  local res = {}
  if self.handbook then
    for i, v in pairs(self.handbook) do
      if v == DominatorArchiveState.CanUnlock then
        table.insert(res, i)
      end
    end
  end
  return res
end

function DominatorInfo:HasAnyArchiveCanUnlock()
  local canUnlockIdList = self:GetArchiveCanUnlockIdList()
  return not table.IsNullOrEmpty(canUnlockIdList)
end

function DominatorInfo:GetTotalSkillCount()
  local res = 0
  if self.skillList then
    for i, v in pairs(self.skillList) do
      res = res + 1
    end
  end
  return res
end

function DominatorInfo:GetCityMainBuildingBubbleIconPath()
  local mainTemplate = self:GetMainTemplate()
  if mainTemplate and not string.IsNullOrEmpty(mainTemplate.main_building_icon) then
    return mainTemplate.main_building_icon
  end
  return string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.DominatorMainBuildingBubbleIconGorilla)
end

return DominatorInfo
