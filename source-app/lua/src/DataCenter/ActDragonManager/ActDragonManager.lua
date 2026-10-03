local ActDragonManager = BaseClass("ActDragonManager", BattlefieldManagerBase)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local ActDragonData = require("DataCenter.ActDragonManager.ActDragonData")
local BattleHistory = require("DataCenter.ActDragonManager.BattleHistory")
local ActDragonPlayerData = require("DataCenter.ActDragonManager.ActDragonPlayerData")
local DragonBattleInfo = require("DataCenter.ActDragonManager.DragonBattleInfo")
local ActDragonRecordData = require("DataCenter.ActDragonManager.ActDragonRecordData")
local ActDragonSelfDetailData = require("DataCenter.ActDragonManager.ActDragonSelfDetailData")
local ActDragonSoldierData = require("DataCenter.ActDragonManager.ActDragonSoldierData")
local BattleBehaviorData = require("DataCenter.ActDragonManager.BattleBehaviorData")
local ActDragonCommanderData = require("DataCenter.ActDragonManager.ActDragonCommanderData")
local ActDragonCommandOrderData = require("DataCenter.ActDragonManager.ActDragonCommandOrderData")
local rapidjson = require("rapidjson")
local ActDragon458252 = "ActDragon_458252_"
local ActDragon458253 = "ActDragon_458253_"
local BASE_ORDER_MARK_PATH = "Assets/Main/Prefabs/UI/AllianceWorldMark/DesertBattleMark_%d.prefab"

function ActDragonManager:OnInit()
  self.bfType = BattleFieldType.Desert
  self.SignUpState = {NoSignUp = 0, SignUp = 1}
  self:ResetData()
end

function ActDragonManager:OnDelete()
  self:ResetData()
end

function ActDragonManager:ResetData()
  self.actInfo = nil
  self:CleanOrderMark()
  self.battleInfos = {}
  self.rewardInfo = {}
  self.battleTimes = {}
  self.battleHistory = {}
  self.playerList = {}
  self.dragonRecord = {}
  self.selfDetailData = {}
  self.treatmentFinishSoldierNum = 0
  self.treatmentSpeed = 0
  self.unitTreatmentNum = 0
  self.treatmentSoldierList = {}
  self.accumulativeTreatmentSoldierNum = 0
  self.buildTopMarch = {}
  self.updateNodes = nil
  self.commandersDic = nil
  self.orders = nil
end

function ActDragonManager:GetActInfo()
  return self.actInfo
end

function ActDragonManager:OnLeaveAlliance()
  self:ResetData()
  self:ReqActInfo()
end

function ActDragonManager:SendGetPlayerList()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastListRequestTime == nil or curTime - self.lastListRequestTime > 1000 then
    SFSNetwork.SendMessage(MsgDefines.DragonAssignPlayerInfo)
    self.lastListRequestTime = curTime
  end
end

function ActDragonManager:RequestBattleInfo(ignoreTime, groupIdx)
  if self:CanShowEnter(true, groupIdx) then
    local group
    if groupIdx == nil or groupIdx == 0 then
      group = self:GetCurGroup()
    else
      group = self:GetGroup(groupIdx)
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local timeInfo = group ~= nil and group.timeInfo or nil
    if timeInfo ~= nil and (ignoreTime or curTime > timeInfo.battleOpenTime) then
      SFSNetwork.SendMessage(MsgDefines.DragonBattleInfo, group.group)
      self.lastSyncTime = curTime
      self.lastReqGroup = group.group
    end
  end
end

function ActDragonManager:HandleBattleScore(message)
  if message.scoreInfo ~= nil then
    self.dragonRecord = {}
    local dic = message.scoreInfo
    for k, v in pairs(dic) do
      local oneData = ActDragonRecordData.New()
      oneData:ParseData(v)
      if oneData.allianceId ~= nil or oneData.allianceId ~= "" then
        self.dragonRecord[oneData.allianceId] = oneData
      end
      if not table.IsNullOrEmpty(v.userList) then
        for k1, v1 in pairs(v.userList) do
          if v1.uid == LuaEntry.Player.uid then
            self.selfDetailData = ActDragonSelfDetailData.New()
            self.selfDetailData:ParseData(v1)
          end
        end
      end
    end
  end
  if message.detail ~= nil then
    self.battleScoreInfo = message.detail
  end
  if message.reward then
    self.battleResultReward = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward)
  end
  CS.GameEntry.Setting:SetBool("ActDragonShowPrepareMainUITip" .. LuaEntry.Player.uid, false)
  CS.GameEntry.Setting:SetBool("ActDragonShowBattleMainUITip" .. LuaEntry.Player.uid, false)
end

function ActDragonManager:GetBattleScoreInfo()
  return self.battleScoreInfo
end

function ActDragonManager:GetBattleResultReward()
  return self.battleResultReward
end

function ActDragonManager:GetRecordScore(isSelf, dataName)
  local selfAllianceId = LuaEntry.Player.allianceId
  if self.dragonRecord then
    local oneData
    for k, v in pairs(self.dragonRecord) do
      if k == selfAllianceId and isSelf then
        oneData = v
        break
      elseif k ~= selfAllianceId and not isSelf then
        oneData = v
        break
      end
    end
    if oneData then
      return oneData[dataName]
    end
  end
end

function ActDragonManager:OnHandleBattleInfo(message)
  local info = DragonBattleInfo.New()
  info:ParseData(message)
  self.battleInfos[info.group] = info
  EventManager:GetInstance():Broadcast(EventId.DragonScoreRefresh)
end

function ActDragonManager:OnHandleBattleScore(message)
  local info = self:GetCurBattleInfo()
  if info == nil then
    return
  end
  info:ParseScoreData(message)
  EventManager:GetInstance():Broadcast(EventId.DragonScoreRefresh)
end

function ActDragonManager:OnHandleBattlePlayerNum(message)
  local info = self:GetCurBattleInfo()
  if info and info.vsInfoArr then
    for k, v in pairs(info.vsInfoArr) do
      if k == message.allianceId then
        v.currPlayerNum = message.currPlayerNum
        EventManager:GetInstance():Broadcast(EventId.DragonPlayerNumRefresh)
        break
      end
    end
  end
end

function ActDragonManager:OnHandleBattleScoreAdd(message)
  local info = self:GetCurBattleInfo()
  if info and info.vsInfoArr then
    for k, v in pairs(info.vsInfoArr) do
      if k == message.allianceId then
        v.pointAdd = message.pointAdd or 0
        EventManager:GetInstance():Broadcast(EventId.DragonScoreRefresh)
        break
      end
    end
  end
end

function ActDragonManager:GetDragonRecord()
  return self.dragonRecord
end

