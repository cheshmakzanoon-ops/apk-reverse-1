local GiftPackInfoBase = BaseClass("GiftPackInfoBase")
local M = GiftPackInfoBase
local Timer = CS.GameEntry.Timer
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local CommonUtils = CS.CommonUtils

function M:__init()
  self._serverData = nil
  self._showTypeParsed = false
  self._weekPopupParsed = false
  self._chooseIndexParsed = false
  self._combDescParsed = false
  self._combDescs = nil
  self._packageDiscountTips = {}
  self._chooseIndex = -1
  self._tableData = nil
end

function M:UpdateWithLocalData(giftPackId)
  local giftPackTemplate = DataCenter.GiftPackTemplateManager:GetGiftPackInfo(giftPackId)
  if giftPackTemplate then
    self._tableData = giftPackTemplate
    return true
  end
  return false
end

function M:update(data)
  if data == nil then
    logErrorWithTag("GiftPackInfoBase", "Server data null")
  end
  self._serverData = data
  if (data.isWeeklyFreePackage == nil or data.isWeeklyFreePackage == false) and data.simple ~= nil and data.simple == true then
    if not self:UpdateWithLocalData(self:getID()) then
      self._tableData = data
    end
  else
    self._tableData = data
  end
  self._showTypeParsed = false
  self._weekPopupParsed = false
  self._chooseIndexParsed = false
  self._packageDiscountTips = nil
  self._combDescParsed = false
  self._combDescs = nil
  self._chooseIndex = -1
end

function M:getID()
  return self._serverData and self._serverData.id or "-1"
end

function M:getType()
  if self._type == nil then
    self._type = self._tableData and tonumber(self._tableData.type) or GiftPackType.Unknown
  end
  return self._type
end

function M:getName()
  return self._tableData and self._tableData.name or ""
end

function M:getSubName()
  return self._tableData and self._tableData.sub_name or ""
end

function M:GetSubNameTxt()
  local desc = self:getSubName()
  if string.contains(desc, "|") then
    local arr = string.split(desc, "|")
    local paramArray = string.split(arr[2], "#")
    local args = {}
    for _, p in ipairs(paramArray) do
      if string.startswith(p, "$") then
        table.insert(args, Localization:GetString(string.sub(p, 2)))
      else
        table.insert(args, p)
      end
    end
    return Localization:GetString(arr[1], table.unpack(args))
  else
    return Localization:GetString(desc)
  end
end

function M:hasSubName()
  return not string.IsNullOrEmpty(self:getSubName())
end

function M:getNameText()
  local name = self:getName()
  if string.contains(name, "|") then
    local arr = string.split(name, "|")
    return Localization:GetString(arr[1], arr[2])
  else
    return Localization:GetString(name)
  end
end

function M:getDescription()
  return self._tableData and self._tableData.description or ""
end

function M:getPopupImageMini()
  return self._tableData and self._tableData.popup_image_mini or ""
end

function M:GetPopupImageMiniBand()
  return self._tableData and self._tableData.popup_image_mini_band or ""
end

function M:GetDiscountTips()
  if self._tableData and self._tableData.image_show then
    local discountTb = string.split(self._tableData.image_show, "|")
    local retTb = {}
    for i, v in ipairs(discountTb) do
      local type_dialog = string.split(v, ";")
      local tempK = tonumber(type_dialog[1])
      if tempK == 4 then
        local arrParams = string.split(type_dialog[2], "@")
        local arrItems = {}
        for m, n in ipairs(arrParams) do
          local itemParam = string.split(n, "_")
          local pos = tonumber(itemParam[1])
          local temp = {}
          temp.itemId = itemParam[2]
          temp.count = itemParam[3]
          temp.rewardType = RewardType.GOODS
          arrItems[pos] = temp
        end
        retTb[tempK] = arrItems
      else
        retTb[tempK] = ""
        if #type_dialog == 2 then
          local dialog_param = string.split(type_dialog[2], "@")
          if #dialog_param == 2 then
            local params = string.split(dialog_param[2], "_")
            retTb[tempK] = Localization:GetString(dialog_param[1], table.unpack(params))
          else
            retTb[tempK] = Localization:GetString(dialog_param[1])
          end
        end
      end
    end
    return retTb
  end
