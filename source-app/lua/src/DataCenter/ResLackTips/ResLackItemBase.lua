local ResLackItemBase = BaseClass("ResLackItemBase")
local Localization = CS.GameEntry.Localization

function ResLackItemBase:__init(configId)
  configId = configId or ""
  self._config = LocalController:instance():getLine(TableName.LW_Res_Lack_Tips, configId)
end

function ResLackItemBase:__delete()
  self._config = nil
end

function ResLackItemBase:GetOrder()
  return tonumber(self._config:getValue("order")) or 1
end

function ResLackItemBase:CheckIsOk(_resType, _needCnt)
end

function ResLackItemBase:TodoAction(SceneID, pos, zoom, time, onComplete)
  if SceneID == SceneManagerSceneID.City then
    GoToUtil.GotoCityPos(pos, zoom, time, onComplete)
  elseif SceneID == SceneManagerSceneID.World then
    GoToUtil.GotoWorldPos(createAction)
  end
end

function ResLackItemBase:GetTips()
  return self._config:getValue("tips") or 0
end

function ResLackItemBase:GetName()
  if self._config == nil then
    return ""
  end
  local name = ""
  if self._config:getValue("tips") == 10 then
    local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(self._config:getValue("para1"))
    if template ~= nil then
      return Localization:GetString(self._config:getValue("name"), Localization:GetString(template.name))
    end
  elseif self._config:getValue("tips") == 2 or self._config:getValue("tips") == 4 then
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self._config:getValue("para1"))
    if template ~= nil then
      return Localization:GetString(self._config:getValue("name"), Localization:GetString(template.name))
    end
  else
    name = self._config:getValue("name") or ""
    return Localization:GetString(name)
  end
end

function ResLackItemBase:GetIcon()
  local pic = self._config:getValue("pic") or ""
  if string.IsNullOrEmpty(pic) then
    return pic
  end
  local tips = self._config:getValue("tips") or 0
  local isBuildIcon = string.startswith(pic, "pic")
  if tips == 2 or tips == 4 or isBuildIcon then
    return string.format(LoadPath.BuildIconOutCity, pic)
  elseif tips == 78 then
    return pic
  end
  return string.format(LoadPath.ResLackIcons, pic)
end

function ResLackItemBase:GetDesc()
  local name = self:GetName()
  local resType = self._config:getValue("res") or 0
  local resName = GetTableData(TableName.Resource, resType, "name")
  resName = Localization:GetString(resName)
  return Localization:GetString("140204", name, resName)
end

function ResLackItemBase:GetGroup()
  if self._config == nil then
    return ""
  end
  local group = self._config:getValue("group") or ""
  return group
end

function ResLackItemBase:GetBtnNameType()
  local tips = self:GetTips()
  if tips == ResLackGoToType.ResourceBagBuy or tips == ResLackGoToType.BuildBuyItem or tips == ResLackGoToType.BuyPveStamina then
    return 2
  else
    return 1
  end
end

function ResLackItemBase:GetId()
  return self._config:getValue("id")
end

function ResLackItemBase:GetTips()
  return self._config:getValue("tips")
end

function ResLackItemBase:GetBtnName()
  return Localization:GetString(self._config:getValue("btn_name"))
end

return ResLackItemBase
