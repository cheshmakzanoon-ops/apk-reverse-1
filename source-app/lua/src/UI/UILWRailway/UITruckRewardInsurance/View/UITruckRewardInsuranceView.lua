local UITruckRewardInsuranceView = BaseClass("UITruckRewardInsuranceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local UITruckRewardInsuranceRewardShell = require("UI.UILWRailway.UITruckRewardInsurance.Component.UITruckRewardInsuranceRewardShell")
local UITruckRewardInsuranceHistoryItem = require("UI.UILWRailway.UITruckRewardInsurance.Component.UITruckRewardInsuranceHistoryItem")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")

function UITruckRewardInsuranceView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UITruckRewardInsuranceView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITruckRewardInsuranceView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnTip = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnTip:SetOnClick(function()
    self:OnBtnTipClick()
  end)
  self.compUICommonToggleList = self.viewSkin:AddComponent(self, UICommonToggleListComponent, 4)
  self.compInsuranceContent = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compHistoryContent = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.textFreeRefundDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compFreeRefundContent = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.textMonthCardRefundDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.gridInfinityMonthCardRefund = self.viewSkin:AddComponent(self, GridInfinityScrollView, 10)
  self.textHistoryDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.loopListView2HistoryScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 12)
  self.compHistoryScrollContent = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.btnClaim = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.compBuyButton = self.viewSkin:AddComponent(self, LWBtnBuyRefundRemind, 15)
  self.textBtnClaimDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.gridInfinityMonthCardRefundContent = self.viewSkin:AddComponent(self, UIBaseContainer, 17)
  self.textExtendMonthCardTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.textFreeRefundEmptyDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.compHistoryEmpty = self.viewSkin:AddComponent(self, UIBaseContainer, 20)
  self.textHistoryEmptyDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.compMonthCardRefundEmpty = self.viewSkin:AddComponent(self, UIBaseContainer, 22)
  self.textMonthCardRefundEmptyDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.imgRewardIcon1 = self.viewSkin:AddComponent(self, UIImage, 24)
  self.imgRewardIcon2 = self.viewSkin:AddComponent(self, UIImage, 25)
  self.imgRewardIcon3 = self.viewSkin:AddComponent(self, UIImage, 26)
  self.btnHistory = self.viewSkin:AddComponent(self, UIButton, 27)
  self.btnHistory:SetOnClick(function()
    self:OnBtnHistoryClick()
  end)
end

function UITruckRewardInsuranceView:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.textTitleTxt = nil
  self.btnTip = nil
  self.compUICommonToggleList = nil
  self.compInsuranceContent = nil
  self.compHistoryContent = nil
  self.textFreeRefundDesc = nil
  self.compFreeRefundContent = nil
  self.textMonthCardRefundDesc = nil
  self.gridInfinityMonthCardRefund = nil
  self.textHistoryDesc = nil
  self.loopListView2HistoryScrollView = nil
  self.compHistoryScrollContent = nil
  self.btnClaim = nil
  self.compBuyButton = nil
  self.textBtnClaimDesc = nil
  self.gridInfinityMonthCardRefundContent = nil
  self.textExtendMonthCardTips = nil
  self.textFreeRefundEmptyDesc = nil
  self.compHistoryEmpty = nil
  self.textHistoryEmptyDesc = nil
  self.compMonthCardRefundEmpty = nil
  self.textMonthCardRefundEmptyDesc = nil
  self.imgRewardIcon1 = nil
  self.imgRewardIcon2 = nil
  self.imgRewardIcon3 = nil
  self.btnHistory = nil
end

