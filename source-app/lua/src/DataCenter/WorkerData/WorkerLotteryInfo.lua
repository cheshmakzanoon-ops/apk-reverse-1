local WorkerLotteryInfo = BaseClass("WorkerLotteryInfo")

local function __init(self)
  self.curNum = 0
  self.nextFreeTime = 0
end

local function __delete(self)
  self.curNum = nil
  self.nextFreeTime = nil
end

local function UpdateInfo(self, message)
  if message.curNum ~= nil then
    self.curNum = message.curNum
  end
  if message.nextFreeTime ~= nil then
    self.nextFreeTime = message.nextFreeTime
  end
end

local function GetCostItems(self)
  local costData = {}
  local oldItemId = LuaEntry.DataConfig:TryGetNum("worker_recruit_1", "k3", 0)
  local itemId = DataCenter.LotteryDataManager:GetOnlyWorkerLotteryCostItemId() or oldItemId
  costData[1] = {itemId = itemId, itemNum = 1}
  costData[2] = {itemId = itemId, itemNum = 10}
  return costData
end

local function CanFreeRecruit(self)
  local now = UITimeManager:GetInstance():GetServerSeconds()
  local canFreeRecruit = now >= self.nextFreeTime / 1000
  return canFreeRecruit
end

WorkerLotteryInfo.__init = __init
WorkerLotteryInfo.__delete = __delete
WorkerLotteryInfo.UpdateInfo = UpdateInfo
WorkerLotteryInfo.GetCostItems = GetCostItems
WorkerLotteryInfo.CanFreeRecruit = CanFreeRecruit
return WorkerLotteryInfo
