local AllianceWarEventDataManager = BaseClass("AllianceWarEventDataManager")
local rapidjson = require("rapidjson")
local AllianceWarEventData = require("DataCenter.AllianceData.AllianceWarEventData")

function AllianceWarEventDataManager:__init()
  self.allData = {}
end

function AllianceWarEventDataManager:__delete()
  self:RemoveUpdateTimer()
  self.allData = nil
  self.allTemplate = nil
  self.noMoreReminds = nil
end

function AllianceWarEventDataManager:OnEnterGame()
  self:PullWarEventData()
end

function AllianceWarEventDataManager:PullWarEventData()
  SFSNetwork.SendMessage(MsgDefines.GetAllianceWarEvents)
end

function AllianceWarEventDataManager:HandleGetAllianceWarEventsMessage(events)
  local oldData = self.allData
  self.allData = {}
  for k, event in pairs(events) do
    local uuid = AllianceWarEventData.CreateUuid(event)
    if oldData[uuid] then
      self.allData[uuid] = oldData[uuid]:ParseServerData(event)
      oldData[uuid] = nil
    else
      local data = AllianceWarEventData.New(event)
      if data.template then
        self.allData[uuid] = data
      else
        data:Destroy()
      end
    end
  end
  for _, v in pairs(oldData) do
    v:Destroy()
  end
  oldData = nil
  if self.noMoreReminds then
    for k, v in pairs(self.noMoreReminds) do
      if not self.allData[k] then
        self.noMoreReminds[k] = nil
      end
    end
  else
    self.noMoreReminds = {}
  end
  self:SaveReminder("uuid", true)
  EventManager:GetInstance():Broadcast(EventId.AllianceWarEventRefresh)
  self:SetAutoPull()
end

function AllianceWarEventDataManager:HandlePushAllianceWarEventChangeMessage(event)
  local uuid = AllianceWarEventData.CreateUuid(event)
  if self.allData[uuid] then
    self.allData[uuid]:ParseServerData(event)
    EventManager:GetInstance():Broadcast(EventId.AllianceWarEventRefresh)
    self:SetAutoPull()
  else
    local data = AllianceWarEventData.New(event)
    if data.template then
      self.allData[data.uuid] = data
      EventManager:GetInstance():Broadcast(EventId.AllianceWarEventRefresh)
      self:SetAutoPull()
    else
      data:Destroy()
    end
  end
end

function AllianceWarEventDataManager:SetAutoPull()
  if table.count(self.allData) > 0 then
    local min = UITimeManager:GetInstance():GetServerTime() + 60000
    for _, v in pairs(self.allData) do
      if min > v.endTime then
        min = v.endTime
      end
    end
    self.minEndTime = min + 1000
    self:AddUpdateTimer()
  else
    self.minEndTime = nil
    self:RemoveUpdateTimer()
  end
end

function AllianceWarEventDataManager:Update1000MS()
  if self.minEndTime and self.minEndTime < UITimeManager:GetInstance():GetServerTime() then
    self:PullWarEventData()
  end
end

function AllianceWarEventDataManager:AddUpdateTimer()
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.Update1000MS, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

function AllianceWarEventDataManager:RemoveUpdateTimer()
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function AllianceWarEventDataManager:GetTemplateByType(type)
  if self.allTemplate == nil then
    self.allTemplate = {}
    LocalController:instance():visitTable(TableName.Alliance_War_Notice, function(id, lineData)
      if lineData and lineData.open == 1 then
        self.allTemplate[lineData.type] = {
          name = lineData.name,
          type = lineData.type,
          desc = lineData.desc,
          weight = lineData.weight,
          bubble = lineData.bubble,
          time_help = lineData.time_help,
          icon_animation = lineData.icon_animation,
          icon = lineData.icon
        }
      end
    end)
  end
  return self.allTemplate[type]
end

function AllianceWarEventDataManager:GetWarEventsDict()
  return self.allData
end

function AllianceWarEventDataManager:CheckHasReminder()
  for _, v in pairs(self.allData) do
    if v.reminder then
      return true
    end
  end
  return false
end

function AllianceWarEventDataManager:GetBubbleWarEvent()
  local needShow = {}
  for _, v in pairs(self.allData) do
    if v.reminder and not v.seen then
      table.insert(needShow, v)
    end
  end
  if #needShow == 0 then
    return nil
  end
  table.sort(needShow, function(a, b)
    if a.template.weight ~= b.template.weight then
      return a.template.weight > b.template.weight
    else
      return a.endTime - a.startTime < b.endTime - b.startTime
    end
  end)
  return needShow[1]
end

function AllianceWarEventDataManager:LoadReminder(uuid)
  if self.noMoreReminds == nil then
    local reminderStr = CS.GameEntry.Setting:GetString("AllianceWarEventReminder", "")
    local rem = string.split(reminderStr, ",")
    self.noMoreReminds = {}
    for _, v in pairs(rem) do
      self.noMoreReminds[v] = true
    end
  end
  return not self.noMoreReminds[uuid]
end

function AllianceWarEventDataManager:SaveReminder(uuid, bool)
  if self.noMoreReminds == nil then
    self.noMoreReminds = {}
  end
  if bool then
    self.noMoreReminds[uuid] = nil
  else
    self.noMoreReminds[uuid] = true
  end
  local rem = {}
  for k, v in pairs(self.noMoreReminds) do
    if v then
      table.insert(rem, k)
    end
  end
  local reminderStr = table.concat(rem, ",")
  CS.GameEntry.Setting:SetString("AllianceWarEventReminder", reminderStr)
end

return AllianceWarEventDataManager
