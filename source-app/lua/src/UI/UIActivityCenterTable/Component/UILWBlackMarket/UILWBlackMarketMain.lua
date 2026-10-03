local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UILWBlackMarketMain = BaseClass("UILWBlackMarketMain", base)
local UILWBlackMarketProductItem = require("UI.UIActivityCenterTable.Component.UILWBlackMarket.UILWBlackMarketProductItem")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local title_txt_path = "topContent/title_txt"
local des_txt_path = "centerContent/bg/des_txt"
local time_txt_path = "topContent/remainTimeContent/time_txt"
local info_btn_path = "topContent/info_btn"
local getMore_btn_path = "topContent/getMore_btn"
local item_img_path = "centerContent/ownItemContent/item_img"
local ownItemCount_txt_path = "centerContent/ownItemContent/ownItemCount_txt"
local add_btn_path = "centerContent/ownItemContent/addBtn"
local addRedPoint_path = "centerContent/ownItemContent/addRedPoint"
local remainRefresh_txt_path = "bottomContent/remainRefresh_txt"
local remain_info_path = "bottomContent/remainRefresh_txt/remain_info"
local refresh_btn_path = "bottomContent/refresh_btn"
local refreshBtn_img_path = "bottomContent/refresh_btn/refreshBtn_img"
local refreshCost_txt_path = "bottomContent/refresh_btn/refreshBtnLayout/refreshPriceLayout/price_txt"
local refreshCost_img_path = "bottomContent/refresh_btn/refreshBtnLayout/refreshPriceLayout/refreshCost_img"
local heroSpineContainer_path = "centerContent/heroSpineViewport/heroSpineContainer"
local refreshBtnPriceLayout_path = "bottomContent/refresh_btn/refreshBtnLayout/refreshPriceLayout"
local refrehsBtnRedPoint_path = "bottomContent/refresh_btn/refreshBtnRedPoint"
local fastBuyState_img_path = "bottomContent/fastBuy/fastBuy_txt/toggle/fill"
local fastBuy_btn_path = "bottomContent/fastBuy"
local products_path = {
  "centerContent/products/item1",
  "centerContent/products/item2",
  "centerContent/products/item3",
  "centerContent/products/item4",
  "centerContent/products/item5",
  "centerContent/products/item6"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.title_txt = self:AddComponent(UIText, title_txt_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.getMore_btn = self:AddComponent(UIButton, getMore_btn_path)
  self.item_img = self:AddComponent(UIImage, item_img_path)
  self.ownItemCount_txt = self:AddComponent(UIText, ownItemCount_txt_path)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.addRedPoint = self:AddComponent(UIImage, addRedPoint_path)
  self.remainRefresh_txt = self:AddComponent(UIText, remainRefresh_txt_path)
  self.remain_info_btn = self:AddComponent(UIButton, remain_info_path)
  self.refresh_btn = self:AddComponent(UIButton, refresh_btn_path)
  self.refreshBtn_img = self:AddComponent(UIImage, refreshBtn_img_path)
  self.refreshCost_txt = self:AddComponent(UIText, refreshCost_txt_path)
  self.refreshCost_img = self:AddComponent(UIImage, refreshCost_img_path)
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainer_path)
  self.refreshBtnPriceLayout = self:AddComponent(UIBaseContainer, refreshBtnPriceLayout_path)
  self.refrehsBtnRedPoint = self:AddComponent(UIBaseContainer, refrehsBtnRedPoint_path)
  self.fastBuyState_img = self:AddComponent(UIImage, fastBuyState_img_path)
  self.fastBuy_btn = self:AddComponent(UIButton, fastBuy_btn_path)
  self.products = {
    self:AddComponent(UILWBlackMarketProductItem, products_path[1]),
    self:AddComponent(UILWBlackMarketProductItem, products_path[2]),
    self:AddComponent(UILWBlackMarketProductItem, products_path[3]),
    self:AddComponent(UILWBlackMarketProductItem, products_path[4]),
    self:AddComponent(UILWBlackMarketProductItem, products_path[5]),
    self:AddComponent(UILWBlackMarketProductItem, products_path[6])
  }
  self.refreshCost_img:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
  self.info_btn:SetOnClick(function()
    if not self.actBaseInfo then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBlackMarketProbab, {anim = true}, self.actBaseInfo.subType, self.actBaseInfo.story, self.actBaseInfo.para_6)
  end)
  self.getMore_btn:SetOnClick(function()
    if not self.costItemId or self.costItemId <= 0 then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.activityId, self.actDetailInfo:GetGiftPacks(), tonumber(self.costItemId))
  end)
  self.add_btn:SetOnClick(function()
    if not self.costItemId then
      return
    end
    LWResourceLackUtil:GotoGoodsItemLack(self.costItemId, 1, false)
  end)
  self.time_txt:SetText("")
  self.remain_info_btn:SetOnClick(function()
    if not LuaEntry.DataConfig:CheckSwitch("blackmarket_get_times") then
      return
    end
    if not self.actDetailInfo then
      return
    end
    local getTimes, freeTime, diamondTimes = self.actDetailInfo:GetRefreshGetCount()
    local tipsStr = Localization:GetString("blackmarket_pop_times_desc", getTimes, freeTime, diamondTimes)
    if not tipsStr or tipsStr == "" then
      return
    end
    local offsetX = -25
    if CommonUtil and CommonUtil.ArabicAutoMirrorFactor then
      offsetX = -25 * CommonUtil.ArabicAutoMirrorFactor()
    end
    UIUtil.ShowBubbleTips(tipsStr, self.remain_info_btn.transform.position, offsetX, 30, 0, nil, nil, {reversal = true})
  end)
  self.refresh_btn:SetOnClick(function()
    if not self.actDetailInfo then
      return
    end
    if self.actDetailInfo:GetRefreshRemainCount() <= 0 then
      UIUtil.ShowTipsId("blackmarket_tips1")
      return
    end
    
    local function RefreshMarket()
      local refreshCostDiamond = self.actDetailInfo:GetRefreshCost()
      if refreshCostDiamond <= 0 then
        DataCenter.ActBlackMarketDataManager:TryRequestRefresh(self.activityId)
        return
      end
      local curHaveDiamond = CommonUtil.GetResOrItemCount(ResourceType.Gold)
      if refreshCostDiamond > curHaveDiamond then
        LWResourceLackUtil:GotoResLack({
          {
            resType = ResourceType.Gold,
            need = refreshCostDiamond
          }
        })
        return
      end
      UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.UseDiamondRefreshBlackMarket, Localization:GetString("blackmarket_desc11", string.GetFormattedSeperatorNum(refreshCostDiamond)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        DataCenter.ActBlackMarketDataManager:TryRequestRefresh(self.activityId)
      end, function()
      end)
    end
    
    local secondConfirmType = TodayNoSecondConfirmType.RefreshBlackMarket
    if DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(secondConfirmType) then
      local needToShowConfirm = false
      local _curProducts = self.actDetailInfo.products
      for _, v in ipairs(_curProducts) do
        if (v.randomPool == 0 or v.randomPool == 1) and v.num < v.buyTimeLimit then
          needToShowConfirm = true
          break
        end
      end
      if not needToShowConfirm then
        RefreshMarket()
        return
      end
      UIUtil.ShowSecondMessage(Localization:GetString("blackmarket_title1"), Localization:GetString("blackmarket_desc8"), 2, "blackmarket_button4", "blackmarket_button3", function()
        RefreshMarket()
      end, function(needSellConfirm)
        DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(secondConfirmType, needSellConfirm)
      end, nil, nil, nil, Localization:GetString(GameDialogDefine.TODAY_NO_SHOW), false, nil, nil)
    else
      RefreshMarket()
    end
  end)
  self.refresh_btn:SetSafeClickMode(true)
  self.refresh_btn:SetSafeClickModeTime(1)
  self.fastBuyState_img:SetEnable(false)
  self.fastBuy_btn:SetOnClick(function()
    if not self.fastBuyKey then
      return
    end
    Setting:SetBool(self.fastBuyKey, not self.fastBuyState)
    self.fastBuyState = not self.fastBuyState
    self.fastBuyState_img:SetEnable(self.fastBuyState)
  end)
