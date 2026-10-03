local CoreCardInfo = BaseClass("CoreCardInfo", UIBaseContainer)
local base = UIBaseContainer
local CardAttrLine = require("UI.LWUITC.UITCCardDetailPanel.Component.CardAttrLineAsync")
local CardAttrLinePrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CardAttrLine.prefab"
local CoreCardSkillItem = require("UI.LWUITC.UITCCardDetailPanel.Component.CoreCardSkillItem")
local CoreCardSkillItemPrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CoreCardSkillItem.prefab"
local StarListItem = require("UI.LWUITCCardMain.Component.TCStarListItemComponent")

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
  self.close_btn = self:AddComponent(UIButton, "CloseBtn")
  self.close_btn:SetOnClick(function()
    self:OnClose_btnClick()
  end)
  self.cardIcon_container = self:AddComponent(UIBaseContainer, "content/shared/card")
  self.cardName_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/cardName_txt")
  self.cardType_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/cardType_txt")
  self.attrs = self:AddComponent(UIBaseContainer, "content/core_card/areas/viewport/content/basic_attrs")
  self.skills = self:AddComponent(UIBaseContainer, "content/core_card/areas/viewport/content/skill_area")
  self.power_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/PowerInfo/PowerNumberText")
  self.stars = self:AddComponent(StarListItem, "content/core_card/areas/viewport/content/star_area/star/stars")
  self.lv_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/cardLv_txt")
end

local function ComponentDestroy(self)
  self:RemoveCardItem()
  self.close_btn = nil
  self.cardIcon_container = nil
  self.cardName_txt = nil
  self.cardType_txt = nil
  self.attrs = nil
  self.skills = nil
  self.power_txt = nil
  self.stars = nil
  self.lv_txt = nil
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

function CoreCardInfo:RemoveCardItem()
  if self.cardRequest then
    self.cardIcon_container:RemoveAllComponentes()
    self.cardRequest:Destroy()
    self.cardRequest = nil
  end
end

function CoreCardInfo:UpdateView(cardData)
  self.cardData = cardData
  self:UpdateBaseInfo(cardData)
  self:UpdateStar(cardData)
  self:UpdateSkill(cardData)
  self:UpdateAttr(cardData)
end

local DISPLAY_CONFIG = {
  isDeluxeShow = true,
  isShowLv = false,
  isShowStar = false
}

function CoreCardInfo:UpdateBaseInfo(cardData)
  self.cardName_txt:SetLocalText(cardData.template.name)
  self.cardType_txt:SetText(TacticalCardUtil.GetCardTypeNameStr(cardData.template.type))
  self.power_txt:SetText(cardData:GetPower())
  self.lv_txt:SetText(TacticalCardUtil.GetLevelStr(cardData))
  if self.cardItem then
    self.cardItem:SetData(cardData, DISPLAY_CONFIG)
  elseif not self.cardRequest then
    self.cardRequest = TacticalCardUtil.CreateOneCardItem(self, cardData.template.type, self.cardIcon_container, function(cardItem)
      cardItem:SetData(cardData, DISPLAY_CONFIG)
      cardItem:SetActive(true)
      self.cardItem = cardItem
    end)
  end
end

function CoreCardInfo:UpdateStar(cardData)
  self.stars:ReInit(cardData:GetStar(), cardData:GetMaxStar())
end

function CoreCardInfo:UpdateSkill()
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

function CoreCardInfo:UpdateAttr(cardData)
  local baseAttrs = cardData:GetBaseAttrsSorted()
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

function CoreCardInfo:OnClose_btnClick()
  self.view.ctrl:CloseSelf()
end

CoreCardInfo.OnCreate = OnCreate
CoreCardInfo.OnDestroy = OnDestroy
CoreCardInfo.OnEnable = OnEnable
CoreCardInfo.OnDisable = OnDisable
CoreCardInfo.ComponentDefine = ComponentDefine
CoreCardInfo.ComponentDestroy = ComponentDestroy
CoreCardInfo.DataDefine = DataDefine
CoreCardInfo.DataDestroy = DataDestroy
CoreCardInfo.OnAddListener = OnAddListener
CoreCardInfo.OnRemoveListener = OnRemoveListener
return CoreCardInfo
