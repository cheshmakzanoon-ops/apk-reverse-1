local CrossKingRoundInfoALLMessage = BaseClass("CrossKingRoundInfoALLMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossKingRoundInfoALLMessage:OnCreate()
  base.OnCreate(self)
end

function CrossKingRoundInfoALLMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ZoneWarManager:SetCrossKingRoundInfoALL(t)
end

return CrossKingRoundInfoALLMessage
