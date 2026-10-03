local PlayerResourceReportCell = BaseClass("PlayerResourceReportCell", UIBaseContainer)
local base = UIBaseContainer
local name_path = "Obj/TxtName"
local own_path = "Obj/Text"
local need_path = "Obj/Text1"
local output_path = "Obj/Text2"
local capacity_path = "Obj/Text3"
local space_path = "Obj/Text4"
local month_path = "Obj/Text5"

local function OnCreate(self, ...)
  base.OnCreate(self)
  self.name = self:AddComponent(UIText, name_path)
  self.own = self:AddComponent(UIText, own_path)
  self.need = self:AddComponent(UIText, need_path)
  self.output = self:AddComponent(UIText, output_path)
  self.capacity = self:AddComponent(UIText, capacity_path)
  self.space = self:AddComponent(UIText, space_path)
  self.month = self:AddComponent(UIText, month_path)
  local itemData = (...)
  self.own:SetText(string.GetFormattedStr(itemData.own))
  self.name:SetText(itemData.name)
  self.need:SetText(string.GetFloatStr(itemData.need) .. "/s")
  self.output:SetText(string.GetFloatStr(itemData.output) .. "/s")
  self.capacity:SetText(string.GetFormattedStr(itemData.capacity))
  self.space:SetText(string.GetFormattedStr(itemData.space))
  self.month:SetText(itemData.month)
end

local function OnDestroy(self)
  self.name = nil
  self.own = nil
  self.need = nil
  self.output = nil
  self.capacity = nil
  self.space = nil
  self.month = nil
  self.gameObject:GameObjectRecycle()
  base.OnDestroy(self)
end

PlayerResourceReportCell.OnCreate = OnCreate
PlayerResourceReportCell.OnDestroy = OnDestroy
return PlayerResourceReportCell
