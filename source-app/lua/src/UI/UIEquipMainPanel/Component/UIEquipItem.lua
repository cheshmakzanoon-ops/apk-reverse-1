local UIEquipItem = BaseClass("UIEquipItem", UIBaseContainer)
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
  self.canCraftIconActive = false
end

local function DataDestroy(self)
  self.slotType = nil
  self.heroType = nil
  self.equipData = nil
  self.emptySlotclickCallBack = nil
  self.equipClickCallBack = nil
  self.selected = nil
  self.canCraftIconActive = nil
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
  self.selectedFrame = self:AddComponent(UIImage, "SelectedFrame")
  self.lockContent = self:AddComponent(UIBaseContainer, "LockContent")
  self.canCraftIcon = self:AddComponent(UIImage, "CanCraftIcon")
  self.craftingContent = self:AddComponent(UIBaseContainer, "CraftingContent")
  self.finishCraftingContent = self:AddComponent(UIBaseContainer, "FinishCraftingContent")
  self.animation = self:AddComponent(UISimpleAnimation, "")
end

local function ComponentDestroy(self)
  self.root = nil
  self.equipContent = nil
  self.selectedFrame = nil
  self.lockContent = nil
  self.canCraftIcon = nil
  self.craftingContent = nil
  self.finishCraftingContent = nil
  self.animation = nil
end

local function OnClickEquip(self, equipId)
  if self.clickCallBack ~= nil and equipId ~= nil then
    self.clickCallBack(equipId, self)
  end
end

local function RefershRedPoint(self, buildLevel)
  local canCraft = self.equipTemplate:CanCraft(buildLevel)
  self.canCraftIcon:SetActive(canCraft)
  self.canCraftIconActive = canCraft
end

local function SetData(self, equipId, buildLevel, clickCallBack)
  self.equipTemplate = DataCenter.EquipTemplateManager:GetTemplate(equipId)
  if self.equipTemplate == nil then
    Logger.LogError("\232\163\133\229\164\135\230\168\161\230\157\191\228\184\186\231\169\186:" .. tostring(equipId))
    self:SetActive(false)
    return
  else
    self:SetActive(true)
  end
  self.clickCallBack = clickCallBack
  local isUnlocked = buildLevel >= self.equipTemplate.unlock_Level
  self.equipContent:SetTemplateData(equipId, BindCallback(self, OnClickEquip), true, false)
  if isUnlocked then
    self.lockContent:SetActive(false)
    RefershRedPoint(self, buildLevel)
  else
    self.lockContent:SetActive(true)
    self.canCraftIcon:SetActive(false)
    self.canCraftIconActive = false
  end
end

local function SetSelected(self, selected)
  self.selected = selected
  self.selectedFrame:SetActive(selected)
end

local function SetIsCrafting(self, isCrafting, finishiCrafting)
  if isCrafting then
    self.craftingContent:SetActive(not finishiCrafting)
    self.finishCraftingContent:SetActive(finishiCrafting)
    if self.canCraftIconActive then
      self.canCraftIcon:SetActive(false)
    end
    if not finishiCrafting then
      self.animation:SampleAnimationAtTime("crafting", 0)
      self.animation:Play("crafting")
    else
      self.animation:Stop()
    end
  else
    self.craftingContent:SetActive(false)
    self.finishCraftingContent:SetActive(false)
    self.animation:Stop()
  end
end

UIEquipItem.OnCreate = OnCreate
UIEquipItem.OnDestroy = OnDestroy
UIEquipItem.OnEnable = OnEnable
UIEquipItem.OnDisable = OnDisable
UIEquipItem.DataDefine = DataDefine
UIEquipItem.DataDestroy = DataDestroy
UIEquipItem.ComponentDefine = ComponentDefine
UIEquipItem.ComponentDestroy = ComponentDestroy
UIEquipItem.SetData = SetData
UIEquipItem.SetSelected = SetSelected
UIEquipItem.SetIsCrafting = SetIsCrafting
return UIEquipItem
