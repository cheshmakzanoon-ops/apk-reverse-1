local PushCampScienceChangeMessage = BaseClass("PushCampScienceChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCampScienceChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CampScienceDataManager:RepCampScienceServer(t)
  end
end

return PushCampScienceChangeMessage
