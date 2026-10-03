local HeroMonthCardManager = BaseClass("HeroMonthCardManager")
local HeroMonthCardData = require("DataCenter.HeroMonthCardManager.HeroMonthCardData")
local HeroMonthCardHavePopKey = "HeroMonthCardHavePop_"

local function __init(self)
  self.templates = {}
  self.monthCardInfoDict = nil
  self.monthCardInfoExchangeIdToActId = {}
  self.monthCardInfoGroupIdToActId = {}
  self.monthCardInfoExchangeIdToRechargeId = nil
end

local function __delete(self)
  self.monthCardInfoDict = nil
  self.monthCardInfoExchangeIdToActId = nil
  self.monthCardInfoGroupIdToActId = nil
  self.monthCardInfoExchangeIdToRechargeId = nil
  self.templates = nil
end

local function Startup(self)
  self:GetDataFromServer()
end

local function GetDataFromServer(self)
  SFSNetwork.SendMessage(MsgDefines.GetHeroMonthCardInfo)
end

local function DoWhenAllDataBack(self, message)
  if message == nil then
    return
  end
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if message.cards then
    if self.monthCardInfoDict == nil then
      self.monthCardInfoDict = {}
    end
    for _, card in ipairs(message.cards) do
      local activityId = card.activityId
      local exchangeId = card.exchangeId
      local groupId = card.group
      if activityId and exchangeId and groupId then
        if self.monthCardInfoDict[activityId] == nil then
          self.monthCardInfoDict[activityId] = HeroMonthCardData.New()
          self.monthCardInfoExchangeIdToActId[exchangeId] = activityId
          self.monthCardInfoGroupIdToActId[groupId] = activityId
        end
        self.monthCardInfoDict[activityId]:ParseData(card)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshHeroMonthCardAll)
  self:CheckIsNeedPopAfterGetData()
end

local function GetReward(self, activityId, day)
  SFSNetwork.SendMessage(MsgDefines.GetHeroMonthCardReward, activityId, day)
end

local function GetHeroMonthCardInfo(self, activityId)
  if self.monthCardInfoDict == nil then
    return nil
  end
  return self.monthCardInfoDict[activityId]
end

local function DoWhenGetRewardBack(self, message)
  if message == nil then
    return
  end
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local reward = message.reward
  if reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  local activityId = message.activityId
  local monthCardInfo = self:GetHeroMonthCardInfo(activityId)
  if monthCardInfo == nil then
    return
  end
  local days = message.days
  if days ~= nil then
    for _, day in ipairs(days) do
      monthCardInfo:SetRewardState(day, 1)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshHeroMonthCardSingle, -1)
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
end

local function DoWhenBuyCard(self, activityId)
  local monthCardInfo = self:GetHeroMonthCardInfo(activityId)
  if monthCardInfo ~= nil then
    monthCardInfo.buy = BuyFlag.BUY
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshHeroMonthCardAll)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetHeroMonthCardReward(self, activityId, day)
  local monthCardInfo = self:GetHeroMonthCardInfo(activityId)
  if monthCardInfo == nil then
    return nil
  end
  return monthCardInfo:GetReward(day)
end

local function GetRewardState(self, activityId, reward)
  local monthCardInfo = self:GetHeroMonthCardInfo(activityId)
  if reward == nil or monthCardInfo == nil or monthCardInfo.buy == BuyFlag.NOT_BUY then
    return HeroMonthCardRewardState.REWARD_STATE_LOCK
  end
  if reward.state == 1 then
    return HeroMonthCardRewardState.REWARD_STATE_RECEIVED
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > monthCardInfo.endTime or now < monthCardInfo.startTime then
    return HeroMonthCardRewardState.REWARD_STATE_LOCK
  end
  if reward.state == 0 then
    local day = (now - monthCardInfo.startTime) / (OneDayTime * 1000) + 1
    if day >= reward.day then
      return HeroMonthCardRewardState.REWARD_STATE_CAN_RECEIVE
    else
      return HeroMonthCardRewardState.REWARD_STATE_UNRECEIVED
    end
  end
  return HeroMonthCardRewardState.REWARD_STATE_LOCK
end

local function GetUnReceivedReward(self, activityId)
  local monthCardInfo = self:GetHeroMonthCardInfo(activityId)
  if monthCardInfo == nil or monthCardInfo.buy == BuyFlag.NOT_BUY then
    return 0
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > monthCardInfo.endTime or now < monthCardInfo.startTime then
    return 0
  end
  local result = 0
  for _, v in ipairs(monthCardInfo.rewardArr) do
    local state = self:GetRewardState(activityId, v)
    if state == HeroMonthCardRewardState.REWARD_STATE_CAN_RECEIVE then
      result = result + 1
    end
  end
  return result
end

local function ShowNewFlag(self, activityId)
  local tagInfo = WelfareController.getShowTagInfoByType(WelfareTagType.HeroMonthCardNew)
  if not tagInfo or not tagInfo:isShow() then
    return false
  end
  local key = self:GetNewFlagSettingKey(activityId)
  local value = Setting:GetBool(key, true)
  return value
end

local function SetNewFlag(self, activityId)
  local key = self:GetNewFlagSettingKey(activityId)
  Setting:SetBool(key, false)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetNewFlagSettingKey(self, activityId)
  return LuaEntry.Player.uid .. "__NewFlagSettingKey" .. activityId
end

