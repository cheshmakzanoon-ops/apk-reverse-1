local IAllianceGovernmentSKill = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentSkill.IAllianceGovernmentSKill")
local UICTeslaCoilSkillTipItem = require("UI.LWSeasonShared.UIAllianceCommonSkillUseTip.Component.UICTeslaCoilSkillTipItem")
local base = IAllianceGovernmentSKill
local CTeslaCoilSkill = BaseClass("CTeslaCoilSkill", IAllianceGovernmentSKill)

function CTeslaCoilSkill:PreUse()
  self:ToUseTeslaCoil()
end

function CTeslaCoilSkill:ToUseTeslaCoil()
  local cfg = self.data.config
  if BattleFieldUtil.InBattleField() then
    UIUtil.ShowTipsId(320242)
    return
  end
  if cfg then
    local curServerId = LuaEntry.Player:GetSelfServerId()
    local isBigMapMode, curSame, srcSame, loginSame = SeasonUtil.InSeasonBigMapMode(curServerId)
    local pointId = LuaEntry.Player:GetMainWorldPos()
    if not srcSame then
      UIUtil.ShowTipsId("season_s6_government_skill_error_tips06")
      return
    end
    local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), MoveCityCameraHeight, 0.02, function()
      local theWorld = CS.SceneManager.World
      local city = theWorld:GetWorldBuildingByUuid(mainBuild.uuid)
      if city ~= nil then
        city:SetMoveState(true)
      end
      local mainBuildModelPath = BuildingUtils.GetWorldBuildingModelName(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
      local pointId = SceneUtils.WorldToTileIndex(theWorld.CurTarget)
      local param = {
        allianceFakeBuildId = BuildingTypes.CAMP_TeslaCoil,
        allianceSkillId = self.data.config.id,
        allianceSkillFlag = self.data.config.skill_flag,
        serverId = curServerId
      }
      if theWorld == nil then
        UIUtil.ShowTipsId(320242)
        return
      end
      theWorld:UICreateBuildingModelPath(BuildingTypes.FUN_BUILD_MAIN, mainBuild.uuid, pointId, PlaceBuildType.AllianceSkill, mainBuildModelPath, nil, param)
    end, curServerId, 0)
  else
    UIUtil.ShowTipsId(320242)
  end
end

function CTeslaCoilSkill:GetCanUseOfficialType()
  return LWAlMemberOffcialType.Al_Ambassadoe
end

function CTeslaCoilSkill:GetUseTipInfo()
  return {
    prefab = "Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceSkill/Component/ItemSkill_TeslaCoilSkill.prefab",
    classPath = UICTeslaCoilSkillTipItem
  }
end

function CTeslaCoilSkill:Use()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCommonSkillUseTip, {anim = true}, self, self.data)
end

return CTeslaCoilSkill
