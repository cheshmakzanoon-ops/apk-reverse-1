local AlScienceResearchMessage = BaseClass("AlScienceResearchMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, scienceId)
  base.OnCreate(self)
  self.sfsObj:PutInt("scienceId", scienceId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceScienceDataManager:EndRefreshAllScienceNum(t)
    DataCenter.AllianceScienceDataManager:UpdateOneAllianceScience(t)
    EventManager:GetInstance():Broadcast(EventId.AllianceTechnology)
  end
end

AlScienceResearchMessage.OnCreate = OnCreate
AlScienceResearchMessage.HandleMessage = HandleMessage
return AlScienceResearchMessage
