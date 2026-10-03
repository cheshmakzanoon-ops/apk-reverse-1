local ParkourManager = BaseClass("ParkourManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.lastPassTime = 0
  self.curStageId = 0
  self.passStageId = 0
end

local function __delete(self)
end

local function InitData(self, message)
  if message.stageFeatureInfo ~= nil then
    local u = message.stageFeatureInfo
    local id = tonumber(u.stageId)
    local time = tonumber(u.featureRewardTimeStamp)
    self:ProcessData(id, time)
  else
    self:ProcessData(0, 0)
  end
end

local function UpdateCountData(self, stageId, reward)
  self.countReward = reward
  self.countRewardStageId = stageId
end

local function UpdateData(self, stageId, time, reward)
  self:ProcessData(stageId, time)
  self.reward = reward
  self.rewardStageId = stageId
end

local function ProcessData(self, stageId, time)
  self.lastPassTime = time
  self.curStageId = math.max(stageId, self.curStageId)
  self.passStageId = math.max(stageId, self.passStageId)
  local meta = {}
  local curOrder = 0
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), function(id, lineData)
    local cfgId = lineData:getValue("id")
    local cfgOrder = lineData:getValue("order")
    if 0 < stageId and cfgId == stageId then
      curOrder = cfgOrder
    end
    table.insert(meta, {id = cfgId, order = cfgOrder})
  end)
  table.sort(meta, function(a, b)
    return a.order < b.order
  end)
  for _, lineData in ipairs(meta) do
    if curOrder < lineData.order then
      self.curStageId = math.max(self.curStageId, lineData.id)
      break
    end
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateParkourStage)
end

local function AlreadyPass(self, id)
  return id < self.curStageId
end

ParkourManager.__init = __init
ParkourManager.__delete = __delete
ParkourManager.InitData = InitData
ParkourManager.UpdateData = UpdateData
ParkourManager.UpdateCountData = UpdateCountData
ParkourManager.ProcessData = ProcessData
ParkourManager.AlreadyPass = AlreadyPass
return ParkourManager
