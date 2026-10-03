local UITrainPrepareView = BaseClass("UITrainPrepareView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local DriverPage = require("UI.UILWRailway.UITrainPrepare.Component.DriverPage")
local PassengerPage = require("UI.UILWRailway.UITrainPrepare.Component.PassengerPage")

function UITrainPrepareView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITrainPrepareView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITrainPrepareView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.closeBtn:SetOnClick(function()
    self:CloseSelf()
  end)
  self.refreshBtn = self:AddComponent(UIButton, "Root/BottomBar/refreshBtn")
  self.refreshBtn:SetOnClick(function()
    self:OnClickRefresh()
  end)
  self.infoBtn = self:AddComponent(UIButton, "Root/Top/Title/infoBtn")
  self.infoBtn:SetOnClick(function()
    self:OnClickInfo()
  end)
  self.arrowBtn = self:AddComponent(UIButton, "Root/BottomBar/arrow")
  self.arrowBtn:SetOnClick(function()
    self:OnClickArrow()
  end)
  self.title = self:AddComponent(UIText, "Root/Top/Title")
  self.costTxt = self:AddComponent(UIText, "Root/BottomBar/refreshBtn/costTxt")
  self.anim = self:AddComponent(UISimpleAnimation, "")
  self.anim:Play("Default")
  self.time = self:AddComponent(UIText, "Root/Top/txtTime")
  self.scroll = self:AddComponent(UIScrollPage, "Root/Middle/ScrollView")
  self.scroll:SetPageChangedCallback(BindCallback(self, self.OnUpdateScroll))
  self.scroll:SetPageCount(2)
  self.scroll:SetNormalizedPosition(0)
  self.driverPage = self:AddComponent(DriverPage, "Root/Middle/ScrollView/Viewport/Content/DriverPage")
  self.passengerPage = self:AddComponent(PassengerPage, "Root/Middle/ScrollView/Viewport/Content/PassengerPage")
end

function UITrainPrepareView:ComponentDestroy()
end

function UITrainPrepareView:CloseSelf()
  self.ctrl:CloseSelf()
end

function UITrainPrepareView:DataDefine()
  self.curPage = self:GetUserData()
end

function UITrainPrepareView:DataDestroy()
end

function UITrainPrepareView:Update1000MS()
  if not self.readyEndTime then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < self.readyEndTime then
    local str = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.readyEndTime - now)
    self.time:SetText(str)
  else
    self:CloseSelf()
  end
end

function UITrainPrepareView:Refresh()
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if not trainData then
    self:CloseSelf()
    return
  end
  if trainData:IsMyTrain() then
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainFormation, 2)
    local key = "TRAIN_DRIVER_HAVE_SEEN_BUBBLE"
    local trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
    if trainData.uuid ~= trainUuid then
      CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
    end
    key = "TRAIN_DRIVER_HAVE_SEEN"
    trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
    if trainData.uuid ~= trainUuid then
      CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
      EventManager:GetInstance():Broadcast(EventId.RefreshTrainStationView)
    end
  else
    local key = "TRAIN_PASSENGER_HAVE_SEEN_BUBBLE"
    local trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
    if trainUuid ~= trainData.uuid then
      CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
    end
    key = "TRAIN_PASSENGER_HAVE_SEEN"
    trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
    if trainUuid ~= trainData.uuid then
      CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
      EventManager:GetInstance():Broadcast(EventId.RefreshTrainStationView)
    end
  end
  local key = "TRAIN_HAVE_SEEN_BUBBLE"
  local trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
  if trainUuid ~= trainData.uuid then
    CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
  end
  key = "TRAIN_HAVE_SEEN"
  trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
  if trainUuid ~= trainData.uuid then
    CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
    EventManager:GetInstance():Broadcast(EventId.RefreshTrainStationView)
  end
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  local showTeleportEffect = false
  if platformData.state == TrainPlatformState.TrainNoDriver then
    self.readyEndTime = nil
    self.time:SetActive(false)
  else
    self.readyEndTime = platformData.readyEndTime
    self.time:SetActive(true)
    showTeleportEffect = self:DriverAnim()
  end
  self:Update1000MS()
  self.scroll:PageTo(self.curPage)
  self.refreshBtn:SetActive(self.curPage == TrainPreparePage.Passenger)
  self.driverPage:Refresh(nil, showTeleportEffect)
  self.passengerPage:Refresh()
  self.title:SetLocalText(self.curPage == TrainPreparePage.Passenger and 458528 or 458519)
  self:RefreshBtn()
end

function UITrainPrepareView:OnUpdateScroll(index)
  self.curPage = index
  self.refreshBtn:SetActive(self.curPage == TrainPreparePage.Passenger)
  self.title:SetLocalText(self.curPage == TrainPreparePage.Passenger and 458528 or 458519)
end

function UITrainPrepareView:OnEnable()
  base.OnEnable(self)
  self:Refresh()
end

function UITrainPrepareView:OnDisable()
  base.OnDisable(self)
end

function UITrainPrepareView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshTrainStationView, self.Refresh)
  self:AddUIListener(EventId.AllianceTrainRefreshMessageSuccess, self.RefreshBtn)
  self:AddUIListener(EventId.ChangeTruckItemNumChange, self.RefreshBtn)
end

function UITrainPrepareView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshTrainStationView, self.Refresh)
  self:RemoveUIListener(EventId.AllianceTrainRefreshMessageSuccess, self.RefreshBtn)
  self:RemoveUIListener(EventId.ChangeTruckItemNumChange, self.RefreshBtn)
end

function UITrainPrepareView:DriverAnim()
  if self.curPage == TrainPreparePage.Passenger then
    return false
  end
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if string.IsNullOrEmpty(trainData.ownerId) then
    return false
  end
  local key = "TRAIN_DRIVER_ANIM"
  local trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
  if trainData.uuid ~= trainUuid then
    self.anim:Play("Driver")
    CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
    return true
  end
  return false
end

function UITrainPrepareView:RefreshBtn()
  local have = DataCenter.ItemData:GetItemCount(DataCenter.LWAllyStationDataManager.CHANGE_TRAIN_COST_ITEM)
  local need = DataCenter.LWAllyStationDataManager.CHANGE_TRAIN_COST_NUM
  self.costTxt:SetText(have .. "/" .. need)
  self.costTxt:SetColor(have >= need and GreenColor or RedColor)
end

function UITrainPrepareView:OnClickRefresh()
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if trainData:IsMyTrain() then
    local itemId = DataCenter.LWAllyStationDataManager.CHANGE_TRAIN_COST_ITEM
    local have = DataCenter.ItemData:GetItemCount(itemId)
    local need = DataCenter.LWAllyStationDataManager.CHANGE_TRAIN_COST_NUM
    if have >= need then
      SFSNetwork.SendMessage(MsgDefines.AllianceTrainRefresh)
    else
      LWResourceLackUtil:GotoGoodsItemLack(itemId, need - have)
    end
  else
    UIUtil.ShowTipsId(458550)
  end
end

function UITrainPrepareView:OnClickInfo()
  RailwayUtil.ShowTrainActivityConstruction()
end

function UITrainPrepareView:OnClickArrow()
  self.scroll:SmoothScrollToPage(TrainPreparePage.Passenger)
end

return UITrainPrepareView
