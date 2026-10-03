local CampBuffViewMessage = BaseClass("CampBuffViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CampBuffViewMessage:OnCreate()
  base.OnCreate(self)
end

function CampBuffViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CampScienceDataManager:RepCampBuffServer(t)
  end
end

return CampBuffViewMessage
