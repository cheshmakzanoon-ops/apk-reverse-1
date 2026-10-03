local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_CollectResInMainCity = BaseClass("ResLackItem_CollectResInMainCity", ResLackItemBase)

function ResLackItem_CollectResInMainCity:CheckIsOk(_resType, _needCnt)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  local build_list = self._config:getValue("para1") or ""
  local build_array = string.split(build_list, ";")
  if table.count(build_array) == 0 then
    return false
  end
  self.build_array = build_array
  self.isFactory = false
  local isGreater = false
  local baseline = tonumber(self._config:getValue("baseline")) or 0
  for _, buildId in pairs(build_array) do
    local tmp_list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(buildId)) or {}
    for _, buildInfo in pairs(tmp_list) do
      if buildInfo.state == BuildingStateType.Upgrading and buildInfo:IsUpgradeFinish() then
        isGreater = true
      end
      if baseline == 0 then
        local info = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(buildInfo.uuid)
        for i = 1, #info.productZoneList do
          local factoryTemplate = DataCenter.FactoryDataManager:GetFactoryTemplate(info.productZoneList[i])
          for k, v in pairs(factoryTemplate.get_resource_goods) do
            if _resType == k then
              isGreater = true
              self.isFactory = true
            end
          end
        end
      elseif DataCenter.BuildBubbleManager:GetBuildNeedShowBuildBubble(buildInfo.uuid) then
        local num = DataCenter.BuildManager:GetOutResourceNum(buildInfo.uuid)
        local buildTemps = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildInfo.itemId, buildInfo.level)
        if num >= tonumber(buildTemps.para2) * baseline then
          isGreater = true
        end
      end
    end
  end
  local is_calculate = self._config:getValue("is_calculate")
  if is_calculate == "1" then
    return isGreater
  else
    return true
  end
  return false
end

function ResLackItem_CollectResInMainCity:TodoAction()
  local pointId = 0
  local obj
  for _, buildId in pairs(self.build_array) do
    local tmp_list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(buildId)) or {}
    for _, buildInfo in pairs(tmp_list) do
      if 0 < buildInfo.updateTime then
        GoToUtil.GotoCityByBuildUuid(buildInfo.uuid)
        return
      end
      if self.isFactory then
        obj = DataCenter.BuildBubbleManager:GetBubbleObjByBuildUuid(buildInfo.uuid)
        pointId = buildInfo.pointId
        break
      elseif DataCenter.BuildBubbleManager:GetBuildNeedShowBuildBubble(buildInfo.uuid) then
        local num = DataCenter.BuildManager:GetOutResourceNum(buildInfo.uuid)
        if 0 < num then
          pointId = buildInfo.pointId
          break
        end
      end
    end
  end
  if pointId ~= 0 then
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
    local worldPointPos = SceneUtils.TileIndexToWorld(pointId)
    local onComplete
    if self.isFactory then
      if obj then
        function onComplete()
          WorldArrowManager:GetInstance():ShowArrowEffect(0, obj.transform.position, ArrowType.Building)
        end
      else
        function onComplete()
          WorldArrowManager:GetInstance():ShowArrowEffect(0, SceneUtils.TileIndexToWorld(pointId))
        end
      end
    end
    GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, onComplete)
  end
end

return ResLackItem_CollectResInMainCity
