local TCPassiveBaseAttrInfoComponent = BaseClass("TCPassiveBaseAttrInfoComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TCCardAttrItemComponentAsync = require("UI.LWUITCCardEquipConfirm.Component.TCCardAttrItemComponentAsync")
local title_text_path = "TitleText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearAttrItems()
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
  self.baseAttrItemList = {}
end

local function DataDestroy(self)
  self.baseAttrItemList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TCPassiveBaseAttrInfoComponent:SetData(baseAttrs, titleTextKey)
  if not baseAttrs then
    return
  end
  if titleTextKey then
    self.titleText:SetLocalText(titleTextKey)
  end
  local baseAttrItemIndex = 1
  for _, attrData in ipairs(baseAttrs) do
    local baseAttrItem = self.baseAttrItemList[baseAttrItemIndex]
    if not baseAttrItem then
      baseAttrItem = self:LoadComponentAsync(TCCardAttrItemComponentAsync, TCCardAttrItemComponentAsync.PrefabPath)
      table.insert(self.baseAttrItemList, baseAttrItem)
    end
    baseAttrItem:SetActive(true)
    baseAttrItemIndex = baseAttrItemIndex + 1
    local name, value = TacticalCardUtil.GetCardAttrValue(attrData.id, attrData.value)
    baseAttrItem:SetData(name, value)
  end
  if baseAttrItemIndex < #self.baseAttrItemList then
    for i = baseAttrItemIndex, #self.baseAttrItemList do
      self.baseAttrItemList[i]:SetActive(false)
    end
  end
end

function TCPassiveBaseAttrInfoComponent:ClearAttrItems()
  for i = 1, #self.baseAttrItemList do
    self:RemoveAsyncComponent(self.baseAttrItemList[i])
  end
  self.baseAttrItemList = {}
end

TCPassiveBaseAttrInfoComponent.OnCreate = OnCreate
TCPassiveBaseAttrInfoComponent.OnDestroy = OnDestroy
TCPassiveBaseAttrInfoComponent.OnEnable = OnEnable
TCPassiveBaseAttrInfoComponent.OnDisable = OnDisable
TCPassiveBaseAttrInfoComponent.ComponentDefine = ComponentDefine
TCPassiveBaseAttrInfoComponent.ComponentDestroy = ComponentDestroy
TCPassiveBaseAttrInfoComponent.DataDefine = DataDefine
TCPassiveBaseAttrInfoComponent.DataDestroy = DataDestroy
TCPassiveBaseAttrInfoComponent.OnAddListener = OnAddListener
TCPassiveBaseAttrInfoComponent.OnRemoveListener = OnRemoveListener
return TCPassiveBaseAttrInfoComponent
