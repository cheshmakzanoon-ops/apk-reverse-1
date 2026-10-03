local CampScienceViewMessage = BaseClass("CampScienceViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CampScienceDataManager:RepCampScienceServer(t)
  end
end

CampScienceViewMessage.OnCreate = OnCreate
CampScienceViewMessage.HandleMessage = HandleMessage
return CampScienceViewMessage
