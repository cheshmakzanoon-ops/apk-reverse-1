local base = UIBaseContainer
local UILWAlSwitchJobFlagItem = BaseClass("UILWAlSwitchJobFlagItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWAlSwitchJobFlagItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlSwitchJobFlagItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlSwitchJobFlagItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgFlagIcon = self.viewSkin:AddComponent(self, UIImage, 1)
end

function UILWAlSwitchJobFlagItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgFlagIcon = nil
end

function UILWAlSwitchJobFlagItem:DataDefine()
end

function UILWAlSwitchJobFlagItem:DataDestroy()
end

function UILWAlSwitchJobFlagItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlSwitchJobFlagItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UILWAlSwitchJobFlagItem
