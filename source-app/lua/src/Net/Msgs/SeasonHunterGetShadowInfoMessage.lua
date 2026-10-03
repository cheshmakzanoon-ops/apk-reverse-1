local SeasonHunterGetShadowInfoMessage = BaseClass("SeasonHunterGetShadowInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonHunterGetShadowInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function SeasonHunterGetShadowInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonHunterManager:HandleSeasonHunterGetShadowInfo(t)
  end
end

return SeasonHunterGetShadowInfoMessage
