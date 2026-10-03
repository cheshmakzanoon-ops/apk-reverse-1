local PushLandlordJoinedMessage = BaseClass("PushLandlordJoinedMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function PushLandlordJoinedMessage:OnCreate()
  base.OnCreate(self)
end

function PushLandlordJoinedMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.LandlordMgr:HandleServerJoined(t)
  end
end

return PushLandlordJoinedMessage
