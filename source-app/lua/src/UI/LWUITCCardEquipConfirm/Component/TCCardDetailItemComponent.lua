local TCCardDetailItemComponent = BaseClass("TCCardDetailItemComponent", UIBaseContainer)
local BaseInfoItem = require("UI.LWUITCCardEquipConfirm.Component.TCCardBaseInfoAreaComponent")
local AttrInfoItem = require("UI.LWUITCCardEquipConfirm.Component.TCCardAttrItemListComponent")
local SkillInfoItem = require("UI.LWUITCCardEquipConfirm.Component.TCSkillInfoComponent")
local PassiveSkillAttrsInfoItem = require("UI.LWUITCCardEquipConfirm.Component.TCPassiveBaseAttrInfoComponent")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local VIEW_MIN_HEIGHT = 508
local VIEW_MAX_HEIGHT = 618
local BASE_INFO_HEIGHT = 196
local BOTTOM_HEIGHT = 130
local BOTTOM_PADDING = 20
local t_c_card_base_info_area_path = "TCCardBaseInfoArea"
local base_attr_info_path = "ScrollView/Content/BaseAttrInfo"
local random_attr_info_path = "ScrollView/Content/RandomAttrInfo"
local t_c_skill_info_path = "ScrollView/Content/TCSkillInfo"
local btn_area_path = "BtnArea"
local cancel_btn_path = "BtnArea/CancelBtn"
local replace_btn_path = "BtnArea/ReplaceBtn"
local btn_text_path = "BtnArea/ReplaceBtn/LW_Btn_Common_New_Base/BtnText"
local scroll_view_path = "ScrollView"
local t_c_passive_skill_info_path = "ScrollView/Content/TCPassiveSkillInfo"
local t_c_passive_base_attr_info_path = "ScrollView/Content/TCPassiveBaseAttrInfo"
local content_path = "ScrollView/Content"

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
  self.baseInfoItem = self:AddComponent(BaseInfoItem, t_c_card_base_info_area_path)
  self.baseAttrItem = self:AddComponent(AttrInfoItem, base_attr_info_path)
  self.randomAttrItem = self:AddComponent(AttrInfoItem, random_attr_info_path)
  self.skillInfoItem = self:AddComponent(SkillInfoItem, t_c_skill_info_path)
  self.passiveSkillInfoItem = self:AddComponent(SkillInfoItem, t_c_passive_skill_info_path)
  self.passiveBaseAttrInfoItem = self:AddComponent(PassiveSkillAttrsInfoItem, t_c_passive_base_attr_info_path)
  self.btnAreaObj = self:AddComponent(UIBaseContainer, btn_area_path)
  self.cancelBtn = self:AddComponent(UIButton, cancel_btn_path)
  self.cancelBtn:SetOnClick(function()
    self:OnClickCancelBtn()
  end)
  self.replaceBtn = self:AddComponent(UIButton, replace_btn_path)
  self.replaceBtn:SetOnClick(function()
    self:OnClickReplaceBtn()
  end)
  self.equipBtnText = self:AddComponent(UIText, btn_text_path)
  self.svLayoutElement = self:AddComponent(UILayoutElement, scroll_view_path)
  self.scrollViewContent = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TCCardDetailItemComponent:SetData(cardData, allCardDataList, equipCardFunc, closeFunc)
  if not cardData then
    return
  end
  self.equipCardFunc = equipCardFunc
  self.replaceFlag = allCardDataList and 1 < #allCardDataList
  self.closeFunc = closeFunc
  local powerChangeSing = self:CalPowerChangeSign(cardData, allCardDataList)
  self.baseInfoItem:SetData(cardData, powerChangeSing)
  local cardType = cardData:GetCardType()
  if cardType == TacticalCardType.Core then
    self:RefreshView4CoreCard(cardData)
  else
    self:RefreshView4NormalCard(cardData)
  end
  self:RefreshBtnState()
end

function TCCardDetailItemComponent:RefreshView4CoreCard(cardData)
  self.passiveSkillInfoItem:SetActive(false)
  self.passiveBaseAttrInfoItem:SetActive(false)
  local baseAttrs = cardData:GetBaseAttrsSorted()
  local isExistBaseAttrs = baseAttrs and table.count(baseAttrs) > 0
  self.baseAttrItem:SetActive(isExistBaseAttrs)
  if isExistBaseAttrs then
    local title = "battle_card_basic"
    self.baseAttrItem:SetData(baseAttrs, title, cardData)
  end
  local randomAttrs = cardData:GetRandomAttrsSorted()
  local isExistRandomAttrs = randomAttrs and table.count(randomAttrs) > 0
  self.randomAttrItem:SetActive(isExistRandomAttrs)
  if isExistRandomAttrs then
    self.randomAttrItem:SetData(randomAttrs, "battle_card_random", cardData)
  end
  local allSkillDataList = cardData:GetAllSkillDataList()
  if cardData:IsUseNewSkillDesc() and allSkillDataList and 1 < #allSkillDataList then
    allSkillDataList = {
      allSkillDataList[1]
    }
  end
  local isExistSkill = allSkillDataList and 0 < #allSkillDataList
  self.skillInfoItem:SetActive(isExistSkill)
  if isExistSkill then
    local title = "battle_card_skill"
    self.skillInfoItem:SetData(TacticalCardSkillType.Active, allSkillDataList, title, cardData)
  end
