local AllianceStarGainCeremonyInfoNewMessage = BaseClass("AllianceStarGainCeremonyInfoNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceStarGainCeremonyInfoNewMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceStarGainCeremonyInfoNewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:OnAllianceStarGainCeremonyInfoNew(t)
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIAllianceStarMain) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceStarMain, {anim = true})
    end
  end
end

return AllianceStarGainCeremonyInfoNewMessage