end

function M:getPopupImageB()
  return self._tableData and self._tableData.popup_image_b or ""
end

function M:getPrefabName()
  return self._tableData and self._tableData.prefab_name or ""
end

function M:getLackPic()
  return self._tableData and self._tableData.lack_pic or ""
end

function M:getPopupImageH()
  return self._tableData and self._tableData.popup_image_h or ""
end

function M:getDescText()
  self:tryParseCombDesc()
  local index = self:getChooseIndex()
  if index > #self._combDescs then
    index = 1
  end
  local desc = self._combDescs[index]
  if string.contains(desc, "|") then
    local arr = string.split(desc, "|")
    local paramArray = string.split(arr[2], "#")
    local args = {}
    for _, p in ipairs(paramArray) do
      if string.startswith(p, "$") then
        table.insert(args, Localization:GetString(string.sub(p, 2)))
      else
        table.insert(args, p)
      end
    end
    return Localization:GetString(arr[1], table.unpack(args))
  else
    return Localization:GetString(desc)
  end
end

function M:tryParseCombDesc()
  if self._combDescParsed then
    return
  end
  self._combDescParsed = true
  local desc = self:getDescription()
  local arr = string.split(desc, "@")
  self._combDescs = {}
  for _, v in ipairs(arr) do
    table.insert(self._combDescs, v)
  end
end

function M:getUIKey()
  return self._tableData and self._tableData.popup_image or ""
end

function M:getQuality()
  return self._tableData and self._tableData.image_mini_quality or 0
end

function M:getMD5()
  return self._serverData and self._serverData.md5_v3 or ""
end

function M:getTimeType()
  return self._tableData and self._tableData.time_type or -1
end

function M:getStartTime()
  return self._serverData and self._serverData.start or -1
end

function M:getEndTime()
  return self._serverData and self._serverData["end"] or -1
end

function M:getCountdown()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local startTime = self:getStartTime()
  local endTime = self:getEndTime()
  local timeType = self:getTimeType()
  if timeType == 1 then
    return endTime - serverTime
  elseif timeType == 2 or timeType == 6 then
    if serverTime > endTime or serverTime < startTime then
      return -1
    end
    local duration = self:getParaTime() * 1000
    if duration <= 0 then
      return -1
    end
    local i = 1
    ::lbl_35::
    do
      local tEndTime = startTime + i * duration
      if serverTime < tEndTime then
        if endTime < tEndTime then
          tEndTime = endTime
        end
        return tEndTime - serverTime
      end
      i = i + 1
      if 100000 < i then
        goto lbl_48
      end
    end
    goto lbl_35
    ::lbl_48::
  elseif timeType == 3 then
    return endTime - serverTime
  elseif timeType == 7 then
    return endTime - serverTime
  else
    return endTime - serverTime
  end
end

function M:getParaTime()
  return self._tableData and self._tableData.time or 0
end

function M:isTimeValid()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime >= self:getStartTime() and serverTime <= self:getEndTime() and self:getCountdown() > 0
end

function M:isServerTimeValid()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime >= self:getStartTime() and serverTime <= self:getEndTime()
end

function M:getConditionPopup()
  return self._serverData and self._serverData["condition-popup"] or 0
end

function M:getPopup()
  local weekDay = Timer:GetServerWeekDay()
  local result
  if self:hasWeekPopup(weekDay) then
    result = self:getWeekPopup(weekDay)
  else
    if self._popup == nil then
      self._popup = self._tableData and tonumber(self._tableData.popup) or 0
    end
    result = self._popup
  end
  return result
end

function M:getWeekPopup(weekDay)
  self:tryParseWeekPopup()
  local popup = self._weekPopupArr[weekDay]
  if popup ~= nil then
    return popup
  else
    return -1
  end
end

function M:hasWeekPopup(weekDay)
  self:tryParseWeekPopup()
  local popup = self._weekPopupArr[weekDay]
  if popup ~= nil then
    return true
  else
    return false
  end
