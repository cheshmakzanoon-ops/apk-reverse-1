local SceneStateWorld = BaseClass("SceneStateWorld")

function SceneStateWorld:__init()
end

function SceneStateWorld:__delete()
end

function SceneStateWorld:OnEnter()
  EventManager:GetInstance():Broadcast(EventId.ShowCrossServerTip)
  DataCenter.WorldBattleManager:OnEnterWorld()
  DataCenter.WorldFakeBattleManager:OnEnterWorld()
  DataCenter.LWWorldZoneChangeTipManager:AddTimer()
  EventManager:GetInstance():Broadcast(EventId.OnEnterWorldState)
end

function SceneStateWorld:OnExit()
  EventManager:GetInstance():Broadcast(EventId.ShowCrossServerTip)
  DataCenter.LWWorldZoneChangeTipManager:RemoveTimer()
  EventManager:GetInstance():Broadcast(EventId.OnExitWorldState)
end

return SceneStateWorld
