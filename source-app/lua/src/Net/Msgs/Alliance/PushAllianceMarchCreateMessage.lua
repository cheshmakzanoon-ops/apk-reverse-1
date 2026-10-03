local PushAllianceMarchCreateMessage = BaseClass("PushAllianceMarchCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if not LuaEntry.Player:IsInAlliance() then
    return
  end
  DataCenter.AllianceWarDataManager:AddAllianceWarCount()
  DataCenter.AllianceWarDataManager:UpdateOneAllianceWarList(t, true)
  DataCenter.AllianceWarDataManager:CalculateAlertNum()
  local attackName = ""
  if t.attackName ~= nil then
    attackName = t.attackName
    if LuaEntry.Player.allianceId == t.attackAllianceId then
      EventManager:GetInstance():Broadcast(EventId.AllianceWarNew, {
        uuid = t.uuid,
        name = attackName,
        ownerUid = t.leaderMarch.ownerUid
      })
    end
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceWarUpdate)
end

PushAllianceMarchCreateMessage.OnCreate = OnCreate
PushAllianceMarchCreateMessage.HandleMessage = HandleMessage
return PushAllianceMarchCreateMessage
