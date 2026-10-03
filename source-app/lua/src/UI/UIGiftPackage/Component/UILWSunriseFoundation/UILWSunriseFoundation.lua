local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UILWSunriseFoundation = BaseClass("UILWSunriseFoundation", base)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UILWSunriseFoundationTargetItem = require("UI.UIGiftPackage.Component.UILWSunriseFoundation.UILWSunriseFoundationTargetItem")
local AfterPunchaseRewardItem = require("UI.UIGiftPackage.Component.UILWSunriseFoundation.AfterPunchaseRewardItem")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local titleNameText_path = "InfoContent/topContent/TitleNameText"
local descriptionText_path = "InfoContent/topContent/DescriptionText"
local buyBtn_path = "InfoContent/topContent/BuyBtn"
local buyBtnPriceText_path = "InfoContent/topContent/BuyBtn/PriceText"
local buyBtnText_path = "InfoContent/topContent/BuyBtn/BtnText"
local buyBtnGiftPackPoint_path = "InfoContent/topContent/BuyBtn/UIGiftPackagePoint"
local targetsScroll_path = "InfoContent/TargetScroll"
local targetsSrollContent_path = "InfoContent/TargetScroll/Viewport/Content"
local cur_lv_path = "InfoContent/centerContent/centerIcon/curLv"
local pay_lock_icon_path = "InfoContent/centerContent/bg2/PayTitleContent/payLockIcon"
local intro_btn_path = "InfoContent/topContent/introBtn"
local buy_content_btn_path = "InfoContent/centerContent/bg2/BuyContentBtn"
local battle_pass_discount_path = "InfoContent/topContent/BattlePassDiscount"
local discount_text_path = "InfoContent/topContent/BattlePassDiscount/DiscountText"
local btn_one_get_path = "InfoContent/Btn_OneGet"
local txt_one_get_path = "InfoContent/Btn_OneGet/Txt_OneGet"
local after_punchase_reward_item_path = "InfoContent/topContent/AfterPurchaseRewardContent/AfterPunchaseRewardItem"
local after_punchase_reward_item_content_path = "InfoContent/topContent/AfterPurchaseRewardContent/AfterPunchaseRewardItemScroll/Viewport/AfterPunchaseRewardItemContent"
local after_punchase_reward_tip_text_path = "InfoContent/topContent/AfterPurchaseRewardContent/AfterPunchaseRewardTipText"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ClearScroll(self)
  self.targetContent:RemoveComponents(UILWSunriseFoundationTargetItem)
  self.targetScroll:ClearAllItems()
  self.after_punchase_reward_item_content:RemoveComponents(AfterPunchaseRewardItem)
  for _, v in ipairs(self.after_punchase_reward_item_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.after_punchase_reward_item.gameObject:GameObjectRecycleAll()
  self.after_punchase_reward_item_list = {}
end

local function OnDestroy(self)
  ClearScroll(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshGiftPack)
  self:AddUIListener(EventId.SunriseInfoGet, self.OnRefresh)
  self:AddUIListener(EventId.SunriseInfoUpdate, self.OnRefresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshGiftPack)
  self:RemoveUIListener(EventId.SunriseInfoGet, self.OnRefresh)
  self:RemoveUIListener(EventId.SunriseInfoUpdate, self.OnRefresh)
  base.OnRemoveListener(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.targets then
    return nil
  end
  local data = self.targets[index]
  local maxNum = #self.targets
  local curNum = index
  local curLv = self.curLv
  local item = loopScroll:NewListViewItem("GrowTargetItem")
  local script = self.targetContent:GetComponent(item.gameObject.name, UILWSunriseFoundationTargetItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.targetContent:AddComponent(UILWSunriseFoundationTargetItem, objectName)
  end
  script:SetActive(true)
  script:SetItem(data, curNum, maxNum, curLv, self.targets, self.buyState, self.actId)
  return item
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, titleNameText_path)
  self.descText = self:AddComponent(UIText, descriptionText_path)
  self.targetScroll = self:AddComponent(UILoopListView2, targetsScroll_path)
  self.targetScroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.targetContent = self:AddComponent(UIBaseContainer, targetsSrollContent_path)
  self.buyBtn = self:AddComponent(LWBtnBuyRefundRemind, buyBtn_path)
  self.buyBtn:SetBuyClickAction(function()
    self:OnClickBtn()
  end)
  self.buyBtn:SetSafeClickMode(true)
  self.buyBtnText = self:AddComponent(UIText, buyBtnText_path)
  self.cur_lv = self:AddComponent(UITextMeshProUGUIEx, cur_lv_path)
  self.pay_lock_icon = self:AddComponent(UIImage, pay_lock_icon_path)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTip()
  end)
  self.buy_content_btn = self:AddComponent(UIButton, buy_content_btn_path)
  self.buy_content_btn:SetOnClick(function()
    self:OnBuyContentBtnClick()
  end)
  self.battle_pass_discount = self:AddComponent(UIImage, battle_pass_discount_path)
  self.discount_text = self:AddComponent(UITextMeshProUGUIEx, discount_text_path)
  self.btn_one_get = self:AddComponent(UIButton, btn_one_get_path)
  self.txt_one_get = self:AddComponent(UITextMeshProUGUIEx, txt_one_get_path)
  self.txt_one_get:SetLocalText(110132)
  self.btn_one_get:SetOnClick(function()
    self:OnGetAllBtnClick()
  end)
  self.btn_one_get:SetActive(true)
  self.after_punchase_reward_item = self:AddComponent(UIBaseContainer, after_punchase_reward_item_path)
  self.after_punchase_reward_item_content = self:AddComponent(UIBaseContainer, after_punchase_reward_item_content_path)
  self.after_punchase_reward_item_list = {}
  self.after_punchase_reward_item:SetActive(false)
  self.after_punchase_reward_item.gameObject:GameObjectCreatePool()
  self.after_punchase_reward_tip_text = self:AddComponent(UITextMeshProUGUIEx, after_punchase_reward_tip_text_path)
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.descText = nil
  self.targetScroll = nil
  self.targetContent = nil
  self.buyBtn = nil
  self.buyBtnText = nil
  self.cur_lv = nil
  self.pay_lock_icon = nil
  self.intro_btn = nil
  self.buy_content_btn = nil
  self.battle_pass_discount = nil
  self.discount_text = nil
  self.btn_one_get = nil
  self.txt_one_get = nil
  self.after_punchase_reward_item = nil
  self.after_punchase_reward_item_content = nil
  self.after_punchase_reward_tip_text = nil
end

local function DataDefine(self)
  self.itemIndex = 0
  self.initTargets = false
  self.targets = {}
  self.curLv = 0
end

local function DataDestroy(self)
  self.itemIndex = nil
  self.initTargets = nil
  self.targets = nil
  self.curLv = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.initTargets = false
end

local function OnDisable(self)
  base.OnDisable(self)
  self.initTargets = false
end

local function SetData(self, actId)
  self.actId = tonumber(actId)
  if not self.actId then
    return
  end
  self.actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(self.actId)
  if not self.actData then
    return
  end
  self.curLv = DataCenter.BuildManager.MainLv or 0
  self:InitUI()
  self:OnRefresh(self.actId)
  self:RequestActivityDetialInfo()
  self:JumpToNeedItem()
end

local function RequestActivityDetialInfo(self)
  SFSNetwork.SendMessage(MsgDefines.SunriseInfo, self.actId)
end

local function InitUI(self)
  if self.actData then
    self.titleText:SetLocalText(self.actData.name)
    self.descText:SetLocalText(self.actData.desc_info)
  end
end

local function OnRefresh(self, actId)
  if actId ~= self.actId then
    return
  end
  self.actDetailInfo = DataCenter.ActSunriseFoundationDataManager:GetActData(self.actId)
  if self.actDetailInfo then
    self.targets = self.actDetailInfo.rewardArr
    self.buyState = self.actDetailInfo.unlock == 1
    if not self.buyState then
      self:RefreshGiftPack()
    end
    if not self.initTargets and self.targets and #self.targets > 0 then
      self:InitTargetList()
    else
      self.targetScroll:RefreshAllShownItem()
    end
    self:RefreshUI()
  end
end

local function RefreshGiftPack(self)
  if self.actDetailInfo then
    self.giftPackGroupId = self.actDetailInfo.exchangeId
    local packs = GiftPackageData.GetPacksByGroupId(self.giftPackGroupId)
    if not table.IsNullOrEmpty(packs) then
      self.giftPackData = packs[1]
    else
      self.giftPackData = nil
    end
  end
end

local function InitTargetList(self)
  if self.actDetailInfo then
    self.targetScroll:SetListItemCount(#self.targets, false, false)
    self.initTargets = true
  end
end

local function RefreshUI(self)
  if self.buyState or not self.giftPackData then
    self.buyBtn:SetActive(false)
    self.pay_lock_icon:SetActive(false)
  else
    self.buyBtn:SetActive(true)
    self.pay_lock_icon:SetActive(true)
    if self.giftPackData then
      self.buyBtn:Init(self.giftPackData)
      self.buyBtn:RefreshPoint()
    end
  end
  if self.giftPackData then
    self.battle_pass_discount:SetActive(true)
    self.discount_text:SetText(string.format("%s%%", self.giftPackData:getPercent()))
  else
    self.battle_pass_discount:SetActive(false)
  end
  local lvTxt = Localization:GetString(GameDialogDefine.LEVEL_NUMBER, self.curLv)
  self.cur_lv:SetText(lvTxt)
  local rewwardNum = self.actDetailInfo:GetCanRewardNum()
  UIGray.SetGray(self.btn_one_get.transform, rewwardNum <= 0, true)
  self:RefreshAfterPunchaseRewardContent()
end

local function RefreshAfterPunchaseRewardContent(self)
  local rewardData = {}
  for i = 1, #rewardData do
    if self.after_punchase_reward_item_list[i] == nil then
      local itemObj = self.after_punchase_reward_item.gameObject:GameObjectSpawn(self.after_punchase_reward_item_content.transform)
      itemObj.name = i
      local obj = self.after_punchase_reward_item_content:AddComponent(AfterPunchaseRewardItem, itemObj.name)
      self.after_punchase_reward_item_list[i] = obj
    end
    local item = self.after_punchase_reward_item_list[i]
    item:SetActive(true)
    item:SetData(rewardData[i], self.buyState)
  end
  for i = #rewardData + 1, #self.after_punchase_reward_item_list do
    self.after_punchase_reward_item_list[i]:SetActive(false)
  end
  self.after_punchase_reward_tip_text:SetActive(0 < #rewardData)
end

local function OnClickBtn(self)
  local windowName = UIWindowNames.UISunriseFoundationPopUpPanel
  UIManager:GetInstance():OpenWindow(windowName, tonumber(self.actId))
end

local function OnBuyContentBtnClick(self)
  if self.buyState == false and self.giftPackData then
    self:OnClickBtn()
  end
end

local function OnGetAllBtnClick(self)
  local rewwardNum = self.actDetailInfo:GetCanRewardNum()
  if 0 < rewwardNum then
    SFSNetwork.SendMessage(MsgDefines.SunriseReceiveReward, self.actId)
  else
    UIUtil.ShowTipsId("season_builders_alliance_tips_11")
  end
end

local function JumpToNeedItem(self)
  local jumpIndex = 0
  for i, v in ipairs(self.targets) do
    if self.curLv >= v.level then
      jumpIndex = i - 1
    else
      break
    end
    if v.rewardFlag == 0 or self.buyState and v.specialRewardFlag == 0 then
      break
    end
  end
  self.targetScroll:MovePanelToItemIndex(jumpIndex)
end

function UILWSunriseFoundation:ClickTip()
  if self.actData ~= nil and self.actData.story ~= nil then
    local param = {}
    param.activityId = self.actId
    param.activityRulesStr = Localization:GetString(self.actData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

UILWSunriseFoundation.OnCreate = OnCreate
UILWSunriseFoundation.OnDestroy = OnDestroy
UILWSunriseFoundation.OnAddListener = OnAddListener
UILWSunriseFoundation.OnRemoveListener = OnRemoveListener
UILWSunriseFoundation.ComponentDefine = ComponentDefine
UILWSunriseFoundation.ComponentDestroy = ComponentDestroy
UILWSunriseFoundation.DataDefine = DataDefine
UILWSunriseFoundation.DataDestroy = DataDestroy
UILWSunriseFoundation.OnRefresh = OnRefresh
UILWSunriseFoundation.SetData = SetData
UILWSunriseFoundation.InitUI = InitUI
UILWSunriseFoundation.RefreshUI = RefreshUI
UILWSunriseFoundation.RefreshAfterPunchaseRewardContent = RefreshAfterPunchaseRewardContent
UILWSunriseFoundation.OnClickBtn = OnClickBtn
UILWSunriseFoundation.OnBuyContentBtnClick = OnBuyContentBtnClick
UILWSunriseFoundation.OnGetAllBtnClick = OnGetAllBtnClick
UILWSunriseFoundation.OnGetItemByIndex = OnGetItemByIndex
UILWSunriseFoundation.OnEnable = OnEnable
UILWSunriseFoundation.OnDisable = OnDisable
UILWSunriseFoundation.ClearScroll = ClearScroll
UILWSunriseFoundation.InitTargetList = InitTargetList
UILWSunriseFoundation.RefreshGiftPack = RefreshGiftPack
UILWSunriseFoundation.RequestActivityDetialInfo = RequestActivityDetialInfo
UILWSunriseFoundation.JumpToNeedItem = JumpToNeedItem
return UILWSunriseFoundation
