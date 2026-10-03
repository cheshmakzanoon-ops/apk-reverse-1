local BattleAbbr = BaseClass("BattleAbbr", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local abbr_path = "text"
local icon_path = "icon"

local function OnCreate(self)
  base.OnCreate(self)
  self.abbr_txt = self:AddComponent(UIText, abbr_path)
  self.icon = self:AddComponent(UIImage, icon_path)
end

local function SetText(self, abbr, icon)
  self.abbr_txt:SetText(abbr)
end

BattleAbbr.OnCreate = OnCreate
BattleAbbr.SetText = SetText
return BattleAbbr
