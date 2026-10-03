local EnableShowCampInfoToALLMessage = BaseClass("EnableShowCampInfoToALLMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EnableShowCampInfoToALLMessage:OnCreate()
  base.OnCreate(self)
end

function EnableShowCampInfoToALLMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.showSelect then
    UIUtil.ShowTipsId("120094")
    Setting:SetPrivateBool("EnableShowSnowCampInfoToALL", true)
    SFSNetwork.SendMessage(MsgDefines.GetSeasonFactionHistory, 0, 10)
  end
end

return EnableShowCampInfoToALLMessage