end

function TCCardDetailItemComponent:RefreshView4NormalCard(cardData)
  self.baseAttrItem:SetActive(false)
  self.skillInfoItem:SetActive(false)
  local passiveSkills = cardData:GetPassiveSkillList(false)
  local isExistPassiveSkill = passiveSkills and 0 < #passiveSkills
  if cardData:IsUseNewSkillDesc() and passiveSkills and 1 < #passiveSkills then
    passiveSkills = {
      passiveSkills[1]
    }
  end
  self.passiveSkillInfoItem:SetActive(isExistPassiveSkill)
  if isExistPassiveSkill then
    local title = "battle_card_passive_skill"
    self.passiveSkillInfoItem:SetData(TacticalCardSkillType.Passive, passiveSkills, title, cardData)
  end
  local isUseNewDesc = cardData:IsUseNewSkillDesc()
  local baseAttrs = cardData:GetNextLvBaseAttrs()
  local isExistBaseAttrs = baseAttrs and 0 < table.count(baseAttrs)
  self.passiveBaseAttrInfoItem:SetActive(isExistBaseAttrs and not isUseNewDesc)
  if isExistBaseAttrs and not isUseNewDesc then
    local title = "battle_card_passive_skill"
    self.passiveBaseAttrInfoItem:SetData(baseAttrs, title)
  end
  local randomAttrs = cardData:GetRandomAttrsSorted()
  local isExistRandomAttrs = randomAttrs and 0 < table.count(randomAttrs)
  self.randomAttrItem:SetActive(isExistRandomAttrs)
  if isExistRandomAttrs then
    self.randomAttrItem:SetData(randomAttrs, "battle_card_random", cardData)
  end
end

function TCCardDetailItemComponent:CalPowerChangeSign(curCard, allCardDataList)
  if not (curCard and allCardDataList) or #allCardDataList <= 1 then
    return 0
  end
  local otherCardData
  for _, v in ipairs(allCardDataList) do
    if v ~= curCard then
      otherCardData = v
      break
    end
  end
  if not otherCardData then
    return 0
  end
  local selfPower = curCard:GetPower()
  local otherCardPower = otherCardData:GetPower()
  if selfPower == otherCardPower then
    return 0
  end
  return selfPower > otherCardPower and 1 or -1
end

function TCCardDetailItemComponent:RefreshBtnState()
  local isShowBtnArea = self.equipCardFunc ~= nil
  self.btnAreaObj:SetActive(isShowBtnArea)
  if not isShowBtnArea then
    return
  end
  self.equipBtnText:SetLocalText(self.replaceFlag and "battle_card_change" or "battle_card_equip")
end

function TCCardDetailItemComponent:OnClickCancelBtn()
  self:ClosePanel()
end

function TCCardDetailItemComponent:OnClickReplaceBtn()
  local replaceRet = false
  if self.equipCardFunc then
    replaceRet = self.equipCardFunc()
  end
  if replaceRet then
    self:ClosePanel()
  end
end

function TCCardDetailItemComponent:ClosePanel()
  if self.closeFunc then
    self.closeFunc()
  end
end

function TCCardDetailItemComponent:ModifyHeight()
  local height = self.scrollViewContent.rectTransform.rect.height
  local totalHeight = BASE_INFO_HEIGHT + BOTTOM_PADDING + height
  local bottomHeight = 0
  if self.btnAreaObj.activeSelf then
    bottomHeight = BOTTOM_HEIGHT
  end
  totalHeight = totalHeight + bottomHeight
  local modifyHeight = Mathf.Clamp(totalHeight, VIEW_MIN_HEIGHT, VIEW_MAX_HEIGHT)
  local realScrollHeight = modifyHeight - BASE_INFO_HEIGHT - BOTTOM_PADDING - bottomHeight
  realScrollHeight = math.max(realScrollHeight, 100)
  self.svLayoutElement:SetEnable(true)
  self.svLayoutElement:SetPreferredHeight(realScrollHeight)
end

function TCCardDetailItemComponent:AutoHeight()
  self.svLayoutElement:SetEnable(false)
end

TCCardDetailItemComponent.OnCreate = OnCreate
TCCardDetailItemComponent.OnDestroy = OnDestroy
TCCardDetailItemComponent.OnEnable = OnEnable
TCCardDetailItemComponent.OnDisable = OnDisable
TCCardDetailItemComponent.ComponentDefine = ComponentDefine
TCCardDetailItemComponent.ComponentDestroy = ComponentDestroy
TCCardDetailItemComponent.DataDefine = DataDefine
TCCardDetailItemComponent.DataDestroy = DataDestroy
TCCardDetailItemComponent.OnAddListener = OnAddListener
TCCardDetailItemComponent.OnRemoveListener = OnRemoveListener
return TCCardDetailItemComponent