end

function M:tryParseWeekPopup()
  if self._weekPopupParsed then
    return
  end
  self._weekPopupParsed = true
  self._weekPopupArr = {}
  local str = self._tableData.popup_week
  if string.IsNullOrEmpty(str) then
    return
  end
  local arr = string.split(str, "|")
  for _, v in ipairs(arr) do
    if not string.IsNullOrEmpty(v) then
      local arr1 = string.split(v, ";")
      if #arr1 ~= 2 then
        printError("Week popup error")
      else
        self:onParseWeekPopupItem(tonumber(arr1[1]), tonumber(arr1[2]))
      end
    end
  end
end

function M:onParseWeekPopupItem(k, v)
  self._weekPopupArr[k] = v
end

function M:isBought()
  return self._serverData and self._serverData.bought
end

function M:getBuyTimes()
  return self._tableData and self._tableData.buy_times or 0
end

function M:getDiamond()
  return self._tableData and self._tableData.gold_doller or 0
end

function M:getGoldBrick()
  return self._tableData and self._tableData.gold_brick_doller or 0
end

function M:getCredit()
  return DataCenter.CreditTemplateManager:GetCreditValue(self._tableData and self._tableData.product_id_google or "")
end

function M:getPrice()
  return self._tableData and self._tableData.dollar or 0
end

function M:getPriceText()
  if self.priceTxt == nil then
    local productId = self:getProductID()
    local price = self:getPrice()
    local priceTxt = DataCenter.PayManager:GetLocalCurrency(productId)
    if string.IsNullOrEmpty(priceTxt) then
      priceTxt = DataCenter.PayManager:GetDollarText(price, productId)
    else
      self.priceTxt = priceTxt
    end
    return priceTxt
  end
  return self.priceTxt
end

function M:getOriginalPrice()
  return self._tableData and self._tableData.price or 0
end

function M:getOriginalPriceText()
  if self.originPriceText == nil then
    local originPrice = self:getOriginalPrice()
    self.originPriceText = DataCenter.PayManager:GetDollarText(originPrice, nil, true)
  end
  return self.originPriceText
end

function M:getPercent()
  return self._tableData and self._tableData.percent
end

function M:hasPercent()
  return self:getPercent() ~= nil
end

function M:getIsShow()
  return self._tableData and self._tableData.is_show
end

function M:isPremiumPack()
  return self:getIsShow() == nil or self:getIsShow() == "0" or self:getIsShow() == "4"
end

function M:isStorePack()
  return self:getIsShow() == "2"
end

function M:IsWeeklyPackage()
  local isShow = self:getIsShow()
  return isShow == "4"
end

function M:IsWeeklyPackageNew()
  local isShow = self:getIsShow()
  return isShow == "5"
end

function M:IsHeroMedalPackage()
  return false
end

function M:isRobotPack()
  local lineData = self:getRechargeLineData()
  return lineData ~= nil and lineData.type == WelfareTagType.RobotPack
end

function M:isPiggyBankPack()
  local lineData = self:getRechargeLineData()
  return lineData ~= nil and lineData.type == WelfareTagType.PiggyBank
end

function M:isEnergyBankPack()
  local lineData = self:getRechargeLineData()
  return lineData ~= nil and lineData.type == WelfareTagType.EnergyBank
end

function M:isGrowthPlanPack()
  local lineData = self:getRechargeLineData()
  return lineData ~= nil and lineData.type == WelfareTagType.GrowthPlan
end

function M:isScrollPack()
  local lineData = self:getRechargeLineData()
  return lineData ~= nil and lineData.type == WelfareTagType.ScrollPack
end

function M:isPvePack()
  local lineData = self:getRechargeLineData()
  return lineData ~= nil and lineData.type == WelfareTagType.PvePack
end

function M:isFirstChargePack()
  local lineData = self:getRechargeLineData()
  return lineData ~= nil and lineData.type == WelfareTagType.FirstCharge
end

function M:isCreditPack()
  local type = self:getType()
  return type == GiftPackType.CreditPackage
end

