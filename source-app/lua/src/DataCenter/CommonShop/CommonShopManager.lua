local CommonShopManager = BaseClass("CommonShopManager")
local Localization = CS.GameEntry.Localization
local CommonShopGoodsTemplate = require("DataCenter.CommonShop.CommonShopGoodsTemplate")
local DecorationShopTemplate = require("DataCenter.CommonShop.DecorationShopTemplate")
local MaxLimit = 99

local function __init(self)
  self.goodsShopDic = {}
  self.goodsInfoDic = {}
  self.refreshCount = 0
  self.redCountDic = {}
  self.updateTimerDic = {}
  self.shopGoodsNumDic = {}
  self.decorationShopDic = {}
  self.shopDataDirtyDic = {}
  self:AddListener()
end

local function __delete(self)
  self.goodsShopDic = nil
  self.goodsInfoDic = nil
  self.refreshCount = nil
  self.redCountDic = nil
  self.updateTimerDic = nil
  self.shopGoodsNumDic = nil
  self.decorationShopDic = nil
  self.shopDataDirtyDic = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

function CommonShopManager:OnEnterGame()
  for _, shopType in pairs(CommonShopType) do
    self:SetAutoSelectMaxCountTag(shopType, false)
  end
end

local function InitAll(self)
  SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.Goods)
  SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.LimitTime)
  SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.Vip)
  SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.Adventure)
  SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.HonorShop)
  SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.GolloesShop)
  SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.SeasonShop)
  if self:CanShowDecorationShop() then
    SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.DecorationShop)
  end
  EventManager:GetInstance():Broadcast(EventId.CheckPubBubble, true)
  SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.HeroReset)
  SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.AllianceShop)
  SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.TrailTowerShop)
  SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.GiftShop)
  SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.GiftVoucher)
end

local function InitData(self, message)
  if message and message.decorationShop and message.decorationShop.giftInfo then
    local giftInfo = message.decorationShop.giftInfo
    self:UpdateDecorationShopMessage(giftInfo)
  end
end

local function UpdateDecorationShopMessage(self, giftInfoArr)
  if giftInfoArr and type(giftInfoArr) == "table" and giftInfoArr[1] then
    local decorationShopInfo = DecorationShopTemplate.New()
    decorationShopInfo:UpdateData(giftInfoArr[1])
    local key = decorationShopInfo.group
    self.decorationShopDic[key] = decorationShopInfo
    EventManager:GetInstance():Broadcast(EventId.OnDecorationShopInfoChange)
  end
end

local function UpdateOneShopInfo(self, msg)
  local updateAll = false
  if msg.type then
    self.goodsInfoDic[msg.type] = {}
    if msg.shopInfo then
      self.goodsShopDic[msg.type] = {}
      local newShop = {}
      for i, v in ipairs(msg.shopInfo) do
        local newOne = CommonShopGoodsTemplate.New()
        newOne:ParseData(v)
        table.insert(newShop, newOne)
      end
      table.sort(newShop, function(a, b)
        return a.order < b.order
      end)
      self.goodsShopDic[msg.type] = newShop
      updateAll = true
    end
  end
  if msg.shopLimit then
    for i, v in ipairs(msg.shopLimit) do
      self:UpdateOneGoodsInfo(msg.type, v, not msg.type)
    end
  end
  if msg.refreshCount then
    self.refreshCount = msg.refreshCount
  end
  self:UpdateRed(msg.type)
  EventManager:GetInstance():Broadcast(EventId.UpdateOneCommonShop, msg.type)
  self:AddUpdateTimer(msg.type)
end

local function AddUpdateTimer(self, shopType)
  if self.updateTimerDic[shopType] then
    self.updateTimerDic[shopType]:Stop()
    self.updateTimerDic[shopType] = nil
  end
  if shopType == CommonShopType.LimitTime then
    local _, remainTs = self:GetLimitShopNextRefreshTs()
    self.updateTimerDic[shopType] = TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.LimitTime)
    end, remainTs + 2)
  elseif shopType == CommonShopType.Vip or shopType == CommonShopType.AllianceShop or shopType == CommonShopType.HonorShop then
    local tomorrowSec = LuaEntry.GlobalData.tomorrow
    local curTimeSec = UITimeManager:GetInstance():GetServerSeconds()
    local todayLeft = tomorrowSec - curTimeSec + 1
    if todayLeft and 0 < todayLeft then
      self.updateTimerDic[shopType] = TimerManager:GetInstance():DelayInvoke(function()
        SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, shopType)
      end, todayLeft * 1000)
    end
  end
