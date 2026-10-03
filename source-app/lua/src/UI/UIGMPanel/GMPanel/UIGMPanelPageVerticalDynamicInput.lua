local base = UIAsyncContainer
local UIGMPanelPageVerticalDynamicInput = BaseClass("UIGMPanelPageVerticalDynamicInput", base)
local Localization = CS.GameEntry.Localization

function UIGMPanelPageVerticalDynamicInput:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGMPanelPageVerticalDynamicInput:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGMPanelPageVerticalDynamicInput:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.inputField = self.viewSkin:AddComponent(self, UIInput, 1)
  self.textPlaceholder = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.inputField:SetOnEndEdit(function(val)
    self:OnEndEdit(val)
  end)
end

function UIGMPanelPageVerticalDynamicInput:ComponentDestroy()
  self.viewSkin = nil
  self.inputField = nil
  self.textPlaceholder = nil
  self.text = nil
end

function UIGMPanelPageVerticalDynamicInput:DataDefine()
end

function UIGMPanelPageVerticalDynamicInput:DataDestroy()
end

function UIGMPanelPageVerticalDynamicInput:OnAddListener()
  base.OnAddListener(self)
end

function UIGMPanelPageVerticalDynamicInput:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGMPanelPageVerticalDynamicInput:ReInit(data, parentItem)
  self.data = data
  self.parentItem = parentItem
  self.min = self.data.min or 0
  self.max = self.data.max or 100
  local defaultVal = self.data.get()
  if data.contentType then
    self.inputField:SetContentType(data.contentType)
  end
  self.inputField:SetText(defaultVal)
end

function UIGMPanelPageVerticalDynamicInput:OnEndEdit(val)
  if self.data.contentType == 2 or self.data.contentType == 3 then
    val = Mathf.Clamp(tonumber(val) or 0, self.min, self.max)
  end
  self.inputField:SetText(val)
  self.data.set(val)
end

function UIGMPanelPageVerticalDynamicInput:RefreshSkin(skin)
end

return UIGMPanelPageVerticalDynamicInput
