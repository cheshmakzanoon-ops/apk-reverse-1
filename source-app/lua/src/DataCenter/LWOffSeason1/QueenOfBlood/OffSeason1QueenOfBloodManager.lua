local OffSeason1QueenOfBloodManager = BaseClass("OffSeason1QueenOfBloodManager")

function OffSeason1QueenOfBloodManager:__init()
  self.activityState = nil
  self.activityStateEndTime = 0
  self.cityInfoList = nil
  self.battleState = nil
  self.battleStateEndTime = 0
  self.allianceList = nil
  self.activityInfo = nil
  self.nowCheckAllianceCityId = nil
  self.monsterInfos = nil
  self.activityCount = 0
  self.maxDefendNum = 0
  self.roundInfo = {}
  self.challengeMonsterIndexData = {}
  self.recordGotoTip = false
  self.personalRankDataArray = nil
  self.allianceRankDataArray = nil
end

function OffSeason1QueenOfBloodManager:__delete()
  self.activityState = nil
  self.activityStateEndTime = nil
  self.cityInfoList = nil
  self.battleState = nil
  self.battleStateEndTime = nil
  self.allianceList = nil
  self.activityInfo = nil
  self.nowCheckAllianceCityId = nil
  self.monsterInfos = nil
  self.activityCount = nil
  self.roundInfo = nil
  self.challengeMonsterIndexData = nil
  self.maxDefendNum = nil
  self.chooseCountLimit = nil
  self.nowChooseCount = nil
  self.recordGotoTip = false
  self.personalRankDataArray = nil
  self.allianceRankDataArray = nil
end

function OffSeason1QueenOfBloodManager:QueenOfBloodActivityInfoMessage(msg)
  if msg then
    local preActivityState = self.activityState
    self.activityState = msg.activityState
    self.activityStateEndTime = msg.activityStateEnd
    self.chooseCountLimit = msg.chooseCountLimit
    self.nowChooseCount = 0
    self.cityInfoList = msg.cityInfo
    if self.cityInfoList and 0 < #self.cityInfoList then
      table.sort(self.cityInfoList, function(a, b)
        if a.defendInfo.battleLv ~= b.defendInfo.battleLv then
          return a.defendInfo.battleLv < b.defendInfo.battleLv
        else
          return a.cityId < b.cityId
        end
      end)
      for i, v in ipairs(self.cityInfoList) do
        if v.defendInfo.isChoose then
          self.nowChooseCount = self.nowChooseCount + 1
        end
      end
    end
    self.battleState = msg.battleState
    self.monsterInfos = msg.monsterInfos
    self.battleStateEndTime = msg.battleStateEnd
    self.activityCount = msg.activityCount
    if self.activityState then
      if self.activityState == QueenOfBloodActivityState.battle then
        self:RefreshRoundInfo(msg)
        self.roundInfo.maxRound = msg.maxCount
      else
        self:ClearRoundInfo()
      end
    else
      self:ClearRoundInfo()
    end
    EventManager:GetInstance():Broadcast(EventId.QueenOfBloodMainInfoUpdate)
    if preActivityState and self.activityState and self.activityState ~= preActivityState and self.activityState ~= QueenOfBloodActivityState.battle and preActivityState == QueenOfBloodActivityState.battle and CS.SceneManager.CurrSceneID == SceneManagerSceneID.World and LuaEntry.Player:AtHomeNow() then
      EventManager:GetInstance():Broadcast(EventId.QueenOfBloodChangeWorldBgm)
    end
    self:BroadcastRefreshMainQueenOfBloodTip(false)
  end
end

function OffSeason1QueenOfBloodManager:QueenOfBloodRefreshAllianceListMessage(msg)
  if msg and msg.allianceList then
    self.allianceList = msg.allianceList
    EventManager:GetInstance():Broadcast(EventId.ShowQueenOfBloodAllianceList, self.nowCheckAllianceCityId)
  end
