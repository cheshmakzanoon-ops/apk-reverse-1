local RadarFakeUIMarchData_CollectGarbage = require("DataCenter.RadarCenterDataManager.RadarFakeUIMarch.UIMarchData.RadarFakeUIMarchData_CollectGarbage")
local RadarFakeUIMarchData_Help = require("DataCenter.RadarCenterDataManager.RadarFakeUIMarch.UIMarchData.RadarFakeUIMarchData_Help")
local RadarFakeUIMarchData_SeasonVisitor = require("DataCenter.RadarCenterDataManager.RadarFakeUIMarch.UIMarchData.RadarFakeUIMarchData_SeasonVisitor")
local RadarFakeUIMarchManager = BaseClass("RadarFakeUIMarchManager")

function RadarFakeUIMarchManager:__init()
  self.uiMarches = {}
  
  function self.tickAction()
    self:Tick()
  end
  
  self.ClaimingTasks = {}
  self.MarchedTasks = {}
end

function RadarFakeUIMarchManager:__delete()
  self.uiMarches = {}
  self.tickAction = nil
  self.ClaimingTasks = {}
end

function RadarFakeUIMarchManager:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.tickAction, self, false, false, false)
    self.timer:Start()
  end
end

function RadarFakeUIMarchManager:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function RadarFakeUIMarchManager:Tick()
  local removeList = {}
  if not table.IsNullOrEmpty(self.uiMarches) then
    for uuid, marchData in pairs(self.uiMarches) do
      marchData:TryEnd()
      if marchData:NeedRemove() then
        table.insert(removeList, uuid)
      end
    end
  end
  if not table.IsNullOrEmpty(removeList) then
    for _, uuid in pairs(removeList) do
      if self.uiMarches[uuid] ~= nil then
        self.uiMarches[uuid]:Remove()
      end
      self.uiMarches[uuid] = nil
    end
  end
  if table.count(self.uiMarches) == 0 then
    self:RemoveTimer()
  end
end

function RadarFakeUIMarchManager:StartUIMarch(eventData)
  if eventData == nil then
    return 0, 0
  end
  local uuid = checknumber(eventData.uuid)
  self.MarchedTasks[uuid] = true
  if self.uiMarches[uuid] ~= nil then
    return 0, 0
  end
  local data
  local radarType = eventData.template.type
  if radarType == DetectEventType.DetectEventPickGarbage or radarType == DetectEventType.DOMINATOR_CURE then
    data = RadarFakeUIMarchData_CollectGarbage.New()
  elseif radarType == DetectEventType.HELPER then
    data = RadarFakeUIMarchData_Help.New()
  elseif radarType == DetectEventType.SEASON_VISITOR then
    data = RadarFakeUIMarchData_SeasonVisitor.New()
  end
  local startTime, endTime = 0, 0
  if data ~= nil and data:Init(eventData) then
    self.uiMarches[uuid] = data
    startTime, endTime = data:Start()
    self:AddTimer()
  end
  return startTime, endTime
end

function RadarFakeUIMarchManager:IsDoing(uuid)
  uuid = checknumber(uuid)
  if self.uiMarches[uuid] ~= nil then
    return self.uiMarches[uuid]:IsEventDoing()
  end
  return false
end

function RadarFakeUIMarchManager:IsAnyDoing()
  if not table.IsNullOrEmpty(self.uiMarches) then
    for _, marchData in pairs(self.uiMarches) do
      if marchData:IsEventDoing() then
        return true
      end
    end
  end
  return false
end

function RadarFakeUIMarchManager:FinishAll()
  if not table.IsNullOrEmpty(self.uiMarches) then
    for _, marchData in pairs(self.uiMarches) do
      marchData:TryEnd(true)
      marchData:Remove()
    end
  end
  self.uiMarches = {}
  self:RemoveTimer()
end

function RadarFakeUIMarchManager:IsFuncOpen()
  local isOpen = LuaEntry.DataConfig:CheckSwitch("radar_quick_operation_switch")
  if not isOpen then
    return false
  end
  return FunctionSeasonUtil.IsFuncOpen(FunctionSeasonUtil.FuncType.RadarQuickFinish)
end

function RadarFakeUIMarchManager:NeedConfirm()
  local level = LuaEntry.DataConfig:TryGetNum("detect_quick_finish_config", "k4", 0)
  local curLevel = LuaEntry.Player.level
  if level > curLevel then
    return false
  end
  local weekConfig = LuaEntry.DataConfig:TryGetStr("detect_quick_finish_config", "k3", "")
  local weeks = string.split(weekConfig, ";")
  local curWeek = UITimeManager:GetInstance():GetWeekdayIndex(UITimeManager:GetInstance():GetServerTime())
  return table.hasvalue(weeks, checkstring(curWeek))
end

function RadarFakeUIMarchManager:TryPlot()
  if not self:IsFuncOpen() then
    return
  end
  local hasPlot = CommonUtil.PlayerPrefsGetBool(SettingKeys.RADAR_QUICK_DO_PLOT, false)
  if not hasPlot then
    CommonUtil.PlayerPrefsSetBool(SettingKeys.RADAR_QUICK_DO_PLOT, true)
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = 9295, hideMainUI = false})
  end
end

function RadarFakeUIMarchManager:AddClaimingTasks(taskUuids)
  self.ClaimingTasks = self.ClaimingTasks or {}
  for _, taskUuid in pairs(taskUuids) do
    self:AddClaimingTask(taskUuid)
  end
end

function RadarFakeUIMarchManager:AddClaimingTask(taskUuid)
  self.ClaimingTasks = self.ClaimingTasks or {}
  self.ClaimingTasks[checknumber(taskUuid)] = true
end

function RadarFakeUIMarchManager:RemoveClaimingTask(taskUuid)
  taskUuid = checknumber(taskUuid)
  if taskUuid == -1 then
    self.ClaimingTasks = {}
    return
  end
  self.ClaimingTasks[taskUuid] = false
end

function RadarFakeUIMarchManager:IsClaiming(taskUuid)
  taskUuid = checknumber(taskUuid)
  return self.ClaimingTasks[taskUuid] or false
end

function RadarFakeUIMarchManager:IsMarched(taskUuid)
  taskUuid = checknumber(taskUuid)
  return self.MarchedTasks[taskUuid] or false
end

function RadarFakeUIMarchManager:RemoveMarchedTask(taskUuid)
  taskUuid = checknumber(taskUuid)
  if taskUuid == -1 then
    self.MarchedTasks = {}
    return
  end
  self.MarchedTasks[taskUuid] = false
end

return RadarFakeUIMarchManager
