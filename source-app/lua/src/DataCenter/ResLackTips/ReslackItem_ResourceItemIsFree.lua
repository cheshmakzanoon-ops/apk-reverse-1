local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ReslackItem_ResourceItemIsFree = BaseClass("ReslackItem_ResourceItemIsFree", ResLackItemBase)

function ReslackItem_ResourceItemIsFree:CheckIsOk(_resType, _needCnt)
  self.buildId = tonumber(self._config:getValue("para1"))
  self.itemId = self._config:getValue("goods")
  self.farmType = nil
  if self.buildId == BuildingTypes.APS_BUILD_FARM_FIELD then
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(self.buildId)
    if list ~= nil and table.count(list) > 0 then
      for k3, v3 in ipairs(list) do
        self.bUuid = v3.uuid
        local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(self.bUuid)
        if queue ~= nil and (queue:GetQueueState() == NewQueueState.Free or queue:GetQueueState() == NewQueueState.Finish) then
          self.pointId = v3.pointId
          self.farmType = queue:GetQueueState()
          break
        end
      end
    end
    if self.farmType ~= nil then
      return true
    end
  elseif DataCenter.BuildManager:IsFactoryBuild(self.buildId) then
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(self.buildId)
    if list ~= nil and table.count(list) > 0 then
      self.bUuid = list[1].uuid
      self.pointId = list[1].pointId
      return true
    end
  elseif self.buildId == BuildingTypes.APS_BUILD_PASTURE_OSTRICH or self.buildId == BuildingTypes.APS_BUILD_PASTURE_CATTLE then
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(self.buildId)
    if list ~= nil and table.count(list) > 0 then
      local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(list[1].uuid)
      if queueList then
        for i, v in pairs(queueList) do
          local state = v:GetQueueState()
          if state == NewQueueState.Finish or state == NewQueueState.Free then
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

function ReslackItem_ResourceItemIsFree:TodoAction()
  GoToUtil.CloseAllWindows()
  local onComplete
  if self.buildId == BuildingTypes.APS_BUILD_FARM_FIELD then
    if not DataCenter.GuideManager:InGuide() then
      if self.farmType == NewQueueState.Free then
        function onComplete()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarm, {
            anim = true,
            
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, tostring(self.bUuid), self.itemId)
        end
      elseif self.farmType == NewQueueState.Finish then
        function onComplete()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarmGather, {
            anim = true,
            
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, tostring(self.bUuid))
        end
      end
    end
    CS.SceneManager.World:AutoFocus(SceneUtils.TileIndexToWorld(self.pointId), CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
  elseif DataCenter.BuildManager:IsFactoryBuild(self.buildId) then
    GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(self.pointId), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFactory, self.bUuid)
    end)
  elseif self.buildId == BuildingTypes.APS_BUILD_PASTURE_OSTRICH or self.buildId == BuildingTypes.APS_BUILD_PASTURE_CATTLE then
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

return ReslackItem_ResourceItemIsFree
