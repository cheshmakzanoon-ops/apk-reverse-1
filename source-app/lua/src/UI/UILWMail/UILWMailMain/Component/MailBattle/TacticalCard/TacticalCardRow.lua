local TacticalCardRow = BaseClass("TacticalCardRow", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local CardInfoPanelWindowParam = require("UI.LWUITC.UITCCardInfoPanel.Ctrl.CardInfoPanelUtil")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:RemoveCards()
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
  self.leftCards = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "leftCards")
  self.rightCards = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "rightCards")
  self.layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "")
  self.cardReq = {}
  self.cardItems = {}
end

local function ComponentDestroy(self)
  self.onCardClick = nil
  self.leftCards = nil
  self.rightCards = nil
end

function TacticalCardRow:RemoveCards()
  self.leftCards:RemoveAllComponentes()
  self.rightCards:RemoveAllComponentes()
  for _, req in pairs(self.cardReq) do
    req:Destroy()
  end
  self.cardReq = {}
  self.cardItems = {}
end

function TacticalCardRow:OnClickCard(cardId, cardUuid, cardLevel, cardStar, cardData, item)
  if not self.cardItems[item] then
    return
  end
  local cardInfo = self.cardItems[item]
  TacticalCardUtil:OpenViewCard(cardInfo.cardId, cardInfo.level, cardInfo.star, cardInfo.randomEffects)
end

local DISPLAY_CONFIG = {isShowLv = true}

function TacticalCardRow:RefreshCards(row)
  local leftCards = row.left
  local rightCards = row.right
  self:RemoveCards()
  if not self.onCardClick then
    self.onCardClick = BindCallback(self, self.OnClickCard)
  end
  
  local function GetCardType(cardId)
    local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
    if cardTemplate then
      return cardTemplate.type
    end
    return nil
  end
  
  local cardType
  if not table.IsNullOrEmpty(leftCards) then
    cardType = GetCardType(leftCards[1].cardId)
  end
  if not cardType and not table.IsNullOrEmpty(rightCards) then
    cardType = GetCardType(rightCards[1].cardId)
  end
  if cardType then
    if cardType == TacticalCardType.Core then
      self.layout:SetPaddingBottom(7)
      self.leftCards:SetSpacing(28)
      self.rightCards:SetSpacing(28)
    else
      self.layout:SetPaddingBottom(0)
      self.leftCards:SetPaddingBottom(4)
      self.rightCards:SetPaddingBottom(4)
    end
  end
  
  local function AddCardItem(index, cardInfo, parent)
    local cardId = cardInfo.cardId
    local cardLevel = cardInfo.level
    local cardStar = cardInfo.star
    local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
    if cardTemplate then
      local cardType = cardTemplate.type
      local cardReq = TacticalCardUtil.CreateOneCardItem(parent, cardType, parent, function(item)
        local scaleRatio = 0.4
        if cardTemplate.type == TacticalCardType.Core then
          scaleRatio = 0.42
        end
        item:SetLocalScaleXYZ(scaleRatio, scaleRatio, scaleRatio)
        local standardSize = item.VISUAL_SIZE
        local sizeX, sizeY
        if standardSize then
          sizeX, sizeY = standardSize.x, standardSize.y
        else
          sizeX, sizeY = item:GetSizeDeltaXY()
        end
        item:SetSizeDeltaXY(sizeX * scaleRatio, sizeY * scaleRatio)
        item:SetConfigData(cardId, cardLevel, cardStar, DISPLAY_CONFIG)
        item:SetClickFunc(self.onCardClick)
        self.cardItems[item] = cardInfo
      end)
      table.insert(self.cardReq, cardReq)
    end
  end
  
  if leftCards then
    for index, cardInfo in pairs(leftCards) do
      AddCardItem(index, cardInfo, self.leftCards)
    end
  end
  if rightCards then
    for index, cardInfo in pairs(rightCards) do
      AddCardItem(index, cardInfo, self.rightCards)
    end
  end
end

TacticalCardRow.OnCreate = OnCreate
TacticalCardRow.OnDestroy = OnDestroy
TacticalCardRow.OnEnable = OnEnable
TacticalCardRow.OnDisable = OnDisable
TacticalCardRow.ComponentDefine = ComponentDefine
TacticalCardRow.ComponentDestroy = ComponentDestroy
return TacticalCardRow