function M:isRechargeId(rechargeId)
  if rechargeId == nil then
    return false
  end
  local lineData = self:getRechargeLineData()
  return lineData ~= nil and lineData.id == rechargeId
end

function M:isHeroMonthCardPack()
  local lineData = self:getRechargeLineData()
  return lineData ~= nil and lineData.type == WelfareTagType.HeroMonthCardNew
end

function M:isLWQueueWeekCardPack()
  local lineData = self:getRechargeLineData()
  return lineData ~= nil and lineData.type == WelfareTagType.BuildQueueWeekCard
end

function M:isSpecialPackCanInPop()
  if self:getID() == "40001" then
    return CS.LF.LuaInterfaceCommon.IsVipUnlock(1) and self:getIsShow() == "1"
  end
  return self:getIsShow() == "1"
end

function M:setWillInPop(inPop)
  self.willInPop = inPop
end

function M:getInPop()
  return self.willInPop
end

function M:isPremiumPackCanInPop()
  return self:getIsShow() ~= "4"
end

function M:getProductID()
  if CS.SDKManager.IS_UNITY_ANDROID() or CommonUtils.IsDebug() then
    return self._tableData and self._tableData.product_id_google
  elseif CS.SDKManager.IS_UNITY_IPHONE() then
    return self._tableData and self._tableData.product_id_ios
  end
end

function M:isFree()
  return self:getProductID() == "free"
end

function M:canGet()
  return self:getHasGetCount() < self:getBuyTimes()
end

function M:getHasGetCount()
  return self._serverData and self._serverData.buys or 0
end

function M:getGroup()
  return self._tableData and self._tableData.group or ""
end

function M:getGiftData()
  return self._tableData and self._tableData.giftData or ""
end

function M:isContainShowType(mainType, subType)
  self:tryParseShowType()
  if string.IsNullOrEmpty(mainType) and string.IsNullOrEmpty(subType) then
    return false
  end
  if string.IsNullOrEmpty(mainType) then
    return false
  end
  if string.IsNullOrEmpty(subType) then
    return self._showTypeArr and self._showTypeArr[mainType]
  elseif self._showTypeArr and self._showTypeArr[mainType] then
    local resTypes = string.split(self._showTypeArr[mainType], ",")
    for i, v in ipairs(resTypes) do
      if v == subType then
        return true
      end
    end
  end
  return false
end

function M:tryParseShowType()
  if self._showTypeParsed then
    return
  end
  self._showTypeArr = {}
  self._showTypeParsed = true
  local showType = self._tableData and self._tableData.show_type or ""
  if string.IsNullOrEmpty(showType) then
    return
  end
  local arr = string.split(showType, "|")
  for _, v in ipairs(arr) do
    if not string.IsNullOrEmpty(v) then
      local arr1 = string.split(v, ";")
      if #arr1 == 2 then
        self:onParseShowTypeItem(arr1[1], arr1[2])
      end
    end
  end
end

function M:onParseShowTypeItem(k, v)
  self._showTypeArr[k] = v
end

function M:getShowType(type)
  if string.IsNullOrEmpty(type) then
    return nil
  end
  self:tryParseShowType()
  if self._showTypeArr == nil then
    return nil
  end
  return self._showTypeArr[type]
end

function M:setTagID(value)
  self._tagID = value
end

function M:getTagID()
  return self._tagID
end

function M:getItemsStr()
  return self._tableData and self._tableData.item or ""
end

function M:getItem2Str()
  return self._serverData and self._serverData.item2 or ""
end

function M:getHeroesStr()
  return self._tableData and self._tableData.hero or ""
end

function M:getItemUse()
  return self._tableData and self._tableData.item_use or ""
end

function M:getResourceStr()
  return self._tableData and self._tableData.resource or ""
end

function M:getAllianceGift()
  return self._tableData and self._tableData.giftData or ""
end

function M:IsBestBuy()
  if self._tableData and self._tableData.best_buy then
    return self._tableData.best_buy == 1
  end
  return false
end

function M:GetBuyType()
  if self._tableData then
    return self._tableData.buy_type or 0
  end
end

