local UIBFBaseSelectUserCtrl = require("UI.BattleFieldBase.SelectUser.Ctrl.UIBFBaseSelectUserCtrl")
local UIBFDsbDuelActSelectUserCtrl = BaseClass("UIBFDsbDuelActSelectUserCtrl", UIBFBaseSelectUserCtrl)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActSelectUserCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelActSelectUserV2)
end

function UIBFDsbDuelActSelectUserCtrl:GetPlayerList()
  return BattlefieldDsbDuelUtils.ActInfo:GetPlayerList()
end

function UIBFDsbDuelActSelectUserCtrl:IsInPrepTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return curTime >= BattlefieldDsbDuelUtils.ActInfo:GetTeamSignUpEndTime()
end

function UIBFDsbDuelActSelectUserCtrl:IsTeamSignUp(teamIdx)
  return BattlefieldDsbDuelUtils.ActInfo:IsTeamSignUp(teamIdx)
end

function UIBFDsbDuelActSelectUserCtrl:IsHadTeam2()
  return BattlefieldDsbDuelUtils.ActInfo:IsTeamSignUp(BattlefieldDsbConst.TeamType.B)
end

function UIBFDsbDuelActSelectUserCtrl:IsUserCanJoin(playerData)
  return true
end

function UIBFDsbDuelActSelectUserCtrl:LoadTeamSprite(img, group)
  BattlefieldDsbDuelUtils.LoadTeamSprite(img, group)
end

function UIBFDsbDuelActSelectUserCtrl:GetPlayerInfoByUID(uid)
  return BattlefieldDsbDuelUtils.ActInfo:GetPlayerInfoByUID(uid)
end

function UIBFDsbDuelActSelectUserCtrl:GetBattleTimeInfo(battlePeriod)
  local battleTimes = BattlefieldDsbDuelUtils.ActInfo:GetBattleTimeInfo()
  if battlePeriod == nil then
    return battleTimes
  else
    return battleTimes[battlePeriod]
  end
end

function UIBFDsbDuelActSelectUserCtrl:GetCurNumByState(playerState, groupIndex)
  return BattlefieldDsbDuelUtils.ActInfo:GetCurNumByStateAndTeam(playerState, groupIndex)
end

function UIBFDsbDuelActSelectUserCtrl:SelectPlayer(uid, state, curTabIdx)
  BattlefieldDsbDuelUtils.ActInfo:SelectPlayer(uid, state, curTabIdx)
end

function UIBFDsbDuelActSelectUserCtrl:CancelPlayer(uid, curTabIdx)
  BattlefieldDsbDuelUtils.ActInfo:CancelPlayer(uid, curTabIdx)
end

function UIBFDsbDuelActSelectUserCtrl:GetTeamBattlePeriod(teamIdx)
  local teamInfo = BattlefieldDsbDuelUtils.ActInfo:GetTeamInfo(teamIdx)
  if teamInfo then
    return teamInfo.battlePeriod
  else
    return 0
  end
end

function UIBFDsbDuelActSelectUserCtrl:GetMemberItemPrefabPath()
  return "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/SelectUser/DsbSelectUserMemberItem.prefab"
end

function UIBFDsbDuelActSelectUserCtrl:GetMemberListPrefabPath()
  return "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/SelectUser/DsbSelectUserMemberList.prefab"
end

function UIBFDsbDuelActSelectUserCtrl:GetTopBarPrefabPath()
  return "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/SelectUser/DsbSelectUserTopbar.prefab"
end

function UIBFDsbDuelActSelectUserCtrl:GetTitleContentPrefabPath()
  return "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/SelectUser/DsbSelectUserTitleContent.prefab"
end

function UIBFDsbDuelActSelectUserCtrl:GetBattlefieldType()
  return BattleFieldType.DsbDuel
end

function UIBFDsbDuelActSelectUserCtrl:GetFilterBattleTimeItemClass()
  return require("UI.BFDsbDuel.BFDsbDuelActSelectUser.Component.UIBFDsbDuelActFilterBattleTimeItem")
end

function UIBFDsbDuelActSelectUserCtrl:GetSelectUserInfoClass()
  return require("UI.BFDsbDuel.BFDsbDuelActSelectUser.Component.UIBFDsbDuelActSelectUserInfo")
end

function UIBFDsbDuelActSelectUserCtrl:GetSelectUserItemClass()
  return require("UI.BFDsbDuel.BFDsbDuelActSelectUser.Component.UIBFDsbDuelActSelectUserItem")
end

function UIBFDsbDuelActSelectUserCtrl:GetSelectUserTitleClass()
  return require("UI.BFDsbDuel.BFDsbDuelActSelectUser.Component.UIBFDsbDuelActSelectUserTitle")
end

function UIBFDsbDuelActSelectUserCtrl:GetSelectUserTopBarClass()
  return require("UI.BFDsbDuel.BFDsbDuelActSelectUser.Component.UIBFDsbDuelActSelectUserTopBar")
end

return UIBFDsbDuelActSelectUserCtrl
