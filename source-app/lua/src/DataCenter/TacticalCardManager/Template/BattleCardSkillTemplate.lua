local BattleCardSkillTemplate = BaseClass("BattleCardSkillTemplate")
local Localization = CS.GameEntry.Localization

function BattleCardSkillTemplate:__init()
  self.id = 0
  self.active = 0
  self.trigger_type = 0
  self.trigger_para = 0
  self.use_position = ""
  self.march_place = {}
  self.active_special_effect = ""
  self.ui_special_effect = ""
  self.position_scale = ""
  self.cd_type = 0
  self.cd_time = 0
  self.cd_max_times = 0
  self.effect = 0
  self.effect_para1 = {}
  self.effect_para2 = ""
  self.effect_para3 = ""
  self.name = ""
  self.icon = ""
  self.desc = ""
  self.group = 0
  self.lv = 0
  self.max_lv = 0
  self.battlefield = 0
  self.view_para = ""
  self.view_attr = ""
  self.ui_special_effect_color = ""
end

function BattleCardSkillTemplate:__delete()
  self.id = nil
  self.active = nil
  self.trigger_type = nil
  self.trigger_para = nil
  self.use_position = nil
  self.march_place = nil
  self.active_special_effect = nil
  self.ui_special_effect = nil
  self.position_scale = nil
  self.cd_type = nil
  self.cd_time = nil
  self.cd_max_times = nil
  self.effect = nil
  self.effect_para1 = nil
  self.effect_para2 = nil
  self.effect_para3 = nil
  self.name = nil
  self.icon = nil
  self.desc = nil
  self.group = nil
  self.lv = nil
  self.max_lv = nil
  self.battlefield = nil
  self.view_para = nil
  self.view_attr = nil
  self.ui_special_effect_color = nil
  self.use_positionDic = nil
end

local function GetFormattedValue(type, val)
  if type == 1 then
    return tostring(val)
  elseif type == 2 then
    return string.format("%.2f%%", val * 100)
  end
end

function BattleCardSkillTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.active = rowData:getValue("active") or 0
  self.trigger_type = rowData:getValue("trigger_type") or 0
  self.trigger_para = rowData:getValue("trigger_para") or 0
  self.use_position = rowData:getValue("use_position") or ""
  self.march_place = rowData:getValue("march_place") or {}
  self.active_special_effect = rowData:getValue("active_special_effect") or ""
  self.ui_special_effect = rowData:getValue("ui_special_effect") or ""
  self.position_scale = rowData:getValue("position_scale") or ""
  self.cd_type = rowData:getValue("cd_type") or 0
  self.cd_time = rowData:getValue("cd_time") or 0
  self.cd_max_times = rowData:getValue("cd_max_times") or 0
  self.effect = rowData:getValue("effect") or 0
  self.effect_para1 = rowData:getValue("effect_para1") or {}
  self.effect_para2 = rowData:getValue("effect_para2") or ""
  self.effect_para3 = rowData:getValue("effect_para3") or ""
  self.name = rowData:getValue("name") or ""
  self.icon = rowData:getValue("icon") or ""
  self.desc = rowData:getValue("desc") or ""
  self.group = rowData:getValue("group") or 0
  self.lv = rowData:getValue("lv") or 0
  self.max_lv = rowData:getValue("max_lv") or 0
  self.battlefield = rowData:getValue("battlefield") or 0
  self.view_para = rowData:getValue("view_para") or ""
  self.view_attr = rowData:getValue("view_attr") or ""
  self.ui_special_effect_color = rowData:getValue("ui_special_effect_color") or ""
  self.use_positionDic = {}
  if not string.IsNullOrEmpty(self.use_position) then
    local use_position = string.split(self.use_position, "|")
    for _, v in ipairs(use_position) do
      self.use_positionDic[tonumber(v)] = true
    end
  end
  local viewParaArray = {}
  for _, item in pairs(string.split(self.view_para, "|")) do
    local splits = string.split(item, ";")
    local type = tonumber(splits[2] or 0)
    local val = tonumber(splits[1] or 0)
    table.insert(viewParaArray, {
      type = type,
      val = GetFormattedValue(type, val)
    })
  end
  self.viewParaArray = viewParaArray
  local viewAttrArray = {}
  for _, item in pairs(string.split(self.view_attr, "|")) do
    local splits = string.split(item, ";")
    local type = tonumber(splits[2] or 0)
    local val = tonumber(splits[1] or 0)
    table.insert(viewAttrArray, {
      type = type,
      val = GetFormattedValue(type, val)
    })
  end
  self.viewAttrArray = viewAttrArray
