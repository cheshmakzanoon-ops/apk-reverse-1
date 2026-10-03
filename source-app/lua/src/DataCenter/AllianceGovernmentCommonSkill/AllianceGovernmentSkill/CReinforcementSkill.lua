local IAllianceGovernmentSKill = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentSkill.IAllianceGovernmentSKill")
local UICReinforcementSkillTipItem = require("UI.LWSeasonShared.UIAllianceCommonSkillUseTip.Component.UICReinforcementSkillTipItem")
local base = IAllianceGovernmentSKill
local CReinforcementSkill = BaseClass("CReinforcementSkill", IAllianceGovernmentSKill)

function CReinforcementSkill:PreUse()
  local cfg = self.data.config
  if cfg then
    local curServerId = LuaEntry.Player:GetCurServerId()
    local _, _, srcSame, _ = SeasonUtil.InSeasonBigMapMode(curServerId)
    if not srcSame then
      UIUtil.ShowTipsId("season_s6_government_skill_error_tips06")
      return
    end
    GoToUtil.CloseAllWindows()
    local effect_scope = 7
    if SceneUtils.GetIsInWorld() then
      local pointId = SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget)
      BuildingUtils.ShowPutAllianceBuild(BuildingTypes.CAMP_Reinforcement, effect_scope, pointId, PlaceBuildType.Build, nil, nil, curServerId, true)
    else
      do
        local pointId = LuaEntry.Player:GetMainWorldPos()
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), TeslaCoilSkillCameraHeight, 0.02, function()
          BuildingUtils.ShowPutAllianceBuild(BuildingTypes.CAMP_Reinforcement, effect_scope, pointId, PlaceBuildType.Build, nil, nil, curServerId, true)
        end, curServerId, 0)
      end
    end
  else
    UIUtil.ShowTipsId(320242)
  end
end

function CReinforcementSkill:GetCanUseOfficialType()
  return LWAlMemberOffcialType.Al_Goddess
end

function CReinforcementSkill:GetUseTipInfo()
  return {
    prefab = "Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceSkill/Component/ItemSkill_Reinforcement.prefab",
    classPath = UICReinforcementSkillTipItem
  }
end

function CReinforcementSkill:Use()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCommonSkillUseTip, {anim = true}, self, self.data)
end

return CReinforcementSkill