end

local function UpdateRed(self, shopType)
  local goodsList = self.goodsShopDic[shopType]
  local goodsInfoDic = self.goodsInfoDic[shopType]
  if not goodsList or #goodsList == 0 then
    self.redCountDic[shopType] = 0
    return
  end
  if shopType == CommonShopType.LimitTime then
    local limitShopNeedBaseLv = LuaEntry.DataConfig:TryGetNum("shop_random", "k4")
    if limitShopNeedBaseLv > DataCenter.BuildManager.MainLv then
      self.redCountDic[shopType] = 0
      return
    end
  elseif shopType == CommonShopType.HeroReset then
    self.redCountDic[shopType] = 0
    return
  elseif shopType == CommonShopType.AllianceShop then
    local click_count = UIUtil.GetWeekActiveCount("AllianceShopWeekOpenCount", false)
    if click_count == 0 then
      self.redCountDic[shopType] = 1
    else
      self.redCountDic[shopType] = 0
    end
    return
  elseif shopType == CommonShopType.TrailTowerShop then
    local cacheKey = "trailTower_shop_open1_" .. LuaEntry.Player.uid
    local lastTimeS = CS.GameEntry.Setting:GetInt(cacheKey, 0)
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local sameDay = UITimeManager:GetInstance():IsSameDayForServer(lastTimeS, serverTime)
    if not sameDay then
      self.redCountDic[shopType] = 1
    else
      self.redCountDic[shopType] = 0
    end
    return
  elseif shopType == CommonShopType.DecorationShop then
    local showRed = false
    for i, v in ipairs(goodsList) do
      local itemId = v.itemId
      if self:IfShopItemNew(itemId) then
        showRed = true
        break
      end
    end
    if showRed then
      self.redCountDic[shopType] = 1
    else
      local count = self.redCountDic[shopType]
      self.redCountDic[shopType] = 0
      if count ~= 0 then
        EventManager:GetInstance():Broadcast(EventId.OnDecorationShopBubbleCheck)
      end
    end
    return
  end
  local redCount = 0
  for i, v in ipairs(goodsList) do
    local goodsInfo = goodsInfoDic[v.id]
    local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
    local maxTimes = v.maxTimes
    local vipInfo = DataCenter.VIPManager:GetVipData()
    local needVip = v.vipLevel or 0
    local vipFit = vipInfo and needVip <= vipInfo.level
    if boughtTimes < maxTimes and v.costNum == 0 and vipFit then
      redCount = redCount + 1
    end
  end
  self.redCountDic[shopType] = redCount
  EventManager:GetInstance():Broadcast(EventId.OnCommonShopRedChange, shopType)
end

local function UpdateOneGoodsInfo(self, shopType, goodsMsg, needBroadcast)
  local tempInfo = {}
  for i, goodsList in pairs(self.goodsShopDic) do
    if not shopType then
      for i, v in ipairs(goodsList) do
        if v.id == goodsMsg.id then
          shopType = v.shopType
          break
        end
      end
    else
      break
    end
  end
  tempInfo.id = goodsMsg.id
  tempInfo.startTime = goodsMsg.st
  tempInfo.boughtTimes = goodsMsg.bt
  if not self.goodsInfoDic[shopType] then
    self.goodsInfoDic[shopType] = {}
  end
  self.goodsInfoDic[shopType][tempInfo.id] = tempInfo
  self:UpdateRed(shopType)
  if needBroadcast then
    EventManager:GetInstance():Broadcast(EventId.UpdateOneCommonShopGoods, tempInfo.id)
  end
end

local function GetGoodsListByShopType(self, shopType)
  local retList = {}
  if self.goodsShopDic[shopType] then
    retList = self.goodsShopDic[shopType]
  end
  if shopType == CommonShopType.GiftShop then
    self:TryRefreshShopData(shopType)
  end
  return retList
end

local function GetGoodsConfByShopId(self, shopType, id)
  local retList = self:GetGoodsListByShopType(shopType)
  local goodsConf
  table.walk(retList, function(_, good)
    if good.id == id then
      goodsConf = good
    end
  end)
  return goodsConf
end

local function GetGoodsInfoById(self, shopType, id)
  if self.goodsInfoDic[shopType] and self.goodsInfoDic[shopType][id] then
    return self.goodsInfoDic[shopType][id]
  end
end

local function GetLimitShopRefreshTimes(self)
  return self.refreshCount
end

