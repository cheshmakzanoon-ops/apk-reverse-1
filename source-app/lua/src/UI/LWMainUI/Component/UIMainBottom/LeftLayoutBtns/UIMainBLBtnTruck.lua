local UIMainBLBtnBase = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnBase")
local UIMainBLBtnTruck = BaseClass("UIMainBLBtnTruck", UIMainBLBtnBase)
local base = UIMainBLBtnBase

function UIMainBLBtnTruck:OnAddMainBtnListener()
  base.OnAddMainBtnListener(self)
  self:AddUIListener(EventId.OnEnterCity, self.Refresh)
  self:AddUIListener(EventId.OnEnterWorld, self.Refresh)
  self:AddUIListener(EventId.RefreshTruckStationView, self.Refresh)
  self:AddUIListener(EventId.RefreshTrainStationView, self.Refresh)
end

function UIMainBLBtnTruck:OnRemoveMainBtnListener()
  base.OnRemoveMainBtnListener(self)
  self:RemoveUIListener(EventId.OnEnterCity, self.Refresh)
  self:RemoveUIListener(EventId.OnEnterWorld, self.Refresh)
  self:RemoveUIListener(EventId.RefreshTruckStationView, self.Refresh)
  self:RemoveUIListener(EventId.RefreshTrainStationView, self.Refresh)
end

function UIMainBLBtnTruck:OnClick()
  self.commonRedPoint:SetViewed()
  local state = DataCenter.LWMyStationDataManager:GetRailwayStationState()
  if state == RailwayStationState.FirstReward then
    GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_RAILWAY_STATION, WorldTileBtnType.TrainList)
  else
    local trainTab = TrainTab.Enemy
    local isShow, num, rewardNum, tipNum = self.view.ctrl:IsRedPotShowByType(self.type)
    if isShow and 0 < rewardNum then
      trainTab = TrainTab.Mine
    end
    RailwayUtil.OpenUITrainList(trainTab)
  end
end

function UIMainBLBtnTruck:CheckEnable()
  local isShowTrainBtn = RailwayUtil.UIMainBLBtnTrainCheckEnable()
  if isShowTrainBtn then
    return false
  end
  local state = DataCenter.LWMyStationDataManager:GetRailwayStationState()
  if state == RailwayStationState.CanRob then
    return true
  elseif state == RailwayStationState.FirstReward then
    return true
  end
  local states = DataCenter.LWMyStationDataManager:GetAllTruckStationState()
  for _, v in pairs(states) do
    if v == TruckStationState.Ready or v == TruckStationState.Reward then
      return true
    end
  end
  return false
end

return UIMainBLBtnTruck
