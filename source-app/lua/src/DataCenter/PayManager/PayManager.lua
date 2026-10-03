local PayManager = BaseClass("PayManager")
local Timer = CS.GameEntry.Timer
local GlobalData = CS.GameEntry.GlobalData
local CommonUtils = CS.CommonUtils
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local Sdk = CS.GameEntry.Sdk
local AnalyticsEvent = CS.UnityGameFramework.SDK.AnalyticsEvent
local SDKManager = CS.SDKManager
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local ClientSwitch = CS.ClientSwitch
local PaymentPriceCNY = {
  ["4.99"] = "30",
  ["9.99"] = "68",
  ["19.99"] = "128",
  ["49.99"] = "328",
  ["99.99"] = "648",
  ["24.99"] = "163",
  ["999.99"] = "6498",
  ["0.99"] = "6"
}
local IOS_PAY_ERRORCODE = {
  IDINVALID = 1001,
  CANTMAKEPAYMENT = 1002,
  CANTGETPRODUCTIFNO = 1003,
  TransactionStateFailed = 1004,
  NORECEIPT = 1005,
  TRANSACTIONINFOINVALID = 1006
}
local GoldBrickWebUrl2 = "https://lastwar-h5.lastwargame.com/pay/index.html"
local ExternalCheckoutResultCode = {
  Unknown = 0,
  UserCancelled = 1,
  Closed = 2,
  LaunchFailed = 3,
  UserClosedWindow = 4,
  EmptyExternalTransactionToken = 5,
  MissingOrderOrPackage = 6,
  InvalidGoldBrickTokenResponse = 7,
  OpenPreparedExternalCheckoutFailed = 8,
  GoldBrickTokenError = 9
}
local ExternalCheckoutResultCategory = {UserCancelled = 1, Failed = 2}
local ExternalCheckoutResultSource = {
  NativeFailed = 1,
  NativeClosed = 2,
  LuaUI = 3,
  LuaFlow = 4
}
local ExternalCheckoutFlowReason = {
  InitData = 1,
  ResetExternalCheckoutFlowState = 2,
  MissingOrderOrPackage = 3,
  InvalidGoldBrickTokenResponse = 4,
  OpenPreparedExternalCheckoutFailed = 5,
  GoldBrickTokenError = 6,
  PendingTimeout = 7
}
local ExternalCheckoutFlowReasonName = {
  [ExternalCheckoutFlowReason.InitData] = "init_data",
  [ExternalCheckoutFlowReason.ResetExternalCheckoutFlowState] = "reset_external_checkout_flow_state",
  [ExternalCheckoutFlowReason.MissingOrderOrPackage] = "missing_order_or_package",
  [ExternalCheckoutFlowReason.InvalidGoldBrickTokenResponse] = "invalid_gold_brick_token_response",
  [ExternalCheckoutFlowReason.OpenPreparedExternalCheckoutFailed] = "open_prepared_external_checkout_failed",
  [ExternalCheckoutFlowReason.GoldBrickTokenError] = "gold_brick_token_error",
  [ExternalCheckoutFlowReason.PendingTimeout] = "pending_timeout"
}
local ExternalCheckoutPendingTimeoutSeconds = 30
local ExternalCheckoutOpenedTimeoutSeconds = 300

local function GetExternalCheckoutFlowReasonName(reason)
  if reason == nil then
    return ""
  end
  return ExternalCheckoutFlowReasonName[reason] or tostring(reason)
end

function PayPrint(fmt, ...)
  local arg = {
    ...
  }
  if #arg == 0 then
    print("[pay]" .. tostring(fmt))
    return
  end
  print("[pay]" .. string.format(fmt, ...))
  return
end

local COK_PURCHASE_DELIMITER_DATA = "|#|"
local COK_PURCHASE_DELIMITER_ORDERS = "|*|"
local regex = "[0-9.,]"
local tab = {}

function PayManager:LogToServer(msg)
  xpcall(function()
    if tab[msg] ~= nil then
      return
    end
    CS.PostEventLog.Record(msg)
    tab[msg] = 1
  end, function()
  end)
end

function PayManager:__init()
  self.payState = 0
  self.packageInfo = nil
  self.fromView = nil
  self.chooseItem = nil
  self.productId = ""
  self.historyPurchaseChecked = false
  self.historyPurchaseList = {}
  self.donateUID = nil
  self.itemId = nil
  self.purchaseSelfOrderId = {}
  self.param = {}
  self.firstPayStatus = -1
  self.firstPayRewards = {}
  self.goldPriceList = {}
  self.localCurrencyCode = ""
  self.BillingClientVersion = 0
  self.m_SkuDetails = {}
  self.isSymbolAtRight = false
  self.exchangeRate = 0
  self.localCurrencySymbol = ""
  self.m_SkuPriceNums = {}
  Sdk:SetPayMangerCallback(function(key, data)
    self:__SdkCallback(key, data)
  end)
  self.hasRequestAllProduct = nil
  self.consumedOrderDetectFunctionOpen = nil
  self.externalCheckoutSelectedMethod = nil
  self.externalCheckoutFallbackOnFail = true
  self.pendingGoldBrickExternalRequest = nil
  self.cancelledExternalCheckoutOrderId = nil
  self.externalCheckoutGoogleTokenInFlight = nil
  self.externalCheckoutPreparedUrlInFlight = nil
  self.activeExternalCheckoutOrderId = nil
  self.externalCheckoutTokenCallbackCount = 0
  self.externalCheckoutGoldBrickTokenRequestCount = 0
  self.pendingExternalCheckoutAvailabilityContext = nil
  self.externalCheckoutPendingTimer = nil
end

function PayManager:Warmup()
end

function PayManager:__delete()
  self.packageInfo = nil
  self.fromView = nil
  self.chooseItem = nil
  self.productId = nil
  self.historyPurchaseList = nil
  self.payState = nil
  self.donateUID = nil
  self.itemId = nil
  self.purchaseSelfOrderId = nil
  self.param = nil
  self.goldPriceList = nil
  self.firstPayStatus = nil
  self.firstPayRewards = nil
  self.hasRequestAllProduct = nil
  self.receiveStoreCode = nil
  self.waitForFormattedPrices = nil
  self.consumedOrderDetectFunctionOpen = nil
  self.externalCheckoutSelectedMethod = nil
  self.externalCheckoutFallbackOnFail = nil
  self.pendingGoldBrickExternalRequest = nil
  self.cancelledExternalCheckoutOrderId = nil
  self.externalCheckoutGoogleTokenInFlight = nil
  self.externalCheckoutPreparedUrlInFlight = nil
  self.activeExternalCheckoutOrderId = nil
  self.externalCheckoutTokenCallbackCount = nil
  self.externalCheckoutGoldBrickTokenRequestCount = nil
  self.pendingExternalCheckoutAvailabilityContext = nil
  self.externalCheckoutPendingTimer = nil
end

local QueryPatchOn

function PayManager:CheckQueryPatchOn()
  if QueryPatchOn == nil then
    if ClientSwitch.ENABLE_PAY_PRODUCT_DATA_PATCH ~= nil then
      QueryPatchOn = ClientSwitch.IsOn(ClientSwitch.ENABLE_PAY_PRODUCT_DATA_PATCH)
    else
      QueryPatchOn = false
    end
  end
  return QueryPatchOn
end

function PayManager:InitData(message)
  if message.firstPayInfo then
    self.firstPayStatus = message.firstPayInfo.state
    self.firstPayRewards = message.firstPayInfo.reward
    EventManager:GetInstance():Broadcast(EventId.FirstPayStatusChange)
  end
  self.goldPriceList = {}
  if message.goldprices then
    for k, v in ipairs(message.goldprices) do
      local price = GoldPrices.New()
      price:Parse(v)
      table.insert(self.goldPriceList, price)
    end
  end
  if self:CheckQueryPatchOn() then
    local PayOrderData = CS.GameEntry.PayOrderData
    if PayOrderData then
      if PayOrderData.GetStorefrontCode then
        local cachedStorefront = PayOrderData:GetStorefrontCode()
        if not string.IsNullOrEmpty(cachedStorefront) then
          self:__onCallPayConfig(cachedStorefront)
        end
      end
      if PayOrderData.GetNativeQueryPriceResult then
        local nativeQueryPriceResult = PayOrderData:GetNativeQueryPriceResult()
        if not string.IsNullOrEmpty(nativeQueryPriceResult) then
          self:__onPurchaseQueried(nativeQueryPriceResult)
        end
      end
    end
    if not self.hasRequestAllProduct then
      local allProducts = DataCenter.GoldBrickTemplateManager:GetAllProductId()
      for _, v in pairs(allProducts) do
        self:CheckRequestProdcut(tostring(v))
      end
      self.hasRequestAllProduct = true
    end
  end
end

function PayManager:CallPayment(packageInfo, fromView, chooseItem, actId, extraParam)
  if packageInfo ~= nil then
    self.cancelledExternalCheckoutOrderId = nil
    local canPay = true
    CommonUtil.ProtectCall(function()
      canPay = DataCenter.LWRefundPunishManager:GetCanPay(packageInfo)
      canPay = canPay and CoppaUtil.GetCanPay()
    end)
    if not canPay then
      return
    end
    local inconsistentConditions
    if packageInfo.getInconsistentBuyConditions then
      inconsistentConditions = packageInfo:getInconsistentBuyConditions()
    end
    local isBuyConditionOk = table.IsNullOrEmpty(inconsistentConditions)
    if not isBuyConditionOk then
      return
    end
    if self:CustomPay(packageInfo) then
      return
    end
    SFSNetwork.SendMessage(MsgDefines.PayRecord, packageInfo:getID(), GlobalData.analyticID)
    if LuaEntry.DataConfig:CheckSwitch("certification_pay") and LuaEntry.GlobalData:IsChina() and not LuaEntry.GlobalData:GetIsAuthenticate() then
      return
    end
    self.packageInfo = packageInfo
    self.fromView = fromView
    self.chooseItem = chooseItem
    local countryCode = self:__GetLocalCurrencyCode()
    PostEventLog.Track(PostEventLog.Defines.pay_before_check, {
      packageId = packageInfo:getID(),
      countryCode = countryCode
    })
    SFSNetwork.SendMessage(MsgDefines.PayBeforeCheck, packageInfo:getID(), countryCode, chooseItem, 0, actId, extraParam)
    if self.payState == 1 then
      PostEventLog.Track(PostEventLog.Defines.pay_before_check_error, {
        packageId = packageInfo:getID()
      })
    end
  end
end

function PayManager:CustomPay(packageInfo)
  local buyType = packageInfo:GetBuyType()
  if buyType ~= GiftPackageBuyType.Money then
    if buyType == GiftPackageBuyType.PlayerGold then
      local resourceType, num = packageInfo:GetResourceBuyCostTypeAndNum()
      local ownNum = LuaEntry.Player.gold
      if num > ownNum then
        local data = {}
        table.insert(data, {resType = resourceType, need = num})
        LWResourceLackUtil:GotoResLack(data)
      end
    end
    local template = packageInfo._tableData
    SFSNetwork.SendMessage(MsgDefines.ExchangeDiamondBuy, tonumber(template.id))
    return true
  end
  return false
end

function PayManager:CancelPay()
  self.packageInfo = nil
  self.fromView = nil
  self.chooseItem = nil
  PostEventLog.Track(PostEventLog.Defines.cancel_pay, {})
end

