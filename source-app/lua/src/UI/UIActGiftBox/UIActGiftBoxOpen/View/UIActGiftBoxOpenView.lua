local UIActGiftBoxOpenView = BaseClass("UIActGiftBoxOpenView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIActGiftBoxOpenView:OnCreate()
  base.OnCreate(self)
  self.actId = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIActGiftBoxOpenView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIActGiftBoxOpenView:OnEnable()
  base.OnEnable(self)
  self:OnRefresh()
end

function UIActGiftBoxOpenView:OnDisable()
  base.OnDisable(self)
end

function UIActGiftBoxOpenView:ComponentDefine()
  self.closeBtnN = self:AddComponent(UIButton, "PopUpTitle/CloseBtn")
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtnN = self:AddComponent(UIButton, "panel")
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleTxtN = self:AddComponent(UIText, "PopUpTitle/Common_img_title/titleText")
  self._reward_rect = self:AddComponent(UICommonResItem, "PopUpTitle/Common_bg_orange2/Reward")
  self._open_btn = self:AddComponent(UIButton, "PopUpTitle/Common_bg_orange2/CostBuyBtn")
  self._open_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickOpen()
  end)
  self._open_txt = self:AddComponent(UIText, "PopUpTitle/Common_bg_orange2/CostBuyBtn/CostBtnText")
  self._cost_txt = self:AddComponent(UIText, "PopUpTitle/Common_bg_orange2/CostBuyBtn/CostInfoArea/PriceBtnText")
  self._cost_img = self:AddComponent(UIImage, "PopUpTitle/Common_bg_orange2/CostBuyBtn/CostInfoArea/Img")
  self._costInfo_root = self:AddComponent(UIBaseContainer, "PopUpTitle/Common_bg_orange2/CostBuyBtn/CostInfoArea")
  self._giftIcon_img = self:AddComponent(UIImage, "PopUpTitle/Common_bg_orange2/BoxImg")
  self._tips_txt = self:AddComponent(UIText, "PopUpTitle/Common_bg_orange2/TitleText")
  self._time_txt = self:AddComponent(UIText, "PopUpTitle/Common_bg_orange2/TimeText")
  self.back_toggle = self:AddComponent(UIToggle, "backToggle")
  self.back_toggle:SetIsOn(false)
  self.back_toggle:SetOnValueChanged(function()
    self:ToggleAction(not self.back_toggle:GetIsOn())
  end)
  self.checkbox_text = self:AddComponent(UIText, "backToggle/Text")
  self.checkbox_text:SetLocalText(120059)
  self.cost_btn_img = self:AddComponent(UIImage, "PopUpTitle/Common_bg_orange2/CostBuyBtn")
end

function UIActGiftBoxOpenView:ToggleAction(needSellConfirm)
  DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.GiftBoxOpenTip, needSellConfirm)
end

function UIActGiftBoxOpenView:ComponentDestroy()
  self.createBtnTxtN = nil
  self.closeBtnN = nil
end

function UIActGiftBoxOpenView:DataDefine()
end

function UIActGiftBoxOpenView:DataDestroy()
end

function UIActGiftBoxOpenView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UseItemSuccess, self.OnRefresh)
  self:AddUIListener(EventId.BuyItemAndRes, self.OnRefresh)
  self:AddUIListener(EventId.ActGiftFreeRewardReceive, self.OnRefresh)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.OnRefresh)
end

function UIActGiftBoxOpenView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UseItemSuccess, self.OnRefresh)
  self:RemoveUIListener(EventId.BuyItemAndRes, self.OnRefresh)
  self:RemoveUIListener(EventId.ActGiftFreeRewardReceive, self.OnRefresh)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.OnRefresh)
end

function UIActGiftBoxOpenView:ReInit()
  self.titleTxtN:SetLocalText(372509)
  self._tips_txt:SetLocalText(372510)
end

function UIActGiftBoxOpenView:OnRefresh()
  self.actData = DataCenter.ActGiftBoxData:GetInfoByActId(self.actId)
  self.keyID = DataCenter.ActGiftBoxData:GetActKeyById(self.actId)
  if self.keyID then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.keyID)
    self._cost_img:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
  end
  self.boxInfo = DataCenter.ActGiftBoxData:GetParam(self.param)
  local template = DataCenter.ActGiftBoxData:GetActBoxInfoByItemId(self.boxInfo.itemId)
  self.unlockNum = tonumber(template.unlock_cost)
  local haveCount = DataCenter.ItemData:GetItemCount(self.keyID)
  local costText = template.unlock_cost
  if haveCount < tonumber(template.unlock_cost) then
    costText = "<color=#ED0000>" .. template.unlock_cost .. "</color>"
  end
  self._cost_txt:SetText(costText)
  self._open_txt:SetLocalText("activity_bujizhaohuan_open_btn")
  self._giftIcon_img:LoadSprite(string.format(LoadPath.UImystery, template.reward_icon))
  self:RefreshReward()
  self:CheckIsShowCostInfo(template.isFreeBox)
end

function UIActGiftBoxOpenView:CheckIsShowCostInfo(isFreeBox)
  if isFreeBox then
    self._costInfo_root:SetActive(false)
    self.cost_btn_img:LoadSprite(UIAssets.GREEN_BTN)
    return
  end
  self._costInfo_root:SetActive(true)
  self.cost_btn_img:LoadSprite(UIAssets.BLUE_BTN)
end

function UIActGiftBoxOpenView:RefreshReward()
  local boxInfo = DataCenter.ActGiftBoxData:GetActBoxInfoByItemId(self.boxInfo.itemId)
  local str = string.split(boxInfo.goods, ";")
  local param = {}
  param.itemId = str[1]
  param.count = str[2]
  param.rewardType = RewardType.GOODS
  self._reward_rect:ReInit(param)
end

function UIActGiftBoxOpenView:OnClickOpen()
  local count = DataCenter.ItemData:GetItemCount(self.keyID)
  if count < self.unlockNum then
    local canGotoPackShop = DataCenter.ActGiftBoxData:CanGotoPackShop(tonumber(self.actId))
    if canGotoPackShop then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.actId, DataCenter.ActGiftBoxData:GetKeyGiftPackId(tonumber(self.actId)), DataCenter.ActGiftBoxData:GetActKeyById(tonumber(self.actId)))
    elseif DataCenter.ActivityListDataManager:IsEndDay(self.actId) then
      UIUtil.ShowTipsId("dailygift_buy_alert2")
    else
      UIUtil.ShowTipsId("dailygift_buy_alert1")
    end
    UIUtil.ShowTipsId(120021)
    return
  end
  self.ctrl:CloseSelf()
  SFSNetwork.SendMessage(MsgDefines.OpenActivityGiftBox, self.actId, self.boxInfo.uuid)
end

return UIActGiftBoxOpenView
