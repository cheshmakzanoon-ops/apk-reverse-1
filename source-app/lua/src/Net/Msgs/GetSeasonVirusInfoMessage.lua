local GetSeasonVirusInfoMessage = BaseClass("GetSeasonVirusInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    DataCenter.LWSeasonBossLoginDataManager:ParseMarchInRecorde(t)
  end
end

GetSeasonVirusInfoMessage.HandleMessage = HandleMessage
return GetSeasonVirusInfoMessage
