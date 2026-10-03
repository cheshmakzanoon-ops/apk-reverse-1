local base = UIBaseContainer
local UIPlayerLevelPackagePageRewardChangeBgComponent = BaseClass("UIPlayerLevelPackagePageRewardChangeBgComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIPlayerLevelPackagePageRewardChangeBgComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPlayerLevelPackagePageRewardChangeBgComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPlayerLevelPackagePageRewardChangeBgComponent:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.btnUIPlayerLevelPackagePageRewardChangeBg = self:AddComponent(UIButton, "")
  self.btnUIPlayerLevelPackagePageRewardChangeBg:SetOnClick(function()
    self:OnBtnUIPlayerLevelPackagePageRewardChangeBgClick()
  end)
end

function UIPlayerLevelPackagePageRewardChangeBgComponent:ComponentDestroy()
  self.animator = nil
  self.btnUIPlayerLevelPackagePageRewardChangeBg = nil
end

function UIPlayerLevelPackagePageRewardChangeBgComponent:DataDefine()
end

function UIPlayerLevelPackagePageRewardChangeBgComponent:DataDestroy()
end

function UIPlayerLevelPackagePageRewardChangeBgComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerLevelPackageEntranceHide, self.OnHideAnim)
  self:AddUIListener(EventId.PlayerLevelPackageEntranceShow, self.OnShowAnim)
end

function UIPlayerLevelPackagePageRewardChangeBgComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerLevelPackageEntranceHide, self.OnHideAnim)
  self:RemoveUIListener(EventId.PlayerLevelPackageEntranceShow, self.OnShowAnim)
  base.OnRemoveListener(self)
end

function UIPlayerLevelPackagePageRewardChangeBgComponent:ReInit(giftInfo)
  self.giftInfo = giftInfo
end

function UIPlayerLevelPackagePageRewardChangeBgComponent:OnBtnUIPlayerLevelPackagePageRewardChangeBgClick()
  if self.giftInfo == nil then
    return
  end
  local curTemplate = DataCenter.GiftPackageChangePreviewManager:GetRewardChangeShowDataByGiftInfo(self.giftInfo)
  if curTemplate ~= nil then
    EventManager:GetInstance():Broadcast(EventId.PlayerLevelPackageEntranceHide)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIPlayerPackageRewardChange, {anim = true}, self.giftInfo)
  end
end

function UIPlayerLevelPackagePageRewardChangeBgComponent:OnHideAnim()
  self.animator:Play("V_ui_RewardChangeBg_click")
end

function UIPlayerLevelPackagePageRewardChangeBgComponent:OnShowAnim()
  self.animator:Play("V_ui_RewardChangeBg_in")
end

return UIPlayerLevelPackagePageRewardChangeBgComponent
