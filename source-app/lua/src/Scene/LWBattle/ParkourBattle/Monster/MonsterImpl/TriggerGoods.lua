local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerBase")
local TriggerGoods = BaseClass("TriggerGoods", base)
local Collider = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.Component.ColliderComponent")

function TriggerGoods:Init(logic, mgr, guid, x, y, monsterMeta, triggerItemMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.deathEvent = triggerItemMeta.id
  self.triggerMeta = triggerItemMeta
end

function TriggerGoods:DestroyView()
  base.DestroyView(self)
  if self.deathTimer then
    self.deathTimer:Stop()
    self.deathTimer = nil
  end
  self.animator = nil
end

function TriggerGoods:InitView()
  self.gameObject.name = "TriggerGoods" .. self.guid
  self.animator = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
end

function TriggerGoods:Trigger(colliderComponentCnt, colliderComponentArray)
  self:TriggerEvent(self.deathEvent, Vector3.New(self.x, 6, self.y))
  if self.colliderComponent then
    self.colliderComponent:Destroy()
    self.colliderComponent = nil
  end
  self:ShowDissolveEffect()
  local citySpaceManTrigger
  if colliderComponentArray then
    citySpaceManTrigger = colliderComponentArray[0]:GetComponent(typeof(CS.CitySpaceManTrigger))
  end
  if citySpaceManTrigger ~= nil and citySpaceManTrigger.ObjectId ~= 0 then
    local objId = citySpaceManTrigger.ObjectId
    local obj = self.battleMgr:GetUnit(objId)
    if obj ~= nil and 0 < obj:GetCurBlood() then
      self.battleMgr:ShowEffectObj("Assets/_Art_LastWar/Effect/Prefab/UI/Beizengmen/Eff_beizengmen_jinbi_chupeng.prefab", Vector3.New(0, 0, 1), nil, 1, citySpaceManTrigger.transform)
    end
  end
  if self.animator then
    self.animator:Play("Eff_beizengmen_jinbi_xiaoshi", 0, 0)
  end
  self.deathTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:Death()
  end, 1)
end

function TriggerGoods:ProcessBuff(monsterMeta)
end

return TriggerGoods
