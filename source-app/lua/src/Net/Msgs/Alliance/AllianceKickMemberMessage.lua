local AllianceKickMemberMessage = BaseClass("AllianceKickMemberMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, playerId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("playerId", playerId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMemberDataManager:RemoveAllianceMemberByUid(t.playerId)
    EventManager:GetInstance():Broadcast(EventId.AllianceMember, t.playerId)
    EventManager:GetInstance():Broadcast(EventId.OnKickAllianceMember, t.playerId)
    UIUtil.ShowTipsId(390091)
    if t.remainTimes then
      EventManager:GetInstance():Broadcast(EventId.UpdateAllianceKickTimes, t.remainTimes)
    end
  end
end

AllianceKickMemberMessage.OnCreate = OnCreate
AllianceKickMemberMessage.HandleMessage = HandleMessage
return AllianceKickMemberMessage