end

function OffSeason1QueenOfBloodManager:OnPushBloodQueenHpChangeMessage(msg)
  if self.cityInfoList then
    for i, v in ipairs(self.cityInfoList) do
      if v.cityId == msg.cityId and v.defendInfo then
        local diff = v.defendInfo.hp - msg.curHp
        v.defendInfo.hp = msg.curHp
        EventManager:GetInstance():Broadcast(EventId.PushBloodQueenHpChange, v)
        if 0 < diff then
          DataCenter.AllianceCityTipManager:ShowBloodQueenHpChangeTip(diff, v.cityId)
        end
        break
      end
    end
  end
end

function OffSeason1QueenOfBloodManager:QueenOfBloodActivityInfoAllMonsterMessage(msg)
  local checkPre = self.monsterInfos == nil or self.monsterInfos[1] == nil
  self.monsterInfos = msg.monsterInfos
  local checkAfter = self.monsterInfos ~= nil and self.monsterInfos[1] ~= nil
  EventManager:GetInstance():Broadcast(EventId.RefreshQueenOfBloodActivityInfoAllMonster)
  self:BroadcastRefreshMainQueenOfBloodTip(checkPre and checkAfter)
end

function OffSeason1QueenOfBloodManager:QueenOfBloodActivityInfoSingleMonsterMessage(msg)
  if self.monsterInfos and msg.monsterInfo then
    for i, v in ipairs(self.monsterInfos) do
      if v.monsterUuid == msg.monsterInfo.monsterUuid then
        v.hp = msg.monsterInfo.hp
        EventManager:GetInstance():Broadcast(EventId.RefreshQueenOfBloodActivityInfoSingleMonster, msg.monsterInfo.monsterUuid)
        self:BroadcastRefreshMainQueenOfBloodTip(false)
        return
      end
    end
  end
end

function OffSeason1QueenOfBloodManager:InitData(activityData)
  self.activityInfo = activityData
  SFSNetwork.SendMessage(MsgDefines.BloodyQueenS1RestGainActivityInfo)
  SFSNetwork.SendMessage(MsgDefines.CityBattleActivityGainTaskInfo, OffSeason1TaskGroup.QueenOfBlood)
end

function OffSeason1QueenOfBloodManager:SendBloodyQueenS1RestChooseCityDefendGain(cityId)
  self.nowCheckAllianceCityId = cityId
  SFSNetwork.SendMessage(MsgDefines.BloodyQueenS1RestChooseCityDefendGain, cityId)
end

function OffSeason1QueenOfBloodManager:SendBloodyQueenS1RestChooseCityDefendSet(operateType, cityId)
  if operateType == 1 and self.nowChooseCount >= self.chooseCountLimit then
    UIUtil.ShowTipsId("s1_QueenChallenge_ready_tips_signUpFull")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BloodyQueenS1RestChooseCityDefendSet, operateType, tonumber(cityId))
end

function OffSeason1QueenOfBloodManager:GetQueenOfBloodActivityStage()
  return self.activityState
end

function OffSeason1QueenOfBloodManager:GetActivityStateEndTime()
  return self.activityStateEndTime
end

function OffSeason1QueenOfBloodManager:GetCityInfoList()
  return self.cityInfoList
end

function OffSeason1QueenOfBloodManager:GetBattleStateNow()
  return self.battleState
end

function OffSeason1QueenOfBloodManager:GetSelectAllianceList()
  return self.allianceList
end

function OffSeason1QueenOfBloodManager:GetBattleStageEndTime()
  return self.battleStateEndTime
end

function OffSeason1QueenOfBloodManager:GetMonsterInfosList()
  return self.monsterInfos
end

