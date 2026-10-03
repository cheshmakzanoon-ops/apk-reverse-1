local base = UIBaseView
local UIDecorationShopDirectPurchaseView = BaseClass("UIDecorationShopDirectPurchaseView", base)
local Localization = CS.GameEntry.Localization
local FunctionSeasonUtil = require("Util.FunctionSeasonUtil")
local UIDecorationShopDirectPurchaseItem = require("UI.UIDecorationShopDirectPurchase.Component.UIDecorationShopDirectPurchaseItem")
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local title_txt_path = "Root/TopBar/TextTitle"
local back_btn_path = "Root/BottomBar/BtnBack"
local item_bar_path = "Root/TopBar/ItemBar"
local diamond_bar_path = "Root/TopBar/DiamondBar"
local pack_list_path = "Root/PackList"
local pack_list_content_path = "Root/PackList/Viewport/Content"
local timeCountDownContainer_path = "Root/TimeCountDownContainer"
local timeCountDownText_path = "Root/TimeCountDownContainer/TimeCountDownText"
local purchase_info_desc_path = "Root/PurchaseInfoDesc"
local infoBtn_path = "Root/InfoBtn"

local function OnCreate(self)
  base.OnCreate(self)
  local param = self:GetUserData()
  self.openType = param.OpenType
  self.freeReward = DataCenter.DecorationShopDirectPurchaseManager:GetFreeRewardId(self.openType)
  self.costItemId = DataCenter.DecorationShopDirectPurchaseManager:GetCostItemId(self.openType)
  self.countDown = DataCenter.DecorationShopDirectPurchaseManager:GetCountDown(self.openType)
  self.countDownOverAction = DataCenter.DecorationShopDirectPurchaseManager:GetCountDownOverAction(self.openType)
  self.packGroup = DataCenter.DecorationShopDirectPurchaseManager:GetPackGroup(self.openType)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

local function OnDestroy(self)
  self:DelTimer()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title_txt = self:AddComponent(UIText, title_txt_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.pack_list = self:AddComponent(UILoopListView2, pack_list_path)
  self.pack_list:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.pack_list_content = self:AddComponent(UIBaseContainer, pack_list_content_path)
  self.item_bar = self:AddComponent(UITopItem, item_bar_path)
  self.diamond_bar = self:AddComponent(UITopItem, diamond_bar_path)
  self.itemBarList = {
    self.diamond_bar,
    self.item_bar
  }
  self.timeCountDownText = self:AddComponent(UIText, timeCountDownText_path)
  self.timeCountDownContainer = self:AddComponent(UIBaseContainer, timeCountDownContainer_path)
  self.timeCountDownContainer:SetActive(false)
  self.item_bar:SetShowAddBtn(false)
  self.diamond_bar:SetShowAddBtn(true)
  self.purchaseInfoDescText = self:AddComponent(UIText, purchase_info_desc_path)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtn:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
end

local function ComponentDestroy(self)
  self.title_txt = nil
  self.back_btn = nil
  self.pack_list = nil
  self.pack_content_list = nil
  self.item_bar = nil
  self.diamond_bar = nil
  self.timeCountDownText = nil
  self.timeCountDownContainer = nil
  self.purchaseInfoDescText = nil
  self.infoBtn = nil
end

local function DataDefine(self)
  self.countDownLessThan1 = false
end

local function DataDestroy(self)
  self.countDownLessThan1 = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.Refresh)
  self:AddUIListener(EventId.BargainDayRewardUpdate, self.Refresh)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGold)
  self:AddUIListener(EventId.RefreshItems, self.RefreshGoods)
  self:AddUIListener(EventId.RefreshTitaniumBlueDailyRewardData, self.Refresh)
  self:AddUIListener(EventId.OnDecorationShopInfoChange, self.Refresh)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.Refresh)
  self:RemoveUIListener(EventId.BargainDayRewardUpdate, self.Refresh)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshGold)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshGoods)
  self:RemoveUIListener(EventId.RefreshTitaniumBlueDailyRewardData, self.Refresh)
  self:RemoveUIListener(EventId.OnDecorationShopInfoChange, self.Refresh)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshData()
  self:InitTop()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ClearScroll(self)
  self.pack_list_content:RemoveComponents(UIDecorationShopDirectPurchaseItem)
  self.pack_list:ClearAllItems()
end

local function InitView(self)
  self:InitTop()
  local title, desc = "", ""
  self.title_txt:SetLocalText(title)
  self.purchaseInfoDescText:SetLocalText("decorationshop_giftbuy_desc1")
  self:Refresh()
end

