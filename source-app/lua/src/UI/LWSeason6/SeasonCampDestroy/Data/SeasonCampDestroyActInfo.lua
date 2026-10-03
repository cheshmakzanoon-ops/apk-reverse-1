local SeasonCampDestroyActInfo = BaseClass("SeasonCampDestroyActInfo")
local SeasonCampDestroyServerInfo = require("UI.LWSeason6.SeasonCampDestroy.Data.SeasonCampDestroyServerInfo")
local SeasonCampDestroyCampInfo = require("UI.LWSeason6.SeasonCampDestroy.Data.SeasonCampDestroyCampInfo")
local SeasonCampDestroyTimeInfo = require("UI.LWSeason6.SeasonCampDestroy.Data.SeasonCampDestroyTimeInfo")
local SeasonCampDestroyDeclareTarget = require("UI.LWSeason6.SeasonCampDestroy.Data.SeasonCampDestroyDeclareTarget")

function SeasonCampDestroyActInfo:__init(mgr)
  self.mgr = mgr
  self.timeMgr = UITimeManager:GetInstance()
  self.actEndTime = 0
  self.camps = {}
  self.servers = {}
  self.idx2server = {}
  self.sid2server = {}
  self.myServerInfo = nil
  self.timeInfo = SeasonCampDestroyTimeInfo.New()
  self.isDeclareWarDay = false
  self.currEndTime = 0
  self.nextOpenTime = 0
  self.declareList = {}
  self.beDeclareList = {}
end

function SeasonCampDestroyActInfo:__delete()
  self.mgr = nil
  self.timeMgr = nil
  if self.timeInfo then
    self.timeInfo:Delete()
    self.timeInfo = nil
  end
  if self.camps then
    for k, v in pairs(self.camps) do
      v:Delete()
    end
    self.camps = nil
  end
  if self.declareList then
    for k, v in ipairs(self.declareList) do
      v:Delete()
    end
    self.declareList = nil
  end
  if self.beDeclareList then
    for k, v in ipairs(self.beDeclareList) do
      v:Delete()
    end
    self.beDeclareList = nil
  end
  if self.servers then
    for k, v in ipairs(self.servers) do
      v:Delete()
    end
    self.servers = nil
    self.idx2server = nil
    self.sid2server = nil
  end
  self.isDeclareWarDay = nil
  self.declareList = nil
  self.beDeclareList = nil
  self.warTimes = nil
end

function SeasonCampDestroyActInfo:RefreshActTime()
  if self.timeInfo then
    self.timeInfo:Refresh()
  end
end

function SeasonCampDestroyActInfo:GetCurrentBattleStage()
  if not self.timeInfo then
    return SeasonCampDestroyStage.None
  end
  self.timeInfo:Refresh()
  return self.timeInfo.currentBattleStage, self.timeInfo.rangeIndex
end

function SeasonCampDestroyActInfo:UpdateActInfo(msg, actId, actConfig)
  if not msg then
    return
  end
  if actId then
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
    if activityData and activityData.endTime then
      self.actEndTime = activityData.endTime
    else
      self.actEndTime = DataCenter.SeasonDataManager:GetSeasonEndTime()
    end
  end
  self.isDeclareWarDay = msg.isDeclareWarDay or false
  self.currEndTime = msg.currEndTime or 0
  self.nextOpenTime = msg.nextOpenTime or 0
  self:UpdateDeclareList(self.declareList, msg.declareList)
  self:UpdateDeclareList(self.beDeclareList, msg.beDeclareList)
  if msg.serverInfos and 0 < #msg.serverInfos then
    self:UpdateServerInfo(msg.serverInfos)
  else
    self:BuildServerInfoFromSeasonData()
  end
  if msg.campInfo and 0 < #msg.campInfo then
    self:UpdateCampInfo(msg.campInfo)
  else
    self:BuildCampInfoFromSeasonData()
  end
  self:RefreshActTime()
end

function SeasonCampDestroyActInfo:UpdateDeclareList(list, msgList)
  if not list then
    return
  end
  for k, v in ipairs(list) do
    v:Delete()
  end
  table.clear(list)
  if not msgList then
    return
  end
  for k, v in ipairs(msgList) do
    local target = SeasonCampDestroyDeclareTarget.New()
    target:Update(v)
    table.insert(list, target)
  end
end

function SeasonCampDestroyActInfo:UpdateCampInfo(camps)
  if not camps then
    return
  end
  for k, v in ipairs(camps) do
    local campType = v.campId
    local camp = self.camps[campType]
    if not camp then
      camp = SeasonCampDestroyCampInfo.New(self)
      self.camps[campType] = camp
    end
    camp:Update(v)
  end
end

function SeasonCampDestroyActInfo:UpdateServerInfo(servers)
  if not servers then
    return
  end
  for k, v in ipairs(servers) do
    local idx = v.gridId
    local sid = v.serverId
    local server = self.idx2server[idx]
    if not server then
      server = SeasonCampDestroyServerInfo.New(self)
      self.idx2server[idx] = server
      self.sid2server[sid] = server
      table.insert(self.servers, server)
    end
    server:Update(v)
    if server.isMyServer then
      self.myServerInfo = server
    end
  end
end

