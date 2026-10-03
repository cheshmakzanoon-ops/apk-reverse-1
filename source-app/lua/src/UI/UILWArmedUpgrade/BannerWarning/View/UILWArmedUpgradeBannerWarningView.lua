local UILWArmedUpgradeBannerWarningView = BaseClass("UILWArmedUpgradeBannerWarningView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local effectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/Eff_ui_icon_trail.prefab"
local IN_D = "in_d"
local IDLE_D = "idle_d"
local IN_M = "in_m"
local IDLE_M = "idle_m"
local IN_U = "in_u"
local IDLE_U = "idle_u"
local IN_U_HF = "in_u_hf"
local IDLE_U_HF = "idle_u_hf"

function UILWArmedUpgradeBannerWarningView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWArmedUpgradeBannerWarningView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWArmedUpgradeBannerWarningView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compNode = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.btnBg = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnBg:SetOnClick(function()
    self:OnBtnBgClick()
  end)
  self.textTip1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTip2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compSkeletonGraphicD = self.viewSkin:AddComponent(self, UISpine, 5)
  self.compSkeletonGraphicM = self.viewSkin:AddComponent(self, UISpine, 6)
  self.compSkeletonGraphicU = self.viewSkin:AddComponent(self, UISpine, 7)
  self.compSkeletonGraphicHF = self.viewSkin:AddComponent(self, UISpine, 8)
  self.textTip1:SetText(Localization:GetString("armed_upgrade_limit5_3"))
  self.textTip2:SetText(Localization:GetString("armed_upgrade_limit10_4"))
  self.compSkeletonGraphicD:SetCompleteEvent(BindCallback(self.OnSkeletonGraphicDComplete, self))
  self.compSkeletonGraphicM:SetCompleteEvent(BindCallback(self.OnSkeletonGraphicMComplete, self))
  self.compSkeletonGraphicU:SetCompleteEvent(BindCallback(self.OnSkeletonGraphicUComplete, self))
  self.compSkeletonGraphicHF:SetCompleteEvent(BindCallback(self.OnSkeletonGraphicHFComplete, self))
  DataCenter.LWSoundManager:PlaySound(62298, false)
end

function UILWArmedUpgradeBannerWarningView:ComponentDestroy()
  self.viewSkin = nil
  self.compNode = nil
  self.btnBg = nil
  self.textTip1 = nil
  self.textTip2 = nil
  self.compSkeletonGraphicD = nil
  self.compSkeletonGraphicM = nil
  self.compSkeletonGraphicU = nil
  self.compSkeletonGraphicHF = nil
end

function UILWArmedUpgradeBannerWarningView:DataDefine()
end

function UILWArmedUpgradeBannerWarningView:DataDestroy()
  self:ClearDelay()
end

function UILWArmedUpgradeBannerWarningView:OnAddListener()
  base.OnAddListener(self)
end

function UILWArmedUpgradeBannerWarningView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWArmedUpgradeBannerWarningView:ReInit()
  self:ClearDelay()
  local param = self:GetUserData()
  local guide = param.guide or false
  self.click = param.click or false
  self.ctrl:SetUseESC(self.click)
  local startPos = self.compNode.transform.position
  self:PlaySkeletonGraphicAnimation()
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
    if self.click then
      return
    end
    EventManager:GetInstance():Broadcast(EventId.ArmedUpgradeMainUIBubblePreFly)
    local endPos
    local view = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    if view then
      endPos = view.View:GetSavePos(UIMainSavePosType.SaveGirlWarning)
    end
    if endPos then
      DataCenter.LWSoundManager:PlaySound(62245, false)
      UIManager:GetInstance():EnableInteractionBlocker(2, 2.1)
      if guide then
        DataCenter.LWCivilizationSparkExtend:UILWArmedUpgradeBannerWarningView_moveEndGuideStart()
      end
      UIUtil.DoFlySimpleFunc(effectPath, startPos, endPos, 2, nil, function()
        EventManager:GetInstance():Broadcast(EventId.ArmedUpgradeMainUIRefresh)
        EventManager:GetInstance():Broadcast(EventId.ArmedUpgradeMainUIBubbleEffect)
        EventManager:GetInstance():Broadcast(EventId.MainUIBottomShow)
        if guide then
          UIManager:GetInstance():EnableInteractionBlocker(2, 1)
          TimerManager:GetInstance():DelayInvoke(function()
            DataCenter.LWCivilizationSparkExtend:UILWArmedUpgradeBannerWarningView_moveEndGuideEnd()
          end, 1)
        end
      end)
    end
  end, 3)
end

function UILWArmedUpgradeBannerWarningView:PlaySkeletonGraphicAnimation()
  if self.compSkeletonGraphicD then
    self.compSkeletonGraphicD:SetAnimation(0, IN_D, false)
  end
  if self.compSkeletonGraphicM then
    self.compSkeletonGraphicM:SetAnimation(0, IN_M, false)
  end
  if self.compSkeletonGraphicU then
    self.compSkeletonGraphicU:SetAnimation(0, IN_U, false)
  end
  if self.compSkeletonGraphicHF then
    self.compSkeletonGraphicHF:SetAnimation(0, IN_U_HF, false)
  end
end

function UILWArmedUpgradeBannerWarningView:OnSkeletonGraphicDComplete()
  if self.compSkeletonGraphicD then
    self.compSkeletonGraphicD:SetAnimation(0, IDLE_D, true)
  end
end

function UILWArmedUpgradeBannerWarningView:OnSkeletonGraphicMComplete()
  if self.compSkeletonGraphicM then
    self.compSkeletonGraphicM:SetAnimation(0, IDLE_M, true)
  end
end

function UILWArmedUpgradeBannerWarningView:OnSkeletonGraphicUComplete()
  if self.compSkeletonGraphicU then
    self.compSkeletonGraphicU:SetAnimation(0, IDLE_U, true)
  end
end

function UILWArmedUpgradeBannerWarningView:OnSkeletonGraphicHFComplete()
  if self.compSkeletonGraphicHF then
    self.compSkeletonGraphicHF:SetAnimation(0, IDLE_U_HF, true)
  end
end

function UILWArmedUpgradeBannerWarningView:ClearDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function UILWArmedUpgradeBannerWarningView:OnBtnBgClick()
  if not self.click then
    return
  end
  self.ctrl:CloseSelf()
end

return UILWArmedUpgradeBannerWarningView
