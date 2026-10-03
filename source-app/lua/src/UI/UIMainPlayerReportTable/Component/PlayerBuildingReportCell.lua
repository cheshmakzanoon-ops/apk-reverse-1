local PlayerBuildingReportCell = BaseClass("PlayerBuildingReportCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rank_path = "Obj/TxtRank"
local name_path = "Obj/Text"
local num_path = "Obj/Text1"
local maintenance_path = "Obj/Text2"
local efficiency_path = "Obj/Text3"
local damage_path = "Obj/Text4"
local repair_path = "Obj/Text5"

local function OnCreate(self)
  base.OnCreate(self)
  self.name = self:AddComponent(UIText, name_path)
  self.rank = self:AddComponent(UIText, rank_path)
  self.num = self:AddComponent(UIText, num_path)
  self.maintenance = self:AddComponent(UIText, maintenance_path)
  self.efficiency = self:AddComponent(UIText, efficiency_path)
  self.damage = self:AddComponent(UIText, damage_path)
  self.repair = self:AddComponent(UIText, repair_path)
end

local function SetItemShow(self, itemData)
  self.rank:SetText(itemData.rank)
  self.name:SetLocalText(itemData.name)
  self.num:SetText(itemData.num)
  self.maintenance:SetText(itemData.maintenance)
  self.efficiency:SetText(itemData.efficiency)
  self.damage:SetText(itemData.damage)
  self.repair:SetText(itemData.repair)
end

PlayerBuildingReportCell.OnCreate = OnCreate
PlayerBuildingReportCell.SetItemShow = SetItemShow
return PlayerBuildingReportCell
