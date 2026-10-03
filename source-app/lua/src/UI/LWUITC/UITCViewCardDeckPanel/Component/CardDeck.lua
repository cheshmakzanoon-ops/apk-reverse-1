local CardDeck = BaseClass("CardDeck", UIBaseContainer)
local NORMAL_CARD_SLOT_SCALE = 0.8
local CORE_CARD_SLOT_SCALE = 1
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local card_slot_root_path = "Root/Content/CardSlotRoot"
local slot_path = "Root/Content/CardSlotRoot/Slot%s"
local GUIDE_FLOW_ID = 5101

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
  if self.curAllSlotDataDic then
    self:UpdateCardState()
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.allSlotHangUpPoint = {}
  self.allSlotItemDic = {}
  self.allSlotItemReqList = {}
  self.slotRoot = self:AddComponent(UIBaseContainer, card_slot_root_path)
  local slotCount = self.slotRoot.transform.childCount
  for i = 1, slotCount do
    local path = string.format(slot_path, i)
    local hangupPoint = self:AddComponent(UIBaseContainer, path)
    self.allSlotHangUpPoint[i] = hangupPoint
  end
  self.animator = self:AddComponent(UISimpleAnimation, "")
end

local function ComponentDestroy(self)
  self.allSlotItemDic = nil
  self:ClearAllSlotItem()
  self.allSlotItemReqList = nil
end

local function DataDefine(self)
  self.curAllSlotDataDic = {}
end

local function DataDestroy(self)
  self.curAllSlotDataDic = nil
end

function CardDeck:ReInit(slotDataList)
  self.curAllSlotDataDic = slotDataList
  self:CreateSlotItem()
  self.animator:Play("open")
end

function CardDeck:CreateSlotItem()
  self:ClearAllSlotItem()
  self.allSlotItemDic = {}
  for slotId, cardInfo in pairs(self.curAllSlotDataDic) do
    local hangupPoint = self.allSlotHangUpPoint[slotId]
    if hangupPoint then
      local cardId = cardInfo.cardId
      local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
      if cardTemplate then
        local slotType = cardTemplate.type
        local slotReq = TacticalCardUtil.CreateOneConfigSlotItem(self, slotType, hangupPoint, function(slotItem)
          if slotItem.transform then
            local scale = self:GetCardScale(slotType)
            slotItem:SetSlotScale(scale)
          end
          slotItem:SetData(slotType, cardInfo, slotId)
          slotItem:SetClickFunc(function(slotId)
            self:OnClickSlotItem(slotId)
          end)
          self.allSlotItemDic[slotId] = slotItem
        end)
        table.insert(self.allSlotItemReqList, slotReq)
      end
    end
  end
end

function CardDeck:OnClickSlotItem(slotId)
  if not slotId then
    return
  end
  local cardData = self.curAllSlotDataDic[slotId]
  if not cardData then
    return
  end
  TacticalCardUtil:OpenViewCard(cardData.cardId, cardData.level, cardData.star, cardData.randomAttr)
end

function CardDeck:GetCardScale(slotType)
  if slotType == TacticalCardSlotType.Core then
    return CORE_CARD_SLOT_SCALE
  elseif slotType == TacticalCardSlotType.Battle or slotType == TacticalCardSlotType.Economy then
    return NORMAL_CARD_SLOT_SCALE
  end
end

function CardDeck:ClearAllSlotItem()
  if self.allSlotItemReqList then
    for _, v in ipairs(self.allSlotItemReqList) do
      v:Destroy()
    end
  end
  self.allSlotItemReqList = {}
end

function CardDeck:UpdateCardState(updateCardDataList, updateSourceType)
  if not updateCardDataList then
    if self.allSlotItemDic then
      for slotId, v in pairs(self.allSlotItemDic) do
        self:UpdateSlotCard(slotId)
      end
    end
    return
  end
  local allNeedUpdateSlotIdList = {}
  for _, v in ipairs(updateCardDataList) do
    local targetSlotId = v.slot
    if 0 < targetSlotId then
      allNeedUpdateSlotIdList[targetSlotId] = true
    end
    targetSlotId = self:FindSlotIdByUuid(v.uuid)
    if targetSlotId and not allNeedUpdateSlotIdList[targetSlotId] then
      allNeedUpdateSlotIdList[targetSlotId] = true
    end
  end
  for slotId, _ in pairs(allNeedUpdateSlotIdList) do
    self:UpdateSlotCard(slotId, updateSourceType)
  end
end

function CardDeck:UpdateSlotCard(slotId, updateSourceType)
  if not self.allSlotItemDic then
    return
  end
  local slotItem = self.allSlotItemDic[slotId]
  if not slotItem or not slotItem.slotData then
    return
  end
  local equipCard = slotItem.slotData:GetCardData()
  if equipCard then
    slotItem:GenCardItem(equipCard, updateSourceType)
  else
    slotItem:ClearCardItem()
  end
end

function CardDeck:FindSlotIdByUuid(cardUuid)
  if not self.allSlotItemDic then
    return nil
  end
  for slotId, v in pairs(self.allSlotItemDic) do
    if v.curCacheCardData and v.curCacheCardData.uuid == cardUuid then
      return slotId
    end
  end
  return nil
end

CardDeck.OnCreate = OnCreate
CardDeck.OnDestroy = OnDestroy
CardDeck.OnEnable = OnEnable
CardDeck.OnDisable = OnDisable
CardDeck.ComponentDefine = ComponentDefine
CardDeck.ComponentDestroy = ComponentDestroy
CardDeck.DataDefine = DataDefine
CardDeck.DataDestroy = DataDestroy
return CardDeck
