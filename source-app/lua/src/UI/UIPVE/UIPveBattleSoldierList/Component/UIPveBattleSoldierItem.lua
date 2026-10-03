local UIPveBattleSoldierItem = BaseClass("UIPveBattleSoldierItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local soldier_icon_path = "soldierIcon"
local soldier_num_path = "soldierNumTxt"
local level_txt_path = "levelTxt"
local soldier_name_path = "soldierName"

local function OnCreate(self)
  base.OnCreate(self)
  self.soldier_icon = self:AddComponent(UIImage, soldier_icon_path)
  self.soldier_num = self:AddComponent(UIText, soldier_num_path)
  self.level_txt = self:AddComponent(UIText, level_txt_path)
  self.soldier_name = self:AddComponent(UIText, soldier_name_path)
end

local function SetItemShow(self, data)
  self.data = data
  self.soldier_icon:LoadSprite(self.data.icon)
  self.soldier_num:SetText(string.GetFormattedSeperatorNum(math.floor(self.data.count)))
  self.level_txt:SetText(self.data.level)
  self.soldier_name:SetText(Localization:GetString(self.data.name))
end

UIPveBattleSoldierItem.OnCreate = OnCreate
UIPveBattleSoldierItem.SetItemShow = SetItemShow
return UIPveBattleSoldierItem
