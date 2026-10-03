local ActionItem = require("DataCenter.MailData.MailDetailModule.MailDetailActionItem")
local BuffItem = BaseClass("BuffItem")
local BuffState = {
  Wait = 1,
  Enter = 2,
  On = 3,
  OFF = 4
}

function BuffItem:InitData(effectdata, userlist)
  local baseReport = effectdata.baseReport or {}
  local actionItem = ActionItem.New()
  actionItem:InitData(baseReport, userlist)
  self._actionItem = actionItem
  self._startRIndex = self._actionItem:GetRoundIndex() or 0
  self._lastTimes = effectdata.time or 0
end

function BuffItem:IsActive(curRoundIdx)
  if curRoundIdx < self._startRIndex then
    return BuffState.Wait
  elseif curRoundIdx == self._startRIndex then
    return BuffState.Enter
  elseif curRoundIdx - self._startRIndex > self._lastTimes then
    return BuffState.OFF
  else
    return BuffState.On
  end
end

function BuffItem:GetTargetTriggerIndex()
  return self._actionItem:GetTriggerIndex()
end

function BuffItem:GetStartRoundIndex()
  return self._startRIndex
end

function BuffItem:GetLastTimes()
  return self._lastTimes
end

function BuffItem:GetActionItem()
  return self._actionItem
end

function BuffItem:GetDesc()
  return self._actionItem:GetDesc()
end

local BuffMgr = {}

function BuffMgr:InitData()
  if self._buffList == nil then
    self._buffList = {}
  end
end

function BuffMgr:ClearData()
  self._buffList = {}
end

function BuffMgr:AddBuffItem(buffItem, userlist)
  self:InitData()
  local item = BuffItem.New()
  item:InitData(buffItem, userlist)
  self._buffList[#self._buffList + 1] = item
end

function BuffMgr:GetBuffListByRoundIndex(roundIdx)
  local activeBuffList = {}
  if self._buffList == nil then
    return activeBuffList
  end
  for i = 1, table.count(self._buffList) do
    local buffItem = self._buffList[i]
    if buffItem ~= nil then
      local _buffState = buffItem:IsActive(roundIdx)
      if _buffState == BuffState.Enter or _buffState == BuffState.On then
        activeBuffList[#activeBuffList + 1] = buffItem
      elseif _buffState == BuffState.OFF then
        self._buffList[i] = nil
      end
    end
  end
  return activeBuffList
end

return BuffMgr
