local _CLASS = {}

function _CLASS:CanShowEnter()
  local remainTime = self:GetInBattleWorldLeftTime()
  return 0 < remainTime
end

function _CLASS:CanGotoMap(group)
  local ec = self:BaseCheckActivityOpen(EnumActivity.ActWinterStorm.Type)
  if ec then
    return ec
  end
  if self:GetInBattleWorldLeftTime() <= 0 then
    return 500018
  end
  if BattleFieldUtil.InSceneStopEnterMap() then
    return "winter_s0_tips_17"
  end
  if LuaEntry.Player:IsInBlackRange(true) or LuaEntry.Player:IsInCityField(true) then
    return 458138
  end
end

function _CLASS:LocalCheckCanEnterBattlefield(group)
  if BattleFieldUtil.InSceneStopEnterMap(true) then
    return
  end
  local msgKey = self:CanGotoMap()
  if msgKey ~= nil then
    UIUtil.ShowTipsId(msgKey)
    return false
  end
  return true
end

function _CLASS:SendEnterBattleMessage(group, pointId)
  BattleFieldUtil.testJump = false
  BattleFieldUtil.prePointId = pointId
  SFSNetwork.SendMessage(MsgDefines.WinterStormEnter)
end

function _CLASS:ServerCheckCanEnterBattlefield(msg)
  EventManager:GetInstance():Broadcast(EventId.WinterStormInfoRefresh)
  if BattleFieldUtil.InSceneStopEnterMap(true) then
    return
  end
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
  local actInfo = self:GetActInfo()
  if actInfo then
    SFSNetwork.SendMessage(MsgDefines.WinterStormOrderList)
  end
end

return _CLASS
