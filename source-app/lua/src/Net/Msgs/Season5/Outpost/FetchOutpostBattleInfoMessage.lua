local FetchOutpostBattleInfoMessage = BaseClass("FetchOutpostBattleInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local _BattleInfo

function FetchOutpostBattleInfoMessage:OnCreate()
  base.OnCreate(self)
end

function FetchOutpostBattleInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.user then
    t.now = UITimeManager:GetInstance():GetServerTime()
    _BattleInfo = t
    EventManager:GetInstance():Broadcast(EventId.OutpostBattleInfoUpdate, t)
  end
end

function FetchOutpostBattleInfoMessage.OutpostOwnerChanged(new_data)
  if _BattleInfo and new_data then
    local outpostInfoList = _BattleInfo.outpostInfoList
    if outpostInfoList then
      for key, data in pairs(outpostInfoList) do
        if data.cityId == new_data.cityId then
          outpostInfoList[key] = new_data
          EventManager:GetInstance():Broadcast(EventId.OutpostBattleInfoUpdate, _BattleInfo)
          return true
        end
      end
    end
  end
  return false
end

function FetchOutpostBattleInfoMessage.GetBattleInfo(fetchWhenNotExist, forceRequest)
  local data = _BattleInfo
  local now = UITimeManager:GetInstance():GetServerTime()
  if forceRequest or fetchWhenNotExist and data == nil or data ~= nil and data.now ~= nil and now - data.now > 5000 then
    SFSNetwork.SendMessage(MsgDefines.FetchOutpostBattleInfo)
  end
  return data
end

function FetchOutpostBattleInfoMessage.HasRed()
  local data = _BattleInfo
  if data == nil or data.user == nil or data.user.scoreBox == nil then
    return false
  end
  local score = data.user.score
  local scoreBox = data.user.scoreBox
  local scoreRewardIndex = data.user.scoreRewardIndex
  if score == nil or score == 0 then
    return false
  end
  local can_get_count = 0
  for k, v in pairs(scoreBox) do
    if v and v.target and score >= v.target then
      can_get_count = can_get_count + 1
    end
  end
  return can_get_count > table.count(scoreRewardIndex)
end

return FetchOutpostBattleInfoMessage
