local GetCrossOccupyStrongholdListMessage = BaseClass("GetCrossOccupyStrongholdListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCrossOccupyStrongholdListMessage:OnCreate()
  base.OnCreate(self)
end

function GetCrossOccupyStrongholdListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonDataManager.CrossOccupyStrongholdRewardInfo = t.rewardInfo
  DataCenter.SeasonDataManager.dailyStrongholdOccupyNum = t.dailyOccupyNum
  DataCenter.SeasonDataManager.dailyStrongholdOccupyMaxNum = t.dailyOccupyMaxNum
  DataCenter.SeasonDataManager.CrossOccupyStrongholdList = t.list
  DataCenter.SeasonDataManager.CrossOccupyStrongholdMaxNum = t.maxNum
  if not table.IsNullOrEmpty(t.depositBanks) then
    local dic = {}
    for index, v in ipairs(t.depositBanks) do
      dic[v] = v
    end
    DataCenter.SeasonBankManager.depositBanksDic = dic
  else
    DataCenter.SeasonBankManager.depositBanksDic = nil
  end
  EventManager:GetInstance():Broadcast(EventId.CrossOccupyStrongholdListUpdate)
end

return GetCrossOccupyStrongholdListMessage
