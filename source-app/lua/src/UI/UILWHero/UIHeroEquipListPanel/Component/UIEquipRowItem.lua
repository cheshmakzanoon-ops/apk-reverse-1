local UIEquipRowItem = BaseClass("UIEquipRowItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local BaseUIEquipItem = require("UI.UILWHero.UIHeroEquipListPanel.Component.BaseUIEquipItem")
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")

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
end

local function DataDestroy(self)
  self.equipData = nil
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
  self.equipItem = self:AddComponent(BaseUIEquipItem, "EquipItem")
  self.equipNameText = self:AddComponent(UIText, "EquipNameText")
  self.equipPowerText = self:AddComponent(UIText, "EquipPowerGroup/PowerText")
  self.replaceBtn = self:AddComponent(UIButton, "ReplaceBtn")
  self.replaceBtn:SetOnClick(function()
    if self.clickCallBack ~= nil then
      self.clickCallBack(self.equipData)
    end
  end)
  self.replaceBtnText = self:AddComponent(UIText, "ReplaceBtn/BtnIcon/ReplaceBtnText")
  self.belongHeroCell = self:AddComponent(UIHeroCellSmall, "ReplaceBtn/BelongHero/UIHeroCellSmall")
  self.heroStateText = self:AddComponent(UIText, "ReplaceBtn/BelongHero/HeroStateText")
  self.equipBtn = self:AddComponent(UIButton, "EquipBtn")
  self.equipBtn:SetOnClick(function()
    if self.clickCallBack ~= nil then
      self.clickCallBack(self.equipData)
    end
  end)
  self.equipBtnText = self:AddComponent(UIText, "EquipBtn/BtnIcon/EquipBtnText")
  self.replaceBtnText:SetLocalText(430740)
  self.equipBtnText:SetLocalText(430743)
  self.heroStateText:SetLocalText(430742)
  self.equipBtnRedPoint = self:AddComponent(UIBaseContainer, "EquipBtn/BtnIcon/RedPoint")
  self.equipBtnRedPoint.gameObject:SetActive(false)
end

local function ComponentDestroy(self)
  self.equipItem = nil
  self.equipNameText = nil
  self.equipPowerText = nil
  self.replaceBtn = nil
  self.replaceBtnText = nil
  self.belongHeroCell = nil
  self.heroStateText = nil
  self.equipBtn = nil
  self.equipBtnText = nil
end

local function SetData(self, equipData, clickCallBack, redPointEUuid, power)
  self.equipData = equipData
  self.clickCallBack = clickCallBack
  if equipData == nil then
    self:SetActive(false)
    return
  else
    self:SetActive(true)
    self.equipItem:SetData(equipData, nil, false, false, true)
    self.equipNameText:SetLocalText(equipData.config.name)
    self.equipPowerText:SetText(math.floor(equipData.power))
    if equipData.heroUuid == nil or equipData.heroUuid <= 0 then
      self.replaceBtn:SetActive(false)
      self.equipBtn:SetActive(true)
      self.equipBtnRedPoint.gameObject:SetActive(equipData.uuid == redPointEUuid and power < equipData.power)
    else
      self.replaceBtn:SetActive(true)
      self.equipBtn:SetActive(false)
      self.belongHeroCell:SetData(equipData.heroUuid)
      self.belongHeroCell:ToggleLevel(false)
    end
  end
end

UIEquipRowItem.OnCreate = OnCreate
UIEquipRowItem.OnDestroy = OnDestroy
UIEquipRowItem.OnEnable = OnEnable
UIEquipRowItem.OnDisable = OnDisable
UIEquipRowItem.DataDefine = DataDefine
UIEquipRowItem.DataDestroy = DataDestroy
UIEquipRowItem.ComponentDefine = ComponentDefine
UIEquipRowItem.ComponentDestroy = ComponentDestroy
UIEquipRowItem.SetData = SetData
return UIEquipRowItem
