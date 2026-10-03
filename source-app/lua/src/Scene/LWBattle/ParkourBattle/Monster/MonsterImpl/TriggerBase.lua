local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.MonsterObj")
local TriggerBase = BaseClass("TriggerBase", base)
local Collider = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.Component.ColliderComponent")
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local Const = require("Scene.LWBattle.Const")

function TriggerBase:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.colliderComponent = Collider.New()
end

function TriggerBase:Load()
  local holderAsset = self.triggerMeta.effect
  self.req = Resource:InstantiateAsync(holderAsset)
  self.req:completed("+", function(req)
    self:OnLoadCompleteGate(req)
  end)
end

function TriggerBase:OnLoadCompleteGate(req)
  self.gameObject = req.gameObject
  self.transform = self.gameObject.transform
  self.transform:Set_position(self.x, 0, self.y)
  self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  local trigger = self.gameObject:GetOrAddComponent(typeof(CS.CitySpaceManTrigger))
  if trigger then
    trigger.ObjectId = self.guid
  end
  if self.colliderComponent then
    self.colliderComponent:InitCollider(self.transform, 10, LayerMask.GetMask("Member"))
    self.colliderComponent:SetOnCollide(function(colliderComponentCnt, colliderComponentArray)
      self:Trigger(colliderComponentCnt, colliderComponentArray)
    end)
  end
  self:InitView()
end

function TriggerBase:OnUpdate(deltaTime)
  if self.colliderComponent then
    self.colliderComponent:CollisionDetect()
  end
  if self.logic.battleType and (not (self.logic.battleType ~= Const.ParkourBattleType.Defense or self.airDropping) or self.forceUpdateReversePos) then
    self:UpdateReversePos(deltaTime)
  end
end

function TriggerBase:UpdateReversePos(deltaTime)
  local pos = self:GetPosition()
  local add = self.logic:GetMoveSpeedZ() * deltaTime
  local z = pos.z - add
  self.y = z
  if self.transform then
    self.transform:Set_position(pos.x, 0, z)
  else
    self.curWorldPos.z = z
  end
end

function TriggerBase:InitView()
end

function TriggerBase:Trigger(colliderComponentCnt, colliderComponentArray)
end

function TriggerBase:DestroyView()
  base.DestroyView(self)
  if self.colliderComponent then
    self.colliderComponent:Destroy()
    self.colliderComponent = nil
  end
  self.collider = nil
  self:RemoveBuffManager()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
end

function TriggerBase:DestroyData()
  base.DestroyData(self)
  self.deathEvent = nil
  self.triggerMeta = nil
end

function TriggerBase:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir)
end

function TriggerBase:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir)
end

function TriggerBase:GetCurBlood()
  return 0
end

function TriggerBase:GetProperty(propertyType)
  return 0
end

function TriggerBase:GetRawProperty(type)
  return 0
end

function TriggerBase:ProcessBuff(monsterMeta)
  local spl = string.split(monsterMeta.death_trigger_item or "", ",")
  local deathEvent = {}
  for _, pair in ipairs(spl) do
    local _spl = string.split(pair, "|")
    if #_spl == 2 then
      table.insert(deathEvent, {
        tonumber(_spl[1]),
        tonumber(_spl[2])
      })
    end
  end
  self.deathEvent = deathEvent
end

function TriggerBase:RandomGetDeathEvent()
  if not self.deathEvent then
    return
  end
  local cnt = 0
  if #self.deathEvent < 1 then
    return
  end
  for _, event in ipairs(self.deathEvent) do
    cnt = cnt + event[2]
  end
  cnt = math.random(0, cnt)
  for _, event in ipairs(self.deathEvent) do
    cnt = cnt - event[2]
    if cnt <= 0 then
      return event[1]
    end
  end
end

function TriggerBase:ShowDissolveEffect()
  if not string.IsNullOrEmpty(self.triggerMeta.dead_effect) then
    self.battleMgr:ShowEffectObj(self.triggerMeta.dead_effect, self:GetPosition(), nil, 1, nil)
  end
  if not string.IsNullOrEmpty(self.triggerMeta.desc) then
    self.battleMgr:ShowDamageText(Localization:GetString(self.triggerMeta.desc), self:GetPosition(), DamageTextType.GetBuff, nil, false, self.triggerMeta.text_time)
  end
end

return TriggerBase
