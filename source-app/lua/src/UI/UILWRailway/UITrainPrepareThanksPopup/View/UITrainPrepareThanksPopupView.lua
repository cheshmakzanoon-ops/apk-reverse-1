local UITrainPrepareThanksPopupView = BaseClass("UITrainPrepareThanksPopupView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local bg_path = "panel"
local txt_title_path = "panel/bg/txtTitle"
local close_btn_path = "panel/bg/CloseBtn"
local input_go_path = "panel/bg/bg2/InfoInput"
local input_slider_path = "panel/bg/bg2/InfoInput/Slider"
local input_dec_btn_path = "panel/bg/bg2/InfoInput/DecBtn"
local input_add_btn_path = "panel/bg/bg2/InfoInput/AddBtn"
local input_count_txt_path = "panel/bg/bg2/InfoInput/TextBg/CountText"
local u_i_common_res_item_path = "panel/bg/bg2/UICommonResItem"
local desc_path = "panel/bg/bg2/Desc"
local like_btn_path = "panel/bg/LikeBtn"
local like_btn_text_path = "panel/bg/LikeBtn/LikeBtnText"
local give_btn_path = "panel/bg/GiveBtn"
local give_btn_text_path = "panel/bg/GiveBtn/GiveBtnText"
local cost_txt_path = "panel/bg/costTxt"
local small_icon_path = "panel/bg/costTxt/smallIcon"

function UITrainPrepareThanksPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UITrainPrepareThanksPopupView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UITrainPrepareThanksPopupView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshData)
end

function UITrainPrepareThanksPopupView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshData)
  base.OnRemoveListener(self)
end

function UITrainPrepareThanksPopupView:ComponentDefine()
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
  self.inputGo = self:AddComponent(UIBaseContainer, input_go_path)
  self.inputSlider = self:AddComponent(UISlider, input_slider_path)
  self.inputTxt = self:AddComponent(UIText, input_count_txt_path)
  self.inputAddBtn = self:AddComponent(UIButton, input_add_btn_path)
  self.inputDecBtn = self:AddComponent(UIButton, input_dec_btn_path)
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
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.like_btn = self:AddComponent(UIButton, like_btn_path)
  self.like_btn_text = self:AddComponent(UITextMeshProUGUIEx, like_btn_text_path)
  self.give_btn = self:AddComponent(UIButton, give_btn_path)
  self.give_btn_text = self:AddComponent(UITextMeshProUGUIEx, give_btn_text_path)
  self.cost_txt = self:AddComponent(UITextMeshProUGUIEx, cost_txt_path)
  self.small_icon = self:AddComponent(UIImage, small_icon_path)
  self.like_btn:SetOnClick(function()
    self:OnLikeBtnClick()
  end)
  self.give_btn:SetOnClick(function()
    self:OnGiveBtnClick()
  end)
  self.txt_title:SetText(Localization:GetString("alliance_train_001"))
  self.desc:SetText(Localization:GetString("alliance_train_002"))
  self.like_btn_text:SetText((Localization:GetString("alliance_train_btn01")))
  self.give_btn_text:SetText(Localization:GetString("alliance_train_btn02"))
end

function UITrainPrepareThanksPopupView:DataDefine()
  self.curItemCount = 1
  self.minCount = DataCenter.LWAllyStationDataManager:GetThanksItemMin()
  self.maxCount = DataCenter.LWAllyStationDataManager:GetThanksItemMax()
  self.canSliderChange = true
end

function UITrainPrepareThanksPopupView:ComponentDestroy()
  self.bg = nil
  self.txt_title = nil
  self.close_btn = nil
  self.inputGo = nil
  self.inputSlider = nil
  self.inputTxt = nil
  self.inputAddBtn = nil
  self.inputDecBtn = nil
  self.u_i_common_res_item = nil
  self.desc = nil
  self.like_btn = nil
  self.like_btn_text = nil
  self.give_btn = nil
  self.give_btn_text = nil
  self.cost_txt = nil
  self.small_icon = nil
end

function UITrainPrepareThanksPopupView:DataDestroy()
  self.curItemCount = nil
  self.itemId = nil
  self.canSliderChange = false
end

function UITrainPrepareThanksPopupView:ReInit()
  local itemId = DataCenter.LWAllyStationDataManager.CHANGE_TRAIN_COST_ITEM
  self.itemId = itemId
  local iconData = {}
  iconData.rewardType = RewardType.GOODS
  iconData.itemId = itemId
  self.u_i_common_res_item:ReInit(iconData)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if goods ~= nil then
    self.small_icon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
  end
  self:RefreshData()
  self:SetInputText(self.curItemCount)
end

function UITrainPrepareThanksPopupView:RefreshData()
  local curCount = DataCenter.ItemData:GetItemCount(self.itemId)
  self.cost_txt:SetText(curCount)
end

function UITrainPrepareThanksPopupView:SetInputText(value)
  self.curItemCount = value
  self.inputTxt:SetText(value)
  self:SetAddAndDecBtnState()
end

function UITrainPrepareThanksPopupView:SetAddAndDecBtnState()
  local can_dec = self.curItemCount > self.minCount
  local can_add = self.curItemCount < self.maxCount
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
  self.inputSlider:SetValue(self.curItemCount / self.maxCount)
end

function UITrainPrepareThanksPopupView:OnInputSliderChanged(value)
  if self.canSliderChange then
    local percent = math.floor(value * self.maxCount)
    percent = Mathf.Clamp(percent, self.minCount, self.maxCount)
    self:SetInputText(percent)
  end
end

function UITrainPrepareThanksPopupView:OnAddBtnClick()
  self.canSliderChange = false
  if self.curItemCount < self.maxCount then
    self:SetInputText(self.curItemCount + 1)
  end
  self.canSliderChange = true
end

function UITrainPrepareThanksPopupView:OnDecBtnClick()
  self.canSliderChange = false
  if self.curItemCount > self.minCount then
    self:SetInputText(self.curItemCount - 1)
  end
  self.canSliderChange = true
end

function UITrainPrepareThanksPopupView:OnLikeBtnClick()
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if trainData == nil then
    self:OnCloseBtnClick()
    return
  end
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  local platformState = platformData.state
  if platformState ~= TrainPlatformState.TrainWithDriver then
    self:OnCloseBtnClick()
    return
  end
  local index = DataCenter.LWAllyStationDataManager:RandomThanksLangIndex()
  DataCenter.LWAllyStationDataManager:SendAllianceTrainThumbsUp(1, 0, index)
  self:OnCloseBtnClick()
end

function UITrainPrepareThanksPopupView:OnGiveBtnClick()
  local curCount = DataCenter.ItemData:GetItemCount(self.itemId)
  if curCount < self.curItemCount then
    LWResourceLackUtil:GotoGoodsItemLack(self.itemId, self.curItemCount - curCount)
    return
  end
  local index = DataCenter.LWAllyStationDataManager:RandomThanksLangIndex()
  DataCenter.LWAllyStationDataManager:SendAllianceTrainThumbsUp(1, self.curItemCount, index)
  self:OnCloseBtnClick()
end

function UITrainPrepareThanksPopupView:OnCloseBtnClick()
  self.ctrl:CloseSelf()
end

return UITrainPrepareThanksPopupView
