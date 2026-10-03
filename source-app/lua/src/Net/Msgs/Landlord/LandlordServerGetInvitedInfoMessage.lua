local LandlordServerGetInvitedInfoMessage = BaseClass("LandlordServerGetInvitedInfoMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function LandlordServerGetInvitedInfoMessage:OnCreate()
  base.OnCreate(self)
end

function LandlordServerGetInvitedInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.LandlordMgr:HandleServerGetInvitedInfo(t)
  end
end

return LandlordServerGetInvitedInfoMessage
