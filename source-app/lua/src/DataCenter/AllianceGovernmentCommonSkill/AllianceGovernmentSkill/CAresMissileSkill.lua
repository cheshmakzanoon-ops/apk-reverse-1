local IAllianceGovernmentSKill = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentSkill.IAllianceGovernmentSKill")
local UICAresMissileSkillTipItem = require("UI.LWSeasonShared.UIAllianceCommonSkillUseTip.Component.UICAresMissileSkillTipItem")
local base = IAllianceGovernmentSKill
local CAresMissileSkill = BaseClass("CAresMissileSkill", IAllianceGovernmentSKill)

function CAresMissileSkill:PreUse()
  self:ToUseAresMissile()
end

function CAresMissileSkill:ToUseAresMissile()
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
      BuildingUtils.ShowPutAllianceBuild(BuildingTypes.CAMP_SEASON_MISSILE, effect_scope, pointId, PlaceBuildType.Build, nil, nil, curServerId, true)
    end, curServerId, 0)
  else
    UIUtil.ShowTipsId(320242)
  end
end

function CAresMissileSkill:GetCanUseOfficialType()
  return LWAlMemberOffcialType.Deputy_Al_Leader
end

function CAresMissileSkill:GetUseTipInfo()
  return {
    prefab = "Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceSkill/Component/ItemSkill_AresMissileSkill.prefab",
    classPath = UICAresMissileSkillTipItem
  }
end

function CAresMissileSkill:Use()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCommonSkillUseTip, {anim = true}, self, self.data)
end

return CAresMissileSkill
