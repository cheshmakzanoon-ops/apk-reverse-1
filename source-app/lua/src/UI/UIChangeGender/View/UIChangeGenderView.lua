local UIChangeGenderView = BaseClass("UIChangeGenderView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local close_panel_path = "Panel"
local close_panel_path_2 = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local title_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local reminds_path = "Root/Content/RemindsTxt"
local male_selected_img_path = "Root/Content/MaleItem/MaleSelect/MaleSelected"
local male_click_btn_path = "Root/Content/MaleItem/MaleSelect"
local female_selected_img_path = "Root/Content/FemaleItem/FemaleSelect/FemaleSelected"
local female_click_btn_path = "Root/Content/FemaleItem/FemaleSelect"
local noShow_selected_txt_path = "Root/Content/NoShowItem/NoShowDesc"
local noShow_selected_img_path = "Root/Content/NoShowItem/NoShowSelect/NoShowSelected"
local noShow_click_btn_path = "Root/Content/NoShowItem/NoShowSelect"
local confirm_btn_path = "Root/Content/ConfirmButton"
local confirm_txt_path = "Root/Content/ConfirmButton/ConfirmTitleTxt"
local BUTTON_SHORT_WIDTH = 210
local BUTTON_LONG_WIDTH = 320
local TXT_SHORT_OFFSET_X = 0
local TXT_LONG_OFFSET_X = -65

local function OnCreate(self)
  base.OnCreate(self)
  self.close_btn = self:AddComponent(UIButton, close_panel_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn_2 = self:AddComponent(UIButton, close_panel_path_2)
  self.close_btn_2:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText(110276)
  self.reminds_txt = self:AddComponent(UIText, reminds_path)
  self.reminds_txt:SetLocalText(110279)
  self.male_selected_img_obj = self:AddComponent(UIBaseContainer, male_selected_img_path)
  self.male_selected_btn = self:AddComponent(UIButton, male_click_btn_path)
  self.male_selected_btn:SetOnClick(BindCallback(self, self.OnGenderTypeClick, 1))
  self.female_selected_img_obj = self:AddComponent(UIBaseContainer, female_selected_img_path)
  self.female_selected_btn = self:AddComponent(UIButton, female_click_btn_path)
  self.female_selected_btn:SetOnClick(BindCallback(self, self.OnGenderTypeClick, 2))
  self.noShow_click_btn = self:AddComponent(UIButton, noShow_click_btn_path)
  self.noShow_click_btn:SetOnClick(BindCallback(self, self.OnGenderTypeClick, 3))
  self.noShow_selected_img_obj = self:AddComponent(UIBaseContainer, noShow_selected_img_path)
  self.noShow_selected_txt = self:AddComponent(UIText, noShow_selected_txt_path)
  self.noShow_selected_txt:SetLocalText("profile_gender_not_show")
  self.confirm_btn_obj = self:AddComponent(UIBaseContainer, confirm_btn_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn:SetOnClick(BindCallback(self, self.OnConfirmClick))
  self.confirm_txt_obj = self:AddComponent(UIBaseContainer, confirm_txt_path)
  self.confirm_txt = self:AddComponent(UIText, confirm_txt_path)
  self.confirm_txt:SetLocalText(110046)
  self:OnInitRefresh()
end

local function OnDestroy(self)
  self.close_btn = nil
  self.close_btn_2 = nil
  self.title = nil
  self.reminds_txt = nil
  self.male_selected_img_obj = nil
  self.male_selected_btn = nil
  self.female_selected_img_obj = nil
  self.female_selected_btn = nil
  self.noShow_click_btn = nil
  self.noShow_selected_img_obj = nil
  self.noShow_selected_txt = nil
  self.confirm_btn_obj = nil
  self.confirm_btn = nil
  self.confirm_txt_obj = nil
  self.confirm_txt = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:OnRefresh()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnInitRefresh(self)
  self.male_selected_img_obj:SetActive(false)
  self.female_selected_img_obj:SetActive(false)
  self.noShow_selected_img_obj:SetActive(false)
  self.confirm_btn_obj:SetSizeDelta(Vector2.New(BUTTON_SHORT_WIDTH, self.confirm_btn_obj:GetSizeDelta().y))
  self.confirm_txt_obj:SetLocalPosition(Vector3.New(TXT_SHORT_OFFSET_X, self.confirm_txt_obj:GetLocalPosition().y, self.confirm_txt_obj:GetLocalPosition().z))
end

local function OnRefresh(self)
  self.cur_gender = LuaEntry.Player:GetGender()
  self.cur_gender = self.cur_gender or 0
  self:OnGenderRefresh()
end

local function OnGenderRefresh(self)
  local cur_gender = self.cur_gender
  self.male_selected_img_obj:SetActive(cur_gender == 1)
  self.female_selected_img_obj:SetActive(cur_gender == 2)
  self.noShow_selected_img_obj:SetActive(cur_gender == 3)
end

local function OnButtonRefresh(self)
  local cur_gender = self.cur_gender
  if cur_gender == 0 then
    return
  end
  if cur_gender == LuaEntry.Player:GetGender() then
    UIGray.SetGray(self.confirm_btn_obj.transform, true, false)
  else
    UIGray.SetGray(self.confirm_btn_obj.transform, false, true)
  end
  self.pay_type = self.ctrl:GetPayType()
  if self.pay_type == 0 then
    self.confirm_btn_obj:SetSizeDelta(Vector2.New(BUTTON_SHORT_WIDTH, self.confirm_btn_obj:GetSizeDelta().y))
    self.confirm_txt_obj:SetLocalPosition(Vector3.New(TXT_SHORT_OFFSET_X, self.confirm_txt_obj:GetLocalPosition().y, self.confirm_txt_obj:GetLocalPosition().z))
    self.confirm_diamond_icon_obj:SetActive(false)
  elseif self.pay_type == 1 then
    self.consume_diamond = self.ctrl:GetConsumeDiamond()
    self.confirm_btn_obj:SetSizeDelta(Vector2.New(BUTTON_LONG_WIDTH, self.confirm_btn_obj:GetSizeDelta().y))
    self.confirm_txt_obj:SetLocalPosition(Vector3.New(TXT_LONG_OFFSET_X, self.confirm_txt_obj:GetLocalPosition().y, self.confirm_txt_obj:GetLocalPosition().z))
    self.confirm_diamond_icon_obj:SetActive(true)
    self.confirm_diamond_icon:LoadSprite(string.format(LoadPath.LWCommonPath, diamondIcon))
    self.confirm_diamond_num:SetText(self.consume_diamond)
  end
end

local function OnGenderTypeClick(self, genderType)
  local new_gender = genderType
  if new_gender == self.cur_gender then
    return
  end
  self.cur_gender = new_gender
  self:OnGenderRefresh()
end

local function OnConfirmClick(self)
  self.ctrl:SendChangeGenderMessage(self.cur_gender)
  self.ctrl:CloseSelf()
end

UIChangeGenderView.OnCreate = OnCreate
UIChangeGenderView.OnDestroy = OnDestroy
UIChangeGenderView.OnEnable = OnEnable
UIChangeGenderView.OnDisable = OnDisable
UIChangeGenderView.OnInitRefresh = OnInitRefresh
UIChangeGenderView.OnRefresh = OnRefresh
UIChangeGenderView.OnGenderRefresh = OnGenderRefresh
UIChangeGenderView.OnButtonRefresh = OnButtonRefresh
UIChangeGenderView.OnGenderTypeClick = OnGenderTypeClick
UIChangeGenderView.OnConfirmClick = OnConfirmClick
return UIChangeGenderView