local function GetAllReward(self, activityId)
  local monthCardInfo = self:GetHeroMonthCardInfo(activityId)
  local tmp = {}
  if monthCardInfo ~= nil then
    local rewardArr = monthCardInfo.rewardArr
    table.walk(rewardArr, function(_, v)
      if v ~= nil and v.reward ~= nil then
        table.walk(v.reward, function(_, k)
          local key = tostring(k.rewardType) .. "_" .. (k.itemId or "")
          if tmp[key] == nil then
            tmp[key] = DeepCopy(k)
          else
            tmp[key].count = tmp[key].count + k.count
          end
        end)
      end
    end)
  end
  local result = table.values(tmp)
  return result
end

local function GetTemplate(self, id)
  if self.templates[id] == nil then
    local lineData = LocalController:instance():getLine("hero_monthcard", id)
    if lineData ~= nil then
      local tempData = DeepCopy(lineData)
      tempData.hotListTab = {}
      if not string.IsNullOrEmpty(tempData.hot_list) then
        local dArr = string.split(tempData.hot_list, "|")
        for k, v in ipairs(dArr) do
          local day = tonumber(v)
          tempData.hotListTab[day] = true
        end
      end
      self.templates[tempData.id] = tempData
    end
  end
  return self.templates[id]
end

local function CheckIsNeedPop(self)
  self.startCkeckPop = true
  local isPopConfig = LuaEntry.DataConfig:TryGetNum("hero_monthcard_config", "k1")
  if isPopConfig ~= 1 then
    self.checkPopIsEnd = true
    return
  end
  if self.monthCardInfoDict == nil then
    DataCenter.HeroMonthCardManager:GetDataFromServer()
    return
  end
  self:CheckIsNeedPopAfterGetData()
end

local function CheckIsNeedPopAfterGetData(self)
  if self.startCkeckPop == nil then
    return
  end
  if self.checkPopIsEnd then
    return
  end
  self.checkPopIsEnd = true
  if self.monthCardInfoDict == nil then
    return
  end
  for _, v in pairs(self.monthCardInfoDict) do
    local data = v
    local flag = data.buy == BuyFlag.BUY
    local activityId = 0
    local activityList = DataCenter.ActivityListDataManager:GetActivityList()
    for k, v in pairs(activityList) do
      if v.type == EnumActivity.HeroMonthCard.Type and v.subType == data.groupId then
        activityId = v.id
        break
      end
    end
    activityId = tonumber(activityId) or 0
    local monthActId = data.activityId
    local isHavePop = self:GetIsHavePop(monthActId)
    if not flag and 0 < activityId and not isHavePop then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.LWActivityPop, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllHide
      }, activityId)
    end
  end
end

local function GetIsHavePop(self, activityId)
  local key = HeroMonthCardHavePopKey .. activityId
  return Setting:GetBool(key, false)
end

local function SetIsHavePop(self, activityId)
  local key = HeroMonthCardHavePopKey .. activityId
  Setting:SetBool(key, true)
end

local function GetActivityIdByExchangeId(self, exchangeId)
  return self.monthCardInfoExchangeIdToActId[exchangeId]
end

local function GetActivityIdByGroupId(self, groupId)
  return self.monthCardInfoGroupIdToActId[groupId]
end

local function GetRechargeIdByExchangeId(self, exchangeId)
end

local function GetActRedNum(self, actId)
  local activityId = 0
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  if activityInfo == nil then
    return 0
  end
  local groupId = activityInfo.subType
  activityId = self:GetActivityIdByGroupId(groupId)
  if activityId == nil or activityId == 0 then
    return 0
  end
  local num = self:GetUnReceivedReward(activityId)
  return num
end

HeroMonthCardManager.__init = __init
HeroMonthCardManager.__delete = __delete
HeroMonthCardManager.GetDataFromServer = GetDataFromServer
HeroMonthCardManager.DoWhenAllDataBack = DoWhenAllDataBack
HeroMonthCardManager.GetReward = GetReward
HeroMonthCardManager.DoWhenBuyCard = DoWhenBuyCard
HeroMonthCardManager.DoWhenGetRewardBack = DoWhenGetRewardBack
HeroMonthCardManager.GetHeroMonthCardReward = GetHeroMonthCardReward
HeroMonthCardManager.GetRewardState = GetRewardState
HeroMonthCardManager.GetHeroMonthCardInfo = GetHeroMonthCardInfo
HeroMonthCardManager.Startup = Startup
HeroMonthCardManager.GetUnReceivedReward = GetUnReceivedReward
HeroMonthCardManager.ShowNewFlag = ShowNewFlag
HeroMonthCardManager.GetNewFlagSettingKey = GetNewFlagSettingKey
HeroMonthCardManager.SetNewFlag = SetNewFlag
HeroMonthCardManager.GetAllReward = GetAllReward
HeroMonthCardManager.GetTemplate = GetTemplate
HeroMonthCardManager.CheckIsNeedPop = CheckIsNeedPop
HeroMonthCardManager.CheckIsNeedPopAfterGetData = CheckIsNeedPopAfterGetData
HeroMonthCardManager.GetActivityIdByExchangeId = GetActivityIdByExchangeId
HeroMonthCardManager.GetActivityIdByGroupId = GetActivityIdByGroupId
HeroMonthCardManager.GetRechargeIdByExchangeId = GetRechargeIdByExchangeId
HeroMonthCardManager.GetActRedNum = GetActRedNum
HeroMonthCardManager.GetIsHavePop = GetIsHavePop
HeroMonthCardManager.SetIsHavePop = SetIsHavePop
return HeroMonthCardManager
