local PushStatusMessage = BaseClass("PushStatusMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.oldStatus ~= nil then
    local statusId = t.oldStatus
    LuaEntry.Effect:RemoveStatus(tonumber(statusId))
  end
  LuaEntry.Effect:AddStatusRangeByServerData(t)
  if t.effectState ~= nil then
    local stateDict = t.effectState
    local virus_layer = 0
    local stateId = 0
    local state_end_time = 0
    for k, v in pairs(stateDict) do
      if k == "layer" then
        virus_layer = toInt(v)
      elseif k == "startTime" then
      else
        stateId = toInt(k)
        state_end_time = toInt(v)
      end
    end
    if stateId == CityState.VirusCity then
      LuaEntry.Player.VirusLayer = virus_layer
      if 0 < LuaEntry.Player.VirusLayer then
        local max = Setting:GetPrivateInt("VirusMax", 0)
        if max < LuaEntry.Player.VirusLayer then
          Setting:SetPrivateInt("VirusMax", LuaEntry.Player.VirusLayer)
        end
        Setting:SetPrivateBool("HasVirus", true)
        DataCenter.SeasonDataManager:AddCheckVirusTimer()
      end
    else
      LuaEntry.Effect.effectLayers[stateId] = virus_layer
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    local timeDelta = state_end_time - now
    LuaEntry.Effect:AddStatus(stateId, state_end_time)
  end
  if t.status ~= nil then
    local status = t.status
    for i, data in pairs(status) do
      LuaEntry.Effect:UpdateEffectStatus(data.effVal, data.effNum, data.stateId)
    end
  end
  if t.effectStateFrom ~= nil then
    local data = t.effectStateFrom
    LuaEntry.Effect:AddStatusFromByServerData(data)
    local curScene = CS.SceneManager.CurrSceneID
    if curScene == SceneManagerSceneID.City or curScene == SceneManagerSceneID.World then
      table.walk(data, function(k, v)
        local stateId = tonumber(v.stateId)
        local isMusicStatus = DataCenter.StatusManager:CheckStatusType2(stateId, StatusType2.MusicFestivalSkill)
        if isMusicStatus then
          local isInRange = UIUtil.CheckStateIsInRange(stateId)
          if isInRange then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UICitySkinSkillTip, stateId)
            DataCenter.DecorationBGMManager:StopBGM()
          end
        end
      end)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.MSG_ITME_STATUS_TIME_CHANGE, 100)
end

local function GetTestData(self, isOld, statusId, uidList)
  statusId = statusId or 500500
  local now = UITimeManager:GetInstance():GetServerTime()
  if isOld then
    local t = {}
    t.effectRangeArray = {
      {
        serverId = LuaEntry.Player.serverId,
        stateId = tostring(statusId),
        worldId = 0
      }
    }
    t.effectState = {
      [statusId] = now + 20000,
      startTime = now
    }
    t.effectStateFrom = {}
    t.oldStatus = tostring(statusId)
    return t
  end
  local t = {}
  t.effectRangeArray = {
    {
      serverId = 19,
      stateId = "500500",
      worldId = 0
    }
  }
  t.effectState = {
    [statusId] = now + 20000,
    startTime = UITimeManager:GetInstance():GetServerTime() + 20
  }
  if uidList then
    t.effectStateFrom = {}
    for i, v in pairs(uidList) do
      table.insert(t.effectStateFrom, {
        stateId = tostring(statusId),
        fromUid = v,
        fromName = v
      })
    end
  else
    t.effectStateFrom = {
      {
        stateId = tostring(statusId),
        fromUid = LuaEntry.Player.uid,
        fromName = LuaEntry.Player.name
      }
    }
  end
  t.status = {
    {
      effNum = 100301,
      stateId = statusId,
      effVal = 1.0
    }
  }
  return t
end

PushStatusMessage.GetTestData = GetTestData
PushStatusMessage.OnCreate = OnCreate
PushStatusMessage.HandleMessage = HandleMessage
return PushStatusMessage