local function GetRedCount(self, shopType)
  if shopType then
    return self.redCountDic[shopType] or 0
  else
    local total = 0
    for i, v in pairs(self.redCountDic) do
      total = total + v
    end
    return total
  end
end

local function CheckIfModuleOpen(self)
  local isOpen = LuaEntry.DataConfig:CheckSwitch("shop_general_switch")
  return isOpen
end

local function CheckHeroResetIsFree(self)
  local k2 = LuaEntry.DataConfig:TryGetStr("free_heroes", "k2")
  local vec = string.split(k2, ";")
  local mainLv = DataCenter.BuildManager.MainLv
  if mainLv < toInt(vec[3]) then
    return false
  end
  local goodsList = self:GetGoodsListByShopType(CommonShopType.HeroReset)
  local price
  for i = 1, #goodsList do
    if goodsList[i].itemId ~= "" then
      local goodsInfo = self:GetGoodsInfoById(goodsList[i].shopType, goodsList[i].id)
      local isBuyT = 1
      if goodsInfo then
        isBuyT = goodsInfo.boughtTimes + 1
      end
      local str = string.split(goodsList[i].currency_num_s, ";")
      price = str[isBuyT] and str[isBuyT] or str[#str]
      break
    end
  end
  if price and tonumber(price) <= 0 then
    return true
  end
  return false
end

local function GetLimitShopNextRefreshTs(self)
  local todayRestTimeS = UITimeManager:GetInstance():GetResSecondsTo24()
  local cdT = todayRestTimeS % 28800
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime + cdT * 1000, cdT
end

local function OnClickBuyBtn(self, goodsConf, ProcessPurchaseCallback, limitCount)
  if goodsConf.shopType ~= CommonShopType.LimitTime then
    local param = {}
    param.limitCount = limitCount
    param.goodsInfo = {}
    if not string.IsNullOrEmpty(goodsConf.itemId) then
      local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(goodsConf.shopType, goodsConf.id)
      local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
      if 0 < goodsConf.maxTimes and boughtTimes >= goodsConf.maxTimes then
        UIUtil.ShowTipsId(129061)
        return
      end
      param.goodsInfo.rewardType = RewardType.GOODS
      param.goodsInfo.itemId = goodsConf.itemId
      param.goodsInfo.count = goodsConf.itemNum
      local limit = goodsConf.maxTimes - boughtTimes
      limit = math.max(limit, 0)
      if goodsConf.itemId == tostring(DataCenter.LWPVPArenaManager:GetChallengeItemId()) then
        limit = math.min(DataCenter.LWPVPArenaManager:GetChallengeLimit(), MaxLimit)
      end
      param.goodsInfo.limitCount = limit == 0 and MaxLimit or limit
      param.goodsInfo.eachPrice = goodsConf.costNum
    else
      param.goodsInfo.rewardType = RewardType.HERO
      param.goodsInfo.itemId = goodsConf.hero
      param.goodsInfo.count = goodsConf.itemNum
    end
    param.consumeInfo = {}
    param.consumeInfo.currencyType = goodsConf.currencyType
    param.consumeInfo.currencyId = goodsConf.currencyId
    
    function param.callback(buyCount)
      ProcessPurchaseCallback(buyCount)
    end
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuy, {anim = true}, param)
  else
    ProcessPurchaseCallback(1)
  end
end

local function CheckCostEnough(self, goodsConf, showTip)
  if goodsConf == nil then
    return true
  end
  if goodsConf.currencyType == ResourceType.AlliancePoint then
    local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if baseData ~= nil then
      return goodsConf.costNum <= baseData.accPoint
    end
    return true
  end
  if goodsConf.currencyType == RewardType.DragonWorldPoint then
    local totalScore = LuaEntry.Resource.honorScore
    if totalScore ~= nil then
      return totalScore >= goodsConf.costNum
    end
    return true
  end
  local resType = RewardToResType[goodsConf.currencyType]
  if resType and DataCenter.ResourceManager:GetResourceIconByType(resType) then
    if resType == ResourceType.Gold then
      if LuaEntry.Player.gold < goodsConf.costNum then
        if showTip then
          GoToUtil.GotoPayTips(goodsConf.costNum)
        end
        return false
      end
    else
      local cnt = LuaEntry.Resource:GetCntByResType(resType)
      if cnt < goodsConf.costNum then
        if showTip then
          local lackTab = {}
          local param = {}
          param.type = ResLackType.Res
          param.resType = resType
          param.targetNum = goodsConf.costNum
          table.insert(lackTab, param)
          GoToResLack.GoToItemResLackList(lackTab)
        end
        return false
      end
    end
  else
    local curNum = DataCenter.ItemData:GetItemCount(goodsConf.currencyId)
    if curNum < goodsConf.costNum then
      if showTip then
        UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
      end
      return false
    end
  end
  return true
