local TradeCenterDataManager = BaseClass("TradeCenterDataManager")

local function __init(self)
  self.tradeCenterData = nil
  self.IsCallState = false
end

local function __delete(self)
  self.tradeCenterData = nil
  self.IsCallState = nil
end

local function InitData(self, obj)
  if obj.resourceExchangeInfo ~= nil then
    local data = obj.resourceExchangeInfo
    self:UpdateData(data)
  end
end

local function UpdateData(self, message)
  if message.isSuperPlane ~= nil then
    self.tradeCenterData = TradeCenterInfo.New()
    self.tradeCenterData:UpdateInfo(message)
  end
end

local function IsResMarketOpen(self)
  local ret = false
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if self.tradeCenterData ~= nil then
    ret = now >= self.tradeCenterData.resourceExchangeST and now < self.tradeCenterData.resourceExchangeET
  end
  return ret
end

local function HasLeftFlightToday(self)
  local ret = true
  if self.tradeCenterData ~= nil then
    ret = self.tradeCenterData.userItemTimes < self.tradeCenterData.maxUseItemTimes
  end
  return ret
end

local function GetCurrentCanGetMoney(self, curMap)
  local ret = 0
  table.walk(curMap, function(k, v)
    ret = ret + self:GetExchangeGoldByResType(k, v)
  end)
  return ret
end

local function GetExchangeGoldByResType(self, ...)
  local type, resAmount = ...
  local texRate = self:GetTotalTexRateByResType(type)
  local result = math.ceil(math.modf(resAmount * 1.0 / (1.0 + math.modf(texRate / 100, 0))))
  return result
end

local function GetTotalTexRateByResType(self, type)
  local baseTex = self:GetBaseTexRate()
  local exTex = self:GetExTexRateByResType(type)
  local effTex = LuaEntry.Effect:GetGameEffect(EffectDefine.TRADE_TEX_DECREASE_938)
  local endTex = baseTex + exTex - effTex
  if endTex < 0 then
    endTex = 0
  end
  return endTex
end

local function GetBaseTexRate(self)
  local baseTex = 0.0
  local info = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.FUN_BUILD_MARKET)
  if info ~= nil then
    local levelTemp = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(info.type, info.level)
    if levelTemp ~= nil and levelTemp.base_tax_rate > 0 then
      baseTex = levelTemp.base_tax_rate
    end
  end
  return baseTex
end

local function GetExTexRateByResType(self, type)
  local exTex = 0.0
  if self.tradeCenterData.isBaseRate ~= 1 then
    local itemUseTimes = self.tradeCenterData.callPlaneTimes
    if itemUseTimes ~= 0 then
      local bBrought = self:CheckHasBroughtStateByResType(type)
      local info = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(BuildingTypes.FUN_BUILD_MARKET)
      local levelTemp = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(info.type, info.level)
      if levelTemp ~= nil and levelTemp.item_tax_rate ~= nil and levelTemp.item_tax_rate ~= "" then
        local vec = string.split(levelTemp.item_tax_rate, "|")
        local index = itemUseTimes
        local para = ""
        if index <= #vec and 1 <= index then
          para = vec[index]
        elseif 0 < #vec then
          para = vec[#vec]
        end
        local vec1 = string.split(para, ";")
        if #vec1 == 2 then
          if bBrought then
            index = 2
          else
            index = 1
          end
          exTex = tonumber(vec1[index])
        end
      end
    end
  end
  return exTex
end

local function CheckHasBroughtStateByResType(self, resType)
  local ret = false
  local broughtParams = self.tradeCenterData.sellRecord
  if broughtParams ~= nil then
    local vec = string.split(broughtParams, ";")
    table.walk(vec, function(k, v)
      local subVec = string.split(v, ":")
      local transToClientType = tonumber(subVec[1])
      if #subVec == 2 and resType == transToClientType then
        ret = subVec[2] == "1"
      end
    end)
  end
  return ret
end

local function GetCurrentNeedMoney(self, curMap)
  local ret = 0
  table.walk(curMap, function(k, v)
    ret = ret + self:GetNeedMoneyByResType(tostring(k), v)
  end)
  return ret
end

local function GetNeedMoneyByResType(self, typeStr, count)
  local num = 0
  if self.tradeCenterData.curPrice[typeStr] ~= nil then
    num = count * self.tradeCenterData.curPrice[typeStr]
  end
  return num
end

local function GetLeftTotalMoney(self)
  return self.tradeCenterData.leftTotalMoney
end

local function GetCurrentMaxCanBuy(self)
  local resourceMax = {}
  local resStr = self.tradeCenterData.totalRes
  local list = string.split(resStr, "|")
  if 0 < #list then
    table.walk(list, function(k, v)
      local per_spl = string.split(v, ";")
      if #per_spl == 2 then
        local typeStr = per_spl[1]
        local tempType = tonumber(per_spl[1])
        local tempValue = tonumber(per_spl[2])
        local tempYiGou = 0
        if self.tradeCenterData.buyInfo[typeStr] ~= nil then
          tempYiGou = self.tradeCenterData.buyInfo[typeStr]
        end
        local rest = tempValue - tempYiGou
        resourceMax[tempType] = rest
      end
    end)
  end
  return resourceMax
end

TradeCenterDataManager.__init = __init
TradeCenterDataManager.__delete = __delete
TradeCenterDataManager.InitData = InitData
TradeCenterDataManager.UpdateData = UpdateData
TradeCenterDataManager.IsResMarketOpen = IsResMarketOpen
TradeCenterDataManager.HasLeftFlightToday = HasLeftFlightToday
TradeCenterDataManager.GetTotalTexRateByResType = GetTotalTexRateByResType
TradeCenterDataManager.GetBaseTexRate = GetBaseTexRate
TradeCenterDataManager.GetExTexRateByResType = GetExTexRateByResType
TradeCenterDataManager.CheckHasBroughtStateByResType = CheckHasBroughtStateByResType
TradeCenterDataManager.GetExchangeGoldByResType = GetExchangeGoldByResType
TradeCenterDataManager.GetCurrentCanGetMoney = GetCurrentCanGetMoney
TradeCenterDataManager.GetLeftTotalMoney = GetLeftTotalMoney
TradeCenterDataManager.GetCurrentMaxCanBuy = GetCurrentMaxCanBuy
TradeCenterDataManager.GetCurrentNeedMoney = GetCurrentNeedMoney
TradeCenterDataManager.GetNeedMoneyByResType = GetNeedMoneyByResType
return TradeCenterDataManager
