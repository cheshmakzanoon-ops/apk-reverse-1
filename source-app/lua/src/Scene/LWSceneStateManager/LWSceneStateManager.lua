local LWSceneStateManager = BaseClass("LWSceneStateManager", Singleton)
local FSM = require("Framework.Common.FSM")
local SceneStateNone = require("Scene.LWSceneStateManager.SceneStateNone")
local SceneStateCity = require("Scene.LWSceneStateManager.SceneStateCity")
local SceneStateWorld = require("Scene.LWSceneStateManager.SceneStateWorld")
local SceneStatePVE = require("Scene.LWSceneStateManager.SceneStatePVE")
local SceneStateCustom = require("Scene.LWSceneStateManager.SceneStateCustom")

function LWSceneStateManager:__init()
  self.fsm = FSM.New()
  self.fsm:AddState(SceneType.None, SceneStateNone.New(self))
  self.fsm:AddState(SceneType.City, SceneStateCity.New(self))
  self.fsm:AddState(SceneType.World, SceneStateWorld.New(self))
  self.fsm:AddState(SceneType.PVE, SceneStatePVE.New(self))
  self.fsm:AddState(SceneType.Custom, SceneStateCustom.New(self))
  self.fsm:ChangeState(SceneType.None)
end

function LWSceneStateManager:__delete()
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
end

function LWSceneStateManager:StartUp()
end

function LWSceneStateManager:ChangeScene(sceneType)
  self.fsm:ChangeState(sceneType)
  if sceneType ~= SceneType.City and sceneType ~= SceneType.World then
    DataCenter.ActWinterStormManager:TryCancelMatch(WinterStormCancelType.OtherChangeScene)
    EventManager:GetInstance():Broadcast(EventId.ChangeOtherScene, sceneType)
  else
    EventManager:GetInstance():Broadcast(EventId.ChangeBaseScene, sceneType)
  end
end

function LWSceneStateManager:GetCurScene()
  return self.fsm:GetStateIndex()
end

return LWSceneStateManager