end

function CommonShopManager:Buy(shopId, shopType, callback, notEnoughCallBack)
  local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(shopType, shopId)
  if goodsConf == nil then
    return
  end
  if goodsConf.GetInconsistentConditions then
    local inconsistentConditions = goodsConf:GetInconsistentConditions()
    if not table.IsNullOrEmpty(inconsistentConditions) then
      return
    end
  end
  local param = {}
  param.goodsInfo = {}
  if not string.IsNullOrEmpty(goodsConf.itemId) or not string.IsNullOrEmpty(goodsConf.resourceitem_id) then
    local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(goodsConf.shopType, goodsConf.id)
    local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
    if 0 < goodsConf.maxTimes and boughtTimes >= goodsConf.maxTimes then
      UIUtil.ShowTipsId(129061)
      return
    end
    if not string.IsNullOrEmpty(goodsConf.itemId) then
      param.goodsInfo.rewardType = RewardType.GOODS
      param.goodsInfo.itemId = goodsConf.itemId
    elseif not string.IsNullOrEmpty(goodsConf.resourceitem_id) then
      param.goodsInfo.rewardType = RewardType.RESOURCE_ITEM
      param.goodsInfo.itemId = goodsConf.resourceitem_id
    end
    param.goodsInfo.count = goodsConf.itemNum
    local limit = goodsConf.maxTimes - boughtTimes
    limit = math.max(limit, 0)
    param.goodsInfo.limitCount = limit == 0 and MaxLimit or limit
    param.goodsInfo.eachPrice = goodsConf.costNum
  else
    param.goodsInfo.rewardType = RewardType.HERO
    param.goodsInfo.itemId = goodsConf.hero
    param.goodsInfo.count = goodsConf.itemNum
  end
  param.consumeInfo = {}
  param.consumeInfo.currencyType = goodsConf.currencyType
  param.consumeInfo.currencyId = goodsConf.currencyId
  param.callback = callback
  param.shopType = shopType
  param.limitCount = self:GetDefaultSelectCount(param, shopType)
  param.notEnoughCallBack = notEnoughCallBack
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuy, {anim = true}, param)
end

function CommonShopManager.CanShowAllianceShop()
  return LuaEntry.Player:IsInAlliance()
end

function CommonShopManager.CanShowDecorationShop()
  return LuaEntry.DataConfig:CheckSwitch("decorationshop")
end

function CommonShopManager.GetAllianceShopScore()
  local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if baseData ~= nil then
    return baseData.accPoint
  end
  return 0
end

function CommonShopManager:SetShopGoodsNum(msg)
  for k, v in pairs(msg.num_info) do
    local type = v.type
    local num = v.num
    self.shopGoodsNumDic[type] = num
  end
end

function CommonShopManager:GetShopGoodsNum(shopType)
  local defaultNum = 0
  local num = defaultNum
  if self.shopGoodsNumDic[shopType] then
    num = self.shopGoodsNumDic[shopType]
  end
  return num
end

function CommonShopManager:GetDecorationShopItemNum()
  local decorationItemId = "654122"
  return DataCenter.ItemData:GetItemCount(decorationItemId)
end

function CommonShopManager:GetGiftVoucherShopItemNum()
  local itemId = DataCenter.GiftVoucherShopBuildBubbleDataManager:GetCostItemId()
  return DataCenter.ItemData:GetItemCount(itemId)
end

function CommonShopManager:GetDecorationShopName(shopType)
  if not self.decorationShopDic or not self.decorationShopDic[shopType] then
    return "store_name_5"
  end
  return self.decorationShopDic[shopType].shopName
end

function CommonShopManager:OpenDirectPurchaseView(shopType)
  local param = {}
  if shopType == CommonShopType.DecorationShop then
    param.OpenType = DirectPurchaseType.DecorationShopMainCity
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationShopDirectPurchase, {anim = true}, param)
end

function CommonShopManager:RequestDecorationShopInfo()
  SFSNetwork.SendMessage(MsgDefines.DecorationShopGiftRequestInfo)
end

