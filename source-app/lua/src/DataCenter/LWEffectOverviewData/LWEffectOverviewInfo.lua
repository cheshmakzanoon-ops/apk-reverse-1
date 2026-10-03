local LWEffectOverviewInfo = BaseClass("LWEffectOverviewInfo")
local LWEffectOverviewTemplate = require("DataCenter.LWEffectOverviewData.LWEffectOverviewTemplate")

function LWEffectOverviewInfo:__init()
  self.id = 0
  self.effectSourceData = nil
end

function LWEffectOverviewInfo:__delete()
  self.id = nil
  self.template = nil
  self.effectSourceData = nil
end

function LWEffectOverviewInfo:InitData(template)
  self.id = template.id
  self.template = template
  self:InitEffectSourceData(template)
end

function LWEffectOverviewInfo:InitDataByOffices(governmentTemplate)
  self.effectSourceData = {}
  self.id = governmentTemplate.id
  local template = LWEffectOverviewTemplate.New()
  template.id = governmentTemplate.id
  template.type = 999
  template.name = governmentTemplate.title_name
  template.index = governmentTemplate.order
  template.effectSourceList[1] = EffectOverviewSourcePoint.Offices
  local effectIds = {}
  for k, v in pairs(governmentTemplate.effect) do
    table.insert(effectIds, k)
  end
  template.effectSource2EffectIds[EffectOverviewSourcePoint.Offices] = effectIds
  self.template = template
  self:InitEffectSourceData(template)
end

function LWEffectOverviewInfo:InitEffectSourceData(template)
  self.effectSourceData = {}
  local effectSourceCount = table.count(template.effectSourceList)
  for i = 1, effectSourceCount do
    local effectSourceType = template.effectSourceList[i]
    if self.effectSourceData[effectSourceType] == nil then
      self.effectSourceData[effectSourceType] = {}
    end
    self.effectSourceData[effectSourceType].total = 0
    self.effectSourceData[effectSourceType].data = {}
    self.effectSourceData[effectSourceType].effectValInfo = {}
  end
end

function LWEffectOverviewInfo:ResetEffectSourceTotalData(effectOverviewSourcePoint)
  if self.effectSourceData[effectOverviewSourcePoint] then
    self.effectSourceData[effectOverviewSourcePoint].total = 0
    self.effectSourceData[effectOverviewSourcePoint].data = {}
    self.effectSourceData[effectOverviewSourcePoint].effectValInfo = {}
  end
end

function LWEffectOverviewInfo:RefreshEffectSourceTotalData(effectOverviewSourcePoint, effectId, effectValue, data)
  self.effectSourceData[effectOverviewSourcePoint].total = self.effectSourceData[effectOverviewSourcePoint].total + effectValue
  self.effectSourceData[effectOverviewSourcePoint].effectValInfo[effectId] = self.effectSourceData[effectOverviewSourcePoint].effectValInfo[effectId] or 0 + effectValue
  if data ~= nil then
    table.insert(self.effectSourceData[effectOverviewSourcePoint].data, data)
  end
end

function LWEffectOverviewInfo:GetEffectValueDataByEffectSourceType(effectOverviewSourcePoint)
  if self.effectSourceData[effectOverviewSourcePoint] then
    return self.effectSourceData[effectOverviewSourcePoint].total
  end
  return 0
end

function LWEffectOverviewInfo:GetAllTotalValue()
  local totalValue = 0
  if self.effectSourceData then
    for effectOverviewSourcePoint, data in pairs(self.effectSourceData) do
      totalValue = totalValue + data.total
    end
  end
  return totalValue
end

function LWEffectOverviewInfo:GetEffectValueDataBySourceTypeAndEffectId(effectOverviewSourcePoint, effectId)
  if not self.effectSourceData[effectOverviewSourcePoint] or not self.effectSourceData[effectOverviewSourcePoint].effectValInfo then
    return 0
  end
  return self.effectSourceData[effectOverviewSourcePoint].effectValInfo[effectId] or 0
end

return LWEffectOverviewInfo
