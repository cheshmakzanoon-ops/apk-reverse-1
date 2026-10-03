local Localization = CS.GameEntry.Localization
local BattlefieldDsbDuelUtils = {}

function BattlefieldDsbDuelUtils.Log(fmt, ...)
  if not CommonUtil.IsDebug() then
    return
  end
  local _ = string.format(fmt, ...)
  _ = string.format("<color=#FFFF00>[DSB]%s</color>", _)
  Logger.Log(_)
end

function BattlefieldDsbDuelUtils.LogError(fmt, ...)
  local _ = string.format(fmt, ...)
  _ = "[DSB][Error]" .. _
  Logger.LogError(_)
end

function BattlefieldDsbDuelUtils.GetColorByRoleType(role, replaceMyColor)
  if not role then
    return
  end
  if replaceMyColor and role == BattlefieldDsbDuelUtils.GetMyRoleId() then
    return BattlefieldDsbDuelUtils.GetMyColor()
  end
  return BattlefieldDsbConst.Colors[role]
end

function BattlefieldDsbDuelUtils.GetMyColor()
  return BattlefieldDsbConst.Colors[BattlefieldDsbConst.RoleType.Mine]
end

function BattlefieldDsbDuelUtils.GetColorByAllianceId(allianceId, replaceMyColor)
  local roleId = BattlefieldDsbDuelUtils.GetRoleIdByAllianceId(allianceId)
  return BattlefieldDsbDuelUtils.GetColorByRoleType(roleId, replaceMyColor)
end

function BattlefieldDsbDuelUtils.GetAllianceAbbr(abbr)
  return string.format("[%s]", abbr)
end

function BattlefieldDsbDuelUtils.DebugEnterBattle(roleType)
  DataCenter.BattlefieldDsbDuelManager:TryEnterBattlefield(roleType)
end

function BattlefieldDsbDuelUtils.GetRoleIdByAllianceId(allianceId)
  local battleInfo = DataCenter.BattlefieldDsbDuelManager:GetBattleInfo()
  if not battleInfo then
    return 0
  end
  return battleInfo:GetRoleIDByAllianceID(allianceId)
end

function BattlefieldDsbDuelUtils.GetAllianceIdByRoleId(roleId)
  local battleInfo = DataCenter.BattlefieldDsbDuelManager:GetBattleInfo()
  if not battleInfo then
    return
  end
  return battleInfo:GetAllianceIdByRoleId(roleId)
end

function BattlefieldDsbDuelUtils.GetRole(roleId)
  local battleInfo = DataCenter.BattlefieldDsbDuelManager:GetBattleInfo()
  if not battleInfo then
    return
  end
  return battleInfo:GetRole(roleId)
end

function BattlefieldDsbDuelUtils.GetCurrentTeam()
  local battleInfo = DataCenter.BattlefieldDsbDuelManager:GetBattleInfo()
  if battleInfo then
    return battleInfo:GetTeam()
  end
  return BattlefieldDsbConst.TeamType.None
end

function BattlefieldDsbDuelUtils.GetMyRoleId()
  return BattlefieldDsbDuelUtils.GetRoleIdByAllianceId(LuaEntry.Player:GetAllianceUid())
end

function BattlefieldDsbDuelUtils.GetBattlefieldBuildingColorIndexByRole(role)
  if role == BattlefieldDsbDuelUtils.GetMyRoleId() then
    return 1
  elseif role == 1 then
    return 2
  elseif role == 2 then
    return 3
  elseif role == 3 then
    return 4
  elseif role == 4 then
    return 5
  else
    return 0
  end
end

function BattlefieldDsbDuelUtils.GetBattlefieldBuildingLabelColorIdByAlliance(allianceId)
  local role = BattlefieldDsbDuelUtils.GetRoleIdByAllianceId(allianceId)
  if role == BattlefieldDsbDuelUtils.GetMyRoleId() then
    return CityLabelColorType.BattlefieldDsbRoleMine
  elseif role == BattlefieldDsbConst.RoleType.A then
    return CityLabelColorType.BattlefieldDsbRole1
  elseif role == BattlefieldDsbConst.RoleType.B then
    return CityLabelColorType.BattlefieldDsbRole2
  elseif role == BattlefieldDsbConst.RoleType.C then
    return CityLabelColorType.BattlefieldDsbRole3
  elseif role == BattlefieldDsbConst.RoleType.D then
    return CityLabelColorType.BattlefieldDsbRole4
  else
    return CityLabelColorType.White
  end
end

