local PushBountyRecordMessage = BaseClass("PushBountyRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBountyRecordMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBountyRecordMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonBountyShopManager:HandleRecordPush(t)
  end
end

return PushBountyRecordMessage
