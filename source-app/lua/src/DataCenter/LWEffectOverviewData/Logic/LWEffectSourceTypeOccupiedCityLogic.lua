local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeOccupiedCityLogic = BaseClass("LWEffectSourceTypeOccupiedCityLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeOccupiedCityLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeOccupiedCityLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeOccupiedCityLogic:RefreshData()
  if self.dirty or self.isGhostKingAlive then
    self.dirty = false
    self:RecalculateData()
  end
end

function LWEffectSourceTypeOccupiedCityLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.OccupiedCity)
  local serverId = LuaEntry.Player:GetSelfServerId()
  local table_name = SeasonUtil.GetWorldCityTableNameByServerId(serverId)
  local myAlId = LuaEntry.Player.allianceId
  local myAlTradeStations = DataCenter.WorldAllianceCityDataManager:GetTradeStationByAlId(myAlId)
  if myAlTradeStations then
    for k, v in pairs(myAlTradeStations) do
      local buffStr = GetTableData(table_name, v, "buff")
      if not string.IsNullOrEmpty(buffStr) then
        local effectStr = string.split(buffStr, "|")
        for j = 1, table.count(effectStr) do
          local effectData = string.split(effectStr[j], ";")
          if table.count(effectData) == 2 then
            local effectId = tonumber(effectData[1])
            local effectValue = tonumber(effectData[2])
            DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.OccupiedCity, effectId, effectValue)
          end
        end
      end
    end
  end
  local tradeBuff = DataCenter.SeasonTradeDataManager:GetShowBuffData()
  if tradeBuff ~= nil then
    local effectId = tonumber(tradeBuff.effectId)
    local effectValue = tonumber(tradeBuff.effectValue)
    if effectId and effectValue then
      DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.OccupiedCity, effectId, effectValue)
    end
  end
  local effects = DataCenter.WorldAllianceCityDataManager:GetAllianceCityEffects()
  if effects then
    local mgrEffect = DataCenter.LWEffectOverviewManager
    for effectId, effectValue in pairs(effects) do
      mgrEffect:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.OccupiedCity, checknumber(effectId), checknumber(effectValue))
    end
  end
end

return LWEffectSourceTypeOccupiedCityLogic
