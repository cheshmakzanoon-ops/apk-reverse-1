local LWUITimelineQTEView = BaseClass("LWUITimelineQTEView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function LWUITimelineQTEView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWUITimelineQTEView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUITimelineQTEView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnQte = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnQte:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(91039, false)
    PostEventLog.Track(PostEventLog.Defines.ArmedUpgradeQTEClick, {})
    self:OnBtnQteClick()
  end)
  self.btnBlack = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnBlack:SetOnClick(function()
    self:OnBtnBlackClick()
  end)
  self.imgProgress = self.viewSkin:AddComponent(self, UIImage, 3)
  self.btnQte:SetActive(false)
end

function LWUITimelineQTEView:ComponentDestroy()
  self.viewSkin = nil
  self.btnQte = nil
  self.btnBlack = nil
  self.imgProgress = nil
end

function LWUITimelineQTEView:DataDefine()
  self.param = self:GetUserData()
  if self.param == nil then
    self.ctrl:CloseSelf()
    return
  end
  if self.param.qte1 then
    self.qte1Duration = self.param.duration or 1
    self.imgProgress:SetFillAmount(1)
    self.btnQte:SetActive(true)
    self.progressTween = self.imgProgress.unity_image:DOFillAmount(0, self.qte1Duration)
    self:AddQTE1Timer()
  end
end

function LWUITimelineQTEView:DataDestroy()
  self:RemoveQTE1Timer()
  if self.progressTween then
    self.progressTween:Kill()
    self.progressTween = nil
  end
end

function LWUITimelineQTEView:ReInit()
end

function LWUITimelineQTEView:OnAddListener()
  base.OnAddListener(self)
end

function LWUITimelineQTEView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUITimelineQTEView:OnBtnQteClick()
  DataCenter.TimelineInteractionManager:OnQTE1Done()
end

function LWUITimelineQTEView:OnBtnBlackClick()
end

function LWUITimelineQTEView:AddQTE1Timer()
  if self.qte1Timer == nil then
    self.qte1Timer = TimerManager:GetInstance():DelayInvoke(function()
      self.qte1Timer = nil
      if self.imgProgress then
        self:OnBtnQteClick()
      end
    end, self.qte1Duration)
  end
end

function LWUITimelineQTEView:RemoveQTE1Timer()
  if self.qte1Timer then
    self.qte1Timer:Stop()
    self.qte1Timer = nil
  end
end

return LWUITimelineQTEView