function PayManager:PayParseData(message, itemId)
  local Player = LuaEntry.Player
  local status = message.status
  local orderId = message.orderId
  if status == 0 then
    local itemId = message.itemId or ""
    local cost = message.cost or ""
    local realCostNum = message.costNum or 0
    local realCurrencyType = message.costCurrencyType or ""
    local realOrderId = message.orderId or ""
    local realPayPf = message.paypf or ""
    if realCostNum ~= 0 and not string.IsNullOrEmpty(realCurrencyType) and 0 <= CS.StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, "1.0.156") then
      local costStr = realCostNum .. "|" .. realCurrencyType
      Sdk:SetFacebookPurchaseEvent(costStr, realOrderId)
      PostEventLog.Track(PostEventLog.Defines.Client_iOS_FB_PurchaseEvent, {
        pay_order_id = tostring(realOrderId),
        spend = string.format("%.2f", realCostNum),
        pay_product_id = tostring(itemId),
        currency = realCurrencyType,
        paypf = realPayPf,
        errMsg = costStr
      })
      BIManager.SendToBI("fb_log_purchase", {
        order_id = tostring(realOrderId),
        spend = string.format("%.2f", realCostNum),
        product_id = tostring(itemId),
        currency = realCurrencyType,
        paypf = realPayPf
      })
    end
    if not self:IsDisableOrderCache() then
      self:__removeOrderCache(orderId)
    end
    local gold = message.gold
    if gold ~= nil then
      Player.sm_addGoldCount = Player.gold
      Player.gold = gold
    end
    Player.payTotal = message.payTotal
    if message.gmGoldLimit ~= nil then
      Player.gmGoldLimit = message.gmGoldLimit
    end
    if message.gmGold ~= nil then
      Player.gmGold = message.gmGold
    end
    if message.goldBrickCount ~= nil then
      DataCenter.GoldBrickDataManager:ParseData(message)
    end
    local key = message.itemId
    local sendGift = false
    if message.exchangegift then
      sendGift = true
    end
    local itemName = ""
    local item = GiftPackageData.get(key)
    if item ~= nil then
      if item.type == "1" and item:GetIsShowType() ~= 0 then
        local vec = string.split(item.show_type, ";")
        if vec ~= nil and #vec == 2 and vec[1] == "12" then
          EventManager:GetInstance():Broadcast(EventId.REDPACK_BUY_GP_SUCCESS, key)
        end
      end
      itemName = item:getName()
      if not sendGift then
        item.bought = true
      end
      local isSubsOrder = false
      if message.isSubscribe then
        isSubsOrder = true
      end
      local reward = message.reward
      local goldAdd = message.goldAdd
      if reward ~= nil or goldAdd ~= nil then
        if ExchangeDefine.MONTH_CARD_ID == key then
          EventManager:GetInstance():Broadcast(EventId.BuyMonthCardSucess)
          EventManager:GetInstance():Broadcast(EventId.CLICK_WELFARE_CELL)
        elseif message.random_hero ~= nil then
        elseif LuaEntry.DataConfig:CheckSwitch("red_packet_switch") then
        elseif reward and 0 < table.count(reward) then
          isSubsOrder = false
        else
          EventManager:GetInstance():Broadcast(EventId.PaySuccess, itemId)
        end
        local showWindow = true
        if itemId == DataCenter.PlayerCareerManager.payAndUsePackId then
          showWindow = false
        end
        if DataCenter.ActivityRebateNewManager:IsRebateNewActivityPackage(itemId) then
          DataCenter.ActivityRebateNewManager:ShowGiftReward(message)
          showWindow = false
        end
        if showWindow then
          if message.itemId == DataCenter.LWAllyStationDataManager.BUY_TRAIN_GIFT_ID then
            TimerManager:GetInstance():DelayInvoke(function()
              DataCenter.RewardManager:ShowGiftReward(message)
            end, TrainAirDropEffectLength - 0.5)
          elseif self:IsDailyFreePackage(message.itemId) then
            DataCenter.RewardManager:ShowGiftReward(message, nil, function()
              self:DailyClaimFreePackage()
            end)
          else
            local isExist = DataCenter.MonthCardNewManager:CheckExistInMonthlyCardCfg(tonumber(message.itemId))
            local expiredFormationData = DataCenter.MonthCardNewManager:GetExpiredFormationData()
            if isExist and expiredFormationData then
              DataCenter.RewardManager:ShowGiftReward(message, nil, function()
                local monthFormationBackups = expiredFormationData.monthFormationBackups
                if monthFormationBackups and monthFormationBackups.data and #monthFormationBackups.data > 0 and monthFormationBackups.data[1].heroPosition and table.IsNotEmpty(monthFormationBackups.data[1].heroPosition) then
                  UIManager:GetInstance():OpenWindow(UIWindowNames.UIExpiredMonthlyCardRecover, {anim = true}, monthFormationBackups.data[1])
                else
                  UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("weekcard_squad_save_desc_6"), 1, "weekcard_squad_save_button_4", "", function()
                    local buildingData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)[1]
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.ExpiredMonthlyCard, buildingData.uuid)
                  end, nil, nil, "weekcard_squad_save_title_3")
                end
              end)
              DataCenter.MonthCardNewManager:SetExpiredFormationData(nil)
            else
              DataCenter.RewardManager:ShowGiftReward(message)
            end
          end
        end
        DataCenter.RewardManager:AddRewardsAndRes(message)
      end
      if isSubsOrder and itemId ~= CExchangeDefine.SUB_MONTH_CARD_ID then
        UIUtil.ShowTipsId(120133)
      end
      if message.exchange ~= nil then
        GiftPackageData.pushPack(message)
      end
      EventManager:GetInstance():Broadcast(EventId.GOLDEXCHANGE_LIST_CHANGE)
    elseif message.reward ~= nil then
      DataCenter.RewardManager:ShowGiftReward(message)
      DataCenter.RewardManager:AddRewardsAndRes(message)
    end
    local showSuccess = message.google_code == nil and message.reward == nil
    local pack = GiftPackManager.get(itemId)
    if pack then
      if pack:isGrowthPlanPack() then
        showSuccess = false
      elseif pack:isPiggyBankPack() then
        DataCenter.RewardManager:ShowGiftReward(message)
        showSuccess = false
      elseif pack:isEnergyBankPack() then
        message.getEnergy = message.getMoney
        message.getMoney = nil
        DataCenter.RewardManager:ShowGiftReward(message)
        showSuccess = false
      elseif pack:isHeroMonthCardPack() then
      elseif pack:isLWQueueWeekCardPack() then
        EventManager:GetInstance():Broadcast(EventId.LWWeekCardRefresh)
        showSuccess = false
      elseif pack:isCreditPack() then
        showSuccess = false
      end
    end
    if sendGift then
      if itemName ~= nil and itemName ~= "" and message.exchangeto ~= nil then
        local exchangeTo = message.exchangeto
        if exchangeTo.receiverName ~= nil then
          local content = Localization:GetString("120010", itemName)
          local toName = exchangeTo.receiverName
          CS.MailManager.Instance:reqSendMailMessage(toName, "", content, "", "", "", false, CS.MailType.MAIL_SELF_SEND, "", "", false)
        end
      end
      UIUtil.ShowMessage(Localization:GetString("120009"))
    elseif showSuccess then
      UIUtil.ShowMessage(Localization:GetString("E100076"), 1, "110006", "", function()
      end)
    end
    EventManager:GetInstance():Broadcast(EventId.PaySuccess, itemId)
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  elseif status == 1 then
    if not self:IsDisableOrderCache() then
      self:__removeOrderCache(orderId)
    end
    UIUtil.ShowMessage(Localization:GetString("E100042"), 1, GameDialogDefine.CONFIRM)
  elseif status == 2 then
    if not self:IsDisableOrderCache() then
      self:__addToPurchaseIdList(orderId)
    end
  elseif status == 3 then
    self:SetPayStateOff()
    return false
  elseif status == 6 then
    if not self:IsDisableOrderCache() then
      self:__removeOrderCache(orderId)
    end
    return false
  elseif status == 7 then
  else
    return false
  end
  return true
end

function PayManager:GetDollarText(dollar, productId, isPrice)
  local returnString = ""
  if not string.IsNullOrEmpty(productId) then
    returnString = self:GetLocalCurrency(productId)
  else
    local rate = self:GetExchangeRate()
    local symbol = self:GetLocalCurrencySymbol()
    if 0 < rate then
      local temp_dollar = tonumber(dollar) * rate
      local payValue = tostring(math.ceil(temp_dollar))
      if self.isSymbolAtRight == true then
        returnString = payValue .. symbol
      else
        returnString = symbol .. payValue
      end
    elseif isPrice then
      rate = 1
      local temp_dollar = tonumber(dollar) * rate
      local payValue = tostring(math.ceil(temp_dollar))
      if self.isSymbolAtRight == true then
        returnString = payValue .. symbol
      else
        returnString = symbol .. payValue
      end
    end
  end
  if not string.IsNullOrEmpty(returnString) then
    return returnString
  end
  local payCurrency = "US $"
  local temp_dollar = tonumber(dollar)
  if GlobalData.analyticID == "onestore" then
    payCurrency = "\226\130\169"
    local payCount = math.ceil(temp_dollar * 10) * 120
    payCount = string.GetFormattedStr(payCount)
    return payCurrency .. tostring(payCount)
  elseif GlobalData:isMiddleEast() then
    payCurrency = "T"
    local payCount = math.ceil(temp_dollar * 40) * 100
    payCount = string.GetFormattedStr(payCount)
    return payCurrency .. tostring(payCount)
  elseif GlobalData.analyticID == "mycard" then
    payCurrency = "TWD "
    local payCount = ""
    local list = self.goldPricesList
    if payCount == "" then
      payCount = math.ceil(temp_dollar) * 30.865
      payCount = string.GetFormattedStr(payCount)
      return payCurrency .. payCount
    end
  elseif SDKManager.IS_UNITY_ANDROID() then
    local symbol = self:GetLocalCurrencySymbol()
    local rate = self:GetExchangeRate()
    local _curCode = self:__GetLocalCurrencyCode()
    if not string.IsNullOrEmpty(symbol) and 0 < rate then
      local payValue = string.format("%.2f", temp_dollar * rate)
      if self.isSymbolAtRight == true then
        payValue = payValue .. symbol
      else
        payValue = symbol .. payValue
      end
      return payValue
    end
  elseif GlobalData.analyticID == "mol" then
    payCurrency = "THB "
    local payCount = ""
    local list = self.goldPricesList
    if not payCount.IsNullOrEmpty() then
      return payCurrency .. payCount
    end
  elseif GlobalData:isChina() then
    payCurrency = ""
    return payCurrency .. self:GetPriceCNY(dollar)
  elseif SDKManager.IS_UNITY_IPHONE() then
    local symbol = self:GetLocalCurrencySymbol()
    local rate = self:GetExchangeRate()
    local _curCode = self:__GetLocalCurrencyCode()
    if not string.IsNullOrEmpty(symbol) and 0 < rate then
      local payValue = string.format("%.2f", temp_dollar * rate)
      if self.isSymbolAtRight == true then
        payValue = payValue .. symbol
      else
        payValue = symbol .. payValue
      end
      return payValue
    end
  end
  payCurrency = "US $"
  return payCurrency .. tostring(dollar)
end

function PayManager:GetDisplayText(dollar)
  local returnString = ""
  local rate = self:GetExchangeRate()
  local symbol = self:GetLocalCurrencySymbol()
  local temp_dollar = tonumber(dollar) * rate
  local payValue = string.format("%.2f", temp_dollar)
  if self.isSymbolAtRight == true then
    returnString = payValue .. symbol
  else
    returnString = symbol .. payValue
  end
  if not string.IsNullOrEmpty(returnString) then
    return returnString
  end
end

function PayManager:GetPriceCNY(dollar)
  local price = dollar
  if PaymentPriceCNY[price] then
    return PaymentPriceCNY[price]
  else
    return math.ceil(price * 6.5)
  end
end

function PayManager:__callPtGoldPayment(selfOrderId, packageId)
  self.param = {}
  self.param.itemId = packageId
  self.param.orderId = selfOrderId
  self.param.productId = self.productId
  SFSNetwork.SendMessage(MsgDefines.PayPtGold, self.param)
end

local random = math.random

function PayManager:CreateOrderId()
  local curTime = Timer:GetServerTime()
  math.randomseed(curTime)
  local template = "xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx"
  local result = string.gsub(template, "[xy]", function(c)
    local v = c == "x" and random(0, 15) or random(8, 11)
    return string.format("%x", v)
  end)
  if LuaEntry and LuaEntry.Player then
    result = string.format("%s@%s", result, LuaEntry.Player:GetSourceServerId())
  end
  return result
end

