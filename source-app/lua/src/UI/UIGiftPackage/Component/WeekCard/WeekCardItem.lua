local WeekCardItem = BaseClass("WeekCardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local GiftPackInfoDefault = require("DataCenter.GiftPackageData.GiftPackInfoDefault")
local Bg2Color = {
  UIWeekCard_img_card_gold = Color.New(0.7176470588235294, 0.4, 0.18823529411764706),
  UIWeekCard_img_card_purple = Color.New(0.6313725490196078, 0.27450980392156865, 0.6627450980392157)
}
local Bg2Outline = {
  UIWeekCard_img_card_gold = Color.New(0.8313725490196079, 0.5725490196078431, 0.24313725490196078),
  UIWeekCard_img_card_purple = Color.New(0.6313725490196078, 0.27450980392156865, 0.6627450980392157)
}
local bg_path = "Image"
local fg_path = "Image/icon"
local discount_path = "Image/discount"
local discountTxt_path = "Image/discount/discountTxt"
local name_path = "Image/title/name"
local mainDesc_path = "Image/desc"
local subDesc_path = "Image/subDesc"
local claimBtn_path = "Image/claimBtn"
local claimBtnTxt_path = "Image/claimBtn/claimBtnTxt"
local buyBtn_path = "Image/buyBtn"
local buyBtnTxt_path = "Image/buyBtn/PriceLayout/TxtPrice2"
local buyBtnTxtBuyAgain_path = "Image/buyBtn/PriceLayout/TxtBuyAgain"
local buyAgainBtn_path = "Image/buyAgainBtn"
local buyAgainBtnTxt_path = "Image/buyAgainBtn/buyAgainTxt"
local claimRed_path = "Image/claimBtn/redDot"
local isHot_path = "Image/isHot"
local isHotTxt_path = "Image/isHot/isHotTxt"
local remainDays_path = "Image/remainDays"
local giftPackagePoint_path = "Image/buyBtn/GiftPackagePoint"
local receiveDescGroup_path = "Image/ReceiveDescGroup"
local instantReceive_path = "Image/ReceiveDescGroup/InstantReceive"
local instantReceiveItemIcon_path = "Image/ReceiveDescGroup/InstantReceive/InstantReceiveItemIcon"
local instantReceiveItemCountText_path = "Image/ReceiveDescGroup/InstantReceive/InstantReceiveItemCountText"
local dailyClaim_path = "Image/ReceiveDescGroup/DailyClaim"
local dailyClaimItemIcon_path = "Image/ReceiveDescGroup/DailyClaim/DailyClaimItemIcon"
local dailyClaimItemCountText_path = "Image/ReceiveDescGroup/DailyClaim/DailyClaimItemCountText"
local totalGetBar_path = "Image/ReceiveDescGroup/TotalGetBar"
local totalGetBarItemIcon_path = "Image/ReceiveDescGroup/TotalGetBar/Layout/Content/TotalGetItemIcon"
local totalGetBarItemCountText_path = "Image/ReceiveDescGroup/TotalGetBar/Layout/Content/TotalGetCountItemText"
local stars_path = "Image/Stars"
local buyBtnDiscount_path = "Image/buyBtn/DiscountGroup"
local buyBtnDiscountPriceText_path = "Image/buyBtn/DiscountGroup/discount_price_text"
local buyBtnOriginalPriceText_path = "Image/buyBtn/DiscountGroup/price_text"
local buyBtnDiscountLine_path = "Image/buyBtn/DiscountGroup/line"
local claimedTodayText_path = "Image/ClaimedText"
local dailyResItemRoot_path = "Image/ReceiveDescGroup/DailyClaim/ItemRootDaily"
local dailyResItem_path = "Image/ReceiveDescGroup/DailyClaim/ItemRootDaily/UICommonResItemDaily"
local totalResItemRoot_path = "Image/ReceiveDescGroup/TotalGetBar/Layout/Content/ItemRootTotal/"
local totalResItem_path = "Image/ReceiveDescGroup/TotalGetBar/Layout/Content/ItemRootTotal/UICommonResItemTotal"
local discount_group_path = "Image/BuyNode/DiscountGroup"
local price_layout_path = "Image/BuyNode/PriceLayout"
local buy_node_path = "Image/BuyNode"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DelTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function WeekCardItem:OnDisable()
  if self.delayVfx then
    self.delayVfx:Stop()
    self.delayVfx = nil
  end
  if self.delayAni then
    self.delayAni:Stop()
    self.delayAni = nil
  end
  self:ClearGetNowReward()
  base.OnDisable(self)
end

function WeekCardItem:OnEnable()
  base.OnEnable(self)
end

local function ComponentDefine(self)
  self.bgN = self:AddComponent(UIImage, bg_path)
  self.fgN = self:AddComponent(UIImage, fg_path)
  self.discountN = self:AddComponent(UIBaseContainer, discount_path)
  self.discountTxtN = self:AddComponent(UIText, discountTxt_path)
  self.nameN = self:AddComponent(UIText, name_path)
  self.nameShadowN = self:AddComponent(UIShadow, name_path)
  self.mainDescN = self:AddComponent(UIText, mainDesc_path)
  self.subDescN = self:AddComponent(UIText, subDesc_path)
  self.claimBtnN = self:AddComponent(UIButton, claimBtn_path)
  self.claimBtnN:SetOnClick(function()
    self:OnClickClaimBtn()
  end)
  self.claimBtnTxtN = self:AddComponent(UIText, claimBtnTxt_path)
  self.claimBtnTxtN:SetLocalText(170004)
  self.discountGroup = self:AddComponent(LWBtnBuyRefundRemind, discount_group_path)
  self.priceLayout = self:AddComponent(LWBtnBuyRefundRemind, price_layout_path)
  self.discountGroup:SetBuyClickAction(function()
    self:OnClickBuyBtn()
  end)
  self.priceLayout:SetBuyClickAction(function()
    self:OnClickBuyBtn()
  end)
  self.discountGroup:SetSafeClickMode(true)
  self.priceLayout:SetSafeClickMode(true)
  self.priceLayout:SetDiscountText(Localization:GetString(320489))
  self.claimRedN = self:AddComponent(UIBaseContainer, claimRed_path)
  self.isHotN = self:AddComponent(UIBaseContainer, isHot_path)
  self.isHotN:SetActive(false)
  self.isHotTxtN = self:AddComponent(UIText, isHotTxt_path)
  self.remainDaysN = self:AddComponent(UIText, remainDays_path)
  self.receiveDescGroup = self:AddComponent(UIBaseContainer, receiveDescGroup_path)
  self.instantReceive = self:AddComponent(UIBaseContainer, instantReceive_path)
  self.instantReceiveItemIcon = self:AddComponent(UIImage, instantReceiveItemIcon_path)
  self.instantReceiveItemCountText = self:AddComponent(UIText, instantReceiveItemCountText_path)
  self.dailyClaim = self:AddComponent(UIBaseContainer, dailyClaim_path)
  self.dailyClaimItemIcon = self:AddComponent(UIImage, dailyClaimItemIcon_path)
  self.dailyClaimItemCountText = self:AddComponent(UIText, dailyClaimItemCountText_path)
  self.totalGetBar = self:AddComponent(UIBaseContainer, totalGetBar_path)
  self.totalGetBarItemIcon = self:AddComponent(UIImage, totalGetBarItemIcon_path)
  self.totalGetBarItemCountText = self:AddComponent(UIText, totalGetBarItemCountText_path)
  self.stars = self:AddComponent(UIBaseContainer, stars_path)
  self.textClaimedToday = self:AddComponent(UIText, claimedTodayText_path)
  self.textClaimedToday:SetLocalText("activity_98600_desc8")
  self.dailyResItemRoot = self:AddComponent(UIBaseContainer, dailyResItemRoot_path)
  self.dailyResItem = self:AddComponent(UICommonResItem, dailyResItem_path)
  self.totalResItemRoot = self:AddComponent(UIBaseContainer, totalResItemRoot_path)
  self.totalResItem = self:AddComponent(UICommonResItem, totalResItem_path)
  self.buyNode = self:AddComponent(UIBaseContainer, buy_node_path)
  self.titleIconS = self:AddComponent(UIImage, "Image/title/iconS")
  self.compRewardGetNowContent = self:AddComponent(UIBaseContainer, "Image/ReceiveDescGroup/InstantReceive/rewardGetNow/Viewport/rewardGetNowContent")
  local flagResPath = "Assets/Main/Prefabs/UI/LWGift/WeekCard/WeekCardItemNewFlag.prefab"
  self.newFlag = self:AddComponent(UIBaseContainer, "Image/newFlag")
  self.newFlagAni = self:LoadComponentAsync(UIAsyncContainer, flagResPath, self.newFlag)
  self.saoguanVfxNode = self:AddComponent(UIVfx, "Image/saoguanVfxNode")
  self.newFlag:SetActive(false)
  self.ani = self:AddComponent(UISimpleAnimation, "")
  self.alphaCpt = self:AddComponent(UICanvasGroup, "")
end

function WeekCardItem:ClearGetNowReward()
  self.compRewardGetNowContent:RemoveComponents(UICommonResItem)
  if self.getNowRewardReqs then
    for i, v in ipairs(self.getNowRewardReqs) do
      if v then
        v:Destroy()
      end
    end
    self.getNowRewardReqs = nil
  end
end

local function ComponentDestroy(self)
  self.compRewardGetNowContent = nil
  self.bgN = nil
  self.fgN = nil
  self.discountN = nil
  self.discountTxtN = nil
  self.nameN = nil
  self.nameShadowN = nil
  self.mainDescN = nil
  self.subDescN = nil
  self.claimBtnN = nil
  self.claimBtnTxtN = nil
  self.claimRedN = nil
  self.isHotN = nil
  self.isHotTxtN = nil
  self.remainDaysN = nil
  self.receiveDescGroup = nil
  self.instantReceive = nil
  self.instantReceiveItemIcon = nil
  self.instantReceiveItemCountText = nil
  self.dailyClaim = nil
  self.dailyClaimItemIcon = nil
  self.dailyClaimItemCountText = nil
  self.totalGetBar = nil
  self.totalGetBarItemIcon = nil
  self.totalGetBarItemCountText = nil
  self.stars = nil
  self.dailyResItemRoot = nil
  self.dailyResItem = nil
  self.totalResItemRoot = nil
  self.totalResItem = nil
  self.discountGroup = nil
  self.priceLayout = nil
  self.buyNode = nil
end

local function DataDefine(self)
  self.weekCardInfo = nil
  self.packageInfo = nil
  self.rewardGetNowIndex = 0
end

local function DataDestroy(self)
  self.weekCardInfo = nil
  self.packageInfo = nil
  self.rewardGetNowIndex = nil
end

local function RefreshPackageData(self)
  if self.weekCardInfo then
    self.packageInfo = GiftPackManager.get(self.weekCardInfo.exchangeId)
  end
end

function WeekCardItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnWeekCardInfoChange, self.RefreshAll)
  self:AddUIListener(EventId.UpdateGiftPackData, RefreshPackageData)
  self:AddUIListener(EventId.UIWeekCardShowNewClose, self.OnUIWeekCardShowNewClose)
