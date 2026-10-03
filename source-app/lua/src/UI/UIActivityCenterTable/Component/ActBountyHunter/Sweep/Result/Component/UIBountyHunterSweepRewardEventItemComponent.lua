local base = UIBaseContainer
local UIBountyHunterSweepRewardEventItemComponent = BaseClass("UIBountyHunterSweepRewardEventItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBountyHunterSweepRewardEventItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBountyHunterSweepRewardEventItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBountyHunterSweepRewardEventItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 3)
  self.btnClickArea = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClickArea:SetOnClick(function()
    self:OnBtnClickAreaClick()
  end)
  self.effect = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.canvasGroup = self.viewSkin:AddComponent(self, UICanvasGroup, 6)
end

function UIBountyHunterSweepRewardEventItemComponent:ComponentDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.viewSkin = nil
  self.imgIcon = nil
  self.textNum = nil
  self.imgBg = nil
  self.btnClickArea = nil
  self.effect = nil
  self.canvasGroup = nil
end

function UIBountyHunterSweepRewardEventItemComponent:DataDefine()
end

function UIBountyHunterSweepRewardEventItemComponent:DataDestroy()
end

function UIBountyHunterSweepRewardEventItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIBountyHunterSweepRewardEventItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBountyHunterSweepRewardEventItemComponent:ReInitKill(data)
  self.canvasGroup:SetAlpha(0)
  local lineData = LocalController:instance():tryGetLine(TableName.Bounty_Monster, data.id)
  if lineData then
    self.imgIcon:LoadSpriteAuto(lineData.head_icon)
    self.imgIcon:SetNativeSize()
    self.imgBg:LoadSpriteAuto(lineData.head_bg)
    self.title = lineData.name
    self.desc = lineData.desc
  end
  self.textNum:SetText(data.count)
end

function UIBountyHunterSweepRewardEventItemComponent:ReInitFound(data)
  self.canvasGroup:SetAlpha(0)
  local lineData = LocalController:instance():tryGetLine(TableName.Bounty_Hunter_Event, data.id)
  if lineData then
    self.imgIcon:LoadSpriteAuto(lineData.small_pic)
    self.imgIcon:SetSizeDeltaXY(150, 150)
    self.imgBg:LoadSpriteAuto(lineData.pic_di)
    self.title = lineData.name
    self.desc = lineData.desc
  end
  self.textNum:SetText(data.count)
end

function UIBountyHunterSweepRewardEventItemComponent:OnBtnClickAreaClick()
  if self.title == nil or self.desc == nil then
    return
  end
  local param = {}
  param.type = "nameDesc"
  param.title = self.title
  param.desc = self.desc
  param.alignObject = self.btnClickArea
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function UIBountyHunterSweepRewardEventItemComponent:ShowAnim(delay)
  if delay == nil or delay <= 0 then
    self.canvasGroup:SetAlpha(1)
    self.effect:SetActive(false)
    self.effect:SetActive(true)
    return
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.canvasGroup:SetAlpha(1)
    self.effect:SetActive(false)
    self.effect:SetActive(true)
  end, delay)
end

return UIBountyHunterSweepRewardEventItemComponent
