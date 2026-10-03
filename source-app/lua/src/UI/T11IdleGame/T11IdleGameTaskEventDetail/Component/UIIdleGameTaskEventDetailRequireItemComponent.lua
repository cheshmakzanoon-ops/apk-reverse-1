local base = UIBaseContainer
local UIIdleGameTaskEventDetailRequireItemComponent = BaseClass("UIIdleGameTaskEventDetailRequireItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIIdleGameTaskEventDetailRequireItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIIdleGameTaskEventDetailRequireItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIIdleGameTaskEventDetailRequireItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
end

function UIIdleGameTaskEventDetailRequireItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUICommonResItem = nil
  self.textNum = nil
end

function UIIdleGameTaskEventDetailRequireItemComponent:DataDefine()
end

function UIIdleGameTaskEventDetailRequireItemComponent:DataDestroy()
end

function UIIdleGameTaskEventDetailRequireItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIIdleGameTaskEventDetailRequireItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIIdleGameTaskEventDetailRequireItemComponent:ReInit(data, showStr)
  self.compUICommonResItem:ReInit(data)
  self.textNum:SetText(showStr)
end

return UIIdleGameTaskEventDetailRequireItemComponent
