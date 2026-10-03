local LandlordServerOptInvitedMessage = BaseClass("LandlordServerOptInvitedMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function LandlordServerOptInvitedMessage:OnCreate(opt)
  base.OnCreate(self)
  self.sfsObj:PutBool("opt", opt)
end

function LandlordServerOptInvitedMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.LandlordMgr:HandleServerOptInvitedInfo(t)
  end
end

return LandlordServerOptInvitedMessage
