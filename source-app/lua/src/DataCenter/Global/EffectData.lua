local EffectData = BaseClass("EffectData")

function EffectData:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function EffectData:RemoveListener(msg_name, callback)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    Logger.LogError(msg_name, " not register")
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function EffectData:__init()
  self.__event_handlers = {}
  self:__reset()
end

function EffectData:__reset()
  self.effectLayers = {}
  self.effectValues = {}
  self.effectStateMap = {}
  self.statusMap = {}
  self.worldStatusMap = {}
  self.reasonEffectValues = {}
  self.serverEffect = {}
  self.statusFromMap = {}
  self.statusRangeMap = {}
  self.breachaData = nil
  self:AddTimer()
end

function EffectData:Destroy()
  self:DeleteTimer()
end

function EffectData:InitFromNet(obj)
  self:__reset()
  if obj.effectStateExtra ~= nil and table.count(obj.effectStateExtra) > 0 then
    for k, v in pairs(obj.effectStateExtra) do
      if v and v.stateId then
        if v.stateId == CityState.VirusCity then
          LuaEntry.Player.VirusLayer = toInt(v.layer)
        elseif v.layer then
          self.effectLayers[v.stateId] = toInt(v.layer)
        end
      end
    end
  end
  if obj.effect ~= nil then
    self.effectValues = {}
    self.reasonEffectValues = {}
    local effectList = obj.effect
    self:OnEffectChange(effectList, true)
  end
  self:AddStatusRangeByServerData(obj)
  if obj.effectState ~= nil then
    self.statusMap = {}
    local stateDic = obj.effectState
    table.walk(stateDic, function(k, v)
      local key = tonumber(k)
      local value = tonumber(v)
      self:AddStatus(key, value)
    end)
  end
  if obj.status ~= nil then
    self.effectStateMap = {}
    local data = obj.status
    table.walk(data, function(k, v)
      if v ~= nil then
        local effectState = {}
        effectState.value = 0
        effectState.effectId = 0
        effectState.stateId = 0
        if v.effVal ~= nil then
          effectState.value = v.effVal
        end
        if v.stateId ~= nil then
          effectState.stateId = v.stateId
        end
        if v.effNum ~= nil then
          effectState.effectId = v.effNum
        end
        if effectState.effectId ~= nil and effectState.effectId ~= 0 then
          if self.effectStateMap[effectState.effectId] == nil then
            self.effectStateMap[effectState.effectId] = {}
          end
          if effectState.stateId ~= nil and effectState.stateId ~= 0 then
            self.effectStateMap[effectState.effectId][effectState.stateId] = effectState
          end
        end
      end
    end)
  end
  if obj.newEffectState ~= nil then
    self.worldStatusMap = {}
    local stateDic = obj.newEffectState
    table.walk(stateDic, function(k, v)
      local oneData = {}
      if v.stateId ~= nil then
        oneData.stateId = v.stateId
      end
      if v.st ~= nil then
        oneData.startTime = v.st
      end
      if v.et ~= nil then
        oneData.endTime = v.et
      end
      if oneData.stateId ~= 0 then
        self.worldStatusMap[oneData.stateId] = oneData
      end
    end)
  end
  if obj.effectStateFrom ~= nil then
    self.statusFromMap = {}
    local data = obj.effectStateFrom
    self:AddStatusFromByServerData(data)
  end
  CommonUtil.ProtectCall(function()
    DataCenter.ServerStatusManager:InitData(obj)
  end)
  EventManager:GetInstance():Broadcast(EventId.StatusDataInit)
end

function EffectData:InitServerEffect(message)
  self.serverEffect = {}
  if message.serverEffects ~= nil then
    local arr = message.serverEffects
    for k, v in pairs(arr) do
      local level = v.level
      local effect = v.effect
      if level ~= nil and level ~= "" and effect ~= nil and effect ~= "" then
        local levelArr = string.split(level, "-")
        local effectArr = string.split(effect, "|")
        if 0 < #levelArr and 0 < #effectArr then
          local minLevel = tonumber(levelArr[1])
          local maxLevel = minLevel
          if 1 < #levelArr then
            maxLevel = tonumber(levelArr[2])
          end
          if minLevel ~= nil and maxLevel ~= nil then
            for i = 1, #effectArr do
              local effectStr = effectArr[i]
              local oneEffectStr = string.split(effectStr, ";")
              if 1 < #oneEffectStr then
                local effectId = tonumber(oneEffectStr[1])
                local num = tonumber(oneEffectStr[2])
                if effectId ~= nil and num ~= nil then
                  if self.serverEffect[effectId] == nil then
                    self.serverEffect[effectId] = {}
                  end
                  if minLevel <= maxLevel then
                    for a = minLevel, maxLevel do
                      if self.serverEffect[effectId][a] == nil then
                        self.serverEffect[effectId][a] = 0
                      end
                      self.serverEffect[effectId][a] = self.serverEffect[effectId][a] + num
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

