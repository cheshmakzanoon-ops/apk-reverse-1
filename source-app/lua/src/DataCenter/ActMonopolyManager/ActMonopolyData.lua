local ActMonopolyData = BaseClass("ActMonopolyData")
local ActivityFreeRewardData = require("DataCenter.ActivityFreeRewardData.ActivityFreeRewardData")

local function __init(self)
  self.activityId = 0
  self.achieveActivityId = 0
  self.cycle = 0
  self.nowGrid = 0
  self.freeNormalDice = 0
  self.freeHighDice = 0
  self.backUpTimes = 0
  self.nextItemGridAddExp = 0
  self.gridList = {}
  self.minStoreEndTime = 0
  self.group = 0
  self.boxGrid = nil
  self.richManGridRewards = nil
  self.storeDict = nil
  self.lastReceiveFreeTime = 0
  self.dayReward = {}
  self.boosReward = {}
  self.weakReward = {}
  self.activityFreeRewardData = ActivityFreeRewardData.New()
  self.isBoss = 0
  self.bossBlood = 0
  self.bossWeakHp = 0
  self.bossReceive = {}
  self.bossDamage = {}
  self.bossWeakReceiveTimes = 0
  self.damageReward = {}
  self.isDamageRewardDataComplete = false
  self.autoEventList = {}
  self.autoDiceNum = 0
  self.autoDiceDoubleNum = 0
  self.autoDiceCost = 0
  self.autoDiceDiamond = 0
end

local function __delete(self)
  self.activityId = nil
  self.achieveActivityId = nil
  self.cycle = nil
  self.nowGrid = nil
  self.freeNormalDice = nil
  self.freeHighDice = nil
  self.backUpTimes = nil
  self.nextItemGridAddExp = nil
  self.gridList = nil
  self.minStoreEndTime = nil
  self.group = nil
  self.boxGrid = nil
  self.richManGridRewards = nil
  self.storeDict = nil
  self.lastReceiveFreeTime = nil
  self.dayReward = nil
  self.boosReward = nil
  self.weakReward = nil
  self.activityFreeRewardData = nil
  self.isBoss = nil
  self.bossBlood = nil
  self.bossWeakHp = nil
  self.bossReceive = nil
  self.bossDamage = nil
  self.bossWeakReceiveTimes = nil
  self.damageReward = nil
  self.isDamageRewardDataComplete = nil
  self.autoEventList = nil
  self.autoDiceNum = nil
  self.autoDiceDoubleNum = nil
  self.autoDiceCost = nil
  self.autoDiceDiamond = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.activityId ~= nil then
    self.activityId = message.activityId
  end
  if message.achieveActivityId ~= nil then
    self.achieveActivityId = message.achieveActivityId
  end
  if message.extra then
    if message.extra.cycle ~= nil then
      self.cycle = message.extra.cycle
    end
    if message.extra.nowGrid ~= nil then
      self.nowGrid = message.extra.nowGrid
    end
    if message.extra.freeNormalDice ~= nil then
      self.freeNormalDice = message.extra.freeNormalDice
    end
    if message.extra.freeHighDice ~= nil then
      self.freeHighDice = message.extra.freeHighDice
    end
    if message.extra.backUpTimes ~= nil then
      self.backUpTimes = message.extra.backUpTimes
    end
    if message.extra.nextItemGridAddExp ~= nil then
      self.nextItemGridAddExp = message.extra.nextItemGridAddExp
    end
    if message.extra.gridList ~= nil then
      self.gridList = message.extra.gridList
    end
    if message.extra.boxGrid ~= nil then
      self.boxGrid = message.extra.boxGrid
    end
    if message.extra.autoDiceNum ~= nil then
      self.autoDiceNum = message.extra.autoDiceNum
    else
      self.autoDiceNum = 0
    end
    if message.extra.autoDiceDoubleNum ~= nil then
      self.autoDiceDoubleNum = message.extra.autoDiceDoubleNum
    else
      self.autoDiceDoubleNum = 0
    end
    if message.extra.autoDiceCost ~= nil then
      self.autoDiceCost = message.extra.autoDiceCost
    else
      self.autoDiceCost = 0
    end
    if message.extra.autoDiceDiamond ~= nil then
      self.autoDiceDiamond = message.extra.autoDiceDiamond
    else
      self.autoDiceDiamond = 0
    end
    if message.extra.isBoos ~= nil then
      self.isBoss = message.extra.isBoos
    end
    if message.extra.bossBlood ~= nil then
      self.bossBlood = message.extra.bossBlood
    end
    if message.extra.bossWeakHp ~= nil then
      self.bossWeakHp = message.extra.bossWeakHp
    end
    if message.extra.bossReceive ~= nil then
      self.bossReceive = {}
      for _, v in ipairs(message.extra.bossReceive) do
        self.bossReceive[v] = 1
      end
    end
    if message.extra.bossDamage ~= nil then
      local msgData = message.extra.bossDamage
      self.bossDamage = {}
      for k, v in pairs(msgData) do
        local useKey = tonumber(k)
        self.bossDamage[useKey] = v
      end
    end
    if message.extra.bossWeakReceiveTimes ~= nil then
      self.bossWeakReceiveTimes = message.extra.bossWeakReceiveTimes
    end
    if message.extra.damageTotalRewards ~= nil then
      self.damageReward = message.extra.damageTotalRewards
      self.isDamageRewardDataComplete = true
    end
    if message.extra.autoEventList ~= nil then
      local autoEventListData = message.extra.autoEventList
      self.autoEventList = {}
      for _, v in ipairs(autoEventListData) do
        table.insert(self.autoEventList, tonumber(v))
      end
    end
  end
  if message.minStoreEndTime ~= nil then
    self.minStoreEndTime = message.minStoreEndTime
  end
  if message.group ~= nil then
    self.group = message.group
  end
  if message.richManGridRewards ~= nil then
    self.richManGridRewards = message.richManGridRewards
  end
  if message.lastReceiveFreeTime ~= nil then
    self.lastReceiveFreeTime = message.lastReceiveFreeTime
  end
  if message.dayReward ~= nil then
    self.dayReward = message.dayReward
  end
  if message.boosReward ~= nil then
    self.boosReward = message.boosReward
  end
  if message.weakReward ~= nil then
    self.weakReward = message.weakReward
  end
  self:UpdateActivityFreeRewardData()
