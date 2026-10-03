local WorkerLotteryDataManager = BaseClass("WorkerLotteryDataManager")
local WorkerLotteryInfo = require("DataCenter.WorkerData.WorkerLotteryInfo")

local function __init(self)
  self.workerLottery = nil
end

local function __delete(self)
  self.workerLottery = nil
end

local function UpdateWorkerLotteryData(self, message)
  if self.workerLottery == nil then
    self.workerLottery = WorkerLotteryInfo.New()
  end
  self.workerLottery:UpdateInfo(message)
end

local function GetWorkerLotteryData(self)
  if self.workerLottery ~= nil then
    local returnRes = {}
    returnRes = DeepCopy(self.workerLottery)
    return returnRes
  end
  return nil
end

local function IsHaveWorkerLotteryData(self)
  if self.workerLottery ~= nil then
    return true
  else
    return false
  end
end

WorkerLotteryDataManager.__init = __init
WorkerLotteryDataManager.__delete = __delete
WorkerLotteryDataManager.UpdateWorkerLotteryData = UpdateWorkerLotteryData
WorkerLotteryDataManager.GetWorkerLotteryData = GetWorkerLotteryData
WorkerLotteryDataManager.IsHaveWorkerLotteryData = IsHaveWorkerLotteryData
return WorkerLotteryDataManager
