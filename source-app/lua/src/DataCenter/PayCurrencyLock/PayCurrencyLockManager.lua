local PayCurrencyLockManager = BaseClass("PayCurrencyLockManager")
local PayCurrencyLockData = require("DataCenter.PayCurrencyLock.PayCurrencyLockData")
local PayCurrencyLockTemplate = require("DataCenter.PayCurrencyLock.PayCurrencyLockTemplate")

function PayCurrencyLockManager:__init()
  self.payCurrencyLockData = nil
  self.payCurrencyConfigDic = {}
end

function PayCurrencyLockManager:__delete()
  self.payCurrencyLockData = nil
  self.payCurrencyConfigDic = nil
end

function PayCurrencyLockManager:InitData(message)
  self.payCurrencyLockData = nil
  local payCurrencyLockInfo = message.payCurrencyLock
  if not payCurrencyLockInfo then
    return
  end
  self.payCurrencyLockData = PayCurrencyLockData.New()
  self.payCurrencyLockData:ParseLockData(payCurrencyLockInfo)
end

function PayCurrencyLockManager:UpdateLockInfo(msg)
  if not msg then
    Logger.LogError("PayCurrencyLockManager:UpdateLockInfo msg is nil")
    return
  end
  local lockInfo = {payCurrencyLock = msg}
  self:InitData(lockInfo)
end

function PayCurrencyLockManager:CheckIfLock()
  if Config.IsPC() then
    return
  end
  local isLock = false
  if not self.payCurrencyLockData then
    return false
  end
  if self.payCurrencyLockData.isInWhiteList then
    local logStr = self:GetLog()
    Logger.LogInfo("PayCurrencyLockManager:CheckIfLock in white list not lock. " .. logStr)
    return isLock
  end
  if self.payCurrencyLockData.playerLockType == PayLockPlayerLockType.New then
    isLock = self:GetNewPlayerIfLock()
  end
  if self.payCurrencyLockData.playerLockType == PayLockPlayerLockType.Old then
    isLock = self:GetOldPlayerIfLock()
  end
  if isLock then
    local logStr = self:GetLog()
    self:PostEventLog()
    self:OpenLockRemindView()
    Logger.LogInfo("PayCurrencyLockManager:CheckIfLock locked. " .. logStr)
  end
  return isLock
end

function PayCurrencyLockManager:GetNewPlayerIfLock()
  local curCurrency = self:GetThisPayCurrency()
  if self:GetFixedCurrencyOpen() then
    local useFixedCurrency, lockByFixedCurrency = self:CheckByFixedCurrency(curCurrency)
    if useFixedCurrency then
      if lockByFixedCurrency then
        Logger.LogInfo("PayCurrencyLockManager:GetNewPlayerIfLock lock by fixedCurrency. curCurrency=" .. tostring(curCurrency))
        return true
      end
      return false
    end
  end
  local conditionDiffCurrencyType = false
  if self:GetIfCurrencyDifferentConditionOpen() then
    local thisPayCountry = self:GetThisPayCountry()
    local playerCountry = self:GetPlayerCountry()
    if string.IsNullOrEmpty(thisPayCountry) then
      Logger.LogError("PayCurrencyLockManager:GetNewPlayerIfLock thisPayCountry  is nil or empty")
      return false
    end
    if string.IsNullOrEmpty(playerCountry) then
      Logger.LogError("PayCurrencyLockManager:GetNewPlayerIfLock  playerCountry is nil or empty")
      playerCountry = ""
    end
    local comparePlayerCountry = self:GetCountryCodeForCompare(playerCountry)
    local alpha2, alpha3 = self:GetCountryAlpha2AndAlpha3(thisPayCountry)
    local thisPayAlpha2CheckFalse = self:GetCountryCodeForCompare(alpha2) ~= comparePlayerCountry
    local thisPayAlpha3CheckFalse = self:GetCountryCodeForCompare(alpha3) ~= comparePlayerCountry
    conditionDiffCurrencyType = thisPayAlpha2CheckFalse and thisPayAlpha3CheckFalse and curCurrency ~= self.payCurrencyLockData.firstPayCurrencyType
  end
  local conditionMaxUsedCurrencyType = false
  if self:GetMaxUsedCurrencyLimitOpen() then
    conditionMaxUsedCurrencyType = self:GetIfReachUsedCurrencyTypeLimit()
  end
  return conditionDiffCurrencyType or conditionMaxUsedCurrencyType
end