function M:GetResourceBuyCostTypeAndNum()
  if not self._tableData or not self._tableData.buy_type_cost then
    return nil, 0
  end
  if not self._tableDataBuyTypeCostArray then
    self._tableDataBuyTypeCostArray = string.split(self._tableData.buy_type_cost, ";")
  end
  return tonumber(self._tableDataBuyTypeCostArray[2]), tonumber(self._tableDataBuyTypeCostArray[3])
end

function M:setChooseIndex(value)
  self._chooseIndex = value
end

function M:getChooseIndex()
  self:tryGetChooseIndexFromLocal()
  return self._chooseIndex
end

function M:getRechargePoint()
  local isShow, actIds = DataCenter.CumulativeRechargeManager:CheckIsShow()
  if isShow then
    local point = self._tableData and self._tableData.recharge_point or 0
    return point, actIds
  end
  return 0, nil
end

function M:saveChooseInfo()
  Setting:SetInt("GIFT_PACK_COMBINE" .. self:getID(), self:getChooseIndex())
  Setting:SetInt("GIFT_PACK_COMBINE_CHOOSE" .. self:getID(), 1)
end

function M:tryGetChooseIndexFromLocal()
  if self._chooseIndex > 0 then
    self._chooseIndexParsed = true
    return
  end
  if self._chooseIndexParsed then
    return
  end
  self._chooseIndex = Setting:GetInt("GIFT_PACK_COMBINE" .. self:getID(), 1)
  self._chooseIndexParsed = true
end

function M:dispose()
  self._tableDataBuyTypeCostArray = nil
  self._serverData = nil
  self._showTypeParsed = false
  self._showTypeArr = nil
  self._weekPopupParsed = false
  self._weekPopupArr = nil
  self._chooseIndexParsed = false
  self._combDescParsed = false
  self._combDescs = nil
  self._chooseIndex = -1
end

function M:toJson(...)
  local rapidjson = require("Common.dkjson")
  if self._tableData.item_combine ~= nil then
    if self._chooseIndex == nil or self._chooseIndex < 0 then
      self._chooseIndex = 1
    end
    self._serverData.chooseItem = string.split(self._tableData.item_combine, "@")[self._chooseIndex]
    self._serverData.chooseHero = string.split(self._tableData.hero_combine, "@")[self._chooseIndex]
  end
  if self:isFree() then
    self._serverData.isFree = true
  end
  local jsonData = rapidjson.encode(self._serverData)
  return jsonData
end

function M:toJsonForGiftBar(...)
  local info = {}
  info.name = self:getNameText()
  info.desc = self:getDescText()
  info.countDown = self:getCountdown()
  info.priceText = self:getPriceText()
  info.id = self:getID()
  info.giftPackBarUI = self:getPopupImageMini()
  info.diamond = self:getDiamond()
  local rapidjson = require("Common.dkjson")
  local jsonData = rapidjson.encode(info)
  return jsonData
end

function M:getRechargeLineData()
  local tempId = self:getID()
  local line = GiftPackageData.GetRechargeDataByPackageId(tempId)
  return line
end

function M:getGoldBrickId()
  return self._serverData and self._serverData.goldbrick or ""
end

function M:getCostGoldBrick()
  if self.costGoldBrick == nil then
    local goldBrickId = self:getGoldBrickId()
    self.costGoldBrick = DataCenter.GoldBrickTemplateManager:GetCostGoldBrick(goldBrickId)
  end
  return self.costGoldBrick
end

function M:getBuyCondition()
  if self._tableData and self._tableData.common_buy_condition then
    return self._tableData.common_buy_condition
  end
  return nil
end

function M:getAlertCondition()
  if self._tableData and self._tableData.alert_condition then
    return self._tableData.alert_condition
  end
  return nil
end

function M:getCanRefund()
  if self._serverData and self._serverData.can_refund then
    return tonumber(self._serverData.can_refund) == 1
  end
  return false
end

function M:getRewardChangeGroup()
  if self._tableData and self._tableData.preview_info_group then
    return tonumber(self._tableData.preview_info_group)
  end
end

return M
