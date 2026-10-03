local LWRefundPunishManager = BaseClass("LWRefundPunishManager")
local LWRefundGoldBrickTemplate = require("DataCenter.LWRefundPunish.LWRefundGoldBrickTemplate")
local Localization = CS.GameEntry.Localization
local punishStrMap = {
  [RefundPunishType.None] = "refund_window_limit_noaffect",
  [RefundPunishType.PAY_BAN] = "refund_window_limit_buypack",
  [RefundPunishType.CHAT_BAN] = "refund_window_limit_chat",
  [RefundPunishType.MARCH_BAN] = "refund_window_limit_march",
  [RefundPunishType.LOGIN_BAN] = "refund_window_limit_ban"
}

function LWRefundPunishManager:__init()
  self.refund2BanType = RefundPunishType.None
  self.refund2PunishTime = 0
  self.goldBrickMap = {}
  self.goldBrickMapPC = {}
end

function LWRefundPunishManager:__delete()
  self.refund2BanType = nil
  self.refund2PunishTime = nil
  self.goldBrickMap = nil
  self.goldBrickMapPC = nil
end

function LWRefundPunishManager:InitData(t)
  self.refund2BanType = t.refund2BanType
  self.refund2PunishTime = t.refund2PunishTime
end

function LWRefundPunishManager:InitGoldBrickMap()
  self.goldBrickMap = {}
  LocalController:instance():visitTable(TableName.REFUND_GOLDBRICK, function(id, lineData)
    if lineData ~= nil then
      local template = LWRefundGoldBrickTemplate.New()
      template:InitData(lineData)
      self.goldBrickMap[template.id] = template
    end
  end)
end

function LWRefundPunishManager:GetPunishType()
  return self.refund2BanType
end

function LWRefundPunishManager:GetCanPay(packageInfo)
  if self:CheckSwitchOn() and self.refund2BanType and self.refund2BanType >= RefundPunishType.PAY_BAN then
    local isRefundBrickPack = packageInfo:getType() == GiftPackType.RefundBrickPackage or packageInfo:getType() == GiftPackType.LawBrickPackage
    if not isRefundBrickPack then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWRefundPunish)
      return false
    end
  end
  return true
end

function LWRefundPunishManager:GetCanChat()
  if self:CheckSwitchOn() and self.refund2BanType and self.refund2BanType >= RefundPunishType.CHAT_BAN then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWRefundPunish)
    return false
  end
  return true
end

function LWRefundPunishManager:GetCanMarch()
  if self:CheckSwitchOn() and self.refund2BanType and self.refund2BanType >= RefundPunishType.MARCH_BAN then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWRefundPunish)
    return false
  end
  return true
end

function LWRefundPunishManager:GetCanLogIn()
  if self:CheckSwitchOn() and self.refund2BanType and self.refund2BanType >= RefundPunishType.LOGIN_BAN then
    return false
  end
  return true
end

function LWRefundPunishManager:GetPunishTime()
  return self.refund2PunishTime
end

function LWRefundPunishManager:GetGoldBrickPackage()
  if not self.goldBrickMap or table.length(self.goldBrickMap) == 0 then
    self:InitGoldBrickMap()
  end
  return self.goldBrickMap
end

function LWRefundPunishManager:GetBrickNumById(id, isPc)
  local num = 0
  local goldBrickMap = self:GetGoldBrickPackage()
  if isPc then
    goldBrickMap = self:GetGoldBrickPackagePC()
  end
  local template = goldBrickMap[tonumber(id)]
  if template then
    num = template.brickNum
  else
    Logger.LogError("goldBrickMap not contain, id: " .. id)
  end
  return num
end

function LWRefundPunishManager:GetCurPunishList()
  if self.refund2BanType == RefundPunishType.None then
    return {
      RefundPunishType.None
    }
  end
  local curPunishList = {}
  for _, value in pairs(RefundPunishType) do
    if value > RefundPunishType.None and value <= self.refund2BanType then
      table.insert(curPunishList, value)
    end
  end
  table.sort(curPunishList)
  return curPunishList
