local CounterAttackDataManager = BaseClass("CounterAttackDataManager")

function CounterAttackDataManager:__init()
  self.type = CounterAttackType.AllianceCity
  self.startTime = 0
  self.endTime = 0
  self.stage = 0
  self.stageEndTime = 0
  self.cityId = 0
  self.defState = 0
  self.round = 0
  self.atkTime = 0
  self.lastTimePersonRank = 0
  self.lastTimeActivityInfo = 0
  self.lastTimeRoundAward = 0
  self.awardRedPoint = 0
  self.totalRound = 30
  self:AddListener()
end

function CounterAttackDataManager:__delete()
  self:RemoveListener()
  if self.nextRoundTimer then
    self.nextRoundTimer:Stop()
    self.nextRoundTimer = nil
  end
  if self.changeStageTimer then
    self.changeStageTimer:Stop()
    self.changeStageTimer = nil
  end
  if self.hideTroopLineTimer then
    self.hideTroopLineTimer:Stop()
    self.hideTroopLineTimer = nil
  end
  if self.troopLineReq then
    self.troopLineReq:Destroy()
    self.troopLineReq = nil
  end
  self.totalRound = nil
  self.cityMeta = nil
  self.personRankReward = nil
  self.allianceRoundReward = nil
  self.selfRank = nil
  self.ranks = nil
end