function OffSeason1QueenOfBloodManager:GetTheBattleResult()
  if self.cityInfoList and #self.cityInfoList > 0 then
    local defendSuccess = 0
    local defendDefeat = 0
    for _, v in pairs(self.cityInfoList) do
      if v.defendInfo.isDefendSuccess then
        defendSuccess = defendSuccess + 1
      else
        defendDefeat = defendDefeat + 1
      end
    end
    local length = #self.cityInfoList
    if defendSuccess == length then
      return QueenOfBloodBattleResult.AllSuccess
    elseif defendDefeat == length then
      return QueenOfBloodBattleResult.AllDefeat
    else
      return QueenOfBloodBattleResult.PartSuccess
    end
  end
  return -1
end

function OffSeason1QueenOfBloodManager:GetQueenOfBloodActId()
  if self.activityInfo then
    return self.activityInfo.id
  end
  return nil
end

function OffSeason1QueenOfBloodManager:RefreshRoundInfo(msg)
  local preRound = self.roundInfo.nextRound
  self.roundInfo.nextRound = msg.nextRound
  self.roundInfo.nextRoundTime = msg.nextRoundTime
  if (preRound == nil or preRound == 1) and self.roundInfo.nextRound == 2 and CS.SceneManager.CurrSceneID == SceneManagerSceneID.World and LuaEntry.Player:AtHomeNow() then
    EventManager:GetInstance():Broadcast(EventId.QueenOfBloodChangeWorldBgm)
  end
  EventManager:GetInstance():Broadcast(EventId.PushBloodQueenNextRound)
end

function OffSeason1QueenOfBloodManager:ClearRoundInfo()
  if self.roundInfo.nextRound ~= nil then
    self.roundInfo.nextRound = nil
    self.roundInfo.nextRoundTime = nil
    self.roundInfo.maxRound = nil
    EventManager:GetInstance():Broadcast(EventId.PushBloodQueenNextRound)
  end
end

function OffSeason1QueenOfBloodManager:ShowQueenOfBloodRound()
  return self.roundInfo ~= nil and self.roundInfo.nextRound ~= nil
end

function OffSeason1QueenOfBloodManager:GetRoundInfo()
  return self.roundInfo
end

function OffSeason1QueenOfBloodManager:InQueenOfBloodBattle()
  return self.activityState and self.activityState == QueenOfBloodActivityState.battle
end

function OffSeason1QueenOfBloodManager:CanAssistance(cityId)
  return DataCenter.OffSeason1RecaptureManager:IsInRecaptureAct() and self.activityState and (self.activityState == QueenOfBloodActivityState.preBattleShowNoApplication or self.activityState == QueenOfBloodActivityState.battle) and self:GetCityIsChoose(cityId)
end

function OffSeason1QueenOfBloodManager:GetCityInfoById(cityId)
  if self.cityInfoList then
    for i, v in ipairs(self.cityInfoList) do
      if v.cityId == cityId then
        return v
      end
    end
  end
  return nil
end

function OffSeason1QueenOfBloodManager:GetMonsterInfoByUuid(uuid)
  if self.monsterInfos then
    for i, v in ipairs(self.monsterInfos) do
      if v.monsterUuid == uuid then
        return v
      end
    end
  end
  return nil
end

function OffSeason1QueenOfBloodManager:GetCityIsChoose(cityId)
  local cityInfo = self:GetCityInfoById(cityId)
  if cityInfo and cityInfo.defendInfo.isChoose then
    return true
  end
  return false
end

function OffSeason1QueenOfBloodManager:GetCanChooseNum()
  if self.nowChooseCount and self.chooseCountLimit then
    return self.chooseCountLimit - self.nowChooseCount
  end
  return 0
end

