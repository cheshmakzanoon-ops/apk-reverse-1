local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_HeroStation = BaseClass("ResLackItem_HeroStation", ResLackItemBase)

function ResLackItem_HeroStation:CheckIsOk(_resType, _needCnt)
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
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(buildId)) or {}
  for _, buildInfo in pairs(list) do
    self.buildUuid = buildInfo.uuid
  end
  self.stationId = DataCenter.HeroStationManager:GetStationIdByBuildId(tonumber(buildId))
  if self.stationId ~= nil and DataCenter.HeroStationManager:HasAvailableHero(stationId) and DataCenter.HeroStationManager:HasAvailableSlot(self.stationId) then
    return true
  end
  return false
end

function ResLackItem_HeroStation:TodoAction()
  if self.buildUuid then
    local empty = 1
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroStation, {
      anim = true,
      hideTop = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.stationId, empty)
  end
end

return ResLackItem_HeroStation
