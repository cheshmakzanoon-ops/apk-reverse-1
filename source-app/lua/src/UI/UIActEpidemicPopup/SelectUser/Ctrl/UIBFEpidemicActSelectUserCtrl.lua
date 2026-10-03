local UIBFBaseSelectUserCtrl = require("UI.BattleFieldBase.SelectUser.Ctrl.UIBFBaseSelectUserCtrl")
local UIBFEpidemicActSelectUserCtrl = BaseClass("UIBFEpidemicActSelectUserCtrl", UIBFBaseSelectUserCtrl)
local Localization = CS.GameEntry.Localization

function UIBFEpidemicActSelectUserCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEpidemicSelectUserViewV2)
end

function UIBFEpidemicActSelectUserCtrl:GetPlayerList()
  return ActEpidemicUtils.GetAllPlayers()
end

function UIBFEpidemicActSelectUserCtrl:IsInPrepTime()
  local actInfo = ActEpidemicUtils.GetActInfo()
  return actInfo ~= nil and not actInfo:CanAssignPlayer()
end

function UIBFEpidemicActSelectUserCtrl:IsTeamSignUp(teamIdx)
  local teamState
  if teamIdx == ActEpidemicUtils.Group1 then
    teamState = ActEpidemicUtils.GetTeamAState()
  elseif teamIdx == ActEpidemicUtils.Group2 then
    teamState = ActEpidemicUtils.GetTeamBState()
  end
  return teamState ~= EpidemicZoneSignState.StateSignNone and teamState ~= EpidemicZoneSignState.StateBan
end

function UIBFEpidemicActSelectUserCtrl:IsHadTeam2()
  local actInfo = ActEpidemicUtils.GetActInfo()
  return actInfo ~= nil and actInfo.hadTeam2 ~= 0
end

function UIBFEpidemicActSelectUserCtrl:IsUserCanJoin(playerData)
  return true
end

function UIBFEpidemicActSelectUserCtrl:LoadTeamSprite(img, group)
  ActEpidemicUtils.LoadTeamSprite(img, group)
end

function UIBFEpidemicActSelectUserCtrl:GetPlayerInfoByUID(uid)
  return ActEpidemicUtils.GetPlayerByUid(uid)
end

function UIBFEpidemicActSelectUserCtrl:GetBattleTimeInfo(battlePeriod)
  local actInfo = ActEpidemicUtils.GetActInfo()
  local battleTimes = actInfo and actInfo.battleTimes or {}
  if battlePeriod == nil then
    return battleTimes
  else
    return battleTimes[battlePeriod]
  end
end

function UIBFEpidemicActSelectUserCtrl:GetCurNumByState(playerState, groupIndex)
  return DataCenter.ActEpidemicZoneManager:GetCurNumByState(playerState, groupIndex)
end

function UIBFEpidemicActSelectUserCtrl:SelectPlayer(uid, state, curTabIdx)
  DataCenter.ActEpidemicZoneManager:RequestActivityAssign(curTabIdx, uid, state)
end

function UIBFEpidemicActSelectUserCtrl:CancelPlayer(uid, curTabIdx)
  DataCenter.ActEpidemicZoneManager:RequestActivityAssign(curTabIdx, uid, 0)
end

function UIBFEpidemicActSelectUserCtrl:GetTeamBattlePeriod(teamIdx)
  local teamInfo = ActEpidemicUtils.GetGroup(teamIdx)
  if teamInfo then
    return teamInfo.battlePeriod
  else
    return 0
  end
end

function UIBFEpidemicActSelectUserCtrl:GetMemberItemPrefabPath()
  return "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIBFEpidemicSelectUserMemberItem.prefab"
end

function UIBFEpidemicActSelectUserCtrl:GetMemberListPrefabPath()
  return "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIBFEpidemicSelectUserMemberList.prefab"
end

function UIBFEpidemicActSelectUserCtrl:GetTopBarPrefabPath()
  return "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIBFEpidemicSelectUserTopbar.prefab"
end

function UIBFEpidemicActSelectUserCtrl:GetTitleContentPrefabPath()
  return "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIBFEpidemicSelectUserTitleContent.prefab"
end

function UIBFEpidemicActSelectUserCtrl:GetBattlefieldType()
  return BattleFieldType.EpidemicZone
end

function UIBFEpidemicActSelectUserCtrl:GetFilterBattleTimeItemClass()
  return require("UI.UIActEpidemicPopup.SelectUser.Component.UIBFEpidemicActFilterBattleTimeItem")
end

function UIBFEpidemicActSelectUserCtrl:GetSelectUserInfoClass()
  return require("UI.UIActEpidemicPopup.SelectUser.Component.UIBFEpidemicActSelectUserInfo")
end

function UIBFEpidemicActSelectUserCtrl:GetSelectUserItemClass()
  return require("UI.UIActEpidemicPopup.SelectUser.Component.UIBFEpidemicActSelectUserItem")
end

function UIBFEpidemicActSelectUserCtrl:GetSelectUserTitleClass()
  return require("UI.UIActEpidemicPopup.SelectUser.Component.UIBFEpidemicActSelectUserTitle")
end

function UIBFEpidemicActSelectUserCtrl:GetSelectUserTopBarClass()
  return require("UI.UIActEpidemicPopup.SelectUser.Component.UIBFEpidemicActSelectUserTopBar")
end

function UIBFEpidemicActSelectUserCtrl:GetCurCommanderNum(curTabIdx)
  return DataCenter.ActEpidemicZoneManager:GetCommanderNum(curTabIdx)
end

function UIBFEpidemicActSelectUserCtrl:SendCommanderModify(uid, group, isSet)
  DataCenter.ActEpidemicZoneManager:ReqCommanderOpt(group, isSet, uid)
end

function UIBFEpidemicActSelectUserCtrl:IsCommander(userInfo)
  return DataCenter.ActEpidemicZoneManager:IsCommander(userInfo.uid, userInfo.group)
end

return UIBFEpidemicActSelectUserCtrl
