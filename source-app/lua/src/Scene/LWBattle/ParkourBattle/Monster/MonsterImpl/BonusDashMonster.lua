local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.MonsterObj")
local Const = require("Scene.LWBattle.Const")
local BonusDashMonster = BaseClass("BonusDashMonster", base)

function BonusDashMonster:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.eulerY = 180
  self.lastViewY = self.mgr.viewY
  self.rushX = self.logic:GetParkourRushX()
  self.valid = true
end

function BonusDashMonster:DestroyView()
  base.DestroyView(self)
  self:ClearTween()
end

function BonusDashMonster:ClearTween()
  if self.tweenFly then
    self.tweenFly:Kill()
    self.tweenFly = nil
  end
  if self.tweenDelay then
    self.tweenDelay:Stop()
    self.tweenDelay = nil
  end
end

function BonusDashMonster:OnLoadComplete()
  base.OnLoadComplete(self)
  self:PlaySimpleAnim(AnimName.Idle)
end

function BonusDashMonster:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.valid then
    local viewY = self.mgr.viewY
    if viewY >= self.y then
      self.valid = false
      self:DieFlyShow()
    end
  end
end

function BonusDashMonster:DieFlyShow()
  local random = Mathf.Random(1, 3)
  self:PlaySimpleAnim("fly" .. random)
  self:ClearTween()
  self.logic:OnBonusDashMonsterDeath(self)
  if self.transform then
    local flyTime = 2
    local dir = self.rushX < self.x and 1 or -1
    local offX = Mathf.Random(11, 15)
    local offY = Mathf.Random(20, 25)
    local dstPos = Vector3.New(self.x + offX * dir, -8, self.y + offY)
    local control = Vector3.New(self.x + offX * dir * 0.3, 10, self.y + offY * 0.35)
    local path = {
      dstPos,
      control,
      control
    }
    self.tweenFly = self.transform:DOPath(path, flyTime, CS.DG.Tweening.PathType.CubicBezier)
    self.tweenDelay = TimerManager:GetInstance():DelayInvoke(function()
      self.tweenDelay = nil
      if not IsNull(self.transform) and self.mgr then
        if self.logic then
          self.logic:ShowEffectObj("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_Common_guanka_luoshui.prefab", dstPos, nil, 3)
        end
        self:Death()
      end
    end, flyTime)
  elseif self.mgr then
    self:Death()
  end
end

function BonusDashMonster:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir)
end

function BonusDashMonster:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir)
end

return BonusDashMonster