function CounterAttackDataManager:AddListener()
  if not self.setEventListener then
    self.setEventListener = true
    EventManager:GetInstance():AddListener(EventId.OnEnterWorldState, self.OnEnterWorldState)
    EventManager:GetInstance():AddListener(EventId.OnExitWorldState, self.OnExitWorldState)
    EventManager:GetInstance():AddListener(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
    EventManager:GetInstance():AddListener(EventId.OnQuitCrossServer, self.OnQuitCrossServer)
  end
end

function CounterAttackDataManager:RemoveListener()
  if self.setEventListener then
    EventManager:GetInstance():RemoveListener(EventId.OnEnterWorldState, self.OnEnterWorldState)
    EventManager:GetInstance():RemoveListener(EventId.OnExitWorldState, self.OnExitWorldState)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
    EventManager:GetInstance():RemoveListener(EventId.OnQuitCrossServer, self.OnQuitCrossServer)
    self.setEventListener = false
  end
end

function CounterAttackDataManager:InitData(activityId, type)
  self.activityId = tonumber(activityId)
  self.type = tonumber(type)
  local marchTime = GetTableData(TableName.Activity, activityId, "para_5", 30)
  self.marchTime = tonumber(marchTime) * 1000
  self:SendMsgActivityInfo()
  self:SendMsgLookRoundAward()
end

function CounterAttackDataManager:SendMsgActivityInfo(block)
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if not block or now > self.lastTimeActivityInfo + 5 then
    self.lastTimeActivityInfo = now
    Logger.LogCustom("SendMsgActivityInfo" .. self.activityId, nil, "CounterAttack")
    SFSNetwork.SendMessage(MsgDefines.DarkKnightAllianceInfo, self.activityId)
  end
end

function CounterAttackDataManager:RecMsgActivityInfo(msg)
  self:RefreshActivityInfo(msg)
end

function CounterAttackDataManager:SendMsgLookRoundAward()
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if now > self.lastTimeRoundAward + 5 then
    self.lastTimeRoundAward = now
    Logger.LogCustom("SendMsgLookRoundAward", nil, "CounterAttack")
    SFSNetwork.SendMessage(MsgDefines.DarkKnightAllianceRewardInfo, self.activityId, 1)
  end
end

function CounterAttackDataManager:RecMsgLookRoundAward(allianceRoundReward)
  Logger.LogCustom("RecMsgLookRoundAward" .. #allianceRoundReward, nil, "CounterAttack")
  self:InitOrRefreshRoundAward(allianceRoundReward)
end

function CounterAttackDataManager:SendMsgLookPersonAward()
  Logger.LogCustom("SendMsgLookPersonAward" .. self.activityId, nil, "CounterAttack")
  SFSNetwork.SendMessage(MsgDefines.DarkKnightAllianceRewardInfo, self.activityId, 0)
end

function CounterAttackDataManager:RecMsgLookPersonAward(personRankReward)
  Logger.LogCustom("RecMsgLookPersonAward" .. #personRankReward, nil, "CounterAttack")
  self:InitPersonAward(personRankReward)
end

function CounterAttackDataManager:SendMsgCollectRoundAward(round)
  SFSNetwork.SendMessage(MsgDefines.DarkKnightAllianceAwardRound, self.activityId, round)
end

function CounterAttackDataManager:RecMsgCollectRoundAward(allianceRoundReward)
  self:InitOrRefreshRoundAward(allianceRoundReward)
end

function CounterAttackDataManager:SendMsgPersonRank()
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if now > self.lastTimePersonRank + 60 then
    self.lastTimePersonRank = now
    SFSNetwork.SendMessage(MsgDefines.DarkKnightAlliancePersonRank, self.activityId)
  end
end

function CounterAttackDataManager:RecMsgPersonRank(msg)
  self:RefreshPersonRank(msg)
end

function CounterAttackDataManager:RefreshActivityInfo(msg)
  if not msg then
    return
  end
  if msg.flag then
    self.flag = msg.flag
  end
  if msg.startTime then
    self.startTime = msg.startTime
  end
  if msg.endTime then
    self.endTime = msg.endTime
  end
  if msg.stage then
    self.stage = msg.stage
    self.stage = math.min(self.stage, 3)
  end
  if msg.stageEndTime then
    self.stageEndTime = msg.stageEndTime
    if self.changeStageTimer then
      self.changeStageTimer:Stop()
      self.changeStageTimer = nil
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    local delta = (self.stageEndTime - now) * 0.001 + 2 + 4 * math.random()
    if 0 < delta then
      self.changeStageTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.changeStageTimer = nil
        self:SendMsgActivityInfo()
      end, delta)
    end
  end
  if msg.cityId then
    self.cityId = msg.cityId
    if self.type == CounterAttackType.AllianceCity then
      local serverId = LuaEntry.Player:GetSourceServerId()
      self.cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId, serverId)
    else
      self.cityMeta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.cityId)
    end
  else
    self.cityMeta = nil
    self.cityId = 0
  end
  if msg.defState then
    self.defState = msg.defState
  else
    self.defState = 0
  end
  if msg.round then
    self.round = msg.round
  else
    self.round = 0
  end
  if msg.totalRound then
    self.totalRound = msg.totalRound
  end
  if msg.atkTime then
    self.atkTime = msg.atkTime
    if self.nextRoundTimer then
      self.nextRoundTimer:Stop()
      self.nextRoundTimer = nil
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    local delta = (self.atkTime - now) * 0.001 + 2 + 4 * math.random()
    if 0 < delta then
      self.nextRoundTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.nextRoundTimer = nil
        self:SendMsgLookRoundAward()
        if self.round == self.totalRound then
          self:SendMsgActivityInfo()
        end
      end, delta)
    end
  else
    self.atkTime = 0
  end
  if msg.srcX and msg.srcY then
    self.srcX = msg.srcX
    self.srcY = msg.srcY
  end
  EventManager:GetInstance():Broadcast(EventId.OnCounterAttackActInfo, self.cityId)
  self:CheckIfShowTroopLine()
end

function CounterAttackDataManager:InitPersonAward(personRankReward)
  self.personRankReward = personRankReward
end

function CounterAttackDataManager:InitOrRefreshRoundAward(allianceRoundReward)
  if self.allianceRoundReward then
    self:RefreshRoundAward(allianceRoundReward)
  else
    self:InitRoundAward(allianceRoundReward)
  end
end

