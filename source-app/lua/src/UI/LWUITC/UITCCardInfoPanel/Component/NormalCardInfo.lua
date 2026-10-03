local NormalCardInfo = BaseClass("NormalCardInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local CardAttrLine = require("UI.LWUITC.UITCCardDetailPanel.Component.CardAttrLineAsync")
local CardAttrLinePrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CardAttrLine.prefab"
local PassiveSkillLine = require("UI.LWUITC.UITCCardDetailPanel.Component.PassiveSkillLineAsync")
local PassiveSkillLinePrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/PassiveSkillLine.prefab"

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
  self.cardName_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/cardName_txt")
  self.cardType_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/cardType_txt")
  self.power_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/PowerInfo/PowerNumberText")
  self.passiveSkills = self:AddComponent(UIBaseContainer, "content/common_card/attrs/viewport/content/basic_attrs/passive_conatiner")
  self.randomAttrs = self:AddComponent(UIBaseContainer, "content/common_card/attrs/viewport/content/random_attrs")
  self.cardIcon_container = self:AddComponent(UIBaseContainer, "content/shared/card")
  self.basicAttrs = self:AddComponent(UIBaseContainer, "content/common_card/attrs/viewport/content/basic_attrs/attr_container")
  self.lv_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/cardLv_txt")
end

local function ComponentDestroy(self)
  self:RemoveCardItem()
  self.close_btn = nil
  self.cardName_txt = nil
  self.cardType_txt = nil
  self.power_txt = nil
  self.passiveSkills = nil
  self.randomAttrs = nil
  self.cardIcon_container = nil
  self.basicAttrs = nil
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

function NormalCardInfo:RemoveCardItem()
  if self.cardRequest then
    self.cardIcon_container:RemoveAllComponentes()
    self.cardRequest:Destroy()
    self.cardRequest = nil
  end
end

function NormalCardInfo:UpdateView(cardData)
  self.cardData = cardData
  self:UpdateBaseInfo(cardData)
  self:UpdateAttrs(cardData)
end

local DISPLAY_CONFIG = {
  isDeluxeShow = true,
  isShowLv = false,
  isShowStar = false
}

function NormalCardInfo:UpdateBaseInfo(cardData)
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
      cardItem:SetLocalScaleXYZ(1.26, 1.26, 1.26)
    end)
  end
end

function NormalCardInfo:UpdateBasicAttrs(cardData)
  local baseAttrs = cardData:GetBaseAttrsSorted()
  local toChange = 0
  local curAttrCount = 0
  if self.attrComps then
    curAttrCount = #self.attrComps
  end
  toChange = #baseAttrs - curAttrCount
  if 0 < toChange then
    for i = 1, toChange do
      local attrComp = self.basicAttrs:LoadComponentAsync(CardAttrLine, CardAttrLinePrefabPath, self.basicAttrs)
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

function NormalCardInfo:UpdatePassiveSkills(cardData)
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

function NormalCardInfo:UpdateRandomAttrs(cardData)
  local randomAttrsArr = cardData:GetRandomAttrsSorted()
  local toChange = 0
  local curAttrCount = 0
  if self.randomAttrComps then
    curAttrCount = #self.randomAttrComps
  end
  toChange = #randomAttrsArr - curAttrCount
  if 0 < toChange then
    for i = 1, toChange do
      local attrComp = self.randomAttrs:LoadComponentAsync(CardAttrLine, CardAttrLinePrefabPath, self.randomAttrs)
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
  for i = 1, #randomAttrsArr do
    self.randomAttrComps[i]:SetActive(true)
    self.randomAttrComps[i]:UpdateAttr(randomAttrsArr[i].id, randomAttrsArr[i].value, randomAttrsArr[i].nextValue, randomAttrsArr[i].effectName, randomAttrsArr[i].quality)
  end
  if #randomAttrsArr == 0 then
    self.randomAttrs:SetActive(false)
  else
    self.randomAttrs:SetActive(true)
  end
end

function NormalCardInfo:UpdateAttrs(cardData)
  if cardData:IsUseNewSkillDesc() then
    self.basicAttrs:SetActive(false)
  else
    self.basicAttrs:SetActive(true)
    self:UpdateBasicAttrs(cardData)
  end
  self:UpdatePassiveSkills(cardData)
  self:UpdateRandomAttrs(cardData)
end

function NormalCardInfo:OnClose_btnClick()
  self.view.ctrl:CloseSelf()
end

NormalCardInfo.OnCreate = OnCreate
NormalCardInfo.OnDestroy = OnDestroy
NormalCardInfo.OnEnable = OnEnable
NormalCardInfo.OnDisable = OnDisable
NormalCardInfo.ComponentDefine = ComponentDefine
NormalCardInfo.ComponentDestroy = ComponentDestroy
NormalCardInfo.DataDefine = DataDefine
NormalCardInfo.DataDestroy = DataDestroy
NormalCardInfo.OnAddListener = OnAddListener
NormalCardInfo.OnRemoveListener = OnRemoveListener
return NormalCardInfo
