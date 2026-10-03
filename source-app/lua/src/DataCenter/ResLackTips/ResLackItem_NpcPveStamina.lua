local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_NpcPveStamina = BaseClass("ResLackItem_NpcPveStamina", ResLackItemBase)

function ResLackItem_NpcPveStamina:CheckIsOk(_resType, _needCnt)
  return true
end

function ResLackItem_NpcPveStamina:TodoAction()
  local buildId = tonumber(self._config:getValue("para1"))
  if CS.SceneManager.IsInPVE() then
    DataCenter.BattleLevel:Exit(function()
      GoToUtil.GotoCityByBuildId(buildId)
    end)
  else
    GoToUtil.GotoCityByBuildId(buildId)
  end
end

return ResLackItem_NpcPveStamina
