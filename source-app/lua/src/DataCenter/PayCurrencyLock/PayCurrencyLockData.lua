local PayCurrencyLockData = BaseClass("PayCurrencyLockData")

function PayCurrencyLockData:__init()
  self.playerLockType = PayLockPlayerLockType.None
  self.firstPayCurrencyType = ""
  self.firstMonthMostUsedCurrencyType = ""
  self.usedCurrencyTypeList = {}
  self.isInWhiteList = false
  self.maxUsedCurrencyTypeNum = nil
  self.fixedCurrency = nil
end

function PayCurrencyLockData:__delete()
  self.playerLockType = nil
  self.firstPayCurrencyType = nil
  self.firstMonthMostUsedCurrencyType = nil
  self.usedCurrencyTypeList = nil
  self.isInWhiteList = nil
  self.maxUsedCurrencyTypeNum = nil
  self.fixedCurrency = nil
end

function PayCurrencyLockData:ParseLockData(lockInfo)
  local newPlayer = lockInfo.newPlayer
  if newPlayer == nil then
    Logger.LogError("PayCurrencyLockManager:InitData newPlayer is nil")
  elseif newPlayer == 1 then
    self.playerLockType = PayLockPlayerLockType.New
  elseif newPlayer == 0 then
    self.playerLockType = PayLockPlayerLockType.Old
  end
  local isInWhiteList = lockInfo.inWhitelist
  if isInWhiteList == nil then
    Logger.LogError("PayCurrencyLockManager:InitData inWhitelist is nil")
  else
    self.isInWhiteList = isInWhiteList == 1
  end
  local firstPayCurrencyType = lockInfo.firstPayCurrencyType
  if not string.IsNullOrEmpty(firstPayCurrencyType) then
    self.firstPayCurrencyType = firstPayCurrencyType
  end
  local firstMonthMostUsedCurrencyType = lockInfo.firstMonthMostUsedCurrencyType
  if not string.IsNullOrEmpty(firstMonthMostUsedCurrencyType) then
    self.firstMonthMostUsedCurrencyType = firstMonthMostUsedCurrencyType
  end
  local usedCurrencyTypeList = lockInfo.usedCurrencyTypeArr
  if usedCurrencyTypeList then
    self.usedCurrencyTypeList = usedCurrencyTypeList
  end
  local fixedCurrencyStr = lockInfo.fixedCurrency
  if not string.IsNullOrEmpty(fixedCurrencyStr) then
    self.fixedCurrency = string.split(fixedCurrencyStr, ",")
  else
    self.fixedCurrency = {}
  end
end

return PayCurrencyLockData