function SeasonCampDestroyActInfo:BuildServerInfoFromSeasonData()
  local seasonInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if not seasonInfo or not seasonInfo.theNinePalacesData then
    return
  end
  local myServerId = LuaEntry.Player.serverId
  for gridIndex, serverId in pairs(seasonInfo.theNinePalacesData) do
    local campId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(serverId)
    local info = {
      gridId = gridIndex,
      serverId = serverId,
      campId = campId,
      city = 0,
      ruins = 0,
      isMyServer = serverId == myServerId
    }
    self:UpdateSingleServerInfo(info)
  end
end

function SeasonCampDestroyActInfo:BuildCampInfoFromSeasonData()
  local groupingData = DataCenter.SeasonFactionWarDataManager:GetGroupingData()
  if not groupingData or #groupingData == 0 then
    return
  end
  local campIdSet = {}
  for _, v in ipairs(groupingData) do
    campIdSet[v.campId] = true
  end
  for campId, _ in pairs(campIdSet) do
    local info = {campId = campId, value = 0}
    self:UpdateSingleCampInfo(info)
  end
end

function SeasonCampDestroyActInfo:UpdateSingleServerInfo(info)
  if not info then
    return
  end
  local idx = info.gridId
  local sid = info.serverId
  local server = self.idx2server[idx]
  if not server then
    server = SeasonCampDestroyServerInfo.New(self)
    self.idx2server[idx] = server
    self.sid2server[sid] = server
    table.insert(self.servers, server)
  end
  server:Update(info)
  if server.isMyServer then
    self.myServerInfo = server
  end
end

function SeasonCampDestroyActInfo:UpdateSingleCampInfo(info)
  if not info then
    return
  end
  local campType = info.campId
  local camp = self.camps[campType]
  if not camp then
    camp = SeasonCampDestroyCampInfo.New(self)
    self.camps[campType] = camp
  end
  camp:Update(info)
end

function SeasonCampDestroyActInfo:GetCamp(campType)
  local camp = self.camps[campType]
  if not camp then
    Logger.LogError(string.format("Try get season 6 camp %s but failed.", campType))
    return nil
  end
  return self.camps[campType]
end

function SeasonCampDestroyActInfo:GetServerInfoByIndex(index)
  return self.idx2server and self.idx2server[index]
end

function SeasonCampDestroyActInfo:GetServerInfoById(id)
  return self.sid2server and self.sid2server[id]
end

function SeasonCampDestroyActInfo:Description()
  local sb = StringBuilder.New()
  local timeMgr = self.timeMgr or UITimeManager:GetInstance()
  sb:AppendLine()
  sb:AppendLine("[Status]")
  sb:AppendLineFormat("  IsDeclareDay: %s", self.isDeclareWarDay)
  sb:AppendLineFormat("0:\230\156\170\229\188\128\229\167\139, 1:\229\174\163\230\136\152\230\151\165, 2:\229\185\178\228\187\150\228\187\172")
  sb:AppendLineFormat("  CurrentBattleStage: %s", self:GetCurrentBattleStage())
  if self.isDeclareWarDay then
    sb:AppendLineFormat("  CurrEndTime: %s (%s)", self.currEndTime, timeMgr:TimeStampToTimeForLocal(self.currEndTime))
  else
    sb:AppendLineFormat("  NextOpenTime: %s (%s)", self.nextOpenTime, timeMgr:TimeStampToTimeForLocal(self.nextOpenTime))
  end
  sb:AppendLine()
  sb:AppendLine("[Declaration]")
  sb:AppendLineFormat("  DeclareList: %s", table.count(self.declareList))
  if self.declareList and #self.declareList > 0 then
    for i, target in ipairs(self.declareList) do
      sb:AppendLineFormat("    [%s] %s", i, target:Description())
    end
  end
  sb:AppendLineFormat("  BeDeclareList: %s", table.count(self.beDeclareList))
  if self.beDeclareList and 0 < #self.beDeclareList then
    for i, target in ipairs(self.beDeclareList) do
      sb:AppendLineFormat("    [%s] %s", i, target:Description())
    end
  end
  sb:AppendLine()
  sb:AppendLine("[TimeInfo]")
  if self.timeInfo then
    sb:AppendLineFormat("  %s", self.timeInfo:Description())
    if self.timeInfo.warTimes then
      for i = 0, 2 do
        local data = self.timeInfo.warTimes[i]
        if data then
          local prefix = self.timeInfo.rangeIndex == i + 1 and "[Current]" or ""
          sb:AppendLineFormat("    %s [%s] %s", prefix, i + 1, data:Description())
        end
      end
    end
  else
    sb:AppendLine("  NULL")
  end
  sb:AppendLine()
  sb:AppendLine("[Camps]")
  if self.camps then
    for k, v in pairs(self.camps) do
      sb:AppendLineFormat("  %s", v:Description())
    end
  else
    sb:AppendLine("  NULL")
  end
  sb:AppendLine()
  sb:AppendLine("[Servers]")
  if self.servers then
    for i = 1, 9 do
      local v = self.idx2server[i]
      if v then
        sb:AppendLineFormat("  %s", v:Description())
      else
        sb:AppendLineFormat("  [Grid:%s] Empty", i)
      end
    end
  else
    sb:AppendLine("  NULL")
  end
  return sb:ToString()
end

return SeasonCampDestroyActInfo