function PayManager:__callPaymentTest(packageId, selfOrderId)
  self.param = {}
  self.param.itemId = packageId
  if LuaEntry.Player and LuaEntry.Player.transferSelfOrder then
    self.param.orderId = selfOrderId
  else
    self.param.orderId = self:CreateOrderId()
  end
  self.param.selfOrderId = selfOrderId
  SFSNetwork.SendMessage(MsgDefines.PayTest, self.param)
end

function PayManager:__callPaymentGoldBrick(selfOrderId)
  self.param = {}
  if LuaEntry.Player and LuaEntry.Player.transferSelfOrder then
    self.param.orderId = selfOrderId
  else
    self.param.orderId = self:CreateOrderId()
  end
  self.param.selfOrderId = selfOrderId
  SFSNetwork.SendMessage(MsgDefines.PayGoldBrick, self.param)
end

function PayManager:__removeOrderCache(orderId)
  local purshaseInfoList = Setting:GetString(SettingKeys.PURCHASE_KEY, "")
  if purshaseInfoList ~= nil and purshaseInfoList ~= "" then
    local list = string.split(purshaseInfoList, COK_PURCHASE_DELIMITER_ORDERS)
    if list ~= nil then
      for i = #list, 1, -1 do
        local subList = string.split(list[i], COK_PURCHASE_DELIMITER_DATA)
        if #subList ~= 10 or orderId == subList[2] then
          table.remove(list, i)
        end
      end
      purshaseInfoList = ""
      for k, v in ipairs(list) do
        if 1 < k then
          purshaseInfoList = purshaseInfoList .. COK_PURCHASE_DELIMITER_ORDERS
        end
        purshaseInfoList = purshaseInfoList .. v
      end
      Setting:SetString(SettingKeys.PURCHASE_KEY, purshaseInfoList)
    end
  end
end

function PayManager:__addToPurchaseIdList(orderId)
  if orderId ~= nil and orderId ~= "" then
    self:__removeOrderCache(orderId)
    if not self:__checkPurchaseSuccessed(orderId) then
      local idList = Setting:GetString(SettingKeys.PURCHASE_SUCCESSED_KEY, "")
      if idList ~= nil and idList ~= "" then
        idList = idList .. COK_PURCHASE_DELIMITER_ORDERS
      end
      idList = idList .. orderId
      Setting:SetString(SettingKeys.PURCHASE_SUCCESSED_KEY, idList)
    end
    if not GlobalData:isTencent() then
      self:__checkPurchaseInfoList()
    end
  end
end

function PayManager:__checkPurchaseSuccessed(orderId)
  local idList = Setting:GetString(SettingKeys.PURCHASE_SUCCESSED_KEY, "")
  if idList ~= nil and idList ~= "" then
    local subList = string.split(idList, COK_PURCHASE_DELIMITER_ORDERS)
    if subList ~= nil then
      for k, v in ipairs(subList) do
        if v == orderId then
          return true
        end
      end
    end
  end
  return false
end

function PayManager:__checkPurchaseItem(item)
  local foundPurchaseCache = false
  local pf = item[1]
  local orderId = item[2]
  local checkedPurchaseOrderId = self.historyPurchaseList[orderId]
  if checkedPurchaseOrderId == nil then
    foundPurchaseCache = true
    self.historyPurchaseList[orderId] = orderId
    if pf == "AppStore" then
      local sSignedData = item[3]
      local productId = item[4]
      local itemId = item[5]
      if string.contains(itemId, "_") then
        local mVec = string.split(itemId, "_")
        if mVec ~= nil and 1 < #mVec and mVec[1] ~= nil and mVec[1] ~= "" and mVec[2] ~= nil and mVec[2] ~= "" then
          self.param = {}
          self.param.orderId = orderId
          self.param.sSignedData = sSignedData
          self.param.productId = productId
          self.param.itemId = self.productId
          self.param.toUID = mVec[2]
          SFSNetwork.SendMessage(MsgDefines.PayIOS, self.param)
        end
      else
        self.param = {}
        self.param.orderId = orderId
        self.param.sSignedData = sSignedData
        self.param.productId = productId
        self.param.itemId = self.productId
        SFSNetwork.SendMessage(MsgDefines.PayIOS, self.param)
      end
    end
    if SDKManager.IS_UNITY_ANDROID() then
      if pf == "onestore" then
        self.param = {}
        self.param.txid = orderId
        self.param.signdata = subList[3]
        SFSNetwork.SendMessage(MsgDefines.PayTstore, self.param)
      elseif pf == "amazon" then
        local amazonUserId = subList[3]
        local sku = subList[4]
        local itemId = subList[5]
        local productType = subList[6]
        local purchaseTime = subList[7]
        if string.contains(itemId, "_") then
          local mVec = string.split(itemId, "_")
          if mVec ~= nil and 1 < #mVec and mVec[1] ~= nil and mVec[1] ~= "" and mVec[2] ~= nil and mVec[2] ~= "" then
            self.param = {}
            self.param.orderId = orderId
            self.param.productType = productType
            self.param.purchaseTime = purchaseTime
            self.param.sku = sku
            self.param.amazonUserId = amazonUserId
            self.param.itemId = mVec[1]
            self.param.toUID = mVec[2]
            SFSNetwork.SendMessage(MsgDefines.PayAmazon, self.param)
          end
        else
          self.param = {}
          self.param.orderId = orderId
          self.param.productType = productType
          self.param.purchaseTime = purchaseTime
          self.param.sku = sku
          self.param.amazonUserId = amazonUserId
          self.param.itemId = itemId
          SFSNetwork.SendMessage(MsgDefines.PayAmazon, self.param)
        end
      end
    end
  end
end

function PayManager:__checkPurchaseInfoList()
  if SDKManager.IS_UNITY_ANDROID() and GlobalData:isTencent() then
    self:__queryHistoryPurchase()
  end
  local foundPurchaseCache = false
  local purshaseInfoList = Setting:GetString(SettingKeys.PURCHASE_KEY, "")
  PayPrint("purshaseInfoList : " .. purshaseInfoList)
  local array = string.string2array_s(purshaseInfoList, COK_PURCHASE_DELIMITER_DATA, COK_PURCHASE_DELIMITER_ORDERS)
  if array then
    for _, v in ipairs(array) do
      if 2 < #v and self:__checkPurchaseItem(v) == true then
        foundPurchaseCache = true
        break
      end
    end
  end
  if foundPurchaseCache == false then
    self:__checkHistoryPurchase()
  end
end

function PayManager:OnCallPaymentServerCallback(status, orderId, gmGoldInfo)
  self:SetPayStateOff()
  if self.packageInfo ~= nil then
  end
  local Player = LuaEntry.Player
  if SDKManager.IS_UNITY_IPHONE() then
    Sdk:ConsumeProduct(orderId, status)
  elseif SDKManager.IS_UNITY_ANDROID() then
    Sdk:ConsumeProduct(orderId, status)
  end
  self:RefreshPayInfo()
  pcall(function()
    DataCenter.VIPManager:VipReqSourceRecord(VipRequestSource.PayManager)
  end)
end

function PayManager:__checkHistoryPurchase()
  if self.historyPurchaseChecked == false then
    self.historyPurchaseChecked = true
    self:__queryHistoryPurchase()
  end
end

function PayManager:PayIOS(productId, description, productid3)
  if self.payState == 0 then
    self.productId = productId
    self:SetPayStateOn()
    local tbl = {}
    tbl.skuId = productid3
    tbl.selfOrderId = self.itemId
    self:__doPay(tbl)
  end
end

function PayManager:PayGoogle(skuId)
  if self.payState == 0 then
    self:SetPayStateOn()
    local tbl = {}
    tbl.skuId = skuId
    tbl.itemId = self.itemId
    tbl.toUID = self.donateUID
    tbl.bRegister = false
    tbl.uid = LuaEntry.Player:GetUid()
    self:__doPay(tbl)
  end
end

function PayManager:PayTencent(itemId, uid, exchangeId, price, gold, desc)
  if self.payState == 0 then
    self:SetPayStateOn()
    local tbl = {}
    tbl.itemId = itemId
    tbl.uid = uid
    tbl.exchangeId = exchangeId
    tbl.price = price
    tbl.gold = gold
    tbl.desc = desc
    tbl.isTencent = true
    self:__doPay(tbl)
  end
end

function PayManager:PayOther(uid, exchangeId, price, gold, desc)
  if self.payState == 0 then
    self:SetPayStateOn()
    local tbl = {}
    tbl.uid = uid
    tbl.exchangeId = exchangeId
    tbl.price = price
    tbl.gold = gold
    tbl.desc = desc
    tbl.isTencent = false
    self:__doPay(tbl)
  end
end

function PayManager:__removeSelfOrderId(orderId)
  if self.purchaseSelfOrderId[orderId] ~= nil then
    self.purchaseSelfOrderId[orderId] = {}
  end
end

function PayManager:CheckSendServerSendGoods(orderId)
  if not orderId then
    return true
  end
  local now = tonumber(UITimeManager:GetInstance():GetServerTime())
  now = now or 0
  local orderIdStr = tostring(orderId)
  local lastTime = Setting:GetString(orderIdStr, "")
  if not string.IsNullOrEmpty(lastTime) and now > tonumber(lastTime) and now - tonumber(lastTime) < 500 then
    pcall(function()
      Logger.LogInfo("check send send goods fail" .. orderIdStr .. " " .. lastTime .. " " .. now)
    end)
    return false
  end
  Setting:SetString(orderIdStr, tostring(now))
  return true
end

function PayManager:CallPaymentGoogleSendGoods(Purchase)
  PostEventLog.Track(PostEventLog.Defines.call_payment_google_send_goods, {})
  local itemId = self.itemId
  if itemId == nil or itemId == "" then
    itemId = Setting:GetString(SettingKeys.CATCH_ITEM_ID, "")
  end
  local _orderId = Purchase.orderId
  local _signData = Purchase.signData
  local _purchaseTime = Purchase.purchaseTime
  local _signature = Purchase.signature
  local _productId = Purchase.productId
  local payload = Purchase.payload
  if not self:IsDisableOrderCache() then
    self:__addOrderCache("googleplay", _orderId, _signData, _productId, itemId)
  end
  self.param = {}
  self.param.orderId = _orderId
  self.param.productId = _productId
  self.param.purchaseTime = _purchaseTime
  self.param.signData = _signData
  self.param.signature = _signature
  if string.IsNullOrEmpty(payload) then
    self.param.itemId = itemId
  else
    local rawSpl = string.split(payload, "|")
    if 1 < #rawSpl then
      self.param.itemId = rawSpl[1]
      local innerSpl = string.split(rawSpl[2], "_")
      if 1 < #innerSpl then
        self.param.currencyCode = innerSpl[1]
        local num = tonumber(innerSpl[2]) / 1000000
        self.param.currencyNumber = tostring(num)
      end
    else
      self.param.itemId = payload
    end
  end
  SFSNetwork.SendMessage(MsgDefines.Pay, self.param)
end