function ActDragonManager:GetDragonSelfData()
  return self.selfDetailData
end

function ActDragonManager:GetSelfSide()
  local side = 0
  local info = self:GetCurBattleInfo()
  if info ~= nil then
    side = info.selfSide
  end
  return side
end

function ActDragonManager:HandleGetInfo(message)
  local oneData = ActDragonData.New()
  oneData:ParseData(message)
  self.actInfo = oneData
  self:SendGetPlayerList()
  EventManager:GetInstance():Broadcast(EventId.DragonInfoRefresh)
  EventManager:GetInstance():Broadcast(EventId.RefreshRaceEntrance)
end

function ActDragonManager:CleanMatch()
  if self.actInfo then
    self.actInfo:CleanMatch()
  end
  local warList = DataCenter.AllianceWarDataManager:GetSelfWarList()
  if not table.IsNullOrEmpty(warList) then
    for _, warData in ipairs(warList) do
      if warData.worldType == BattleFieldType.Desert then
        DataCenter.AllianceWarDataManager:DeleteAllianceWarDataByUuid(warData.uuid)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.DragonInfoRefresh)
end

function ActDragonManager:HandleGetPlayerList(message)
  if message.users ~= nil then
    self.playerList = {}
    local dic = message.users
    for k, v in pairs(dic) do
      local oneData = ActDragonPlayerData.New()
      oneData:ParseData(v)
      if oneData.uid ~= nil and oneData.uid ~= "" then
        self.playerList[oneData.uid] = oneData
      end
    end
    EventManager:GetInstance():Broadcast(EventId.GetDagonPlayerList)
    DataCenter.AllianceWarDataManager:RemoveCanNotJoinDragonWar()
  end
end

function ActDragonManager:GetPlayerList()
  return self.playerList
end

function ActDragonManager:GetPlayerInfoByUID(uid)
  return self.playerList[uid]
end

function ActDragonManager:SelectPlayer(uid, state, group)
  if self.playerList[uid] ~= nil then
    if self.playerList[uid].state == state then
      return
    end
    if state == DragonPlayerState.Main then
      local maxNum = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k4", 20)
      local curNum = self:GetCurNumByState(state, group)
      if maxNum <= curNum then
        UIUtil.ShowTipsId("458148")
        EventManager:GetInstance():Broadcast(EventId.GetDagonPlayerList)
        return
      else
        self:AssignPlayer(uid, state, group)
      end
    elseif state == DragonPlayerState.Sub then
      local maxNum = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k5", 10)
      local curNum = self:GetCurNumByState(state, group)
      if maxNum <= curNum then
        UIUtil.ShowTipsId("458149")
        EventManager:GetInstance():Broadcast(EventId.GetDagonPlayerList)
        return
      else
        self:AssignPlayer(uid, state, group)
      end
    end
    self.playerList[uid].state = state
  end
end

function ActDragonManager:AssignPlayer(uid, state, group)
  SFSNetwork.SendMessage(MsgDefines.DragonAssignPlayer, uid, state, group)
end

function ActDragonManager:CancelPlayer(uid, group)
  local playerInfo = self.playerList[uid]
  if playerInfo ~= nil then
    SFSNetwork.SendMessage(MsgDefines.DragonRevokePlayer, uid, group)
    playerInfo.state = DragonPlayerState.None
    playerInfo.commander = false
  end
end

function ActDragonManager:HandleSelectPlayer(message)
  if message ~= nil and message.userInfo ~= nil then
    local uid = message.userInfo.uid
    if uid ~= nil and uid ~= "" then
      local oneData = self.playerList[uid]
      if oneData == nil then
        oneData = ActDragonPlayerData.New()
      end
      oneData:ParseData(message.userInfo)
      oneData.group = message.group
      self.playerList[uid] = oneData
      EventManager:GetInstance():Broadcast(EventId.GetDagonPlayerList)
    end
  end
end

function ActDragonManager:GetCurNumByState(state, group)
  local num = 0
  for _, v in pairs(self.playerList) do
    if v.group == group and v.state == state then
      num = num + 1
    end
  end
  return num
end

function ActDragonManager:GetCurCommanderNum(group)
  local num = 0
  for _, v in pairs(self.playerList) do
    if v.group == group and v.commander then
      num = num + 1
    end
  end
  return num
end

function ActDragonManager:SelfIsBattleMember(state, group)
  local uid = LuaEntry.Player:GetUid()
  for k, v in pairs(self.playerList) do
    if v.group == group and v.state == state and v.uid == uid then
      return true
    end
  end
  return false
end

function ActDragonManager:GetTotalPowerBySelect(group)
  local num = 0
  for k, v in pairs(self.playerList) do
    if v.group == group and v.state == DragonPlayerState.Main or v.state == DragonPlayerState.Sub then
      num = num + v.power
    end
  end
  return num
end

function ActDragonManager:SendGetRewardInfo()
  if not table.IsNullOrEmpty(self.rewardInfo) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.DragonRewardInfo)
end

function ActDragonManager:HandleGetRewardInfo(message)
  self.rewardInfo = {}
  if message.winAllianceReward then
    self.rewardInfo[1] = {}
    self.rewardInfo[1] = DataCenter.RewardManager:ReturnRewardParamForView(message.winAllianceReward)
  end
  if message.loseAllianceReward then
    self.rewardInfo[2] = {}
    self.rewardInfo[2] = DataCenter.RewardManager:ReturnRewardParamForView(message.loseAllianceReward)
  end
  if message.winPersonReward then
    self.rewardInfo[3] = {}
    self.rewardInfo[3] = DataCenter.RewardManager:ReturnRewardParamForView(message.winPersonReward)
  end
  if message.losePersonReward then
    self.rewardInfo[4] = {}
    self.rewardInfo[4] = DataCenter.RewardManager:ReturnRewardParamForView(message.losePersonReward)
  end
  self.scoreArr = {}
  if message.winScoreRewardArr then
    local winScoreRewardArr = message.winScoreRewardArr
    self.rewardInfo[5] = {}
    self.scoreArr.winScore = {}
    for i = 1, table.count(winScoreRewardArr) do
      local param = {}
      param.s = winScoreRewardArr[i].start
      param.e = winScoreRewardArr[i]["end"]
      if param.e == -1 or param.e == "-1" or param.e == 1 or param.e == "1" then
        param.e = "..."
      end
      table.insert(self.scoreArr.winScore, param)
      self.rewardInfo[5][i] = DataCenter.RewardManager:ReturnRewardParamForView(winScoreRewardArr[i].reward)
    end
  end
  if message.loseScoreRewardArr then
    local loseScoreRewardArr = message.loseScoreRewardArr
    self.rewardInfo[6] = {}
    self.scoreArr.loseScore = {}
    for i = 1, table.count(loseScoreRewardArr) do
      local param = {}
      param.s = loseScoreRewardArr[i].start
      param.e = loseScoreRewardArr[i]["end"]
      if param.e == -1 or param.e == "-1" or param.e == 1 or param.e == "1" then
        param.e = "..."
      end
      table.insert(self.scoreArr.loseScore, param)
      self.rewardInfo[6][i] = DataCenter.RewardManager:ReturnRewardParamForView(loseScoreRewardArr[i].reward)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.DragonRewardInfo)
