local WeekCardMain = BaseClass("WeekCardMain", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local WeekCardItem = require("UI.UIGiftPackage.Component.WeekCard.WeekCardItem")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local title_path = "MsgBg/titleTxt"
local desc_path = "MsgBg/desTxt"
local freeRewardBtn_path = "MsgBg/TopBg/freeReward"
local freeRewardTxt_path = "MsgBg/TopBg/freeReward/freeTxt"
local freeRewardOpen_path = "MsgBg/TopBg/freeReward/opened"
local freeRewardUnopen_path = "MsgBg/TopBg/freeReward/unopen"
local freeRewardRed_path = "MsgBg/TopBg/freeReward/unopen/RedDot"
local packageSv_path = "MsgBg/Scroll View"
local packageContent_path = "MsgBg/Scroll View/Viewport/Content"
local quickFunctionBtns_path = "MsgBg/TopBg/QuickFunctionBtns"
local allBuyBtn_path = "MsgBg/TopBg/QuickFunctionBtns/AllBuyBtn"
local allBuyBtnPriceText_path = "MsgBg/TopBg/QuickFunctionBtns/AllBuyBtn/AllBuyBtnPriceText"
local allBuyBtnTitleText_path = "MsgBg/TopBg/QuickFunctionBtns/AllBuyBtn/AllBuyBtnText"
local allBuyBtnPoint_path = "MsgBg/TopBg/QuickFunctionBtns/AllBuyBtn/UIGiftPackagePoint"
local allClaimBtn_path = "MsgBg/TopBg/QuickFunctionBtns/AllClaimBtn"
local allBuyDescText_path = "MsgBg/TopBg/AllBuyDescText"
local discount_path = "MsgBg/TopBg/Discount"
local discount_txt_path = "MsgBg/TopBg/Discount/DiscountTxt"
local CARD_ITEM_SHOW_ANI_DELAY_TIME = 0.05
local CARD_ITEM_SHOW_ANI_DELAY_DELTA = 0.05

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  if self.claimFreeTimer then
    self.claimFreeTimer:Stop()
    self.claimFreeTimer = nil
  end
  self:ComponentDestroy()
  self:DataDestroy()
  self.allWeekCardPackageId = nil
  base.OnDestroy(self)
end

local function RefreshPackageData(self)
  if not self.allWeekCardPackageId then
    self.allWeekCardPackageId = DataCenter.WeekCardManager:GetBuyAllPackageId()
  end
  if self.allWeekCardPackageId then
    self.allBuyPackage = GiftPackageData.get(tostring(self.allWeekCardPackageId))
  end
  self:RefreshAllBuyPercent()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnWeekCardInfoChange, self.OnRefreshAll)
  self:AddUIListener(EventId.UpdateGiftPackData, RefreshPackageData)
  self:AddUIListener(EventId.UIWeekCardShowNewOpen, self.OnUIWeekCardShowNewOpen)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
  self:AddUIListener(EventId.UpdateWeekCardFreeGiftData, self.RefreshFreePackage)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnWeekCardInfoChange, self.OnRefreshAll)
  self:RemoveUIListener(EventId.UpdateGiftPackData, RefreshPackageData)
  self:RemoveUIListener(EventId.UIWeekCardShowNewOpen, self.OnUIWeekCardShowNewOpen)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  self:RemoveUIListener(EventId.UpdateWeekCardFreeGiftData, self.RefreshFreePackage)
  base.OnRemoveListener(self)
end

local function AllBuy(self)
  if self.weekCardList then
    local minLeftTimeWeekCardInfo
    for i, v in pairs(self.weekCardList) do
      if minLeftTimeWeekCardInfo == nil or v.endTime < minLeftTimeWeekCardInfo.endTime then
        minLeftTimeWeekCardInfo = v
      end
    end
    if minLeftTimeWeekCardInfo and minLeftTimeWeekCardInfo:IsRenewWeekCountLimited() then
      UIUtil.ShowTipsId("weekcard_buy_alert3")
      return
    end
  end
  if self.allBuyPackage then
    self.view.ctrl:BuyGift(self.allBuyPackage)
  end
end

local function AllClaim(self)
  SFSNetwork.SendMessage(MsgDefines.ClaimAllWeekCardRewardMessage)
end

function WeekCardMain:OnPassDay()
  SFSNetwork.SendMessage(MsgDefines.GetWeekCardList, false)
end

