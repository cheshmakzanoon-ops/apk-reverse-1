local DepartureBtn = BaseClass("DepartureBtn", UIBaseContainer)
local base = UIBaseContainer

function DepartureBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DepartureBtn:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DepartureBtn:ComponentDefine()
  self.addBtn = self:AddComponent(UIButton, "")
  self.addBtn:SetOnClick(function()
    self:OnAddClick()
  end)
  self.bg = self:AddComponent(UIBaseComponent, "bg")
  self.redPointText = self:AddComponent(UIText, "bg/RedPoint/RedPointText")
end

function DepartureBtn:ComponentDestroy()
end

function DepartureBtn:DataDefine()
end

function DepartureBtn:DataDestroy()
end

function DepartureBtn:OnEnable()
  base.OnEnable(self)
  self:Refresh()
end

function DepartureBtn:OnDisable()
  base.OnDisable(self)
end

function DepartureBtn:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshMyTruck, self.Refresh)
end

function DepartureBtn:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshMyTruck, self.Refresh)
end

function DepartureBtn:Refresh()
  local count = DataCenter.LWMyStationDataManager:GetRealReadyCount()
  self.bg:SetActive(0 < count)
  self.redPointText:SetText(tostring(count))
  local ap = self:GetAnchoredPosition()
  local dataList = DataCenter.LWMyStationDataManager:GetMyDepartureTrains()
  ap.x = 0 < table.count(dataList) and 202 or 0
  self:SetAnchoredPosition(ap)
end

function DepartureBtn:OnAddClick()
  for i = 1, 4 do
    local trainData = DataCenter.LWMyStationDataManager:GetMyTrainByIndex(i)
    local state = DataCenter.LWMyStationDataManager:GetTruckStationStateByTrainData(trainData)
    if state == TruckStationState.Ready then
      RailwayUtil.OpenUITruckDeparture(trainData.buildUuid)
    end
  end
end

return DepartureBtn