end

function WeekCardItem:OnRemoveListener()
  self:RemoveUIListener(EventId.OnWeekCardInfoChange, self.RefreshAll)
  self:RemoveUIListener(EventId.UpdateGiftPackData, RefreshPackageData)
  self:RemoveUIListener(EventId.UIWeekCardShowNewClose, self.OnUIWeekCardShowNewClose)
  base.OnRemoveListener(self)
end

function WeekCardItem:OnUIWeekCardShowNewClose()
  if not self.weekCardInfo or not self.weekCardInfo.isNew then
    return
  end
  self:ShowNewFlagVfx()
end

local function SetItem(self, weekCardInfo)
  self.weekCardInfo = weekCardInfo
  self.packageInfo = GiftPackManager.get(self.weekCardInfo.exchangeId)
  self:RefreshAll()
end

function WeekCardItem:SetItemLocal(weekCardInfo)
  self.weekCardInfo = weekCardInfo
  self.packageInfo = GiftPackInfoDefault.New()
  local giftPackTemplate = DataCenter.GiftPackTemplateManager:GetGiftPackInfo(self.weekCardInfo.exchangeId)
  self.packageInfo._tableData = giftPackTemplate
  self.packageInfo._serverData = giftPackTemplate
  self:RefreshAll()
end

function WeekCardItem:SetAlpha(value)
  self.alphaCpt:SetAlpha(value)