local function RefreshAllBtn(self)
  if table.IsNullOrEmpty(self.weekCardList) then
    self.quickFunctionBtns:SetActive(false)
    return
  end
  local canClaim = false
  local hasBoughtAll = true
  for i, v in pairs(self.weekCardList) do
    local status = v:RefreshStatus()
    if v.status == WeekCardPackageStatus.CanClaim then
      canClaim = true
    end
    local hasBought = v.status == WeekCardPackageStatus.CanClaim or v.status == WeekCardPackageStatus.BuyAgain
    if not hasBought then
      hasBoughtAll = false
    end
  end
  local allBtnTitleText = ""
  if hasBoughtAll and not canClaim then
    allBtnTitleText = Localization:GetString("weekcard_allrepaid")
  else
    allBtnTitleText = Localization:GetString(2000124)
  end
  self.allBuyBtn:SetDiscountText(allBtnTitleText)
  self.quickFunctionBtns:SetActive(true)
  if canClaim then
    self.allClaimBtn:SetActive(true)
    self.allBuyBtn:SetActive(false)
  else
    self.allClaimBtn:SetActive(false)
    self.allBuyBtn:SetActive(true)
    if self.allBuyPackage then
      self.allBuyBtn:Init(self.allBuyPackage)
    end
    self.allBuyBtn:RefreshPoint()
  end
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "MsgBg")
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(320457)
  self.descN = self:AddComponent(UIText, desc_path)
  self.descN:SetLocalText(320488)
  self.freeBtnAnimN = self:AddComponent(UIAnimator, freeRewardBtn_path)
  self.freeRewardBtnN = self:AddComponent(UIButton, freeRewardBtn_path)
  self.freeRewardBtnN:SetOnClick(function()
    self:OnClickFreeRewardBtn()
  end)
  self.freeRewardTxtN = self:AddComponent(UIText, freeRewardTxt_path)
  self.freeRewardTxtN:SetLocalText(320487)
  self.freeRewardTxtN:SetActive(true)
  self.freeRewardOpenN = self:AddComponent(UIBaseContainer, freeRewardOpen_path)
  self.freeRewardUnopenN = self:AddComponent(UIBaseContainer, freeRewardUnopen_path)
  self.freeRewardRedN = self:AddComponent(UIBaseContainer, freeRewardRed_path)
  self.packageSvN = self:AddComponent(UIScrollView, packageSv_path)
  self.packageSvN:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.packageSvN:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.packageContentN = self:AddComponent(UIBaseContainer, packageContent_path)
  self.quickFunctionBtns = self:AddComponent(UIBaseContainer, quickFunctionBtns_path)
  self.allBuyBtn = self:AddComponent(LWBtnBuyRefundRemind, allBuyBtn_path)
  self.allBuyBtn:SetBuyClickAction(function()
    AllBuy(self)
  end)
  self.allBuyBtn:SetSafeClickMode(true)
  self.allClaimBtn = self:AddComponent(UIButton, allClaimBtn_path)
  self.allClaimBtn:SetOnClick(function()
    AllClaim(self)
  end)
  self.allBuyDescText = self:AddComponent(UIText, allBuyDescText_path)
  self.allBuyDescText:SetLocalText(2000125, UITimeManager:GetInstance():SecondToFmtStringWithoutDay(UITimeManager:GetInstance():GetServerTimeToLocal(0)))
  self.discount = self:AddComponent(UIImage, discount_path)
  self.discountTxt = self:AddComponent(UIText, discount_txt_path)
  self.buyAllGetRewardList = self:AddComponent(UILoopListView2, "MsgBg/TopBg/buyAllGetRewardList")
  self.buyAllGetRewardList:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
  self.buyAllGetRewardContent = self:AddComponent(UIBaseContainer, "MsgBg/TopBg/buyAllGetRewardList/Viewport/buyAllGetRewardContent")
  self.NameInfoBtn = self:AddComponent(UIButton, "MsgBg/TopBg/NameInfoBtn")
  self.NameInfoBtn:SetOnClick(function()
    local param = {}
    param.title = LuaEntry.DataConfig:TryGetStr("weekcard_config_new", "k2", "common_weekcard_title01")
    param.activityRulesStr = Localization:GetString(LuaEntry.DataConfig:TryGetStr("weekcard_config_new", "k3", "common_weekcard_desc01"))
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.NameSecondText = self:AddComponent(UITextMeshProUGUIEx, "MsgBg/TopBg/NameSecondText")
  self.NameSecondText:SetLocalText(LuaEntry.DataConfig:TryGetStr("weekcard_config_new", "k1", "2000125"), UITimeManager:GetInstance():SecondToFmtStringWithoutDay(UITimeManager:GetInstance():GetServerTimeToLocal(0)))
end

function WeekCardMain:ClearRewards()
  self.buyAllGetRewardContent:RemoveComponents(UICommonResItem)
  self.buyAllGetRewardList:ClearAllItems()
end

local function ComponentDestroy(self)
  self:ClearRewards()
  self.buyAllGetRewardList = nil
  self.buyAllGetRewardContent = nil
  self.root = nil
  self.titleN = nil
  self.descN = nil
  self.freeRewardBtnN = nil
  self.freeRewardOpenN = nil
  self.freeRewardUnopenN = nil
  self.freeRewardRedN = nil
  self.packageSvN = nil
  self.packageContentN = nil
  self.quickFunctionBtns = nil
  self.allBuyBtn = nil
  self.allClaimBtn = nil
  self.allBuyBtnPriceText = nil
  self.allBuyDescText = nil
  self.discount = nil
  self.discountTxt = nil
end

function WeekCardMain:OnEnable()
  base.OnEnable(self)
  self.delayAnimFlags = {}
end

function WeekCardMain:OnDisable()
  self.delayAnimFlags = nil
  self.playItemShowAniTime = nil
  self:ClearScroll()
  base.OnDisable(self)
end

local function DataDefine(self)
  self.dataInited = false
  self.weekCardList = {}
  self.rewardIndex = 0
  self.delayAnimFlags = {}
end

local function DataDestroy(self)
  self.dataInited = nil
  self.weekCardList = nil
  self.rewardIndex = nil
  self.delayAnimFlags = nil
end

local function ReInit(self)
  self:InitData()
end

local function InitData(self)
  if not self.dataInited then
    SFSNetwork.SendMessage(MsgDefines.GetWeekCardList, false)
    self.dataInited = true
  else
    self:RefreshAll()
  end
  self.freeRewardRedN:SetActive(false)
end

local function OnRefreshAll(self, weekCardId)
  if not weekCardId then
    self:RefreshAll()
  else
    RefreshAllBtn(self)
  end
end

local function RefreshAll(self)
  self.weekCardList = DataCenter.WeekCardManager:GetWeekCardList()
  if self.weekCardList == nil then
    return
  end
  self.allWeekCardPackageId = DataCenter.WeekCardManager:GetBuyAllPackageId()
  if self.allWeekCardPackageId then
    self.allBuyPackage = GiftPackageData.get(tostring(self.allWeekCardPackageId))
  end
  self.rewardList = self:GetRewardList()
  self:RefreshAllBuyPercent()
  self:RefreshFreePackage()
  self:RefreshPackages()
  self.buyAllGetRewardList:SetListItemCount(#self.rewardList, false, false)
  self.buyAllGetRewardList:RefreshAllShownItem()
  RefreshAllBtn(self)
end

function WeekCardMain:OnUIWeekCardShowNewOpen(cardInfo)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWeekCardShowNew, {anim = true}, cardInfo)
end

local function RefreshFreePackage(self)
  local hasFree = DataCenter.WeekCardManager:CheckIfHasFreeReward()
  if not hasFree then
    self.freeBtnAnimN:Play("V_ui_zhoukabaoxiang_01_opened", 0, 0)
    self.freeRewardOpenN:SetActive(true)
    self.freeRewardUnopenN:SetActive(false)
    self.freeRewardTxtN:SetLocalText(170003)
  else
    self.freeBtnAnimN:Play("V_ui_zhoukabaoxiang_01_idle", 0, 0)
    self.freeRewardOpenN:SetActive(false)
    self.freeRewardUnopenN:SetActive(true)
    self.freeRewardTxtN:SetLocalText(320487)
  end
end

local function RefreshPackages(self)
  if #self.weekCardList > 0 then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.rectTransform)
    self.packageSvN:SetTotalCount(#self.weekCardList)
    self.packageSvN:RefillCells(1, true)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.packageSvN:AddComponent(WeekCardItem, itemObj)
  local weekCardInfo = self.weekCardList[index]
  cellItem:SetItem(weekCardInfo)
  cellItem:SetAlpha(0)
  if self.delayAnimFlags and not self.delayAnimFlags[index] then
    if index == 1 then
      self.playItemShowAniTime = Time.realtimeSinceStartup
    end
    local delayTime = CARD_ITEM_SHOW_ANI_DELAY_TIME + index * CARD_ITEM_SHOW_ANI_DELAY_DELTA
    if self.playItemShowAniTime and Time.realtimeSinceStartup - self.playItemShowAniTime < delayTime + CARD_ITEM_SHOW_ANI_DELAY_DELTA then
      cellItem:PlayShowAni(delayTime)
    else
      cellItem:SetAlpha(1)
    end
    self.delayAnimFlags[index] = true
  else
    cellItem:SetAlpha(1)
  end
end

local function OnItemMoveOut(self, itemObj, index)
  self.packageSvN:RemoveComponent(itemObj.name, WeekCardItem)
end

local function ClearScroll(self)
  self.packageSvN:ClearCells()
  self.packageSvN:RemoveComponents(WeekCardItem)
end

local function OnClickFreeRewardBtn(self)
  local hasFree = DataCenter.WeekCardManager:CheckIfHasFreeReward()
  if hasFree then
    self.freeBtnAnimN:Play("V_ui_zhoukabaoxiang_01_open", 0, 0)
    self.claimFreeTimer = TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.ClaimWeekCardFreeReward, false)
      self.claimFreeTimer = nil
      if self.freeRewardTxtN then
        self.freeRewardTxtN:SetLocalText(170003)
      end
    end, 0.2)
  end
