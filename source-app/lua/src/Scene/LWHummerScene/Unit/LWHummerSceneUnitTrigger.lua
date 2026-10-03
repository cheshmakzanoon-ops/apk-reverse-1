local base = require("Scene.LWHummerScene.Unit.LWHummerSceneUnitBase")
local LWHummerSceneUnitTrigger = BaseClass("LWHummerSceneUnitTrigger", base)
local luzhang_path = "O_env_luzhang_01_zhuan_%s/O_env_beizengmen_luzhang_01_skin"
local hitEffect_path = "Eff_Common_pata_hit"

function LWHummerSceneUnitTrigger:OnDestroy()
  base.OnDestroy(self)
end

function LWHummerSceneUnitTrigger:__init(param)
  self.layerMask = LayerMask.GetMask(LayerType.Member)
end

function LWHummerSceneUnitTrigger:OnInited()
  base.OnInited(self)
  self.cfgId = self.bornData.cfgId
  self.cfg = self.logic.data:GetTriggerTemplate(self.cfgId)
  self.triggerType = self.cfg.type
  if self.cfg.type == HummerSceneTriggerType.Battle then
    self:SetPosition(self.logic.data:GetSceneCenterX(), self:GetPosition().z)
    self.luzhangAnims = {}
    for i = 1, 2 do
      local anim = self.transform:Find(string.format(luzhang_path, i)):GetComponentInChildren(typeof(CS.SimpleAnimation), true)
      anim:Play("show2")
      table.insert(self.luzhangAnims, anim)
    end
    self.hitEffect = self.transform:Find(hitEffect_path).gameObject
    self.hitEffect:SetActive(false)
  end
end

function LWHummerSceneUnitTrigger:OnCollisionPlayer(other, trigger)
  if trigger then
    local unit = self.logic:GetUnit(trigger.ObjectId)
    if unit and unit.unitType == HummerSceneUnitType.Player then
      if self.triggerType == HummerSceneTriggerType.SpeedAdd then
        self.colliderComponent.active = false
        unit:OnCollisionTrigger(self)
        self.logic:RemoveUnit(self)
      elseif self.triggerType == HummerSceneTriggerType.Battle then
        self.colliderComponent.active = false
        self.logic:ChangeBattle(self)
      elseif self.triggerType == HummerSceneTriggerType.Air then
        self.colliderComponent.active = false
        self.logic:AddAir()
        self.logic:RemoveUnit(self)
      end
      EventManager:GetInstance():Broadcast(EventId.HummerSceneTrigger, self.cfg)
    end
  end
end

function LWHummerSceneUnitTrigger:OnUpdate(dt)
  base.OnUpdate(self, dt)
  if self.isLoaded and self.curPos.z < self.logic:GetFollowCameraTarget().z then
    self.logic:RemoveUnit(self)
    return
  end
end

function LWHummerSceneUnitTrigger:ShowBattleExit()
  for i, v in ipairs(self.luzhangAnims) do
    v:Play("show3")
  end
  self.hitEffect:SetActive(true)
end

return LWHummerSceneUnitTrigger