end

function LWRefundPunishManager:GetNextPunish()
  local nextPunish = self.refund2BanType + 1
  if nextPunish > RefundPunishType.MARCH_BAN then
    nextPunish = RefundPunishType.MARCH_BAN
  end
  return nextPunish
end

function LWRefundPunishManager:GetPunishLocalizationString(punish)
  local id = punishStrMap[punish]
  if not id then
    Logger.LogError("punishStrMap not contain,punish==" .. punish)
    return ""
  end
  return Localization:GetString(id)
end

function LWRefundPunishManager:CheckSwitchOn()
  return LuaEntry.DataConfig:CheckSwitch("refund_client2")
end

function LWRefundPunishManager:InitGoldBrickMapPC()
  self.goldBrickMapPC = {}
  LocalController:instance():visitTable(TableName.REFUND_GOLDBRICK_PC, function(id, lineData)
    if lineData ~= nil then
      local template = LWRefundGoldBrickTemplate.New()
      template:InitData(lineData)
      self.goldBrickMapPC[template.id] = template
    end
  end)
end

function LWRefundPunishManager:GetGoldBrickPackagePC()
  if not self.goldBrickMapPC or table.length(self.goldBrickMapPC) == 0 then
    self:InitGoldBrickMapPC()
  end
  return self.goldBrickMapPC
end

function LWRefundPunishManager:GetGoldBrickDataByGoods(goodsId)
  local brickMapPC = self:GetGoldBrickPackagePC()
  for k, v in pairs(brickMapPC) do
    local template = v
    if not template then
      Logger.LogError("goldBrickMap template is nil, index: " .. k)
      return nil
    end
    if template.goodsId == goodsId then
      return template
    end
  end
  return nil
end

function LWRefundPunishManager:GetIsRefundBrick(packageInfo)
  if not packageInfo then
    Logger.LogError("packageInfo is nil")
    return false
  end
  return packageInfo:getType() == GiftPackType.RefundBrickPackage
end

function LWRefundPunishManager:GetBanTypeByBrickNum(curBrickNum)
  local k2Str = LuaEntry.DataConfig:TryGetStr("refund_params", "k2", "")
  if string.IsNullOrEmpty(k2Str) then
    Logger.LogError("k2Str is nil")
    return 0
  end
  local limitMap = {}
  local k2List = string.split(k2Str, "|")
  for k, v in pairs(k2List) do
    local str = string.split(v, ";")
    local id = str[1]
    local beginValue = str[2]
    local endValue = str[3]
    table.insert(limitMap, {
      id = tonumber(id),
      beginValue = tonumber(beginValue),
      endValue = tonumber(endValue)
    })
  end
  if table.count(limitMap) == 0 then
    Logger.LogError("limitMap is nil")
    return 0
  end
  if limitMap[1] and limitMap[1].beginValue ~= 0 then
    table.insert(limitMap, 1, {
      id = 0,
      beginValue = 0,
      endValue = limitMap[1].beginValue
    })
  end
  table.sort(limitMap, function(a, b)
    return a.beginValue > b.beginValue
  end)
  for k, v in pairs(limitMap) do
    if curBrickNum == v.endValue or curBrickNum == v.beginValue or curBrickNum < v.beginValue and curBrickNum > v.endValue then
      return tonumber(v.id)
    end
  end
  return 0
end

function LWRefundPunishManager:GetPunishListByBanType(banType)
  if banType == RefundPunishType.None then
    return {
      RefundPunishType.None
    }
  end
  local curPunishList = {}
  for _, value in pairs(RefundPunishType) do
    if value > RefundPunishType.None and value <= banType then
      table.insert(curPunishList, value)
    end
  end
  table.sort(curPunishList)
  return curPunishList
end

function LWRefundPunishManager:GetNextPunishByBanType(banType)
  local nextPunish = banType + 1
  if nextPunish > RefundPunishType.MARCH_BAN then
    nextPunish = RefundPunishType.MARCH_BAN
  end
  return nextPunish
end

return LWRefundPunishManager