function OffSeason1QueenOfBloodManager:GetChallengeMonsterIndexDataByCount(count)
  count = tonumber(count)
  local data = self.challengeMonsterIndexData[count]
  if data == nil then
    local cfg = GetTableData(TableName.LW_OFFSEASON_QUEENCHALLENGE, 100 + count, "monster_preview")
    if not string.IsNullOrEmpty(cfg) then
      local split1 = string.split(cfg, "|")
      local previewData = {}
      for i = 1, 3 do
        previewData[i] = {}
      end
      for i1, v in ipairs(split1) do
        local split2 = string.split(v, ";")
        local monsterPreviewInfo = {}
        monsterPreviewInfo.monsterId = tonumber(split2[1])
        monsterPreviewInfo.tipId = split2[5]
        for i2 = 2, 4 do
          if tonumber(split2[i2]) == 1 then
            table.insert(previewData[i2 - 1], monsterPreviewInfo)
          end
        end
      end
      data = previewData
      self.challengeMonsterIndexData[count] = previewData
    end
  end
  return data
end

function OffSeason1QueenOfBloodManager:GetMaxDefendNum()
  if self.maxDefendNum and self.maxDefendNum == 0 then
    self.maxDefendNum = LuaEntry.DataConfig:TryGetNum("s1_offSeason_rerecapture", "k14", 0)
  end
  return self.maxDefendNum
end

function OffSeason1QueenOfBloodManager:GetCityIsDie(cityId)
  local cityInfo = self:GetCityInfoById(cityId)
  if cityInfo then
    return cityInfo.defendInfo.hp <= 0
  end
  return false
end

function OffSeason1QueenOfBloodManager:GetRedDotNum()
  if DataCenter.OffSeason1TaskDataManager:GetRedDotNum(tonumber(OffSeason1TaskGroup.QueenOfBlood)) > 0 then
    return 1
  end
  return 0
end

function OffSeason1QueenOfBloodManager:GetNeedPlayBgmId()
  local bgmId
  if self.activityState and self.activityState == QueenOfBloodActivityState.battle and self.roundInfo.nextRound and self.roundInfo.nextRound > 1 then
    bgmId = 20004
  end
  return bgmId
end

function OffSeason1QueenOfBloodManager:GetGunnerJumpPoint()
  local curScene = CS.SceneManager.CurrSceneID
  local point
  if curScene == SceneManagerSceneID.World then
    local monsterInfo
    if self.monsterInfos and #self.monsterInfos > 0 then
      for i, v in ipairs(self.monsterInfos) do
        local monsterCfg = DataCenter.MonsterTemplateManager:GetMonsterTemplate(v.monsterConfigId)
        if monsterCfg.special == WorldMonsterSpecialType.S1RestBloodyQueenGunner and 0 < v.hp and (monsterInfo == nil or v.hp < monsterInfo.hp) then
          monsterInfo = v
        end
      end
    end
    if monsterInfo then
      point = monsterInfo.point
    end
  end
  return point
end

function OffSeason1QueenOfBloodManager:BroadcastRefreshMainQueenOfBloodTip(needShowTip)
  EventManager:GetInstance():Broadcast(EventId.RefreshMainQueenOfBloodTip, needShowTip)
end

function OffSeason1QueenOfBloodManager:CheckGotoTipStatus()
  if self.recordGotoTip then
    return false
  end
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    return false
  end
  if self.activityState == nil or self.activityState ~= QueenOfBloodActivityState.preBattleShow then
    return false
  end
  if self.nowChooseCount and self.nowChooseCount > 0 then
    return false
  end
  return true
end

function OffSeason1QueenOfBloodManager:RecordGotoTipStatus()
  self.recordGotoTip = true
end

function OffSeason1QueenOfBloodManager:GetRankDefaultQualityAndCount()
  local count = self.activityCount or 1
  local quality
  if self.cityInfoList then
    for i, v in ipairs(self.cityInfoList) do
      if v.defendInfo.isChoose then
        local battleLv = v.defendInfo.battleLv
        if quality == nil or quality > battleLv then
          quality = battleLv
        end
      end
    end
    if quality == nil then
      quality = 1
    end
  end
  return quality, count
end

return OffSeason1QueenOfBloodManager
