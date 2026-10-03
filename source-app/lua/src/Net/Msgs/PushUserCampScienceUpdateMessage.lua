local PushUserCampScienceUpdateMessage = BaseClass("PushUserCampScienceUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUserCampScienceUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CampScienceDataManager:RepCampScienceServer(t)
  end
end

return PushUserCampScienceUpdateMessage
