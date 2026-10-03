local OffSeason1RecaptureManager = BaseClass("OffSeason1RecaptureManager")

function OffSeason1RecaptureManager:__init()
  self.effectList = {}
  self.count = 0
  self.monsterInfos = nil
  self.rewardInfo = nil
  self.activityId = nil
  self.serverActivityOpen = nil
end

function OffSeason1RecaptureManager:__delete()
  self.effectList = nil
  self.count = nil
  self.monsterInfos = nil
  self.rewardInfo = nil
  self.activityId = nil
  self.serverActivityOpen = nil
end

function OffSeason1RecaptureManager:OnCityBattleS1RestGainActivityInfoMessage(msg)
  self.buffInfos = msg.buffInfos
  self.count = msg.count
  self.monsterInfos = {}
  for i, v in ipairs(msg.monsterInfos) do
    local monsterInfoList = v.monsterInfoList
    if monsterInfoList and 1 < #monsterInfoList and not monsterInfoList[1].presidentChoose then
      for j = 1, #monsterInfoList do
        local item = monsterInfoList[j]
        if item.presidentChoose then
          monsterInfoList[j] = monsterInfoList[1]
          monsterInfoList[1] = item
          break
        end
      end
    end
    self.monsterInfos[v.lv] = monsterInfoList
  end
  self.rewardInfo = msg.rewardInfo
  for i, v in ipairs(self.effectList) do
    if table.hasvalue(self.buffInfos, v.id) then
      v.unlock = true
      v.needNum = 0
    else
      v.unlock = false
      v.needNum = table.count(self.monsterInfos[i])
    end
  end
  EventManager:GetInstance():Broadcast(EventId.CityBattleS1RestGainActivityInfoRefresh)
  if msg.updateType and msg.updateType == RecaptureActUpdateType.MONSTER_DEAD then
    local cityId = tonumber(msg.extendInfo)
    if cityId then
      EventManager:GetInstance():Broadcast(EventId.PushRecaptureActMonsterDead, cityId)
    end
  end
end

function OffSeason1RecaptureManager:InitData(activityId)
  self.activityId = activityId
  self.effectList = {}
  local effectCfg = LuaEntry.DataConfig:TryGetStr("s1_offSeason_rerecapture", "k2")
  if not string.IsNullOrEmpty(effectCfg) then
    local split = string.split(effectCfg, ";")
    for i, v in ipairs(split) do
      local id = tonumber(v)
      self.effectList[i] = {}
      self.effectList[i].id = id
      self.effectList[i].unlock = false
      self.effectList[i].needNum = 0
      self.effectList[i].level = i
      self.effectList[i].cfg = LocalController:instance():getLine(TableName.StatusTab, id)
    end
  end
  SFSNetwork.SendMessage(MsgDefines.CityBattleS1RestGainActivityInfo)
  SFSNetwork.SendMessage(MsgDefines.CityBattleActivityGainTaskInfo, OffSeason1TaskGroup.OffSeason1Recapture)
end

function OffSeason1RecaptureManager:GetAtkTime()
  return self.count or 0
end

function OffSeason1RecaptureManager:GetMonsterInfos()
  return self.monsterInfos
end

function OffSeason1RecaptureManager:GetEffectList()
  return self.effectList
end

function OffSeason1RecaptureManager:GetActivityId()
  return self.activityId
end

function OffSeason1RecaptureManager:GetRedDotNum()
  if DataCenter.OffSeason1TaskDataManager:GetRedDotNum(tonumber(OffSeason1TaskGroup.OffSeason1Recapture)) > 0 then
    return 1
  end
  return 0
end

function OffSeason1RecaptureManager:IsInRecaptureAct()
  if self.activityId then
    local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if data then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if data.endTime and curTime < data.endTime then
        return true
      end
    end
  end
  return false
end

function OffSeason1RecaptureManager:GetPresidentChooseIndexByMonsterLv(monsterLv)
  local presidentChooseIndex
  if self.monsterInfos and self.monsterInfos[monsterLv] then
    for i, v in ipairs(self.monsterInfos[monsterLv]) do
      if v.presidentChoose then
        presidentChooseIndex = i
        break
      end
    end
  end
  return presidentChooseIndex
end

function OffSeason1RecaptureManager:IsCtrl()
  return LuaEntry.Player:IsPresident()
end

function OffSeason1RecaptureManager:SaveBubbleTipShown(shown)
  self.shown = shown
  CommonUtil.PlayerPrefsSetBool(SettingKeys.OFFSEASON_RECAPTURE_BUBBLE_TIP_SHOWN, shown)
end

function OffSeason1RecaptureManager:GetBubbleTipStr()
  local str
  if self.shown == nil then
    self.shown = CommonUtil.PlayerPrefsGetBool(SettingKeys.OFFSEASON_RECAPTURE_BUBBLE_TIP_SHOWN, false)
  end
  if self.shown == false and self:IsCtrl() then
    str = "s1_offseason_activity_recapture_firstAttackTips4"
  end
  return str
end

function OffSeason1RecaptureManager:SetServerRankFirstInfo(msg)
  if not msg or not msg.serverId then
    return
  end
  if msg.serverId == LuaEntry.Player:GetCurServerId() then
    self.serverRankFirstInfo = msg.ranks
    self.serverActivityOpen = msg.activityOpen
    EventManager:GetInstance():Broadcast(EventId.CityBattleS1RestUpdateFirstInfo)
  end
end

function OffSeason1RecaptureManager:GetServerRankFirstRoleInfo(cityId)
  if self.serverRankFirstInfo then
    for i, v in ipairs(self.serverRankFirstInfo) do
      if v.cityId == cityId then
        return v.roleInfo
      end
    end
  end
  return nil
end

return OffSeason1RecaptureManager
