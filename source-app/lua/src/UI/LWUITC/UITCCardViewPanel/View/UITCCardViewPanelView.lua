local UITCCardViewPanelView = BaseClass("UITCCardViewPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CardAttrLine = require("UI.LWUITC.UITCCardViewPanel.Component.CardViewAttrLineAsync")
local CardAttrLinePrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CardAttrLine2.prefab"
local CoreCardSkillItem = require("UI.LWUITC.UITCCardDetailPanel.Component.CoreCardSkillItem")
local CoreCardSkillItemPrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CoreCardSkillItem.prefab"
local PassiveSkillLine = require("UI.LWUITC.UITCCardDetailPanel.Component.PassiveSkillLineAsync")
local PassiveSkillLinePrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/PassiveSkillLine.prefab"
local StarListItem = require("UI.LWUITCCardMain.Component.TCStarListItemComponent")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local cId, initState, hideGetMore = self:GetUserData()
  if not cId then
    self.ctrl:CloseSelf()
    return
  end
  if hideGetMore then
    self.getMore_btn:SetActive(false)
  else
    self.getMore_btn:SetActive(true)
  end
  local cardData = self.ctrl:GetCardData(cId, initState)
  if cardData then
    self:UpdateView(cardData)
  else
    self.ctrl:CloseSelf()
  end
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
  self.mask_btn = self:AddComponent(UIButton, "panel")
  self.mask_btn:SetOnClick(function()
    self:OnMask_btnClick()
  end)
  self.close_btn = self:AddComponent(UIButton, "PopUpTitle/CloseBtn")
  self.close_btn:SetOnClick(function()
    self:OnClose_btnClick()
  end)
  self.power_txt = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/content/shared/PowerInfo/PowerNumberText")
  self.cardIcon_container = self:AddComponent(UIBaseContainer, "PopUpTitle/content/shared/card")
  self.cardName_txt = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/content/shared/cardName_txt")
  self.cardType_txt = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/content/shared/cardType_txt")
  self.skills = self:AddComponent(UIBaseContainer, "PopUpTitle/content/card/areas/viewport/content/skill_area")
  self.getMore_btn = self:AddComponent(UIButton, "PopUpTitle/btns/getMore_btn")
  self.getMore_btn:SetOnClick(function()
    self:OnGetMore_btnClick()
  end)
  self.random_attrs = self:AddComponent(UIBaseContainer, "PopUpTitle/content/card/areas/viewport/content/random_attrs")
  self.randomTitle_txt = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/content/card/areas/viewport/content/random_attrs/title/randomTitle_txt")
  self.attrs = self:AddComponent(UIBaseContainer, "PopUpTitle/content/card/areas/viewport/content/basic_attrs/attr_container")
  self.passiveSkills = self:AddComponent(UIBaseContainer, "PopUpTitle/content/card/areas/viewport/content/basic_attrs/passive_conatiner")
  self.basicAttrTitle_txt = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/content/card/areas/viewport/content/basic_attrs/title/title_txt")
  self.star_container = self:AddComponent(UIBaseContainer, "PopUpTitle/content/card/areas/viewport/content/star_area")
  self.stars = self:AddComponent(StarListItem, "PopUpTitle/content/card/areas/viewport/content/star_area/star/stars")
  self.cardLv_txt = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/content/shared/cardLv_txt")
end

local function ComponentDestroy(self)
  self.mask_btn = nil
  self.close_btn = nil
  self.power_txt = nil
  self.cardIcon_container = nil
  self.cardName_txt = nil
  self.cardType_txt = nil
  self.stars = nil
  self.skills = nil
  self.getMore_btn = nil
  self.random_attrs = nil
  self.randomTitle_txt = nil
  self.attrs = nil
  self.passiveSkills = nil
  self.basicAttrTitle_txt = nil
  self.star_container = nil
  self.stars = nil
  self.cardLv_txt = nil
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

local function OnMask_btnClick(self)
  self.ctrl:CloseSelf()
end

local function OnClose_btnClick(self)
  self.ctrl:CloseSelf()
end

function UITCCardViewPanelView:UpdateView(cardData)
  self.cardData = cardData
  local cardType = cardData.template.type
  if cardType ~= TacticalCardType.Core and cardData.template.attr_random_show > 0 then
    local line = LocalController:instance():getLine("battle_card_random_attr", cardData.template.attr_random_show)
    if not line then
      return nil
    end
    local randomAttrs_str = line:getValue("attr_pool")
    local randomAttrs = string.split(randomAttrs_str, "|")
    self.randomAttrs = {}
    for _, v in ipairs(randomAttrs) do
      local split = string.split(v, ";")
      local weight = tonumber(split[1] or 0)
      local type = tonumber(split[2] or 0)
      local id = tonumber(split[3] or 0)
      local detailTemplate = LocalController:instance():getLine("battle_card_random_attr_detail", id)
      local min = detailTemplate.quality_range[1]
      local max = detailTemplate.quality_range[2]
      local effectId = detailTemplate.effect_num
      local effectTemplate = DataCenter.TacticalCardDataManager:GetRandomAttributeShowTemplate(effectId)
      local quality = DataCenter.TacticalCardDataManager:GetCardAttributeQuality(id)
      table.insert(self.randomAttrs, {
        weight = weight,
        type = type,
        id = effectId,
        min = min,
        max = max,
        name = effectTemplate.effect_name,
        quality = quality
      })
    end
    table.sort(self.randomAttrs, function(a, b)
      if a.quality ~= b.quality then
        return a.quality > b.quality
      end
      return a.id > b.id
    end)
    self.powerRange = cardData.template.power_range
  else
    self.randomAttrs = nil
    self.powerRange = nil
  end
  self:UpdateBaseInfo(cardData)
  if cardType == TacticalCardType.Core then
    self.star_container:SetActive(true)
    self.skills:SetActive(true)
    self.random_attrs:SetActive(false)
    self:UpdateStar(cardData)
    self:UpdateSkill(cardData)
    self.basicAttrTitle_txt:SetLocalText("battle_card_basic")
    self:UpdateAttr(cardData)
  else
    self.star_container:SetActive(false)
    self.skills:SetActive(false)
    if not table.IsNullOrEmpty(self.randomAttrs) then
      self.random_attrs:SetActive(true)
      self:UpdateRandomAttr(cardData)
    else
      self.random_attrs:SetActive(false)
    end
    self:UpdatePassiveSkills(cardData)
    self.basicAttrTitle_txt:SetLocalText("battle_card_passive_skill")
    if cardData:IsUseNewSkillDesc() then
      self.attrs:SetActive(false)
    else
      self.attrs:SetActive(true)
      self:UpdateAttr(cardData)
    end
  end
end

local DISPLAY_CONFIG = {
  isShowStar = false,
  isDeluxeShow = true,
  isShowLv = false
}

function UITCCardViewPanelView:UpdateBaseInfo(cardData)
  self.cardName_txt:SetLocalText(cardData.template.name)
  self.cardType_txt:SetText(TacticalCardUtil.GetCardTypeNameStr(cardData.template.type))
  self.cardLv_txt:SetText(TacticalCardUtil.GetLevelStr(cardData))
  local power = cardData:GetPower()
  if self.powerRange then
    power = string.format("%d-%d", power + self.powerRange[1], power + self.powerRange[2])
  end
  self.power_txt:SetText(power)
  if self.cardItem then
    self.cardItem:SetData(cardData, DISPLAY_CONFIG)
  elseif not self.cardRequest then
    self.cardRequest = TacticalCardUtil.CreateOneCardItem(self, cardData.template.type, self.cardIcon_container, function(cardItem)
      cardItem:SetData(cardData, DISPLAY_CONFIG)
      cardItem:SetActive(true)
      self.cardItem = cardItem
      local scale = cardData.cardType == TacticalCardType.Core and 1 or 1.26
      cardItem:SetLocalScaleXYZ(scale, scale, scale)
    end)
  end
end

function UITCCardViewPanelView:UpdateStar(cardData)
  self.stars:ReInit(cardData:GetStar(), cardData:GetMaxStar())
end

function UITCCardViewPanelView:UpdateSkill()
  local skillList = self.cardData:GetSkillList()
  if self.cardData:IsUseNewSkillDesc() and skillList and 1 < #skillList then
    skillList = {
      skillList[1]
    }
  end
  local curSkillCount = 0
  if self.skillComps then
    curSkillCount = #self.skillComps
  end
  local toChange = #skillList - curSkillCount
  if 0 < toChange then
    for i = 1, toChange do
      local skillComp = self.skills:LoadComponentAsync(CoreCardSkillItem, CoreCardSkillItemPrefabPath, self.skills)
      if not self.skillComps then
        self.skillComps = {}
      end
      table.insert(self.skillComps, skillComp)
    end
  elseif toChange < 0 and self.skillComps then
    for i, v in ipairs(self.skillComps) do
      if v then
        v:SetActive(false)
      end
    end
  end
  for i = 1, #skillList do
    self.skillComps[i]:SetActive(true)
    self.skillComps[i]:UpdateSkill(skillList[i], nil, true, self.cardData)
  end
end

function UITCCardViewPanelView:UpdateAttr(cardData)
  local baseAttrs = cardData:GetBaseAttrsSorted()
  if table.IsNullOrEmpty(baseAttrs) then
    self.attrs:SetActive(false)
    return
  end
  self.attrs:SetActive(true)
  local toChange = 0
  local curAttrCount = 0
  if self.attrComps then
    curAttrCount = #self.attrComps
  end
  toChange = #baseAttrs - curAttrCount
  if 0 < toChange then
    for i = 1, toChange do
      local attrComp = self.attrs:LoadComponentAsync(CardAttrLine, CardAttrLinePrefabPath, self.attrs)
      if not self.attrComps then
        self.attrComps = {}
      end
      table.insert(self.attrComps, attrComp)
    end
  elseif toChange < 0 and self.attrComps then
    for i, v in ipairs(self.attrComps) do
      if v then
        v:SetActive(false)
      end
    end
  end
  for i = 1, #baseAttrs do
    self.attrComps[i]:SetActive(true)
    self.attrComps[i]:UpdateAttr(baseAttrs[i].id, baseAttrs[i].value, baseAttrs[i].nextValue)
  end
end

function UITCCardViewPanelView:UpdatePassiveSkills(cardData)
  local passiveSkills = cardData:GetPassiveSkillList(false)
  if not passiveSkills or #passiveSkills == 0 then
    self.passiveSkills:SetActive(false)
    return
  end
  self.passiveSkills:SetActive(true)
  local curPassiveSkillCount = 0
  if self.passiveSkillComps then
    curPassiveSkillCount = #self.passiveSkillComps
  end
  local toChange = #passiveSkills - curPassiveSkillCount
  if 0 < toChange then
    for i = 1, toChange do
      local passiveSkillComp = self.passiveSkills:LoadComponentAsync(PassiveSkillLine, PassiveSkillLinePrefabPath, self.passiveSkills)
      if not self.passiveSkillComps then
        self.passiveSkillComps = {}
      end
      table.insert(self.passiveSkillComps, passiveSkillComp)
    end
  elseif toChange < 0 and self.passiveSkillComps then
    for i, v in ipairs(self.passiveSkillComps) do
      if v then
        v:SetActive(false)
      end
    end
  end
  for i = 1, #passiveSkills do
    self.passiveSkillComps[i]:SetActive(true)
    self.passiveSkillComps[i]:UpdateSkill(passiveSkills[i].desc, passiveSkills[i].val, passiveSkills[i].nextVal, cardData)
  end
end

function UITCCardViewPanelView:UpdateRandomAttr(cardData)
  local randomAttrs = self.randomAttrs
  local randomAttrCountRange = string.split(cardData.template.attr_random_count, ";")
  if tonumber(randomAttrCountRange[1] or 1) == tonumber(randomAttrCountRange[2] or 1) then
    self.randomTitle_txt:SetLocalText("battle_card_book_random_01", tonumber(randomAttrCountRange[1]) or 1)
  else
    self.randomTitle_txt:SetLocalText("battle_card_book_random", tonumber(randomAttrCountRange[1]) or 1, tonumber(randomAttrCountRange[2]) or 1)
  end
  local toChange = 0
  local curAttrCount = 0
  if self.randomAttrComps then
    curAttrCount = #self.randomAttrComps
  end
  toChange = #randomAttrs - curAttrCount
  if 0 < toChange then
    for i = 1, toChange do
      local attrComp = self.random_attrs:LoadComponentAsync(CardAttrLine, CardAttrLinePrefabPath, self.random_attrs)
      if not self.randomAttrComps then
        self.randomAttrComps = {}
      end
      table.insert(self.randomAttrComps, attrComp)
    end
  elseif toChange < 0 and self.randomAttrComps then
    for i, v in ipairs(self.randomAttrComps) do
      if v then
        v:SetActive(false)
      end
    end
  end
  if self.randomAttrComps then
    for i = 1, #randomAttrs do
      self.randomAttrComps[i]:SetActive(true)
      self.randomAttrComps[i]:UpdateAttr(randomAttrs[i].id, randomAttrs[i].min, randomAttrs[i].max, randomAttrs[i].name, randomAttrs[i].quality)
    end
  end
end

function UITCCardViewPanelView:OnGetMore_btnClick()
  self.ctrl:CloseSelf()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardBoxPanel)
end

UITCCardViewPanelView.OnCreate = OnCreate
UITCCardViewPanelView.OnDestroy = OnDestroy
UITCCardViewPanelView.OnEnable = OnEnable
UITCCardViewPanelView.OnDisable = OnDisable
UITCCardViewPanelView.ComponentDefine = ComponentDefine
UITCCardViewPanelView.ComponentDestroy = ComponentDestroy
UITCCardViewPanelView.DataDefine = DataDefine
UITCCardViewPanelView.DataDestroy = DataDestroy
UITCCardViewPanelView.OnAddListener = OnAddListener
UITCCardViewPanelView.OnRemoveListener = OnRemoveListener
UITCCardViewPanelView.OnMask_btnClick = OnMask_btnClick
UITCCardViewPanelView.OnClose_btnClick = OnClose_btnClick
return UITCCardViewPanelView
