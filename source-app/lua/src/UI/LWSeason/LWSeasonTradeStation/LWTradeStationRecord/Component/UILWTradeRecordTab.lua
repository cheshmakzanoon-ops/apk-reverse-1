local UILWTradeRecordTab = BaseClass("UILWTradeRecordTab", UIToggle)
local base = UIToggle

function UILWTradeRecordTab:OnCreate()
  base.OnCreate(self)
  self.condition_dark = self:AddComponent(UITextMeshProUGUIEx, "ConditionDark")
  self.condition = self:AddComponent(UITextMeshProUGUIEx, "ConditionSelect/Condition")
end

function UILWTradeRecordTab:OnDestroy()
  self.condition_dark = nil
  self.condition = nil
  base.OnDestroy(self)
end

function UILWTradeRecordTab:ReInit(index, tabName)
  self.condition:SetText(tabName)
  self.condition_dark:SetText(tabName)
end

return UILWTradeRecordTab
