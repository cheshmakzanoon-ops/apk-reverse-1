local PushUseBloodNightSkillMessage = BaseClass("PushUseBloodNightSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUseBloodNightSkillMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushUseBloodNightSkillMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BloodyNightDataManager:HandleNightStalkerUltimate(t)
  end
end

return PushUseBloodNightSkillMessage
