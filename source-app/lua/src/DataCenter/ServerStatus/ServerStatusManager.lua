local ServerStatusManager = BaseClass("ServerStatusManager")
local OneServerInfo = require("DataCenter.ServerStatus.OneServerInfo")

function ServerStatusManager:__init()
  self.globalStatus = {}
  self.globalEffectDic = {}
  self.globalServerInfo = {}
end

function ServerStatusManager:__delete()
  self.globalStatus = nil
  self.globalEffectDic = nil
  self.globalServerInfo = nil
end

function ServerStatusManager:InitData(message)
  if message ~= nil and message.globalState ~= nil then
    self:SetGlobalStatus(message.globalState.list)
  end
end

function ServerStatusManager:SetGlobalStatus(message)
  self.globalStatus = {}
  self.globalEffectDic = {}
  local needBroadcast = false
  if message then
    for k, v in pairs(message) do
      if v and v.effects and v.reason and v.stateId and (v.reason == FetchGlobalStateReason.CITY_BATTLE_S1_REST_DEFEND or v.reason == FetchGlobalStateReason.WEATHER or v.reason == FetchGlobalStateReason.ZWL_FARMER_BUFF or v.reason == FetchGlobalStateReason.Season6CampDestroy or v.reason == FetchGlobalStateReason.ZWL_LANDLORD_BUFF) then
        for index, effect in ipairs(v.effects) do
          local effectId = effect.eff
          local effectValue = effect.val
          self.globalEffectDic[effectId] = (self.globalEffectDic[effectId] or 0) + effectValue
        end
        table.insert(self.globalStatus, v)
        needBroadcast = true
        if v.reason == FetchGlobalStateReason.ZWL_FARMER_BUFF or v.reason == FetchGlobalStateReason.ZWL_LANDLORD_BUFF then
          DataCenter.LandlordMgr:RecordLandlordStatusId(v.stateId)
        end
      end
    end
  end
  if needBroadcast then
    EventManager:GetInstance():Broadcast(EventId.ServerStatusChanged)
  end
end

function ServerStatusManager:GetGlobalStatus()
  return self.globalStatus or {}
end

function ServerStatusManager:GetEffectById(effectId)
  if BattleFieldUtil.InBattleField() then
    return 0
  end
  return self.globalEffectDic[effectId] or 0
end

function ServerStatusManager:GetOneServerInfo(serverId)
  if not serverId then
    return
  end
  local info = self.globalServerInfo[serverId]
  if not info then
    info = OneServerInfo.New(serverId)
    self.globalServerInfo[serverId] = info
    SFSNetwork.SendMessage(MsgDefines.GetOneServerInfo, serverId)
  end
  return info
end

function ServerStatusManager:OnHandleOneServerInfo(msg)
  if not msg then
    return
  end
  local serverId = msg.server
  if not serverId then
    return
  end
  local info = self.globalServerInfo[serverId]
  if not info then
    info = OneServerInfo.New(serverId)
    self.globalServerInfo[serverId] = info
  end
  info:UpdateFromMsg(msg)
  EventManager:GetInstance():Broadcast(EventId.ActMigrationOnUpdateOneServerInfo, info)
end

return ServerStatusManager
