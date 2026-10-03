local AccountListManager = BaseClass("AccountListManager")
local AccountInfo = require("DataCenter.AccountData.AccountInfo")
local MaxLimit = 50
local Sdk = CS.GameEntry.Sdk
local Setting = CS.GameEntry.Setting

function AccountListManager:__init()
  self.m_accountInfos = nil
  self:LoadAcountInfos()
end

function AccountListManager:GetAccountInfoString()
  local accountCache = Sdk:GetDataFromNative("PM_getDatFromFile", "account.txt")
  local historyAccount = ""
  if not string.IsNullOrEmpty(accountCache) then
    historyAccount = accountCache
  else
    historyAccount = Setting:GetString(SettingKeys.ACCOUNT_LIST_DEBUG, "")
  end
  return historyAccount
end

function AccountListManager:ParseAccountInfos(info)
  local _ = {}
  if not info then
    return _
  end
  local accList = string.string2array_s(info, "|", "#")
  for k, v in ipairs(accList) do
    if not table.IsNullOrEmpty(v) and not (#v < 4) then
      local accountInfo = AccountInfo.New()
      accountInfo.serverid = toInt(v[1])
      accountInfo.gameUid = v[2]
      accountInfo.nickname = v[3]
      accountInfo.level = toInt(v[4])
      if 5 <= #v then
        accountInfo.newLevel = toInt(v[5])
      end
      if 8 <= #v then
        accountInfo.ip = v[6]
        accountInfo.port = toInt(v[7])
        accountInfo.zone = v[8]
      end
      if 9 <= #v then
        accountInfo.accessToken = v[9]
      end
      if 10 <= #v then
        accountInfo.urlEnv = v[10]
      end
      table.insert(_, accountInfo)
    end
  end
  return _
end

function AccountListManager:LoadAcountInfos()
  local historyAccount = self:GetAccountInfoString()
  self.m_accountInfos = self:ParseAccountInfos(historyAccount)
end

function AccountListManager:AddAcountInfo(accountInfo, dontSave)
  local queryIndex = self:GetAcountInfoIndexByUidAndURLEnv(accountInfo.serverid, accountInfo.gameUid, accountInfo.urlEnv)
  if queryIndex ~= -1 then
    table.remove(self.m_accountInfos, queryIndex)
  end
  table.insert(self.m_accountInfos, accountInfo)
  if not dontSave then
    self:Save()
  end
end

function AccountListManager:DeleteAcountInfo(serverId, uid, urlEnv)
  local index = self:GetAcountInfoIndexByUidAndURLEnv(serverId, uid, urlEnv)
  if index == -1 then
    return
  end
  table.remove(self.m_accountInfos, index)
  self:Save()
end

function AccountListManager:MergeAccountInfoAndSave(str)
  if not self.m_accountInfos then
    self:LoadAcountInfos()
  end
  local newCount = 0
  local parsedInfos = self:ParseAccountInfos(str)
  if parsedInfos and 0 < #parsedInfos then
    for _, accountInfo in ipairs(parsedInfos) do
      local queryIndex = self:GetAcountInfoIndexByUidAndURLEnv(accountInfo.serverid, accountInfo.gameUid, accountInfo.urlEnv)
      if queryIndex ~= -1 then
      else
        table.insert(self.m_accountInfos, accountInfo)
        newCount = newCount + 1
      end
    end
  end
  if 0 < newCount then
    self:Save()
  end
  return newCount
end

function AccountListManager:GetAcountInfoIndexByUidAndURLEnv(serverId, uid, urlEnv)
  local index = -1
  if string.IsNullOrEmpty(uid) then
    return index
  end
  local inputEnvName = string.match(urlEnv, "^([^:]+)") or urlEnv
  for k, v in pairs(self.m_accountInfos) do
    local storedEnvName = string.match(v.urlEnv, "^([^:]+)") or v.urlEnv
    if v.serverid == serverId and v.gameUid == uid and storedEnvName == inputEnvName then
      index = k
      break
    end
  end
  return index
end

function AccountListManager:Save()
  local count = #self.m_accountInfos
  local beginIndex = count > MaxLimit and count - MaxLimit or 0
  beginIndex = beginIndex + 1
  local tbl = {}
  for i = beginIndex, count do
    local acountInfo = self.m_accountInfos[i]
    if not string.IsNullOrEmpty(acountInfo.gameUid) then
      local newStr = string.format("%s|%s|%s|%s|%s|%s|%s|%s|%s|%s", acountInfo.serverid, acountInfo.gameUid, acountInfo.nickname or "", acountInfo.level or 0, acountInfo.newLevel or 0, acountInfo.ip, acountInfo.port, acountInfo.zone, acountInfo.accessToken or "", acountInfo.urlEnv or "")
      table.insert(tbl, newStr)
    end
  end
  local str = table.concat(tbl, "#")
  Setting:SetString(SettingKeys.ACCOUNT_LIST_DEBUG, str)
  Sdk:saveDataToSdcard(str, "account.txt")
end

function AccountListManager:UpdatePlayerMainLv(serverId, uid, level, urlEnv, fromReload)
  local index = self:GetAcountInfoIndexByUidAndURLEnv(serverId, uid, urlEnv)
  if index == -1 then
    return
  end
  self.m_accountInfos[index].newLevel = level
  self:Save()
end

function AccountListManager:UpdatePlayerName(serverId, uid, name, urlEnv)
  local index = self:GetAcountInfoIndexByUidAndURLEnv(serverId, uid, urlEnv)
  if index == -1 then
    return
  end
  self.m_accountInfos[index].nickname = name
  self:Save()
end

function AccountListManager:GetAccountInfos()
  local filteredAccountList = {}
  for k, v in ipairs(self.m_accountInfos) do
    local enumName = CS.System.Enum.GetName(typeof(CS.URLGroupType), CS.NetworkURLConfig.URLGroupType)
    local storedEnvName = string.match(v.urlEnv, "^([^:]+)") or v.urlEnv
    if storedEnvName == enumName then
      table.insert(filteredAccountList, v)
    end
  end
  return filteredAccountList
end

return AccountListManager
