local TCCommonDropDownComponent = BaseClass("TCCommonDropDownComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TCCommonDropDownItemComponent = require("UI.LWUITC.Component.TCCommonDropDownItemComponent")
local btn_text_path = "BtnText"
local expand_area_path = "ExpandArea"
local close_expand_btn_path = "ExpandArea/CloseExpandBtn"
local t_c_common_drop_down_item_path = "TCCommonDropDownItem"
local item_content_path = "ExpandArea/ItemContent"

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
  self.expandBtn = self:AddComponent(UIButton, "")
  self.expandBtn:SetOnClick(function()
    self:ShowExpandArea()
  end)
  self.hideExpandBtn = self:AddComponent(UIButton, close_expand_btn_path)
  self.hideExpandBtn:SetOnClick(function()
    self:HideExpandArea()
  end)
  self.expandAreaObj = self:AddComponent(UIBaseContainer, expand_area_path)
  self.btnText = self:AddComponent(UIText, btn_text_path)
  self.dropdownItemObj = self:AddComponent(UIBaseContainer, t_c_common_drop_down_item_path).gameObject
  self.dropdownItemObj:GameObjectCreatePool()
  self.itemContent = self:AddComponent(UIBaseContainer, item_content_path)
end

local function ComponentDestroy(self)
  self:Clear()
end

local function DataDefine(self)
  self.optionDataList = {}
  self.optionItemList = {}
  self.curSelectIndex = 1
end

local function DataDestroy(self)
  self.optionDataList = nil
  self.optionItemList = nil
  self.curSelectIndex = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TCCommonDropDownComponent:ShowExpandArea()
  self.expandAreaObj:SetActive(true)
end

function TCCommonDropDownComponent:HideExpandArea()
  self.expandAreaObj:SetActive(false)
end

function TCCommonDropDownComponent:Add(optionLoc, isHorseLamp)
  if not optionLoc then
    return
  end
  local optionObj = self.dropdownItemObj:GameObjectSpawn(self.itemContent.transform)
  local name = tostring(NameCount)
  NameCount = NameCount + 1
  optionObj.name = name
  local optionItem = self.itemContent:AddComponent(TCCommonDropDownItemComponent, name)
  local index = #self.optionItemList + 1
  local isSelect = self.curSelectIndex == index
  optionItem:SetData(index, optionLoc, isHorseLamp)
  optionItem:SetSelectState(isSelect)
  if isSelect then
    self:SetSelectIndex(index)
  end
  optionItem:BlindClickCallback(function(newIndex)
    self:OnSelectIndexChange(newIndex)
  end)
  table.insert(self.optionItemList, optionItem)
  table.insert(self.optionDataList, optionLoc)
end

function TCCommonDropDownComponent:Clear()
  self.itemContent:RemoveComponents(TCCommonDropDownItemComponent)
  self.dropdownItemObj:GameObjectRecycleAll()
  self.optionItemList = {}
  self.onDropdownValueChangeFunc = nil
end

function TCCommonDropDownComponent:SetSelectIndex(index)
  self.curSelectIndex = index
  self:RefreshSelectState()
  local curSelectLoc = self.optionDataList[self.curSelectIndex]
  if curSelectLoc then
    self.btnText:SetText(curSelectLoc)
  else
    self.btnText:SetText("")
  end
end

function TCCommonDropDownComponent:RefreshSelectState()
  for index, v in ipairs(self.optionItemList) do
    local isSelect = self.curSelectIndex == index
    v:SetSelectState(isSelect)
  end
end

function TCCommonDropDownComponent:BindIndexChangeEvent(onDropdownValueChangeFunc)
  self.onDropdownValueChangeFunc = onDropdownValueChangeFunc
end

function TCCommonDropDownComponent:OnSelectIndexChange(newIndex)
  self:SetSelectIndex(newIndex)
  self:HideExpandArea()
  if self.onDropdownValueChangeFunc then
    self.onDropdownValueChangeFunc(newIndex)
  end
end

TCCommonDropDownComponent.OnCreate = OnCreate
TCCommonDropDownComponent.OnDestroy = OnDestroy
TCCommonDropDownComponent.OnEnable = OnEnable
TCCommonDropDownComponent.OnDisable = OnDisable
TCCommonDropDownComponent.ComponentDefine = ComponentDefine
TCCommonDropDownComponent.ComponentDestroy = ComponentDestroy
TCCommonDropDownComponent.DataDefine = DataDefine
TCCommonDropDownComponent.DataDestroy = DataDestroy
TCCommonDropDownComponent.OnAddListener = OnAddListener
TCCommonDropDownComponent.OnRemoveListener = OnRemoveListener
return TCCommonDropDownComponent
