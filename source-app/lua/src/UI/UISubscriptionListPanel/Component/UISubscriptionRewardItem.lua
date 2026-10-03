local UISubscriptionRewardItem = BaseClass("UISubscriptionRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function ComponentDefine(self)
  self.resItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.locked = self:AddComponent(UIBaseContainer, "Locked")
  self.LockIcon = self:AddComponent(UIImage, "Locked/LockIcon")
end

local function ComponentDestroy(self)
  self.resItem = nil
  self.locked = nil
  self.LockIcon = nil
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ReInit(self, param)
  self.resItem:ReInit(param)
end

local function SetLocked(self, locked)
  self.locked:SetActive(locked)
  self.lockedState = locked
end

UISubscriptionRewardItem.ComponentDefine = ComponentDefine
UISubscriptionRewardItem.ComponentDestroy = ComponentDestroy
UISubscriptionRewardItem.OnCreate = OnCreate
UISubscriptionRewardItem.OnDestroy = OnDestroy
UISubscriptionRewardItem.ReInit = ReInit
UISubscriptionRewardItem.SetLocked = SetLocked
return UISubscriptionRewardItem
