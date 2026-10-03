local TorchRelayScenePropsBase = require("DataCenter.LWBattle.Logic.TorchRelayBattle.Props.TorchRelayScenePropsBase")
local base = TorchRelayScenePropsBase
local MotionPart = require("DataCenter.LWBattle.Logic.CountBattle.Traps.Motion.MotionPart")
local TorchRelayScenePropsZombieObstacles = BaseClass("TorchRelayScenePropsZombieObstacles", TorchRelayScenePropsBase)

function TorchRelayScenePropsZombieObstacles:__init(bornData, sceneRoot, logic)
end

function TorchRelayScenePropsZombieObstacles:__delete()
end

function TorchRelayScenePropsZombieObstacles:OnCollisionPlayer(playerCollider, cpt)
  base.OnCollisionPlayer(self, playerCollider, cpt)
  local config = self.bornData.props.config
  local propsData = {}
  propsData.instanceId = self.id
  propsData.configId = config.id
  propsData.config = config
  propsData.subStrength = config.para1
  self.logic:OnObstaclesTrigger(propsData)
  if self.anims then
    for i = 0, self.anims.Length - 1 do
      self.anims[i]:Play("dead")
    end
  end
end

function TorchRelayScenePropsZombieObstacles:OnResLoaded()
  base.OnResLoaded(self)
  if self.transform then
    self.anims = self.transform:GetComponentsInChildren(typeof(CS.SimpleAnimation), true)
  end
end

return TorchRelayScenePropsZombieObstacles