local function InitTop(self)
  self.diamond_bar:SetData(nil, ResourceType.Gold, function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceInfo, {anim = true}, ResourceType.Gold)
  end)
  self.item_bar:SetData(self.costItemId, nil, nil)
end

local function GetFreeReward(self, rewardId)
  local result = {}
  local line = LocalController:instance():getLine(TableName.RewardConfig, rewardId)
  if line == nil then
    return result
  end
  local itemValues = line:getValue("item") or ""
  local numValues = line:getValue("num") or ""
  if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
    local ids = string.split(itemValues, "|")
    local nums = string.split(numValues, "|")
    if ids ~= nil and 0 < #ids then
      for i, id in pairs(ids) do
        local oneData = {}
        oneData.itemId = id
        oneData.count = nums[i] or 0
        oneData.rewardType = RewardType.GOODS
        table.insert(result, oneData)
      end
    end
  end
  return result
end

local function ShouldHideGiftByRechargeCondition(openType, packGiftId)
  local shopInfo = DataCenter.DecorationShopDirectPurchaseManager:GetDecorationShopInfo(openType)
  local rcInfo = shopInfo and shopInfo.rechargeConditionInfo
  if not (rcInfo and rcInfo.giftId) or rcInfo.giftId == 0 then
    return false
  end
  local gid = tonumber(packGiftId) or 0
  if gid ~= rcInfo.giftId then
    return false
  end
  local funcId = rcInfo.functionSeasonId or 0
  if funcId == 0 then
    return false
  end
  if FunctionSeasonUtil.IsFuncOpen(funcId) then
    return false
  end
  return true
end

local function RefreshData(self)
  self.packDataList = {}
  local unpaidAllPack = {}
  local paidAllPack = {}
  local giftPack = GiftPackManager.GetPacksByGroupId(self.packGroup, true)
  for _, v in pairs(giftPack) do
    local giftId = v ~= nil and v:getID()
    if ShouldHideGiftByRechargeCondition(self.openType, giftId) then
    else
      local giftPackData = {}
      giftPackData.isFree = false
      giftPackData.realData = v
      giftPackData.openType = self.openType
      giftPackData.giftId = giftId
      if v and v._serverData.buys and tonumber(v._serverData.buys) <= 0 then
        table.insert(paidAllPack, giftPackData)
      else
        table.insert(unpaidAllPack, giftPackData)
      end
    end
  end
  table.sort(paidAllPack, function(a, b)
    if a.giftId and b.giftId then
      return a.giftId < b.giftId
    end
    return true
  end)
  if self.freeReward and type(self.freeReward) == "number" and 0 < self.freeReward then
    local freePackData = {}
    freePackData.isFree = true
    freePackData.realData = {}
    freePackData.openType = self.openType
    local reward = self:GetFreeReward(self.freeReward)
    if reward and type(reward) == "table" then
      freePackData.realData.rewards = reward
      local canGet = DataCenter.DecorationShopDirectPurchaseManager:GetIfCanFreeReward(self.openType)
      if canGet then
        table.insert(unpaidAllPack, 1, freePackData)
      else
        table.insert(paidAllPack, 1, freePackData)
      end
    end
  end
  for k, v in pairs(unpaidAllPack) do
    table.insert(self.packDataList, v)
  end
  for k, v in pairs(paidAllPack) do
    table.insert(self.packDataList, v)
  end
end

