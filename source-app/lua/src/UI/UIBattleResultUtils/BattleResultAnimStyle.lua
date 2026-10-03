local BattleResultAnimStyle = BaseClass("BattleResultAnimStyle")
local DELAY_SEC = 0.04
local START_DELAY_SEC = 0.3

function BattleResultAnimStyle:__init()
  self.itemDelayTimers = {}
  self.itemDelayTime = 0
end

function BattleResultAnimStyle:__delete()
  self:ClearAllDelayTimers()
end

function BattleResultAnimStyle:AddItemNewDelayActiveTimer(itemName, itemCmp)
  local timer = self.itemDelayTimers[itemName]
  if timer then
    return
  end
  self.itemDelayTime = self.itemDelayTime + DELAY_SEC
  self:SetAlpha(itemCmp, 0)
  timer = TimerManager:GetInstance():DelayInvoke(function()
    self:SetAlpha(itemCmp, 1)
    self:PlayMoveInAnim(itemCmp)
    self:PlayMoveInEffect(itemCmp)
  end, self.itemDelayTime + START_DELAY_SEC)
  self.itemDelayTimers[itemName] = timer
end

function BattleResultAnimStyle:StopItemDelayActiveTimer(itemName, itemCmp)
  if not self.itemDelayTimers then
    return
  end
  local timer = self.itemDelayTimers[itemName]
  if not timer then
    return
  end
  timer:Stop()
  self:PlayIdleAnim(itemCmp)
  self:SetAlpha(itemCmp, 1)
  self.itemDelayTimers[itemName] = nil
end

function BattleResultAnimStyle:ClearAllDelayTimers()
  self.itemDelayTime = nil
  if self.itemDelayTimers then
    for i, v in pairs(self.itemDelayTimers) do
      v:Stop()
    end
    self.itemDelayTimers = nil
  end
end

function BattleResultAnimStyle:SetAlpha(itemCmp, value)
  if itemCmp.__cname == "UICommonResItem" then
    itemCmp:SetRewardAlpha(value)
  else
    itemCmp:SetRootAlpha(value)
  end
end

function BattleResultAnimStyle:PlayMoveInAnim(itemCmp)
  if itemCmp.__cname == "UICommonResItem" then
    itemCmp:PlayAnimator("Eff_ui_icon_chuxian_tongyong_new")
  else
    itemCmp:RewindPlayRootAnimation("MoveIn")
  end
end

function BattleResultAnimStyle:PlayIdleAnim(itemCmp)
  if itemCmp.__cname == "UICommonResItem" then
    itemCmp:PlayAnimator("Eff_ui_icon_chuxian_tongyong_idle")
  else
    itemCmp:StopRootAnimation()
  end
end

function BattleResultAnimStyle:PlayMoveInEffect(itemCmp)
  if itemCmp.__cname == "UICommonResItem" then
    itemCmp:SetRewardEffect()
  end
end

return BattleResultAnimStyle
