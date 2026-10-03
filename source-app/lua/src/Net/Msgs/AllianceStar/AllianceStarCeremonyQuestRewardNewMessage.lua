local AllianceStarCeremonyQuestRewardNewMessage = BaseClass("AllianceStarCeremonyQuestRewardNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceStarCeremonyQuestRewardNewMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceStarCeremonyQuestRewardNewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:OnAllianceStarCeremonyQuestRewardNew(t)
  end
end

return AllianceStarCeremonyQuestRewardNewMessage
