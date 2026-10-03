local FetchOutpostDetailInfoMessage = BaseClass("FetchOutpostDetailInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local _DetailInfo = {}

function FetchOutpostDetailInfoMessage:OnCreate(serverId, cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("clientServerId", serverId)
  self.sfsObj:PutInt("cityId", cityId)
  self.sfsObj:PutInt("previewAssistance", 10)
end

function FetchOutpostDetailInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local serverId = toInt(t.clientServerId)
  local cityId = toInt(t.cityId)
  if 0 < cityId then
    _DetailInfo[serverId * 10000 + cityId] = t
    if SeasonUtil.IsInSameGroup(serverId, ServerEnum.Source) then
      DataCenter.SeasonOutpostManager:SetOutpostDetailInfo(serverId, cityId, t)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.OutpostDetailInfoUpdate, t)
end

function FetchOutpostDetailInfoMessage.OutpostOwnerChanged(new_data)
  if _DetailInfo and new_data then
    local ownerServerId = toInt(new_data.ownerServerId)
    local cityId = toInt(new_data.cityId)
    local info = SeasonUtil.GetSeasonInfo(ownerServerId)
    if info then
      local serverId = SeasonUtil.GetShownServerIdByCityIdInBigMap(ownerServerId, cityId)
      _DetailInfo[serverId * 10000 + cityId] = new_data
      EventManager:GetInstance():Broadcast(EventId.OutpostDetailInfoUpdate, new_data)
      if SeasonUtil.IsInSameGroup(serverId, ServerEnum.Source) then
        DataCenter.SeasonOutpostManager:SetOutpostDetailInfo(serverId, cityId, new_data)
      end
    end
  end
end

function FetchOutpostDetailInfoMessage.GetDetailInfo(_serverId, _cityId, fetchWhenNotExist, forceRequest)
  local serverId = toInt(_serverId)
  local cityId = toInt(_cityId)
  local data = _DetailInfo[serverId * 10000 + cityId]
  if forceRequest or fetchWhenNotExist and data == nil and 0 < serverId and 0 < cityId then
    SFSNetwork.SendMessage(MsgDefines.FetchOutpostDetailInfo, serverId, cityId)
  end
  return data
end

return FetchOutpostDetailInfoMessage
