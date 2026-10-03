local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local UIGiftPackageCell = BaseClass("UIGiftPackageCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local item_path = "IconNode/UIGiftItem"
local item_name_path = "TxtName"
local item_num_path = "TxtNum"
local Param = DataClass("Param", ParamData)
local ParamData = {
  itemId,
  count,
  iconName,
  itemName,
  itemDes,
  itemColor,
  heroId
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.item = self:AddComponent(UICommonResItem, item_path)
  self.item_name = self:AddComponent(UIText, item_name_path)
  self.item_num = self:AddComponent(UIText, item_num_path)
end

local function ComponentDestroy(self)
  self.item = nil
  self.item_name = nil
  self.item_num = nil
end

local function DataDefine(self)
  self.param = {}
  self.itemName = ""
  self.itemNum = ""
end

local function DataDestroy(self)
  self.param = nil
  self.itemName = nil
  self.itemNum = nil
end

local function ReInit(self, param)
  self.param = param
  self.item:ReInit(param)
end

local function OnItemClick(self, userdata, tf)
end

local function SetItemName(self, value)
  if self.itemName ~= value then
    self.itemName = value
    self.item_name:SetText(value)
  end
end

local function SetItemNum(self, value)
  if self.itemNum ~= value then
    self.itemNum = value
    self.item_num:SetText(value)
  end
end

UIGiftPackageCell.OnCreate = OnCreate
UIGiftPackageCell.OnDestroy = OnDestroy
UIGiftPackageCell.ReInit = ReInit
UIGiftPackageCell.ComponentDefine = ComponentDefine
UIGiftPackageCell.ComponentDestroy = ComponentDestroy
UIGiftPackageCell.DataDefine = DataDefine
UIGiftPackageCell.DataDestroy = DataDestroy
UIGiftPackageCell.Param = Param
UIGiftPackageCell.OnItemClick = OnItemClick
UIGiftPackageCell.SetItemName = SetItemName
UIGiftPackageCell.SetItemNum = SetItemNum
return UIGiftPackageCell
