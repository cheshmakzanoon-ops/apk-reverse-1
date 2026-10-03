local LWAllianceCongratulationPopView = BaseClass("LWAllianceCongratulationPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllianceCongratulationCard = require("UI.AllianceCongratulation.CongratulationPop.Component.AllianceCongratulationCard")
local delayTime = 0.75

function LWAllianceCongratulationPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
  self:RefreshCard(true)
end

function LWAllianceCongratulationPopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWAllianceCongratulationPopView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBg = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBg:SetOnClick(function()
    self:OnBtnBgClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compCardA = self.viewSkin:AddComponent(self, AllianceCongratulationCard, 6)
  self.compCardB = self.viewSkin:AddComponent(self, AllianceCongratulationCard, 7)
  self.nodeHighfive = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.compCenter = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.animator = self:AddComponent(UIAnimator, "")
end

function LWAllianceCongratulationPopView:ComponentDestroy()
  self.viewSkin = nil
  self.btnBg = nil
  self.btnClose = nil
  self.textTips = nil
  self.btnGo = nil
  self.textNum = nil
  self.compCardA = nil
  self.compCardB = nil
  self.nodeHighfive = nil
  self.compCenter = nil
  self.animator = nil
end

function LWAllianceCongratulationPopView:DataDefine()
  self.closing = false
end

function LWAllianceCongratulationPopView:DataDestroy()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  if self.delaySound then
    self.delaySound:Stop()
    self.delaySound = nil
  end
  if self.delaySound2 then
    self.delaySound2:Stop()
    self.delaySound2 = nil
  end
  self.list = nil
  self.btnDownState = nil
  self.nextDay = nil
  self.remainCount = nil
  self.closing = nil
  self.btnGoRunning = nil
end

function LWAllianceCongratulationPopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceCongratulationListNew, self.ShowNextCard)
  self:AddUIListener(EventId.AllianceCongratulationCount, self.UpDateCount)
  self:AddUIListener(EventId.AllianceCongratulationBtnState, self.UpdateBtnLock)
end

function LWAllianceCongratulationPopView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceCongratulationListNew, self.ShowNextCard)
  self:RemoveUIListener(EventId.AllianceCongratulationCount, self.UpDateCount)
  self:RemoveUIListener(EventId.AllianceCongratulationBtnState, self.UpdateBtnLock)
  base.OnRemoveListener(self)
end

function LWAllianceCongratulationPopView:UpdateBtnLock()
  if self and self.btnGoRunning then
    self.btnGoRunning = false
  end
end

function LWAllianceCongratulationPopView:OnBtnBgClick()
  self:CloseWindow()
end

function LWAllianceCongratulationPopView:OnBtnCloseClick()
  self:CloseWindow()
end

function LWAllianceCongratulationPopView:CloseWindow()
  if not self.closing then
    self.closing = true
    self.animator:Play("V_ui_LWAllianceCongratulationPop_normal_out", 0, 0)
    if self.delay then
      self.delay:Stop()
      self.delay = nil
    end
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      self.ctrl:CloseSelf()
    end, 0.3)
  end
end

function LWAllianceCongratulationPopView:OnBtnGoClick()
  if self.btnGoRunning then
    return
  end
  if not table.IsNullOrEmpty(self.list) and self.list[1] then
    self.btnDownState = true
    local targetUid = self.list[1].uid
    local configId = self.list[1].configId
    self.btnGoRunning = true
    DataCenter.AllianceCongratulationDataManager:SendAllianceCongratulationThumbsUp(targetUid, configId)
  end
  self.cardFront:SetBubble()
end

function LWAllianceCongratulationPopView:InitData()
  self.nextDay = UITimeManager:GetInstance():GetTomorrowZero()
  DataCenter.AllianceCongratulationDataManager:SetFlyCenter(self.compCenter.transform.position)
  self.cardFront = self.compCardA
  self.cardBack = self.compCardB
  self.moveDuration = 0.5
end

