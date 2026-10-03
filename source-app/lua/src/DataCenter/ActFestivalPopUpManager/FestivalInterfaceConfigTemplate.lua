local FestivalInterfaceConfigTemplate = BaseClass("FestivalInterfaceConfigTemplate")

function FestivalInterfaceConfigTemplate:__init()
  self.id = 0
  self.borad_range_config = ""
  self.boradRangeDic = {}
end

function FestivalInterfaceConfigTemplate:__delete()
  self.id = nil
  self.borad_range_config = nil
  self.boradRangeDic = nil
end

function FestivalInterfaceConfigTemplate:UpdateData(rowData)
  if not rowData then
    Logger.LogError("rowData is nil")
    return
  end
  self.id = rowData:getValue("id") or 0
  self.borad_range_config = rowData:getValue("borad_range_config") or ""
  local strList = string.split(self.borad_range_config, ",")
  for i = 1, #strList do
    self:AddSecondPopUpPanelList(strList[i])
  end
end

function FestivalInterfaceConfigTemplate:AddSecondPopUpPanelList(str)
  if string.IsNullOrEmpty(str) then
    return
  end
  local idAndNameListStr = string.split(str, "|")
  local id = tonumber(idAndNameListStr[1])
  local nameListStr = idAndNameListStr[2]
  if id then
    local nameList = string.split(nameListStr, ";")
    for _, v in pairs(nameList) do
      local nameConfig = string.split(v, "#")
      local name = nameConfig[1]
      local ifShowEffect = nameConfig[2] or 1
      local ifShowBottomNode = nameConfig[3] or 1
      if not self.boradRangeDic[id] then
        self.boradRangeDic[id] = {}
      end
      table.insert(self.boradRangeDic[id], {
        name = name,
        ifShowEffect = ifShowEffect,
        ifShowBottomNode = ifShowBottomNode
      })
    end
  end
end

function FestivalInterfaceConfigTemplate:CheckActFestivalUseNewSkin(activityId, uiWindowNames)
  local id = tonumber(activityId)
  if self.boradRangeDic[id] == nil then
    return false
  end
  local nameList = self.boradRangeDic[id]
  for _, nameConfig in ipairs(nameList) do
    if uiWindowNames == nameConfig.name then
      return true
    end
  end
  return false
end

function FestivalInterfaceConfigTemplate:CheckLoadEffect(activityId, uiWindowNames)
  local id = tonumber(activityId)
  if self.boradRangeDic[id] == nil then
    return false
  end
  local nameList = self.boradRangeDic[id]
  for _, nameConfig in ipairs(nameList) do
    if uiWindowNames == nameConfig.name then
      if not nameConfig.ifShowEffect then
        return false
      end
      return tonumber(nameConfig.ifShowEffect) == 1
    end
  end
  return false
end

function FestivalInterfaceConfigTemplate:CheckShowBottomNode(activityId, uiWindowNames)
  local id = tonumber(activityId)
  if self.boradRangeDic[id] == nil then
    return false
  end
  local nameList = self.boradRangeDic[id]
  for _, nameConfig in ipairs(nameList) do
    if uiWindowNames == nameConfig.name then
      if not nameConfig.ifShowBottomNode then
        return false
      end
      return tonumber(nameConfig.ifShowBottomNode) == 1
    end
  end
  return false
end

return FestivalInterfaceConfigTemplate
