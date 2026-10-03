local TCCardBaseSlot = BaseClass("TCCardBaseSlot", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local root_path = "Root"
local empty_slot_path = "Root/EmptySlot"
local equip_card_path = "Root/EquipCard"
local slot_type_icon_path = "Root/EmptySlot/SlotTypeIcon"
local red_dot_path = "Root/EmptySlot/RedDot"
local lock_img_path = "Root/EmptySlot/LockImg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.clickBtn = self:AddComponent(UIButton, root_path)
  self.clickBtn:SetOnClick(function()
    self:ClickCardSlot()
  end)
  self.cardItem = nil
  self.emptySlotObj = self:AddComponent(UIBaseContainer, empty_slot_path)
  self.equipCardRoot = self:AddComponent(UIBaseContainer, equip_card_path)
  self.slotTypeIcon = self:AddComponent(UIImage, slot_type_icon_path)
  self.redDot = self:AddComponent(UIBaseContainer, red_dot_path)
  self.redDot:SetActive(false)
  self.lockImgObj = self:AddComponent(UIBaseComponent, lock_img_path)
  self:SetSlotScale(1)
  self:SetCardScale(1)
end

local function ComponentDestroy(self)
  self.cardItem = nil
  if self.loadCardReq then
    self.loadCardReq:Destroy()
    self.loadCardReq = nil
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.clickFunc = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TCCardBaseSlot:SetData(slotData)
  self.slotId = slotData.slotId
  self.slotData = slotData
  self.slotType = slotData.slotType
  self:RefreshView()
end

function TCCardBaseSlot:RefreshView()
  self:ShowEmptyState()
  self:RefreshSlotIcon()
  local curEquipCard = self.slotData:GetCardData()
  if curEquipCard then
    self:GenCardItem(curEquipCard)
  end
end

function TCCardBaseSlot:GenCardItem(cardData, updateSource)
  self:ClearCardItem()
  self.curCacheCardData = cardData
  if not self.curCacheCardData then
    return
  end
  self.loadCardReq = TacticalCardUtil.CreateOneCardItem(self, self.slotType, self.equipCardRoot, function(cardItem)
    self.cardItem = cardItem
    local displayConfig = {}
    displayConfig.isDeluxeShow = true
    displayConfig.isShowLv = true
    if updateSource == TacticalCardUpdateSource.EquipCard then
      displayConfig.isEquipEffShow = true
    end
    self.cardItem:SetData(cardData, displayConfig)
    self:OnCardLoadFinish()
  end)
end

function TCCardBaseSlot:ClearCardItem()
  self.curCacheCardData = nil
  if self.loadCardReq then
    self.equipCardRoot:RemoveAllComponentes()
    self.loadCardReq:Destroy()
    self.loadCardReq = nil
  end
  self:ShowEmptyState()
end

function TCCardBaseSlot:OnCardLoadFinish()
  self.emptySlotObj:SetActive(false)
end

function TCCardBaseSlot:ShowEmptyState()
  self.emptySlotObj:SetActive(true)
end

function TCCardBaseSlot:RefreshSlotIcon()
  if not self.slotData then
    return
  end
  local isLock = self.slotData:IsLock()
  self.lockImgObj:SetActive(isLock)
  local isShowCardTypeIcon = self.slotType ~= TacticalCardSlotType.Core
  self.slotTypeIcon:SetActive(isShowCardTypeIcon)
  if isShowCardTypeIcon then
    local iconPath = TacticalCardUtil.GetSlotTypeIconPath(self.slotType)
    if not string.IsNullOrEmpty(iconPath) then
      self.slotTypeIcon:LoadSprite(iconPath)
      self.slotTypeIcon:SetNativeSize()
    end
  end
end

function TCCardBaseSlot:SetClickFunc(clickFunc)
  self.clickFunc = clickFunc
end

function TCCardBaseSlot:ClickCardSlot()
  if self.clickFunc then
    self.clickFunc(self.slotData)
  end
end

function TCCardBaseSlot:SetRedDotState(isShow)
  self.redDot:SetActive(isShow)
end

function TCCardBaseSlot:CheckLockState()
  self:ShowEmptyState()
  self:RefreshSlotIcon()
end

function TCCardBaseSlot:SetSlotScale(scale)
  self.emptySlotObj.transform:Set_localScale(scale, scale, scale)
end

function TCCardBaseSlot:SetCardScale(scale)
  self.equipCardRoot.transform:Set_localScale(scale, scale, scale)
end

TCCardBaseSlot.OnCreate = OnCreate
TCCardBaseSlot.OnDestroy = OnDestroy
TCCardBaseSlot.OnEnable = OnEnable
TCCardBaseSlot.OnDisable = OnDisable
TCCardBaseSlot.ComponentDefine = ComponentDefine
TCCardBaseSlot.ComponentDestroy = ComponentDestroy
TCCardBaseSlot.DataDefine = DataDefine
TCCardBaseSlot.DataDestroy = DataDestroy
TCCardBaseSlot.OnAddListener = OnAddListener
TCCardBaseSlot.OnRemoveListener = OnRemoveListener
return TCCardBaseSlot
