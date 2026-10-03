local AllScienceRefreshMessage = BaseClass("AllScienceRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.allianceScience ~= nil then
      DataCenter.AllianceScienceDataManager:UpdateAllianceScienceServer(t)
    end
    EventManager:GetInstance():Broadcast(EventId.AllianceTechnology)
    EventManager:GetInstance():Broadcast(EventId.OnGetAllianceTechMessage)
  end
end

AllScienceRefreshMessage.OnCreate = OnCreate
AllScienceRefreshMessage.HandleMessage = HandleMessage
return AllScienceRefreshMessage
