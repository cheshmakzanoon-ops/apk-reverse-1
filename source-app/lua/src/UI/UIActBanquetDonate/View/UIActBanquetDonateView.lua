local UIActBanquetDonateView = BaseClass("UIActBanquetDonateView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local exp_img_path = "BgGo/MiddleBg/BuildInfo/DonateInfoGo/donateReward/exp_img"

function UIActBanquetDonateView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local activityId, actBanquetId = self:GetUserData()
  self:SetData(activityId, actBanquetId)
end

function UIActBanquetDonateView:OnDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIActBanquetDonateView:OnEnable()
  base.OnEnable(self)
end

function UIActBanquetDonateView:OnDisable()
  base.OnDisable(self)
end

function UIActBanquetDonateView:ComponentDefine()
  self.closeBtnN = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtnN = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleTxtN = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.titleTxtN:SetLocalText("thanksactivity_UI034")
  self.inputGo = self:AddComponent(UIBaseContainer, "BgGo/MiddleBg/BuildInfo/InfoInput")
  self.inputSlider = self:AddComponent(UISlider, "BgGo/MiddleBg/BuildInfo/InfoInput/Slider")
  self.inputTxt = self:AddComponent(UIText, "BgGo/MiddleBg/BuildInfo/InfoInput/TextBg/CountText")
  self.inputAddBtn = self:AddComponent(UIButton, "BgGo/MiddleBg/BuildInfo/InfoInput/AddBtn")
  self.inputDecBtn = self:AddComponent(UIButton, "BgGo/MiddleBg/BuildInfo/InfoInput/DecBtn")
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
  self._confirm_btn = self:AddComponent(UIButton, "BgGo/MiddleBg/BuildInfo/ConfirmBtn")
  self._confirm_btn_txt = self:AddComponent(UIText, "BgGo/MiddleBg/BuildInfo/ConfirmBtn/ConfirmBtnTxt")
  self._confirm_btn_txt:SetLocalText(2000541)
  self._confirm_btn:SetOnClick(function()
    self:OnClickConfirm()
  end)
  self._common_res_item = self:AddComponent(UICommonResItem, "BgGo/MiddleBg/BuildInfo/UICommonResItem")
  self._desc_tip = self:AddComponent(UIText, "BgGo/MiddleBg/BuildInfo/DonateInfoGo/donateReward/donate_tip_txt")
  self._desc_tip:SetLocalText("thanksactivity_UI035")
  self._personal_donate_txt = self:AddComponent(UIText, "BgGo/MiddleBg/BuildInfo/DonateInfoGo/donateReward/personal_donate_txt")
  self._exp_txt = self:AddComponent(UIText, "BgGo/MiddleBg/BuildInfo/DonateInfoGo/donateReward/exp_txt")
  self._have_txt = self:AddComponent(UIText, "BgGo/MiddleBg/BuildInfo/HaveText")
  self._item_icon = self:AddComponent(UIImage, "BgGo/MiddleBg/BuildInfo/DonateInfoGo/donateReward/personal_donate_img")
  self.exp_img = self:AddComponent(UIImage, exp_img_path)
end

function UIActBanquetDonateView:DataDefine()
  self.canSliderChange = true
  self.minItemCount = 1
  self.maxItemCount = 1
  self.curItemCount = 1
  self.onceDonateNum = 1
  self.donateTime = 1
  self.minDonateTime = 1
  self.maxDonateTime = 1
end

function UIActBanquetDonateView:DataDestroy()
  self.canSliderChange = nil
  self.minItemCount = nil
  self.maxItemCount = nil
  self.curItemCount = nil
  self.onceDonateNum = nil
  self.donateTime = nil
  self.minDonateTime = nil
  self.maxDonateTime = nil
end

function UIActBanquetDonateView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBanquetCloseScoreDetail, self.OnCloseScoreDetail)
end

function UIActBanquetDonateView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBanquetCloseScoreDetail, self.OnCloseScoreDetail)
end

function UIActBanquetDonateView:SetData(activityId, actBanquetId)
  self.activityId = activityId
  self.actBanquetId = actBanquetId
  self.donateItemId = DataCenter.ActBanquetData:GetBanquetDonateItemId()
  local itemParam = {
    itemId = self.donateItemId,
    count = 1,
    rewardType = RewardType.GOODS
  }
  self._common_res_item:ReInit(itemParam)
  self.donateTime = 1
  self.onceDonateNum = DataCenter.ActBanquetData.actBanquetTemplate.unit_num or 1
  local haveCount = DataCenter.ItemData:GetItemCount(self.donateItemId)
  self.maxItemCount = haveCount
  self.maxDonateTime = math.floor(self.maxItemCount / self.onceDonateNum)
  self._have_txt:SetLocalText("thanksactivity_UI036", haveCount)
  local addItemId = DataCenter.ActBanquetData:GetBanquetAddGoodId()
  self._item_icon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(addItemId))
  self:RefreshDonateDescInfo()
  self:SetInputText(1)
  local actBanquetTemplate = DataCenter.ActivityPartyTemplateManager:GetActBanquetTemplate(self.actBanquetId)
  local iconName = actBanquetTemplate.score_pic
  if string.IsNullOrEmpty(iconName) then
    iconName = "zyf_yanhuujifen_icon_daoju"
  end
  local iconPath = string.format(LoadPath.ItemPath, iconName)
  self.exp_img:LoadSprite(iconPath)
end

function UIActBanquetDonateView:OnClickConfirm()
  local param = {}
  param.aid = self.activityId
  param.id = DataCenter.ActBanquetData.actBanquetId
  param.num = self.curItemCount
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyLevelUp, param)
  self.ctrl:CloseSelf()
end

function UIActBanquetDonateView:OnInputSliderChanged(value)
  if self.canSliderChange then
    local percent = math.floor(value * self.maxDonateTime)
    percent = math.max(self.minDonateTime, percent)
    percent = math.min(self.maxDonateTime, percent)
    self:SetInputText(percent)
  end
end

function UIActBanquetDonateView:SetInputText(value)
  self.donateTime = value
  self.curItemCount = self.donateTime * self.onceDonateNum
  self.inputTxt:SetText(self.curItemCount)
  self:RefreshDonateDescInfo()
  self:SetAddAndDecBtnState()
end

function UIActBanquetDonateView:SetAddAndDecBtnState()
  local can_dec = self.donateTime > self.minDonateTime
  local can_add = self.donateTime < self.maxDonateTime
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
  self.inputSlider:SetValue(self.donateTime / self.maxDonateTime)
end

function UIActBanquetDonateView:OnAddBtnClick()
  self.canSliderChange = false
  if self.donateTime + 1 <= self.maxDonateTime then
    self:SetInputText(self.donateTime + 1)
  end
  self.canSliderChange = true
end

function UIActBanquetDonateView:OnDecBtnClick()
  self.canSliderChange = false
  if self.donateTime > self.minDonateTime then
    self:SetInputText(self.donateTime - 1)
  end
  self.canSliderChange = true
end

function UIActBanquetDonateView:RefreshDonateDescInfo()
  local singleAddExp = DataCenter.ActBanquetData:GetBanquetAddScore()
  local singlePersonalAdd = DataCenter.ActBanquetData:GetBanquetAddGoodNum()
  self._exp_txt:SetText(string.GetFormattedStr(singleAddExp * self.donateTime))
  self._personal_donate_txt:SetText(string.GetFormattedStr(singlePersonalAdd * self.donateTime))
end

return UIActBanquetDonateView
