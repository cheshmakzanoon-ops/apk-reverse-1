local GetSeasonVirusResearchInfoMessage = BaseClass("GetSeasonVirusResearchInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSpreadResearchDataManager:OnMessage(t)
  end
end

GetSeasonVirusResearchInfoMessage.HandleMessage = HandleMessage
return GetSeasonVirusResearchInfoMessage
