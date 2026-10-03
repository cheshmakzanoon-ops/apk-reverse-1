local baseToggle = UIToggle
local LWSeasonComboBoxItem = BaseClass("LWSeasonComboBoxItem", baseToggle)
local base = UIBaseContainer
local LWSeasonComboBox = BaseClass("LWSeasonComboBox", base)
local select_mode_txt_path = "SelectModeTxt"
local arrow_path = "Arrow"
local select_mode_btn1_path = "SelectModeBtn1"
local item_list_path = "ItemList"
local select_mode_btn2_path = "ItemList/SelectModeBtn2"
local item_path = "ItemList/Item"
local divide_path = "ItemList/divide"

function LWSeasonComboBox:OnCreate()
  base.OnCreate(self)
  self.funSelectedIndexChange = nil
  self.select_mode_txt = self:AddComponent(UITextMeshProUGUIEx, select_mode_txt_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.content = self:AddComponent(UIBaseContainer, item_list_path)
  self.select_mode_btn1 = self:AddComponent(UIButton, select_mode_btn1_path)
  self.select_mode_btn2 = self:AddComponent(UIButton, select_mode_btn2_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.theDivide = self.transform:Find(divide_path).gameObject
  self.theDivide:GameObjectCreatePool()
  self.select_mode_btn1:SetOnClick(function()
    DOTween.To(function()
      return 0
    end, function(scale)
      self.content:SetLocalScaleXYZ(1, scale, 1)
    end, 1, 0.2)
  end)
  self.select_mode_btn2:SetOnClick(function()
    self:HideList()
  end)
  self.content:SetLocalScaleXYZ(1, 0, 1)
end

function LWSeasonComboBox:HideList()
  DOTween.To(function()
    return 1
  end, function(scale)
    self.content:SetLocalScaleXYZ(1, scale, 1)
  end, 0, 0.2):SetEase(CS.DG.Tweening.Ease.InExpo)
end

function LWSeasonComboBox:OnDestroy()
  self.content:RemoveComponents(LWSeasonComboBoxItem)
  self.theItem:GameObjectRecycleAll()
  self.theDivide:GameObjectRecycleAll()
  self.funSelectedIndexChange = nil
  self.select_mode = nil
  self.select_mode_txt = nil
  self.arrow = nil
  self.select_mode_btn1 = nil
  self.content = nil
  self.select_mode_btn2 = nil
  self.item = nil
  self.divide = nil
  base.OnDestroy(self)
end

function LWSeasonComboBox:FillData(dataList, defaultIndex)
  local goItem, theToggle
  local itemCount = #dataList
  local toggleList = {}
  self.content:RemoveComponents(LWSeasonComboBoxItem)
  self.theItem:GameObjectRecycleAll()
  self.theDivide:GameObjectRecycleAll()
  self.dataList = dataList
  self.selectIndex = 0
  if defaultIndex == nil then
    defaultIndex = 1
  end
  for i, data in ipairs(dataList) do
    local theIndex = i
    goItem = self.theItem:GameObjectSpawn(self.content.transform)
    goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
    goItem:SetActive(true)
    theToggle = self.content:AddComponent(LWSeasonComboBoxItem, goItem.name)
    theToggle:ReInit(i, data, self)
    if itemCount > theIndex then
      goItem = self.theDivide:GameObjectSpawn(self.content.transform)
      goItem:SetActive(true)
    end
    table.insert(toggleList, theToggle)
  end
  self.toggleList = toggleList
  self.itemCount = itemCount
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  self:SelectItem(defaultIndex)
end

function LWSeasonComboBox:SelectItem(index)
  if self.selectIndex ~= index and self.toggleList ~= nil and self.dataList ~= nil and self.itemCount ~= nil and index ~= nil and 0 < index and index <= self.itemCount then
    local theToggle = self.toggleList[index]
    local theData = self.dataList[index]
    if theToggle and theData then
      theToggle:SetIsOn(true)
      self.selectIndex = index
      if self.select_mode_txt then
        if theData.isLocal == true then
          self.select_mode_txt:SetText(theData.txt)
        else
          self.select_mode_txt:SetLocalText(theData.txt)
        end
      end
      if self.funSelectedIndexChange then
        pcall(self.funSelectedIndexChange, index, theData)
      end
    end
  end
  self.content:SetLocalScaleXYZ(1, 0, 1)
end

function LWSeasonComboBox:SelectedIndexChanged(callback)
  self.funSelectedIndexChange = callback
end

function LWSeasonComboBoxItem:OnCreate()
  baseToggle.OnCreate(self)
  self.theTextOn = self:AddComponent(UITextMeshProUGUIEx, "Txt_On")
  self.theTextOff = self:AddComponent(UITextMeshProUGUIEx, "Txt_Off")
  self.theBtn = self:AddComponent(UIButton, "Btn")
  self.theBtn:SetOnClick(function()
    if self.theView and self.theIndex and self.theView.SelectItem then
      self.theView:SelectItem(self.theIndex)
    end
  end)
  self:SetOnValueChanged(function(isOn)
    self.theTextOn:SetActive(isOn)
    self.theTextOff:SetActive(not isOn)
  end)
end

function LWSeasonComboBoxItem:OnDestroy()
  self.theIndex = nil
  self.theData = nil
  self.theView = nil
  self.theTextOn = nil
  self.theTextOff = nil
  baseToggle.OnDestroy(self)
end

function LWSeasonComboBoxItem:SetIsOn(tf)
  baseToggle.SetIsOn(self, tf)
  self.theTextOn:SetActive(tf)
  self.theTextOff:SetActive(not tf)
end

function LWSeasonComboBoxItem:SetIsOnWithoutNotify(tf)
  baseToggle.SetIsOnWithoutNotify(self, tf)
  self.theTextOn:SetActive(tf)
  self.theTextOff:SetActive(not tf)
end

function LWSeasonComboBoxItem:ReInit(index, data, view)
  local isOn = self:GetIsOn()
  self.theIndex = index
  self.theData = data
  self.theView = view
  if data.isLocal == true then
    self.theTextOn:SetText(data.txt)
    self.theTextOff:SetText(data.txt)
  else
    self.theTextOn:SetLocalText(data.txt)
    self.theTextOff:SetLocalText(data.txt)
  end
  self.theTextOn:SetActive(isOn)
  self.theTextOff:SetActive(not isOn)
end

return LWSeasonComboBox
