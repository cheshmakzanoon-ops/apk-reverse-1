local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_HeroStationSkill = BaseClass("ResLackItem_HeroStationSkill", ResLackItemBase)

function ResLackItem_HeroStationSkill:CheckIsOk(_resType, _needCnt)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  if DataCenter.HeroStationManager:Enabled() then
    local stationId = DataCenter.HeroStationManager:GetStationIdByBuildId(BuildingTypes.FUN_BUILD_MAIN)
    if stationId ~= nil then
      local skillId = DataCenter.HeroStationManager:GetStationFirstUsableSkillId(stationId)
      if skillId == 1000 then
        return true
      end
    end
  end
  return false
end

function ResLackItem_HeroStationSkill:TodoAction()
  GoToUtil.CloseAllWindows()
  local bubbleObj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.HeroStationSkill, BuildingTypes.FUN_BUILD_MAIN)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)
  if list ~= nil and table.count(list) > 0 then
    for k, v in pairs(list) do
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v.uuid)
      local worldPointPos = SceneUtils.TileIndexToWorld(buildData.pointId)
      GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        if bubbleObj then
          WorldArrowManager:GetInstance():ShowArrowEffect(0, bubbleObj.transform.position, ArrowType.Building)
        end
      end)
    end
  end
end

return ResLackItem_HeroStationSkill
