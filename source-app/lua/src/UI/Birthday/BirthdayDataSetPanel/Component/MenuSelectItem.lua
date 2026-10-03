local MenuSelectItem = BaseClass("MenuSelectItem", UIBaseContainer)
local base = UIBaseContainer
local btn_txt_path = "BtnText"
local selected_icon_path = "SelectedIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self.btn_txt = self:AddComponent(UITextMeshProUGUIEx, btn_txt_path)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.selected_icon = self:AddComponent(UIImage, selected_icon_path)
  self.rootLayout = self:AddComponent(UILayoutElement, "")
end

local function SetData(self, str, key, selectKey, clickFunc, itemH)
  self.str = str
  self.key = key
  self.selectKey = selectKey
  self.clickFunc = clickFunc
  self.rootLayout:SetMinHeight(itemH)
  self.rootLayout:SetPreferredHeight(itemH)
  if self.selectKey ~= nil and self.key == self.selectKey then
    self.btn_txt:SetColorHex("2a2830")
  else
    self.btn_txt:SetColorHex("736863")
  end
  self.btn_txt:SetText(self.str)
  self.selected_icon:SetActive(self.selectKey ~= nil and self.key == self.selectKey)
end

local function OnBtnClick(self)
  if self.clickFunc then
    self.clickFunc(self.key)
  end
end

MenuSelectItem.OnCreate = OnCreate
MenuSelectItem.SetData = SetData
MenuSelectItem.OnBtnClick = OnBtnClick
return MenuSelectItem
