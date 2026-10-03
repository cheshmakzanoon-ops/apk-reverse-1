local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_LandLockChest = BaseClass("ResLackItem_LandLockChest", ResLackItemBase)
local landLockId

function ResLackItem_LandLockChest:CheckIsOk(_resType, _needCnt)
  local itemId = _resType
  local dataList = DataCenter.LandLockManager:GetLandLockDataListByState(LandLockState.Any)
  for _, data in ipairs(dataList) do
    if data.state == LandLockState.Finished and data:HasReward() then
      local template = DataCenter.LandLockManager:GetTemplate(data.id)
      if table.hasvalue(template.rewardItemList, itemId) then
        landLockId = data.id
        return true
      end
    end
  end
  return false
end

function ResLackItem_LandLockChest:TodoAction()
  GoToUtil.CloseAllWindows()
  if landLockId ~= nil then
    local data = DataCenter.LandLockManager:GetLandLockDataById(landLockId)
    local pointId = data:GetPointId()
    GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(pointId), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      WorldArrowManager:GetInstance():ShowArrowEffect(0, SceneUtils.TileIndexToWorld(pointId))
    end)
  end
end

return ResLackItem_LandLockChest
