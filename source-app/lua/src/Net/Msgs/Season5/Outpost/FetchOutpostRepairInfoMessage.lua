local FetchOutpostRepairInfoMessage = BaseClass("FetchOutpostRepairInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local _RepairInfo = {}
local _todayRepairInfo = {repairCount = 0, updateTime = 0}

function FetchOutpostRepairInfoMessage:OnCreate(serverId, cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("clientServerId", serverId)
  self.sfsObj:PutInt("cityId", cityId)
end

function FetchOutpostRepairInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local now = UITimeManager:GetInstance():GetServerTime()
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.repairCount then
    if _todayRepairInfo == nil then
      _todayRepairInfo = {
        repairCount = toInt(t.repairCount),
        updateTime = now
      }
    else
      _todayRepairInfo.repairCount = toInt(t.repairCount)
      _todayRepairInfo.updateTime = now
    end
  end
  if t.outpostInfo then
    local serverId = toInt(t.clientServerId)
    local cityId = toInt(t.outpostInfo.cityId)
    if 0 < cityId then
      _RepairInfo[serverId * 10000 + cityId] = t
      if SeasonUtil.IsInSameGroup(serverId, ServerEnum.Source) then
        DataCenter.SeasonOutpostManager:SetOutpostRepairInfo(serverId, cityId, t)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.OutpostRepairInfoUpdate, t)
end

function FetchOutpostRepairInfoMessage.GetRepairInfo(_serverId, _cityId, fetchWhenNotExist, forceRequest)
  local serverId = toInt(_serverId)
  local cityId = toInt(_cityId)
  local data = _RepairInfo[serverId * 10000 + cityId]
  if (forceRequest or fetchWhenNotExist and data == nil and 0 < serverId and 0 < cityId) and SeasonUtil.IsOutpost(cityId, serverId) then
    SFSNetwork.SendMessage(MsgDefines.FetchOutpostRepairInfo, serverId, cityId)
  end
  return data
end

function FetchOutpostRepairInfoMessage.GetTodayRepairCount()
  if _todayRepairInfo == nil then
    return 0
  end
  local nowMs = UITimeManager:GetInstance():GetServerTime()
  local updateZero = UITimeManager:GetInstance():GetZeroTime(_todayRepairInfo.updateTime)
  local nowZero = UITimeManager:GetInstance():GetZeroTime(nowMs)
  if nowZero == updateZero then
    return toInt(_todayRepairInfo.repairCount)
  end
  return 0
end

return FetchOutpostRepairInfoMessage
