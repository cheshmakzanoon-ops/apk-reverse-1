local base = UIBaseContainer
local UIChatAISettingHeader = BaseClass("UIChatAISettingHeader", base)

function UIChatAISettingHeader:OnCreate(title)
  base.OnCreate(self)
  self._titleText = self:AddComponent(UIText, "Head/title")
  self:SetData(title)
end

function UIChatAISettingHeader:SetData(title)
  self._titleText:SetText(title)
end

function UIChatAISettingHeader:OnEnable()
  base.OnEnable(self)
end

function UIChatAISettingHeader:OnDisable()
  base.OnDisable(self)
end

function UIChatAISettingHeader:OnDestroy()
  self._titleText = nil
  base.OnDestroy(self)
end

return UIChatAISettingHeader
