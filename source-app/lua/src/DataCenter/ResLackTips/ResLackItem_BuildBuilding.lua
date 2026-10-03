local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_BuildBuilding = BaseClass("ResLackItem_BuildBuilding", ResLackItemBase)
local Localization = CS.GameEntry.Localization

function ResLackItem_BuildBuilding:CheckIsOk(_resType, _needCnt)
  local buildId = self._config:getValue("para1")
  if string.IsNullOrEmpty(buildId) then
    return false
  end
  self.buildId = tonumber(buildId)
  return self:GetBuildState(self.buildId)
end

function ResLackItem_BuildBuilding:GetName()
  if self._config == nil then
    return ""
  end
  local name = self._config:getValue("name") or ""
  local buildName = ""
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
  if template ~= nil then
    buildName = Localization:GetString(template.name)
  end
  return Localization:GetString(name, buildName)
end

function ResLackItem_BuildBuilding:TodoAction()
  SceneUtils.ChangeToCity(function()
    GoToUtil.CloseAllWindows()
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
    if template ~= nil and template.build_type == BuildType.Second then
      local num = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(template.sup_main_build_id)
      if num <= 0 then
        self.buildId = template.sup_main_build_id
        local mainTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
        if mainTemplate ~= nil then
          UIUtil.ShowTips(Localization:GetString(GameDialogDefine.NEED_FIRST_BUILD, Localization:GetString(mainTemplate.name)))
        end
      end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildList, self.buildId, true)
  end)
end

function ResLackItem_BuildBuilding:GetBuildState(buildId)
  local buildNum = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(buildId)
  local maxNum = DataCenter.BuildManager:GetMaxBuildNum(buildId)
  local curMaxNum = DataCenter.BuildManager:GetCurMaxBuildNum(buildId)
  if buildNum >= maxNum then
    return false
  end
  if buildNum >= curMaxNum then
    return false
  end
  local list = DataCenter.BuildManager:GetFoldUpBuildByBuildId(buildId)
  if list ~= nil and table.count(list) > 0 then
    return true
  end
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    return buildTemplate:IsPreBuildConditionValid()
  end
  return false
end

return ResLackItem_BuildBuilding
