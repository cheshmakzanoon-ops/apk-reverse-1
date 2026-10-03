local base = UIBaseContainer
local UIMainGoldStore = BaseClass("UIMainGoldStore", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ChangePerTime = 100
local DelayTime = 0.5
local CountNumJumpTimes = 10

function UIMainGoldStore:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainGoldStore:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainGoldStore:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textGoldStoreCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnGoldStoreIcon = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnGoldStoreIcon:SetOnClick(function()
    self:OnBtnGoldStoreIconClick()
  end)
  self.compGoldStoreRed = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.textGoldStoreRedNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgGoldIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.compGoldStoreNew = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
end

function UIMainGoldStore:ComponentDestroy()
  self.viewSkin = nil
  self.textGoldStoreCount = nil
  self.btnGoldStoreIcon = nil
  self.compGoldStoreRed = nil
  self.textGoldStoreRedNum = nil
  self.imgGoldIcon = nil
  self.compGoldStoreNew = nil
end

function UIMainGoldStore:DataDefine()
  self.delayTimer = nil
  self._resNumShow = 0
  self._resNumTarget = 0
  self._resNumDelta = 0
  self._lastSetTime = 0
  
  function self.delay_timer_action()
    self:DelayRefreshTimerBallBack()
  end
  
  self.isInPve = false
end

function UIMainGoldStore:DataDestroy()
  self:DeleteDelayRefreshTimer()
end

function UIMainGoldStore:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshWelfareRedDot, self.RefreshStoreRedPoint)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.RefreshStoreRedPoint)
  self:AddUIListener(EventId.EnterDiamondStore, self.HideStoreNewTag)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
  self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
end

function UIMainGoldStore:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshWelfareRedDot, self.RefreshStoreRedPoint)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.RefreshStoreRedPoint)
  self:RemoveUIListener(EventId.EnterDiamondStore, self.HideStoreNewTag)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  base.OnRemoveListener(self)
end

function UIMainGoldStore:OnBtnGoldStoreIconClick()
  self.view.ctrl:OnClickGoldBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, nil, nil, RechargeEntryType.Store)
  CommonUtil.FeatureExplorationTrack(FeatureExplorationType.Shop)
end

function UIMainGoldStore:ReInit()
  self._resNumShow = self.view.ctrl:GetGoldNum()
  self._resNumTarget = self._resNumShow
  self.textGoldStoreCount:SetText(string.GetFormattedGoldNum(self._resNumShow))
  self:RefreshStoreRedPoint()
end

function UIMainGoldStore:AddDelayRefreshTimer()
  self:DeleteDelayRefreshTimer()
  self.delayTimer = TimerManager:GetInstance():GetTimer(DelayTime, self.delay_timer_action, self, true, false, false)
  self.delayTimer:Start()
end

function UIMainGoldStore:DelayRefreshTimerBallBack()
  self:DeleteDelayRefreshTimer()
  self.textGoldStoreCount:SetText(string.GetFormattedGoldNum(self._resNumShow))
end

function UIMainGoldStore:DeleteDelayRefreshTimer()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UIMainGoldStore:Update()
  if self._resNumShow ~= self._resNumTarget then
    local tempT = UITimeManager:GetInstance():GetServerTime()
    if tempT - self._lastSetTime >= ChangePerTime then
      self._lastSetTime = tempT
      self._resNumShow = self._resNumShow + self._resNumDelta
      if self._resNumDelta > 0 and self._resNumShow > self._resNumTarget then
        self._resNumShow = self._resNumTarget
      elseif self._resNumDelta < 0 and self._resNumShow < self._resNumTarget then
        self._resNumShow = self._resNumTarget
      end
      self.textGoldStoreCount:SetText(string.GetFormattedGoldNum(self._resNumShow))
      if self._resNumShow == self._resNumTarget then
        self:AddDelayRefreshTimer()
      end
    end
  end
end

function UIMainGoldStore:RefreshGoldNum()
  if self.isInPve == true then
    return
  end
  self._resNumTarget = self.view.ctrl:GetGoldNum()
  if self._resNumShow ~= self._resNumTarget then
    self._resNumDelta = (self._resNumTarget - self._resNumShow) / CountNumJumpTimes
    if math.modf(self._resNumDelta) == 0 then
      self._resNumDelta = self._resNumDelta > 0 and 1 or -1
    else
      self._resNumDelta = math.modf(self._resNumDelta)
    end
    self._lastSetTime = UITimeManager:GetInstance():GetServerTime()
  else
    self.textGoldStoreCount:SetText(string.GetFormattedGoldNum(self._resNumShow))
  end
end

function UIMainGoldStore:RefreshStoreRedPoint()
  self.compGoldStoreNew:SetActive(false)
  self.compGoldStoreRed:SetActive(false)
end

function UIMainGoldStore:HideStoreNewTag()
  self:RefreshStoreRedPoint()
end

function UIMainGoldStore:OnPassDay()
  self:RefreshStoreRedPoint()
end

function UIMainGoldStore:UpdateGoldSignal()
  self:RefreshGoldNum()
end

return UIMainGoldStore
