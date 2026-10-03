local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_HeroStationUpgrade = BaseClass("ResLackItem_HeroStationUpgrade", ResLackItemBase)

function ResLackItem_HeroStationUpgrade:CheckIsOk(_resType, _needCnt)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  local buildId = self._config:getValue("para1")
  if string.IsNullOrEmpty(buildId) then
    return false
  end
  if not DataCenter.HeroStationManager:Enabled() then
    return false
  end
  self.buildUuid = nil
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(buildId)) or {}
  for _, buildInfo in pairs(list) do
    self.buildUuid = buildInfo.uuid
  end
  self.stationId = DataCenter.HeroStationManager:GetStationIdByBuildId(tonumber(buildId))
  if self.stationId ~= nil then
    local stationData = DataCenter.HeroStationManager:GetStationData(self.stationId)
    local heroUuids = stationData:GetHeroUuids()
    if next(heroUuids) then
      local items = {}
      if next(items) then
        return true
      end
    end
  end
  return false
end

function ResLackItem_HeroStationUpgrade:TodoAction()
  if self.buildUuid then
    local HeroUpgrade = 2
    GoToResLack.GotoOpenView(UIWindowNames.UIHeroStation, self.stationId, HeroUpgrade)
  end
end

return ResLackItem_HeroStationUpgrade
