local MenuSelectItem = BaseClass("MenuSelectItem", UIBaseContainer)
local base = UIBaseContainer
local selected_icon_path = "SelectedIcon"
local selected_bg_path = "SelectedBg"
local model_num_img_path = "ModelNumContent/modelNumImg"
local lock_img_path = "ModelNumContent/modelNumImg/lockImg"
local model_num_txt_path = "ModelNumContent/ModelNumTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.selected_icon = self:AddComponent(UIImage, selected_icon_path)
  self.selected_bg = self:AddComponent(UIImage, selected_bg_path)
  self.model_num_img = self:AddComponent(UIImage, model_num_img_path)
  self.lock_img = self:AddComponent(UIImage, lock_img_path)
  self.model_num_txt = self:AddComponent(UITextMeshProUGUIEx, model_num_txt_path)
end

local function SetData(self, data)
  self.data = data
  local isSelect = self.data.selectId == self.data.id
  self.selected_icon:SetActive(isSelect)
  self.selected_bg:SetActive(isSelect)
  if isSelect then
    self.model_num_txt:SetColorRGBA255(42, 40, 48, 255)
  else
    self.model_num_txt:SetColorRGBA255(149, 147, 160, 255)
  end
  self.model_num_txt:SetText("\195\151" .. self.data.num)
  local isUnlock = self.data.isUnlock
  self.lock_img:SetActive(not isUnlock)
  if isUnlock then
    self.model_num_img:SetColorRGBA255(255, 255, 255, 255)
  else
    self.model_num_img:SetColorRGBA255(100, 100, 100, 255)
  end
  self.model_num_img:LoadSprite(GiftSystemConst.GetIconPath(self.data.icon))
  self.model_num_img:SetSizeDeltaXY(56, 56)
end

local function OnBtnClick(self)
  local isSelect = self.data.selectId == self.data.id
  if isSelect then
    return
  end
  local isUnlock = self.data.isUnlock
  if not isUnlock then
    UIUtil.ShowTipsId("gift_tips_1")
    return
  end
  self.view:OnMenuHideMsg()
  if self.data.clickFunc then
    self.data.clickFunc(self.data.num)
  end
end

MenuSelectItem.OnCreate = OnCreate
MenuSelectItem.SetData = SetData
MenuSelectItem.OnBtnClick = OnBtnClick
return MenuSelectItem