end

function WeekCardItem:PlayShowAni(delayTime)
  if self.delayAni then
    self.delayAni:Stop()
    self.delayAni = nil
  end
  self.delayAni = TimerManager:GetInstance():DelayInvoke(function()
    self.ani:Play("show")
  end, delayTime)
end

local function RefreshAll(self, targetCardId)
  if targetCardId and targetCardId ~= self.weekCardInfo.id then
    return
  end
  if not self.packageInfo then
    return
  end
  self.rewardGetNowList = self.packageInfo:getItems(true)
  local bgImg = self.weekCardInfo.image
  if not string.IsNullOrEmpty(bgImg) then
    local bgPath = string.format("Assets/Main/Sprites/UI/UIWeekCard/%s", bgImg)
    self.fgN:LoadSprite(bgPath)
  end
  self.nameN:SetLocalText(self.weekCardInfo.name)
  local weekCardTemplate = LocalController:instance():getLine(TableName.WeekCard, self.weekCardInfo.id)
  local iconPath
  if weekCardTemplate then
    iconPath = self:GetSeasonIcon(weekCardTemplate.season_tips)
  end
  if iconPath then
    self.titleIconS:LoadSprite(iconPath)
    self.titleIconS:SetActive(true)
  else
    self.titleIconS:SetActive(false)
  end
  if self.weekCardInfo.discount > 0 then
    self.discountN:SetActive(true)
    self.discountTxtN:SetText(string.format("%s%%", self.weekCardInfo.discount))
  else
    self.discountN:SetActive(false)
  end
  local status = self.weekCardInfo:RefreshStatus()
  self:RefreshByStatus(status)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  self.expireTime = self.weekCardInfo.endTime
  if serverTime < self.expireTime then
    self:AddTimer()
    self:RefreshRemainTime()
  else
    self:DelTimer()
    self.remainDaysN:SetText(Localization:GetString("320485", self.weekCardInfo.validDays))
  end
