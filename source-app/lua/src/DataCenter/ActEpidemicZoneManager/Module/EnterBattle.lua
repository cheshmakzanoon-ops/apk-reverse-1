local _CLASS = {}
local Localization = CS.GameEntry.Localization

function _CLASS:CanShowEnter()
  local actInfo = self:GetActInfo()
  if actInfo == nil then
    return false
  end
  if actInfo.selfGroup == 0 or actInfo.selfAssigned == EpidemicZonePlayerState.None then
    return false
  end
  if not self:BattleStartCheck(actInfo.selfGroup) then
    return false
  end
  return self:TodayEnterBattleWorld()
end

function _CLASS:CanGotoMap(group)
  local ec = self:BaseCheckActivityOpen(EnumActivity.ActEpidemic.Type)
  if ec ~= nil then
    return ec
  end
  local watchIdx = group or BattleFieldUtil.ObserveIdx()
  if watchIdx == 0 and 0 < self:GetLeaveCDLeft() then
    return "YiBianJinQu_errorcode_10"
  end
  local ec2 = self:BaseCheckAlliance()
  if ec2 then
    return ec2
  end
  local actInfo = self:GetActInfo()
  if actInfo == nil then
    return 458153
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
  if groupInfo.state ~= 1 and groupInfo.state ~= 4 then
    return 458141
  end
  if watchIdx == 0 and actInfo.selfAssigned == EpidemicZonePlayerState.None then
    return 458137
  end
  local stage = self:FixStage(groupInfo.group)
  if stage == EpidemicZoneStage.Prepare then
    if watchIdx == 0 and actInfo.selfAssigned == EpidemicZonePlayerState.Sub then
      return 458145
    end
  elseif stage == EpidemicZoneStage.Battle then
  elseif stage == EpidemicZoneStage.Show then
    return "Desert_strom_tips1025"
  else
    return 458153
  end
end

function _CLASS:LocalCheckCanEnterBattlefield(group)
  local actInfo = self:GetActInfo()
  if not actInfo then
    return false
  end
  local teamIndex = group or 0
  if teamIndex == 0 then
    local commonCheck = BattleFieldUtil.CheckCanEnterBattlefield(BattleFieldType.EpidemicZone)
    if not commonCheck then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertJumpTo, {anim = true}, BattleFieldType.EpidemicZone)
      return false
    end
  end
  local cdTime = self:GetLeaveCDLeft()
  if teamIndex == 0 and 0 < cdTime then
    UIUtil.ShowTips(Localization:GetString("YiBianJinQu_battle_tips_5", cdTime))
    return false
  end
  local errorCode = self:CanGotoMap(group)
  if errorCode then
    UIUtil.ShowTipsId(errorCode)
    return false
  end
  local stage = self:FixStage(teamIndex)
  if stage == EpidemicZoneStage.Prepare then
    if teamIndex == 0 and actInfo.selfAssigned == EpidemicZonePlayerState.Sub then
      UIUtil.ShowTipsId(458145)
      return false
    end
  elseif stage == EpidemicZoneStage.Battle then
  elseif stage == EpidemicZoneStage.Show then
    UIUtil.ShowTipsId("Desert_strom_tips1025")
    return false
  end
  return true
end

function _CLASS:SendEnterBattleMessage(group, pointId)
  local teamIndex = self:BaseBeforeSendEnter(group, pointId)
  if teamIndex == 0 then
    teamIndex = self:GetMyGroupIdx()
    if teamIndex ~= 0 then
      SFSNetwork.SendMessage(MsgDefines.EpidemicZoneEnterBattle, teamIndex)
    end
  else
    SFSNetwork.SendMessage(MsgDefines.EpidemicZoneWatchBattle, teamIndex)
  end
end

function _CLASS:BeforeEnterBattlefield(msg, bWatch)
  if not bWatch then
    self.battleInfo:ParseData(msg)
  end
end

function _CLASS:AfterEnterBattlefield(bWatch)
  local groupIdx = self:GetCurGroupIdx()
  if groupIdx == 0 then
    return
  end
  local actInfo = self:GetActInfo()
  if actInfo then
    actInfo:FetchAllianceMemberData(groupIdx)
    self:ReqCommanderList(groupIdx)
    if not BattleFieldUtil.isObserve then
      self:ReqBattleFreeSpeedInfo()
    end
    SFSNetwork.SendMessage(MsgDefines.EpidemicZoneCommanderOrderList, groupIdx)
  end
end

return _CLASS