function CounterAttackDataManager:InitRoundAward(allianceRoundReward)
  self.allianceRoundReward = {}
  self.awardRedPoint = 0
  for _, v in pairs(allianceRoundReward) do
    self.allianceRoundReward[v.round] = v
    if v.state == TaskState.CanReceive then
      self.awardRedPoint = self.awardRedPoint + 1
    end
  end
  Logger.LogCustom("Broadcast:OnCounterAttackRoundAwardInit", nil, "CounterAttack")
  EventManager:GetInstance():Broadcast(EventId.OnCounterAttackRoundAwardInit)
  EventManager:GetInstance():Broadcast(EventId.OnCounterAttackRoundAwardPoint)
end

function CounterAttackDataManager:RefreshRoundAward(allianceRoundReward)
  for _, v in pairs(allianceRoundReward) do
    local oldState = self.allianceRoundReward[v.round].state
    if oldState ~= TaskState.CanReceive and v.state == TaskState.CanReceive then
      self.awardRedPoint = self.awardRedPoint + 1
    elseif oldState == TaskState.CanReceive and v.state ~= TaskState.CanReceive then
      self.awardRedPoint = self.awardRedPoint - 1
    end
    self.allianceRoundReward[v.round].state = v.state
    self.allianceRoundReward[v.round].reason = v.reason
    if oldState ~= v.state then
      EventManager:GetInstance():Broadcast(EventId.OnCounterAttackRoundAward, v.round)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.OnCounterAttackRoundAwardPoint)
end

function CounterAttackDataManager:RefreshPersonRank(msg)
  self.selfRank = msg.self
  self.ranks = msg.ranks
  EventManager:GetInstance():Broadcast(EventId.OnCounterAttackPersonRank)
end

function CounterAttackDataManager:InitTemplate()
  if self.langKey then
    return
  end
  self.langKey = {}
  LocalController:instance():visitTable(TableName.LW_DK_Dialog, function(id, lineData)
    if lineData ~= nil then
      local type = lineData:getValue("type")
      self.langKey[type] = {
        pretime_dialog = lineData:getValue("pretime_dialog"),
        countdown_dialog = lineData:getValue("countdown_dialog"),
        gathertime_dialog = lineData:getValue("gathertime_dialog"),
        noaim_dialog = lineData:getValue("noaim_dialog"),
        attacktime_dialog = lineData:getValue("attacktime_dialog"),
        attackstart_dialog = lineData:getValue("attackstart_dialog"),
        end_dialog = lineData:getValue("end_dialog"),
        win_dialog = lineData:getValue("win_dialog"),
        lose_dialog = lineData:getValue("lose_dialog"),
        bg = lineData:getValue("bg")
      }
    end
  end)
end

function CounterAttackDataManager:GetLangKey()
  if self.langKey == nil then
    self:InitTemplate()
  end
  return self.langKey[self.type]
end

function CounterAttackDataManager:SetFirstSeenAssemble()
  self.seenAssemble = true
  EventManager:GetInstance():Broadcast(EventId.OnCounterAttackFirstSeen)
end

function CounterAttackDataManager:SetFirstSeenAttack()
  self.seenAttack = true
  EventManager:GetInstance():Broadcast(EventId.OnCounterAttackFirstSeen)
end

function CounterAttackDataManager:GetActEndTime()
  return self.endTime
end

function CounterAttackDataManager:GetStage()
  return self.stage
end

function CounterAttackDataManager:GetCityMeta()
  return self.cityMeta
end

function CounterAttackDataManager:GetStageEndTime()
  return self.stageEndTime
end

function CounterAttackDataManager:GetNextRound()
  local now = UITimeManager:GetInstance():GetServerTime()
  if not self.atkTime or now > self.atkTime then
    return 0, self.stageEndTime
  end
  return self.round, self.atkTime
end

function CounterAttackDataManager:GetState()
  return self.defState
end

function CounterAttackDataManager:GetPersonRankReward()
  return self.personRankReward
end

