local UILWWorldTipTab = BaseClass("UILWWorldTipTab", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local normal_label_path = "normalLabel"
local selected_path = "selected"
local selected_label_path = "selected/selectedLabel"
local btn_path = "btn"

function UILWWorldTipTab:OnCreate()
  base.OnCreate(self)
  self.normal_label = self:AddComponent(UITextMeshProUGUIEx, normal_label_path)
  self.selected = self:AddComponent(UIImage, selected_path)
  self.selected_label = self:AddComponent(UITextMeshProUGUIEx, selected_label_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
end

function UILWWorldTipTab:OnDestroy()
  self.normal_label = nil
  self.selected = nil
  self.selected_label = nil
  self.btn = nil
  base.OnDestroy(self)
end

function UILWWorldTipTab:SetData(data, index)
  self.index = index
  self.normal_label:SetLocalText(data.title_key)
  self.selected_label:SetLocalText(data.title_key)
  self.selected:SetActive(false)
end

function UILWWorldTipTab:SetUnSelected()
  self.selected:SetActive(false)
end

function UILWWorldTipTab:SetSelected()
  self.selected:SetActive(true)
end

function UILWWorldTipTab:OnClick()
  self.view:OnTabClick(self.index)
end

return UILWWorldTipTab
