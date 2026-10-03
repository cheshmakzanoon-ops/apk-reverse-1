local PushCampBuffTypeMessage = BaseClass("PushCampBuffTypeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCampBuffTypeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CampScienceDataManager:UpdateOneBuffServer(t)
  end
end

return PushCampBuffTypeMessage
