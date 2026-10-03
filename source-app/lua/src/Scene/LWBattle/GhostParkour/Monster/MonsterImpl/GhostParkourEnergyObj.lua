local base = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingObj")
local GhostParkourEnergyObj = BaseClass("GhostParkourEnergyObj", base)
local ROTATE_TIME = 2

function GhostParkourEnergyObj:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  self.isMoving = nil
  self.duration = nil
  self.movingTime = nil
  self._showStaticEffect = true
end

function GhostParkourEnergyObj:OnLoadComplete()
  base.OnLoadComplete(self)
  self:UpdateSelfRotate()
end

function GhostParkourEnergyObj:ShowStaticEffect()
  if self.logic.ignoreSpectacularEffect then
    return
  end
  if self.isMoving then
    return
  end
  local pos = self.logic.staticEffectCommonPos
  if self.effectParent == nil then
    pos.x = self.curWorldPos.x
    pos.y = self.curWorldPos.y + 0.9
    pos.z = self.curWorldPos.z
  else
    pos.x = 0
    pos.y = 0.9
    pos.z = 0
  end
  self.staticEffectId = self.logic:ShowEffectObj("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_ljw_s4_running_gold_glow.prefab", pos, nil, -1, self.effectParent)
end

function GhostParkourEnergyObj:ResetEffectPosition()
  if self.effectParent == nil and self.staticEffectId then
    local p = self.curWorldPos
    self.logic:ResetEffectPosition(self.staticEffectId, p.x, p.y + 0.9, p.z)
  end
end

function GhostParkourEnergyObj:DestroyData()
  base.DestroyData(self)
  self.isMoving = nil
  self.duration = nil
  self.movingTime = nil
end

function GhostParkourEnergyObj:OnCollide(target)
  local para = {}
  local goodsParam = self.monsterMeta:GetGoodsParam()
  if goodsParam then
    local goodsId = goodsParam.goodsId
    para.goodsId = goodsId
    local goodsCount = goodsParam.goodsCount
    para.goodsCount = goodsCount
    EventManager:GetInstance():Broadcast(EventId.OnPVEBattleGetGoods, para)
    self.logic:RecordGoods(SurfingGoodsType.Energy, goodsId, goodsCount)
    target:ShowUnitEffect(SurfingUnitEffectType.GotEnergy)
  end
  base.OnCollide(self, target)
end

function GhostParkourEnergyObj:OnUpdate(deltaTime, viewY)
  base.OnUpdate(self, deltaTime, viewY)
  self:UpdateMoving(deltaTime)
  self:UpdateSelfRotate()
end

function GhostParkourEnergyObj:SetIsAutoMove(isOn, unit)
  if self.isMoving == nil then
    return
  end
  if self.isMoving == isOn then
    return
  end
  self.isMoving = isOn
  if isOn and unit and self.transform then
    self:RemoveEffect()
    self:ResetToIdle()
    self.transform:SetParent(unit.transform)
    local x, y, z = self.transform:Get_localPosition()
    self:SetLocalPosition(Vector3.New(x, y, z))
    self.duration = 0.5
    self.movingTime = self.duration
  end
end

function GhostParkourEnergyObj:UpdateSelfRotate()
  if not self.transform then
    return
  end
  if not self.logic or self.logic.lowDevice then
    return
  end
  local t = math.fmod(self.logic.totalRunTime, ROTATE_TIME)
  local r = Mathf.Lerp(0, 360, t / ROTATE_TIME)
  self.transform:Set_eulerAngles(0, r, 0)
end

function GhostParkourEnergyObj:UpdateMoving(deltaTime)
  if not self.isMoving then
    return
  end
  if self.movingTime > 0 then
    self.movingTime = self.movingTime - deltaTime
    local localPos = self:GetLocalPosition()
    local pos = Vector3.Lerp(localPos, Vector3.zero, 1 - self.movingTime / self.duration)
    self:SetLocalPosition(pos)
  else
    self:Death()
  end
end

function GhostParkourEnergyObj:Death()
  DataCenter.LWSoundManager:PlaySoundByCache(11005)
  if self.isMoving then
    self.transform:SetParent(nil)
  end
  base.Death(self)
end

return GhostParkourEnergyObj
