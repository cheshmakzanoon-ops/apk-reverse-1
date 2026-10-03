local LWOpeningStageManager = BaseClass("LWOpeningStageManager")

function LWOpeningStageManager:__init()
  self.squadProxy = require("DataCenter.LWOpeningStageManager.LWOpeningStageSquadProxy")
  self.dirtyWorks = require("DataCenter.LWOpeningStageManager.LWOpeningStageDirtyWorks")
  self.eventDealer = require("DataCenter.LWOpeningStageManager.LWOpeningStageEventDealer")
  self.utils = require("DataCenter.LWOpeningStageManager.LWOpeningStageUtils")
  self.openStages = {}
  self.closeStages = {}
end

function LWOpeningStageManager:__delete()
  self:ClearStages()
  if self.eventDealer then
    self.eventDealer:Dispose()
  end
  if self.dirtyWorks then
    self.dirtyWorks:Clear()
  end
  self:ClearAllDelayTimers()
end

LWOpeningStageManager.MaxStageID = 7

function LWOpeningStageManager:Startup()
end

function LWOpeningStageManager:InitData(msg)
  LWOpeningStageManager.MaxStageID = DataCenter.LWCivilizationSparkExtend:LWOpeningStageManager_getMaxStageID()
  self.openStages = {}
  self.closeStages = {}
  local serverStageId = msg.openingStageInfo and msg.openingStageInfo.stageId and tonumber(msg.openingStageInfo.stageId) or 0
  local tbl = LocalController:instance():getTable(LuaEntry.Player:GetABTestTableName(TableName.LW_Opening_Stage))
  for id, _ in ipairs(tbl.data) do
    local data = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Opening_Stage), id)
    if serverStageId >= id then
      table.insert(self.closeStages, 1, data)
    else
      table.insert(self.openStages, data)
    end
  end
end

function LWOpeningStageManager:ResetDataAndSyncServer(serverStageId)
  SFSNetwork.SendMessage(MsgDefines.LWSaveOpeningRecord, serverStageId)
  self.openStages = {}
  self.closeStages = {}
  local tbl = LocalController:instance():getTable(LuaEntry.Player:GetABTestTableName(TableName.LW_Opening_Stage))
  for id, _ in ipairs(tbl.data) do
    local data = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Opening_Stage), id)
    if serverStageId >= id then
      table.insert(self.closeStages, 1, data)
    else
      table.insert(self.openStages, data)
    end
  end
end

function LWOpeningStageManager:OnEnterGame()
  self:ClearStages()
  self.dirtyWorks = DataCenter.LWCivilizationSparkExtend:LWOpeningStageManager_requireDirtyWorks()
  if #self.openStages > 0 then
    self.eventDealer:Setup()
    self.dirtyWorks:Clear()
    if CS.SceneManager:IsInCity() then
      self:SetupStages()
      self:UpdateCurrStageState()
      self:PostprocessOfFlags()
    end
  end
  self.dirtyWorks:Do(true)
  self.flagWin = nil
  self.flagLose = nil
  LWOpeningStageManager.fromBattle = nil
end

function LWOpeningStageManager:IsAllDone()
  return self.openStages == nil or #self.openStages <= 0
end

function LWOpeningStageManager:GetCurStageId()
  if self:IsAllDone() then
    return self.MaxStageID + 1
  end
  if self.openStages then
    return self.openStages[1].id
  end
end

function LWOpeningStageManager:IsStageDone(stageId)
  if self:IsAllDone() then
    return true
  end
  return stageId < self.openStages[1].id
end

function LWOpeningStageManager:SetupStages()
  if #self.closeStages == 0 then
    return
  end
  self.utils.CreateRoot()
  for _, stage in ipairs(self.openStages) do
    self.utils.LoadNodeRes(stage)
    self.utils.LoadEnemyRes(stage)
  end
  self.utils.LoadNodeRes(self.closeStages[1], true)
  self.utils.ShowLine(self.closeStages[1], self.openStages[1])
  self.utils.LoadBubble(self.openStages[1])
  self.squadProxy:Init(self.openStages[1])
end

