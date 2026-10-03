local DecorationBuildingUpgradeTemplate = BaseClass("DecorationBuildingUpgradeTemplate")

function DecorationBuildingUpgradeTemplate:__init()
  self.id = nil
  self.group = nil
  self.level = nil
  self.progressIndex = nil
  self.para_gain = nil
  self.stage_gain = nil
  self.stage_need = nil
  self.cost_item = nil
  self.stage_icon = nil
  self.basePropInfo = {}
  self.starPropInfo = {}
end

function DecorationBuildingUpgradeTemplate:__delete()
  self.id = nil
  self.group = nil
  self.level = nil
  self.progressIndex = nil
  self.para_gain = nil
  self.stage_gain = nil
  self.stage_need = nil
  self.cost_item = nil
  self.stage_icon = nil
  self.basePropInfo = nil
  self.starPropInfo = nil
end

function DecorationBuildingUpgradeTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = toInt(rowData:getValue("group")) or 0
  self.level = toInt(rowData:getValue("level")) or 0
  self.progressIndex = toInt(rowData:getValue("progress")) or ""
  self.para_gain = rowData:getValue("para_gain") or ""
  self.stage_gain = rowData:getValue("stage_gain") or ""
  self.stage_need = toInt(rowData:getValue("stage_need")) or ""
  self.cost_item = toInt(rowData:getValue("cost_item")) or 0
  self.stage_icon = rowData:getValue("stage_icon") or ""
  local baseEff = string.split(self.para_gain, "|")
  for _, v in ipairs(baseEff) do
    local info = string.split(v, ";")
    if #info == 2 then
      local effId = toInt(info[1])
      local effVal = tonumber(info[2])
      if table.containsKey(self.basePropInfo, effId) then
        self.basePropInfo[effId] = self.basePropInfo[effId] + effVal
      else
        self.basePropInfo[effId] = effVal
      end
    end
  end
  local starEff = string.split(self.stage_gain, "|")
  for _, v in pairs(starEff) do
    local info = string.split(v, ";")
    if #info == 2 then
      local effId = toInt(info[1])
      local effVal = tonumber(info[2])
      if table.containsKey(self.starPropInfo, effId) then
        self.starPropInfo[effId] = self.starPropInfo[effId] + effVal
      else
        self.starPropInfo[effId] = effVal
      end
    end
  end
end

function DecorationBuildingUpgradeTemplate:GetStarEffectInfo()
end

function DecorationBuildingUpgradeTemplate:GetBaseEffectFromProgress(targetProgress)
  local ret = {}
  for effId, baseEffVal in pairs(self.basePropInfo) do
    if not table.containsKey(ret, effId) then
      ret[effId] = baseEffVal * targetProgress
    else
      ret[effId] = ret[effId] + baseEffVal * targetProgress
    end
  end
  return ret
end

function DecorationBuildingUpgradeTemplate:GetEffectFromStarByProgress(targetProgress)
  if targetProgress < self.stage_need then
    local prevProgress = self.progressIndex - 1
    if 0 < prevProgress then
      local prevData = DataCenter.DecorationUpgradeTemplateManager:GetProgressInfo(self.group, self.level, prevProgress)
      if prevData then
        return prevData:GetEffectFromStar()
      end
    end
    return {}
  end
  return self:GetEffectFromStar()
end

function DecorationBuildingUpgradeTemplate:GetEffectFromStar()
  local ret = {}
  for effId, effVal in pairs(self.starPropInfo) do
    if not table.containsKey(ret, effId) then
      ret[effId] = effVal
    else
      ret[effId] = ret[effId] + effVal
    end
  end
  return ret
end

return DecorationBuildingUpgradeTemplate
