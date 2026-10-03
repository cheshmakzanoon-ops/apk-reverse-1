local UILWSeasonDistributeRewardView = BaseClass("UILWSeasonDistributeRewardView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local panel_path = "root/panel"
local left_btn_path = "BtnGo/leftBtn"
local right_btn_path = "BtnGo/rightBtn"
local info_input_path = "root/InfoInput"
local slider_path = "root/InfoInput/Slider"
local dec_btn_path = "root/InfoInput/DecBtn"
local add_btn_path = "root/InfoInput/AddBtn"
local first_name_txt_path = "root/target/Name/firstNameTxt"
local player_path = "root/target/player"
local input_field_path = "root/InfoInput/InputField"
local input_count_text_path = "root/InfoInput/InputField/viewport/InputCountText"

function UILWSeasonDistributeRewardView:OnCreate()
  base.OnCreate(self)
  local userData = self:GetUserData()
  self:ComponentDefine()
  if userData then
    self.parentData = userData.parentData
    self.maxItemCount = math.min(userData.max, 100)
    self.minItemCount = userData.min
    self:SetInputText(userData.defaultValue)
    self:SetPlayaerInfo(userData.parentData.data)
    self.inputGo:SetActive(true)
  else
    self.inputGo:SetActive(false)
  end
  self.canSliderChange = true
end

function UILWSeasonDistributeRewardView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonDistributeRewardView:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonDistributeRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonDistributeRewardView:ComponentDefine()
  self.right_btn = self:AddComponent(UIButton, right_btn_path)
  self.right_btn:SetOnClick(function()
    self:ConfirmBtn()
  end)
  self.left_btn = self:AddComponent(UIButton, left_btn_path)
  self.left_btn:SetOnClick(function()
    self:CancelBtn()
  end)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self:CancelBtn()
  end)
  self.first_name_txt = self:AddComponent(UIText, first_name_txt_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.player:SetEnableClickShowInfo(true, true)
  self.inputGo = self:AddComponent(UIBaseContainer, info_input_path)
  self.inputSlider = self:AddComponent(UISlider, slider_path)
  self.inputAddBtn = self:AddComponent(UIButton, add_btn_path)
  self.inputDecBtn = self:AddComponent(UIButton, dec_btn_path)
  self.input_field = self:AddComponent(UIInput, input_field_path)
  self.input_count_text = self:AddComponent(UIText, input_count_text_path)
  self.input_field:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self.inputSlider:SetOnValueChanged(function(value)
    self:OnInputSliderChanged(value)
  end)
  self.inputAddBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_ChangeNum, false)
    self:OnAddBtnClick()
  end)
  self.inputDecBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_ChangeNum, false)
    self:OnDecBtnClick()
  end)
end

function UILWSeasonDistributeRewardView:ComponentDestroy()
  self.right_btn = nil
  self.left_btn = nil
  self.panel = nil
  self.inputGo = nil
  self.inputSlider = nil
  self.inputAddBtn = nil
  self.inputDecBtn = nil
  self.first_name_txt = nil
  self.player = nil
  self.input_field = nil
  self.input_count_text = nil
end

function UILWSeasonDistributeRewardView:OnInputSliderChanged(value)
  if self.canSliderChange then
    local percent = math.floor(value * self.maxItemCount)
    percent = math.max(self.minItemCount, percent)
    percent = math.min(self.maxItemCount, percent)
    self:SetInputText(percent)
  end
end

function UILWSeasonDistributeRewardView:SetAddAndDecBtnState()
  local can_dec = self.curItemCount > self.minItemCount
  local can_add = self.curItemCount < self.maxItemCount
  if can_dec then
    UIGray.SetGray(self.inputDecBtn.transform, false, true)
  else
    UIGray.SetGray(self.inputDecBtn.transform, true, false)
  end
  if can_add then
    UIGray.SetGray(self.inputAddBtn.transform, false, true)
  else
    UIGray.SetGray(self.inputAddBtn.transform, true, false)
  end
  self.inputSlider:SetValueWithoutNotify(self.curItemCount / self.maxItemCount)
end

function UILWSeasonDistributeRewardView:OnAddBtnClick()
  self.canSliderChange = false
  if self.curItemCount < self.maxItemCount then
    self:SetInputText(self.curItemCount + 1)
  end
  self.canSliderChange = true
end

function UILWSeasonDistributeRewardView:OnDecBtnClick()
  self.canSliderChange = false
  if self.curItemCount > 1 then
    self:SetInputText(self.curItemCount - 1)
  end
  self.canSliderChange = true
end

function UILWSeasonDistributeRewardView:SetInputText(value)
  self.curItemCount = value
  self.input_field:SetText(value)
  self:SetAddAndDecBtnState()
end

function UILWSeasonDistributeRewardView:SetPlayaerInfo(data)
  local headFrame = data.headFrame
  headFrame = headFrame or data:GetHeadBgImg()
  self.player:SetHead(data.uid, data.pic, data.picVer, nil, headFrame)
  local firstName = data:GetShowName()
  self.first_name_txt:SetText(firstName)
end

function UILWSeasonDistributeRewardView:ConfirmBtn()
  if self.parentData then
    local str = Localization:GetString("season_alliance_reward_tips001", self.parentData.data:GetShowName(), self.curItemCount)
    UIUtil.ShowSecondMessage(Localization:GetString("season_alliance_reward_ui003"), str, 2, "", "", function()
      self.parentData:DistributeReward(self.curItemCount)
    end, nil, nil, nil, nil, nil, nil, nil, nil, false)
  end
  self.ctrl:CloseSelf()
end

function UILWSeasonDistributeRewardView:CancelBtn()
  self.ctrl:CloseSelf()
end

function UILWSeasonDistributeRewardView:IptOnValueChange(value)
  self.canSliderChange = false
  local valueInt = tonumber(value)
  if valueInt > self.maxItemCount then
    valueInt = self.maxItemCount
  elseif valueInt < self.minItemCount then
    valueInt = self.minItemCount
  end
  self:SetInputText(valueInt)
  self.canSliderChange = true
end

return UILWSeasonDistributeRewardView
