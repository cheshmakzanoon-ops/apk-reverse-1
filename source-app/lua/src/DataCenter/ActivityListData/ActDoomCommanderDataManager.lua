local ActDoomCommanderDataManager = BaseClass("ActDoomCommanderDataManager")

local function __init(self)
  self.defuseBombFinish = 0
  self.monopolyFinish = 0
  self.detectFinish = 0
  self.allStageReward = 0
  self.arenaV2Open = 0
  self.lockHartIsOpen = 0
  self.lockHartOpenTime = 0
  self.sortTask = {}
  for key, value in pairs(DoomCommanderTaskType) do
    self.sortTask[value] = {}
    self.sortTask[value].type = key
    self.sortTask[value].id = value
    self.sortTask[value].order = value
  end
  self:AddListener()
end

local function __delete(self)
  self.defuseBombFinish = nil
  self.monopolyFinish = nil
  self.detectFinish = nil
  self.allStageReward = nil
  self.arenaV2Open = nil
  self.lockHartIsOpen = nil
  self.lockHartOpenTime = nil
  self.sortTask = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function ParseServerData(self, message)
  if message then
    self.defuseBombFinish = message.defuseBombFinish
    self.monopolyFinish = message.monopolyFinish
    self.detectFinish = message.detectFinish
    self.allStageReward = message.allStageReward
    self.arenaV2Open = message.arenaV2Open
    self.lockHartIsOpen = message.lockHart.isOpen
    self.lockHartOpenTime = message.lockHart.openTime
    for index, value in ipairs(self.sortTask) do
      if value.id == DoomCommanderTaskType.Monopoly then
        value.order = self.monopolyFinish
      elseif value.id == DoomCommanderTaskType.Detect then
        value.order = self.detectFinish
      elseif value.id == DoomCommanderTaskType.AllStage then
        value.order = self.allStageReward
      elseif value.id == DoomCommanderTaskType.ArenaV2 then
        if self.arenaV2Open == 0 then
          value.order = 0.5
        elseif self.arenaV2Open == 1 then
          value.order = 0
        elseif self.arenaV2Open == 2 then
          value.order = 1
        end
      elseif value.id == DoomCommanderTaskType.LockHart then
        if self.lockHartIsOpen == 0 then
          value.order = 0.5
        elseif self.lockHartIsOpen == 1 then
          value.order = 0
        elseif self.lockHartIsOpen == 2 then
          value.order = 1
        end
      end
    end
    table.sort(self.sortTask, function(a, b)
      if a.order ~= b.order then
        return a.order < b.order
      else
        return a.id < b.id
      end
    end)
    EventManager:GetInstance():Broadcast(EventId.DoomCommanderRefresh)
  end
end

local function GetNormalDataByCfg(self, cfg)
  return string.split(cfg, ";")
end

local function GetActDataByCfg(self, cfg)
  local tab = string.split(cfg, "|")
  return tab[1], string.split(tab[2], ";")
end

local function GetTaskIdByOrder(self, order)
  return self.sortTask[order].id
end

ActDoomCommanderDataManager.__init = __init
ActDoomCommanderDataManager.__delete = __delete
ActDoomCommanderDataManager.AddListener = AddListener
ActDoomCommanderDataManager.RemoveListener = RemoveListener
ActDoomCommanderDataManager.ParseServerData = ParseServerData
ActDoomCommanderDataManager.GetNormalDataByCfg = GetNormalDataByCfg
ActDoomCommanderDataManager.GetActDataByCfg = GetActDataByCfg
ActDoomCommanderDataManager.GetTaskIdByOrder = GetTaskIdByOrder
return ActDoomCommanderDataManager
