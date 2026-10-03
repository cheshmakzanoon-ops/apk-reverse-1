local UIChampionDuelDonateConfirmView = BaseClass("UIChampionDuelDonateConfirmView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local exp_img_path = "BgGo/MiddleBg/BuildInfo/DonateInfoGo/donateReward/exp_img"

function UIChampionDuelDonateConfirmView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetData()
end

function UIChampionDuelDonateConfirmView:OnDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelDonateConfirmView:OnEnable()
  base.OnEnable(self)
end

function UIChampionDuelDonateConfirmView:OnDisable()
  base.OnDisable(self)
end

function UIChampionDuelDonateConfirmView:ComponentDefine()
  self.closeBtnN = self:AddComponent(UIButton, "Common_bg_orange/CloseBtn")
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtnN = self:AddComponent(UIButton, "panel")
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleTxtN = self:AddComponent(UIText, "Common_bg_orange/Common_img_title/titleText")
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

function UIChampionDuelDonateConfirmView:DataDefine()
  self.canSliderChange = true
  self.minItemCount = 1
  self.maxItemCount = 1
  self.curItemCount = 1
  self.onceDonateNum = 1
  self.donateTime = 1
  self.minDonateTime = 1
  self.maxDonateTime = 1
end

function UIChampionDuelDonateConfirmView:DataDestroy()
  self.canSliderChange = nil
  self.minItemCount = nil
  self.maxItemCount = nil
  self.curItemCount = nil
  self.onceDonateNum = nil
  self.donateTime = nil
  self.minDonateTime = nil
  self.maxDonateTime = nil
end

function UIChampionDuelDonateConfirmView:SetData()
  self.donateItemId = tonumber(LuaEntry.DataConfig:TryGetStr("lw_champion_duel", "k5"))
  self.rewardId = tonumber(LuaEntry.DataConfig:TryGetStr("lw_champion_duel", "k11"))
  self.rewardList = DataCenter.ChampionDuelManager:GetRewardsById(self.rewardId)
  local itemParam = {
    itemId = self.donateItemId,
    count = 1,
    rewardType = RewardType.GOODS
  }
  self._common_res_item:ReInit(itemParam)
  self.donateTime = 1
  self.onceDonateNum = 1
  local haveCount = DataCenter.ItemData:GetItemCount(self.donateItemId)
  self.maxItemCount = haveCount
  self.maxDonateTime = math.floor(self.maxItemCount / self.onceDonateNum)
  self._have_txt:SetLocalText("thanksactivity_UI036", haveCount)
  if #self.rewardList == 2 then
    local addItemId = self.rewardList[1].itemId
    self._item_icon:LoadSpriteAuto(DataCenter.ItemTemplateManager:GetIconPath(addItemId))
    local addItemId2 = self.rewardList[2].itemId
    self.exp_img:LoadSpriteAuto(DataCenter.ItemTemplateManager:GetIconPath(addItemId2))
    self:RefreshDonateDescInfo()
  end
  self:SetInputText(1)
end

function UIChampionDuelDonateConfirmView:OnClickConfirm()
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelHotActDonate, self.curItemCount)
  self.ctrl:CloseSelf()
end

function UIChampionDuelDonateConfirmView:OnInputSliderChanged(value)
  if self.canSliderChange then
    local percent = math.floor(value * self.maxDonateTime)
    percent = math.max(self.minDonateTime, percent)
    percent = math.min(self.maxDonateTime, percent)
    self:SetInputText(percent)
  end
end

function UIChampionDuelDonateConfirmView:SetInputText(value)
  self.donateTime = value
  self.curItemCount = self.donateTime * self.onceDonateNum
  self.inputTxt:SetText(self.curItemCount)
  self:RefreshDonateDescInfo()
  self:SetAddAndDecBtnState()
end

function UIChampionDuelDonateConfirmView:SetAddAndDecBtnState()
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

function UIChampionDuelDonateConfirmView:OnAddBtnClick()
  self.canSliderChange = false
  if self.donateTime + 1 <= self.maxDonateTime then
    self:SetInputText(self.donateTime + 1)
  end
  self.canSliderChange = true
end

function UIChampionDuelDonateConfirmView:OnDecBtnClick()
  self.canSliderChange = false
  if self.donateTime > self.minDonateTime then
    self:SetInputText(self.donateTime - 1)
  end
  self.canSliderChange = true
end

function UIChampionDuelDonateConfirmView:RefreshDonateDescInfo()
  local item1Num = self.rewardList[1].count
  local item2Num = self.rewardList[2].count
  self._personal_donate_txt:SetText(string.GetFormattedStr(item1Num * self.donateTime))
  self._exp_txt:SetText(string.GetFormattedStr(item2Num * self.donateTime))
end

return UIChampionDuelDonateConfirmView
