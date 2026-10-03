local DecorationTemplate = BaseClass("DecorationTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.type = 0
  self.name = ""
  self.wearEffect = {}
  self.ownEffect = {}
  self.gainMethod = {}
  self.quality = 0
  self.order = 0
  self.icon = ""
  self.hot = 0
  self.titlePosOffset = 0
  self.titleSizeAdd = 0
  self.showGroup = 0
  self.appearance = 0
  self.customVariable = ""
  self.isShow = 1
  self.serverid = {}
  self.inner_server = {}
  self.show_condition = {}
  self.callback_skill_id = 0
  self.skill_id_list = {}
  self.act_mod_open = 0
  self.randMin = 0
  self.randMax = 0
  self.season = 0
  self.special_image = ""
  self.goto_buy = 0
  self.rt_config = ""
  self.if_vip = 0
end

local function __delete(self)
  self.id = 0
  self.type = 0
  self.name = ""
  self.wearEffect = {}
  self.ownEffect = {}
  self.quality = 0
  self.order = 0
  self.hot = 0
  self.icon = ""
  self.titlePosOffset = 0
  self.titleSizeAdd = 0
  self.customVariable = ""
  self.showGroup = 0
  self.appearance = 0
  self.isShow = nil
  self.serverid = nil
  self.inner_server = nil
  self.show_condition = nil
  self.callback_skill_id = nil
  self.skill_id_list = nil
  self.act_mod_open = nil
  self.special_image = nil
  self.goto_buy = nil
  self.rt_config = nil
  self.if_vip = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.name = row:getValue("name") or ""
  self.quality = tonumber(row:getValue("quality")) or 0
  self.order = tonumber(row:getValue("order")) or 0
  self.hot = tonumber(row:getValue("hot")) or 0
  self.typeGain = tonumber(row:getValue("type_gain")) or 0
  self.customVariable = row:getValue("custom_variable") or ""
  self.isShow = tonumber(row:getValue("isShow")) or 1
  self.callback_skill_id = tonumber(row:getValue("callback_skill_id"))
  local skill_id_str = row:getValue("skill_id") or ""
  if not string.IsNullOrEmpty(skill_id_str) then
    self.skill_id_list = string.string2array_i_oneSep(skill_id_str, "|")
  end
  local img = row:getValue("image")
  if string.IsNullOrEmpty(img) then
    self.img = nil
  elseif self.type == DecorationType.DecorationType_TittleName then
    self.img = string.format(LoadPath.UITitleIcon, img)
  else
    self.img = string.format(LoadPath.UIDecoration, img)
  end
  local iconPath = row:getValue("icon") or ""
  self.icon = string.format(LoadPath.ItemPath, iconPath)
  
  local function SetEffect(effectMap, str)
    local all = string.split(str, "|")
    for _, v in ipairs(all) do
      if not string.IsNullOrEmpty(v) then
        local effectVec = string.split(v, ";")
        if table.count(effectVec) == 2 then
          local para = {}
          para.key = toInt(effectVec[1])
          para.value = tonumber(effectVec[2])
          table.insert(effectMap, para)
        end
      end
    end
  end
  
  self.model = row:getValue("model")
  self.model_world = row:getValue("model_world")
  self.model_new = row:getValue("model_new")
  if string.IsNullOrEmpty(self.model_new) then
    self.model_new = self.model
  end
  self.model_world_new = row:getValue("model_world_new")
  if string.IsNullOrEmpty(self.model_world_new) then
    self.model_world_new = self.model_world
  end
  self.is_advanced = row:getValue("is_advanced") == "1"
  self.model_advanced = row:getValue("model_advanced")
  self.model_world_advanced = row:getValue("model_world_advanced")
  self.wearEffect = {}
  self.ownEffect = {}
  self.gainMethod = {}
  local wearStr = row:getValue("effect_wear")
  SetEffect(self.wearEffect, wearStr)
  local ownStr = row:getValue("effect_gain")
  SetEffect(self.ownEffect, ownStr)
  local gainStr = row:getValue("para_gain")
  local vec1 = string.split(gainStr, "|")
  for k, v in ipairs(vec1) do
    if not string.IsNullOrEmpty(v) then
      local effectVec = string.split(v, ";")
      if not table.IsNullOrEmpty(effectVec) then
        local para = {}
        para.id = toInt(effectVec[1])
        local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(para.id)
        if itemTemplate then
          para.name = tonumber(itemTemplate.para2)
        end
        para.index = k
        para.skinId = self.id
        table.insert(self.gainMethod, para)
      end
    end
  end
  local posOffsetStr = row:getValue("position")
  if not string.IsNullOrEmpty(posOffsetStr) then
    local posOffsetVec = string.split(posOffsetStr, "|")
    if table.count(posOffsetVec) == 2 then
      self.titlePosOffset = tonumber(posOffsetVec[1])
      self.titleSizeAdd = tonumber(posOffsetVec[2])
    end
  end
  self.showGroup = tonumber(row:getValue("showgroup")) or 0
  self.appearance = tonumber(row:getValue("appearance")) or 0
  local serverid = row:getValue("serverid")
  if not string.IsNullOrEmpty(serverid) then
    local serverIdStr1 = string.split(serverid, ",")
    if not table.IsNullOrEmpty(serverIdStr1) then
      for k, v in pairs(serverIdStr1) do
        local serverIdStr2 = string.split(v, "-")
        if table.count(serverIdStr2) == 1 then
          table.insert(self.serverid, {
            tonumber(serverIdStr2[1]),
            tonumber(serverIdStr2[1])
          })
        elseif table.count(serverIdStr2) == 2 then
          table.insert(self.serverid, {
            tonumber(serverIdStr2[1]),
            tonumber(serverIdStr2[2])
          })
        end
      end
    end
  end
  local inner_server = row:getValue("inner_server")
  if not string.IsNullOrEmpty(inner_server) then
    local innerServerIdStr1 = string.split(inner_server, ",")
    if not table.IsNullOrEmpty(innerServerIdStr1) then
      for k, v in pairs(innerServerIdStr1) do
        local serverIdStr2 = string.split(v, "-")
        if table.count(serverIdStr2) == 1 then
          table.insert(self.inner_server, {
            tonumber(serverIdStr2[1]),
            tonumber(serverIdStr2[1])
          })
        elseif table.count(serverIdStr2) == 2 then
          table.insert(self.inner_server, {
            tonumber(serverIdStr2[1]),
            tonumber(serverIdStr2[2])
          })
        end
      end
    end
  end
  local show_condition = row:getValue("show_condition")
  if not string.IsNullOrEmpty(show_condition) then
    local showConditionStr1 = string.split(show_condition, "|")
    if not table.IsNullOrEmpty(showConditionStr1) then
      for k, v in pairs(showConditionStr1) do
        local condition = string.split(v, ";")
        if table.count(condition) == 2 then
          table.insert(self.show_condition, {
            tonumber(condition[1]),
            tostring(condition[2])
          })
        end
      end
    end
  end
  self.act_mod_open = tonumber(row:getValue("act_mod_open")) or 0
  self.season = tonumber(row:getValue("season")) or 0
  local act_random_config = row:getValue("act_random_config")
  if not string.IsNullOrEmpty(act_random_config) then
    local times = string.split(act_random_config, ";")
    if times and #times == 2 then
      self.randMin = toInt(times[1])
      self.randMax = toInt(times[2])
    end
  end
  self.special_image = row:getValue("special_image")
  self.act_idle_status_para = row:getValue("act_idle_status_para")
  self.goto_buy = row:getValue("goto_buy")
  self.rt_config = row:getValue("rt_config")
  self.if_vip = tonumber(row:getValue("if_vip")) or 0
end

local function IsHot(self)
  return self.hot == 1
end

local function IsDefault(self)
  return self.typeGain == DecorationGainType.DecorationGainType_Default
end

local function CheckTemplateCanShow(self)
  if self.isShow == 0 then
    return false
  end
  local serverList = CS.CommonUtils.IsDebug() and self.inner_server or self.serverid
  return DataCenter.DecorationTemplateManager:CheckTemplateCanShow(self.show_condition, serverList)
end

DecorationTemplate.__init = __init
DecorationTemplate.__delete = __delete
DecorationTemplate.InitData = InitData
DecorationTemplate.IsHot = IsHot
DecorationTemplate.IsDefault = IsDefault
DecorationTemplate.CheckTemplateCanShow = CheckTemplateCanShow
return DecorationTemplate
