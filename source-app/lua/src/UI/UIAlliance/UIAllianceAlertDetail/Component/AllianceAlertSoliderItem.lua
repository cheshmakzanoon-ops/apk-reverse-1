local AllianceWarPlayerSoliderItem = BaseClass("AllianceWarPlayerSoliderItem", UIBaseContainer)
local base = UIBaseContainer
local icon_path = "Icon"
local lv_path = "Icon/lv"
local count_path = "count"

local function OnCreate(self)
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.lv = self:AddComponent(UIText, lv_path)
  self.count = self:AddComponent(UIText, count_path)
  self.data = nil
end

local function OnDestroy(self)
  self.icon = nil
  self.count = nil
  self.data = nil
  base.OnDestroy(self)
end

local function SetData(self, armsId, count)
  local data = DataCenter.ArmyTemplateManager:GetArmyTemplate(tonumber(armsId))
  self.icon:LoadSprite(string.format(LoadPath.SoldierIcons, data.icon))
  self.count:SetText("x " .. string.GetFormattedSeperatorNum(count))
  self.lv:SetText(data.level)
end

AllianceWarPlayerSoliderItem.OnCreate = OnCreate
AllianceWarPlayerSoliderItem.OnDestroy = OnDestroy
AllianceWarPlayerSoliderItem.SetData = SetData
return AllianceWarPlayerSoliderItem
