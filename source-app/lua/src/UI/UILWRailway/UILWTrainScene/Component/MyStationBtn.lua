local MyStationBtn = BaseClass("MyStationBtn", UIBaseContainer)
local base = UIBaseContainer

function MyStationBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MyStationBtn:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MyStationBtn:ComponentDefine()
  self.addImg = self:AddComponent(UIImage, "Ready/plus")
  self.addBtn = self:AddComponent(UIButton, "Ready")
  self.addBtn:SetOnClick(function()
    self:OnAddClick()
  end)
  self.lockBtn = self:AddComponent(UIButton, "Lock")
  self.lockBtn:SetOnClick(function()
    local data = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.TruckActivity.Type)
    if data == nil then
      UIUtil.ShowTipsId("super_trucklaunch_tips10")
      return
    end
    if LuaEntry.Player:IsLoginSourceServer() or LuaEntry.DataConfig:CheckSwitch("train_cross_server") then
      UIUtil.ShowTipsId(457563)
    else
      UIUtil.ShowTipsId(458644)
    end
  end)
end

function MyStationBtn:ComponentDestroy()
  self.heroItems = {}
  self.bg = nil
  self.qualityImage = nil
  self.head = nil
  self.title = nil
  self.time = nil
  self.desc1 = nil
  self.desc2 = nil
  self.desc3 = nil
  self.desc4 = nil
  self.goBtnText = nil
  self.goBtn = nil
  self.lockBtn = nil
  self.desc4 = nil
  self.exhausted = nil
  self.desc5 = nil
  self.anim = nil
  self.addBtn = nil
end

function MyStationBtn:DataDefine()
end

function MyStationBtn:DataDestroy()
  self.trainData = nil
end

function MyStationBtn:OnEnable()
  base.OnEnable(self)
end

function MyStationBtn:OnDisable()
  base.OnDisable(self)
end

function MyStationBtn:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshOneMyTruck, self.OnRefreshOneMyTruck)
end

function MyStationBtn:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshOneMyTruck, self.OnRefreshOneMyTruck)
end

function MyStationBtn:OnRefreshOneMyTruck(trainData)
  if trainData.index == self.index then
    self:SetData(self.index)
  end
end

function MyStationBtn:SetData(index)
  self.index = index
  self.trainData = DataCenter.LWMyStationDataManager:GetMyTrainByIndex(index)
  self.addBtn:SetActive(false)
  self.lockBtn:SetActive(false)
  local state = DataCenter.LWMyStationDataManager:GetTruckStationStateByTrainData(self.trainData)
  if state == TruckStationState.Lock then
    self:ShowLock()
  elseif state == TruckStationState.Ready then
    self:ShowAdd()
  elseif state == TruckStationState.Exhausted then
    self:ShowExhausted()
  else
    if state == TruckStationState.Travelling then
    else
    end
  end
  self.state = state
end

function MyStationBtn:ShowLock()
  self.lockBtn:SetActive(true)
end

function MyStationBtn:ShowAdd()
  self.addBtn:SetActive(true)
  CS.UIGray.SetGray(self.addImg.transform, false, true)
end

function MyStationBtn:ShowExhausted()
  self.addBtn:SetActive(true)
  CS.UIGray.SetGray(self.addImg.transform, true, true)
end

function MyStationBtn:OnAddClick()
  local state = DataCenter.LWMyStationDataManager:GetTruckStationStateByTrainData(self.trainData)
  if state == TruckStationState.Ready then
    RailwayUtil.OpenUITruckDeparture(self.trainData.buildUuid)
  elseif state == TruckStationState.Exhausted then
    UIUtil.ShowTipsId(457607)
  end
end

return MyStationBtn