function LWOpeningStageManager:UpdateCurrStageState()
  if #self.closeStages == 0 then
    return
  end
  self.squadProxy:UpdateSegments(self.closeStages[2], self.closeStages[1], self.openStages[1])
  self.squadProxy:ResetLeaderCell(self.closeStages[1], self.openStages[1])
  self.utils.UpdateStageBubbleVisible()
  EventManager:GetInstance():Broadcast(EventId.OpeningStageSetup, self.openStages[1].id)
end

function LWOpeningStageManager:PostprocessOfFlags()
  if #self.closeStages == 0 then
    return
  end
  local checkResult = self:CheckNextStageConditions()
  if self.flagWin then
    LWOpeningStageManager.fromBattle = true
    if DataCenter.LWGuideManager.curGuideId == GuideState.OpeningDebut then
      DataCenter.LWGuideManager:GuideFire()
    else
      self.utils.ShowBattleResult(true)
      if 0 < self.closeStages[1].over_plot then
        EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
          plotGroupId = self.closeStages[1].over_plot,
          hideMainUI = false
        })
        if self.closeStages[1].id == 3 or self.closeStages[1].id == 7 then
          DataCenter.BuildBubbleManager:HideBubbleNode()
        elseif self.closeStages[1].id == 6 then
          DataCenter.LWOpeningStageManager.utils.SetStageBubbleVisible(7, false)
        end
      elseif self.squadProxy.newHero then
        self.squadProxy:WelcomeNewFellow()
      elseif checkResult == 0 then
        self.utils.FocusCameraToNextStage(0.5)
      end
      DataCenter.LWCivilizationSparkExtend:LWOpeningStageManager_flagWinCameraMove(self.utils)
    end
  elseif self.flagLose then
    LWOpeningStageManager.fromBattle = true
    self.utils.ShowBattleResult(false)
    self.utils.FocusCameraToNextStage(0.5)
  else
    LWOpeningStageManager.fromBattle = false
    if DataCenter.LWGuideManager.curGuideId == GuideState.OpeningDebut then
      DataCenter.LWGuideManager:GuideFire()
    elseif checkResult == 0 then
      self.utils.FocusCameraToNextStage(0.5)
    end
  end
  self.flagWin = nil
  self.flagLose = nil
end

function LWOpeningStageManager:ClearStages()
  if self.isMarching then
    DataCenter.LWOpeningStageManager:OnMarchEnd()
  end
  self.utils.Clear()
  self.dirtyWorks:Clear()
  if self.openStages and self.openStages[1] then
    EventManager:GetInstance():Broadcast(EventId.OpeningStageClear, self.openStages[1].id)
  end
  self:ClearAllDelayTimers()
end

function LWOpeningStageManager:CheckNextStageConditions()
  if self.openStages[1] and self.openStages[1].building_condition and #self.openStages[1].building_condition > 0 then
    for _, conditionStr in ipairs(self.openStages[1].building_condition) do
      local conditionArr = string.split(conditionStr, ";")
      local buildingId = tonumber(conditionArr[1])
      local pointId = tonumber(conditionArr[2])
      local buildingLv = buildingId % 1000
      buildingId = math.floor(buildingId / 1000) * 1000
      local buildingData
      for _, data in pairs(DataCenter.BuildManager.allBuilding) do
        if data.itemId == buildingId and (pointId <= 0 or data.pointId == pointId) then
          buildingData = data
          break
        end
      end
      if buildingData == nil then
        Logger.LogError("LWOpeningStage bulding_condition buildingData is nil, buildingId=" .. buildingId .. ", pointId=" .. pointId)
        return 2
      end
      if buildingLv > buildingData.level then
        return 2, buildingData
      end
    end
  end
  return 0
end

