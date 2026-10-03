local PushLwUserSkillRefreshMessage = BaseClass("PushLwUserSkillRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushLwUserSkillRefreshMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushLwUserSkillRefreshMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.MasteryManager:SetSkillCdAndEffectTime(t)
end

return PushLwUserSkillRefreshMessage
