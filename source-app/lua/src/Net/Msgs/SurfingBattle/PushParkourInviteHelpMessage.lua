local PushParkourInviteHelpMessage = BaseClass("PushParkourInviteHelpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushParkourInviteHelpMessage:OnCreate()
  base.OnCreate(self)
end

function PushParkourInviteHelpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local playerInfo = t.playerInfo
    if playerInfo then
      DataCenter.LWSurfingDataManager:SendGetAllParkourInfosMessage()
    end
  end
end

return PushParkourInviteHelpMessage