function PayManager:__addOrderCache(pf, orderId, sSignedData, productId, itemId, productType, purchaseTime)
  Logger.Log("---------------add order cache---------------")
  if self:__checkPurchaseSuccessed(orderId) then
    Logger.Log("---------------order already fulfilled---------------")
    return
  end
  local purshaseInfoList = Setting:GetString(SettingKeys.PURCHASE_KEY, "")
  Logger.Log(string.format("------before add order %s", purshaseInfoList))
  local tmpInfo = string.format("%s|#|%s|#|%s|#|%s|#|%s|#|%s|#|%s|#|%s|#|%s|#|%s", pf, orderId, sSignedData, productId, itemId, productType, purchaseTime, "", "", "")
  if purshaseInfoList ~= nil and purshaseInfoList ~= "" then
    tmpInfo = string.format("%s%s%s", tmpInfo, COK_PURCHASE_DELIMITER_ORDERS, purshaseInfoList)
    local array = string.split(purshaseInfoList, COK_PURCHASE_DELIMITER_ORDERS)
    if array ~= nil then
      for k, v in ipairs(array) do
        local subList = string.split(v, COK_PURCHASE_DELIMITER_DATA)
        if subList ~= nil and (#subList ~= 10 or orderId == subList[2]) then
          Logger.Log("info already exist")
          return
        end
      end
    end
  end
  Setting:SetString(SettingKeys.PURCHASE_KEY, tmpInfo)
  Logger.Log("------after add order ", tmpInfo)
end

function PayManager:CallPaymentIOSSendGoods(Purchase)
  local orderId = Purchase.transactionIdentifier
  local sSignedData = Purchase.encodedReceipt
  local productId = Purchase.productIdentifier
  local priceNumber = Purchase.priceNumber
  local currencyCode = Purchase.currencyCode
  local itemId = Purchase.serverOrderId
  if string.IsNullOrEmpty(itemId) then
    itemId = self.itemId
    if itemId == nil or itemId == "" then
      itemId = Setting:GetString(SettingKeys.CATCH_ITEM_ID, "")
    end
  end
  if not self:IsDisableOrderCache() then
    self:__addOrderCache("AppStore", orderId, sSignedData, productId, itemId)
  end
  self.param = {}
  self.param.orderId = orderId
  self.param.sSignedData = sSignedData
  self.param.productId = productId
  self.param.itemId = itemId
  self.param.priceNumber = priceNumber
  self.param.currencyCode = currencyCode
  SFSNetwork.SendMessage(MsgDefines.PayIOS, self.param)
end

function PayManager:SetPayState(state)
  if state == 1 then
    self:SetPayStateOn()
  elseif state == 0 then
    self:SetPayStateOff()
  else
    self.payState = state
  end
end

function PayManager:SetPayStateOn()
  self.payState = 1
  if self.payStateTimer then
    self.payStateTimer:Stop()
    self.payStateTimer = nil
  end
  self.payStateTimer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
    self.payState = 0
    self.payStateTimer = nil
  end, 30)
end

function PayManager:SetPayStateOff()
  self.payState = 0
  if self.payStateTimer then
    self.payStateTimer:Stop()
    self.payStateTimer = nil
  end
end

function PayManager:GetExchangeRate()
  if self.exchangeRate > 0 then
    return self.exchangeRate
  else
    return Setting:GetFloat("gp_price_exchange_rate", 1)
  end
end

function PayManager:GetLocalCurrencySymbol()
  if not string.IsNullOrEmpty(self.localCurrencySymbol) then
    return self.localCurrencySymbol
  else
    return Setting:GetString("gp_price_symbole", "$")
  end
end

function PayManager:RefreshPayInfo()
  SFSNetwork.SendMessage(MsgDefines.VipInfo)
  SFSNetwork.SendMessage(MsgDefines.ExchangeInfo)
end

function PayManager:PayMessageHandle(message)
  if message.errorCode == nil then
    if message.orderId == self.param.orderId then
      if self:PayParseData(message) then
        if ExchangeDefine.MONTH_CARD_ID == self.param.itemId then
          EventManager:GetInstance():Broadcast(EventId.MONTHCARD_REFRESH)
        else
          self:OnCallPaymentServerCallback(message.status, message.orderId, message.gmGoldInfo)
        end
        if message.payDollerTotal and tonumber(message.payDollerTotal) then
          LuaEntry.Player:UpdatePayDollerTotal(tonumber(message.payDollerTotal))
        end
        EventManager:GetInstance():BroadcastDeferred(EventId.OnPackageInfoUpdated)
      end
    else
      self:RefreshPayInfo()
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    CS.GameEntry.Sdk:ConsumeProduct(self.param.orderId, 2)
  end
end

function PayManager:PayPtGoldMessageHandle(message)
  if message.errorCode == nil then
    if self:PayParseData(message) then
      LuaEntry.Player.ptGold = message.ptGold
      self:OnCallPaymentServerCallback(message.status, self.param.orderId)
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    CS.GameEntry.Sdk:ConsumeProduct(self.param.orderId, 2)
  end
end

function PayManager:PushPayWebMessageHandle(message)
  if message.errorCode == nil then
    self:__TryCloseExternalCheckoutWindowByPush(message.selfOrderId)
    self:PayParseData(message)
    self:RefreshPayInfo()
  end
end

function PayManager:PayBeforeCheckMessageHandle(message)
  if message.errorCode == nil then
    self:OnCallPaymentBeforeCheckCallbackNew(message)
  else
    self:CancelPay()
  end
end

function PayManager:PayTstoreMessageHandle(message)
  if message.errorCode == nil then
    if message.orderId == self.param.txid and self:PayParseData(message) then
      self:OnCallPaymentServerCallback(message.status, message.orderId, message.gmGoldInfo)
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    CS.GameEntry.Sdk:ConsumeProduct(self.param.orderId, 2)
  end
end

function PayManager:__queryHistoryPurchase()
  Sdk:SendDataToNative("Pay_queryHistoryPurchase", "")
end

function PayManager:__getBillingConfig()
  Sdk:SendDataToNative("Pay_getBillingConfig", "")
end

function PayManager:__doPay(tbl)
  local _payEnv = Sdk:CheckPayEnv()
  if 0 < _payEnv then
    if _payEnv == 300 then
      UIUtil.ShowMessage(Localization:GetString("320285"))
    else
      UIUtil.ShowMessage(Localization:GetString("320284"))
    end
    PostEventLog.Track(PostEventLog.Defines.pay_google_env_check_fail, {errMsg = _payEnv})
    self:SetPayStateOff()
    return
  end
  local json = rapidjson.encode(tbl)
  if json then
    PostEventLog.Track(PostEventLog.Defines.pay_google_step2, {})
    Sdk:Pay(json)
  end
end

function PayManager:__GetLocalCurrencyCode()
  if string.IsNullOrEmpty(self.localCurrencyCode) then
    self.localCurrencyCode = Setting:GetString("price_currency_code", "USD")
  end
  if string.contains(self.localCurrencyCode, "data") then
    local str = self.localCurrencyCode .. "\"}"
    local jsonStr = rapidjson.decode(str)
    if jsonStr == nil then
      self.localCurrencyCode = ""
    else
      self.localCurrencyCode = jsonStr.data or ""
    end
  end
  return self.localCurrencyCode
end

function PayManager:__GetNativeLocalCurrencyCode()
  if string.IsNullOrEmpty(self.nativeLocalCurrencyCode) then
    local code = Setting:GetString("price_currency_code", "")
    if not string.IsNullOrEmpty(code) then
      self.nativeLocalCurrencyCode = code
    end
  end
  if self.nativeLocalCurrencyCode and string.contains(self.nativeLocalCurrencyCode, "data") then
    local str = self.nativeLocalCurrencyCode .. "\"}"
    local jsonStr = rapidjson.decode(str)
    if jsonStr == nil then
      self.nativeLocalCurrencyCode = ""
    else
      self.nativeLocalCurrencyCode = jsonStr.data or ""
    end
  end
  return self.nativeLocalCurrencyCode
end

function PayManager:GetLocalCurrency(productId)
  local _product_price = self.m_SkuDetails[productId]
  if _product_price then
    return _product_price
  else
    local tbl = {}
    tbl.type = "inapp"
    tbl.list = {productId}
    local json = rapidjson.encode(tbl)
    Sdk:SendDataToNative("Pay_querySkuDetailsAsync", json)
    return Setting:GetString(productId, "")
  end
end

local CACHE_PRICE_NUM_KEY = "ProductPriceNum_%s"

function PayManager:GetProductPriceNumber(productId)
  local _product_price = self.m_SkuPriceNums[productId]
  if _product_price then
    return _product_price
  else
    local tbl = {}
    tbl.type = "inapp"
    tbl.list = {productId}
    local json = rapidjson.encode(tbl)
    Sdk:SendDataToNative("Pay_querySkuDetailsAsync", json)
    local cachedPriceNumKey = string.format(CACHE_PRICE_NUM_KEY, productId)
    local cachedPriceNum = Setting:GetString(cachedPriceNumKey, "")
    if not string.IsNullOrEmpty(cachedPriceNum) then
      return cachedPriceNum
    end
  end
end

function PayManager:GetPriceLocal(priceNum, txt)
  return Sdk:GetFormattedPrice(priceNum)
end

function PayManager:CheckRequestProdcut(productId)
  local price = Setting:GetString(productId, "")
  if string.IsNullOrEmpty(price) then
    self:GetLocalCurrency(productId)
  end
end

function PayManager:__onGetFormattedPrice(formattedPrice)
  local price = string.split(formattedPrice, ":")
  if price and #price == 2 then
    EventManager:GetInstance():Broadcast(EventId.OnGetFormattedPriceFromNative, price)
  end
end

function PayManager:__SdkCallback(key, data)
  CommonUtil.ProtectCall(function()
    if key == "onGooglePayInitResult" then
      self:__onGooglePayInitResult(data)
    elseif key == "onPurchaseQueried" then
      self:__onPurchaseQueried(data)
    elseif key == "onPurchaseCallback" then
      self:__onPurchaseCallback(data)
    elseif key == "onCallPayConfig" then
      self:__onCallPayConfig(data)
    elseif key == "onCallPayConfigFail" then
      self:__onCallPayConfigFail(data)
    elseif key == "onGetFormattedPrice" then
      self:__onGetFormattedPrice(data)
    elseif key == "onExternalCheckoutOpened" then
      self:__onExternalCheckoutOpened(data)
    elseif key == "onExternalCheckoutToken" then
      self:__onExternalCheckoutToken(data)
    elseif key == "onExternalCheckoutAvailability" then
      self:__onExternalCheckoutAvailability(data)
    elseif key == "onExternalCheckoutFailed" then
      self:__onExternalCheckoutFailed(data)
    elseif key == "onExternalCheckoutClosed" then
      self:__onExternalCheckoutClosed(data)
    end
  end)
end

function PayManager:__StopExternalCheckoutPendingTimer()
  if self.externalCheckoutPendingTimer ~= nil then
    self.externalCheckoutPendingTimer:Stop()
    self.externalCheckoutPendingTimer = nil
  end
end

function PayManager:__HandleExternalCheckoutPendingTimeout()
  self:__ResetExternalCheckoutFlowState(ExternalCheckoutFlowReason.PendingTimeout)
end

function PayManager:__RestartExternalCheckoutPendingTimer(timeoutSeconds)
  self:__StopExternalCheckoutPendingTimer()
  self.externalCheckoutPendingTimer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
    self.externalCheckoutPendingTimer = nil
    self:__HandleExternalCheckoutPendingTimeout()
  end, timeoutSeconds or ExternalCheckoutPendingTimeoutSeconds)
end

function PayManager:__ResetPendingGoldBrickExternalRequest()
  self.pendingGoldBrickExternalRequest = nil
end

function PayManager:__ResetPendingExternalCheckoutAvailabilityContext()
  self.pendingExternalCheckoutAvailabilityContext = nil
end

function PayManager:__ResetExternalCheckoutInFlightState()
  self.externalCheckoutGoogleTokenInFlight = nil
  self.externalCheckoutPreparedUrlInFlight = nil
  self.externalCheckoutTokenCallbackCount = 0
  self.externalCheckoutGoldBrickTokenRequestCount = 0
end

function PayManager:__ResetActiveExternalCheckoutOrder()
  self.activeExternalCheckoutOrderId = nil
end

function PayManager:__ResetExternalCheckoutFlowState(reason)
  local hasExternalState = self.pendingGoldBrickExternalRequest ~= nil or self.pendingExternalCheckoutAvailabilityContext ~= nil or not string.IsNullOrEmpty(self.activeExternalCheckoutOrderId) or not string.IsNullOrEmpty(self.externalCheckoutGoogleTokenInFlight) or not string.IsNullOrEmpty(self.externalCheckoutPreparedUrlInFlight) or self.externalCheckoutSelectedMethod ~= nil or self.externalCheckoutPendingTimer ~= nil
  if not hasExternalState then
    return
  end
  local finalReason = reason or ExternalCheckoutFlowReason.ResetExternalCheckoutFlowState
  self:__StopExternalCheckoutPendingTimer()
  self:__CancelPreparedExternalCheckout(finalReason)
  self:__ResetPendingGoldBrickExternalRequest()
  self:__ResetPendingExternalCheckoutAvailabilityContext()
  self:__ResetExternalCheckoutInFlightState()
  self:__ResetActiveExternalCheckoutOrder()
  self.externalCheckoutSelectedMethod = nil
  self.externalCheckoutFallbackOnFail = true
  self:SetPayStateOff()
  PayPrint("Reset external checkout flow state, reason=%s", GetExternalCheckoutFlowReasonName(finalReason))