end

function ActDragonManager:ReqBattleEffect()
  if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
    SFSNetwork.SendMessage(MsgDefines.GetDragonSeverEffect)
  end
end

function ActDragonManager:SendSignUp(battlePeriod, group)
  SFSNetwork.SendMessage(MsgDefines.DragonBattleSignUp, battlePeriod, group)
end

function ActDragonManager:SendModifyBattlePeriod(battlePeriod, group)
  SFSNetwork.SendMessage(MsgDefines.DragonBattleModifyBattlePeriod, battlePeriod, group)
end

function ActDragonManager:HandleBattlePeriod(message)
  self.actInfo:UpdateBattlePeriod(message)
  self:ReqActInfo()
  self:SendGetBattleTime()
  self:SendGetPlayerList()
end

function ActDragonManager:SendGetBattleTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastBTRequestTime == nil or curTime - self.lastBTRequestTime > 3000 then
    SFSNetwork.SendMessage(MsgDefines.GetDragonBattleTimes)
    self.lastBTRequestTime = curTime
  end
end

function ActDragonManager:HandleGetBattleTime(message)
  self.battleTimes = {}
  if message.battleTimes then
    local battleTimes = message.battleTimes
    for i = 1, table.count(battleTimes) do
      local param = {}
      param.battlePeriod = battleTimes[i].battlePeriod
      param.startTime = battleTimes[i].startTime
      param.endTime = battleTimes[i].endTime
      table.insert(self.battleTimes, param)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.DragonBattleTimes)
end

function ActDragonManager:SendBattleHistory()
  SFSNetwork.SendMessage(MsgDefines.DragonBattleHistory)
end

function ActDragonManager:HandleBattleHistory(message)
  self.battleHistory = {}
  if message.historyArr then
    local historyArr = message.historyArr
    for i = 1, table.count(historyArr) do
      local oneData = BattleHistory.New()
      oneData:ParseData(historyArr[i])
      if oneData.name and oneData.enemyName and oneData.abbr and oneData.enemyAbbr then
        table.insert(self.battleHistory, oneData)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.DragonBattleHistory)
end

function ActDragonManager:OnHandleDragonHospitalNum(message)
  if message.finishNum then
    local newTreatmentFinishSoldierNum = message.finishNum
    local addNum = newTreatmentFinishSoldierNum - self.treatmentFinishSoldierNum
    self.treatmentFinishSoldierNum = newTreatmentFinishSoldierNum
    EventManager:GetInstance():Broadcast(EventId.GetDesertBattleTreatmentSoldierNum, addNum)
  end
end

function ActDragonManager:GetTreatmentFinishSoldierNum()
  return self.treatmentFinishSoldierNum
end

function ActDragonManager:SendDragonHospitalViewMsg()
  SFSNetwork.SendMessage(MsgDefines.DragonHospitalView)
end

function ActDragonManager:OnHandleDragonHospitalView(message)
  if message.armyList then
    self.treatmentSoldierList = {}
    self.accumulativeTreatmentSoldierNum = 0
    local list = message.armyList
    for i, v in pairs(list) do
      if v ~= nil then
        local oneData = ActDragonSoldierData.New()
        oneData:ParseData(v)
        table.insert(self.treatmentSoldierList, oneData)
        self.accumulativeTreatmentSoldierNum = self.accumulativeTreatmentSoldierNum + oneData.finishNum
      end
    end
  end
  if message.speed then
    self.unitTreatmentNum = message.speed
    local unitTime = DataCenter.DragonBuildTemplateManager:GetItemValue("k14")
    self.treatmentSpeed = self.unitTreatmentNum / unitTime
  end
  EventManager:GetInstance():Broadcast(EventId.GetDesertBattleHospitalViewData)
end

function ActDragonManager:GetTreatmentSpeed()
  return self.treatmentSpeed
end

function ActDragonManager:GetUnitTreatmentNum()
  return self.unitTreatmentNum
end

function ActDragonManager:GetTreatmentSoldierDataList()
  local rst = {}
  for k, v in ipairs(self.treatmentSoldierList) do
    local deadTotal = v.deadTotal and tonumber(v.deadTotal) or 0
    if 0 < deadTotal then
      table.insert(rst, v)
    end
  end
  return rst
end

function ActDragonManager:GetAccumulativeTreatmentSoldierNum()
  return self.accumulativeTreatmentSoldierNum
end

function ActDragonManager:SendDragonHospitalFinishMsg()
  SFSNetwork.SendMessage(MsgDefines.DragonHospitalFinish)
end

function ActDragonManager:OnHandleDragonHospitalFinish()
  self.treatmentFinishSoldierNum = 0
  self:SendDragonHospitalViewMsg()
  EventManager:GetInstance():Broadcast(EventId.GetDesertBattleTreatmentSoldierNum, 0)
end

function ActDragonManager:CheckCanWatch(checkGroup)
  local group = self:GetGroup(checkGroup)
  if group == nil then
    return false
  end
  if not self:InDragonBattleTime(checkGroup) or not group:IsInMatch() then
    return false
  end
  if DataCenter.ActDragonManager:TodayEnterDragonWorld() then
    local myGroup = self:GetMyGroup()
    if myGroup then
      if myGroup.group == checkGroup then
        return DataCenter.ActDragonManager:TodayLeaveDragonWorld()
      elseif self:InDragonBattleTime(myGroup.group) and myGroup:IsInMatch() then
        return DataCenter.ActDragonManager:TodayLeaveDragonWorld()
      end
    end
  end
  return true
end

function ActDragonManager:GetMyGroup()
  return self.actInfo ~= nil and self.actInfo:GetMyGroup() or nil
end

function ActDragonManager:GetCurGroup()
  local watchIdx = BattleFieldUtil.ObserveIdx()
  if BattleFieldUtil.isObserve and watchIdx ~= 0 then
    return self:GetGroup(watchIdx)
  end
  return self:GetMyGroup()
end

function ActDragonManager:GetCurGroupIdx()
  local myGroup = self:GetCurGroup()
  return myGroup ~= nil and myGroup.group or 0
end

function ActDragonManager:GetCurBattleInfo()
  local group = self:GetCurGroupIdx()
  return self.battleInfos[group]
