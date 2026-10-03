local PushAlHelpNewMessage = BaseClass("PushAlHelpNewMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.senderId ~= nil and t.senderId ~= LuaEntry.Player.uid then
    DataCenter.AllianceHelpDataManager:SetHelpNum(DataCenter.AllianceHelpDataManager:GetHelpNum() + 1)
    EventManager:GetInstance():Broadcast(EventId.UpdateAllianceHelpNum)
    local myAllianceCenterUuid = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER)
    if myAllianceCenterUuid and myAllianceCenterUuid.uuid then
      EventManager:GetInstance():Broadcast(EventId.AllianceMemberNeedHelp, myAllianceCenterUuid.uuid)
    end
  end
end

PushAlHelpNewMessage.OnCreate = OnCreate
PushAlHelpNewMessage.HandleMessage = HandleMessage
return PushAlHelpNewMessage
