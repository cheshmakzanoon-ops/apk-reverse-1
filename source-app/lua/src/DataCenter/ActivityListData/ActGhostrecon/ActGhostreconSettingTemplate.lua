local ActGhostreconSettingTemplate = BaseClass("ActGhostreconSettingTemplate")

local function __init(self)
  self.lvInterval = {}
  self.maxTaskQueue = 0
  self.teamworkCount = 0
  self.stealCount = 0
end

local function __delete(self)
  self.lvInterval = nil
  self.maxTaskQueue = nil
  self.teamworkCount = nil
  self.stealCount = nil
end

local function InitData(self, cfg)
  local lvInterval = string.split(cfg.baselv, "-")
  self.lvInterval[1] = tonumber(lvInterval[1])
  self.lvInterval[2] = tonumber(lvInterval[2])
  self.maxTaskQueue = cfg.max_taskQueue
  self.teamworkCount = cfg.teamwork_count
  self.stealCount = cfg.steal_count
end

local function CheckInInterval(self)
  local mainlv = DataCenter.BuildManager.MainLv
  return mainlv >= self.lvInterval[1] and mainlv <= self.lvInterval[2]
end

ActGhostreconSettingTemplate.__init = __init
ActGhostreconSettingTemplate.__delete = __delete
ActGhostreconSettingTemplate.InitData = InitData
ActGhostreconSettingTemplate.CheckInInterval = CheckInInterval
return ActGhostreconSettingTemplate
