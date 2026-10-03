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
end

local function DataDestroy(self)
  self.slotType = nil
  self.heroType = nil
  self.equipData = nil
  self.emptySlotclickCallBack = nil
  self.equipClickCallBack = nil
end

local EQUIP_ITEM_PREFAB_PATH = "Assets/Main/Prefabs/UI/UIHero/New/Optimized/HeroDetailPanelEquipItem.prefab"

local function OnEnable(self)
  base.OnEnable(self)
  if not self.equipItemReq then
    self.equipItemReq = self:GameObjectInstantiateAsync(EQUIP_ITEM_PREFAB_PATH, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.transform)
      go.transform:Reset()
      go.name = "EquipItem"
      go.gameObject:SetActive(true)
      self:RealComponentDefine()
      if self.slotType and self.hero then
        self:RealSetData()
      end
      if self.selected ~= nil then
        self:SetSelected(self.selected)
      end
    end)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIImage, "")
end

local function ComponentDestroy(self)
  self.root = nil
  self.equipContent = nil
  self.emptyContent = nil
  self.emptyContentBtn = nil
  self.emptyContentRedPoint = nil
  self.selectedFrame = nil
  self.recommendRoot = nil
end

local function OnClickEquip(self, equipData)
  if self.equipClickCallBack ~= nil and equipData ~= nil then
    self.equipClickCallBack(equipData, self.root)
  end
end

local function RefershRedPoint(self)
  if self.equipData == nil then
    local canEquip = HeroRedPointManager:GetInstance():CheckCanShowRedPoint(HeroRedPointType.HeroDetail_EmptyEquipSlot, self.slotType, self.heroType, self.hero.uuid)
    self.emptyContentRedPoint:SetActive(canEquip)
  end
end

local function SetData(self, slot, hero, equipData, emptySlotClickCallBack, equipClickCallBack)
  self.slotType = slot
  self.hero = hero
  self.heroType = hero.heroType
  self.equipData = equipData
  self.emptySlotclickCallBack = emptySlotClickCallBack
  self.equipClickCallBack = equipClickCallBack
  if self.equipContent then
    self:RealSetData()
  end
end

local function SetSelected(self, selected)
  self.selected = selected
  if self.selectedFrame then
    self.selectedFrame:SetActive(selected)
  end
end

function UIEquipItem:RealComponentDefine()
  self.equipContent = self:AddComponent(BaseUIEquipItem, "EquipItem/EquipContent")
  self.emptyContent = self:AddComponent(UIImage, "EquipItem/EmptyContent")
  self.emptyContentBtn = self:AddComponent(UIButton, "EquipItem/EmptyContent/Bg")
  self.emptyContentBtn:SetOnClick(function()
    if self.emptySlotclickCallBack ~= nil then
      self.emptySlotclickCallBack(self.slotType)
    end
  end)
  self.emptyContentRedPoint = self:AddComponent(UIImage, "EquipItem/EmptyContent/RedPoint")
  self.emptyContentBg = self:AddComponent(UIImage, "EquipItem/EmptyContent/Bg")
  self.selectedFrame = self:AddComponent(UIImage, "EquipItem/EquipContent/SelectedFrame")
  self.recommendRoot = self:AddComponent(UIBaseContainer, "EquipItem/Recommend")
end

local BG_PATH = "Assets/Main/Sprites/UI/UILWHeroDetail/cfm_yingxiong_peijiankuang_%d"

function UIEquipItem:RealSetData()
  if self.equipData == nil then
    self.emptyContent:SetActive(true)
    self.equipContent:SetActive(false)
    local bg_id = 1
    if self.slotType == EquipmentSlotType.Weapon then
      bg_id = 3
    elseif self.slotType == EquipmentSlotType.Armor then
      bg_id = 1
    elseif self.slotType == EquipmentSlotType.Core then
      bg_id = 4
    elseif self.slotType == EquipmentSlotType.Radar then
      bg_id = 2
    end
    self.emptyContentBg:LoadSprite(string.format(BG_PATH, bg_id))
    RefershRedPoint(self)
  else
    self.emptyContent:SetActive(false)
    self.equipContent:SetActive(true)
    self.equipContent:SetData(self.equipData, BindCallback(self, OnClickEquip), true, false, true)
    self.equipContent:RefreshCanReplaceWithBetterEquipRedPoint()
  end
  self.recommendRoot:SetActive(DataCenter.EquipRecommendManager:IsShowRecommend(self.hero, self.equipData))
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
return UIEquipItem