function EffectData:Release()
end

function EffectData:GetEffectValue(effId)
  if self.effectValues[effId] ~= nil then
    return self.effectValues[effId]
  end
  return 0
end

function EffectData:GetEffectStateValue(effId)
  local ret = 0
  if self.effectStateMap[effId] ~= nil then
    local effList = self.effectStateMap[effId]
    local curTime = UITimeManager:GetInstance():GetServerTime()
    table.walk(effList, function(k, v)
      if self.statusMap[v.stateId] ~= nil and curTime < self.statusMap[v.stateId] then
        ret = ret + v.value
      end
      if self.worldStatusMap[v.stateId] ~= nil and curTime < self.worldStatusMap[v.stateId].endTime and curTime > self.worldStatusMap[v.stateId].startTime then
        ret = ret + v.value
      end
    end)
  end
  return ret
end

function EffectData:GetGameEffect(effect)
  local effectId = toInt(effect)
  local allianceCityEffect = DataCenter.WorldAllianceCityDataManager:GetAllianceCityEffectById(effectId)
  local allianceScienceEffect = DataCenter.AllianceScienceDataManager:GetAllianceScienceEffectById(effectId)
  local campScienceEffect = DataCenter.CampScienceDataManager:GetCampScienceEffectById(effectId)
  local warFlagEffect = DataCenter.WarFlagDataManager:GetEffectById(effectId)
  local serverEffect = 0
  if self.serverEffect[effectId] ~= nil then
    local mainLv = DataCenter.BuildManager.MainLv
    if mainLv ~= nil and self.serverEffect[effectId][mainLv] ~= nil then
      serverEffect = self.serverEffect[effectId][mainLv]
    end
  end
  local total = self:GetEffectValue(effectId) + self:GetEffectStateValue(effectId) + allianceCityEffect + allianceScienceEffect + campScienceEffect + serverEffect + warFlagEffect
  if EffectDefine.APS_SEASON_DESERT_RESISTANCE == effectId then
    local lightBuffDict = DataCenter.SeasonLightDataManager:GetAllLightBuff()
    if lightBuffDict then
      for stateId, lightStatus in pairs(lightBuffDict) do
        local stateMeta = LocalController:instance():getLine(TableName.StatusTab, stateId)
        if stateMeta and toInt(stateMeta.effect) == effectId then
          total = total + toInt(stateMeta.effect_num)
        end
      end
    end
    local GlobalState = DataCenter.SeasonDataManager:GetGlobalStatus()
    if GlobalState then
      for k, v in pairs(GlobalState) do
        if v and v.effects and v.reason and v.stateId ~= nil then
          for m, n in ipairs(v.effects) do
            if n and n.eff == effectId and n.val ~= 0 then
              total = total + checknumber(n.val)
            end
          end
        end
      end
    end
  end
  local effectList = DataCenter.SeasonFarmerManager:GetCityAttachmentEffectInfo()
  if effectList and effectList.effect then
    for _effectId, _effectValue in pairs(effectList.effect) do
      if toInt(_effectId) == effectId then
        total = total + (tonumber(_effectValue) or 0)
        break
      end
    end
  end
  total = total + DataCenter.ServerStatusManager:GetEffectById(effectId)
  return total
end

function EffectData:AddCityStateDelay(time)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local delayTime = (time - curTime) / 1000
  if 0 < delayTime then
    self.statuDelay = TimerManager:GetInstance():DelayInvoke(function()
      self:RemoveStatus(time)
      self.statuDelay = nil
    end, delayTime)
  end
end