end

function PayManager:ResetExternalCheckoutForInitMessage()
  self:__ResetExternalCheckoutFlowState(ExternalCheckoutFlowReason.InitData)
end

function PayManager:__IsExternalCheckoutInFlight()
  return self.pendingExternalCheckoutAvailabilityContext ~= nil or not string.IsNullOrEmpty(self.activeExternalCheckoutOrderId) or self.pendingGoldBrickExternalRequest ~= nil
end

function PayManager:__HasExternalCheckoutCallbackContext()
  return self.pendingExternalCheckoutAvailabilityContext ~= nil or self.pendingGoldBrickExternalRequest ~= nil or not string.IsNullOrEmpty(self.activeExternalCheckoutOrderId) or not string.IsNullOrEmpty(self.externalCheckoutGoogleTokenInFlight) or not string.IsNullOrEmpty(self.externalCheckoutPreparedUrlInFlight) or self.externalCheckoutSelectedMethod ~= nil
end

function PayManager:__StartUsExternalCheckoutAvailabilityProbe(selfOrderId, packageInfo, defaultMethod)
  local manager = DataCenter.PaymentMethodManager
  local externalCheckout = Sdk.ExternalCheckout
  local checkAvailability = externalCheckout and externalCheckout.CheckUsExternalCheckoutAvailability or nil
  if checkAvailability == nil then
    PayPrint("[pref] skip real-time external availability probe: api missing, fallback native, orderId=%s packageId=%s", tostring(selfOrderId), tostring(packageInfo and packageInfo:getID() or ""))
    return self:__PayWithNativeMethod(selfOrderId, packageInfo)
  end
  self.pendingExternalCheckoutAvailabilityContext = {
    selfOrderId = selfOrderId,
    packageInfo = packageInfo,
    defaultMethod = defaultMethod
  }
  self:__RestartExternalCheckoutPendingTimer()
  manager:SetRuntimeExternalCheckoutAvailability(manager.RuntimeAvailability.Unknown)
  if checkAvailability(externalCheckout) then
    return true
  end
  self:__StopExternalCheckoutPendingTimer()
  self:__ResetPendingExternalCheckoutAvailabilityContext()
  PayPrint("[pref] real-time external availability probe failed to start, fallback native, orderId=%s packageId=%s", tostring(selfOrderId), tostring(packageInfo and packageInfo:getID() or ""))
  return self:__PayWithNativeMethod(selfOrderId, packageInfo)
end

function PayManager:__onExternalCheckoutAvailability(data)
  local context = self.pendingExternalCheckoutAvailabilityContext
  local manager = DataCenter.PaymentMethodManager
  if context == nil then
    if manager:HasPendingUiAvailabilityRefresh() then
      manager:ApplyExternalCheckoutAvailabilityUpdate(data)
      return
    end
    PayPrint("Skip stale external checkout availability callback, payload=%s", tostring(data))
    return
  end
  self:__StopExternalCheckoutPendingTimer()
  manager:ApplyExternalCheckoutAvailabilityUpdate(data)
  self:__ResetPendingExternalCheckoutAvailabilityContext()
  local available = manager:IsRuntimeExternalCheckoutAvailable()
  if available then
    if context.defaultMethod == nil then
      self:__ShowUsPaymentMethodChooser(context.selfOrderId, context.packageInfo)
      return
    end
    self:__ExecuteUsPaymentByMethod(context.defaultMethod, context.selfOrderId, context.packageInfo, false, true)
    return
  end
  PayPrint("[pref] external checkout unavailable, fallback native, orderId=%s packageId=%s source=%s payload=%s", tostring(context.selfOrderId), tostring(context.packageInfo and context.packageInfo:getID() or ""), context.defaultMethod == nil and "chooser_probe" or "saved_default_external", tostring(data))
  self:__PayWithNativeMethod(context.selfOrderId, context.packageInfo)
end

function PayManager:__CreateExternalCheckoutResult(code, category, message, source)
  return {
    code = code or ExternalCheckoutResultCode.Unknown,
    category = category or ExternalCheckoutResultCategory.Failed,
    message = message or "",
    source = source or ExternalCheckoutResultSource.LuaFlow
  }
end

function PayManager:__ParseExternalCheckoutResult(resultData, defaultCode, defaultCategory, defaultSource)
  if type(resultData) == "table" then
    return self:__CreateExternalCheckoutResult(resultData.code, resultData.category, resultData.message, resultData.source)
  end
  if not string.IsNullOrEmpty(resultData) then
    local ok, decoded = pcall(rapidjson.decode, resultData)
    if ok and decoded ~= nil and type(decoded) == "table" and decoded.code ~= nil then
      return self:__CreateExternalCheckoutResult(tonumber(decoded.code) or defaultCode, tonumber(decoded.category) or defaultCategory, tostring(decoded.message or ""), tonumber(decoded.source) or defaultSource)
    end
  end
  return self:__CreateExternalCheckoutResult(defaultCode, defaultCategory, tostring(resultData or ""), defaultSource)
end

function PayManager:__IsExternalCheckoutCancelledResult(result)
  return result ~= nil and result.category == ExternalCheckoutResultCategory.UserCancelled
end

function PayManager:__GetExternalCheckoutResultLogMessage(result)
  if result == nil then
    return ""
  end
  local message = result.message or ""
  if string.IsNullOrEmpty(message) then
    return tostring(result.code or "")
  end
  return string.format("%s|%s", tostring(result.code or ""), tostring(message))
end

function PayManager:__MarkExternalCheckoutCancelled(orderId, result)
  local cancelledOrderId = orderId
  if string.IsNullOrEmpty(cancelledOrderId) then
    cancelledOrderId = self.itemId
  end
  self.cancelledExternalCheckoutOrderId = cancelledOrderId
  self:CancelPay()
  self:__ResetActiveExternalCheckoutOrder()
  PayPrint("Mark external checkout cancelled, orderId=%s result=%s", tostring(cancelledOrderId), self:__GetExternalCheckoutResultLogMessage(result))
end

function PayManager:__CancelPreparedExternalCheckout(reason)
  if CS.ExternalCheckoutService.CancelPendingApproval ~= nil then
    CS.ExternalCheckoutService.CancelPendingApproval()
  end
  PayPrint("Cancel prepared external checkout, reason=%s", GetExternalCheckoutFlowReasonName(reason))
end

function PayManager:__OpenAndroidExternalCheckoutWindow(url)
  if string.IsNullOrEmpty(url) then
    PayPrint("Skip Android external checkout window, url empty")
    return
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIExternalCheckout) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIExternalCheckout)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIExternalCheckout, {anim = true}, {
    url = url,
    title = Localization:GetString("goldbrick_title_1")
  })
end

function PayManager:__TryCloseExternalCheckoutWindowByPush(selfOrderId)
  if string.IsNullOrEmpty(selfOrderId) then
    return
  end
  if tostring(self.activeExternalCheckoutOrderId) ~= tostring(selfOrderId) then
    return
  end
  if SDKManager.IS_UNITY_ANDROID() and UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIExternalCheckout) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIExternalCheckout)
  end
  self:__ResetPendingGoldBrickExternalRequest()
  self:__StopExternalCheckoutPendingTimer()
  self:__ResetExternalCheckoutInFlightState()
  self:__ResetActiveExternalCheckoutOrder()
  self.externalCheckoutSelectedMethod = nil
  self.externalCheckoutFallbackOnFail = true
  self:SetPayStateOff()
end

function PayManager:__onExternalCheckoutOpened(data)
  if string.IsNullOrEmpty(self.activeExternalCheckoutOrderId) then
    PayPrint("Skip stale external checkout opened callback, payload=%s", tostring(data))
    return
  end
  self:__RestartExternalCheckoutPendingTimer(ExternalCheckoutOpenedTimeoutSeconds)
  self:__ResetPendingGoldBrickExternalRequest()
  self.externalCheckoutGoogleTokenInFlight = nil
  if SDKManager.IS_UNITY_ANDROID() then
    self:__OpenAndroidExternalCheckoutWindow(data)
  elseif SDKManager.IS_UNITY_IPHONE() then
  end
end

function PayManager:__GetExternalCheckoutPackageName(packageInfo)
  local packageName = packageInfo:getNameText()
  if not string.IsNullOrEmpty(packageName) then
    return packageName
  end
  return tostring(packageInfo:getProductID() or "")
end

function PayManager:__BuildGoldBrickPayloadUrl(url, payload)
  if string.IsNullOrEmpty(url) or string.IsNullOrEmpty(payload) then
    return nil
  end
  if string.find(url, "payload=", 1, true) then
    local replacedUrl, replaceCount = string.gsub(url, "payload=[^&]*", function()
      return "payload=" .. payload
    end, 1)
    if 0 < replaceCount then
      return replacedUrl
    end
  end
  local separator = string.find(url, "?", 1, true) and "&" or "?"
  return string.format("%s%spayload=%s", url, separator, payload)
end

function PayManager:__RequestGoldBrickTokenForExternalCheckout(googleToken, canSkipTokenCheck)
  local requiresExternalToken = canSkipTokenCheck ~= true
  if requiresExternalToken and string.IsNullOrEmpty(googleToken) then
    PayPrint("Skip gold brick token request, googleToken empty")
    self:__onExternalCheckoutFailed(self:__CreateExternalCheckoutResult(ExternalCheckoutResultCode.EmptyExternalTransactionToken, ExternalCheckoutResultCategory.Failed, "googleToken empty", ExternalCheckoutResultSource.LuaFlow))
    return false
  end
  if self.packageInfo == nil or string.IsNullOrEmpty(self.itemId) then
    PayPrint("Skip gold brick token request, packageInfo=%s itemId=%s", tostring(self.packageInfo ~= nil), tostring(self.itemId))
    self:__CancelPreparedExternalCheckout(ExternalCheckoutFlowReason.MissingOrderOrPackage)
    self:__onExternalCheckoutFailed(self:__CreateExternalCheckoutResult(ExternalCheckoutResultCode.MissingOrderOrPackage, ExternalCheckoutResultCategory.Failed, "packageInfo or itemId missing", ExternalCheckoutResultSource.LuaFlow))
    return false
  end
  local packageName = self:__GetExternalCheckoutPackageName(self.packageInfo)
  self.externalCheckoutGoldBrickTokenRequestCount = (self.externalCheckoutGoldBrickTokenRequestCount or 0) + 1
  if self.pendingGoldBrickExternalRequest ~= nil and tostring(self.pendingGoldBrickExternalRequest.selfOrderId) == tostring(self.itemId) and tostring(self.externalCheckoutGoogleTokenInFlight) == tostring(googleToken) then
    return true
  end
  self.externalCheckoutGoogleTokenInFlight = googleToken
  self.pendingGoldBrickExternalRequest = {
    selfOrderId = self.itemId,
    packageName = packageName,
    googleToken = googleToken
  }
  self.activeExternalCheckoutOrderId = self.itemId
  SFSNetwork.SendMessage(MsgDefines.GetGoldBrickToken, {
    selfOrderId = self.itemId,
    packageName = packageName,
    googleToken = googleToken
  })
  return true
end

function PayManager:__BuildGoldBrickExternalCheckoutUrl(tokenData)
  if tokenData == nil or string.IsNullOrEmpty(tokenData.url) then
    return nil
  end
  local payload = tokenData.goldBrickUuid
  if string.IsNullOrEmpty(payload) then
    payload = tokenData.token
  end
  if string.IsNullOrEmpty(payload) then
    return nil
  end
  return self:__BuildGoldBrickPayloadUrl(tokenData.url, payload)
end

function PayManager:__OpenPreparedExternalCheckout(url)
  if string.IsNullOrEmpty(url) then
    return false
  end
  if CS.ExternalCheckoutService.OpenPreparedUrl ~= nil then
    return CS.ExternalCheckoutService.OpenPreparedUrl(url)
  end
  return false
end

