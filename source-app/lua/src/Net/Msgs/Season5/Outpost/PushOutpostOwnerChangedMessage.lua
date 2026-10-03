local PushOutpostOwnerChangedMessage = BaseClass("PushOutpostOwnerChangedMessage", SFSBaseMessage)
local base = SFSBaseMessage
local tmpOwnerCache = {}

function PushOutpostOwnerChangedMessage:OnCreate()
  base.OnCreate(self)
end

function PushOutpostOwnerChangedMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local cityId = toInt(t.cityId)
  local tmpOwnerServerId = toInt(t.tmpOwnerServerId)
  if cityId <= 0 or tmpOwnerServerId <= 0 then
    return
  end
  local curServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.View)
  t.now = UITimeManager:GetInstance():GetServerTime()
  if 0 < tmpOwnerServerId then
    local seasonInfo = SeasonUtil.GetSeasonInfo(tmpOwnerServerId)
    if seasonInfo then
      curServerId = seasonInfo:GetNinePalacesServer(5)
    end
  end
  tmpOwnerCache[curServerId * 10000 + cityId] = t
  Logger.LogInfo(string.format("OutpostOwnerChanged Owner = %s , serverId = %s , cityId = %s", tmpOwnerServerId, curServerId, cityId))
  local uuid = CS.WorldPointManager.GetCityUuid(curServerId, cityId)
  if uuid == nil or uuid == 0 then
    return
  end
  if not SceneUtils.GetIsInWorld() then
    return
  end
  local world = CS.SceneManager.World
  if world == nil then
    return
  end
  local obj = world:GetObjectByUuid(uuid)
  if obj ~= nil and type(obj.OwnerChanged) == "function" then
    obj:OwnerChanged(tmpOwnerServerId)
  end
  if t.firstOccupyServerId == nil then
  else
    EventManager:GetInstance():Broadcast(EventId.OutpostOwnerChanged, t)
  end
end

function PushOutpostOwnerChangedMessage.GetTempOwnerInfo(cityId, serverId)
  if tmpOwnerCache then
    return tmpOwnerCache[serverId * 10000 + cityId]
  end
  return nil
end

function PushOutpostOwnerChangedMessage.CleanTempScoreInfo()
  tmpOwnerCache = {}
end

return PushOutpostOwnerChangedMessage
