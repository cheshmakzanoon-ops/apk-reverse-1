local TCSkillInfoComponent = BaseClass("TCSkillInfoComponent", UIBaseContainer)
local CoreCardSkillItemPrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CoreCardSkillItem.prefab"
local CoreCardSkillItem = require("UI.LWUITC.UITCCardDetailPanel.Component.CoreCardSkillItem")
local TCCardAttrItemComponentAsync = require("UI.LWUITCCardEquipConfirm.Component.TCCardAttrItemComponentAsync")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_text_path = "TitleText"

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
  self.titleText = self:AddComponent(UIText, title_text_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.activeSkillItemList = {}
  self.passiveSkillItemList = {}
end

local function DataDestroy(self)
  self.activeSkillItemList = nil
  self.passiveSkillItemList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TCSkillInfoComponent:SetData(skillType, skillDataList, titleTextKey, cardData)
  if not skillDataList then
    return
  end
  if titleTextKey then
    self.titleText:SetLocalText(titleTextKey)
  end
  for _, v in ipairs(self.activeSkillItemList) do
    v:SetActive(false)
  end
  for _, v in ipairs(self.passiveSkillItemList) do
    v:SetActive(false)
  end
  local activeSkillItemIndex = 1
  local passiveSkillItemIndex = 1
  for _, skillData in ipairs(skillDataList) do
    if skillType == TacticalCardSkillType.Active then
      local activeSkillItem = self.activeSkillItemList[activeSkillItemIndex]
      if not activeSkillItem then
        activeSkillItem = self:LoadComponentAsync(CoreCardSkillItem, CoreCardSkillItemPrefabPath)
        table.insert(self.activeSkillItemList, activeSkillItem)
      end
      activeSkillItem:UpdateSkill(skillData.skillId, nil, nil, cardData)
      activeSkillItem:SetActive(true)
      activeSkillItemIndex = activeSkillItemIndex + 1
    elseif skillType == TacticalCardSkillType.Passive then
      local passiveSkillItem = self.passiveSkillItemList[passiveSkillItemIndex]
      if not passiveSkillItem then
        passiveSkillItem = self:LoadComponentAsync(TCCardAttrItemComponentAsync, TCCardAttrItemComponentAsync.PrefabPath)
        table.insert(self.passiveSkillItemList, passiveSkillItem)
      end
      local desc = skillData.desc
      local val = skillData.val
      if cardData and cardData:IsUseNewSkillDesc() then
        desc = cardData:GetBaseSkillDesc()
        passiveSkillItem:SetData(desc, nil)
      else
        passiveSkillItem:SetData(desc, val)
      end
      passiveSkillItem:SetActive(true)
      passiveSkillItemIndex = passiveSkillItemIndex + 1
    end
  end
end

TCSkillInfoComponent.OnCreate = OnCreate
TCSkillInfoComponent.OnDestroy = OnDestroy
TCSkillInfoComponent.OnEnable = OnEnable
TCSkillInfoComponent.OnDisable = OnDisable
TCSkillInfoComponent.ComponentDefine = ComponentDefine
TCSkillInfoComponent.ComponentDestroy = ComponentDestroy
TCSkillInfoComponent.DataDefine = DataDefine
TCSkillInfoComponent.DataDestroy = DataDestroy
TCSkillInfoComponent.OnAddListener = OnAddListener
TCSkillInfoComponent.OnRemoveListener = OnRemoveListener
return TCSkillInfoComponent