function LWOpeningStageManager:OnClickAttack()
  local checkResult, resultData = self:CheckNextStageConditions()
  if 0 < checkResult then
    if checkResult == 1 then
      self.utils.FocusCameraToLeader(self.squadProxy.cells[1], 0.5, function()
        local firstTime = CommonUtil.PlayerPrefsGetInt("OP_First_Time_Stage_Condition_Failed_Worker", 0) == 0
        if firstTime then
          EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = 2006, hideMainUI = false})
          CommonUtil.PlayerPrefsSetInt("OP_First_Time_Stage_Condition_Failed_Worker", 1)
        end
        self.utils.ShowFingerClick(self.squadProxy.cells[1].position + Vector3(0, 4, 0), 2, 2)
      end, 150)
    elseif checkResult == 2 and resultData then
      self.utils.FocusCameraToBuilding(resultData, 0.5, function()
        self.utils.ShowFingerClick(self.utils.BuildingPointID_to_WorldPos(resultData.itemId, resultData.pointId) + Vector3(0, 2, 0), 2, 2)
      end, 150)
    end
    return
  end
  if self.isMarching then
    return
  end
  local nextStage = self.openStages[1]
  if nextStage.plot > 0 then
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
      plotGroupId = nextStage.plot,
      hideMainUI = false
    })
  else
    self:OnMarchBegin()
  end
end

function LWOpeningStageManager:OnMarchBegin()
  if self.isMarching then
    return
  end
  self.isMarching = true
  UpdateManager:GetInstance():AddUpdate(self.squadProxy.OnUpdate)
  self.squadProxy:PlayAnim("run")
  self.utils.NoticeLingerZombies(self.openStages[1])
  EventManager:GetInstance():Broadcast(EventId.OpeningStageMarchBegin, self.openStages[1].id)
  self.utils.ClearNodeAndLine()
end

function LWOpeningStageManager:OnMarchReach(firstGuideStage)
  local nextStage = self.openStages[1]
  if not nextStage and firstGuideStage then
    Logger.LogError("LWOpeningStageManager firstGuideStage Error! server data of stage progress was finished but still try to enter the first guide level from guide manager. must be dirty user data.")
    return
  end
  if nextStage.type == 1 then
    local param = {}
    param.type = PVEType.Parkour
    param.enterType = PVEEnterType.OpeningStage
    param.levelId = tonumber(nextStage.param)
    param.firstGuideStage = firstGuideStage
    param.absoluteBtn = true
    if firstGuideStage then
      LEVEL_ONE_ID = param.levelId
    end
    DataCenter.LWBattleManager:Enter(param)
  elseif nextStage.type == 2 then
    local param = {}
    param.type = PVEType.Count
    param.levelId = tonumber(nextStage.param)
    param.firstGuideStage = firstGuideStage
    if firstGuideStage then
      LEVEL_ONE_ID = param.levelId
    end
    DataCenter.LWBattleManager:Enter(param)
  else
    Logger.LogError(TableName.LW_Opening_Stage .. " \230\156\170\231\159\165 type: " .. nextStage.type)
    self:OnMarchEnd()
  end
end

function LWOpeningStageManager:OnMarchEnd()
  self.isMarching = false
  UpdateManager:GetInstance():RemoveUpdate(self.squadProxy.OnUpdate)
  self.squadProxy:PlayAnim("idle")
end

function LWOpeningStageManager:OnStageWin(levelId)
  local nextStage = self.openStages[1]
  if not nextStage or tonumber(nextStage.param) ~= levelId then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.LWSaveOpeningRecord, nextStage.id)
  table.insert(self.closeStages, 1, nextStage)
  table.remove(self.openStages, 1)
  self.flagWin = true
  self.flagFinish = #self.openStages == 0
  if self.dirtyWorks then
    self.dirtyWorks:CheckFakeNewHero(levelId)
  end
end

function LWOpeningStageManager:OnStageLose(levelId)
  self.flagLose = true
end

function LWOpeningStageManager:CreateDelayTimer(callback, delay, timerName)
  if self.delayTimers == nil then
    self.delayTimers = {}
  end
  timerName = timerName or "timer_" .. tostring(#self.delayTimers + 1)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimers[timerName] then
      self.delayTimers[timerName] = nil
    end
    callback()
  end, delay)
  self.delayTimers[timerName] = timer
  return timer
end

function LWOpeningStageManager:ClearAllDelayTimers()
  if self.delayTimers then
    for name, timer in pairs(self.delayTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.delayTimers = {}
  end
end

return LWOpeningStageManager