end

function BattleCardSkillTemplate:IsMaxLv()
  return self.lv >= self.max_lv
end

local DEFAULT_COLOR_STR = "#099b4a"
local DEFAULT_HYPER_TEXT_COLOR = "#c47920"

function BattleCardSkillTemplate:GetDesc(paraColorStr, hyperTextColor)
  local resultStr = ""
  local colorStr = paraColorStr
  colorStr = colorStr or DEFAULT_COLOR_STR
  local hyperTextColorStr = hyperTextColor
  hyperTextColorStr = hyperTextColorStr or DEFAULT_HYPER_TEXT_COLOR
  if not table.IsNullOrEmpty(self.viewParaArray) then
    local paras = {}
    local cdPara = self:GetCDViewPara()
    if cdPara then
      table.insert(paras, cdPara)
    end
    local count = 2
    for k, v in pairs(self.viewParaArray) do
      local value = v.val
      paras[count] = value
      count = count + 1
    end
    for index, para in pairs(paras) do
      paras[index] = string.format("<color=%s>%s</color>", colorStr, para)
    end
    resultStr = Localization:GetString(self.desc, SafeUnpack(paras))
  else
    resultStr = Localization:GetString(self.desc)
  end
  return HeroUtils.ProcessHyperText(resultStr, hyperTextColorStr)
end

function BattleCardSkillTemplate:GetUpgradeDesc(nextLvId, paraColorStr, hyperTextColor)
  if self:IsMaxLv() then
    return self:GetDesc()
  end
  local nextLvSkillId = nextLvId
  local nextLvSkillTemplate = DataCenter.TacticalCardDataManager:GetSkillTemplateData(nextLvSkillId)
  if not nextLvSkillTemplate then
    return self:GetDesc()
  end
  local resultStr = ""
  local colorStr = paraColorStr
  colorStr = colorStr or DEFAULT_COLOR_STR
  local hyperTextColorStr = hyperTextColor
  hyperTextColorStr = hyperTextColorStr or DEFAULT_HYPER_TEXT_COLOR
  if not table.IsNullOrEmpty(self.viewParaArray) then
    local paras = {}
    local cdPara = self:GetCDViewPara()
    if cdPara then
      table.insert(paras, cdPara)
    end
    local count = 2
    local nextLvParas = nextLvSkillTemplate.viewParaArray
    for k, v in pairs(self.viewParaArray) do
      local value = v.val
      local formattedValue = value
      local nextLvFormattedValue = nextLvParas[k].val
      local valueChanged = formattedValue ~= nextLvFormattedValue
      if valueChanged then
        formattedValue = CommonUtil.IsArabic() and string.format("%s (%s<-)", formattedValue, nextLvFormattedValue) or string.format("%s (->%s)", formattedValue, nextLvFormattedValue)
      end
      paras[count] = formattedValue
      count = count + 1
    end
    for index, para in pairs(paras) do
      paras[index] = string.format("<color=%s>%s</color>", colorStr, para)
    end
    resultStr = Localization:GetString(self.desc, SafeUnpack(paras))
  else
    resultStr = Localization:GetString(self.desc)
  end
  return HeroUtils.ProcessHyperText(resultStr, hyperTextColorStr)
end

function BattleCardSkillTemplate:GetCDDesc()
  local resultStr = ""
  if self.cd_type == 0 then
    resultStr = ""
  elseif self.cd_type == 1 then
    resultStr = Localization:GetString("battle_card_cd_type1")
  elseif self.cd_type == 2 then
    resultStr = Localization:GetString("battle_card_cd_type2")
  end
  return resultStr
end

function BattleCardSkillTemplate:GetCDViewPara()
  local para = ""
  if self.cd_type == 0 then
    para = ""
  elseif self.cd_type == 1 then
    para = UITimeManager:GetInstance():SecondToFmtString(self.cd_time)
  elseif self.cd_type == 2 then
    para = self.cd_max_times
  end
  return para
end

function BattleCardSkillTemplate:IsActive()
  return self.active == 1
end

function BattleCardSkillTemplate:GetFormattedViewAttr()
  local resultStr = ""
  if not table.IsNullOrEmpty(self.viewAttrArray) then
    local value = self.viewAttrArray[1].val
    local formattedValue = value
    return formattedValue
  end
  return resultStr
end

function BattleCardSkillTemplate:GetIcon()
  return string.format(LoadPath.TacticalCardSkillPath, self.icon)
end

return BattleCardSkillTemplate