end

local function ComponentDestroy(self)
  self.title_txt = nil
  self.des_txt = nil
  self.time_txt = nil
  self.info_btn = nil
  self.getMore_btn = nil
  self.item_img = nil
  self.ownItemCount_txt = nil
  self.add_btn = nil
  self.addRedPoint = nil
  self.remainRefresh_txt = nil
  self.remain_info_btn = nil
  self.refresh_btn = nil
  self.refreshBtn_img = nil
  self.refreshCost_txt = nil
  self.refreshCost_img = nil
  self.heroSpineContainer = nil
  self.refreshBtnPriceLayout = nil
  self.refrehsBtnRedPoint = nil
  self.fastBuyState_img = nil
  self.fastBuy_btn = nil
  self.products = nil
end

local function DataDefine(self)
  self.crossDayRequestSent = false
end

local function DataDestroy(self)
  self.reachEnd = nil
  self.crossDayRequestSent = nil
end

local function RefreshActBaseInfo(self)
  if not self.actBaseInfo then
    self.title_txt:SetText("")
    self.des_txt:SetText("")
  else
    self.title_txt:SetLocalText(self.actBaseInfo.name)
    local range = self.actBaseInfo.para_1
    local maxRandomRange = 0
    local randomPool = {}
    local rangeList = string.split(range, "|")
    for i = 1, #rangeList do
      local rangeItem = string.split(rangeList[i], ";")
      local key = rangeItem[1]
      local weight = tonumber(rangeItem[2])
      maxRandomRange = maxRandomRange + weight
      table.insert(randomPool, {key = key, weight = weight})
    end
    local randomValue = math.random(1, maxRandomRange)
    local curRange = 0
    local curKey = ""
    for i = 1, #randomPool do
      curRange = curRange + randomPool[i].weight
      if randomValue <= curRange then
        curKey = randomPool[i].key
        break
      end
    end
    if 0 < curRange then
      self.des_txt:SetActive(true)
      self.des_txt:SetLocalText(curKey)
    else
      self.des_txt:SetActive(false)
    end
  end
