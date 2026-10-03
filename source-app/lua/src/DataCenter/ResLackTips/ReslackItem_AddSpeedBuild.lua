local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ReslackItem_AddSpeedBuild = BaseClass("ReslackItem_AddSpeedBuild", ResLackItemBase)

function ReslackItem_AddSpeedBuild:CheckIsOk(_resType, _needCnt)
  local build = self._config:getValue("para1") or ""
  self.build = build
  local tmp_list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(build)) or {}
  for _, buildInfo in pairs(tmp_list) do
    if buildInfo.state == BuildingStateType.Upgrading and buildInfo.updateTime >= UITimeManager:GetInstance():GetServerTime() then
      return true
    end
  end
end

function ReslackItem_AddSpeedBuild:TodoAction()
  local tmp_list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(self.build)) or {}
  for _, buildInfo in pairs(tmp_list) do
    if buildInfo.state == BuildingStateType.Upgrading and buildInfo.updateTime >= UITimeManager:GetInstance():GetServerTime() then
      GoToUtil.GotoCityByBuildUuid(buildInfo.uuid, WorldTileBtnType.City_SpeedUp)
      return
    end
  end
end

return ReslackItem_AddSpeedBuild
