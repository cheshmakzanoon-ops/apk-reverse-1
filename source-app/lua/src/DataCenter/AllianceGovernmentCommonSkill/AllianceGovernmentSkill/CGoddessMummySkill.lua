local IAllianceGovernmentSKill = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentSkill.IAllianceGovernmentSKill")
local UICGoddessMummySkillTipItem = require("UI.LWSeasonShared.UIAllianceCommonSkillUseTip.Component.UICGoddessMummySkillTipItem")
local base = IAllianceGovernmentSKill
local CGoddessMummySkill = BaseClass("CGoddessMummySkill", IAllianceGovernmentSKill)

function CGoddessMummySkill:PreUse()
  self:ToUseAresMissile()
end

function CGoddessMummySkill:ToUseAresMissile()
  local cfg = self.data.config
  if cfg then
    local curServerId = LuaEntry.Player:GetSelfServerId()
    local isBigMapMode, curSame, srcSame, loginSame = SeasonUtil.InSeasonBigMapMode(curServerId)
    local pointId = LuaEntry.Player:GetMainWorldPos()
    if not srcSame then
      UIUtil.ShowTipsId("season_s6_government_skill_error_tips06")
      return
    end
    local effect_scope = cfg.effect_scope or 18
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), 500, 0.02, function()
      BuildingUtils.ShowPutAllianceBuild(BuildingTypes.CAMP_GODDESS_MUMMY_TARGET, effect_scope, pointId, PlaceBuildType.Build, nil, nil, curServerId, true)
    end, curServerId, 0)
  else
    UIUtil.ShowTipsId(320242)
  end
end

function CGoddessMummySkill:GetCanUseOfficialType()
  return LWAlMemberOffcialType.War_Commander
end

function CGoddessMummySkill:GetUseTipInfo()
  return {
    prefab = "Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceSkill/Component/ItemSkill_GoddessMummySkill.prefab",
    classPath = UICGoddessMummySkillTipItem
  }
end

function CGoddessMummySkill:Use()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCommonSkillUseTip, {anim = true}, self, self.data)
end

return CGoddessMummySkill
