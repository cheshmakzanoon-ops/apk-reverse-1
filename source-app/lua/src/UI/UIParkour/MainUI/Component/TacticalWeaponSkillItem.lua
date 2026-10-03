local TacticalWeaponSkillItem = BaseClass("TacticalWeaponSkillItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")

function TacticalWeaponSkillItem:OnCreate(isMirror)
  base.OnCreate(self)
  self:ComponentDefine()
  if isMirror == nil then
    self.isMirror = false
  else
    self.isMirror = isMirror
  end
  if not self.isMirror then
    self.startPos = -300
  else
    self.startPos = 300
  end
end

function TacticalWeaponSkillItem:OnDestroy()
  if not IsNull(self.timer) then
    self.timer:Stop()
    self.timer = nil
  end
  if not IsNull(self.enterTween) then
    self.enterTween:Kill()
    self.enterTween = nil
  end
  if not IsNull(self.tween) then
    self.tween:Kill()
    self.tween = nil
  end
  if not IsNull(self.endTween) then
    self.endTween:Kill()
    self.endTween = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TacticalWeaponSkillItem:ComponentDefine()
  self.UIHeroSkillItem = self:AddComponent(UIHeroSkillItem, "UIHeroSkillItem")
  self.finish = false
  self.state = 1
end

function TacticalWeaponSkillItem:ComponentDestroy()
  self.UIHeroSkillItem = nil
end

function TacticalWeaponSkillItem:IsEnterFinish()
  return self.state == 3
end

function TacticalWeaponSkillItem:SetData(skill)
  if self.finish then
    return
  end
  self.UIHeroSkillItem:SetData(skill, {
    showSkillName = false,
    showSkillLevel = false,
    showLock = false,
    showRedPoint = false,
    showStar = true
  })
  self.UIHeroSkillItem.rectTransform:Set_anchoredPosition(self.startPos, 0)
  self.state = 1
end

function TacticalWeaponSkillItem:Enter()
  if not IsNull(self.enterTween) then
    self.enterTween:Kill()
    self.enterTween = nil
  end
  self.state = 2
  self.enterTween = self.UIHeroSkillItem.rectTransform:DOAnchorPosX(0, 0.3):OnComplete(function()
    self.enterTween = nil
    self:EnterFinish()
  end)
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    self:End()
  end, 2.3)
end

function TacticalWeaponSkillItem:EnterFinish()
  self.state = 3
  if self.holder and self.holder.OnSkillEnterFinish then
    self.holder:OnSkillEnterFinish(self)
  end
end

function TacticalWeaponSkillItem:End()
  if self.finish then
    return
  end
  self.finish = true
  if not IsNull(self.endTween) then
    self.endTween:Kill()
    self.endTween = nil
  end
  self.endTween = self.UIHeroSkillItem.rectTransform:DOAnchorPosX(self.startPos, 0.3):OnComplete(function()
    self.endTween = nil
    self:OnEnd()
  end)
end

function TacticalWeaponSkillItem:OnEnd()
  if self.holder and self.holder.OnSkillItemEnd then
    self.holder:OnSkillItemEnd(self)
  end
end

function TacticalWeaponSkillItem:MoveUp(value)
  if self.finish then
    return
  end
  if not IsNull(self.tween) then
    self.tween:Kill()
    self.tween = nil
  end
  self.tween = self.rectTransform:DOAnchorPosY(value, 0.3):OnComplete(function()
    self.tween = nil
  end)
end

return TacticalWeaponSkillItem