end

local function ShowWeekCardType_1(self, status)
  if not self.weekCardInfo then
    return
  end
  self.receiveDescGroup:SetActive(false)
  self.stars:SetActive(true)
  self.mainDescN:SetActive(true)
  self.mainDescN:SetLocalText(self.weekCardInfo.desc)
  self.discountGroup:SetActive(true)
  self.priceLayout:SetActive(false)
  self.discountGroup:Init(self.packageInfo)
  self.discountGroup:RefreshPoint()
  self.discountGroup:SetDiscountText(self.packageInfo:getOriginalPriceText())
  local price = Localization:GetString(135225, self.packageInfo:getPriceText(), UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(self.packageInfo._tableData.time * 1000))
  self.discountGroup:SetPriceText(price)
  self.priceLayout:ShowDiscountText(false)
  if status == WeekCardPackageStatus.CannotBuy then
    self.buyNode:SetActive(true)
    self.claimBtnN:SetActive(false)
    UIGray.SetGray(self.buyNode.transform, true, false)
  elseif status == WeekCardPackageStatus.CanBuy or status == WeekCardPackageStatus.BuyAgain then
    self.buyNode:SetActive(true)
    self.claimBtnN:SetActive(false)
    UIGray.SetGray(self.buyNode.transform, false, true)
  end
  self.dailyResItemRoot:SetActive(false)
  self.totalResItemRoot:SetActive(false)
  if self.isShowNewStatus then
    self.buyNode:SetActive(false)
    self.claimBtnN:SetActive(false)
  end
