local TCCardProbItemComponent = BaseClass("TCCardProbItemComponent", UIAsyncDataContainer)
TCCardProbItemComponent.DataSchema = {"prob", "cardTmp"}
TCCardProbItemComponent.PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/TCCardProbItem.prefab"
local base = UIAsyncDataContainer
local Localization = CS.GameEntry.Localization
local card_item_point_path = "CardItemPoint"
local probability_text_path = "ProbabilityText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.cardTmp = nil
  self:ClearCardItem()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.cardItemPoint = self:AddComponent(UIBaseContainer, card_item_point_path)
  self.probabilityText = self:AddComponent(UIText, probability_text_path)
end

function TCCardProbItemComponent:ComponentDestroy()
  self.cardItemPoint = nil
  self.probabilityText = nil
end

function TCCardProbItemComponent:UpdateData()
  if not self.viewData then
    return
  end
  if self.viewData.prob then
    self.probabilityText:SetText(string.percentage(self.viewData.prob, 1, 2))
  else
    self.probabilityText:SetText(string.percentage(0, 1, 2))
  end
  self.cardTmp = self.viewData.cardTmp
  if not self.cardTmp then
    return
  end
  self:GenCardItem(self.cardTmp)
end

function TCCardProbItemComponent:RefreshCardItem(cardItem)
  if not cardItem then
    return
  end
  if not self.cardTmp then
    return
  end
  local displayConfig = {}
  displayConfig.isShowLv = false
  displayConfig.isShowStar = false
  displayConfig.showBg = true
  local lv = 1
  local star = 0
  cardItem:SetConfigData(self.cardTmp.id, lv, star, displayConfig)
  cardItem:SetClickFunc(function()
    self:ShowCardDetailInfo()
  end)
  local scale = self.cardTmp.type == TacticalCardType.Core and 1 or 1.26
  cardItem:SetLocalScaleXYZ(scale, scale, scale)
end

function TCCardProbItemComponent:GenCardItem(cardTmp)
  if not cardTmp then
    return
  end
  local prevCardType = self.cardType
  if prevCardType ~= cardTmp.type then
    self:ClearCardItem()
    self.loadCardReq = TacticalCardUtil.CreateOneCardItem(self, cardTmp.type, self.cardItemPoint, function(cardItem)
      self.cardItem = cardItem
      self:RefreshCardItem(cardItem)
    end)
  elseif self.cardItem then
    self:RefreshCardItem(self.cardItem)
  end
  self.cardType = cardTmp.type
end

function TCCardProbItemComponent:ClearCardItem()
  if self.loadCardReq then
    self.cardItemPoint:RemoveAllComponentes()
    self.loadCardReq:Destroy()
    self.loadCardReq = nil
    self.cardItem = nil
  end
  self.cardType = nil
end

function TCCardProbItemComponent:ShowCardDetailInfo()
  if not self.cardTmp then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardViewPanel, {anim = true}, self.cardTmp.id, true)
end

TCCardProbItemComponent.OnCreate = OnCreate
TCCardProbItemComponent.OnDestroy = OnDestroy
TCCardProbItemComponent.ComponentDefine = ComponentDefine
return TCCardProbItemComponent
