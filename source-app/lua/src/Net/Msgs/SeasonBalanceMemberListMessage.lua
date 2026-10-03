local SeasonBalanceMemberListMessage = BaseClass("SeasonBalanceMemberListMessage", SFSBaseMessage)
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
    DataCenter.DesertDataManager:SetSelfAllianceSendList(t)
    EventManager:GetInstance():Broadcast(EventId.GetSeasonAllianceSendMemberList)
  end
end

SeasonBalanceMemberListMessage.OnCreate = OnCreate
SeasonBalanceMemberListMessage.HandleMessage = HandleMessage
return SeasonBalanceMemberListMessage