end

function ActDragonManager:GetGroup(idx)
  return self.actInfo ~= nil and self.actInfo:GetGroup(idx) or nil
end

function ActDragonManager:GetBattleInfo(idx)
  return self.battleInfos[idx]
end

function ActDragonManager:GetRewardInfo()
  return self.rewardInfo
end

function ActDragonManager:GetBattleTimeInfo()
  return self.battleTimes
end

function ActDragonManager:GetBattleTimeInfoByBattlePeriod(targetBattlePeriod)
  if self.battleTimes then
    local count = table.count(self.battleTimes)
    for i = 1, count do
      local battleTimeInfo = self.battleTimes[i]
      if battleTimeInfo.battlePeriod == targetBattlePeriod then
        return battleTimeInfo
      end
    end
  end
  return nil
end

function ActDragonManager:GetBattleHistory()
  return self.battleHistory
end

function ActDragonManager:GetScoreInfo(type)
  if self.scoreArr then
    if type == 5 then
      return self.scoreArr.winScore
    elseif type == 6 then
      return self.scoreArr.loseScore
    end
  end
  return nil
end

function ActDragonManager:GetGuideList()
  if self.theGuideList == nil then
    self.theGuideList = BattleFieldUtil.GetGuideList(BattleFieldType.Desert)
  end
  return self.theGuideList
end

function ActDragonManager:CheckBattleStart()
  return self:InDragonBattleTime()
end

function ActDragonManager:InDragonBattleTime(groupIdx)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local dragonInfo = self:GetActInfo()
  if dragonInfo == nil or dragonInfo.actEndTime ~= nil then
    return false
  end
  local tmpIdx = groupIdx or 0
  local groupInfo = tmpIdx == 0 and self:GetCurGroup() or self:GetGroup(tmpIdx)
  local timeInfo = groupInfo ~= nil and groupInfo.timeInfo or nil
  if timeInfo ~= nil and timeInfo.endTime ~= nil and timeInfo.prepTime ~= nil and curTime < timeInfo.endTime and curTime > timeInfo.prepTime then
    return true
  end
  return false
end

function ActDragonManager:TodayEnterDragonWorld()
  local time = CommonUtil.PlayerPrefsGetString(EnterDragonWorld .. BattleFieldType.Desert, "")
  if time ~= nil and time ~= "" then
    local now = UITimeManager:GetInstance():GetServerSeconds()
    return UITimeManager:GetInstance():IsSameDayForServer(tonumber(time) or 0, now)
  end
  return false
end

function ActDragonManager:CleanTodayEnterDragonWorld()
  CommonUtil.PlayerPrefsSetString(EnterDragonWorld .. BattleFieldType.Desert, "")
end

function ActDragonManager:SignTodayLevelDragonWorld()
  local myGroup = self:GetMyGroup()
  if myGroup ~= nil then
    myGroup.exitDragon = true
  end
end

function ActDragonManager:ReqLevelDragonWorld()
  if BattleFieldUtil.isObserve then
    return
  end
  local myGroup = self:GetMyGroup()
  local group = myGroup ~= nil and myGroup.group or 0
  if group ~= nil then
    SFSNetwork.SendMessage(MsgDefines.ExitDragonServer, group)
    self:SignTodayLevelDragonWorld()
  end
end

function ActDragonManager:TodayLeaveDragonWorld()
  local group = self:GetMyGroup()
  if group ~= nil then
    return group.exitDragon
  end
  return false
end

function ActDragonManager:TodayDontShowJumpTipAgain()
  local time = CommonUtil.PlayerPrefsGetString(DragonDontShowJumpTip, "")
  if time ~= nil and time ~= "" then
    local now = UITimeManager:GetInstance():GetServerSeconds()
    return UITimeManager:GetInstance():IsSameDayForServer(tonumber(time) or 0, now)
  end
  return false
end

function ActDragonManager:CheckGotoTipStatus(enroll)
  if not RaceEntranceUtil.IsOldEntranceOpen() then
    return nil
  end
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.ActDragon.ActId)
  if activityData ~= nil then
    if self.actInfo ~= nil and self.actInfo.stopSignUpTime ~= nil then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < self.actInfo.stopSignUpTime then
        local strK = ActDragon458252 .. LuaEntry.Player.uid
        local lastTime = Setting:GetString(strK, "")
        local now = UITimeManager:GetInstance():GetServerSeconds()
        if lastTime ~= nil and lastTime ~= "" and now - toInt(lastTime) < 432000 then
          return nil
        end
        if enroll then
          return "458252"
        else
          return nil
        end
      end
      local myGroup = self:GetCurGroup()
      if myGroup == nil then
        return nil
      end
      local timeInfo = myGroup.timeInfo
      if timeInfo and myGroup.assigned ~= 0 and timeInfo.endTime ~= nil and curTime >= timeInfo.prepTime and curTime <= timeInfo.endTime then
        if myGroup.assigned == 2 and curTime < timeInfo.battleOpenTime then
          return nil
        end
        local strK = ActDragon458253 .. LuaEntry.Player.uid
        local lastTime = Setting:GetString(strK, "")
        local now = UITimeManager:GetInstance():GetServerSeconds()
        if lastTime ~= nil and lastTime ~= "" and now - toInt(lastTime) < 259200 then
          return nil
        end
        if not enroll then
          return "458253"
        else
          return nil
        end
      end
    else
      return ""
    end
  end
  return nil
end

function ActDragonManager:RecordGotoTipStatus(enroll)
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if enroll then
    local strK = ActDragon458252 .. LuaEntry.Player.uid
    Setting:SetString(strK, tostring(now))
  else
    local strK = ActDragon458253 .. LuaEntry.Player.uid
    Setting:SetString(strK, tostring(now))
  end
end

