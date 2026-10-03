local DominatorSkillItem = BaseClass("DominatorSkillItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")

function DominatorSkillItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.startPos = -300 * CommonUtil.ArabicAutoMirrorFactor()
end

function DominatorSkillItem:OnDestroy()
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

function DominatorSkillItem:ComponentDefine()
  self.UIHeroSkillItem = self:AddComponent(UIHeroSkillItem, "UIHeroSkillItem")
  self.finish = false
  self.state = 1
end

function DominatorSkillItem:ComponentDestroy()
  self.UIHeroSkillItem = nil
end

function DominatorSkillItem:IsEnterFinish()
  return self.state == 3
end

function DominatorSkillItem:SetData(skill)
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

function DominatorSkillItem:Enter()
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

function DominatorSkillItem:EnterFinish()
  self.state = 3
  if self.holder and self.holder.OnSkillEnterFinish then
    self.holder:OnSkillEnterFinish(self)
  end
end

function DominatorSkillItem:End()
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

function DominatorSkillItem:OnEnd()
  if self.holder and self.holder.OnSkillItemEnd then
    self.holder:OnSkillItemEnd(self)
  end
end

function DominatorSkillItem:MoveUp(value)
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

return DominatorSkillItem