end

local function GetGridItemDatabyIndex(self, index)
  local data
  if self.gridList and self.gridList[index] then
    data = self.gridList[index]
  else
    data = {lv = 1, exp = 0}
  end
  return data
end

local function OnGetShopListDataMsg(self, msg)
  self.storeDict = {}
  if msg.storeArr and #msg.storeArr > 0 then
    for k, v in ipairs(msg.storeArr) do
      local storeKey = v.storeKey
      self.storeDict[storeKey] = v
    end
  end
end

local function AddShopData(self, shopData)
  if shopData then
    if self.storeDict == nil then
      self.storeDict = {}
    end
    local storeKey = shopData.storeKey
    self.storeDict[storeKey] = shopData
  end
end

local function UpdateShopItem(self, data)
  local storeKey = data.storeKey
  if self.storeDict and self.storeDict[storeKey] then
    local storeData = self.storeDict[storeKey]
    for k, v in ipairs(storeData.shopArr) do
      if v.id == data.shopId then
        v.num = data.num
        break
      end
    end
  end
end

local function GetShopShowListData(self)
  local showListData = {}
  showListData = {
    dataArr = {},
    refreshTime = -1
  }
  local curTime = UITimeManager:GetInstance():GetServerTime() / 1000
  if self.storeDict then
    for k, v in pairs(self.storeDict) do
      if curTime < v.endTime then
        local isHaveCanBuy = false
        for _, shopItemData in ipairs(v.shopArr) do
          if shopItemData.buy_times > shopItemData.num then
            isHaveCanBuy = true
            break
          end
        end
        if isHaveCanBuy then
          table.insert(showListData.dataArr, v)
          table.sort(v.shopArr, function(a, b)
            return a.order < b.order
          end)
          if showListData.refreshTime < 0 then
            showListData.refreshTime = v.endTime
          end
          if v.endTime < showListData.refreshTime then
            showListData.refreshTime = v.endTime
          end
        end
      end
    end
    table.sort(showListData.dataArr, function(a, b)
      return a.endTime < b.endTime
    end)
  end
  return showListData
