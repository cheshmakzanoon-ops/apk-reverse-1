local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_PickUpGarbage = BaseClass("ResLackItem_PickUpGarbage", ResLackItemBase)

function ResLackItem_PickUpGarbage:CheckIsOk(_resType, _needCnt)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  if CS.SceneManager:IsInCity() then
    local point = DataCenter.CityPointDataManager:SearchGarbagePointDataByResourceType(_resType, true)
    if point and point.pointId then
      self._resPoint = point.pointId
      return true
    end
  else
    local point = CS.SceneManager.World:GetGarbagePoint()
    local count = point.Count
    for i = 0, count - 1 do
      local pointInfo = CS.SceneManager.World:GetGarbagePointInfoByIndex(point[i])
      local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(pointInfo.eventId)
      if config.res ~= "" and tonumber(config.res) == _resType then
        self._resPoint = point[i]
        return true
      end
    end
  end
  return false
end

function ResLackItem_PickUpGarbage:TodoAction()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
  EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
  local data = DataCenter.CityPointDataManager:GetPointDataByPointId(self._resPoint)
  if data ~= nil then
    local uuid = data.uuid
    local worldPosition = SceneUtils.TileIndexToWorld(self._resPoint)
    if data.type == CityPointType.GarbageReward then
      worldPosition.y = worldPosition.y + 2.5
    end
    WorldArrowManager:GetInstance():ShowArrowEffect(uuid, worldPosition, ArrowType.Guide_Garbage)
  end
  DataCenter.ArrowManager:RemoveArrow()
  WorldArrowManager:GetInstance():RemoveEffect()
  local worldPointPos = SceneUtils.TileIndexToWorld(self._resPoint)
  GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    if data ~= nil and data.type == CityPointType.GarbageReward then
      worldPointPos.y = worldPointPos.y + 2.5
    end
    WorldArrowManager:GetInstance():ShowArrowEffect(0, worldPointPos, ArrowType.Guide_Garbage)
  end)
end

return ResLackItem_PickUpGarbage