function EffectData:AddStatus(stateId, time)
  self:RefreshStatusMap(stateId, time)
  self:RemoveStatusFrom(stateId)
  if stateId == CityState.RuinedCity then
    self:AddCityStateDelay(time)
  end
  EventManager:GetInstance():Broadcast(EventId.LuaEntryEffectRefreshStatus, stateId)
end

function EffectData:RemoveStatus(stateId)
  if self.statusMap[stateId] ~= nil then
    if stateId == CityState.RuinedCity and self.statuDelay ~= nil then
      self.statuDelay:Stop()
      self.statuDelay = nil
    end
    if stateId == CityState.VirusCity then
      LuaEntry.Player.VirusLayer = 0
    end
    self.statusMap[stateId] = nil
    local meta = LocalController:instance():getLine(TableName.StatusTab, stateId)
    if meta and self.effectStateMap[tonumber(meta.effect)] then
      self.effectStateMap[tonumber(meta.effect)][stateId] = nil
    end
    EventManager:GetInstance():Broadcast(EventId.LuaEntryEffectRefreshStatus, stateId)
  end
  self:RemoveStatusFrom(stateId)
end

function EffectData:OnEffectChange(effectList, isInit)
  table.walk(effectList, function(k, v)
    local key = tonumber(k)
    local value = tonumber(v)
    if key == EffectDefine.APS_ARMY_NUM_MAX and self.effectValues[key] ~= nil and self.effectValues[key] > 0 and self.effectValues[key] ~= value and DataCenter.GuideManager:InGuide() == false then
      local total = DataCenter.ArmyManager:GetTotalArmyNum()
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UINoticeEquipTips) then
        TimerManager:GetInstance():DelayInvoke(function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UISoliderGetTip, {anim = true}, "", 0, total, math.floor(self.effectValues[key]), math.floor(value), nil)
        end, 3)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISoliderGetTip, {anim = true}, "", 0, total, math.floor(self.effectValues[key]), math.floor(value), nil)
      end
    end
    if key ~= nil then
      self.effectValues[key] = value
    elseif k == "reasons" then
      for k1, v1 in pairs(v) do
        local subEffect = {}
        for k2, v2 in pairs(v1) do
          if k2 == "id" then
            self.reasonEffectValues[tonumber(v2)] = subEffect
          else
            subEffect[tonumber(k2)] = tonumber(v2)
          end
        end
      end
    elseif k == "reason" then
      local subEffect = {}
      for k2, v2 in pairs(v) do
        if k2 == "id" then
          self.reasonEffectValues[tonumber(v2)] = subEffect
        else
          subEffect[tonumber(k2)] = tonumber(v2)
        end
      end
    end
    if (key == EffectDefine.ADD_OSTRICH_NUM or key == EffectDefine.ADD_COW_NUM or key == EffectDefine.ADD_PIG_NUM) and isInit ~= true then
      DataCenter.QueueDataManager:DoWhenPastureEffectChange(key)
    end
  end)
end

function EffectData:RefreshStatusMap(stateId, endTime)
  local stateMeta = LocalController:instance():getLine(TableName.StatusTab, stateId)
  if stateMeta and tonumber(stateMeta.effect) == EffectDefine.MAIN_SHIELD then
    local ids = DataCenter.StatusManager:GetShieldStatusIds()
    local longestStateId = stateId
    local longestEndTime = endTime
    for k, v in pairs(self.statusMap) do
      if ids[k] then
        if v > longestEndTime then
          longestStateId = k
          longestEndTime = v
        end
        self.statusMap[k] = nil
      end
    end
    self.statusMap[longestStateId] = longestEndTime
  else
    self.statusMap[stateId] = endTime
  end
end

function EffectData:UpdateEffectStatus(effVal, effId, stateId, endTime)
  local effectState = {}
  effectState.value = effVal
  effectState.effectId = effId
  effectState.stateId = stateId
  if effectState.effectId ~= nil and effectState.effectId ~= 0 then
    if self.effectStateMap[effectState.effectId] == nil then
      self.effectStateMap[effectState.effectId] = {}
    end
    if effectState.stateId ~= nil and effectState.stateId ~= 0 then
      self.effectStateMap[effectState.effectId][effectState.stateId] = effectState
    end
    if endTime ~= nil and 0 < endTime then
      self:RefreshStatusMap(stateId, endTime)
      EventManager:GetInstance():Broadcast(EventId.LuaEntryEffectRefreshStatus)
    end
  end
end