end

local function RefreshProducts(self)
  if not self.actDetailInfo then
    for i = 1, #self.products do
      self.products[i]:SetActive(false)
    end
  end
  for i = 1, 6 do
    local product = self.actDetailInfo.products[i]
    self.products[i]:SetData(product)
  end
end

local function RefreshOwnItemInfo(self)
  if not self.actDetailInfo then
    self.ownItemCount_txt:SetText("")
    return
  end
  if not self.costItemId then
    self.ownItemCount_txt:SetText("")
    return
  end
  local itemNum = DataCenter.ItemData:GetItemCount(self.costItemId)
  self.ownItemCount_txt:SetText(itemNum)
  if not self.iconItemId or self.iconItemId ~= self.costItemId then
    local itemIcon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, self.costItemId)
    self.item_img:LoadSprite(itemIcon)
    self.iconItemId = self.costItemId
  end
end

local function RefreshRefreshInfo(self)
  if not self.actDetailInfo then
    return
  end
  local useServerMaxTimes = LuaEntry.DataConfig:CheckSwitch("blackmarket_get_times")
  self.remain_info_btn:SetActive(useServerMaxTimes)
  local remainRefreshTimes, totalRefreshTimes = self.actDetailInfo:GetRefreshRemainCount()
  self.remainRefresh_txt:SetLocalText("blackmarket_desc7", remainRefreshTimes, totalRefreshTimes)
  self.refrehsBtnRedPoint:SetActive(false)
  if remainRefreshTimes <= 0 then
    UIGray.SetGray(self.refresh_btn.transform, true, true)
    self.refreshBtnPriceLayout:SetActive(false)
    return
  else
    UIGray.SetGray(self.refresh_btn.transform, false, true)
    self.refreshBtnPriceLayout:SetActive(true)
  end
  local refreshCostDiamond = self.actDetailInfo:GetRefreshCost()
  if refreshCostDiamond <= 0 then
    self.refreshCost_img:SetActive(false)
    self.refreshCost_txt:SetLocalText("blackmarket_desc5")
    self.refreshBtn_img:LoadSprite(UIAssets.GREEN_BTN)
  else
    self.refreshCost_img:SetActive(true)
    self.refreshCost_txt:SetText(refreshCostDiamond)
    self.refreshBtn_img:LoadSprite(UIAssets.BLUE_BTN)
    local curHaveDiamond = CommonUtil.GetResOrItemCount(ResourceType.Gold)
    if refreshCostDiamond > curHaveDiamond then
      self.refreshCost_txt:SetColor(LackResourceRedColor)
    else
      self.refreshCost_txt:SetColor(WhiteColor)
    end
  end
end

local function SetData(self, activityId)
  self.activityId = activityId
  self.actBaseInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if not self.actBaseInfo then
    return
  end
  self.fastBuyKey = string.format("FastBuyBlackMarket_%s", activityId)
  self.fastBuyState = Setting:GetBool(self.fastBuyKey, false)
  self.fastBuyState_img:SetEnable(self.fastBuyState)
  self.costItemId = tonumber(self.actBaseInfo.para_2)
  local detailInfo = DataCenter.ActBlackMarketDataManager:GetActDetail(activityId)
  if not detailInfo then
    for i = 1, #self.products do
      self.products[i]:SetActive(false)
    end
    UIGray.SetGray(self.refresh_btn.transform, true, false)
    return
  end
  self.refreshCosts = detailInfo.costDiamonds
  self.actDetailInfo = detailInfo
  RefreshActBaseInfo(self)
  RefreshOwnItemInfo(self)
  RefreshRefreshInfo(self)
  self:RefreshProducts()
  local triggerFlowId = 4001
  if not DataCenter.LWGuideFlowManager:IsRunning() and 0 < triggerFlowId and not DataCenter.LWGuideFlowManager:ReadDone(triggerFlowId) then
    DataCenter.LWGuideFlowManager.Runner:Run(triggerFlowId)
  end