local function Refresh(self)
  self:RefreshData(self)
  if self.packDataList == nil or #self.packDataList == 0 then
    self.pack_list:SetActive(false)
  else
    self.pack_list:SetActive(true)
    self.pack_list:SetListItemCount(#self.packDataList, false, false)
    self.pack_list:RefreshAllShownItem()
  end
  self:ShowCountDown()
end

local function RefreshGold(self)
  if self.diamond_bar then
    self.diamond_bar:RefreshData()
  end
end

local function RefreshGoods(self)
  if self.item_bar then
    self.item_bar:SetData(self.costItemId, nil, nil)
  end
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.packDataList then
    return nil
  end
  local packData = self.packDataList[index]
  local itemKey = "PackItem"
  local itemCls = UIDecorationShopDirectPurchaseItem
  local item = loopScroll:NewListViewItem(itemKey)
  local script = self.pack_list_content:GetComponent(item.gameObject.name, itemCls)
  if script == nil then
    local objectName = UIUtil.GetLoopListItemIndex()
    item.gameObject.name = objectName
    script = self.pack_list_content:AddComponent(itemCls, objectName)
  end
  script:SetActive(true)
  script:SetData(packData)
  return item
end

local function ShowCountDown(self)
  if not self.countDown then
    return
  end
  self.timeCountDownContainer:SetActive(true)
  local giftRefreshType, giftRefreshInfo = DataCenter.DecorationShopDirectPurchaseManager:GetGiftRefreshDateInfo(self.openType)
  if not giftRefreshType then
    Logger.LogError("giftRefreshType is nil")
    return
  end
  if giftRefreshType == 1 then
    self:DelTimer()
    self:AddTimer()
  elseif giftRefreshType == 2 and giftRefreshInfo and type(giftRefreshInfo) == "table" then
    local shopInfo = DataCenter.DecorationShopDirectPurchaseManager:GetDecorationShopInfo(self.openType)
    local seasonRefreshKey = shopInfo.seasonRefreshKey
    local seasonRefreshValue = shopInfo.seasonRefreshValue
    if seasonRefreshKey == 0 or seasonRefreshValue == 0 then
      self.timeCountDownText:SetText(Localization:GetString("decorationshop_giftbuy_desc10"))
    else
      self.timeCountDownText:SetText(Localization:GetString("decorationshop_giftbuy_desc11"))
    end
  end
end

local function AddTimer(self)
  function self.TimerAction()
    self:SetRemainTime()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
end

local function SetRemainTime(self)
  local time = DataCenter.DecorationShopDirectPurchaseManager:GetCountDown(self.openType)
  if 0 < time then
    local timeFormat = UITimeManager:GetInstance():MilliSecondToFmtString(time)
    self.timeCountDownText:SetText(Localization:GetString("decorationshop_giftbuy_desc5", timeFormat))
    if self.countDownLessThan1 then
      self.countDownLessThan1 = false
    end
  else
    self:DelTimer()
    if self.countDownOverAction and not self.countDownLessThan1 then
      self.countDownOverAction()
    end
    self.countDownLessThan1 = true
  end
end

local function DelTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnClickInfoBtn(self)
  local infoTable = DataCenter.DecorationShopDirectPurchaseManager:GetTitleAndDesc(self.openType)
  if not (infoTable and infoTable.title) or not infoTable.content then
    return
  end
  local param = {}
  param.title = Localization:GetString(infoTable.title)
  param.activityRulesStr = Localization:GetString(infoTable.content)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

local function OnPassDay(self)
  local giftRefreshType, giftRefreshInfo = DataCenter.DecorationShopDirectPurchaseManager:GetGiftRefreshDateInfo(self.openType)
  if not giftRefreshType then
    return
  end
  if giftRefreshType == 2 then
    DataCenter.CommonShopManager:RequestDecorationShopInfo()
  end
end

UIDecorationShopDirectPurchaseView.OnCreate = OnCreate
UIDecorationShopDirectPurchaseView.OnDestroy = OnDestroy
UIDecorationShopDirectPurchaseView.OnEnable = OnEnable
UIDecorationShopDirectPurchaseView.OnDisable = OnDisable
UIDecorationShopDirectPurchaseView.OnAddListener = OnAddListener
UIDecorationShopDirectPurchaseView.OnRemoveListener = OnRemoveListener
UIDecorationShopDirectPurchaseView.ComponentDefine = ComponentDefine
UIDecorationShopDirectPurchaseView.ComponentDestroy = ComponentDestroy
UIDecorationShopDirectPurchaseView.DataDefine = DataDefine
UIDecorationShopDirectPurchaseView.DataDestroy = DataDestroy
UIDecorationShopDirectPurchaseView.ClearScroll = ClearScroll
UIDecorationShopDirectPurchaseView.OnGetItemByIndex = OnGetItemByIndex
UIDecorationShopDirectPurchaseView.Refresh = Refresh
UIDecorationShopDirectPurchaseView.RefreshGold = RefreshGold
UIDecorationShopDirectPurchaseView.RefreshGoods = RefreshGoods
UIDecorationShopDirectPurchaseView.ShowCountDown = ShowCountDown
UIDecorationShopDirectPurchaseView.AddTimer = AddTimer
UIDecorationShopDirectPurchaseView.SetRemainTime = SetRemainTime
UIDecorationShopDirectPurchaseView.DelTimer = DelTimer
UIDecorationShopDirectPurchaseView.GetFreeReward = GetFreeReward
UIDecorationShopDirectPurchaseView.InitView = InitView
UIDecorationShopDirectPurchaseView.OnClickInfoBtn = OnClickInfoBtn
UIDecorationShopDirectPurchaseView.RefreshData = RefreshData
UIDecorationShopDirectPurchaseView.InitTop = InitTop
UIDecorationShopDirectPurchaseView.OnPassDay = OnPassDay
return UIDecorationShopDirectPurchaseView
