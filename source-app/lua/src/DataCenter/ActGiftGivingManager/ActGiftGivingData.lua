local ActGiftGivingData = BaseClass("ActGiftGivingData")
local DataExpiredTime = 10000

local function __init(self)
  self.activityId = 0
  self.givePlayers = {}
  self.totalAmount = 0
  self.receiveDict = {}
  self.givePlayersDataExpiredTime = 0
end

local function __delete(self)
  self.activityId = nil
  self.givePlayers = nil
  self.totalAmount = nil
  self.receiveDict = nil
  self.givePlayersDataExpiredTime = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.activityId ~= nil then
    self.activityId = message.activityId
  end
  if message.givePlayers ~= nil then
    self.givePlayers = message.givePlayers
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.givePlayersDataExpiredTime = curTime + DataExpiredTime
  end
  if message.totalAmount ~= nil then
    self.totalAmount = message.totalAmount
  end
  if message.receiveArr ~= nil then
    self.receiveDict = {}
    for k, v in pairs(message.receiveArr) do
      self.receiveDict[v] = true
    end
  end
end

local function GetRedNum(self)
  local num = 0
  local tipNum = 0
  local targetIndex = DataCenter.ActGiftGivingDataManager:GetRewardTargetIndex(self.activityId)
  if 0 < targetIndex then
    num = num + 1
  end
  local canCookNum = self:GetCanCookNum()
  if 0 < canCookNum then
    tipNum = tipNum + 1
  end
  return num + tipNum, num, tipNum
end

local function GetCanCookNum(self)
  local num = 0
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityInfo == nil then
    return num
  end
  local activityTemp = DataCenter.ActGiftGivingDataManager:GetTempByActInfo(activityInfo)
  local costItemId = activityTemp.merge_cost_item_tab[1]
  local costItemNum = activityTemp.merge_cost_item_tab[2]
  local curNum = DataCenter.ItemData:GetItemCount(costItemId)
  num = math.floor(curNum / costItemNum)
  return num
end

local function ReceiveGiveRewardeMsg(self, message)
  local getIndex = message.index
  self.receiveDict[getIndex] = true
end

local function ReceiveRecommendeMsg(self, message)
  self.givePlayers = message.givePlayers
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.givePlayersDataExpiredTime = curTime + DataExpiredTime
end

local function CheckIsGivePlayersDataExpired(self)
  local isExpired = false
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.givePlayersDataExpiredTime then
    isExpired = true
  end
  return isExpired
end

ActGiftGivingData.__init = __init
ActGiftGivingData.__delete = __delete
ActGiftGivingData.ParseData = ParseData
ActGiftGivingData.GetRedNum = GetRedNum
ActGiftGivingData.ReceiveGiveRewardeMsg = ReceiveGiveRewardeMsg
ActGiftGivingData.ReceiveRecommendeMsg = ReceiveRecommendeMsg
ActGiftGivingData.CheckIsGivePlayersDataExpired = CheckIsGivePlayersDataExpired
ActGiftGivingData.GetCanCookNum = GetCanCookNum
return ActGiftGivingData