local function OnInitScroll(self, go, index)
  local item = self.gridInfinityMonthCardRefundContent:AddComponent(UITruckRewardInsuranceRewardShell, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local item = self.listGO[go]
  local rewardData = self.monthCardShowList[index + 1]
  item:SetData(rewardData)
end

local function OnDestroyScrollItem(self, go, index)
end

function UITruckRewardInsuranceView:DataDefine()
  self.golloesMonthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
  self.curTabIndex = nil
  self.insurancePageData = nil
  self.historyPageData = nil
  self.compBuyButton:SetBuyClickAction(function()
    self:OnClickBuyBtn()
  end)
  self.monthCardShowList = {}
  self.listGO = {}
  local bindFunc1 = BindCallback(self, OnInitScroll)
  local bindFunc2 = BindCallback(self, OnUpdateScroll)
  local bindFunc3 = BindCallback(self, OnDestroyScrollItem)
  self.gridInfinityMonthCardRefund:Init(bindFunc1, bindFunc2, bindFunc3)
  self.freeItemReqs = {}
  self.historyItemScriptDic = {}
  self.loopListView2HistoryScrollView:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
  self.btnClaim:SetSafeClickMode(true)
  self.compBuyButton:SetSafeClickMode(true)
  self.btnHistory:SetSafeClickMode(true)
  self.compHistoryContent:SetActive(false)
  self.compInsuranceContent:SetActive(false)
  self.btnClaim:SetActive(false)
  self.compBuyButton:SetActive(false)
  self.btnHistory:SetActive(false)
  self.textFreeRefundEmptyDesc:SetActive(false)
  self.compMonthCardRefundEmpty:SetActive(false)
  self.compHistoryEmpty:SetActive(false)
  local isOn = CommonUtil.PlayerPrefsGetBool(SettingKeys.TRUCK_INSURANCE_HOW_TO_PLAY, true)
  if isOn then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {100051}
    })
    CommonUtil.PlayerPrefsSetBool(SettingKeys.TRUCK_INSURANCE_HOW_TO_PLAY, false)
  end
end

function UITruckRewardInsuranceView:DataDestroy()
  self.golloesMonthCard = nil
  self.curTabIndex = nil
  self.insurancePageData = nil
  self:ClearFreeRewardContent()
  self.monthCardShowList = nil
  self:ClearMonthCardRewardContent()
  self.listGO = nil
  self.historyPageData = nil
  self.historyItemScriptDic = {}
  self.compHistoryScrollContent:RemoveComponents(UITruckRewardInsuranceHistoryItem)
  self.loopListView2HistoryScrollView:ClearAllItems()
end

function UITruckRewardInsuranceView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshTruckInsuranceRefundPage, self.RefreshInsurancePageByMsg)
  self:AddUIListener(EventId.RefreshTruckInsuranceHistoryPage, self.RefreshHistoryPageByMsg)
  self:AddUIListener(EventId.MonthCardInfoUpdated, self.RefreshView_BuyMonthCard)
  self:AddUIListener(EventId.GetTruckInsuranceReward, self.RefreshView_ClaimReward)
end

function UITruckRewardInsuranceView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshTruckInsuranceRefundPage, self.RefreshInsurancePageByMsg)
  self:RemoveUIListener(EventId.RefreshTruckInsuranceHistoryPage, self.RefreshHistoryPageByMsg)
  self:RemoveUIListener(EventId.MonthCardInfoUpdated, self.RefreshView_BuyMonthCard)
  self:RemoveUIListener(EventId.GetTruckInsuranceReward, self.RefreshView_ClaimReward)
  base.OnRemoveListener(self)
end

function UITruckRewardInsuranceView:RefreshView()
  self.textTitleTxt:SetLocalText("month_card_title_01")
  local monthCardCfg = self.golloesMonthCard:GetMonthCardCfg()
  if monthCardCfg then
    local showIconStr = monthCardCfg.goods_pre or ""
    local iconList = string.split(showIconStr, ";")
    self.imgRewardIcon1:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(iconList[1]))
    self.imgRewardIcon2:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(iconList[2]))
    self.imgRewardIcon3:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(iconList[3]))
  end
  local itemsDataList = {}
  table.insert(itemsDataList, {
    name = Localization:GetString("month_card_tab_02")
  })
  table.insert(itemsDataList, {
    name = Localization:GetString("month_card_tab_03")
  })
  local toggleListData = {}
  toggleListData.itemsDataList = itemsDataList
  
  function toggleListData.onItemSelect(index, itemData)
    self:OnSelectTabToggle(index, itemData)
  end
  
  self.compUICommonToggleList:ReInit(toggleListData)
