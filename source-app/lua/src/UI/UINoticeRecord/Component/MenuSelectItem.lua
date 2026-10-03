local MenuSelectItem = BaseClass("MenuSelectItem", UIBaseContainer)
local base = UIBaseContainer
local selected_icon_path = "SelectedIcon"
local selected_bg_path = "SelectedBg"
local model_num_txt_path = "ModelNumContent/ModelNumTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.selected_icon = self:AddComponent(UIImage, selected_icon_path)
  self.selected_bg = self:AddComponent(UIImage, selected_bg_path)
  self.model_num_txt = self:AddComponent(UITextMeshProUGUIEx, model_num_txt_path)
end

local function SetData(self, data)
  self.data = data
  local isSelect = self.data.isSelect
  self.selected_icon:SetActive(isSelect)
  self.selected_bg:SetActive(isSelect)
  if isSelect then
    self.model_num_txt:SetColorRGBA255(42, 40, 48, 255)
  else
    self.model_num_txt:SetColorRGBA255(149, 147, 160, 255)
  end
  local type = self.data.type
  local filterTypeCfg = self.view.ctrl:GetFilterTypeConfig(type)
  if filterTypeCfg then
    local txtKey = filterTypeCfg.txtKey
    self.model_num_txt:SetLocalText(txtKey)
  end
end

local function OnBtnClick(self)
  local isSelect = self.data.isSelect
  if isSelect then
    return
  end
  self.view:OnFilterChange(self.data.type)
end

MenuSelectItem.OnCreate = OnCreate
MenuSelectItem.SetData = SetData
MenuSelectItem.OnBtnClick = OnBtnClick
return MenuSelectItem