end

local function UpdateDailyRewardData(self, message)
  if message.lastReceiveFreeTime ~= nil then
    self.lastReceiveFreeTime = message.lastReceiveFreeTime
  end
  self:UpdateActivityFreeRewardData()
end

local function UpdateActivityFreeRewardData(self)
  self.activityFreeRewardData.activityId = self.activityId
  self.activityFreeRewardData.freeReward = DataCenter.RewardManager:ReturnRewardParamForView(self.dayReward)
  self.activityFreeRewardData.lastReceiveFreeTime = self.lastReceiveFreeTime * 1000
  self.rewardPackGroupId = self:GetGiftPackId()
end

local function CanGetDailyReward(self)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local result = not UITimeManager:GetInstance():IsSameDayForServer(self.lastReceiveFreeTime, curTime)
  return result
end

local function CanGetFreePack(self)
  return self:CanGetDailyReward()
end

local function CanGotoPackShop(self)
  local canGetFreePack = self:CanGetFreePack()
  if canGetFreePack then
    return true
  end
  local rewardPackGroupId = self:GetGiftPackId()
  local packs = GiftPackManager.GetPacksByGroupId(rewardPackGroupId, false)
  return not table.IsNullOrEmpty(packs)
end

local function GetGiftPackId(self)
  local rewardPackGroupId = 0
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local dataStr = activityInfo.para_6
  local dataArr = string.string2array_i_oneSep(dataStr, ";")
  if #dataArr == 2 then
    rewardPackGroupId = dataArr[2]
  end
  return rewardPackGroupId
end

local function GetRedNum(self)
  local num = 0
  local tipNum = 0
  tipNum = tipNum + self.freeNormalDice + self.freeHighDice
  local targetActId = tonumber(self.achieveActivityId)
  local curTaskRedNum = DataCenter.ActTaskManager:GetRedNum(targetActId)
  num = num + curTaskRedNum
  local canGetFreePack = self:CanGetFreePack()
  if canGetFreePack then
    num = num + 1
  end
  local isOpenBoss = self:IsOpenBoss()
  if isOpenBoss then
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    local bossTempId = tonumber(activityInfo.boss_type)
    local bossTemp = DataCenter.ActMonopolyDataManager:GetMonopolyBossTempById(bossTempId)
    local curBossState = self:GetBossState()
    if curBossState == ActMonopolyBossState.Normal then
      local curHp = self.bossBlood
      local rewardNum = #bossTemp.bullet_boss_hp_list
      for i = 1, rewardNum do
        local needHp = bossTemp.bullet_boss_hp_list[i]
        local serverIndex = i - 1
        local isHaveGet = self.bossReceive[serverIndex] ~= nil
        if curHp <= needHp and not isHaveGet then
          num = num + 1
        end
      end
    elseif curBossState == ActMonopolyBossState.Weak then
      local totalFightHp = self.bossWeakHp
      local canGetNum = math.floor(totalFightHp / bossTemp.bullet_boss_hp_weak)
      local canGetNumMax = bossTemp.bullet_boss_reward_limit_num
      if canGetNum > canGetNumMax then
        canGetNum = canGetNumMax
      end
      local haveGetNum = self.bossWeakReceiveTimes
      local redNum = canGetNum - haveGetNum
      num = num + redNum
    end
  end
  if 0 < #self.damageReward then
    num = num + 1
  end
  local ItemUseRedNum = self:GetItemUseRedNum()
  tipNum = tipNum + ItemUseRedNum
  return num + tipNum, num, tipNum
end

local function GetItemUseRedNum(self)
  local num = 0
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityInfo == nil then
    return num
  end
  local paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(activityInfo.richman_para)
  if paraTemp == nil then
    return num
  end
  local usebox_list = paraTemp.usebox_list
  for _, v in ipairs(usebox_list) do
    local goodsId = v
    local curNum = DataCenter.ItemData:GetItemCount(goodsId)
    if 0 < curNum then
      num = 1
      break
    end
  end
  return num
end

local function IsOpenBoss(self)
  local result = self.isBoss > 0
  return result
end

