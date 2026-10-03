local base = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingObj")
local SurfingCoinObj = BaseClass("SurfingCoinObj", base)
local ROTATE_TIME = 2

function SurfingCoinObj:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  self.isMoving = false
  self.duration = nil
  self.movingTime = nil
  self._showStaticEffect = true
end

function SurfingCoinObj:OnLoadComplete()
  base.OnLoadComplete(self)
  self:UpdateSelfRotate()
end

function SurfingCoinObj:ShowStaticEffect()
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

function SurfingCoinObj:ResetEffectPosition()
  if self.effectParent == nil and self.staticEffectId then
    local p = self.curWorldPos
    self.logic:ResetEffectPosition(self.staticEffectId, p.x, p.y + 0.9, p.z)
  end
end

function SurfingCoinObj:ResetRenderPosition()
  if self.isMoving then
    return
  end
  self.z = self.dataZ + self.logic.renderOffsetZ
  self:SetLocalPosition(Vector3.New(self.x, self.y, self.z))
  self:ResetEffectPosition()
end

function SurfingCoinObj:DestroyData()
  base.DestroyData(self)
  self.isMoving = nil
  self.duration = nil
  self.movingTime = nil
end

function SurfingCoinObj:OnCollide(target)
  local para = {}
  local param1 = self.monsterMeta.para1
  if param1 and 1 < #param1 then
    local goodsId = tonumber(param1[1]) or 0
    para.goodsId = goodsId
    local goodsCount = tonumber(param1[2]) or 0
    goodsCount = goodsCount * self.logic:GetScoreMultiplier()
    para.goodsCount = goodsCount
    EventManager:GetInstance():Broadcast(EventId.OnPVEBattleGetGoods, para)
    self.logic:RecordGoods(SurfingGoodsType.Score, goodsId, goodsCount)
    target:ShowUnitEffect(SurfingUnitEffectType.GotScore)
  end
  base.OnCollide(self, target)
end

function SurfingCoinObj:OnUpdate(deltaTime, viewY)
  base.OnUpdate(self, deltaTime, viewY)
  self:UpdateMoving(deltaTime)
  self:UpdateSelfRotate()
end

function SurfingCoinObj:SetIsAutoMove(isOn, unit)
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

function SurfingCoinObj:UpdateSelfRotate()
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

function SurfingCoinObj:UpdateMoving(deltaTime)
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

function SurfingCoinObj:Death()
  DataCenter.LWSoundManager:PlaySoundByCache(SoundAssetId.SFX_Battle_Surfing_Coin)
  if self.isMoving then
    self.transform:SetParent(nil)
  end
  base.Death(self)
end

return SurfingCoinObj
