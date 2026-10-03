local base = UIBaseContainer
local T11UnlockableItemComponent = BaseClass("T11UnlockableItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local T11MiddleUnlockableComponent = require("UI.T11MainView.Component.State.Component.T11MiddleUnlockableComponent")
local T11BottomUnlockableComponent = require("UI.T11MainView.Component.State.Component.T11BottomUnlockableComponent")
local t11_middle_unlockable_path = "T11MiddleUnlockable"
local t11_bottom_unlockable_path = "T11BottomUnlockable"

function T11UnlockableItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11UnlockableItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11UnlockableItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compT11UnlockableItem = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.middleCpt = self:AddComponent(T11MiddleUnlockableComponent, t11_middle_unlockable_path)
  self.breakableCpt = self:AddComponent(T11BottomUnlockableComponent, t11_bottom_unlockable_path)
end

function T11UnlockableItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compT11UnlockableItem = nil
end

function T11UnlockableItemComponent:DataDefine()
end

function T11UnlockableItemComponent:DataDestroy()
end

function T11UnlockableItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11UnlockableItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11UnlockableItemComponent:RefreshView()
  self.middleCpt:RefreshView()
  self.breakableCpt:RefreshView()
end

return T11UnlockableItemComponent
