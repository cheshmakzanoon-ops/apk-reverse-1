local PushSeasonSettleRecordMessage = BaseClass("PushSeasonSettleRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSeasonSettleRecordMessage:OnCreate()
  base.OnCreate(self)
end

function PushSeasonSettleRecordMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonPhotoSimpleAllView)
end

return PushSeasonSettleRecordMessage
