local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerBase")
local TriggerGoodsAlwaysGet = BaseClass("TriggerGoodsAlwaysGet", base)
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")

function TriggerGoodsAlwaysGet:Init(logic, mgr, guid, x, y, monsterMeta, triggerItemMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.triggerMeta = triggerItemMeta
  self.countdownTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:OnCountdownEnd()
  end, 1)
end

function TriggerGoodsAlwaysGet:DestroyView()
  base.DestroyView(self)
  if self.deathTimer then
    self.deathTimer:Stop()
    self.deathTimer = nil
  end
  if self.countdownTimer then
    self.countdownTimer:Stop()
    self.countdownTimer = nil
  end
  self.animator = nil
end

function TriggerGoodsAlwaysGet:InitView()
  self.gameObject.name = "TriggerGoodsAlwaysGet" .. self.guid
  self.animator = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
end

function TriggerGoodsAlwaysGet:OnCountdownEnd()
  DataCenter.LWBattleManager.logic.triggerEventMgr:Trigger(TriggerEnum.EventType.GetGoods, self.triggerMeta, Vector3.New(self.x, 6, self.y))
  self:ShowDissolveEffect()
  if self.animator then
    self.animator:Play("Eff_beizengmen_jinbi_xiaoshi_01", 0, 0)
  end
  self.deathTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:Death()
  end, 1)
end

return TriggerGoodsAlwaysGet
