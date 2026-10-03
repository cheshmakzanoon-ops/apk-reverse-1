local UIMainBLBtnBase = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnBase")
local UIMainBLBtnTrain = BaseClass("UIMainBLBtnTrain", UIMainBLBtnBase)
local base = UIMainBLBtnBase
local driverTipPath = "Assets/Main/Prefabs/UI/UILWRailway/Scene/driverTips.prefab"
local UIDriverTipBubbleComponent = require("UI.LWMainUI.Component.UIMainBottom.UIDriverTipBubbleComponent")

function UIMainBLBtnTrain:ComponentDefine()
  base.ComponentDefine(self)
  self.bubble = self:AddComponent(UIBaseComponent, "tip")
  self.bubbleTxt = self:TryAddComponent(UITextMeshProUGUIEx, "tip/tipTxt")
  self.vipTipsBtn = self:TryAddComponent(UIButton, "vipTips")
  self.vipTipsBtn:SetOnClick(function()
    self:vipTipsBtnOnClick()
  end)
end

function UIMainBLBtnTrain:ComponentDestroy()
  if self.driverTipReq ~= nil then
    self.driverTipReq:Destroy()
    self.driverTipReq = nil
  end
  self:ClearBubbleTimer()
  base.ComponentDestroy(self)
end

function UIMainBLBtnTrain:OnAddMainBtnListener()
  base.OnAddMainBtnListener(self)
  self:AddUIListener(EventId.OnEnterCity, self.Refresh)
  self:AddUIListener(EventId.OnEnterWorld, self.Refresh)
  self:AddUIListener(EventId.RefreshTrainStationView, self.Refresh)
  self:AddUIListener(EventId.RefreshTruckStationView, self.Refresh)
  self:AddUIListener(EventId.AllianceTrainVipInfo, self.Refresh)
  EventManager:GetInstance():AddListener(EventId.AllianceTrainVipSetInfo, self.GotoTrain)
end

function UIMainBLBtnTrain:OnRemoveMainBtnListener()
  base.OnRemoveMainBtnListener(self)
  self:RemoveUIListener(EventId.OnEnterCity, self.Refresh)
  self:RemoveUIListener(EventId.OnEnterWorld, self.Refresh)
  self:RemoveUIListener(EventId.RefreshTrainStationView, self.Refresh)
  self:RemoveUIListener(EventId.RefreshTruckStationView, self.Refresh)
  self:RemoveUIListener(EventId.AllianceTrainVipInfo, self.Refresh)
  EventManager:GetInstance():RemoveListener(EventId.AllianceTrainVipSetInfo, self.GotoTrain)
end

function UIMainBLBtnTrain:VipTrainInfoCheck()
  local isShow, isShowBubble, bubbleMsg = RailwayUtil.UIMainBLBtnTrainCheckEnable()
  local bubbleShow = self.bubble:GetActive()
  if bubbleShow then
    self.bubble:SetActive(false)
  end
  if isShowBubble then
    RailwayUtil.TryHideUIMainBtnTrainBubble()
  end
  self.vipTipsBtn.gameObject:SetActive(true)
  if not UIManager:GetInstance():CheckIfIsMainUIOpenOnly(true) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainVIPBeInvitedPop, {anim = true}, self.vipType)
  self.vipTipsBtn.gameObject:SetActive(false)
end

function UIMainBLBtnTrain:vipTipsBtnOnClick()
  if self.vipType then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainVIPBeInvitedPop, {anim = true}, self.vipType)
    self.vipTipsBtn.gameObject:SetActive(false)
  else
    Logger.LogError("\230\149\176\230\141\174\230\156\137\233\151\174\233\162\152")
  end
end

function UIMainBLBtnTrain:OnClick()
  self.commonRedPoint:SetViewed()
  local bubbleShow = self.bubble:GetActive()
  if bubbleShow then
    RailwayUtil.TryHideUIMainBtnTrainBubble()
    self.bubble:SetActive(false)
  end
  local isShow, num = self.view.ctrl:IsRedPotShowByType(self.type)
  if isShow then
    RailwayUtil.OpenUITrainList(TrainTab.Mine)
    return
  end
  GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_RAILWAY_STATION, WorldTileBtnType.TrainList)
end

function UIMainBLBtnTrain:GotoTrain()
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  if platformData.state == TrainPlatformState.TrainNoDriver then
    local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
    if not isR4orR5 then
      UIUtil.ShowTipsId(458615)
      return
    end
  end
  if CS.SceneManager:IsInCity() then
    RailwayUtil.OpenUITrainPrepare(TrainPreparePage.Driver)
  end
end

function UIMainBLBtnTrain:CheckEnable()
  local platform = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if trainData and trainData.vipInfo then
    self.vipTipsBtn.gameObject:SetActive(false)
  elseif platform and platform.vipInvite and platform.vipInvite.vipId == LuaEntry.Player.uid then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < platform.vipInvite.endTime then
      self.vipType = platform.vipInvite.vipType
      self:VipTrainInfoCheck()
      return true
    end
  end
  self.vipTipsBtn.gameObject:SetActive(false)
  local isShow, isShowBubble, bubbleMsg, isShowDriverBubble = RailwayUtil.UIMainBLBtnTrainCheckEnable()
  self.bubble:SetActive(isShowBubble)
  if isShowBubble then
    if self.bubbleTxt then
      self.bubbleTxt:SetText(bubbleMsg)
    end
    self:ClearBubbleTimer()
    self.bubbleTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.bubbleTimer = nil
      if self.bubble == nil then
        return
      end
      local bubbleShow = self.bubble:GetActive()
      if bubbleShow then
        RailwayUtil.TryHideUIMainBtnTrainBubble()
        self.bubble:SetActive(false)
      end
    end, 3)
  end
  if isShowDriverBubble then
    self:ShowDriverTipBubble()
  else
    self:HideDriverTipBubble()
  end
  return isShow
end

function UIMainBLBtnTrain:ClearBubbleTimer()
  if self.bubbleTimer ~= nil then
    self.bubbleTimer:Stop()
    self.bubbleTimer = nil
  end
end

function UIMainBLBtnTrain:Update1000MS()
  if self.vipTipsBtn.gameObject.activeSelf then
    local platform = DataCenter.LWAllyStationDataManager:GetPlatform(1)
    local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
    if trainData and trainData.vipInfo then
      self.vipTipsBtn.gameObject:SetActive(false)
    elseif platform and platform.vipInvite then
      if platform.vipInvite.vipId == LuaEntry.Player.uid then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if curTime < platform.vipInvite.endTime then
          self.vipTipsBtn.gameObject:SetActive(true)
        else
          self.vipTipsBtn.gameObject:SetActive(false)
        end
      else
        self.vipTipsBtn.gameObject:SetActive(false)
      end
    else
      self.vipTipsBtn.gameObject:SetActive(false)
    end
  end
end

function UIMainBLBtnTrain:ShowDriverTipBubble()
  if self.driverTipReq == nil then
    self.driverTipReq = self:GameObjectInstantiateAsync(driverTipPath, function(request)
      if request.isError then
        request:Destroy()
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.driverTipComp = self:AddComponent(UIDriverTipBubbleComponent, go.name)
      self.driverTipComp:SetAnchoredPositionXY(61, 1.6)
      self.driverTipComp:CheckActive()
    end)
  elseif self.driverTipComp then
    self.driverTipComp:Show()
  end
end

function UIMainBLBtnTrain:HideDriverTipBubble()
  if self.driverTipComp then
    self.driverTipComp:Hide()
  end
end

return UIMainBLBtnTrain