function ActDragonManager:GetClosestPos(target)
  local ret = target
  local findBestPos = false
  local box = {}
  local list = CS.SceneManager.World:GetAllDragonPointList()
  local cityList = CS.SceneManager.World:GetAllMainBaseList()
  local resList = CS.SceneManager.World:GetAllDragonResourceList()
  local TileIndexToWorld = SceneUtils.TileIndexToWorld
  for bestLen = 36, 200, 20 do
    if list then
      for k, v in pairs(list) do
        local detailInfo = v.detail
        if detailInfo ~= nil then
          local buildId = detailInfo.BuildId or detailInfo.ItemId
          if (buildId == 10110 or buildId == "10110") and detailInfo.Score ~= nil then
            if #box == 0 then
              table.insert(box, v.mainIndex)
            end
          else
            local pos = TileIndexToWorld(v.mainIndex, ForceChangeScene.World)
            if bestLen > math.abs(pos.x - target.x) and bestLen > math.abs(pos.z - target.z) then
              ret = pos
              findBestPos = true
              break
            end
          end
        end
      end
      if not findBestPos then
        for _, mainIndex in ipairs(box) do
          local pos = TileIndexToWorld(mainIndex, ForceChangeScene.World)
          if bestLen > math.abs(pos.x - target.x) and bestLen > math.abs(pos.z - target.z) then
            ret = pos
            findBestPos = true
            break
          end
        end
      end
    end
    if not findBestPos and cityList ~= nil then
      for k, v in pairs(cityList) do
        local pos = TileIndexToWorld(v.mainIndex, ForceChangeScene.World)
        if bestLen > math.abs(pos.x - target.x) and bestLen > math.abs(pos.z - target.z) then
          ret = pos
          findBestPos = true
          break
        end
      end
    end
    if not findBestPos and resList ~= nil then
      for k, v in pairs(resList) do
        local pointIndex = v
        local pos = TileIndexToWorld(pointIndex, ForceChangeScene.World)
        if bestLen > math.abs(pos.x - target.x) and bestLen > math.abs(pos.z - target.z) then
          ret = pos
          findBestPos = true
          break
        end
      end
    end
    if findBestPos then
      break
    end
  end
  return ret
end

function ActDragonManager:UpdateAreaMaterial(mapHandle)
  if mapHandle == nil then
    return
  end
  local battleInfo = self:GetCurBattleInfo()
  local selfSide = battleInfo ~= nil and battleInfo.selfSide or 0
  local myIdx = selfSide == 1 and 1 or 0
  for i = 0, 1 do
    local colorIdx = myIdx == i and 1 or 0
    local renderer = mapHandle:GetRenderer(i)
    if IsNotNull(renderer) then
      renderer.sharedMaterial = mapHandle:GetMaterial(colorIdx)
    end
  end
end

function ActDragonManager:HandleBattleBehaviorData(message)
  if message == nil then
    return
  end
  local data = BattleBehaviorData.New()
  data:ParseData(message)
  EventManager:GetInstance():Broadcast(EventId.DragonBattleBehaviorNotify, data)
end

function ActDragonManager:HandleDragonTeamGroupCancel(message)
  if message == nil then
    return
  end
  if message.ret == 1 then
    local info = self:GetActInfo()
    if info then
      info.hadTeam2 = 2
      EventManager:GetInstance():Broadcast(EventId.DragonInfoRefresh)
    end
  end
end

function ActDragonManager:HandleDragonTeamGroupOpen(message)
  if message == nil then
    return
  end
  local info = self:GetActInfo()
  if info then
    info.hadTeam2 = 1
    info.groupOpenCDEndTime = message.groupOpenCDEndTime
    if info.group2 then
      info.group2.signUp = 0
      info.group2.battlePeriod = 0
    end
    EventManager:GetInstance():Broadcast(EventId.DragonInfoRefresh)
  end
end

function ActDragonManager:LoadTeamSprite(image, curIdx)
  local teamStr = curIdx == 1 and "A" or "B"
  image:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldDesertPath, "lrb_shamofengbao_" .. teamStr), function()
    image:SetNativeSize()
  end)
end

function ActDragonManager:CheckErrorHideUI(errCode)
  if errCode == "Desert_strom_tips1037" then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertSelectUserV2)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleFieldSelectTime)
  end
end

function ActDragonManager:HandleBuildTopMarch(message)
  if message == nil then
    return
  end
  local list = message.topMarch
  if not list then
    return
  end
  self.buildTopMarch = {}
  for _, v in pairs(list) do
    self:HandleBuildingHpChange(v)
  end
end

function ActDragonManager:GetBGM(bUp)
  local soundCheckTime = -1
  if bUp == nil then
    local detailInfo = BattleFieldUtil.GetDetailInfoByCfgId(10000)
    if detailInfo ~= nil and detailInfo.State == 0 then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local openTime = detailInfo.OpenTime or 0
      if curTime < openTime then
        soundCheckTime = openTime
      else
        bUp = true
      end
    end
  end
  return bUp and 30002 or 30001, soundCheckTime
end

function ActDragonManager:GetUpdateNodes()
  if self.updateNodes == nil then
    local list = {}
    LocalController:instance():visitTable(TableName.Desert_Battle_Update_Note, function(id, lineData)
      table.insert(list, {
        id = tonumber(lineData:getValue("id")) or 0,
        title = lineData:getValue("tittle") or "",
        desc = lineData:getValue("desc") or ""
      })
    end)
    self.updateNodes = list
  end
  return self.updateNodes or {}
end

function ActDragonManager:GetBuildUpEffInfo(allianceId)
  local effInfo = BattleFieldUtil.GetDetailInfoByCfgId(10040)
  local effAId = effInfo ~= nil and effInfo.AllianceId or nil
  local bUp = effAId ~= nil and effAId ~= "" and effAId ~= "0" and effAId == allianceId
  local template = DataCenter.DragonBuildTemplateManager:GetTemplate(10040)
  local effNum = template ~= nil and template.special_effect_number or 1
  return bUp, effNum
end

function ActDragonManager:SendCommanderList()
  local groupIdx = self:GetCurGroupIdx()
  SFSNetwork.SendMessage(MsgDefines.DragonCommanderList, groupIdx)
end

function ActDragonManager:HandleCommanderList(message)
  local data = message ~= nil and message.data or nil
  if data then
    local oldDic = self.commandersDic
    local dic = {}
    for _, v in pairs(data) do
      local uid = v.uid
      local info = oldDic ~= nil and oldDic[uid] or nil
      info = info or ActDragonCommanderData.New()
      info:ParseData(v)
      dic[uid] = info
    end
    self.commandersDic = dic
    EventManager:GetInstance():Broadcast(EventId.GetDagonPlayerList)
  end
end

function ActDragonManager:IsSelfCommander()
  if BattleFieldUtil.isObserve then
    return false
  end
  local myUid = LuaEntry.Player:GetUid()
  if self:GetCommanderByUid(myUid) ~= nil then
    return true
  end
  local pInfo = self:GetPlayerInfoByUID(myUid)
  if pInfo and pInfo.commander then
    return true
  end
  return false
end

function ActDragonManager:GetCommanderByUid(uid)
  return self.commandersDic ~= nil and self.commandersDic[uid] or nil
end

function ActDragonManager:GetCommanderList()
  if self.commandersDic == nil then
    return {}
  end
  local values = table.values(self.commandersDic)
  table.sort(values, function(a, b)
    local pA = self:GetPlayerInfoByUID(a.uid)
    local pB = self:GetPlayerInfoByUID(b.uid)
    if pA and pB then
      return pA.power > pB.power
    end
    return false
  end)
  return values
