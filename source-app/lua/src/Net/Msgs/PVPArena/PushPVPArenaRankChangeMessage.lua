local PushPVPArenaRankChangeMessage = BaseClass("PushPVPArenaRankChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushPVPArenaRankChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushPVPArenaRankChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWPVPArenaManager:OnRankChange(t)
  end
end

return PushPVPArenaRankChangeMessage