function PayCurrencyLockManager:GetOldPlayerIfLock()
  local curCurrency = self:GetThisPayCurrency()
  if self:GetFixedCurrencyOpen() then
    local useFixedCurrency, lockByFixedCurrency = self:CheckByFixedCurrency(curCurrency)
    if useFixedCurrency then
      if lockByFixedCurrency then
        Logger.LogInfo("PayCurrencyLockManager:GetOldPlayerIfLock lock by fixedCurrency. curCurrency=" .. tostring(curCurrency))
        return true
      end
      return false
    end
  end
  local conditionDiffCurrencyType = false
  if self:GetIfCurrencyDifferentConditionOpen() then
    local thisPayCountry = self:GetThisPayCountry()
    local playerCountry = self:GetPlayerCountry()
    if string.IsNullOrEmpty(thisPayCountry) then
      Logger.LogError("PayCurrencyLockManager:GetOldPlayerIfLock thisPayCountry or playerCountry is nil or empty")
      return false
    end
    if string.IsNullOrEmpty(playerCountry) then
      Logger.LogInfo("PayCurrencyLockManager:GetOldPlayerIfLock playerCountry is nil or empty")
      playerCountry = ""
    end
    local comparePlayerCountry = self:GetCountryCodeForCompare(playerCountry)
    local alpha2, alpha3 = self:GetCountryAlpha2AndAlpha3(thisPayCountry)
    local thisPayAlpha2CheckFalse = self:GetCountryCodeForCompare(alpha2) ~= comparePlayerCountry
    local thisPayAlpha3CheckFalse = self:GetCountryCodeForCompare(alpha3) ~= comparePlayerCountry
    conditionDiffCurrencyType = thisPayAlpha2CheckFalse and thisPayAlpha3CheckFalse and curCurrency ~= self.payCurrencyLockData.firstMonthMostUsedCurrencyType
  end
  local conditionMaxUsedCurrencyType = false
  if self:GetMaxUsedCurrencyLimitOpen() then
    conditionMaxUsedCurrencyType = self:GetIfReachUsedCurrencyTypeLimit()
  end
  return conditionDiffCurrencyType or conditionMaxUsedCurrencyType
end

function PayCurrencyLockManager:GetIfReachUsedCurrencyTypeLimit()
  if #self.payCurrencyLockData.usedCurrencyTypeList > self:GetMaxUsedCurrencyType() then
    return true
  end
  local curPayCurrency = self:GetThisPayCurrency()
  if not curPayCurrency then
    return false
  end
  local curPayInUsedCurrencyType = false
  local historyUsedCurrencyTypeArr = self.payCurrencyLockData.usedCurrencyTypeList
  for _, v in ipairs(historyUsedCurrencyTypeArr) do
    if v == curPayCurrency then
      curPayInUsedCurrencyType = true
    end
  end
  if curPayInUsedCurrencyType then
    return false
  else
    return #historyUsedCurrencyTypeArr + 1 >= self:GetMaxUsedCurrencyType()
  end
end

function PayCurrencyLockManager:PostEventLog()
  local usedCurrencyTypeStr = ""
  if self.payCurrencyLockData.usedCurrencyTypeList then
    usedCurrencyTypeStr = table.concat(self.payCurrencyLockData.usedCurrencyTypeList, ",")
  end
  local param = {
    thisPayCountry = self:GetThisPayCountry(),
    playerCountry = self:GetPlayerCountry(),
    thisPayCurrency = self:GetThisPayCurrency(),
    firstPayCurrency = self.payCurrencyLockData.firstPayCurrencyType or "",
    firstMonthMostUsedCurrency = self.payCurrencyLockData.firstMonthMostUsedCurrencyType or "",
    usedCurrencyTypeArr = usedCurrencyTypeStr,
    maxUsedCurrencyTypeNum = self:GetMaxUsedCurrencyType()
  }
  local paramStr = ""
  for k, v in pairs(param) do
    paramStr = paramStr .. k .. "=" .. v .. ";"
  end
  PostEventLog.Track(PostEventLog.Defines.PayCurrencyLock, param)
end

function PayCurrencyLockManager:OpenLockRemindView()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPayCurrencyLock)
end

function PayCurrencyLockManager:GetThisPayCountry()
  return DataCenter.PayManager:GetStorefrontCode()
end

function PayCurrencyLockManager:GetPlayerCountry()
  return LuaEntry.Player.regCountry
end

function PayCurrencyLockManager:GetThisPayCurrency()
  return DataCenter.PayManager:__GetLocalCurrencyCode() or ""
end

function PayCurrencyLockManager:GetIfCurrencyDifferentConditionOpen()
  return LuaEntry.DataConfig:CheckSwitch("currency_country_lock")
end

function PayCurrencyLockManager:GetMaxUsedCurrencyLimitOpen()
  return LuaEntry.DataConfig:CheckSwitch("currency_max_count_lock")
end

function PayCurrencyLockManager:GetFixedCurrencyOpen()
  return LuaEntry.DataConfig:CheckSwitch("currency_gm_fix")
end