end

function ActDragonManager:SendCommanderModify(uid, group, type)
  if self.playerList[uid] ~= nil then
    local flag = type == 1 and true or false
    if self.playerList[uid].commander == flag then
      return
    end
    SFSNetwork.SendMessage(MsgDefines.DragonCommanderModify, group, type, uid)
  end
end

function ActDragonManager:HandleCommanderModify(message)
  if message == nil then
    return
  end
  local uid = message.uid
  local bAdd = message.type == 1
  local oUid = message.operator
  if BattleFieldUtil.InBattleField(BattleFieldType.Desert) and uid == LuaEntry.Player:GetUid() and oUid and oUid ~= LuaEntry.Player:GetUid() then
    local oInfo = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(oUid)
    if oInfo then
      local nameStr = UIUtil.FormatAllianceAndName(nil, oInfo.name, oInfo.uid)
      local keyId = bAdd and "Desert_strom_tips1069" or "Desert_strom_tips1068"
      UIUtil.ShowTips(Localization:GetString(keyId, nameStr))
    end
  end
  local bBroadcast = false
  local player = self:GetPlayerInfoByUID(uid)
  if player then
    player.commander = bAdd
    bBroadcast = true
  end
  local commander = self:GetCommanderByUid(uid)
  if bAdd then
    if commander == nil then
      commander = ActDragonCommanderData.New()
      if self.commandersDic == nil then
        self.commandersDic = {}
      end
      self.commandersDic[uid] = commander
    end
    commander:ParseData(message)
    bBroadcast = true
  elseif commander and self.commandersDic then
    self.commandersDic[uid] = nil
    bBroadcast = true
  end
  if bBroadcast then
    EventManager:GetInstance():Broadcast(EventId.GetDagonPlayerList)
  end
  local removeOrder = message.removeOrder
  if removeOrder then
    for _, v in pairs(removeOrder) do
      self:HandleOneCommandOrder({index = v}, 2, false)
    end
    EventManager:GetInstance():Broadcast(EventId.DragonCommandOrderUpdate)
  end
end

function ActDragonManager:SendCommandOrderList()
  local groupIdx = self:GetCurGroupIdx()
  SFSNetwork.SendMessage(MsgDefines.DragonCommandOrderList, groupIdx)
end

function ActDragonManager:GetLastNewOrderTime()
  return self.lastNewOrderTime or 0
end

function ActDragonManager:HandleOneCommandOrder(message, type, notify)
  local index = message ~= nil and message.index or -1
  local info = self:GetOrderByIndex(index)
  if type == 1 then
    if info then
      info:ResetData()
    else
      info = ActDragonCommandOrderData.New()
    end
    info:ParseData(message)
    if self.orders == nil then
      self.orders = {}
    end
    if not info.hadJoin and info.commander ~= LuaEntry.Player:GetUid() then
      info.bNew = true
    end
    self.orders[index] = info
    self.lastNewOrderTime = UITimeManager:GetInstance():GetServerTime()
    self:AddOrderMark(index)
    if notify then
      EventManager:GetInstance():Broadcast(EventId.DragonCommandOrderUpdate, index)
    end
  elseif type == 2 then
    self:DelOrderMark(index)
    if info then
      self.orders[index] = nil
      if notify then
        EventManager:GetInstance():Broadcast(EventId.DragonCommandOrderUpdate, index)
      end
    end
  elseif type == 3 and info then
    info.joinCount = message.joinCount or 0
    if notify then
      EventManager:GetInstance():Broadcast(EventId.DragonCommandOrderUpdate, index)
    end
  end
end

function ActDragonManager:HandleCommandOrderList(message)
  local data = message ~= nil and message.data or nil
  if data then
    self.orders = {}
    for _, v in pairs(data) do
      self:HandleOneCommandOrder(v, 1, false)
    end
    EventManager:GetInstance():Broadcast(EventId.DragonCommandOrderUpdate)
  end
end

function ActDragonManager:GetOrderByIndex(index)
  return self.orders ~= nil and self.orders[index] or nil
end

function ActDragonManager:GetOrders()
  return self.orders or {}
end

function ActDragonManager:TrySendCommandOrder(info)
  local idx = self:CheckPointHaveOrder(info.point)
  if idx ~= 0 then
    self:ShowCommandOrderDelTip(idx, true, function()
      self:SendCommandOrder(idx, info)
    end)
    return
  end
  for i = 1, 3 do
    if self:GetOrderByIndex(i) == nil then
      idx = i
      break
    end
  end
  if idx == 0 then
    EventManager:GetInstance():Broadcast(EventId.DragonCommandOrderShow, info)
  else
    self:SendCommandOrder(idx, info)
  end
end

function ActDragonManager:ShowCommandOrderDelTip(idx, bReplace, cb)
  local order = self:GetOrderByIndex(idx)
  local flag = false
  local commander = order ~= nil and order.commander or ""
  if commander == LuaEntry.Player:GetUid() then
    flag = true
  end
  flag = flag or self:TodayDontShowJumpTipAgain()
  if flag then
    if cb then
      cb()
    end
    return
  end
  local pInfo = self:GetPlayerInfoByUID(commander)
  local commanderName = pInfo ~= nil and UIUtil.FormatAllianceAndName(nil, pInfo.name, pInfo.uid) or ""
  UIUtil.ShowSecondMessageByParam({
    tipText = Localization:GetString(bReplace and "Desert_strom_commander_1037" or "Desert_strom_commander_1038", commanderName),
    btnNum = 2,
    showToggle = true,
    toggleAction = function(isOn)
      if isOn then
        CommonUtil.PlayerPrefsSetString(DragonDontShowJumpTip, "")
      else
        CommonUtil.PlayerPrefsSetString(DragonDontShowJumpTip, tostring(UITimeManager:GetInstance():GetServerSeconds()))
      end
    end,
    sureAction = cb
  })
end

function ActDragonManager:SendCommandOrder(idx, info)
  local groupIdx = self:GetCurGroupIdx()
  SFSNetwork.SendMessage(MsgDefines.DragonCommandOrder, groupIdx, idx, info.type, info.point, info.extra)
end

function ActDragonManager:SendCommandOrderDel(index, ignoreTip)
  if ignoreTip then
    SFSNetwork.SendMessage(MsgDefines.DragonCommandOrderDel, self:GetCurGroupIdx(), index)
    return
  end
  self:ShowCommandOrderDelTip(index, false, function()
    SFSNetwork.SendMessage(MsgDefines.DragonCommandOrderDel, self:GetCurGroupIdx(), index)
  end)
end

function ActDragonManager:SendCommandOrderExec(index)
  local groupIdx = self:GetCurGroupIdx()
  SFSNetwork.SendMessage(MsgDefines.DragonCommandOrderExec, groupIdx, index)
