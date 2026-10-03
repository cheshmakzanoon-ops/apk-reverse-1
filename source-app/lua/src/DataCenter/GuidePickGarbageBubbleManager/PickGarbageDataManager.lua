local PickGarbageDataManager = BaseClass("PickGarbageDataManager")

local function __init(self)
  self:AddListener()
  self.pickGarbageQueue = {}
  self.currentPickStartTime = 0
  self.currentPickEndTime = 0
end

local function __delete(self)
  self:RemoveListener()
  self.pickGarbageQueue = nil
  self.currentPickStartTime = nil
  self.currentPickEndTime = nil
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function AddIndexToGarbageQueue(self, index)
  for _, v in ipairs(self.pickGarbageQueue) do
    if v == index then
      return false
    end
  end
  table.insert(self.pickGarbageQueue, index)
  if #self.pickGarbageQueue == 1 then
  else
    DataCenter.GuidePickGarbageBubbleManager:AddPickQueue(index)
  end
  return true
end

local function RemoveFromGarbageQueue(self, index)
  if index == -1 then
    self:RemoveAllFromQueue()
  else
    self:RemoveFirstIndexFromGarbageQueue()
    if #self.pickGarbageQueue > 0 then
      DataCenter.GuidePickGarbageBubbleManager:RemovePickQueue(self:GetCurrentPickIndex())
    else
      DataCenter.GuidePickGarbageBubbleManager:RemovePickProgress()
    end
  end
end

local function RemoveFirstIndexFromGarbageQueue(self)
  local result
  if #self.pickGarbageQueue > 0 then
    result = self.pickGarbageQueue[1]
    table.remove(self.pickGarbageQueue, 1)
  end
  return result
end

local function RemoveAllFromQueue(self)
  table.walk(self.pickGarbageQueue, function(_, v)
    DataCenter.GuidePickGarbageBubbleManager:RemovePickQueue(v)
  end)
  DataCenter.GuidePickGarbageBubbleManager:RemovePickProgress()
  self.pickGarbageQueue = {}
end

local function SetTime(self, startTime, endTime)
  local now = UITimeManager:GetInstance():GetServerTime()
  self.currentPickStartTime = startTime * 1000 + now
  self.currentPickEndTime = endTime * 1000 + now + 1000
  DataCenter.GuidePickGarbageBubbleManager:RefreshPickProgress()
end

local function RefreshTime(self)
end

local function GetCurrentPickIndex(self)
  if #self.pickGarbageQueue > 0 then
    return self.pickGarbageQueue[1]
  end
  return -1
end

PickGarbageDataManager.__init = __init
PickGarbageDataManager.__delete = __delete
PickGarbageDataManager.AddListener = AddListener
PickGarbageDataManager.RemoveListener = RemoveListener
PickGarbageDataManager.AddIndexToGarbageQueue = AddIndexToGarbageQueue
PickGarbageDataManager.RemoveFirstIndexFromGarbageQueue = RemoveFirstIndexFromGarbageQueue
PickGarbageDataManager.RefreshTime = RefreshTime
PickGarbageDataManager.SetTime = SetTime
PickGarbageDataManager.RemoveAllFromQueue = RemoveAllFromQueue
PickGarbageDataManager.GetCurrentPickIndex = GetCurrentPickIndex
PickGarbageDataManager.RemoveFromGarbageQueue = RemoveFromGarbageQueue
return PickGarbageDataManager