function BattlefieldDsbDuelUtils.TryGetSelfBattleRoomId()
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if not battleInfo then
    return
  end
  local myRole = battleInfo:GetMyRole()
  if not myRole then
    return
  end
  local teamId = battleInfo:GetTeam()
  if teamId == BattlefieldDsbConst.TeamType.A or teamId == BattlefieldDsbConst.TeamType.B then
    return string.format("%s%s%s_%s_%s", ChatInterface.GetRoomIdPrefix(), ChatInterface.getDragonGroupType(true), myRole.allianceId, teamId, BattleFieldType.DsbDuel)
  end
end

local getters = {}

function getters.ActInfo()
  return DataCenter.BattlefieldDsbDuelManager:GetActInfo()
end

function getters.BattleInfo()
  return DataCenter.BattlefieldDsbDuelManager:GetBattleInfo()
end

function getters.MyInfo()
  return DataCenter.BattlefieldDsbDuelManager:GetMyInfo()
end

function getters.ActTemplateInfo()
  return DataCenter.BattlefieldDsbDuelTemplateManager:GetActTemplateInfo()
end

function getters.BattleTemplateInfo()
  return DataCenter.BattlefieldDsbDuelTemplateManager:GetBattleTemplateInfo()
end

function getters.Mgr()
  return DataCenter.BattlefieldDsbDuelManager
end

setmetatable(BattlefieldDsbDuelUtils, {
  __index = function(t, k)
    if getters[k] then
      return getters[k]()
    end
    return nil
  end
})

function BattlefieldDsbDuelUtils.Description()
  return DataCenter.BattlefieldDsbDuelManager:Description()
end

function BattlefieldDsbDuelUtils.GetGroupLetter(idx)
  if idx == 0 then
    return Localization:GetString("151110")
  end
  if 5 < idx or idx < 0 then
    return ""
  end
  return Localization:GetString("dsb_duel_interface_101" .. idx + 3)
end

function BattlefieldDsbDuelUtils.LoadTeamSprite(image, curIdx)
  local teamStr = curIdx == 1 and "A" or "B"
  image:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldDesertPath, "lrb_shamofengbao_" .. teamStr), function()
    if IsNotNull(image) then
      image:SetNativeSize()
    end
  end)
end

function BattlefieldDsbDuelUtils.ShowWinningTipsParams(pos, params)
  do return end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlefieldSimpleWinningTipsView, {anim = true}, {
    pos = pos,
    title = params.title,
    width = params.width or 170,
    offset = params.offset or Vector2.zero,
    name_0 = params.name0,
    name_1 = params.name1,
    val_0 = params.point0 or 0,
    val_1 = params.point1 or 0,
    icon_0 = params.icon0,
    icon_1 = params.icon1,
    vertical = params.vertical or BattlefieldTipsVertical.Auto
  })
end

function BattlefieldDsbDuelUtils.GetMyAllianceRankInBattle()
  local myInfo = DataCenter.BattlefieldDsbDuelManager:GetMyInfo()
  if not myInfo then
    return 0
  end
  local allianceInfo = myInfo.allianceInfo
  if allianceInfo then
    return allianceInfo.rank
  end
  return 0
end

function BattlefieldDsbDuelUtils.GetMyPointsInBattle()
  local myInfo = DataCenter.BattlefieldDsbDuelManager:GetMyInfo()
  if not myInfo then
    return 0
  end
  return myInfo.selfScore.score
end

function BattlefieldDsbDuelUtils.GetMyTeam()
  local myInfo = DataCenter.BattlefieldDsbDuelManager:GetMyInfo()
  if not myInfo then
    return BattlefieldDsbConst.TeamType.None
  end
  return myInfo.selfTeamId
end

function BattlefieldDsbDuelUtils.GetEmptyRoles(teamId)
  local actInfo = DataCenter.BattlefieldDsbDuelManager:GetActInfo()
  if not actInfo then
    return 0
  end
  if teamId == BattlefieldDsbConst.TeamType.A then
    return actInfo.teamAEmptyCount
  elseif teamId == BattlefieldDsbConst.TeamType.B then
    return actInfo.teamBEmptyCount
  end
  return 0
end

function BattlefieldDsbDuelUtils.GetEnterBattleState()
  local info = DataCenter.BattlefieldDsbDuelManager:GetActInfo()
  if not info then
    return BattlefieldDsbConst.EnterBattleState.None
  end
  return info:GetEnterBattleState()
end

function BattlefieldDsbDuelUtils.FakeEmptyRoles(tab)
  local myAlliance = LuaEntry.Player:GetAllianceUid()
  local count = 1
  for i = #tab, 1, -1 do
    local v = tab[i]
    if v.allianceId ~= myAlliance and 0 < count then
      table.remove(tab, i)
      count = count - 1
    end
  end
end

return BattlefieldDsbDuelUtils
