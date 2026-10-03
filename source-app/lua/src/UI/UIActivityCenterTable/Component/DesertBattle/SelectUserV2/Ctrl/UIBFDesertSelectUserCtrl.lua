local UIBFBaseSelectUserCtrl = require("UI.BattleFieldBase.SelectUser.Ctrl.UIBFBaseSelectUserCtrl")
local UIBFDesertSelectUserCtrl = BaseClass("UIBFDesertSelectUserCtrl", UIBFBaseSelectUserCtrl)
local Localization = CS.GameEntry.Localization

function UIBFDesertSelectUserCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertSelectUserV2)
end

function UIBFDesertSelectUserCtrl:GetPlayerList()
  return DataCenter.ActDragonManager:GetPlayerList()
end

function UIBFDesertSelectUserCtrl:IsInPrepTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local actInfo = DataCenter.ActDragonManager:GetActInfo()
  return curTime >= actInfo.stopSignUpTime
end

function UIBFDesertSelectUserCtrl:IsTeamSignUp(teamIdx)
  local dragonInfo = DataCenter.ActDragonManager:GetGroup(teamIdx)
  local signUp = dragonInfo ~= nil and dragonInfo.signUp or DataCenter.ActDragonManager.SignUpState.NoSignUp
  return signUp == DataCenter.ActDragonManager.SignUpState.SignUp
end

function UIBFDesertSelectUserCtrl:IsHadTeam2()
  local actInfo = DataCenter.ActDragonManager:GetActInfo()
  return actInfo ~= nil and actInfo.hadTeam2 ~= 0
end

function UIBFDesertSelectUserCtrl:IsUserCanJoin(playerData)
  return true
end

function UIBFDesertSelectUserCtrl:LoadTeamSprite(img, group)
  DataCenter.ActDragonManager:LoadTeamSprite(img, group)
end

function UIBFDesertSelectUserCtrl:GetPlayerInfoByUID(uid)
  return DataCenter.ActDragonManager:GetPlayerInfoByUID(uid)
end

function UIBFDesertSelectUserCtrl:GetBattleTimeInfo(battlePeriod)
  local ret
  if battlePeriod then
    ret = DataCenter.ActDragonManager:GetBattleTimeInfoByBattlePeriod(battlePeriod)
  else
    ret = DataCenter.ActDragonManager:GetBattleTimeInfo()
  end
  if ret == nil then
    DataCenter.ActDragonManager:SendGetBattleTime()
  end
  return ret
end

function UIBFDesertSelectUserCtrl:GetCurNumByState(playerState, groupIndex)
  return DataCenter.ActDragonManager:GetCurNumByState(playerState, groupIndex)
end

function UIBFDesertSelectUserCtrl:SelectPlayer(uid, state, curTabIdx)
  DataCenter.ActDragonManager:SelectPlayer(uid, state, curTabIdx)
end

function UIBFDesertSelectUserCtrl:CancelPlayer(uid, curTabIdx)
  DataCenter.ActDragonManager:CancelPlayer(uid, curTabIdx)
end

function UIBFDesertSelectUserCtrl:GetTeamBattlePeriod(teamIdx)
  local teamInfo = DataCenter.ActDragonManager:GetGroup(teamIdx)
  if teamInfo then
    return teamInfo.battlePeriod
  else
    return 0
  end
end

function UIBFDesertSelectUserCtrl:GetTopBarPrefabPath()
  return "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/SelectUser/DesertSelectUserTopbar.prefab"
end

function UIBFDesertSelectUserCtrl:GetMemberItemPrefabPath()
  return "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/SelectUser/DesertSelectUserMemberItem.prefab"
end

function UIBFDesertSelectUserCtrl:GetMemberListPrefabPath()
  return "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/SelectUser/DesertSelectUserMemberList.prefab"
end

function UIBFDesertSelectUserCtrl:GetTitleContentPrefabPath()
  return "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/SelectUser/DesertSelectUserTitleContent.prefab"
end

function UIBFDesertSelectUserCtrl:GetBattlefieldType()
  return BattleFieldType.Desert
end

function UIBFDesertSelectUserCtrl:GetFilterBattleTimeItemClass()
  return require("UI.UIActivityCenterTable.Component.DesertBattle.SelectUserV2.Component.UIBFDesertFilterBattleTimeItem")
end

function UIBFDesertSelectUserCtrl:GetSelectUserInfoClass()
  return require("UI.UIActivityCenterTable.Component.DesertBattle.SelectUserV2.Component.UIBFDesertSelectUserInfo")
end

function UIBFDesertSelectUserCtrl:GetSelectUserItemClass()
  return require("UI.UIActivityCenterTable.Component.DesertBattle.SelectUserV2.Component.UIBFDesertSelectUserItem")
end

function UIBFDesertSelectUserCtrl:GetSelectUserTitleClass()
  return require("UI.UIActivityCenterTable.Component.DesertBattle.SelectUserV2.Component.UIBFDesertSelectUserTitle")
end

function UIBFDesertSelectUserCtrl:GetSelectUserTopBarClass()
  return require("UI.UIActivityCenterTable.Component.DesertBattle.SelectUserV2.Component.UIBFDesertSelectUserTopBar")
end

function UIBFDesertSelectUserCtrl:GetCurCommanderNum(curTabIdx)
  return DataCenter.ActDragonManager:GetCurCommanderNum(curTabIdx)
end

function UIBFDesertSelectUserCtrl:SendCommanderModify(uid, group, isSet)
  DataCenter.ActDragonManager:SendCommanderModify(uid, group, isSet)
end

function UIBFDesertSelectUserCtrl:IsCommander(userInfo)
  return userInfo and userInfo.commander
end

return UIBFDesertSelectUserCtrl
