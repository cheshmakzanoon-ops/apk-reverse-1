local AllianceStarCeremonyInteractionMessage = BaseClass("AllianceStarCeremonyInteractionMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceStarCeremonyInteractionMessage:OnCreate(type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

function AllianceStarCeremonyInteractionMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return AllianceStarCeremonyInteractionMessage
