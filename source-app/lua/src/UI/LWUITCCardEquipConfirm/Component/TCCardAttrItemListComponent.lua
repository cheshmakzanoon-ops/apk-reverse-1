local TCCardAttrItemListComponent = BaseClass("TCCardAttrItemListComponent", UIBaseContainer)
local TCCardAttrItemComponentAsync = require("UI.LWUITCCardEquipConfirm.Component.TCCardAttrItemComponentAsync")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_text_path = "TitleText"
local t_c_card_attr_item_path = "TCCardAttrItem"

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
  self:ClearAllAttrItem()
end

local function DataDefine(self)
  self.itemList = {}
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TCCardAttrItemListComponent:SetData(attrInfo, titleKey, cardData)
  if not attrInfo then
    return
  end
  for k, v in ipairs(attrInfo) do
    local item = self.itemList[k]
    if not item then
      item = self:LoadComponentAsync(TCCardAttrItemComponentAsync, TCCardAttrItemComponentAsync.PrefabPath)
      table.insert(self.itemList, item)
    end
    item:SetActive(true)
    local name, value = TacticalCardUtil.GetCardAttrValue(v.id, v.value)
    if cardData and not cardData:IsCoreCard() then
      local quality = DataCenter.TacticalCardDataManager:GetCardAttributeQualityByValue(v.id, v.value)
      local format = DataCenter.TacticalCardDataManager:GetAttributeQualityColor(quality)
      name = string.format(format, name)
    end
    item:SetData(name, value)
  end
  if #self.itemList > #attrInfo then
    for i = #attrInfo + 1, #self.itemList do
      self.itemList[i]:SetActive(false)
    end
  end
  if titleKey then
    self.titleText:SetLocalText(titleKey)
  end
end

function TCCardAttrItemListComponent:ClearAllAttrItem()
  for i = 1, #self.itemList do
    self:RemoveAsyncComponent(self.itemList[i])
  end
  self.itemList = {}
end

TCCardAttrItemListComponent.OnCreate = OnCreate
TCCardAttrItemListComponent.OnDestroy = OnDestroy
TCCardAttrItemListComponent.OnEnable = OnEnable
TCCardAttrItemListComponent.OnDisable = OnDisable
TCCardAttrItemListComponent.ComponentDefine = ComponentDefine
TCCardAttrItemListComponent.ComponentDestroy = ComponentDestroy
TCCardAttrItemListComponent.DataDefine = DataDefine
TCCardAttrItemListComponent.DataDestroy = DataDestroy
TCCardAttrItemListComponent.OnAddListener = OnAddListener
TCCardAttrItemListComponent.OnRemoveListener = OnRemoveListener
return TCCardAttrItemListComponent
