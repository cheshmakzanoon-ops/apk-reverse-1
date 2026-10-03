local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeOfficesLogic = BaseClass("LWEffectSourceTypeOfficesLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeOfficesLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeOfficesLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeOfficesLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.Offices)
  local serverId = LuaEntry.Player:GetSourceServerId()
  local playerUid = LuaEntry.Player:GetUid()
  local IsConqueror = DataCenter.GovernmentManager:IsConqueror(serverId)
  local officesMap = DataCenter.GovernmentManager:GetKingdomPositionByServerId(serverId)
  if officesMap then
    for configId, position in pairs(officesMap) do
      if position.uid == playerUid then
        local template = DataCenter.GovernmentTemplateManager:GetTemplate(position.positionId)
        local effectMap
        if IsConqueror then
          effectMap = template.conqueror_effect
        else
          effectMap = template.effect
        end
        for effectId, effectValue in pairs(effectMap) do
          DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Offices, effectId, effectValue)
        end
        break
      end
    end
  end
  local positionInfos = DataCenter.BuildingOfficialManager:GetMyBuildingPositions()
  if positionInfos then
    for _, position in ipairs(positionInfos) do
      local template = DataCenter.GovernmentTemplateManager:GetTemplate(position.positionId)
      if template then
        for effectId, effectValue in pairs(template.effect) do
          DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Offices, effectId, effectValue)
        end
      end
    end
  end
end

return LWEffectSourceTypeOfficesLogic
