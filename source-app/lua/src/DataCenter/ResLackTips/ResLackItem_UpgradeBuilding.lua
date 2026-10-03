local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_UpgradeBuilding = BaseClass("ResLackItem_UpgradeBuilding", ResLackItemBase)
local Localization = CS.GameEntry.Localization

function ResLackItem_UpgradeBuilding:CheckIsOk(_resType, _needCnt)
  local str = self._config:getValue("para1")
  if string.IsNullOrEmpty(str) then
    return false
  end
  local arr = string.split(str, ";")
  local buildId = tonumber(arr[1])
  local targetLv = arr[2]
  self.buildId = buildId
  local lv = 9999
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId) or {}
  for _, buildInfo in pairs(list) do
    if targetLv then
      if buildInfo.level == tonumber(targetLv) then
        self.buildUuid = buildInfo.uuid
      end
    elseif lv > buildInfo.level then
      lv = buildInfo.level
      self.buildUuid = buildInfo.uuid
    end
  end
  if self.buildUuid then
    return true
  end
  return false
end

function ResLackItem_UpgradeBuilding:TodoAction()
  if CS.SceneManager.IsInPVE() then
    DataCenter.BattleLevel:Exit(function()
      GoToUtil.GotoCityByBuildUuid(self.buildUuid, WorldTileBtnType.City_Upgrade)
    end)
  else
    GoToUtil.GotoCityByBuildUuid(self.buildUuid, WorldTileBtnType.City_Upgrade)
  end
end

function ResLackItem_UpgradeBuilding:GetName()
  if self._config == nil then
    return ""
  end
  local name = self._config:getValue("name") or ""
  local buildName = ""
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
  if template ~= nil then
    buildName = Localization:GetString(template.name)
  end
  return Localization:GetString(name, buildName)
end

return ResLackItem_UpgradeBuilding
