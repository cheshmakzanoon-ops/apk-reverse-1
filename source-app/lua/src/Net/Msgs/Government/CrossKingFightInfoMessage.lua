local CrossKingFightInfoMessage = BaseClass("CrossKingFightInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossKingFightInfoMessage:OnCreate()
  base.OnCreate(self)
end

function CrossKingFightInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ZoneWarManager:SetCrossKingFightInfo(t)
end

return CrossKingFightInfoMessage