local function GetBossState(self)
  local result = self.bossBlood > 0 and ActMonopolyBossState.Normal or ActMonopolyBossState.Weak
  return result
end

local function GetBossStageRewardMsg(self, data)
  local index = data.index
  self.bossReceive[index] = 1
end

local function GetBossWeakRewardMsg(self, data)
  self.bossWeakReceiveTimes = data.weakReceiveTimes
end

local function OnGetDamageDataMsg(self, data)
  self.bossBlood = data.blood
  self.bossWeakHp = data.weakHp
  if data.damageReward ~= nil then
    for _, v in ipairs(data.damageReward) do
      table.insert(self.damageReward, v)
    end
    self.isDamageRewardDataComplete = false
  end
end

local function OnGetDamageRewardMsg(self, data)
  self.damageReward = {}
  self.isDamageRewardDataComplete = true
end

local function OnAddDamageReward(self, reward)
  if reward ~= nil then
    for _, v in ipairs(reward) do
      table.insert(self.damageReward, v)
    end
    self.isDamageRewardDataComplete = false
  end
end

local function OnAddAutoEvent(self, eventId)
  table.insert(self.autoEventList, eventId)
end

local function OnReceiveAutoEvent(self, eventId)
  local removeIndex = -1
  for i, v in ipairs(self.autoEventList) do
    if v == eventId then
      removeIndex = i
      break
    end
  end
  if 0 < removeIndex then
    table.remove(self.autoEventList, removeIndex)
  end
end

local function SetDamageRewardData(self, data)
  self.damageReward = data
  self.isDamageRewardDataComplete = true
end

local function GetAutoEventShowData(self)
  local showDataList = {}
  local showDataDict = {}
  for _, eventId in ipairs(self.autoEventList) do
    local line = LocalController:instance():getLine(TableName.RichManEvent, eventId)
    if line then
      local showTag = tonumber(line.entrance_order) or 0
      if showDataDict[showTag] == nil then
        showDataDict[showTag] = {}
      end
      table.insert(showDataDict[showTag], line)
    end
  end
  for k, v in pairs(showDataDict) do
    table.insert(showDataList, {tag = k, data = v})
  end
  table.sort(showDataList, function(a, b)
    return a.tag < b.tag
  end)
  return showDataList
end

ActMonopolyData.__init = __init
ActMonopolyData.__delete = __delete
ActMonopolyData.ParseData = ParseData
ActMonopolyData.GetGridItemDatabyIndex = GetGridItemDatabyIndex
ActMonopolyData.OnGetShopListDataMsg = OnGetShopListDataMsg
ActMonopolyData.AddShopData = AddShopData
ActMonopolyData.UpdateShopItem = UpdateShopItem
ActMonopolyData.GetShopShowListData = GetShopShowListData
ActMonopolyData.GetAutoEventShowData = GetAutoEventShowData
ActMonopolyData.UpdateDailyRewardData = UpdateDailyRewardData
ActMonopolyData.UpdateActivityFreeRewardData = UpdateActivityFreeRewardData
ActMonopolyData.CanGetDailyReward = CanGetDailyReward
ActMonopolyData.CanGetFreePack = CanGetFreePack
ActMonopolyData.CanGotoPackShop = CanGotoPackShop
ActMonopolyData.GetGiftPackId = GetGiftPackId
ActMonopolyData.GetRedNum = GetRedNum
ActMonopolyData.IsOpenBoss = IsOpenBoss
ActMonopolyData.GetBossState = GetBossState
ActMonopolyData.GetBossStageRewardMsg = GetBossStageRewardMsg
ActMonopolyData.GetBossWeakRewardMsg = GetBossWeakRewardMsg
ActMonopolyData.OnGetDamageDataMsg = OnGetDamageDataMsg
ActMonopolyData.OnGetDamageRewardMsg = OnGetDamageRewardMsg
ActMonopolyData.OnAddDamageReward = OnAddDamageReward
ActMonopolyData.SetDamageRewardData = SetDamageRewardData
ActMonopolyData.GetItemUseRedNum = GetItemUseRedNum
ActMonopolyData.OnAddAutoEvent = OnAddAutoEvent
ActMonopolyData.OnReceiveAutoEvent = OnReceiveAutoEvent
return ActMonopolyData
