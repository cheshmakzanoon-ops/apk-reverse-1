local SceneStateCity = BaseClass("SceneStateCity")

function SceneStateCity:__init()
end

function SceneStateCity:__delete()
end

function SceneStateCity:OnEnter()
  EventManager:GetInstance():Broadcast(EventId.OnEnterCityState)
end

function SceneStateCity:OnExit()
  EventManager:GetInstance():Broadcast(EventId.OnExitCityState)
end

return SceneStateCity
