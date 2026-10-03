local GetHeroTryOutInfoMessage = BaseClass("GetHeroTryOutInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetHeroTryOutInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HeroTryOutManager:OnGetHeroTryOutInfoMessageCallback(t)
  end
end

return GetHeroTryOutInfoMessage