function CounterAttackDataManager:GetAllianceRoundReward()
  return self.allianceRoundReward
end

function CounterAttackDataManager:GetRankData()
  return self.ranks, self.selfRank
end

function CounterAttackDataManager:GetTotalRound()
  return self.totalRound
end

function CounterAttackDataManager:GetAwardRedPoint()
  return self.awardRedPoint
end

function CounterAttackDataManager:GetFirstSeenRedPoint()
  if not LuaEntry.Player:IsInAlliance() then
    return false
  end
  if not self.cityMeta then
    return false
  end
  if self.stage == CounterAttackStage.WarmUp then
    return false
  elseif self.stage == CounterAttackStage.Assemble then
    return not self.seenAssemble
  elseif self.stage == CounterAttackStage.Attack then
    return not self.seenAttack
  elseif self.stage == CounterAttackStage.Settle then
    return false
  end
  return false
end

function CounterAttackDataManager:CheckAllianceCityIsBeingAttack(cityId, serverId)
  return self.stage == CounterAttackStage.Attack and self.type == CounterAttackType.AllianceCity and self.defState == 1 and self.cityMeta and self.cityMeta.id == cityId and LuaEntry.Player:GetSourceServerId() == serverId
end

function CounterAttackDataManager:CheckStoveIsBeingAttack(uuid)
  if self.stage == CounterAttackStage.Attack and self.type ~= CounterAttackType.AllianceCity and self.defState == 1 and self.cityMeta and LuaEntry.Player:IsInSourceServer() then
    local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
    return theStoveCenter and theStoveCenter.uuid == uuid
  end
end

function CounterAttackDataManager:GetType()
  return self.type
end

function CounterAttackDataManager:OnEnterWorldState()
  DataCenter.CounterAttackDataManager:CheckIfShowTroopLine()
end

function CounterAttackDataManager:OnExitWorldState()
  DataCenter.CounterAttackDataManager:ShowOrHideTroopLine(false)
end

function CounterAttackDataManager:OnEnterCrossServer()
  DataCenter.CounterAttackDataManager:CheckIfShowTroopLine()
end

function CounterAttackDataManager:OnQuitCrossServer()
  DataCenter.CounterAttackDataManager:CheckIfShowTroopLine()
end

function CounterAttackDataManager:CheckIfShowTroopLine()
  self:ShowOrHideTroopLine(LuaEntry.Player:IsInSourceServer() and self.stage == CounterAttackStage.Assemble and DataCenter.LWSceneStateManager:GetCurScene() == SceneType.World)
end

function CounterAttackDataManager:ShowOrHideTroopLine(bool)
  if not bool then
    if self.troopLineReq then
      self.troopLineReq:Destroy()
      self.troopLineReq = nil
    end
  else
    if self.troopLineReq then
      return
    end
    if not LuaEntry.Player:IsInAlliance() then
      return
    end
    if not self.srcX or not self.cityMeta then
      return
    end
    local endTilePos
    if self.type == CounterAttackType.AllianceCity then
      endTilePos = self.cityMeta.pos
    else
      local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
      if not theStoveCenter then
        return
      end
      endTilePos = SceneUtils.IndexToTilePos(theStoveCenter.pointId, ForceChangeScene.World)
    end
    self.troopLineReq = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/March/DarkKnightTroopLine.prefab")
    self.troopLineReq:completed("+", function(req)
      local go = req.gameObject
      if IsNull(go) then
        return
      end
      go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      local line = go.transform:Find("Line"):GetComponent(typeof(CS.UnityEngine.LineRenderer))
      local startPos = SceneUtils.TileToWorld({
        x = self.srcX,
        y = self.srcY
      }, ForceChangeScene.World)
      local endPos = SceneUtils.TileToWorld(endTilePos, ForceChangeScene.World)
      line:SetPosition(0, startPos)
      line:SetPosition(1, endPos)
    end)
  end
end

return CounterAttackDataManager
