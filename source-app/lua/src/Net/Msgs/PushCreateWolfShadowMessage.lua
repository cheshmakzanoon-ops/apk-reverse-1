local PushCreateWolfShadowMessage = BaseClass("PushCreateWolfShadowMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCreateWolfShadowMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushCreateWolfShadowMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonHunterManager:HandleSeasonHunterGetShadowInfo(t)
  end
end

return PushCreateWolfShadowMessage
