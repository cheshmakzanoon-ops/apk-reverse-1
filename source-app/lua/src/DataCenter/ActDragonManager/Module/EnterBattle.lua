local _CLASS = {}

function _CLASS:CanShowEnter(ignoreEnter, groupIdx)
  local canShow = false
  if LuaEntry.Player:IsInAlliance() and self:InDragonBattleTime(groupIdx) and self.actInfo then
    local groupInfo = groupIdx == nil and self:GetMyGroup() or self:GetGroup(groupIdx)
    if groupInfo and groupInfo:IsInMatch() then
      if ignoreEnter then
        canShow = true
      else
        canShow = self:TodayEnterDragonWorld() and not self:TodayLeaveDragonWorld()
      end
    end
  end
  return canShow
end

function _CLASS:CanGotoMap(group)
  local ec = self:BaseCheckActivityOpen(EnumActivity.ActDragon.Type)
  if ec then
    return ec
  end
  local watchIdx = group or BattleFieldUtil.ObserveIdx()
  if watchIdx == 0 and self:TodayLeaveDragonWorld() then
    return 458143
  end
  local ec2 = self:BaseCheckAlliance()
  if ec2 then
    return ec2
  end
  local groupInfo
  if watchIdx ~= 0 then
    groupInfo = self:GetGroup(watchIdx)
  else
    groupInfo = self:GetCurGroup()
  end
  if not groupInfo then
    return 458153
  end
  if not self:InDragonBattleTime(groupInfo.group) then
    return "Desert_strom_tips1025"
  end
  if groupInfo.signUp ~= self.SignUpState.SignUp then
    return 458141
  end
  if watchIdx == 0 and groupInfo.assigned == 0 then
    return 458137
  end
  if groupInfo.timeInfo ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime <= groupInfo.timeInfo.prepTime then
      return 458153
    end
    if watchIdx == 0 and groupInfo.assigned == 2 and curTime < groupInfo.timeInfo.battleOpenTime then
      return 458145
    end
  else
    return 458153
  end
end

function _CLASS:LocalCheckCanEnterBattlefield(group)
  return self:BaseLocalCheckCanEnterBattlefield(group)
end

function _CLASS:SendEnterBattleMessage(group, pointId)
  local teamIndex = self:BaseBeforeSendEnter(group, pointId)
  if teamIndex == 0 then
    SFSNetwork.SendMessage(MsgDefines.EnterDragonWorld)
  else
    local groupInfo = self:GetGroup(teamIndex)
    if groupInfo then
      SFSNetwork.SendMessage(MsgDefines.DragonBattleWatchCheck, groupInfo.battleServerId, groupInfo.worldId, teamIndex)
    end
  end
end

function _CLASS:BeforeEnterBattlefield(msg, bWatch)
  if bWatch then
    local group = self:GetGroup(BattleFieldUtil.watchIdx)
    if group == nil then
      return
    end
    msg.server = group.battleServerId
    msg.world = group.worldId
  end
  self:HandleBuildTopMarch(msg)
end

function _CLASS:AfterEnterBattlefield(bWatch)
  self:SendCommanderList()
  self:SendCommandOrderList()
end

return _CLASS
