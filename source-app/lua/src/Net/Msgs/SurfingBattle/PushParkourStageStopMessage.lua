local PushParkourStageStopMessage = BaseClass("PushParkourStageStopMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushParkourStageStopMessage:OnCreate()
  base.OnCreate(self)
end

function PushParkourStageStopMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  EventManager:GetInstance():Broadcast(EventId.SurfingFightOnStageStop, t)
  local reason = t.reason
  if reason and 0 < reason then
    if reason == 10 then
      DataCenter.LWBattleManager:ShowTipsId("parkour_activity_end_tips")
    else
      DataCenter.LWBattleManager:ShowTipsId("parkour_cheat_01")
    end
  end
end

return PushParkourStageStopMessage