function PayManager:__onExternalCheckoutToken(data)
  if string.IsNullOrEmpty(self.activeExternalCheckoutOrderId) and self.pendingGoldBrickExternalRequest == nil then
    PayPrint("Skip stale external checkout token callback, payload=%s", tostring(data))
    return
  end
  local token = data
  local canSkipTokenCheck = false
  if not string.IsNullOrEmpty(data) then
    local ok, decoded = pcall(rapidjson.decode, data)
    if ok and decoded ~= nil and type(decoded) == "table" then
      if decoded.token ~= nil then
        token = tostring(decoded.token)
      end
      canSkipTokenCheck = decoded.canSkipTokenCheck == true
    end
  end
  self:__RestartExternalCheckoutPendingTimer()
  self.externalCheckoutTokenCallbackCount = (self.externalCheckoutTokenCallbackCount or 0) + 1
  self:__RequestGoldBrickTokenForExternalCheckout(token, canSkipTokenCheck)
end

function PayManager:__onExternalCheckoutFailed(resultData)
  if not self:__HasExternalCheckoutCallbackContext() then
    PayPrint("Skip stale external checkout failed callback, payload=%s", tostring(resultData))
    return
  end
  self:__StopExternalCheckoutPendingTimer()
  local result = self:__ParseExternalCheckoutResult(resultData, ExternalCheckoutResultCode.LaunchFailed, ExternalCheckoutResultCategory.Failed, ExternalCheckoutResultSource.NativeFailed)
  local activeOrderId = self.activeExternalCheckoutOrderId
  PayPrint("External checkout failed, result=%s selectedMethod=%s fallbackOnFail=%s", self:__GetExternalCheckoutResultLogMessage(result), tostring(self.externalCheckoutSelectedMethod), tostring(self.externalCheckoutFallbackOnFail))
  self:__ResetPendingGoldBrickExternalRequest()
  if SDKManager.IS_UNITY_ANDROID() then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIExternalCheckout) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIExternalCheckout)
    end
    if self:__IsExternalCheckoutCancelledResult(result) then
      self:SetPayStateOff()
      self:__ResetExternalCheckoutInFlightState()
      self:__MarkExternalCheckoutCancelled(activeOrderId, result)
      self.externalCheckoutSelectedMethod = nil
      self.externalCheckoutFallbackOnFail = true
      return
    end
    if self.packageInfo ~= nil and self.externalCheckoutFallbackOnFail ~= false then
      PayPrint("External checkout fallback -> Google IAP, productId=%s", tostring(self.packageInfo:getProductID()))
      self.externalCheckoutSelectedMethod = nil
      self.externalCheckoutFallbackOnFail = true
      self:__ResetExternalCheckoutInFlightState()
      self:__ResetActiveExternalCheckoutOrder()
      self:SetPayStateOff()
      self:PayGoogle(self.packageInfo:getProductID())
      return
    end
  elseif SDKManager.IS_UNITY_IPHONE() then
    if self:__IsExternalCheckoutCancelledResult(result) then
      self:SetPayStateOff()
      self:__ResetExternalCheckoutInFlightState()
      self:__MarkExternalCheckoutCancelled(activeOrderId, result)
      self.externalCheckoutSelectedMethod = nil
      self.externalCheckoutFallbackOnFail = true
      return
    end
    if self.packageInfo ~= nil and self.externalCheckoutFallbackOnFail ~= false then
      PayPrint("External checkout fallback -> iOS IAP, productId=%s", tostring(self.packageInfo:getProductID()))
      self.externalCheckoutSelectedMethod = nil
      self.externalCheckoutFallbackOnFail = true
      self:__ResetExternalCheckoutInFlightState()
      self:__ResetActiveExternalCheckoutOrder()
      self:SetPayStateOff()
      self:PayIOS(self.packageInfo:getID(), self.packageInfo:getProductID(), self.packageInfo:getProductID())
      return
    end
  end
  self.externalCheckoutSelectedMethod = nil
  self.externalCheckoutFallbackOnFail = true
  self:__ResetExternalCheckoutInFlightState()
  self:__ResetActiveExternalCheckoutOrder()
  self:SetPayStateOff()
end

function PayManager:__onExternalCheckoutClosed(resultData)
  if not self:__HasExternalCheckoutCallbackContext() then
    PayPrint("Skip stale external checkout closed callback, payload=%s", tostring(resultData))
    return
  end
  self:__StopExternalCheckoutPendingTimer()
  local result = self:__ParseExternalCheckoutResult(resultData, ExternalCheckoutResultCode.Closed, ExternalCheckoutResultCategory.UserCancelled, ExternalCheckoutResultSource.NativeClosed)
  local closedOrderId = self.activeExternalCheckoutOrderId
  self:__ResetPendingGoldBrickExternalRequest()
  if SDKManager.IS_UNITY_ANDROID() and UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIExternalCheckout) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIExternalCheckout)
  end
  self:__MarkExternalCheckoutCancelled(closedOrderId, result)
  self.externalCheckoutSelectedMethod = nil
  self.externalCheckoutFallbackOnFail = true
  self:__ResetExternalCheckoutInFlightState()
  self:SetPayStateOff()
end

function PayManager:OnExternalCheckoutWindowClosedByUser()
  if string.IsNullOrEmpty(self.activeExternalCheckoutOrderId) and self.pendingGoldBrickExternalRequest == nil then
    PayPrint("Skip manual external checkout close, no active state")
    return
  end
  self:__onExternalCheckoutClosed(self:__CreateExternalCheckoutResult(ExternalCheckoutResultCode.UserClosedWindow, ExternalCheckoutResultCategory.UserCancelled, "user closed window", ExternalCheckoutResultSource.LuaUI))
end

function PayManager:__PayWithNativeMethod(selfOrderId, packageInfo)
  if SDKManager.IS_UNITY_IPHONE() then
    PayPrint("Fallback to iOS IAP, orderId=%s productId=%s", tostring(selfOrderId), tostring(packageInfo:getProductID()))
    self:PayIOS(packageInfo:getID(), packageInfo:getProductID(), packageInfo:getProductID())
    return true
  end
  if SDKManager.IS_UNITY_ANDROID() then
    PayPrint("Fallback to Google IAP, orderId=%s productId=%s", tostring(selfOrderId), tostring(packageInfo:getProductID()))
    self:PayGoogle(packageInfo:getProductID())
    return true
  end
  return false
end

function PayManager:__PersistSelectedPaymentMethod(method, shouldSaveDefault)
  if not shouldSaveDefault then
    return
  end
  local manager = DataCenter.PaymentMethodManager
  manager:SetDefaultMethod(method)
  if not manager:SyncDefaultMethodToServer(method) and manager.RestoreServerPreferences ~= nil then
    manager:RestoreServerPreferences()
  end
end

function PayManager:__ExecuteUsPaymentByMethod(method, selfOrderId, packageInfo, shouldSaveDefault, allowExternalFallbackOnFail)
  local manager = DataCenter.PaymentMethodManager
  local externalMethod = manager.MethodType.External
  local nativeMethod = manager.MethodType.Native
  if method == externalMethod then
    self.externalCheckoutSelectedMethod = externalMethod
    self.externalCheckoutFallbackOnFail = allowExternalFallbackOnFail == true
    if self:TryLaunchUsExternalCheckout(selfOrderId, packageInfo) then
      self:__PersistSelectedPaymentMethod(method, shouldSaveDefault)
      return true
    end
    if allowExternalFallbackOnFail == true then
      PayPrint("Saved default external payment launch failed before open, fallback native, orderId=%s packageId=%s", tostring(selfOrderId), tostring(packageInfo and packageInfo:getID() or ""))
      self.externalCheckoutSelectedMethod = nil
      self.externalCheckoutFallbackOnFail = true
      return self:__PayWithNativeMethod(selfOrderId, packageInfo)
    end
    PayPrint("Selected external payment launch failed, keep current flow without native fallback")
    self.externalCheckoutSelectedMethod = nil
    self.externalCheckoutFallbackOnFail = true
    return false
  end
  if method == nativeMethod then
    self.externalCheckoutSelectedMethod = nil
    self.externalCheckoutFallbackOnFail = true
    self:__PersistSelectedPaymentMethod(method, shouldSaveDefault)
    return self:__PayWithNativeMethod(selfOrderId, packageInfo)
  end
  return false
end

function PayManager:__ShowUsPaymentMethodChooser(selfOrderId, packageInfo)
  local manager = DataCenter.PaymentMethodManager
  local saveAsDefault = false
  local nativeMethod = manager.MethodType.Native
  local externalMethod = manager.MethodType.External
  local showSaveDefaultToggle = manager:ShouldShowSaveDefaultToggle()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPaymentMethodSelect, {anim = true, playEffect = false}, {
    packageInfo = packageInfo,
    showSaveDefaultToggle = showSaveDefaultToggle,
    defaultSaveDefault = false,
    onSaveDefaultChanged = function(isOn)
      saveAsDefault = isOn == true
    end,
    onExternalSelect = function()
      if self:__ExecuteUsPaymentByMethod(externalMethod, selfOrderId, packageInfo, saveAsDefault, false) then
        return
      end
      PayPrint("External method selection failed before launch, keep chooser-triggered flow without native fallback, orderId=%s packageId=%s", tostring(selfOrderId), tostring(packageInfo and packageInfo:getID() or ""))
    end,
    onNativeSelect = function()
      self:__ExecuteUsPaymentByMethod(nativeMethod, selfOrderId, packageInfo, saveAsDefault)
    end,
    onClose = function()
    end
  })
  return true
end

function PayManager:TryHandleUsPaymentMethodFlow(selfOrderId, packageInfo)
  local manager = DataCenter.PaymentMethodManager
  if not manager:CanUseUsExternalCheckoutForPaymentFlow() then
    return false
  end
  local controlEnabled = manager:RefreshState()
  if controlEnabled ~= true then
    PayPrint("[pref] skip payment method flow: control disabled after refresh, fallback native, orderId=%s packageId=%s", tostring(selfOrderId), tostring(packageInfo and packageInfo:getID() or ""))
    return self:__PayWithNativeMethod(selfOrderId, packageInfo)
  end
  if manager:ShouldForceUsExternalCheckout() then
    PayPrint("[pref] skip chooser by item k4=2, force external checkout, orderId=%s packageId=%s", tostring(selfOrderId), tostring(packageInfo and packageInfo:getID() or ""))
    return self:__StartUsExternalCheckoutAvailabilityProbe(selfOrderId, packageInfo, manager.MethodType.External)
  end
  if not manager:ShouldShowUsPaymentMethodChooser() then
    PayPrint("[pref] skip chooser by item k4, fallback native, orderId=%s packageId=%s", tostring(selfOrderId), tostring(packageInfo and packageInfo:getID() or ""))
    return self:__PayWithNativeMethod(selfOrderId, packageInfo)
  end
  local defaultMethod = manager:GetDefaultMethod()
  if not string.IsNullOrEmpty(defaultMethod) then
    if defaultMethod == manager.MethodType.Native then
      return self:__ExecuteUsPaymentByMethod(defaultMethod, selfOrderId, packageInfo, false)
    end
    return self:__StartUsExternalCheckoutAvailabilityProbe(selfOrderId, packageInfo, defaultMethod)
  end
  return self:__StartUsExternalCheckoutAvailabilityProbe(selfOrderId, packageInfo, nil)
end

function PayManager:__onGooglePayInitResult(jsonData)
  local result = rapidjson.decode(jsonData)
  if result and result.code == 0 then
    LuaEntry.GlobalData.s_isGooglePlayAvailable = true
    self.BillingClientVersion = result.version
    self:__getBillingConfig()
    return
  else
  end
end

local test = false

function PayManager:__onPurchaseQueried(data)
  print("gp_pay2_log" .. data)
  PostEventLog.Track(PostEventLog.Defines.on_purchase_queried, {data = data})
  if string.IsNullOrEmpty(data) then
    return
  end
  if test == false then
    self:LogToServer("gp_pay2_all" .. tostring(data))
    test = true
  end
  self:__setLocalCurrency(data)
  if not self:CheckQueryPatchOn() and not self.hasRequestAllProduct then
    local allProducts = DataCenter.GoldBrickTemplateManager:GetAllProductId()
    for _, v in pairs(allProducts) do
      self:CheckRequestProdcut(tostring(v))
    end
    self.hasRequestAllProduct = true
  end
  if self.receiveStoreCode then
    self:TrySyncStoreInfo()
  end
