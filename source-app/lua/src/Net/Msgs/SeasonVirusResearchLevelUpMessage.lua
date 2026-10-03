local SeasonVirusResearchLevelUpMessage = BaseClass("SeasonVirusResearchLevelUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    DataCenter.LWSpreadResearchDataManager:OnExpMessage(t)
  end
end

SeasonVirusResearchLevelUpMessage.HandleMessage = HandleMessage
return SeasonVirusResearchLevelUpMessage