end

local function Update1000MS(self)
  if not self.actBaseInfo then
    self.time_txt:SetText("")
    return
  end
  if self.reachEnd then
    return
  end
  if LuaEntry.DataConfig:CheckSwitch("blackmarket_get_times") and self.actDetailInfo and self.actDetailInfo.nowZeroTime and not self.crossDayRequestSent then
    local nowServerSeconds = UITimeManager:GetInstance():GetServerSeconds()
    local nowZeroTimeSeconds = self.actDetailInfo.nowZeroTime / 1000
    if not UITimeManager:GetInstance():IsSameDayForServer(nowZeroTimeSeconds, nowServerSeconds) then
      SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.activityId))
      self.crossDayRequestSent = true
    end
  end
  local remainTime = self.actBaseInfo.endTime - UITimeManager:GetInstance():GetServerTime()
  if remainTime <= 0 then
    self.time_txt:SetText("")
    self.reachEnd = true
    return
  end
  self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
end

local function OnDetailInfoUpdate(self)
  self.crossDayRequestSent = false
  self:RefreshProducts()
  self:RefreshRefreshInfo()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.BlackMarketInfoUpdate, self.OnDetailInfoUpdate)
  self:AddUIListener(EventId.RefreshItems, self.RefreshOwnItemInfo)
  self:AddUIListener(EventId.OnPassDay, self.OnDetailInfoUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.BlackMarketInfoUpdate, self.OnDetailInfoUpdate)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshOwnItemInfo)
  self:RemoveUIListener(EventId.OnPassDay, self.OnDetailInfoUpdate)
end

local function TryBuyProduct(self, productData)
  if productData or not self.activityId then
    if productData.num >= productData.buyTimeLimit then
      UIUtil.ShowTipsId("blackmarket_desc6")
      return
    end
    if self.fastBuyState then
      local cost = productData.costNum
      local curHaveItemCount = DataCenter.ItemData:GetItemCount(productData.costItem)
      if cost > curHaveItemCount then
        LWResourceLackUtil:GotoGoodsItemLack(productData.costItem, 1)
        return
      end
      DataCenter.ActBlackMarketDataManager:TryExchangeItem(self.activityId, productData.shopUuid, 1)
    else
      local param = {}
      param.goodsInfo = {}
      local reward = productData.reward[1]
      param.goodsInfo.rewardType = reward.rewardType
      param.goodsInfo.itemId = reward.itemId
      param.goodsInfo.count = reward.count
      param.goodsInfo.limitCount = limit == 0 and 9999 or productData.buyTimeLimit - productData.num
      param.goodsInfo.eachPrice = productData.costNum
      param.consumeInfo = {}
      param.consumeInfo.currencyType = RewardType.GOODS
      param.consumeInfo.currencyId = productData.costItem
      
      function param.callback(buyCount)
        DataCenter.ActBlackMarketDataManager:TryExchangeItem(self.activityId, productData.shopUuid, buyCount)
      end
      
      function param.notEnoughCallBack()
        LWResourceLackUtil:GotoGoodsItemLack(productData.costItem, 1)
      end
      
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuyV2, {anim = true}, param)
    end
  end
end

UILWBlackMarketMain.OnCreate = OnCreate
UILWBlackMarketMain.OnDestroy = OnDestroy
UILWBlackMarketMain.OnEnable = OnEnable
UILWBlackMarketMain.OnDisable = OnDisable
UILWBlackMarketMain.ComponentDefine = ComponentDefine
UILWBlackMarketMain.ComponentDestroy = ComponentDestroy
UILWBlackMarketMain.DataDefine = DataDefine
UILWBlackMarketMain.DataDestroy = DataDestroy
UILWBlackMarketMain.SetData = SetData
UILWBlackMarketMain.RefreshProducts = RefreshProducts
UILWBlackMarketMain.RefreshActBaseInfo = RefreshActBaseInfo
UILWBlackMarketMain.RefreshOwnItemInfo = RefreshOwnItemInfo
UILWBlackMarketMain.RefreshRefreshInfo = RefreshRefreshInfo
UILWBlackMarketMain.Update1000MS = Update1000MS
UILWBlackMarketMain.OnDetailInfoUpdate = OnDetailInfoUpdate
UILWBlackMarketMain.OnAddListener = OnAddListener
UILWBlackMarketMain.OnRemoveListener = OnRemoveListener
UILWBlackMarketMain.TryBuyProduct = TryBuyProduct
return UILWBlackMarketMain
