local UIDecomposeEquipItem = BaseClass("UIDecomposeEquipItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local BaseUIEquipItem = require("UI.UILWHero.UIHeroEquipListPanel.Component.BaseUIEquipItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.slotType = EquipmentSlotType.Weapon
  self.heroType = HeroType.Tank
  self.selected = false
end

local function DataDestroy(self)
  self.slotType = nil
  self.heroType = nil
  self.equipData = nil
  self.emptySlotclickCallBack = nil
  self.equipClickCallBack = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIImage, "")
  self.equipContent = self:AddComponent(BaseUIEquipItem, "EquipItem")
  self.selectedContent = self:AddComponent(UIBaseContainer, "SelectedContent")
end

local function ComponentDestroy(self)
  self.root = nil
  self.equipContent = nil
  self.selectedContent = nil
end

local function OnClickEquip(self, equipId)
  if self.clickCallBack ~= nil and equipId ~= nil then
    self.clickCallBack(equipId, self)
  end
end

local function RefershRedPoint(self)
  return false
end

local function SetData(self, equipUuid, clickCallBack)
  self.equipData = DataCenter.EquipDataManager:GetEquipByUuid(equipUuid)
  if self.equipData == nil then
    Logger.LogError("\229\143\150\228\184\141\229\136\176\232\163\133\229\164\135:" .. tostring(equipUuid))
    self:SetActive(false)
    return
  else
    self:SetActive(true)
  end
  self.clickCallBack = clickCallBack
  self.equipContent:SetData(self.equipData, BindCallback(self, OnClickEquip), false, true, true)
end

local function SetSelected(self, selected)
  self.selected = selected
  self.selectedContent:SetActive(selected)
end

UIDecomposeEquipItem.OnCreate = OnCreate
UIDecomposeEquipItem.OnDestroy = OnDestroy
UIDecomposeEquipItem.OnEnable = OnEnable
UIDecomposeEquipItem.OnDisable = OnDisable
UIDecomposeEquipItem.DataDefine = DataDefine
UIDecomposeEquipItem.DataDestroy = DataDestroy
UIDecomposeEquipItem.ComponentDefine = ComponentDefine
UIDecomposeEquipItem.ComponentDestroy = ComponentDestroy
UIDecomposeEquipItem.SetData = SetData
UIDecomposeEquipItem.SetSelected = SetSelected
return UIDecomposeEquipItem