end

function PayManager:__setLocalCurrency(data)
  local jsondata = rapidjson.decode(data)
  if jsondata == nil then
    return
  end
  data = jsondata.data or ""
  
  local function RecordProductPrice(productList)
    for _, v in pairs(productList) do
      local tabV = string._split_ss_array(v, ":")
      if table.count(tabV) == 2 then
        local product_id = tabV[1]
        local product_price = tabV[2]
        if product_id == "prod_2" or product_id == "prodios_2" then
          local _price_num = 0
          for k in string.gmatch(product_price, "(%-?%d+%.*%d*)") do
            _price_num = tonumber(k)
          end
          self.exchangeRate = _price_num / 1.99
          self:LogToServer("gp_pay2_gp_price_exchange_rate" .. self.exchangeRate)
          self:LogToServer("gp_pay2_gp_price" .. product_price)
          Setting:SetFloat("gp_price_exchange_rate", self.exchangeRate)
          if string.IsNullOrEmpty(self.localCurrencySymbol) then
            self.localCurrencySymbol = string.gsub(product_price, regex, "")
            if string.startswith(product_price, self.localCurrencySymbol) then
              self.isSymbolAtRight = false
            elseif string.endswith(product_price, self.localCurrencySymbol) then
              self.isSymbolAtRight = true
            end
            Setting:SetString("gp_price_symbole", self.localCurrencySymbol)
            self:LogToServer("gp_pay2_gp_price_symbole" .. self.localCurrencySymbol)
          end
        end
        Setting:SetString(product_id, product_price)
        self.m_SkuDetails[product_id] = product_price
      elseif table.count(tabV) == 3 then
        local product_id = tabV[1]
        local product_price = tabV[2]
        local product_price_num = tabV[3] or 0
        if SDKManager.IS_UNITY_ANDROID() then
          product_price_num = product_price_num / 1000000
        end
        if product_id == "prod_2" or product_id == "prodios_2" then
          local _price_num = product_price_num
          self.exchangeRate = _price_num / 1.99
          self:LogToServer("gp_pay2_gp_price_exchange_rate" .. self.exchangeRate)
          self:LogToServer("gp_pay2_gp_price" .. product_price)
          Setting:SetFloat("gp_price_exchange_rate", self.exchangeRate)
          if string.IsNullOrEmpty(self.localCurrencySymbol) then
            self.localCurrencySymbol = string.gsub(product_price, regex, "")
            if string.startswith(product_price, self.localCurrencySymbol) then
              self.isSymbolAtRight = false
            elseif string.endswith(product_price, self.localCurrencySymbol) then
              self.isSymbolAtRight = true
            end
            Setting:SetString("gp_price_symbole", self.localCurrencySymbol)
            self:LogToServer("gp_pay2_gp_price_symbole" .. self.localCurrencySymbol)
          end
        end
        Setting:SetString(product_id, product_price)
        self.m_SkuDetails[product_id] = product_price
        self.m_SkuPriceNums[product_id] = product_price_num
        local product_price_num_str = string.format(CACHE_PRICE_NUM_KEY, product_id)
        Setting:SetString(product_price_num_str, product_price_num)
      end
    end
  end
  
  local _tabData = string._split_ss_array(data, "|")
  if table.count(_tabData) == 2 then
    self.localCurrencyCode = _tabData[1]
    self.nativeLocalCurrencyCode = _tabData[1]
    Setting:SetString("price_currency_code", self.localCurrencyCode)
    local _productList = string._split_ss_array(_tabData[2], ";")
    RecordProductPrice(_productList)
  else
    local _productList = string._split_ss_array(data, ";")
    RecordProductPrice(_productList)
  end
end

function PayManager:_isConsumedOrder(orderId)
  local PayOrderData = CS.GameEntry.PayOrderData
  if PayOrderData and PayOrderData.IsOrderConsumed then
    local state = PayOrderData:IsOrderConsumed(orderId)
    return state
  else
    return false
  end
end

function PayManager:__onPurchaseCallback(jsonData)
  local result = rapidjson.decode(jsonData)
  if result == nil then
    PostEventLog.Track(PostEventLog.Defines.on_purchase_callback_break, {err_code = "nil", errMsg = jsonData})
    return
  end
  
  local function stripSensitiveDataIOS(data)
    local strippedData = {}
    if data then
      strippedData.code = data.code
      strippedData.orderId = data.transactionIdentifier
      strippedData.productId = data.productIdentifier
      strippedData.priceNumber = data.priceNumber
      strippedData.currencyCode = data.currencyCode
      strippedData.serverOrderId = data.serverOrderId
      strippedData.typeCode = data.typeCode
      strippedData.type = data.type
    end
    return strippedData
  end
  
  local function stripSensitiveDataGoogle(data)
    local strippedData = {}
    if data then
      strippedData.code = data.code
      strippedData.orderId = data.orderId
      strippedData.productId = data.productId
      strippedData.purchaseTime = data.purchaseTime
      strippedData.signData = data.signData
      strippedData.payload = data.payload
      strippedData.typeCode = data.typeCode
      strippedData.type = data.type
    end
    return strippedData
  end
  
  local isAndroid = SDKManager.IS_UNITY_ANDROID()
  local isIOS = SDKManager.IS_UNITY_IPHONE()
  
  local function stripSensitiveData(data)
    if isAndroid then
      return stripSensitiveDataGoogle(data)
    elseif isIOS then
      return stripSensitiveDataIOS(data)
    end
  end
  
  local code = tonumber(result.code)
  if code ~= 0 then
    self:SetPayStateOff()
    PostEventLog.Track(PostEventLog.Defines.on_purchase_callback_break, stripSensitiveData(result))
    if isIOS then
      local errorTypeCode = result.typeCode
      if errorTypeCode and tonumber(errorTypeCode) == IOS_PAY_ERRORCODE.CANTMAKEPAYMENT then
        UIUtil.ShowMessage(Localization:GetString("ios_pay_forbid_tips"), 1, "ios_pay_forbid_btn", nil, nil, nil, nil, "ios_pay_forbid_title")
      end
    elseif isAndroid then
      local errorTypeCode = tonumber(result.typeCode)
      if errorTypeCode == -2 and result.type == "product_details_not_supported" then
        UIUtil.ShowMessage(Localization:GetString("goldbrick_desc_lowversion"), 1, GameDialogDefine.CONFIRM)
      end
    end
    return
  end
  if self:_isConsumedOrder(result.orderId) then
    PostEventLog.Track(PostEventLog.Defines.on_purchase_callback_consumed_order, stripSensitiveData(result))
    return
  end
  if SDKManager.IS_UNITY_ANDROID() then
    self:CallPaymentGoogleSendGoods(result)
  elseif SDKManager.IS_UNITY_IPHONE() then
    self:CallPaymentIOSSendGoods(result)
  end
  PostEventLog.Track(PostEventLog.Defines.on_purchase_callback, stripSensitiveData(result))
end

function PayManager:UpdateFirstPayStatus(tempStatus)
  self.firstPayStatus = tempStatus
  EventManager:GetInstance():Broadcast(EventId.FirstPayStatusChange)
end

function PayManager:GetFirstPayRewards()
  return self.firstPayRewards
end

function PayManager:GetFirstPayStatus()
  return self.firstPayStatus
end

function PayManager:GetCacheFirstPayReward()
  local tempMsg = self.cacheRewardsFromMsg
  self.cacheRewardsFromMsg = nil
  return tempMsg
end

function PayManager:CheckIfFirstPayOpen()
  local k1 = LuaEntry.DataConfig:TryGetNum("first_pay", "k3")
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if buildData ~= nil and k1 <= buildData.level and (self.firstPayStatus == 0 or self.firstPayStatus == 1) then
    return true
  end
  return false
end

function PayManager:BuyGift(info, selectedCombineIndex)
  if not info then
    return
  end
  local combinationData = ""
  if info._tableData and not string.IsNullOrEmpty(info._tableData.item_combine) then
    local combineVec = string.split(info._tableData.item_combine, "@", 0, true)
    if combineVec ~= nil and selectedCombineIndex ~= nil and selectedCombineIndex <= #combineVec then
      combinationData = combineVec[selectedCombineIndex]
    end
  end
  self:CallPayment(info, "", combinationData)
end

local function IsVietnamAndroid(self)
  if SDKManager.IS_UNITY_ANDROID() then
    local localCurrencyCode = self:__GetLocalCurrencyCode()
    if localCurrencyCode and localCurrencyCode == "VND" then
      return true
    end
  end
end

local function IsVietnamAndroidSwithOn(self)
  local switch = LuaEntry.DataConfig:TryGetNum("vn_goldbrick_goto", "k1", 0)
  if switch == 1 then
    return true
  end
  return false
end

local needGuideToGoldbrick

local function NeedGuideToGoldBrick(self)
  if needGuideToGoldbrick == nil then
    if Config.IsPC() then
      needGuideToGoldbrick = true
    elseif IsVietnamAndroid(self) and IsVietnamAndroidSwithOn(self) then
      needGuideToGoldbrick = true
    else
      needGuideToGoldbrick = false
    end
  end
  return needGuideToGoldbrick
end

function PayManager:OnCallPaymentBeforeCheckCallbackNew(message)
  local Player = LuaEntry.Player
  local selfOrderId = message.selfOrderId
  local productId = message.productId
  local packageInfo
  if not string.IsNullOrEmpty(productId) then
    packageInfo = GiftPackManager.get(productId)
  end
  packageInfo = packageInfo or self.packageInfo
  if not packageInfo then
    return
  end
  local canUseGoldBrick = true
  if packageInfo:getType() == GiftPackType.CreditPackage or packageInfo:getType() == GiftPackType.LawBrickPackage then
    canUseGoldBrick = false
  end
  if canUseGoldBrick then
    local goldBrickCount = DataCenter.GoldBrickDataManager:GetGoldBrickCount()
    goldBrickCount = tonumber(goldBrickCount)
    if 0 < goldBrickCount then
      local price = packageInfo:getCostGoldBrick()
      if price and 0 < price and goldBrickCount >= price then
        UIUtil.ShowCostGoldBrickConfirm(packageInfo:getNameText(), price, function()
          local haveGoldBrick = DataCenter.GoldBrickDataManager:GetGoldBrickCount()
          if haveGoldBrick >= price then
            self:__callPaymentGoldBrick(selfOrderId)
          end
        end)
        return
      end
    end
  end
  if CommonUtils.IsDebug() then
    self:__callPaymentTest(packageInfo:getID(), selfOrderId)
    return
  end
  if Player.gmFlag == 1 or Player.gmFlag == 10 then
    local dollar = 0
    if packageInfo:getPrice() ~= nil and packageInfo:getPrice() ~= "" then
      dollar = tonumber(packageInfo:getPrice())
    end
    if 0 < Player.gmGoldLimit and Player.gmGold + dollar <= Player.gmGoldLimit then
      self:__callPaymentTest(packageInfo:getID(), selfOrderId)
    else
      self:CallOnlinePaymentNotiveNew(selfOrderId, packageInfo)
    end
  else
    self:CallOnlinePaymentNotiveNew(selfOrderId, packageInfo)
  end
end

function PayManager:CallOnlinePaymentNotiveNew(selfOrderId, packageInfo)
  local manager = DataCenter.PaymentMethodManager
  if manager:IsUsExternalCheckoutGreyEnabled() then
    return self:__CallOnlinePaymentWithExternalCheckout(selfOrderId, packageInfo)
  end
  local Player = LuaEntry.Player
  if packageInfo ~= nil then
    if DataCenter.PayCurrencyLockManager:CheckIfLock(packageInfo) then
      return
    end
    self.itemId = selfOrderId
    Setting:SetString(SettingKeys.CATCH_ITEM_ID, selfOrderId)
    if Config.IsPC() and WelfareController.CanOpenGoldBrickStore() and self:PayGoldBrickDirect(packageInfo) then
      return
    end
    if NeedGuideToGoldBrick(self) then
      self:PayPCByGoldBrickWeb2()
      return
    end
    if SDKManager.IS_UNITY_IPHONE() then
      self:PayIOS(packageInfo:getID(), packageInfo:getProductID(), packageInfo:getProductID())
    elseif SDKManager.IS_UNITY_ANDROID() then
      self:PayGoogle(packageInfo:getProductID())
    end
  end