function CommonShopManager:IsSaleInDecorationShop(decorationId, shopType)
  if not self.goodsShopDic[shopType] then
    return false
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
  local gain = template.gainMethod
  local result = false
  for k, v in pairs(gain) do
    local goodsList = self.goodsShopDic[shopType]
    for m, n in pairs(goodsList) do
      if n and n.itemId and tonumber(n.itemId) == v.id then
        result = true
        break
      end
    end
  end
  return result
end

function CommonShopManager:GetDecorationShopInfo(shopType)
  if not self.decorationShopDic then
    return nil
  end
  return self.decorationShopDic[shopType]
end

function CommonShopManager:IfShopItemNew(itemId)
  return Setting:GetPrivateInt(SettingKeys.Show_DecorationShop_NEW .. itemId, 0) == 0
end

function CommonShopManager:SetShopItemNotNew(itemId)
  if not itemId then
    return
  end
  Setting:SetPrivateInt(SettingKeys.Show_DecorationShop_NEW .. itemId, 1)
end

function CommonShopManager:IfHaveNewItemInDecorationShop()
  local list = self:GetGoodsListByShopType(CommonShopType.DecorationShop)
  local result = false
  for k, v in pairs(list) do
    if v and v.itemId and self:IfShopItemNew(v.itemId) then
      result = true
      break
    end
  end
  return result
end

function CommonShopManager:UpdateDecorationShopItemNew(curShopType)
  if not curShopType then
    return
  end
  local shopInfo = DataCenter.CommonShopManager:GetGoodsListByShopType(curShopType)
  if not shopInfo then
    return
  end
  for k, v in pairs(shopInfo) do
    if v and v.itemId and self:IfShopItemNew(v.itemId) then
      self:SetShopItemNotNew(v.itemId)
    end
  end
end

function CommonShopManager:SendGetHonorShopItemsCacheMessage(curShopIdList)
  SFSNetwork.SendMessage(MsgDefines.UserShopHonorCacheUpdate, curShopIdList)
end

function CommonShopManager:GetHonorShopChangedIdListForFirstTime()
  local str = LuaEntry.DataConfig:TryGetStr("honor_shop_update", "k1", "")
  if not string.IsNullOrEmpty(str) then
    local res = {}
    local vec = string.split(str, ";")
    for _, v in ipairs(vec) do
      local shopId = tonumber(v)
      local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.HonorShop, shopId)
      if goodsConf ~= nil then
        table.insert(res, shopId)
      end
    end
    return res
  end
end

function CommonShopManager:OnGetHonorShopItemsCacheMessage(msg)
  local changeShopIdList = {}
  local previousShopIdList = {}
  if msg and not string.IsNullOrEmpty(msg.oldCacheIdSet) then
    local splitStr = string.split(msg.oldCacheIdSet, ";")
    for _, v in ipairs(splitStr) do
      previousShopIdList[tonumber(v)] = true
    end
  end
  if table.IsNullOrEmpty(previousShopIdList) then
    changeShopIdList = self:GetHonorShopChangedIdListForFirstTime()
  else
    local curGoodsList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.HonorShop)
    if not table.IsNullOrEmpty(curGoodsList) then
      for _, v in ipairs(curGoodsList) do
        if not previousShopIdList[v.id] then
          table.insert(changeShopIdList, v.id)
        end
      end
    end
  end
  if not table.IsNullOrEmpty(changeShopIdList) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIRewardChangePreview_HonorShopView, {anim = true}, changeShopIdList)
  end
end

function CommonShopManager:IsAutoSelectMaxCountFuncOpen(shopType)
  if not LuaEntry.DataConfig:CheckSwitch("shop_smart_max_switch") then
    return false
  end
  shopType = checknumber(shopType)
  if not FunctionSeasonUtil.IsFuncOpen(FunctionSeasonUtil.FuncType.ShopAutoMax) then
    return false
  end
  local shopTypeConfig = LuaEntry.DataConfig:TryGetStr("shop_smart_max_buy", "k2", "")
  local shopTypeArr = string.string2array_num_oneSep(shopTypeConfig, ";")
  if not table.hasvalue(shopTypeArr, shopType) then
    return false
  end
  return true
end

function CommonShopManager:SetAutoSelectMaxCountTag(shopType, isOn)
  shopType = checknumber(shopType)
  local key = string.format("%s_%s", SettingKeys.SHOP_AUTO_SELECT_MAX_COUNT, shopType)
  CommonUtil.PlayerPrefsSetBool(key, isOn)
end