end

function UITruckRewardInsuranceView:RefreshView_BuyMonthCard()
  self:RefreshBtns()
  self:RefreshInsurancePageRewards()
  self:RefreshInsurancePageDesc()
end

function UITruckRewardInsuranceView:RefreshView_ClaimReward()
  if #self.insurancePageData:GetFreeReward() <= 0 then
    self.textFreeRefundDesc:SetLocalText("month_card_desc_18")
  end
  if 0 >= #self.insurancePageData:GetVipReward() then
    self.textMonthCardRefundDesc:SetLocalText("month_card_desc_19")
  end
  self:RefreshBtns()
  self:RefreshInsurancePageRewards()
end

function UITruckRewardInsuranceView:OnSelectTabToggle(index, itemData)
  if self.curTabIndex == index then
    return
  end
  self.curTabIndex = index
  if self.curTabIndex == 1 then
    self:RefreshInsurancePage()
  else
    self:RefreshHistoryPage()
  end
end

function UITruckRewardInsuranceView:RefreshInsurancePage()
  if self.insurancePageData == nil then
    SFSNetwork.SendMessage(MsgDefines.TruckMonthcardPrivilegeGetInfo)
    return
  end
  self.compHistoryContent:SetActive(false)
  self.compInsuranceContent:SetActive(true)
  self:RefreshInsurancePageDesc()
  self:RefreshInsurancePageRewards()
  self:RefreshBtns()
  local logCount = self.insurancePageData and self.insurancePageData:GetLogCount() or 0
  self.textHistoryDesc:SetText(Localization:GetString("month_card_desc_07", logCount))
end

function UITruckRewardInsuranceView:RefreshHistoryPage()
  if self.historyPageData == nil then
    SFSNetwork.SendMessage(MsgDefines.TruckMonthcardPrivilegeGetRecord)
    return
  end
  self.compHistoryContent:SetActive(true)
  self.compInsuranceContent:SetActive(false)
  self:RefreshHistoryPageRecords()
  self:RefreshBtns()
end

function UITruckRewardInsuranceView:RefreshBtns()
  self.btnClaim:SetActive(self.curTabIndex == 1)
  self.compBuyButton:SetActive(self.curTabIndex == 1)
  self.btnHistory:SetActive(self.curTabIndex == 2)
  if self.curTabIndex == 1 then
    local canClaimFreeReward = #self.insurancePageData:GetFreeReward() > 0
    local isOpen = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
    local canClaimMonthCardReward = isOpen and 0 < #self.insurancePageData:GetVipReward()
    if canClaimFreeReward or canClaimMonthCardReward then
      self.textBtnClaimDesc:SetLocalText("month_card_tab_21")
      UIGray.SetGray(self.btnClaim.transform, false, true)
    elseif not isOpen and 0 < #self.insurancePageData:GetVipReward() then
      self.textBtnClaimDesc:SetLocalText("month_card_tab_23")
      UIGray.SetGray(self.btnClaim.transform, false, true)
    else
      self.textBtnClaimDesc:SetLocalText("month_card_tab_21")
      UIGray.SetGray(self.btnClaim.transform, true, false)
    end
    self.compBuyButton:Init(self.golloesMonthCard.packageData)
    local isCanBuy = not self.golloesMonthCard:IsBought()
    if self.golloesMonthCard:IsBought() then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local remainTime = self.golloesMonthCard.endTime - curTime
      local days = math.ceil(remainTime / (OneDayTime * 1000))
      local maxDays = LuaEntry.DataConfig:TryGetNum("monthcard_purchase", "k1") * 30
      isCanBuy = maxDays >= days + 30
    end
    self.compBuyButton:SetActive(not self.golloesMonthCard:IsBought() or isCanBuy)
    self.compBuyButton:RefreshPoint()
    self.textExtendMonthCardTips:SetActive(self.golloesMonthCard:IsBought())
    self.textExtendMonthCardTips:SetLocalText("monthcard_extend")
  end
