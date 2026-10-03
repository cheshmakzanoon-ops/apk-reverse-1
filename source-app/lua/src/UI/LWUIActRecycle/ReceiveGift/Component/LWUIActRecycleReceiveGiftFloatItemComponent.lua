local base = UIBaseContainer
local LWUIActRecycleReceiveGiftFloatItemComponent = BaseClass("LWUIActRecycleReceiveGiftFloatItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

function LWUIActRecycleReceiveGiftFloatItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActRecycleReceiveGiftFloatItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleReceiveGiftFloatItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
end

function LWUIActRecycleReceiveGiftFloatItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUIPlayerHead = nil
end

function LWUIActRecycleReceiveGiftFloatItemComponent:DataDefine()
end

function LWUIActRecycleReceiveGiftFloatItemComponent:DataDestroy()
end

function LWUIActRecycleReceiveGiftFloatItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActRecycleReceiveGiftFloatItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActRecycleReceiveGiftFloatItemComponent:SetData(...)
  self.compUIPlayerHead:SetData(...)
end

return LWUIActRecycleReceiveGiftFloatItemComponent
