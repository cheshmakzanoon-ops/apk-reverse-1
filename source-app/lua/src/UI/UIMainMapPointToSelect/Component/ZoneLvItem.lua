local ZoneLvItem = BaseClass("ZoneLvItem", UIBaseContainer)
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
end

local function SetData(self, lv, selectLv, clickFunc)
  self.lv = lv
  self.selectLv = selectLv
  self.clickFunc = clickFunc
  self.btn_txt:SetLocalText("alliance_announcement_2", tostring(lv))
  self.selected_icon:SetActive(self.lv == self.selectLv)
end

local function OnBtnClick(self)
  if self.clickFunc then
    self.clickFunc(self.lv)
  end
end

ZoneLvItem.OnCreate = OnCreate
ZoneLvItem.SetData = SetData
ZoneLvItem.OnBtnClick = OnBtnClick
return ZoneLvItem
