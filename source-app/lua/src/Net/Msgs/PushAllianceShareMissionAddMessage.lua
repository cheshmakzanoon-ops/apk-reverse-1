local PushAllianceShareMissionAddMessage = BaseClass("PushAllianceShareMissionAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceShareMissionAddMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceShareMissionAddMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local missionUuid = checknumber(t.missionUuid)
    DataCenter.ActDispatchTaskDataManager:OnPushMarkAdd(missionUuid)
    EventManager:GetInstance():Broadcast(EventId.DispatchTaskMarkPush, missionUuid)
  end
end

return PushAllianceShareMissionAddMessage
