local UILWSeasonIntroductionTab = BaseClass("UILWSeasonIntroductionTab", UIToggle)
local base = UIToggle

function UILWSeasonIntroductionTab:OnCreate()
  base.OnCreate(self)
  self.condition_dark = self:AddComponent(UITextMeshProUGUIEx, "ConditionDark")
  self.condition = self:AddComponent(UITextMeshProUGUIEx, "ConditionSelect/Condition")
end

function UILWSeasonIntroductionTab:OnDestroy()
  self.condition_dark = nil
  self.condition = nil
  base.OnDestroy(self)
end

function UILWSeasonIntroductionTab:ReInit(weekIndex, tabText)
  if not string.IsNullOrEmpty(tabText) then
    self.condition:SetText(tabText)
    self.condition_dark:SetText(tabText)
  else
    self.condition:SetLocalText("801425", toInt(weekIndex))
    self.condition_dark:SetLocalText("801425", toInt(weekIndex))
  end
end

return UILWSeasonIntroductionTab
