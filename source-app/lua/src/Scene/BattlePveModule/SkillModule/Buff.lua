local Buff = BaseClass("Buff")

function Buff:__init()
  self.m_startRoundIdx = 0
  self.m_lastRoundCnt = 0
end

function Buff:SetData(buffItem)
  self.m_actionItem = buffItem:GetActionItem()
  self.m_startRoundIdx = buffItem:GetStartRoundIndex()
  self.m_lastRoundCnt = buffItem:GetLastTimes()
end

function Buff:DoAction()
  self.m_lastRoundCnt = self.m_lastRoundCnt - 1
  self:DoAction_Show()
  self:DoAction_Effect()
  if self.m_lastRoundCnt < 0 then
    self:RemoveBuff()
  end
end

function Buff:DoAction_Show()
end

function Buff:DoAction_Effect()
  if self.m_actionItem ~= nil then
    PveActorMgr:GetInstance():PlaySkillWithActionItem(self.m_actionItem)
  end
end

function Buff:RemoveBuff()
end

return Buff
