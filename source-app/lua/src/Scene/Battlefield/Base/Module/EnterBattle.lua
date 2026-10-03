local _CLASS = {}

function _CLASS:CanShowEnter()
  return false
end

function _CLASS:CanGotoMap(group)
end

function _CLASS:LocalCheckCanEnterBattlefield(group)
  return false, {}
end

function _CLASS:BaseLocalCheckCanEnterBattlefield(group)
  local tmpIdx = group or 0
  if self.CanGotoMap then
    local errorCode = self:CanGotoMap(group)
    if errorCode then
      UIUtil.ShowTipsId(errorCode)
      return false
    end
  end
  if tmpIdx == 0 and self.bfType ~= nil then
    local commonCheck = BattleFieldUtil.CheckCanEnterBattlefield(self.bfType)
    if not commonCheck then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertJumpTo, {anim = true}, self.bfType)
      return false
    end
  end
  return true
end

function _CLASS:BaseBeforeSendEnter(group, pointId)
  BattleFieldUtil.testJump = false
  local teamIndex = group or 0
  if teamIndex == 0 then
    BattleFieldUtil.preWatchIdx = nil
  else
    BattleFieldUtil.preWatchIdx = teamIndex
  end
  BattleFieldUtil.prePointId = pointId or nil
  return teamIndex
end

function _CLASS:SendEnterBattleMessage(group, pointId)
end

function _CLASS:ServerCheckCanEnterBattlefield(msg)
  local errCode = msg.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return false
  end
  return true
end

function _CLASS:BeforeEnterBattlefield(msg, bWatch)
end

function _CLASS:AfterEnterBattlefield(bWatch)
end

return _CLASS