end

function ActDragonManager:GetOrderImgByType(type)
  local img
  if type == WorldPointBtnType.DragonCommandOrderTypeAssist then
    img = "mjc_smzc_icon_s_fangyu"
  elseif type == WorldPointBtnType.DragonCommandOrderTypeAtk then
    img = "mjc_smzc_icon_s_jingong"
  elseif type == WorldPointBtnType.DragonCommandOrderTypePick then
    img = "mjc_smzc_icon_s_caiji"
  end
  if string.IsNullOrEmpty(img) then
    return nil
  end
  return string.format(LoadPath.LWBattleFieldDesertPath, img)
end

function ActDragonManager:GetOrderIcon(order)
  if order == nil or string.IsNullOrEmpty(order.extra) then
    return
  end
  local extraData = rapidjson.decode(order.extra)
  if extraData == nil then
    return
  end
  if extraData.buildId then
    local template = DataCenter.DragonBuildTemplateManager:GetTemplate(extraData.buildId)
    if template then
      return template:GetDetailPath(), 1
    end
  elseif extraData.skinId then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(extraData.skinId)
    if template then
      return template.icon, 1
    end
  end
  return
end

function ActDragonManager:CleanOrderMark()
  if self.orderMarkDic then
    for _, v in pairs(self.orderMarkDic) do
      v:Destroy()
    end
    self.orderMarkDic = nil
  end
end

function ActDragonManager:ShowOrderMark(order)
  local request = self.orderMarkDic ~= nil and self.orderMarkDic[order.index] or nil
  if request ~= nil then
    local worldPoint = BuildingUtils.GetBuildModelCenterVec(order.point, 1, 1, ForceChangeScene.World)
    local v3 = Vector3.New(worldPoint.x, worldPoint.y, worldPoint.z)
    local transform = request.gameObject.transform
    transform.position = v3
  end
end

function ActDragonManager:AddOrderMark(index)
  self:DelOrderMark(index)
  local order = self:GetOrderByIndex(index)
  if order == nil then
    return
  end
  local request = self.orderMarkDic ~= nil and self.orderMarkDic[index] or nil
  if request ~= nil then
    self:ShowOrderMark(order)
    return
  end
  local path = string.format(BASE_ORDER_MARK_PATH, order.type)
  request = ResourceManager:InstantiateAsync(path)
  request:completed("+", function()
    order = self:GetOrderByIndex(index)
    if not (order ~= nil and CS.SceneManager:IsInWorld()) or not BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
      request:Destroy()
      return
    elseif request.isError then
      request:Destroy()
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.name = "DesertBattleMark_" .. index
    if self.orderMarkDic == nil then
      self.orderMarkDic = {}
    end
    self.orderMarkDic[index] = request
    self:ShowOrderMark(order)
  end)
end

function ActDragonManager:DelOrderMark(index)
  if self.orderMarkDic and self.orderMarkDic[index] then
    self.orderMarkDic[index]:Destroy()
    self.orderMarkDic[index] = nil
  end
end

function ActDragonManager:CheckPointHaveOrder(point)
  local orders = self:GetOrders()
  for i, order in pairs(orders) do
    if order.point == point then
      return i
    end
  end
  return 0
end

function ActDragonManager:CheckAllianceIsValid()
  local groupInfo = self:GetCurGroup()
  if groupInfo and groupInfo.signUp == self.SignUpState.SignUp and groupInfo.matchResult == 1 then
    return true
  end
end

function ActDragonManager:CheckSelfAssigned()
  local myGroup = self:GetMyGroup()
  return myGroup ~= nil and myGroup.assigned ~= 0 or false
end

function ActDragonManager:TryGetDesertBattleRoomId()
  local group = DataCenter.ActDragonManager:GetCurGroup()
  local groupId = group ~= nil and group:GetMyAllianceGroupId() or 0
  return string.format("%s%s%s_%s", ChatInterface.GetRoomIdPrefix(), ChatInterface.getDragonGroupType(true), groupId, BattleFieldType.Desert)
end

function ActDragonManager:Description()
  local sb = StringBuilder.New()
  local mgr = UITimeManager:GetInstance()
  local curSec = mgr:GetServerSeconds()
  local time = CommonUtil.PlayerPrefsGetString(EnterDragonWorld .. BattleFieldType.Desert, "")
  sb:AppendFormatLine("\229\189\147\229\137\141\230\151\182\233\151\180\239\188\136\231\167\146\239\188\137 = %s(%s)", mgr:GetServerTimeByUTC(curSec * 1000), curSec)
  if time == "" then
    sb:AppendFormatLine("\229\189\147\229\137\141\232\191\155\229\133\165\230\136\152\229\156\186\230\160\135\232\174\176: \230\151\160")
  else
    local sign = tonumber(time) or 0
    sb:AppendFormatLine("\228\187\138\230\151\165\232\191\155\229\133\165\230\136\152\229\156\186\230\160\135\232\174\176\239\188\136\231\167\146\239\188\137 = %s(%s)", mgr:GetServerTimeByUTC(sign * 1000), sign)
    sb:AppendFormatLine("\230\152\175\229\144\166\230\152\175\228\187\138\229\164\169\230\156\137\230\160\135\232\174\176: %s", mgr:IsSameDayForServer(sign, curSec))
  end
  sb:AppendLine()
  sb:AppendLine(self.actInfo ~= nil and self.actInfo:Description() or "")
  return sb:ToString()
end

