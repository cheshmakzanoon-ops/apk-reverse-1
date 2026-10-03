local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.ColliderMonsterBase")
local ColliderMonster = BaseClass("ColliderMonster", base)
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")

function ColliderMonster:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.useHpText = monsterMeta.is_hp_text == 1
  self.bloodDirty = false
end

function ColliderMonster:OnLoadComplete()
  base.OnLoadComplete(self)
  if self.useHpText then
    pveUnitViewUtil.InitHpText(self.viewHandle, math.ceil(self.curBlood))
  elseif self.monsterMeta.hp_bar_num > 0 then
    if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
      pveUnitViewUtil.CreateHpBarListWithHandleRequest(self, self.viewHandle, self.monsterMeta.hp_bar_height * 1.0, nil, self.curBlood, self.maxBlood, nil, ParkourHpBarType.Enemy)
    else
      self.hpBarHandle = pveUnitViewUtil.CreateEnemyHpBarWithHandle(self.viewHandle, self.monsterMeta.hp_bar_height * 1.0, nil, self.curBlood, self.maxBlood, nil)
    end
  end
end

function ColliderMonster:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.useHpText and self.bloodDirty then
    self.bloodDirty = false
    pveUnitViewUtil.SetNumberHpText(self.viewHandle, math.ceil(self.curBlood))
  end
end

function ColliderMonster:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir)
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, dir)
  if self.useHpText then
    if hurt ~= 0 then
      self.bloodDirty = true
    end
  elseif 0 < self.curBlood and self.hpBarHandle then
    pveUnitViewUtil.SetHpBar(self.hpBarHandle, self.curBlood, self.maxBlood, self:GetShieldValue())
  end
end

function ColliderMonster:DestroyView()
  if self.useHpText then
    pveUnitViewUtil.NumberHpTextActive(self.viewHandle, false)
  end
  base.DestroyView(self)
  if self.hpBarHandle then
    pveUnitViewUtil.DestroyHpBar(self.hpBarHandle)
    self.hpBarHandle = nil
  end
  self.useHpText = nil
  self.bloodDirty = nil
end

function ColliderMonster:AfterCreateHpBarList(viewHandle)
  self.hpBarHandle = viewHandle
end

return ColliderMonster
