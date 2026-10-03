local base = UIBaseContainer
local UIPlayerLevelPackagePageRewardChangeEntranceComponent = BaseClass("UIPlayerLevelPackagePageRewardChangeEntranceComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIPlayerLevelPackagePageRewardChangeEntranceComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPlayerLevelPackagePageRewardChangeEntranceComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPlayerLevelPackagePageRewardChangeEntranceComponent:ComponentDefine()
  self.btnUIPlayerLevelPackagePageRewardChangeEntrance = self:AddComponent(UIButton, "")
  self.btnUIPlayerLevelPackagePageRewardChangeEntrance:SetOnClick(function()
    self:OnBtnUIPlayerLevelPackagePageRewardChangeEntranceClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "TitleText")
  self.animator = self:AddComponent(UIAnimator, "")
end

function UIPlayerLevelPackagePageRewardChangeEntranceComponent:ComponentDestroy()
  self.btnUIPlayerLevelPackagePageRewardChangeEntrance = nil
  self.textTitle = nil
  self.animator = nil
end

function UIPlayerLevelPackagePageRewardChangeEntranceComponent:DataDefine()
end

function UIPlayerLevelPackagePageRewardChangeEntranceComponent:DataDestroy()
  self:ClearDelayAnimTimer()
end

function UIPlayerLevelPackagePageRewardChangeEntranceComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerLevelPackageEntranceHide, self.OnHideAnim)
  self:AddUIListener(EventId.PlayerLevelPackageEntranceShow, self.OnShowAnim)
end

function UIPlayerLevelPackagePageRewardChangeEntranceComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerLevelPackageEntranceHide, self.OnHideAnim)
  self:RemoveUIListener(EventId.PlayerLevelPackageEntranceShow, self.OnShowAnim)
  base.OnRemoveListener(self)
end

function UIPlayerLevelPackagePageRewardChangeEntranceComponent:ReInit(giftInfo)
  self.giftInfo = giftInfo
  if self.giftInfo == nil then
    return
  end
  local curTemplate = DataCenter.GiftPackageChangePreviewManager:GetRewardChangeShowDataByGiftInfo(self.giftInfo)
  if curTemplate ~= nil then
    local text = Localization:GetString(curTemplate.entry_text)
    self.textTitle:SetText(text)
  end
  local ret, time = self.animator:PlayAnimationReturnTime("V_ui_RewardChangeEntrance_in")
  if ret then
    self:ClearDelayAnimTimer()
    self.delayAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.animator:Play("V_ui_RewardChangeEntrance_idle")
    end, time)
  end
end

function UIPlayerLevelPackagePageRewardChangeEntranceComponent:OnBtnUIPlayerLevelPackagePageRewardChangeEntranceClick()
  if self.giftInfo == nil then
    return
  end
  local curTemplate = DataCenter.GiftPackageChangePreviewManager:GetRewardChangeShowDataByGiftInfo(self.giftInfo)
  if curTemplate ~= nil then
    EventManager:GetInstance():Broadcast(EventId.PlayerLevelPackageEntranceHide)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIPlayerPackageRewardChange, {anim = true}, self.giftInfo)
  end
end

function UIPlayerLevelPackagePageRewardChangeEntranceComponent:OnHideAnim()
  self:ClearDelayAnimTimer()
  self.animator:Play("V_ui_RewardChangeEntrance_click")
end

function UIPlayerLevelPackagePageRewardChangeEntranceComponent:OnShowAnim()
  local ret, time = self.animator:PlayAnimationReturnTime("V_ui_RewardChangeEntrance_in")
  if ret then
    self:ClearDelayAnimTimer()
    self.delayAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.animator:Play("V_ui_RewardChangeEntrance_idle")
    end, time)
  end
end

function UIPlayerLevelPackagePageRewardChangeEntranceComponent:ClearDelayAnimTimer()
  if self.delayAnimTimer ~= nil then
    self.delayAnimTimer:Stop()
    self.delayAnimTimer = nil
  end
end

return UIPlayerLevelPackagePageRewardChangeEntranceComponent