function EffectData:UpdateEffectWorldStatus(effVal, effId, stateId, startTime, endTime)
  local effectState = {}
  effectState.value = effVal
  effectState.effectId = effId
  effectState.stateId = stateId
  if effectState.effectId ~= nil and effectState.effectId ~= 0 then
    if self.effectStateMap[effectState.effectId] == nil then
      self.effectStateMap[effectState.effectId] = {}
    end
    if effectState.stateId ~= nil and effectState.stateId ~= 0 then
      self.effectStateMap[effectState.effectId][effectState.stateId] = effectState
    end
    if endTime ~= nil and 0 < endTime and startTime ~= nil and 0 < startTime then
      local oneData = {}
      oneData.stateId = stateId
      oneData.startTime = startTime
      oneData.endTime = endTime
      if oneData.stateId ~= 0 then
        self.worldStatusMap[oneData.stateId] = oneData
      end
    end
  end
end

function EffectData:GetStatusMap()
  return self.statusMap
end

function EffectData:HasStatus(statusId)
  if self.statusMap and self.statusMap[statusId] then
    local endTime = self.statusMap[statusId]
    if endTime > UITimeManager:GetInstance():GetServerTime() then
      return true
    end
  end
  return false
end

function EffectData:HasStatusByStatusType2(type2)
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  local type2Str = tostring(type2)
  for statusId, endTime in pairs(self.statusMap) do
    local meta = LocalController:instance():getLine(TableName.StatusTab, statusId)
    if meta and meta.type2 == type2Str and endTime > nowTime then
      return true
    end
  end
  return false
end

function EffectData:GetStatusEndTime(statusId)
  if self.statusMap and self.statusMap[statusId] then
    return self.statusMap[statusId]
  end
  return 0
end

function EffectData:GetWorldStatusStartTime(statusId)
  if self.worldStatusMap and self.worldStatusMap[statusId] then
    return self.worldStatusMap[statusId].startTime
  end
  return 0
end

function EffectData:GetWorldStatusMap()
  return self.worldStatusMap
end

function EffectData:GetReasonEffectValue(effectId, reasonType)
  if self.reasonEffectValues ~= nil and self.reasonEffectValues[effectId] ~= nil then
    return self.reasonEffectValues[effectId][reasonType]
  end
end

function EffectData:AddTimer()
  self:DeleteTimer()
  
  function self.timer_action()
    self:UpdatePerSecond()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, true)
  end
  self.timer:Start()
end

function EffectData:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
  end
  self.timer = nil
  self.timer_action = nil
end

function EffectData:UpdatePerSecond()
  local now = UITimeManager:GetInstance():GetServerTime()
  for stateId, time in pairs(self.statusMap) do
    if time < now then
      if stateId == CityState.VirusCity and LuaEntry.Player.VirusLayer > 1 then
        LuaEntry.Player.VirusLayer = LuaEntry.Player.VirusLayer - 1
        SFSNetwork.SendMessage(MsgDefines.SyncSeasonVirusLayer)
      else
        self:RemoveStatus(stateId)
      end
    end
  end
end

function EffectData:CheckCityBuff(cityBuffType)
  for statusId, v in pairs(self.statusMap) do
    local meta = LocalController:instance():getLine(TableName.StatusTab, statusId)
    if meta and tonumber(meta.type2) == cityBuffType then
      return true
    end
  end
  return false
end

function EffectData:GetStatusLayer(statusId)
  if self.effectLayers ~= nil then
    return toInt(self.effectLayers[statusId])
  end
  return 0
end

function EffectData:CheckCityFarmState()
  local time = self.statusMap[CityState.RuinedCity]
  if time and 0 < time then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local delayTime = (time - curTime) / 1000
    if 0 < delayTime then
      return true
    end
  end
  return false
end

function EffectData:SetBreachData(breachaData)
  self.breachaData = breachaData
end

function EffectData:CheckCityBreach()
  return self.breachaData
end