function LWAllianceCongratulationPopView:UpDateCount()
  self.remainCount = DataCenter.AllianceCongratulationDataManager:GetRemainRewardCount()
  if self.remainCount > 0 then
    self.textTips:SetLocalText("alliance_congratulation_desc_reward", self.remainCount)
  end
end

function LWAllianceCongratulationPopView:PlaySound(id, time)
  if self.delaySound then
    self.delaySound:Stop()
    self.delaySound = nil
  end
  self.delaySound = TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.AllianceStarManager:PlaySfx(id)
  end, time)
end

function LWAllianceCongratulationPopView:ShowNextCard()
  if self.closing then
    return
  end
  if self.btnDownState then
    self.btnDownState = false
    self.list = DataCenter.AllianceCongratulationDataManager:GetAllianceCongratulationList()
    if self.delaySound2 then
      self.delaySound2:Stop()
      self.delaySound2 = nil
    end
    self.delaySound2 = TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.AllianceStarManager:PlaySfx(91029)
    end, 0.12)
    if not table.IsNullOrEmpty(self.list) then
      local count = table.length(self.list)
      self.textNum:SetText(count)
      if 2 <= count then
        self.cardBack.gameObject:SetActive(true)
        self.cardBack:UpdateData(self.list[2], false)
        self.animator:Play("V_ui_LWAllianceCongratulationPop_switch", 0, 0)
        self:PlaySound(91030, 0.83)
        if self.delay then
          self.delay:Stop()
          self.delay = nil
        end
        self.delay = TimerManager:GetInstance():DelayInvoke(function()
          if self and self.cardFront and self.list and self.list[1] then
            self.cardFront:UpdateData(self.list[1], true)
          end
          self.btnGoRunning = false
        end, delayTime)
      elseif count == 1 then
        self.animator:Play("V_ui_LWAllianceCongratulationPop_switch_last", 0, 0)
        self:PlaySound(91030, 0.83)
        if self.delay then
          self.delay:Stop()
          self.delay = nil
        end
        self.delay = TimerManager:GetInstance():DelayInvoke(function()
          if self and self.cardFront and self.list and self.list[1] then
            self.cardFront:UpdateData(self.list[1], true)
          end
          self.btnGoRunning = false
        end, delayTime)
      end
    else
      self.animator:Play("V_ui_LWAllianceCongratulationPop_switch_last_out", 0, 0)
      if self.delay then
        self.delay:Stop()
        self.delay = nil
      end
      self.delay = TimerManager:GetInstance():DelayInvoke(function()
        self.btnGoRunning = false
        self.ctrl:CloseSelf()
      end, delayTime)
      return
    end
  else
    self:RefreshCard()
  end
end

function LWAllianceCongratulationPopView:RefreshCard(openWindows)
  self.list = DataCenter.AllianceCongratulationDataManager:GetAllianceCongratulationList()
  if not table.IsNullOrEmpty(self.list) then
    if openWindows then
      DataCenter.AllianceStarManager:PlaySfx(91028)
    end
    local count = table.length(self.list)
    self.textNum:SetText(count)
    self.cardFront:UpdateData(self.list[1], true)
    self.cardBack:UpdateData(self.list[2], false)
    self:UpDateCount()
  else
    if openWindows then
      EventManager:GetInstance():Broadcast(EventId.AllianceCongratulationListNew)
      UIUtil.ShowTipsId("alliance_congratulation_tips_expired")
    end
    self.ctrl:CloseSelf()
  end
end

function LWAllianceCongratulationPopView:Update1000MS()
  if self.remainCount and self.remainCount <= 0 and self.nextDay then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.nextDay - curTime
    if 0 < leftTime then
      local time = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.textTips:SetLocalText("alliance_congratulation_desc_rewardRefresh", time)
    else
      self.nextDay = UITimeManager:GetInstance():GetTomorrowZero()
      DataCenter.AllianceCongratulationDataManager:UpdateCrossDayRewardCount()
      self:UpDateCount()
    end
  end
end

return LWAllianceCongratulationPopView