end

function PayManager:__CallOnlinePaymentWithExternalCheckout(selfOrderId, packageInfo)
  local Player = LuaEntry.Player
  if packageInfo ~= nil then
    if DataCenter.PayCurrencyLockManager:CheckIfLock(packageInfo) then
      return
    end
    if self:__IsExternalCheckoutInFlight() then
      PayPrint("Skip external checkout payment, flow already in flight, activeOrderId=%s requestOrderId=%s", tostring(self.activeExternalCheckoutOrderId), tostring(selfOrderId))
      return
    end
    if not string.IsNullOrEmpty(self.cancelledExternalCheckoutOrderId) then
      if tostring(self.cancelledExternalCheckoutOrderId) == tostring(selfOrderId) then
        PayPrint("Skip payment retry after external checkout cancellation, orderId=%s", tostring(selfOrderId))
        return
      end
      self.cancelledExternalCheckoutOrderId = nil
    end
    self:__ResetExternalCheckoutInFlightState()
    self:__ResetActiveExternalCheckoutOrder()
    self.itemId = selfOrderId
    Setting:SetString(SettingKeys.CATCH_ITEM_ID, selfOrderId)
    if Config.IsPC() and WelfareController.CanOpenGoldBrickStore() and self:PayGoldBrickDirect(packageInfo) then
      return
    end
    if NeedGuideToGoldBrick(self) then
      self:PayPCByGoldBrickWeb2()
      return
    end
    if self:TryHandleUsPaymentMethodFlow(selfOrderId, packageInfo) then
      return
    end
    if self:TryLaunchUsExternalCheckout(selfOrderId, packageInfo) then
      return
    end
    self:__PayWithNativeMethod(selfOrderId, packageInfo)
  end
end

function PayManager:TryLaunchUsExternalCheckout(selfOrderId, packageInfo)
  local manager = DataCenter.PaymentMethodManager
  if not manager:CanUseUsExternalCheckout() then
    return false
  end
  local externalCheckout = Sdk.ExternalCheckout
  local prepareExternalCheckout = externalCheckout and (externalCheckout.PrepareUsExternalCheckout or externalCheckout.LaunchConfiguredUsExternalCheckout) or nil
  if prepareExternalCheckout == nil then
    PayPrint("Skip US external checkout, PrepareUsExternalCheckout missing")
    return false
  end
  self.activeExternalCheckoutOrderId = selfOrderId
  self:SetPayStateOn()
  local prepared = prepareExternalCheckout(externalCheckout, true)
  if not prepared then
    self:__ResetActiveExternalCheckoutOrder()
    self:SetPayStateOff()
    return false
  end
  self:__RestartExternalCheckoutPendingTimer()
  return true
end

function PayManager:HandleGoldBrickTokenResponse(tokenData)
  if self.pendingGoldBrickExternalRequest == nil then
    return false
  end
  self:__ResetPendingGoldBrickExternalRequest()
  local finalUrl = self:__BuildGoldBrickExternalCheckoutUrl(tokenData)
  if string.IsNullOrEmpty(finalUrl) then
    self:__CancelPreparedExternalCheckout(ExternalCheckoutFlowReason.InvalidGoldBrickTokenResponse)
    self:__onExternalCheckoutFailed(self:__CreateExternalCheckoutResult(ExternalCheckoutResultCode.InvalidGoldBrickTokenResponse, ExternalCheckoutResultCategory.Failed, "invalid gold brick token response", ExternalCheckoutResultSource.LuaFlow))
    return true
  end
  if tostring(self.externalCheckoutPreparedUrlInFlight) == tostring(finalUrl) then
    return true
  end
  self.externalCheckoutPreparedUrlInFlight = finalUrl
  self.externalCheckoutGoogleTokenInFlight = nil
  self:__RestartExternalCheckoutPendingTimer()
  if not self:__OpenPreparedExternalCheckout(finalUrl) then
    self:__CancelPreparedExternalCheckout(ExternalCheckoutFlowReason.OpenPreparedExternalCheckoutFailed)
    self:__onExternalCheckoutFailed(self:__CreateExternalCheckoutResult(ExternalCheckoutResultCode.OpenPreparedExternalCheckoutFailed, ExternalCheckoutResultCategory.Failed, "open prepared external checkout failed", ExternalCheckoutResultSource.LuaFlow))
    return true
  end
  return true
end

function PayManager:HandleGoldBrickTokenError(errCode)
  if self.pendingGoldBrickExternalRequest == nil then
    return false
  end
  PayPrint("Handle gold brick token error for external checkout, orderId=%s errCode=%s", tostring(self.pendingGoldBrickExternalRequest.selfOrderId), tostring(errCode))
  self:__ResetPendingGoldBrickExternalRequest()
  self:__CancelPreparedExternalCheckout(ExternalCheckoutFlowReason.GoldBrickTokenError)
  self:__onExternalCheckoutFailed(self:__CreateExternalCheckoutResult(ExternalCheckoutResultCode.GoldBrickTokenError, ExternalCheckoutResultCategory.Failed, "gold brick token error:" .. tostring(errCode), ExternalCheckoutResultSource.LuaFlow))
  return true
end

function PayManager:PayPCByGoldBrickWeb2()
  local canBuyGoldBrick = LuaEntry.Player.canBuyGoldBrick
  if not canBuyGoldBrick or canBuyGoldBrick == 0 then
    UIUtil.ShowMessage(Localization:GetString("pc_pay_tips_001"), 1, GameDialogDefine.CONFIRM)
    return
  end
  local uid = LuaEntry.Player:GetUid()
  local url = string.format("%s?uid=%s", GoldBrickWebUrl2, uid)
  CS.SDKManager.OpenURL(url)
end

function PayManager:PayGoldBrickDirect(packageInfo)
  if not packageInfo then
    Logger.LogError("PayGoldBrickDirect: Invalid packageInfo")
    return false
  end
  local goldBrickItem
  if DataCenter.LWRefundPunishManager:GetIsRefundBrick(packageInfo) then
    local brickNum = DataCenter.LWRefundPunishManager:GetBrickNumById(packageInfo:getID(), true)
    goldBrickItem = WelfareController.GetGoldBrickItemByCount(brickNum)
  else
    local goldBrickCount = packageInfo:getCostGoldBrick()
    if not goldBrickCount or goldBrickCount <= 0 then
      goldBrickCount = 1
    else
      local haveGoldBrick = DataCenter.GoldBrickDataManager:GetGoldBrickCount()
      haveGoldBrick = tonumber(haveGoldBrick)
      local needGoldBrick = goldBrickCount - haveGoldBrick
      goldBrickCount = math.max(needGoldBrick, 1)
      goldBrickItem = WelfareController.GetGoldBrickItemByAtLeastCount(goldBrickCount)
    end
  end
  if goldBrickItem then
    local function __callback_for_tokenData(tokenData)
      if not (tokenData and tokenData.token) or not tokenData.url then
        Logger.LogError("PayGoldBrickDirect: Invalid tokenData received")
      else
        self:PayPCGoldBrickStore(tokenData, goldBrickItem, 1)
      end
      EventManager:GetInstance():RemoveListener(EventId.GoldBrickShopGetToken, __callback_for_tokenData)
    end
    
    EventManager:GetInstance():AddListener(EventId.GoldBrickShopGetToken, __callback_for_tokenData)
    SFSNetwork.SendMessage(MsgDefines.GetGoldBrickToken)
    return true
  end
  return false
end

function PayManager:PayPCGoldBrickStore(tokenData, goldBrickData, count)
  if not tokenData or not goldBrickData then
    Logger.LogError("PayPCGoldBrickStore: Invalid tokenData or goldBrickData")
    return
  end
  local token = tokenData.token
  local url = tokenData.url
  local uid = LuaEntry.Player:GetUid()
  if not Config.IsPC() then
    PostEventLog.Track(PostEventLog.Defines.goldbrick_IOS, {
      product_id = tostring(goldBrickData.goods_id)
    })
  end
  local embeded = {
    uid = uid,
    count = count or 1,
    goods_id = goldBrickData.goods_id,
    token = token
  }
  local json = rapidjson.encode(embeded)
  local encoded_json = base64.encode(json)
  local full_url = url .. "?embed=" .. encoded_json
  Logger.Log("Gold Brick Pay URL: " .. full_url)
  CS.SDKManager.OpenURL(full_url)
end

function PayManager:__onCallPayConfig(billingConfig)
  if string.IsNullOrEmpty(billingConfig) then
    return
  end
  self.storeCode = billingConfig
  self.receiveStoreCode = true
  self:TrySyncStoreInfo()
  DataCenter.PaymentMethodManager:RefreshState()
  EventManager:GetInstance():Broadcast(EventId.PlayerInfoUpdated)
  if WelfareController.CanOpenGoldBrickStore() then
    SFSNetwork.SendMessage(MsgDefines.GetGoldBrickInfo)
  end
end

function PayManager:__onCallPayConfigFail(errorCode)
  self.storeCode = nil
  self.receiveStoreCode = true
  self:TrySyncStoreInfo()
  DataCenter.PaymentMethodManager:RefreshState()
  EventManager:GetInstance():Broadcast(EventId.PlayerInfoUpdated)
end

function PayManager:TrySyncStoreInfo()
  local hasSetStore = LuaEntry.Player:GetStoreInfo()
  if hasSetStore ~= nil and hasSetStore == false then
    local nativeCurrency = self:__GetNativeLocalCurrencyCode()
    if not string.IsNullOrEmpty(nativeCurrency) and self.receiveStoreCode then
      local now = UITimeManager:GetInstance():GetServerSeconds()
      local last = self.__lastStoreInitSend or 0
      if now - last < 2 then
        return
      end
      self.__lastStoreInitSend = now
      local storeCode = self.storeCode or ""
      SFSNetwork.SendMessage(MsgDefines.StoreCurrencyInit, storeCode, nativeCurrency)
    end
  end
end

function PayManager:TryCollectStoreInfo()
  local getAllInfo = true
  if not self.receiveStoreCode then
    self:__getBillingConfig()
    getAllInfo = false
  end
  if string.IsNullOrEmpty(self:__GetNativeLocalCurrencyCode()) then
    getAllInfo = false
  end
  if getAllInfo then
    self:TrySyncStoreInfo()
  end
end

function PayManager:GetStorefrontCode()
  if self.receiveStoreCode then
    return self.storeCode or ""
  end
  local PayOrderData = CS.GameEntry.PayOrderData
  if PayOrderData and PayOrderData.GetStorefrontCode then
    local cached = PayOrderData:GetStorefrontCode()
    if not string.IsNullOrEmpty(cached) then
      self:__onCallPayConfig(cached)
      return self.storeCode or ""
    end
  end
  self:__getBillingConfig()
  return ""
end

function PayManager:IsDisableOrderCache()
  if self._isDisableOrderCache ~= nil then
    return self._isDisableOrderCache
  end
  local isDisable = LuaEntry.DataConfig:CheckSwitch("disable_setting_cache_order")
  self._isDisableOrderCache = isDisable
  return isDisable
end

function PayManager:IsDailyFreePackage(id)
  local totalPack, packs = DataCenter.DailyPackageManager:getDailyPackageGroup()
  if totalPack == id then
    return true
  end
  for _, v in pairs(packs) do
    if v == id then
      return true
    end
  end
  return false
end

function PayManager:DailyClaimFreePackage()
  local isFunctionOn = LuaEntry.DataConfig:CheckSwitch("free_chest_receive")
  if not isFunctionOn then
    return
  end
  local hasFree = GiftPackageData.CheckIfHasFreeWeeklyPackage()
  if hasFree then
    TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.BuyFreeWeeklyPackage, true)
    end, 0.5)
  end
end

return PayManager
