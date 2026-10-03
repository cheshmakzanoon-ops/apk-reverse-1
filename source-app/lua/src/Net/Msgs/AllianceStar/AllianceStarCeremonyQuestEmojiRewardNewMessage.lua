local AllianceStarCeremonyQuestEmojiRewardNewMessage = BaseClass("AllianceStarCeremonyQuestEmojiRewardNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceStarCeremonyQuestEmojiRewardNewMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceStarCeremonyQuestEmojiRewardNewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:OnAllianceStarCeremonyQuestEmojiRewardNew(t)
  end
end

return AllianceStarCeremonyQuestEmojiRewardNewMessage
