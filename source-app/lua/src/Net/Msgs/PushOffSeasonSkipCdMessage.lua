local PushOffSeasonSkipCdMessage = BaseClass("PushOffSeasonSkipCdMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushOffSeasonSkipCdMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushOffSeasonSkipCdMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWAllyStationDataManager:OnPushOffSeasonSkipCD(t)
  end
end

return PushOffSeasonSkipCdMessage
