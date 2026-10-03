local FetchHeroEventCfgInfoMessage = BaseClass("FetchHeroEventCfgInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local __heroEventData

function FetchHeroEventCfgInfoMessage:OnCreate(heroEventId)
  base.OnCreate(self)
  self.sfsObj:PutInt("heroEventId", heroEventId)
end

function FetchHeroEventCfgInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local heroEventId = t.heroEventId
  if heroEventId then
    if __heroEventData == nil then
      __heroEventData = {}
    end
    __heroEventData[heroEventId] = t
    EventManager:GetInstance():Broadcast(EventId.HeroEventCfgInfoUpdate, heroEventId)
  end
end

function FetchHeroEventCfgInfoMessage.GetCfgInfo(_heroEventId, fetchWhenNotExist, forceRequest)
  local heroEventId = toInt(_heroEventId)
  local data
  if __heroEventData ~= nil then
    data = __heroEventData[heroEventId]
  end
  if forceRequest or fetchWhenNotExist and data == nil and 0 < heroEventId then
    SFSNetwork.SendMessage(MsgDefines.FetchHeroEventCfgInfo, heroEventId)
  end
  return data
end

function FetchHeroEventCfgInfoMessage.ClearCache(_heroEventId)
  local heroEventId = toInt(_heroEventId)
  if __heroEventData ~= nil then
    __heroEventData[heroEventId] = nil
  end
end

return FetchHeroEventCfgInfoMessage
