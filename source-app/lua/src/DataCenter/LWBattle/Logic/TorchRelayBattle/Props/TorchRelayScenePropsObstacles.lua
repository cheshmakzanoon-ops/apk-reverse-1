local TorchRelayScenePropsBase = require("DataCenter.LWBattle.Logic.TorchRelayBattle.Props.TorchRelayScenePropsBase")
local base = TorchRelayScenePropsBase
local MotionPart = require("DataCenter.LWBattle.Logic.CountBattle.Traps.Motion.MotionPart")
local TorchRelayScenePropsObstacles = BaseClass("TorchRelayScenePropsObstacles", TorchRelayScenePropsBase)

function TorchRelayScenePropsObstacles:__init(bornData, sceneRoot, logic)
  self.motionParts = {}
end

function TorchRelayScenePropsObstacles:__delete()
  for _, motionPart in pairs(self.motionParts) do
    motionPart:Dispose()
  end
  self.motionParts = nil
end

function TorchRelayScenePropsObstacles:ReInit(bornData, sceneRoot, logic)
  base.ReInit(self, bornData, sceneRoot, logic)
  for _, motionPart in pairs(self.motionParts) do
    motionPart:RevertStatus()
  end
end

function TorchRelayScenePropsObstacles:Recycle()
  base.Recycle(self)
end

function TorchRelayScenePropsObstacles:OnResLoaded()
  base.OnResLoaded(self)
  self:InitMotion()
end

function TorchRelayScenePropsObstacles:OnCollisionPlayer(playerCollider, cpt)
  base.OnCollisionPlayer(self, playerCollider, cpt)
  local config = self.bornData.props.config
  local propsData = {}
  propsData.instanceId = self.id
  propsData.configId = config.id
  propsData.config = config
  propsData.subStrength = config.para1
  self.logic:OnObstaclesTrigger(propsData)
end

function TorchRelayScenePropsObstacles:OnUpdate(dt)
  base.OnUpdate(self, dt)
  for _, motionPart in pairs(self.motionParts) do
    motionPart:OnUpdate(dt)
    motionPart:SyncView()
  end
end

function TorchRelayScenePropsObstacles:InitMotion()
  if self.resConfig.motionCfgs == nil then
    return
  end
  for _, motionCfg in ipairs(self.resConfig.motionCfgs) do
    local motionPart = self.motionParts[motionCfg.part]
    if not motionPart then
      local rootTrans = motionCfg.part == "root"
      local partTrans = rootTrans and self.transform or self.transform:Find(motionCfg.part)
      assert(partTrans, "TrapDynamic motion part not found: " .. motionCfg.part)
      motionPart = MotionPart.Create(self, partTrans, rootTrans)
      self.motionParts[motionCfg.part] = motionPart
    end
    motionPart:AddMotion(motionCfg)
  end
end

return TorchRelayScenePropsObstacles