end

function UITruckRewardInsuranceView:RefreshInsurancePageByMsg()
  self.insurancePageData = DataCenter.MonthCardNewManager:GetMonthCardPrivilege()
  if self.insurancePageData == nil then
    return
  end
  if self.curTabIndex ~= 1 then
    return
  end
  self:RefreshInsurancePage()
  self:RefreshBtns()
end

function UITruckRewardInsuranceView:RefreshInsurancePageDesc()
  local isOpen = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
  if not isOpen then
    local isToLimit = DataCenter.MonthCardNewManager:IsTruckInsuranceToLimit_Free()
    if isToLimit then
      self.textFreeRefundDesc:SetText(Localization:GetString("month_card_desc_12") .. Localization:GetString("month_card_desc_17"))
    else
      self.textFreeRefundDesc:SetText(Localization:GetString("month_card_desc_12"))
    end
  else
    local hasFreeReward = self.insurancePageData:GetHasFreeReward()
    if hasFreeReward then
      self.textFreeRefundDesc:SetText(Localization:GetString("month_card_desc_14"))
    else
      local isToLimit = DataCenter.MonthCardNewManager:IsTruckInsuranceToLimit_Free()
      if isToLimit then
        self.textFreeRefundDesc:SetText(Localization:GetString("month_card_desc_12") .. Localization:GetString("month_card_desc_17"))
      else
        self.textFreeRefundDesc:SetText(Localization:GetString("month_card_desc_12"))
      end
    end
  end
  if not isOpen then
    local isToLimit, maxLimit = DataCenter.MonthCardNewManager:IsTruckInsuranceToLimit_MonthCard()
    if isToLimit then
      self.textMonthCardRefundDesc:SetText(Localization:GetString("month_card_desc_13", maxLimit) .. Localization:GetString("month_card_desc_17"))
    else
      self.textMonthCardRefundDesc:SetText(Localization:GetString("month_card_desc_13", maxLimit))
    end
  else
    local hasExtraReward = self.insurancePageData:GetHasExtraReward()
    if hasExtraReward then
      self.textMonthCardRefundDesc:SetText(Localization:GetString("month_card_desc_15"))
    else
      local isToLimit, maxLimit = DataCenter.MonthCardNewManager:IsTruckInsuranceToLimit_MonthCard()
      if isToLimit then
        self.textMonthCardRefundDesc:SetText(Localization:GetString("month_card_desc_16") .. Localization:GetString("month_card_desc_17"))
      else
        self.textMonthCardRefundDesc:SetText(Localization:GetString("month_card_desc_16"))
      end
    end
  end
end