function ActDragonManager:Test()
  if not CommonUtil.IsDebug() then
    return false
  end
  local t = {
    scoreInfo = {
      {
        collectScore = 0,
        side = 1,
        occupyScore = 880,
        icon = "1",
        centerControlTime = 0,
        serverId = 160,
        allianceId = "40a00e4907ba458f84fb0136c1e56dc5",
        score = 880,
        brokeScore = 0,
        maxPlayerNum = 20,
        killScore = 110760,
        currPlayerNum = 1,
        name = "123",
        power = 4405047766,
        abbr = "yb2",
        win = 0,
        killMvp = {
          collectScore = 0,
          level = 35,
          occupyScore = 8800,
          heroId = 50019,
          pic = "",
          picVer = 0,
          uid = LuaEntry.Player:GetUid(),
          score = 119560,
          brokeScore = 0,
          thumbsUpCount = 3231,
          killScore = 110760,
          name = "123",
          abbr = "yb2"
        },
        mvp = {
          collectScore = 0,
          level = 35,
          occupyScore = 8800,
          heroId = 50019,
          pic = "",
          picVer = 0,
          uid = LuaEntry.Player:GetUid(),
          score = 119560,
          brokeScore = 0,
          thumbsUpCount = 3231,
          killScore = 110760,
          name = "123",
          abbr = "yb2"
        },
        collectMvp = {
          collectScore = 0,
          level = 29,
          occupyScore = 3700,
          heroId = 50006,
          pic = "",
          picVer = 1,
          uid = "7156761701000160",
          score = 4646,
          brokeScore = 0,
          thumbsUpCount = 0,
          killScore = 946,
          name = "ffffff",
          abbr = "kjj"
        },
        occupyMvp = {
          collectScore = 0,
          level = 35,
          occupyScore = 8800,
          heroId = 50019,
          pic = "",
          picVer = 0,
          uid = "7550692381000160",
          score = 119560,
          brokeScore = 0,
          thumbsUpCount = 3231,
          killScore = 110760,
          name = "123",
          abbr = "yb2"
        },
        userList = {
          {
            avgBrokeScore = 0,
            collectScore = 0,
            occupyScore = 8800,
            avgOccupyScore = 4483,
            pic = "",
            picVer = 0,
            avgCollectScore = 0,
            uid = LuaEntry.Player:GetUid(),
            score = 119560,
            maxBrokeScore = 0,
            brokeScore = 0,
            mvpId = 1,
            killScore = 110760,
            maxOccupyScore = 15100,
            name = LuaEntry.Player:GetName(),
            maxCollectScore = 0,
            avgKillScore = 117690,
            abbr = "Test",
            maxKillScore = 320480
          },
          {
            avgBrokeScore = 0,
            collectScore = 0,
            occupyScore = 8800,
            avgOccupyScore = 4483,
            pic = "",
            picVer = 0,
            avgCollectScore = 0,
            uid = "7550692381000160",
            score = 119560,
            maxBrokeScore = 0,
            brokeScore = 0,
            mvpId = 1,
            killScore = 110760,
            maxOccupyScore = 15100,
            name = "123",
            maxCollectScore = 0,
            avgKillScore = 117690,
            abbr = "yb2",
            maxKillScore = 320480
          },
          {
            avgBrokeScore = 0,
            collectScore = 0,
            occupyScore = 3700,
            avgOccupyScore = 0,
            pic = "",
            picVer = 1,
            avgCollectScore = 0,
            uid = "7156761701000160",
            score = 4646,
            maxBrokeScore = 0,
            brokeScore = 0,
            mvpId = 1,
            killScore = 946,
            maxOccupyScore = 0,
            name = "ffffff",
            maxCollectScore = 0,
            avgKillScore = 0,
            abbr = "kjj",
            maxKillScore = 0
          }
        }
      }
    },
    reward = {
      {
        total = 3482600,
        type = 40,
        value = 20000
      },
      {
        type = 7,
        value = {
          itemId = "200211",
          otherPara = "",
          rewardAdd = 215,
          use = "0",
          count = 149848,
          para1 = "7",
          para2 = "1",
          para3 = "300",
          uuid = "5453859929471843"
        }
      },
      {
        type = 7,
        value = {
          itemId = "520005",
          rewardAdd = 21,
          use = "1",
          count = 6880,
          para1 = "2",
          para2 = "8",
          para3 = "1",
          uuid = "4a15eba16f7042d6b258d58d836e0a79"
        }
      },
      {
        type = 7,
        value = {
          itemId = "520006",
          rewardAdd = 21,
          use = "1",
          count = 6880,
          para1 = "4",
          para2 = "8",
          para3 = "1",
          uuid = "ce3bac7861dc4f9ea3cf4e9b078e3107"
        }
      },
      {
        type = 7,
        value = {
          itemId = "520007",
          rewardAdd = 21,
          use = "1",
          count = 8076,
          para1 = "3",
          para2 = "8",
          para3 = "1",
          uuid = "ac3baa14eddb496b8d6b903dfc60e084"
        }
      },
      {
        type = 7,
        value = {
          itemId = "700001",
          rewardAdd = 1,
          use = "1",
          count = 280,
          para1 = "106020050",
          uuid = "cce0983e92fb4dc89c34ecb0d316390f"
        }
      },
      {
        type = 7,
        value = {
          itemId = "200221",
          rewardAdd = 10,
          use = "0",
          count = 10111,
          para1 = "6",
          para2 = "1",
          para3 = "300",
          uuid = "388c7a92d8944a4994222a87ea3f9e79"
        }
      },
      {
        type = 7,
        value = {
          itemId = "200211",
          otherPara = "",
          rewardAdd = 19,
          use = "0",
          count = 149867,
          para1 = "7",
          para2 = "1",
          para3 = "300",
          uuid = "5453859929471843"
        }
      },
      {
        type = 7,
        value = {
          itemId = "200241",
          rewardAdd = 10,
          use = "0",
          count = 3927,
          para1 = "4",
          para2 = "1",
          para3 = "300",
          uuid = "fa941e799e4e48a49e737ea073ae4978"
        }
      },
      {
        type = 7,
        value = {
          itemId = "200201",
          rewardAdd = 14,
          use = "0",
          count = 5237,
          para1 = "1",
          para2 = "1",
          para3 = "300",
          uuid = "066189244cc0414386faca3ec855d17a"
        }
      },
      {
        type = 7,
        value = {
          itemId = "200231",
          otherPara = "",
          rewardAdd = 7,
          use = "0",
          count = 3703,
          para1 = "3",
          para2 = "1",
          para3 = "300",
          uuid = "5453859929472566"
        }
      },
      {
        type = 7,
        value = {
          itemId = "200231",
          otherPara = "",
          rewardAdd = 60,
          use = "0",
          count = 3763,
          para1 = "3",
          para2 = "1",
          para3 = "300",
          uuid = "5453859929472566"
        }
      },
      {
        type = 7,
        value = {
          itemId = "200241",
          rewardAdd = 60,
          use = "0",
          count = 3987,
          para1 = "4",
          para2 = "1",
          para3 = "300",
          uuid = "fa941e799e4e48a49e737ea073ae4978"
        }
      },
      {
        type = 27,
        value = {
          addNum = 160,
          add = 160,
          itemId = 7005,
          number = 103037,
          uuid = 5453859931420057
        }
      }
    }
  }
  self:HandleBattleScore(t)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleResultS0, {anim = false})
  return true
end

BattleFieldUtil.MergeFunctions(ActDragonManager, "DataCenter.ActDragonManager.Module.BuildInfo")
BattleFieldUtil.MergeFunctions(ActDragonManager, "DataCenter.ActDragonManager.Module.EnterBattle")
Implement(ActDragonManager, InterfaceConfig.BattlefieldManager, InterfaceConfig.BattlefieldTreatment, InterfaceConfig.BattlefieldEnterCheck)
return ActDragonManager
