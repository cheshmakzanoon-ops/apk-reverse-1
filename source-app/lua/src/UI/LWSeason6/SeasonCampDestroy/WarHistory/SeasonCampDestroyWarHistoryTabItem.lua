local SeasonCampDestroyWarHistoryTabItem = BaseClass("SeasonCampDestroyWarHistoryTabItem", UIToggle)
local base = UIToggle
local Localization = CS.GameEntry.Localization

function SeasonCampDestroyWarHistoryTabItem:OnCreate()
  base.OnCreate(self)
  self.txt1 = self:AddComponent(UIText, "ConditionDark")
  self.txt2 = self:AddComponent(UIText, "ConditionSelect/Condition")
end

function SeasonCampDestroyWarHistoryTabItem:OnDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyWarHistoryTabItem:ReInit(tabIndex)
  self.txt1:SetLocalText("801425", tabIndex)
  self.txt2:SetLocalText("801425", tabIndex)
end

return SeasonCampDestroyWarHistoryTabItem