function EffectData:SyncSeasonVirusStatus(data)
  local effectStateExtra = data.effectStateExtra
  if effectStateExtra ~= nil then
    local virusLayer = {}
    local hasVirus, theEffectId = SeasonUtil.HasVirus()
    LocalController:instance():visitTable(TableName.StatusEffect, function(id, lineData)
      if hasVirus and toInt(lineData.father_status) == theEffectId then
        virusLayer[toInt(id)] = true
      end
    end)
    virusLayer[theEffectId] = true
    for _, v in pairs(effectStateExtra) do
      if v and v.stateId == CityState.VirusCity then
        LuaEntry.Player.VirusLayer = toInt(v.layer)
        if LuaEntry.Player.VirusLayer > 0 then
          local max = Setting:GetPrivateInt("VirusMax", 0)
          if max < LuaEntry.Player.VirusLayer then
            Setting:SetPrivateInt("VirusMax", LuaEntry.Player.VirusLayer)
          end
          Setting:SetPrivateBool("HasVirus", true)
          DataCenter.SeasonDataManager:AddCheckVirusTimer()
        end
      end
      if v and v.layer then
        virusLayer[toInt(v.stateId)] = false
      end
    end
    for stateId, dirty in pairs(virusLayer) do
      if dirty == true then
        if stateId == CityState.VirusCity then
          LuaEntry.Player.VirusLayer = 0
        end
        LuaEntry.Effect:RemoveStatus(tonumber(stateId))
      end
    end
  end
  if data.effectState ~= nil then
    table.walk(data.effectState, function(k, v)
      LuaEntry.Effect:AddStatus(toInt(k), toInt(v))
    end)
  end
  if data.status ~= nil then
    table.walk(data.status, function(k, v)
      if v ~= nil then
        local effectState = {}
        effectState.value = 0
        effectState.effectId = 0
        effectState.stateId = 0
        if v.effVal ~= nil then
          effectState.value = v.effVal
        end
        if v.stateId ~= nil then
          effectState.stateId = v.stateId
        end
        if v.effNum ~= nil then
          effectState.effectId = v.effNum
        end
        if effectState.effectId ~= nil and effectState.effectId ~= 0 then
          if self.effectStateMap[effectState.effectId] == nil then
            self.effectStateMap[effectState.effectId] = {}
          end
          if effectState.stateId ~= nil and effectState.stateId ~= 0 then
            self.effectStateMap[effectState.effectId][effectState.stateId] = effectState
          end
        end
      end
    end)
  end
  EventManager:GetInstance():Broadcast(EventId.MSG_ITME_STATUS_TIME_CHANGE)
end

function EffectData:RemoveStatusFrom(stateId)
  if self.statusFromMap[stateId] ~= nil then
    self.statusFromMap[stateId] = nil
  end
end

function EffectData:AddStatusFrom(statusData)
  local stateId = tonumber(statusData.stateId)
  self.statusFromMap[stateId] = statusData
end

function EffectData:AddStatusFromByServerData(data)
  table.walk(data, function(k, v)
    self:AddStatusFrom(v)
  end)
end

function EffectData:GetStatusFrom(stateId)
  return self.statusFromMap[stateId]
end

function EffectData:RemoveStatusRange(stateId)
  if self.statusRangeMap[stateId] ~= nil then
    self.statusRangeMap[stateId] = nil
  end
end

function EffectData:AddStatusRange(statusData)
  local stateId = tonumber(statusData.stateId)
  self.statusRangeMap[stateId] = statusData
end

function EffectData:GetStatusRange(stateId)
  return self.statusRangeMap[stateId]
end

function EffectData:AddStatusRangeByServerData(msgData)
  if msgData == nil then
    return
  end
  local effectStateData = msgData.effectState
  local effectRangeArrayData = msgData.effectRangeArray
  if effectStateData then
    for k, v in pairs(effectStateData) do
      local stateId = toInt(k) or 0
      if 0 < stateId then
        self:RemoveStatusRange(stateId)
      end
    end
  end
  if effectRangeArrayData then
    table.walk(effectRangeArrayData, function(k, v)
      self:AddStatusRange(v)
    end)
  end
end

function EffectData:GetAllianceArmsEffectNum(baseNum, effectList)
  local num = baseNum
  local effectFactor = 0
  if effectList and 0 < #effectList then
    for i = 1, #effectList do
      effectFactor = effectFactor + self:GetGameEffect(tonumber(effectList[i]))
    end
  end
  if effectFactor ~= 0 then
    num = math.floor(num * (1 + effectFactor) + 0.5)
  end
  return num
end

function EffectData:GetFixDoubleNumber(num)
  return math.floor(num * 1000000 + 0.5) / 1000000
end

return EffectData
