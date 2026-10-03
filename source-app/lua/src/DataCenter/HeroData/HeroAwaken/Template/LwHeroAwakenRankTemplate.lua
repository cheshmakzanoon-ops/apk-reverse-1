local LwHeroAwakenRankTemplate = BaseClass("LwHeroAwakenRankTemplate")
local Localization = CS.GameEntry.Localization

function LwHeroAwakenRankTemplate:__init()
  self.id = 0
  self.hero_id = 0
  self.level = 0
  self.attr_add = {}
  self.rank_cost = 0
  self.skill_list = {}
  self.is_advanced_skin = 0
  self.skillId = nil
  self.isMaxLevel = nil
end

function LwHeroAwakenRankTemplate:__delete()
  self.id = nil
  self.hero_id = nil
  self.level = nil
  self.attr_add = nil
  self.rank_cost = nil
  self.skill_list = nil
  self.is_advanced_skin = nil
  self.skillId = nil
  self.isMaxLevel = nil
end

function LwHeroAwakenRankTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.hero_id = rowData:getValue("hero_id") or 0
  self.level = rowData:getValue("level") or 0
  self.attr_add = rowData:getValue("attr_add") or {}
  self.rank_cost = rowData:getValue("rank_cost") or 0
  self.skill_list = rowData:getValue("skill_list") or {}
  self.is_advanced_skin = rowData:getValue("is_advanced_skin") or 0
end

function LwHeroAwakenRankTemplate:GetSkillId()
  if self.skillId == nil and #self.skill_list >= 1 then
    self.skillId = self.skill_list[1]
  end
  return self.skillId
end

function LwHeroAwakenRankTemplate:GetEffectAdd(effctId, formatted)
  local add = 0
  if self.attr_add[effctId] then
    add = self.attr_add[effctId]
  end
  if not formatted then
    return add
  else
    return tostring(math.floor(add))
  end
end

function LwHeroAwakenRankTemplate:GetRankUpgradeCostItemCount()
  return self.rank_cost
end

function LwHeroAwakenRankTemplate:GetRankLevel()
  return self.level
end

function LwHeroAwakenRankTemplate:IsMaxRankLevel()
  if self.isMaxLevel == nil then
    local awakenTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenTemplateById(self.hero_id, true)
    if awakenTemplate ~= nil then
      local maxLevel = awakenTemplate:GetHeroAwakenMaxRankLevel()
      local curLevel = self:GetRankLevel()
      self.isMaxLevel = maxLevel <= curLevel
    else
      self.isMaxLevel = false
    end
  end
  return self.isMaxLevel
end

function LwHeroAwakenRankTemplate:GetNextRankTemplate()
  if self:IsMaxRankLevel() then
    return nil
  end
  local curLevel = self:GetRankLevel()
  local nextId = HeroUtils.GetHeroAwakenRankIdByHeroIdAndLevel(self.hero_id, curLevel + 1)
  return DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenRankTemplateById(nextId)
end

function LwHeroAwakenRankTemplate:GetUpgradePageShowEffects(heroData)
  local res = {}
  local showEffectDict = {}
  local curEffects = self.attr_add
  local effectCount = 1
  if not table.IsNullOrEmpty(curEffects) then
    for i, v in pairs(curEffects) do
      local processedValue = v
      if heroData then
        processedValue = heroData:ProcessEffectValue(i, v)
      end
      showEffectDict[i] = {
        index = effectCount,
        curValue = processedValue,
        effectId = i,
        title = GetTableData(TableName.LW_Effect_Number, i, "name", "")
      }
      effectCount = effectCount + 1
    end
  end
  local nextTemplate = self:GetNextRankTemplate()
  if nextTemplate then
    local nextEffects = nextTemplate.attr_add
    if not table.IsNullOrEmpty(nextEffects) then
      for i, v in pairs(nextEffects) do
        local processedValue = v
        if heroData then
          processedValue = heroData:ProcessEffectValue(i, v)
        end
        if showEffectDict[i] then
          showEffectDict[i].nextValue = processedValue
        else
          showEffectDict[i] = {
            index = effectCount,
            curValue = 0,
            nextValue = processedValue,
            effectId = i,
            title = GetTableData(TableName.LW_Effect_Number, i, "name", "")
          }
          effectCount = effectCount + 1
        end
      end
    end
  end
  for i, v in pairs(showEffectDict) do
    table.insert(res, v)
  end
  table.sort(res, function(a, b)
    return a.effectId < b.effectId
  end)
  return res
end

return LwHeroAwakenRankTemplate
