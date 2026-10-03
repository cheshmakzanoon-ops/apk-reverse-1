local PushAllianceBaseInfoMessage = BaseClass("PushAllianceBaseInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.AllianceBaseDataManager:UpdateAllianceBaseData(t)
  if t.alliance then
    DataCenter.AllianceNoticeManager:UpdateAllianceFirstNoticeData(t.alliance)
    if t.alliance.autoScienceResearch then
      EventManager:GetInstance():Broadcast(EventId.AllianceAutoDinate, t.alliance.autoScienceResearch)
    end
  end
end

PushAllianceBaseInfoMessage.OnCreate = OnCreate
PushAllianceBaseInfoMessage.HandleMessage = HandleMessage
return PushAllianceBaseInfoMessage
