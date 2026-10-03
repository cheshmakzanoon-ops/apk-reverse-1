local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_StorageShop = BaseClass("ResLackItem_StorageShop", ResLackItemBase)

function ResLackItem_StorageShop:CheckIsOk(_resType, _needCnt)
  if not DataCenter.StorageShopManager:CheckIfIsActive() then
    return false
  end
  local tmp_list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_KONBINI)
  for _, buildInfo in pairs(tmp_list) do
    if buildInfo.level > 0 then
      return true
    end
  end
  return false
end

function ResLackItem_StorageShop:TodoAction()
  GoToUtil.CloseAllWindows()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_KONBINI)
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local posEnd = buildList[1].pointId
    ResLackItemBase:TodoAction(SceneManagerSceneID.City, SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), nil, nil, function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, buildList[1].pointId, false, WorldTileBtnType.StorageShop)
    end)
  else
    GoToUtil.GotoCityByBuildId(self.build)
  end
end

return ResLackItem_StorageShop