function CommonShopManager:GetAutoSelectMaxCountTag(shopType)
  shopType = checknumber(shopType)
  if self:IsAutoSelectMaxCountFuncOpen(shopType) then
    local key = string.format("%s_%s", SettingKeys.SHOP_AUTO_SELECT_MAX_COUNT, shopType)
    return CommonUtil.PlayerPrefsGetBool(key, false)
  end
  return false
end

function CommonShopManager:GetDefaultSelectCount(param, shopType)
  if param == nil or param.goodsInfo == nil or param.consumeInfo == nil then
    return nil
  end
  if not self:GetAutoSelectMaxCountTag(shopType) then
    return nil
  end
  local limitCount = param.goodsInfo.limitCount
  local eachPrice = param.goodsInfo.eachPrice
  local resCount = 0
  local resType = RewardToResType[param.consumeInfo.currencyType]
  if resType and DataCenter.ResourceManager:GetResourceIconByType(resType) then
    if resType == ResourceType.Gold then
      resCount = LuaEntry.Player.gold
    else
      resCount = LuaEntry.Resource:GetCntByResType(resType)
    end
  else
    local curNum = DataCenter.ItemData:GetItemCount(param.consumeInfo.currencyId)
    resCount = curNum
  end
  local maxNum = math.floor(resCount / eachPrice)
  limitCount = math.min(limitCount, maxNum)
  return 0 < limitCount and limitCount or nil
end

function CommonShopManager:GetNoQualificationTips(configData)
  if configData == nil then
    return ""
  end
  local buyConditionStr = configData.buy_condition
  if string.IsNullOrEmpty(buyConditionStr) then
    return ""
  end
  local buyConditionStrList = string.split(buyConditionStr, ";")
  local buyConditionType = tonumber(buyConditionStrList[1]) or 0
  local tips = Localization:GetString("shop_preview_type_none")
  if buyConditionType == 1 then
    tips = Localization:GetString("shop_preview_type_1", buyConditionStrList[2])
  elseif buyConditionType == 2 then
    tips = Localization:GetString("shop_preview_type_2", tonumber(buyConditionStrList[2]) + 1)
  elseif buyConditionType == 3 then
    tips = Localization:GetString("shop_preview_type_3", buyConditionStrList[2])
  elseif buyConditionType == 4 then
    tips = Localization:GetString("shop_preview_type_4", buyConditionStrList[2], buyConditionStrList[3])
  elseif buyConditionType == 5 then
    local timeStr = buyConditionStrList[2]
    local dateStr = timeStr:match("^(%d+%-%d+%-%d+)")
    tips = Localization:GetString("shop_preview_type_5", dateStr)
  elseif buyConditionType == 6 then
    tips = Localization:GetString("shop_preview_type_6", buyConditionStrList[2], buyConditionStrList[3])
  end
  return tips
end

function CommonShopManager:TryRefreshShopData(shopType)
  if shopType == nil then
    return
  end
  if self.shopDataDirtyDic[shopType] then
    self.shopDataDirtyDic[shopType] = nil
    SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, shopType)
  end
end

function CommonShopManager:SetShopDataDirty(shopType)
  if shopType == nil then
    return
  end
  self.shopDataDirtyDic[shopType] = true
end

CommonShopManager.__init = __init
CommonShopManager.__delete = __delete
CommonShopManager.AddListener = AddListener
CommonShopManager.RemoveListener = RemoveListener
CommonShopManager.UpdateOneShopInfo = UpdateOneShopInfo
CommonShopManager.UpdateOneGoodsInfo = UpdateOneGoodsInfo
CommonShopManager.GetGoodsListByShopType = GetGoodsListByShopType
CommonShopManager.GetGoodsInfoById = GetGoodsInfoById
CommonShopManager.CheckIfModuleOpen = CheckIfModuleOpen
CommonShopManager.GetLimitShopRefreshTimes = GetLimitShopRefreshTimes
CommonShopManager.InitAll = InitAll
CommonShopManager.UpdateRed = UpdateRed
CommonShopManager.GetRedCount = GetRedCount
CommonShopManager.CheckHeroResetIsFree = CheckHeroResetIsFree
CommonShopManager.GetLimitShopNextRefreshTs = GetLimitShopNextRefreshTs
CommonShopManager.AddUpdateTimer = AddUpdateTimer
CommonShopManager.OnClickBuyBtn = OnClickBuyBtn
CommonShopManager.CheckCostEnough = CheckCostEnough
CommonShopManager.GetGoodsConfByShopId = GetGoodsConfByShopId
CommonShopManager.InitData = InitData
CommonShopManager.UpdateDecorationShopMessage = UpdateDecorationShopMessage
return CommonShopManager
