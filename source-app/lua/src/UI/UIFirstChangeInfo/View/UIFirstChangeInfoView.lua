local base = require("UI.UIChangeName.View.UIChangeNameView")
local Localization = CS.GameEntry.Localization
local male_selected_img_path = "Gender/MaleItem/MaleSelect/MaleSelected"
local male_click_btn_path = "Gender/MaleItem/MaleSelect"
local female_selected_img_path = "Gender/FemaleItem/FemaleSelect/FemaleSelected"
local female_click_btn_path = "Gender/FemaleItem/FemaleSelect"
local noShow_selected_img_path = "Gender/NoShowItem/NoShowSelect/NoShowSelected"
local noShow_click_btn_path = "Gender/NoShowItem/NoShowSelect"
local noShow_selected_txt_path = "Gender/NoShowItem/NoShowDesc"
local UIFirstChangeInfoView = BaseClass("UIFirstChangeInfoView", base)

function UIFirstChangeInfoView:OnCreate()
  base.OnCreate(self)
  self.male_selected_img_obj = self:AddComponent(UIBaseContainer, male_selected_img_path)
  self.male_selected_btn = self:AddComponent(UIButton, male_click_btn_path)
  self.male_selected_btn:SetOnClick(function()
    self:OnGenderTypeClick(1)
  end)
  self.female_selected_img_obj = self:AddComponent(UIBaseContainer, female_selected_img_path)
  self.female_selected_btn = self:AddComponent(UIButton, female_click_btn_path)
  self.female_selected_btn:SetOnClick(function()
    self:OnGenderTypeClick(2)
  end)
  self.noShow_selected_img_obj = self:AddComponent(UIBaseContainer, noShow_selected_img_path)
  self.noShow_selected_btn = self:AddComponent(UIButton, noShow_click_btn_path)
  self.noShow_selected_btn:SetOnClick(function()
    self:OnGenderTypeClick(3)
  end)
  self.noShow_selected_txt = self:AddComponent(UIText, noShow_selected_txt_path)
  self.noShow_selected_txt:SetLocalText("profile_gender_not_show")
  self:OnInitRefresh()
  self.use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChangeInfoClick()
  end)
  self.return_btn:SetOnClick(function()
  end)
end

function UIFirstChangeInfoView:OnChangeInfoClick()
  local state = self.checkState
  if self.inputValue == "" then
    UIUtil.ShowTipsId(120177)
    return
  end
  if state == CheckNameType.IllegalChar then
    UIUtil.ShowTipsId(129082)
    return
  elseif state == CheckNameType.MinNameChar or state == CheckNameType.MaxNameChar then
    UIUtil.ShowTipsId(120193)
    return
  elseif state == CheckNameType.Exist then
    UIUtil.ShowTipsId(280038)
    return
  elseif state == CheckNameType.SensitiveWords then
    UIUtil.ShowTipsId(280073)
    return
  end
  if LuaEntry.Player.renameTime < 1 then
    self.ctrl:SendChangeNameMessage(self.inputValue)
    self.cur_gender = self.cur_gender or math.random(3)
    if self.cur_gender ~= LuaEntry.Player:GetGender() then
      SFSNetwork.SendMessage(MsgDefines.GenderChange, self.cur_gender, true)
    end
    self.ctrl:CloseSelf()
    return
  end
end

function UIFirstChangeInfoView:OnGenderTypeClick(genderType)
  local new_gender = genderType
  if new_gender == self.cur_gender then
    return
  end
  self.cur_gender = new_gender
  self:OnGenderRefresh()
end

function UIFirstChangeInfoView:OnInitRefresh()
  self.cur_gender = LuaEntry.Player:GetGender()
  self.cur_gender = self.cur_gender or 0
  self:OnGenderRefresh()
end

function UIFirstChangeInfoView:OnGenderRefresh()
  local cur_gender = self.cur_gender
  self.male_selected_img_obj:SetActive(cur_gender == 1)
  self.female_selected_img_obj:SetActive(cur_gender == 2)
  self.noShow_selected_img_obj:SetActive(cur_gender == 3)
end

return UIFirstChangeInfoView
