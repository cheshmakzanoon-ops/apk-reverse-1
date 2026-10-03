local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ReslackItem_KonbiniFree = BaseClass("ReslackItem_KonbiniFree", ResLackItemBase)

function ReslackItem_KonbiniFree:CheckIsOk(_resType, _needCnt)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  self.buildId = BuildingTypes.FUN_BUILD_KONBINI
  local itemId = self._config:getValue("goods")
  local buildData
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(self.buildId))
  if list ~= nil and table.count(list) > 0 then
    buildData = DataCenter.BuildManager:GetBuildingDataByUuid(list[1].uuid)
  else
    return true
  end
  local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildId, buildData.level)
  local freeAllCount = math.tointeger(tonumber(template.para3) + LuaEntry.Effect:GetGameEffect(EffectDefine.KONBINI_EXTRA_FREE_COUNT))
  local restFreeCount = freeAllCount - LuaEntry.Player:GetKonbiniFreeBuyCountToday()
  if 0 < restFreeCount then
    return true
  end
  local freeItemData = DataCenter.ItemData:GetItemById(itemId)
  if freeItemData and freeItemData.count > 0 then
    return true
  end
  return false
end

function ReslackItem_KonbiniFree:TodoAction()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(self.buildId))
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    GoToUtil.GotoCityByBuildId(tonumber(self.buildId), WorldTileBtnType.Konbini)
  else
    GoToUtil.GotoCityByBuildId(tonumber(self.buildId))
  end
end

return ReslackItem_KonbiniFree