end

local function ShowWeekCardType_2(self, status)
  self.receiveDescGroup:SetActive(true)
  self.stars:SetActive(false)
  self.mainDescN:SetActive(false)
  self.discountGroup:SetActive(false)
  self.priceLayout:SetActive(true)
  self.priceLayout:Init(self.packageInfo)
  self.priceLayout:RefreshPoint()
  self.instantReceiveItemCountText:SetText(self.packageInfo:getDiamond())
  local usingNewRewardUI = true
  self.dailyClaimItemIcon:SetActive(not usingNewRewardUI)
  self.totalGetBarItemIcon:SetActive(not usingNewRewardUI)
  self.dailyClaimItemCountText:SetActive(not usingNewRewardUI)
  self.totalGetBarItemCountText:SetActive(not usingNewRewardUI)
  self.dailyResItemRoot:SetActive(usingNewRewardUI)
  self.totalResItemRoot:SetActive(usingNewRewardUI)
  if not usingNewRewardUI then
    self.dailyClaimItemIcon:LoadSprite(self.weekCardInfo.showImg)
    self.totalGetBarItemIcon:LoadSprite(self.weekCardInfo.showImg)
    local dailyClaimCount = self.weekCardInfo:GetDailyRewardCount()
    local totalClaimCount = self.weekCardInfo.validDays * dailyClaimCount
    self.dailyClaimItemCountText:SetText(string.GetFormattedStr(dailyClaimCount))
    self.totalGetBarItemCountText:SetText(string.GetFormattedStr(totalClaimCount))
  else
    local reward
    if self.weekCardInfo.showReward ~= nil and self.weekCardInfo.showReward[1] ~= nil then
      reward = DeepCopy(self.weekCardInfo.showReward[1])
    end
    if reward ~= nil then
      self.dailyResItem:ReInit(reward)
      local totalReward = reward
      totalReward.count = totalReward.count * self.weekCardInfo.validDays
      self.totalResItem:ReInit(totalReward)
      self:RefreshGetNewRewardItemList()
    end
  end
  self.textClaimedToday:SetActive(status == WeekCardPackageStatus.BuyAgain)
  self.priceLayout:ShowDiscountText(status == WeekCardPackageStatus.BuyAgain)
  if status == WeekCardPackageStatus.CannotBuy then
    self.buyNode:SetActive(true)
    self.claimBtnN:SetActive(false)
    UIGray.SetGray(self.buyNode.transform, true, false)
  elseif status == WeekCardPackageStatus.CanBuy or status == WeekCardPackageStatus.BuyAgain then
    self.buyNode:SetActive(true)
    self.claimBtnN:SetActive(false)
    UIGray.SetGray(self.buyNode.transform, false, true)
  elseif status == WeekCardPackageStatus.CanClaim then
    self.buyNode:SetActive(false)
    self.claimBtnN:SetActive(true)
  end
  if self.isShowNewStatus then
    self.buyNode:SetActive(false)
    self.claimBtnN:SetActive(false)
    self.textClaimedToday:SetActive(false)
  end
end

local function RefreshByStatus(self, status)
  if self.weekCardInfo.typeFunction == 1 then
    ShowWeekCardType_1(self, status)
  elseif self.weekCardInfo.typeFunction == 2 then
    ShowWeekCardType_2(self, status)
  end
end

local function AddTimer(self)
  function self.CountDownTimerAction()
    self:RefreshRemainTime()
  end
  
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction, self, false, false, false)
  end
  self.countDownTimer:Start()
end

local function RefreshRemainTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.expireTime - curTime
  if 0 < remainTime then
    self.remainDaysN:SetText(UITimeManager:GetInstance():MillisionSecToWeekCardFormat(remainTime))
  else
    self:DelTimer()
    self:RefreshAll()
  end
end

local function DelTimer(self)
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

