local UILWArmedUpgradeBannerWarning_JPView = BaseClass("UILWArmedUpgradeBannerWarning_JPView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SpineAnimName = "jichemonika_ruchang"
local effectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/Eff_ui_icon_trail.prefab"

function UILWArmedUpgradeBannerWarning_JPView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWArmedUpgradeBannerWarning_JPView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWArmedUpgradeBannerWarning_JPView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBg = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBg:SetOnClick(function()
    self:OnBtnBgClick()
  end)
  self.compNode = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.textTip1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTip2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compSkeletonGraphic = self.viewSkin:AddComponent(self, UISpine, 5)
  self.textTip1:SetText(Localization:GetString("armed_upgrade_limit5_3"))
  self.textTip2:SetText(Localization:GetString("armed_upgrade_limit10_4"))
  self.compSkeletonGraphic:SetCompleteEvent(BindCallback(self.OnSkeletonGraphicComplete, self))
  DataCenter.LWSoundManager:PlaySound(80068, false)
end

function UILWArmedUpgradeBannerWarning_JPView:ComponentDestroy()
  self.viewSkin = nil
  self.btnBg = nil
  self.compNode = nil
  self.textTip1 = nil
  self.textTip2 = nil
  self.compSkeletonGraphic = nil
end

function UILWArmedUpgradeBannerWarning_JPView:DataDefine()
end

function UILWArmedUpgradeBannerWarning_JPView:DataDestroy()
  self:ClearDelay()
end

function UILWArmedUpgradeBannerWarning_JPView:OnAddListener()
  base.OnAddListener(self)
end

function UILWArmedUpgradeBannerWarning_JPView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWArmedUpgradeBannerWarning_JPView:ReInit()
  self:ClearDelay()
  local param = self:GetUserData()
  self.guide = param.guide or false
  self.click = param.click or false
  self.ctrl:SetUseESC(self.click)
  self:PlaySkeletonGraphicAnimation()
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self.delay = nil
    self:TryDoFly()
  end, 4)
end

function UILWArmedUpgradeBannerWarning_JPView:PlaySkeletonGraphicAnimation()
  if self.compSkeletonGraphic then
    self.compSkeletonGraphic:SetAnimation(0, SpineAnimName, false)
  end
end

function UILWArmedUpgradeBannerWarning_JPView:OnSkeletonGraphicComplete()
  self:ClearDelay()
  self:TryDoFly()
end

function UILWArmedUpgradeBannerWarning_JPView:TryDoFly()
  local startPos = self.compNode.transform.position
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWArmedUpgradeBannerWarningView_JP, {anim = false})
  if self.click then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.ArmedUpgradeMainUIBubblePreFly)
  local endPos
  local view = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
  if view then
    endPos = view.View:GetSavePos(UIMainSavePosType.SaveGirlWarning)
  end
  if endPos and startPos then
    DataCenter.LWSoundManager:PlaySound(62245, false)
    UIManager:GetInstance():EnableInteractionBlocker(2, 2.1)
    UIUtil.DoFlySimpleFunc(effectPath, startPos, endPos, 2, nil, function()
      EventManager:GetInstance():Broadcast(EventId.ArmedUpgradeMainUIRefresh)
      EventManager:GetInstance():Broadcast(EventId.ArmedUpgradeMainUIBubbleEffect)
      EventManager:GetInstance():Broadcast(EventId.MainUIBottomShow)
      if self.guide then
        UIManager:GetInstance():EnableInteractionBlocker(2, 1)
        TimerManager:GetInstance():DelayInvoke(function()
          GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILD_RADAR, true)
        end, 1)
      end
    end)
  end
end

function UILWArmedUpgradeBannerWarning_JPView:ClearDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function UILWArmedUpgradeBannerWarning_JPView:OnBtnBgClick()
  if not self.click then
    return
  end
  self.ctrl:CloseSelf()
end

return UILWArmedUpgradeBannerWarning_JPView
