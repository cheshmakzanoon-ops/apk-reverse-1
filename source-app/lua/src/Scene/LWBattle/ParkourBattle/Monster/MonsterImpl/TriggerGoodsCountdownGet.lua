local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerBase")
local TriggerGoodsCountdownGet = BaseClass("TriggerGoodsCountdownGet", base)
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")

function TriggerGoodsCountdownGet:Init(logic, mgr, guid, x, y, monsterMeta, triggerItemMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.triggerMeta = triggerItemMeta
  self.delay = 0
  if self.triggerMeta then
    local spl = string.split(self.triggerMeta.para, "|")
    self.delay = tonumber(spl[3]) / 1000 or 0
  end
  if self.delay <= 0 then
    self:OnCountdownEnd()
  else
    self.countdownTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:OnCountdownEnd()
    end, self.delay)
  end
end

function TriggerGoodsCountdownGet:DestroyView()
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

function TriggerGoodsCountdownGet:InitView()
  self.gameObject.name = "TriggerGoodsCountdownGet" .. self.guid
  self.animator = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
end

function TriggerGoodsCountdownGet:UpdateReversePos(deltaTime)
end

function TriggerGoodsCountdownGet:OnCountdownEnd()
  self:ShowDissolveEffect()
  if self.animator then
    self.animator:Play("Eff_beizengmen_jinbi_xiaoshi_01", 0, 0)
  end
  DataCenter.LWBattleManager.logic.triggerEventMgr:Trigger(TriggerEnum.EventType.GetGoods, self.triggerMeta, Vector3.New(self.x, 6, self.y))
  self.deathTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:Death()
  end, 0.3)
end

return TriggerGoodsCountdownGet