local function OnClickBuyBtn(self)
  if self.weekCardInfo and self.weekCardInfo:IsRenewWeekCountLimited() then
    UIUtil.ShowTipsId("weekcard_buy_alert1")
    return
  end
  self.view.ctrl:BuyGift(self.packageInfo)
end

local function OnClickClaimBtn(self)
  SFSNetwork.SendMessage(MsgDefines.ClaimWeekCardReward, self.weekCardInfo.id)
end

function WeekCardItem:OnGetItemByIndex(loopScroll, index)
  local count = table.count(self.rewardGetNowList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = loopScroll:NewListViewItem("UICommonResItem")
  local script = self.compRewardGetNowContent:GetComponent(item.gameObject.name, UICommonResItem)
  if script == nil then
    local objectName = tostring(self.rewardGetNowIndex)
    self.rewardGetNowIndex = self.rewardGetNowIndex + 1
    item.gameObject.name = objectName
    script = self.compRewardGetNowContent:AddComponent(UICommonResItem, objectName)
  end
  script:SetActive(true)
  local rewardInfo = self.rewardGetNowList[index]
  script:ReInit(rewardInfo)
  item.transform.localScale = Vector3.New(0.45, 0.45, 0.45)
  return item
end

function WeekCardItem:RefreshGetNewRewardItemList()
  if self.getNowRewardReqs then
    return
  end
  self.getNowRewardReqs = {}
  for i, v in ipairs(self.rewardGetNowList) do
    table.insert(self.getNowRewardReqs, self:CreateGetNewRewardItem(i))
  end
end

function WeekCardItem:CreateGetNewRewardItem(index)
  return self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
    if not request or request.isError then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.compRewardGetNowContent.transform)
    local goName = tostring(index)
    go.name = goName
    local rewardInfo = self.rewardGetNowList[index]
    local cell = self.compRewardGetNowContent:AddComponent(UICommonResItem, goName)
    if CommonUtil.IsArabic() then
      if CommonUtil.IsArabicAutoMirrorOpen() then
        cell:SetPivotXY(1, 1)
      else
        cell:SetPivotXY(0, 1)
      end
    else
      cell:SetPivotXY(0, 1)
    end
    cell:SetSizeDelta(Vector2.New(150, 150))
    cell:SetLocalScale(Vector3.New(0.45, 0.45, 0.45))
    cell:ReInit(rewardInfo)
  end)
end

function WeekCardItem:ShowNewFlagVfx()
  self:ShowNewGetDisplayVfx()
  self.delayVfx = TimerManager:GetInstance():DelayInvoke(function()
    self.newFlag:SetActive(true)
  end, 0.5)
end

function WeekCardItem:ShowNewGetDisplayVfx()
  self.saoguanVfxNode:PlayByOnce(VfxAssets.WeekCardItemSaoGuang)
end

function WeekCardItem:GetSeasonIcon(tips)
  if tonumber(tips) == 0 then
    return nil
  end
  local iconName = string.format("cfm_tianxiadashi_S%s", tips)
  local path = string.format(LoadPath.WeekCardPath, iconName)
  return path
end

function WeekCardItem:SetShowNewStatus(isNew)
  self.isShowNewStatus = isNew
end

WeekCardItem.OnCreate = OnCreate
WeekCardItem.OnDestroy = OnDestroy
WeekCardItem.ComponentDefine = ComponentDefine
WeekCardItem.ComponentDestroy = ComponentDestroy
WeekCardItem.DataDefine = DataDefine
WeekCardItem.DataDestroy = DataDestroy
WeekCardItem.SetItem = SetItem
WeekCardItem.RefreshAll = RefreshAll
WeekCardItem.RefreshByStatus = RefreshByStatus
WeekCardItem.OnClickBuyBtn = OnClickBuyBtn
WeekCardItem.OnClickClaimBtn = OnClickClaimBtn
WeekCardItem.AddTimer = AddTimer
WeekCardItem.RefreshRemainTime = RefreshRemainTime
WeekCardItem.DelTimer = DelTimer
return WeekCardItem
