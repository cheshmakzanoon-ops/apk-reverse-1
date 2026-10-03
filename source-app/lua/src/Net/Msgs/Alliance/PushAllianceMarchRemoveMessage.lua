local PushAllianceMarchRemoveMessage = BaseClass("PushAllianceMarchRemoveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.teamUuid ~= nil then
    local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(t.teamUuid)
    if data then
      local cancel = false
      if t.isCancel then
        cancel = t.isCancel
      end
      if cancel and LuaEntry.Player.allianceId == data.attackAllianceId then
        UIUtil.ShowTips(Localization:GetString("390786", data.attackName))
      end
      DataCenter.AllianceWarDataManager:ReduceAllianceWarCount()
      DataCenter.AllianceWarDataManager:DeleteAllianceWarDataByUuid(t.teamUuid)
      EventManager:GetInstance():Broadcast(EventId.ALLIANCE_WAR_DELETE, t.teamUuid)
    end
  end
end

PushAllianceMarchRemoveMessage.OnCreate = OnCreate
PushAllianceMarchRemoveMessage.HandleMessage = HandleMessage
return PushAllianceMarchRemoveMessage
