local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ReslackItem_ResourceItemIsWork = BaseClass("ReslackItem_ResourceItemIsWork", ResLackItemBase)

function ReslackItem_ResourceItemIsWork:CheckIsOk(_resType, _needCnt)
  local str = string.split(self._config:getValue("para1"), "|")
  self.buildId = tonumber(str[1])
  self.itemId = self._config:getValue("goods")
  if self.buildId == BuildingTypes.APS_BUILD_FARM_FIELD then
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(self.buildId)
    if list ~= nil and table.count(list) > 0 then
      for k3, v3 in ipairs(list) do
        self.bUuid = v3.uuid
        local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(self.bUuid)
        if queue ~= nil and queue.itemId == str[2] and queue:GetQueueState() == NewQueueState.Work then
          self.pointId = v3.pointId
          return true
        end
      end
    end
  elseif DataCenter.BuildManager:IsFactoryBuild(self.buildId) then
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(self.buildId)
    if list ~= nil and table.count(list) > 0 then
      local state = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(list[1].uuid)
      if next(state.planZoneList) then
        for i = 1, #state.planZoneList do
          if state.planZoneList[i] == str[2] then
            self.bUuid = list[1].uuid
            self.pointId = list[1].pointId
            return true
          end
        end
      end
    end
  elseif self.buildId == BuildingTypes.APS_BUILD_PASTURE_OSTRICH or self.buildId == BuildingTypes.APS_BUILD_PASTURE_CATTLE then
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(self.buildId)
    if list ~= nil and table.count(list) > 0 then
      local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(list[1].uuid)
      if queueList then
        for i, v in pairs(queueList) do
          local state = v:GetQueueState()
          if state == NewQueueState.Work then
            self.bUuid = list[1].uuid
            self.pointId = list[1].pointId
            return true
          end
        end
      end
    end
  end
  return false
end

function ReslackItem_ResourceItemIsWork:TodoAction()
  local onComplete
  GoToUtil.CloseAllWindows()
  if self.buildId == BuildingTypes.APS_BUILD_FARM_FIELD then
    local signal = SFSObject.New()
    signal:PutLong("bUuid", self.bUuid)
    EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShow, signal)
    EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShowEffect, self.bUuid)
    local pos, needMove = UIUtil.ClickFarmAdjustPos(SceneUtils.TileIndexToWorld(self.pointId), FarmAdjust)
    CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
  elseif DataCenter.BuildManager:IsFactoryBuild(self.buildId) then
    GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(self.pointId), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFactory, self.bUuid)
    end)
  elseif self.buildId == BuildingTypes.APS_BUILD_PASTURE_OSTRICH or self.buildId == BuildingTypes.APS_BUILD_PASTURE_CATTLE then
    local signal = SFSObject.New()
    signal:PutLong("bUuid", self.bUuid)
    EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShow, signal)
    
    function onComplete()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPasture, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, self.bUuid)
    end
    
    CS.SceneManager.World:AutoFocus(SceneUtils.TileIndexToWorld(self.pointId), CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
  end
end

return ReslackItem_ResourceItemIsWork
