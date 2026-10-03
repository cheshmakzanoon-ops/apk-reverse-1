local WeekCardManager = BaseClass("WeekCardManager")
local Localization = CS.GameEntry.Localization
local WeekCardData = require("DataCenter.WeekCard.WeekCardData")

local function __init(self)
  self.weekCardList = {}
  self.lastRecvFreeTime = 0
  self:AddListener()
end

local function __delete(self)
  self.weekCardList = nil
  self.buyAllPackageId = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function InitData(self)
  SFSNetwork.SendMessage(MsgDefines.GetWeekCardList, true)
end

function WeekCardManager:OnInitWeekCardList(tb)
  self:UpdateWeekCardList(tb)
  for i, v in ipairs(self.weekCardList) do
    if v and v.isNew then
      EventManager:GetInstance():Broadcast(EventId.UIWeekCardShowNewOpen, v)
      break
    end
  end
end

function WeekCardManager:UpdateBuyAllPackageId(id)
  self.buyAllPackageId = id
end

function WeekCardManager:GetBuyAllPackageId()
  return self.buyAllPackageId
end

local function UpdateWeekCardList(self, tb)
  if table.IsNullOrEmpty(tb) then
    return
  end
  for i, v in pairs(tb) do
    self:UpdateOneWeekCard(v, true)
  end
  EventManager:GetInstance():Broadcast(EventId.OnWeekCardInfoChange)
  EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
end

local function UpdateOneWeekCard(self, t, notBroadcast)
  local isExist = false
  for i, v in pairs(self.weekCardList) do
    if v.id == t.id then
      v:ParseData(t)
      isExist = true
      break
    end
  end
  if not isExist then
    local newCard = WeekCardData.New()
    newCard:ParseData(t)
    table.insert(self.weekCardList, newCard)
  end
  if not notBroadcast then
    EventManager:GetInstance():Broadcast(EventId.OnWeekCardInfoChange, t.id)
    EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
  end
end

local function UpdateWeekCardFreeReward(self, t)
  if t.lastRewardTime then
    self.lastRecvFreeTime = t.lastRewardTime
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
  EventManager:GetInstance():Broadcast(EventId.UpdateWeekCardFreeGiftData)
end

local function CheckIfHasFreeReward(self)
  local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
  local lastT = math.modf(self.lastRecvFreeTime / 1000)
  return not UITimeManager:GetInstance():IsSameDayForServer(serverTimeS, lastT)
end

local function GetWeekCardList(self)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  table.sort(self.weekCardList, function(a, b)
    if a.isNew == true and not b.isNew then
      return true
    elseif b.isNew == true and not a.isNew then
      return false
    end
    local isBoughtA = a.endTime > serverTime
    local isBoughtB = b.endTime > serverTime
    if isBoughtA ~= isBoughtB then
      return isBoughtA
    elseif a.order ~= b.order then
      return a.order > b.order
    end
    return a.id > b.id
  end)
  return self.weekCardList
end

function WeekCardManager:GetWeekCardDataById(id)
  for i = 1, #self.weekCardList do
    if self.weekCardList[i] and id == self.weekCardList[i].id then
      return self.weekCardList[i]
    end
  end
  return nil
end

local function CheckIfHasRed(self)
  local total = 0
  for i, v in pairs(self.weekCardList) do
    v:RefreshStatus()
    if v.status == WeekCardPackageStatus.CanClaim then
      total = total + 1
    end
  end
  return 0 < total, total
end

function WeekCardManager:IsUsingNewRewardIconUI()
  local server = LuaEntry.Player:GetSourceServerId()
  local configStr = ""
  if CS.CommonUtils.IsDebug() then
    configStr = LuaEntry.DataConfig:TryGetStr("weekcard_config", "k2")
  else
    configStr = LuaEntry.DataConfig:TryGetStr("weekcard_config", "k1")
  end
  if not string.IsNullOrEmpty(configStr) then
    local array = string.split(configStr, "|")
    for _, arr in ipairs(array) do
      local list = string.split(arr, ",")
      if #list == 2 then
        local startServer = tonumber(list[1])
        local endServer = tonumber(list[2])
        if startServer <= endServer and server >= startServer and server <= endServer then
          return true
        end
      end
    end
  end
  return false
end

function WeekCardManager:GetRenewWeekCountLimit()
  return LuaEntry.DataConfig:TryGetNum("weekcard_config_new", "k4", 0)
end

WeekCardManager.__init = __init
WeekCardManager.__delete = __delete
WeekCardManager.AddListener = AddListener
WeekCardManager.RemoveListener = RemoveListener
WeekCardManager.InitData = InitData
WeekCardManager.GetWeekCardList = GetWeekCardList
WeekCardManager.UpdateWeekCardList = UpdateWeekCardList
WeekCardManager.UpdateOneWeekCard = UpdateOneWeekCard
WeekCardManager.CheckIfHasRed = CheckIfHasRed
WeekCardManager.UpdateWeekCardFreeReward = UpdateWeekCardFreeReward
WeekCardManager.CheckIfHasFreeReward = CheckIfHasFreeReward
return WeekCardManager