function UITruckRewardInsuranceView:RefreshInsurancePageRewards()
  self:ClearFreeRewardContent()
  local freeList = self.insurancePageData:GetFreeReward()
  self.textFreeRefundEmptyDesc:SetActive(#freeList <= 0)
  self.textFreeRefundEmptyDesc:SetLocalText("month_card_desc_24")
  if 0 < #freeList then
    local freeShowList = DataCenter.RewardManager:ReturnRewardParamForView(freeList)
    self:RefreshRewardList(freeShowList, self.compFreeRefundContent)
  end
  local monthCardList = self.insurancePageData:GetVipReward()
  self.compMonthCardRefundEmpty:SetActive(#monthCardList <= 0)
  self.textMonthCardRefundEmptyDesc:SetLocalText("month_card_desc_24")
  self.monthCardShowList = DataCenter.RewardManager:ReturnRewardParamForView(monthCardList) or {}
  self.gridInfinityMonthCardRefund:SetItemCount(#self.monthCardShowList)
  self.gridInfinityMonthCardRefund:ForceUpdate()
end

function UITruckRewardInsuranceView:RefreshRewardList(rewardList, contentScript)
  if not table.IsNullOrEmpty(rewardList) then
    for i, data in pairs(rewardList) do
      local req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "reward_item" .. i
        item:SetActive(true)
        item.transform:SetParent(contentScript.transform)
        item.transform:Set_localScale(0.9, 0.9, 0.9)
        item.transform:Set_sizeDelta(118, 118)
        item.transform:Set_pivot(0.5, 0.5)
        local cell = contentScript:AddComponent(UICommonResItem, item.name)
        cell:ReInit(data)
      end)
      table.insert(self.freeItemReqs, req)
    end
  end
end

function UITruckRewardInsuranceView:ClearFreeRewardContent()
  self.compFreeRefundContent:RemoveComponents(UICommonResItem)
  if self.freeItemReqs and table.count(self.freeItemReqs) then
    for _, req in pairs(self.freeItemReqs) do
      req:Destroy()
    end
    self.freeItemReqs = {}
  end
end

function UITruckRewardInsuranceView:ClearMonthCardRewardContent()
  self.gridInfinityMonthCardRefundContent:RemoveComponents(UITruckRewardInsuranceRewardShell)
  self.gridInfinityMonthCardRefund:DestroyChildNode()
end

function UITruckRewardInsuranceView:RefreshHistoryPageByMsg(msg)
  self.historyPageData = msg
  if self.historyPageData == nil then
    return
  end
  table.sort(self.historyPageData, function(a, b)
    return a.timestamp > b.timestamp
  end)
  if self.curTabIndex ~= 2 then
    return
  end
  self:RefreshHistoryPage()
end

function UITruckRewardInsuranceView:RefreshHistoryPageRecords()
  self.compHistoryEmpty:SetActive(#self.historyPageData <= 0)
  self.textHistoryEmptyDesc:SetLocalText("month_card_tab_26")
  self.loopListView2HistoryScrollView:SetListItemCount(#self.historyPageData, false, false)
  self.loopListView2HistoryScrollView:RefreshAllShownItem()
end

function UITruckRewardInsuranceView:OnGetItemByIndex(listview, index)
  if index < 0 or index >= #self.historyPageData then
    return nil
  end
  index = index + 1
  local item = listview:NewListViewItem("UITruckRewardInsuranceHistoryItem")
  if item == nil then
    Logger.LogError("UITruckRewardInsuranceView \230\187\145\229\138\168\229\136\151\232\161\168\232\142\183\229\143\150Item\228\184\186\231\169\186 \239\188\154" .. tostring(index))
    return nil
  end
  local temp = self.historyItemScriptDic[item]
  if temp == nil then
    NameCount = NameCount + 1
    item.gameObject.name = item.gameObject.name .. tostring(NameCount)
    temp = self.compHistoryScrollContent:AddComponent(UITruckRewardInsuranceHistoryItem, item.gameObject)
    temp:SetActive(true)
    self.historyItemScriptDic[item] = temp
  end
  temp:SetActive(true)
  temp:SetData(self.historyPageData[index])
  return item
end

function UITruckRewardInsuranceView:OnRecycleItemFunc(loopListViewItem)
end

function UITruckRewardInsuranceView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UITruckRewardInsuranceView:OnBtnTipClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
    howToPlayList = {100051}
  })
end

function UITruckRewardInsuranceView:OnBtnClaimClick()
  local canClaimFreeReward = #self.insurancePageData:GetFreeReward() > 0
  local isOpen = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
  local canClaimMonthCardReward = isOpen and 0 < #self.insurancePageData:GetVipReward()
  if canClaimFreeReward or canClaimMonthCardReward then
    SFSNetwork.SendMessage(MsgDefines.TruckMonthcardPrivilegeClickReward)
  elseif not isOpen and 0 < #self.insurancePageData:GetVipReward() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITruckRewardInsuranceTips)
  end
end

function UITruckRewardInsuranceView:OnBtnHistoryClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTruckRecord, {anim = false}, {showTab = 2})
end

function UITruckRewardInsuranceView:OnClickBuyBtn()
  if self.golloesMonthCard.packageData then
    local combinationData = ""
    DataCenter.PayManager:CallPayment(self.golloesMonthCard.packageData, "GoldExchangeView", combinationData)
  end
end

return UITruckRewardInsuranceView
