local Season5DeclareCityHistoryTabItem = BaseClass("Season5DeclareCityHistoryTabItem", UIToggle)
local base = UIToggle
local Localization = CS.GameEntry.Localization

function Season5DeclareCityHistoryTabItem:OnCreate()
  base.OnCreate(self)
  self.txt1 = self:AddComponent(UIText, "ConditionDark")
  self.txt2 = self:AddComponent(UIText, "ConditionSelect/Condition")
end

function Season5DeclareCityHistoryTabItem:OnDestroy()
  base.OnDestroy(self)
end

function Season5DeclareCityHistoryTabItem:ReInit(tabIndex)
  self.txt1:SetLocalText("801425", tabIndex)
  self.txt2:SetLocalText("801425", tabIndex)
end

return Season5DeclareCityHistoryTabItem