end

local function RefreshAllBuyPercent(self)
  if self.allBuyPackage then
    local discount = self.allBuyPackage:getPercent()
    if discount then
      self.discount:SetActive(true)
      self.discountTxt:SetLocalText("giftpackage_value", discount)
    else
      self.discount:SetActive(false)
    end
  else
    self.discount:SetActive(false)
  end
end

function WeekCardMain:OnGetItemByIndex(loopScroll, index)
  local count = table.count(self.rewardList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = loopScroll:NewListViewItem("UICommonResItem")
  local script = self.buyAllGetRewardContent:GetComponent(item.gameObject.name, UICommonResItem)
  if script == nil then
    local objectName = tostring(self.rewardIndex)
    self.rewardIndex = self.rewardIndex + 1
    item.gameObject.name = objectName
    script = self.buyAllGetRewardContent:AddComponent(UICommonResItem, objectName)
  end
  script:SetActive(true)
  script:SetLocalScaleXYZ(0.63, 0.63, 0.63)
  local rewardInfo = self.rewardList[index]
  script:ReInit(rewardInfo)
  return item
end

function WeekCardMain:GetRewardList()
  local itemDic = {}
  local itemList = {}
  for i, v in ipairs(self.weekCardList) do
    if v then
      local packageInfo = GiftPackManager.get(v.exchangeId)
      local items = packageInfo:getItems(true)
      for j, item in ipairs(items) do
        if item.rewardType ~= RewardType.ALLIANCE_GIFT then
          if itemDic[item.rewardType] then
            itemDic[item.rewardType].count = itemDic[item.rewardType].count + item.count
          else
            itemDic[item.rewardType] = self:GetRewardItemCopy(item)
          end
        end
      end
    end
  end
  for i, v in pairs(itemDic) do
    table.insert(itemList, v)
  end
  local allBuyPackageItems = self.allBuyPackage:getItems(true)
  for i, item in ipairs(allBuyPackageItems) do
    if item.rewardType == RewardType.ALLIANCE_GIFT then
      table.insert(itemList, self:GetRewardItemCopy(item))
      break
    end
  end
  return itemList
end

function WeekCardMain:GetRewardItemCopy(item)
  local newItem = {}
  newItem.id = item.id
  newItem.rewardType = item.rewardType
  newItem.count = item.count
  newItem.iconName = item.iconName
  newItem.itemName = item.itemName
  newItem.itemDesc = item.itemDesc
  newItem.isLocal = item.isLocal
  newItem.itemColor = item.itemColor
  newItem.itemId = item.itemId
  return newItem
end

WeekCardMain.OnCreate = OnCreate
WeekCardMain.OnDestroy = OnDestroy
WeekCardMain.OnAddListener = OnAddListener
WeekCardMain.OnRemoveListener = OnRemoveListener
WeekCardMain.ComponentDefine = ComponentDefine
WeekCardMain.ComponentDestroy = ComponentDestroy
WeekCardMain.DataDefine = DataDefine
WeekCardMain.DataDestroy = DataDestroy
WeekCardMain.ReInit = ReInit
WeekCardMain.InitData = InitData
WeekCardMain.RefreshAll = RefreshAll
WeekCardMain.RefreshFreePackage = RefreshFreePackage
WeekCardMain.RefreshPackages = RefreshPackages
WeekCardMain.OnRefreshAll = OnRefreshAll
WeekCardMain.OnItemMoveIn = OnItemMoveIn
WeekCardMain.OnItemMoveOut = OnItemMoveOut
WeekCardMain.ClearScroll = ClearScroll
WeekCardMain.OnClickFreeRewardBtn = OnClickFreeRewardBtn
WeekCardMain.RefreshAllBuyPercent = RefreshAllBuyPercent
return WeekCardMain
