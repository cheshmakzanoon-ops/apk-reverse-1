local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_KonbiniOrderComplete = BaseClass("ResLackItem_KonbiniOrderComplete", ResLackItemBase)

function ResLackItem_KonbiniOrderComplete:CheckIsOk(_resType, _needCnt)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  if DataCenter.StorageShopManager:CheckIfIsActive() then
    return false
  end
  local list = DataCenter.StorageShopManager:GetSelfSlotsInfo()
  for i, v in pairs(list) do
    if v.state == StorageShopSlotState.Empty then
      return true
    end
  end
  return false
end

function ResLackItem_KonbiniOrderComplete:TodoAction()
  GoToUtil.CloseAllWindows()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_KONBINI)
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local posEnd = buildList[1].pointId
    ResLackItemBase:TodoAction(SceneManagerSceneID.City, SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), nil, nil, function()
      local isArrow = 1
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopMain, nil, 1, isArrow)
    end)
  else
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_KONBINI)
  end
end

return ResLackItem_KonbiniOrderComplete
