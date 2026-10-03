local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemTacticalCard = BaseClass("UICommonResItemTacticalCard", UICommonResItemBase)
local base = UICommonResItemBase
local Localization = CS.GameEntry.Localization

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
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function OnReInit(self)
  local cardTemplate
  if self.param.itemId then
    cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(self.param.itemId)
  end
  if not cardTemplate then
    return
  end
  self:SetFlagActive(false)
  self.item_bg:SetActive(false)
  self.item_quality:SetActive(true)
  local quality_path = TacticalCardUtil.GetCardFrameByQuality(cardTemplate.type, TacticalCardShowType.SimpleShow, cardTemplate.color)
  self.item_quality:LoadSprite(quality_path)
  self.hero_quality:SetActive(false)
  self:SetItemIconImage(cardTemplate.icon)
  self:SetNameText(Localization:GetString(cardTemplate.name))
end

local function OnClick(self)
  local cardTemplate
  if self.param.itemId then
    cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(self.param.itemId)
  end
  if not cardTemplate then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardViewPanel, {anim = true}, cardTemplate.id, true, true)
end

UICommonResItemTacticalCard.OnCreate = OnCreate
UICommonResItemTacticalCard.OnDestroy = OnDestroy
UICommonResItemTacticalCard.ComponentDefine = ComponentDefine
UICommonResItemTacticalCard.ComponentDestroy = ComponentDestroy
UICommonResItemTacticalCard.DataDefine = DataDefine
UICommonResItemTacticalCard.DataDestroy = DataDestroy
UICommonResItemTacticalCard.OnReInit = OnReInit
UICommonResItemTacticalCard.OnClick = OnClick
return UICommonResItemTacticalCard