function PayCurrencyLockManager:GetMaxUsedCurrencyType()
  if not self.payCurrencyLockData.maxUsedCurrencyTypeNum then
    local maxUsedCurrencyTypeNum = LuaEntry.DataConfig:TryGetStr("currency_lock_params", "k1")
    if string.IsNullOrEmpty(maxUsedCurrencyTypeNum) then
      Logger.LogError("PayCurrencyLockManager:GetMaxUsedCurrencyType maxUsedCurrencyTypeNum is nil or empty")
      self.payCurrencyLockData.maxUsedCurrencyTypeNum = 3
    else
      self.payCurrencyLockData.maxUsedCurrencyTypeNum = tonumber(maxUsedCurrencyTypeNum) or 3
    end
  end
  return self.payCurrencyLockData.maxUsedCurrencyTypeNum
end

function PayCurrencyLockManager:GetLog()
  local usedCurrencyTypeStr = ""
  if self.payCurrencyLockData.usedCurrencyTypeList then
    usedCurrencyTypeStr = table.concat(self.payCurrencyLockData.usedCurrencyTypeList, ",")
  end
  local param = {
    thisPayCountry = self:GetThisPayCountry(),
    playerCountry = self:GetPlayerCountry(),
    thisPayCurrency = self:GetThisPayCurrency(),
    firstPayCurrency = self.payCurrencyLockData.firstPayCurrencyType or "",
    firstMonthMostUsedCurrency = self.payCurrencyLockData.firstMonthMostUsedCurrencyType or "",
    usedCurrencyTypeArr = usedCurrencyTypeStr,
    maxUsedCurrencyTypeNum = self:GetMaxUsedCurrencyType(),
    fixedCurrency = table.concat(self.payCurrencyLockData.fixedCurrency or {}, ",")
  }
  local paramStr = ""
  for k, v in pairs(param) do
    paramStr = paramStr .. k .. "=" .. v .. ";"
  end
  return paramStr
end

function PayCurrencyLockManager:CheckByFixedCurrency(curCurrency)
  local fixedCurrency = self.payCurrencyLockData.fixedCurrency
  local isEmpty = fixedCurrency == nil or #fixedCurrency == 0
  if isEmpty then
    return false, false
  end
  for _, v in ipairs(fixedCurrency) do
    if curCurrency == v then
      return true, false
    end
  end
  return true, true
end

function PayCurrencyLockManager:GetThisPayCurrencyTemplate(country)
  local curCurrencyLockTemplate
  LocalController:instance():visitTable(TableName.PAY_COUNTRY_CURRENCY, function(_, lineData)
    if lineData ~= nil then
      local alpha2 = lineData:getValue("Alpha2")
      local alpha3 = lineData:getValue("Alpha3")
      if country == alpha2 or country == alpha3 then
        local currencyLockTemplate = PayCurrencyLockTemplate.New()
        currencyLockTemplate:UpdateData(lineData)
        if currencyLockTemplate.id ~= nil then
          self.payCurrencyConfigDic[lineData.id] = currencyLockTemplate
          curCurrencyLockTemplate = currencyLockTemplate
        end
      end
    end
  end)
  return curCurrencyLockTemplate
end

function PayCurrencyLockManager:GetCountryAlpha2AndAlpha3(country)
  local find = false
  local alpha2 = ""
  local alpha3 = ""
  local compareCountry = self:GetCountryCodeForCompare(country)
  for _, v in pairs(self.payCurrencyConfigDic) do
    if self:GetCountryCodeForCompare(v.storeCodeAlpha2) == compareCountry or self:GetCountryCodeForCompare(v.storeCodeAlpha3) == compareCountry then
      alpha2 = v.storeCodeAlpha2
      alpha3 = v.storeCodeAlpha3
      find = true
      break
    end
  end
  if not find then
    local template = self:GetThisPayCurrencyTemplate(country)
    if template then
      alpha2 = template.storeCodeAlpha2
      alpha3 = template.storeCodeAlpha3
    else
      alpha2 = country
      alpha3 = country
    end
  end
  return alpha2, alpha3
end

function PayCurrencyLockManager:GetCountryCodeForCompare(countryCode)
  if string.IsNullOrEmpty(countryCode) then
    return ""
  end
  return string.upper(countryCode)
end

function PayCurrencyLockManager:SetFakeData()
  self.payCurrencyLockData = PayCurrencyLockData.New()
  local testPayCurrencyLockData = {}
  testPayCurrencyLockData.inWhitelist = 0
  testPayCurrencyLockData.newPlayer = 0
  testPayCurrencyLockData.firstPayCurrencyType = "KRW"
  testPayCurrencyLockData.firstMonthMostUsedCurrencyType = "KRW"
  testPayCurrencyLockData.maxUsedCurrencyTypeNum = 3
  testPayCurrencyLockData.fixedCurrency = "USD"
  testPayCurrencyLockData.usedCurrencyTypeList = {
    "SGD",
    "KRW",
    "JPY"
  }
  self.payCurrencyLockData:ParseLockData(testPayCurrencyLockData)
end

return PayCurrencyLockManager
