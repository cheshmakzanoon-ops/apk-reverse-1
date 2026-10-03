local ParkourShareInviteChatMessage = BaseClass("ParkourShareInviteChatMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ParkourShareInviteChatMessage:OnCreate()
  base.OnCreate(self)
end

function ParkourShareInviteChatMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId(120061)
    local curTs = UITimeManager:GetInstance():GetServerTime()
    CS.GameEntry.Setting:SetString(SettingKeys.SURFING_ON_INVITE_SHARE_CD, tostring(curTs))
  end
end

return ParkourShareInviteChatMessage
