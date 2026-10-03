local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local TorchRelayBattleStageConfigTemplate = BaseClass("TorchRelayBattleStageConfigTemplate")

function TorchRelayBattleStageConfigTemplate:__init()
  self.id = 0
  self.scene_loop = ""
  self.item_position_random = ""
  self.birth_point = ""
  self.limit_width = 0
  self.distribution_weight = ""
  self.buff_item_id = ""
  self.trap_id = ""
  self.stamina_cost = 0
  self.speed_up_max = 0
  self.meter_para = 0
  self.cheer_ID = ""
  self.cheer_position = ""
  self.exceed_ally = ""
  self.speed_power_max = 0
  self.speed_percent = 0
  self.speed_last_time = 0
  self.start_position = 0
  self.start_speed_power = 0
  self.soldier_path = ""
  self.invincible_path = ""
  self.switch_resource = ""
  self.banner_leftText = ""
  self.banner_rightText = ""
  self.banner_loadingBgRes = ""
  self.end_GiveAway = 0
  self.line = ""
  self.line_res = ""
  self.golden_stage = ""
  self.item_flyspeed = 0
  self.main_mile_icon = ""
  self.model_give_torch = ""
end

function TorchRelayBattleStageConfigTemplate:__delete()
  self.id = nil
  self.scene_loop = nil
  self.item_position_random = nil
  self.birth_point = nil
  self.limit_width = nil
  self.distribution_weight = nil
  self.buff_item_id = nil
  self.trap_id = nil
  self.stamina_cost = nil
  self.speed_up_max = nil
  self.meter_para = nil
  self.cheer_ID = nil
  self.cheer_position = nil
  self.exceed_ally = nil
  self.speed_power_max = nil
  self.speed_percent = nil
  self.speed_last_time = nil
  self.start_position = nil
  self.start_speed_power = nil
  self.soldier_path = nil
  self.invincible_path = nil
  self.switch_resource = nil
  self.end_GiveAway = nil
  self.line = nil
  self.line_res = nil
  self.golden_stage = nil
  self.item_flyspeed = nil
  self.main_mile_icon = nil
  self.model_give_torch = nil
  self:DeleteCustom()
end

function TorchRelayBattleStageConfigTemplate:InitCustom()
  self.sceneConfigs = {}
  self.sceneIndexRandomIdPairList = {}
end

function TorchRelayBattleStageConfigTemplate:DeleteCustom()
  self.sceneConfigs = nil
  self.sceneIndexRandomIdPairList = nil
  self.banner_leftText = nil
  self.banner_rightText = nil
  self.banner_loadingBgRes = nil
  self.effectLine_server_key = nil
  self.effectLine_server_res = nil
  self.effectLine_self_key = nil
  self.effectLine_self_res = nil
  self.effectLine_m_key = nil
  self.effectLine_m_res = nil
  self.lineScoreList = nil
end

function TorchRelayBattleStageConfigTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id") or 0
  self.scene_loop = row:getValue("scene_loop") or ""
  self.item_position_random = row:getValue("item_position_random") or ""
  self.birth_point = row:getValue("birth_point") or ""
  self.limit_width = row:getValue("limit_width") or 0
  self.distribution_weight = row:getValue("distribution_weight") or ""
  self.buff_item_id = row:getValue("buff_item_id") or ""
  self.trap_id = row:getValue("trap_id") or ""
  self.stamina_cost = row:getValue("stamina_cost") or 0
  self.speed_up_max = row:getValue("speed_up_max") or 0
  self.meter_para = row:getValue("meter_para") or 0
  self.cheer_ID = row:getValue("cheer_ID") or ""
  self.cheer_position = row:getValue("cheer_position") or ""
  self.exceed_ally = row:getValue("exceed_ally") or ""
  self.speed_power_max = row:getValue("speed_power_max")
  self.speed_percent = row:getValue("speed_percent")
  self.speed_last_time = row:getValue("speed_last_time")
  self.start_position = row:getValue("start_position")
  self.start_speed_power = row:getValue("start_speed_power")
  self.soldier_path = row:getValue("soldier_path")
  self.invincible_path = row:getValue("invincible_path")
  self.switch_resource = row:getValue("switch_resource")
  self.end_GiveAway = tonumber(row:getValue("end_GiveAway"))
  self.line_res = row:getValue("line_res")
  self.line = row:getValue("line")
  self.golden_stage = row:getValue("golden_stage")
  self.item_flyspeed = row:getValue("item_flyspeed")
  self.main_mile_icon = row:getValue("main_mile_icon")
  self.model_give_torch = row:getValue("model_give_torch")
  self:InitCustom()
  local keyList = string.split(self.switch_resource, "|")
  if 3 <= #keyList then
    self.banner_leftText = keyList[2]
    self.banner_rightText = keyList[3]
    self.banner_loadingBgRes = keyList[1]
  end
  if not string.IsNullOrEmpty(self.line_res) then
    local lineStrList = string.split(self.line_res, ";")
    if 3 <= #lineStrList then
      local function _returnKeyAndValue(pairStr)
        if not string.IsNullOrEmpty(pairStr) then
          local pairList = string.split(pairStr, "|")
          
          if 2 <= #pairList then
            return pairList[1], pairList[2]
          end
        end
        return nil, nil
      end
      
      self.effectLine_server_key, self.effectLine_server_res = _returnKeyAndValue(lineStrList[1])
      self.effectLine_self_key, self.effectLine_self_res = _returnKeyAndValue(lineStrList[2])
      self.effectLine_m_key, self.effectLine_m_res = _returnKeyAndValue(lineStrList[3])
    end
  end
  self.lineScoreList = {}
  if not string.IsNullOrEmpty(self.line) then
    local lineStrList = string.split(self.line, "|")
    for i, v in ipairs(lineStrList) do
      if not string.IsNullOrEmpty(v) then
        table.insert(self.lineScoreList, tonumber(v))
      end
    end
  end
  local sceneIndex = 1
  if not string.IsNullOrEmpty(self.scene_loop) then
    local strList1 = string.split(self.scene_loop, "|")
    for _, i in pairs(strList1) do
      local strList2 = string.split(i, ";")
      if #strList2 == 2 then
        local length = tonumber(strList2[2]) or 1
        local sceneMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Scene), tonumber(strList2[1]))
        if sceneMeta ~= nil then
          local sizeZ = sceneMeta:getValue("scene_size") or TorchConstant.SCENE_CHUNK_SIZE
          local data = {
            asset = sceneMeta:getValue("asset") or "",
            sizeZ = sizeZ,
            startIndex = sceneIndex,
            endIndex = sceneIndex + length - 1
          }
          table.insert(self.sceneConfigs, data)
          sceneIndex = sceneIndex + length
        end
      end
    end
  end
  if not string.IsNullOrEmpty(self.item_position_random) then
    local pairStr = string.split(self.item_position_random, "|")
    for i, v in ipairs(pairStr) do
      local paramList = string.split(v, ";")
      if #paramList == 2 then
        local maxIndex = tonumber(paramList[1])
        local randomConfigId = tonumber(paramList[2])
        table.insert(self.sceneIndexRandomIdPairList, {maxIndex = maxIndex, randomConfigId = randomConfigId})
      end
    end
  end
end

function TorchRelayBattleStageConfigTemplate:GetRandomConfigId(index, logic)
  local res
  if logic then
    local cheerTemplate = logic:TryConvertSceneIndexToCheerTemplate(index)
    if cheerTemplate ~= nil then
      res = cheerTemplate.rare_cheer_random
    end
  end
  if res == nil then
    for i, v in ipairs(self.sceneIndexRandomIdPairList) do
      if index <= v.maxIndex then
        return v.randomConfigId
      end
    end
  end
  if res == nil then
    res = self.sceneIndexRandomIdPairList[#self.sceneIndexRandomIdPairList].randomConfigId
  end
  if res ~= nil then
    return tonumber(res)
  end
end

function TorchRelayBattleStageConfigTemplate:GetBirthPos()
  if not string.IsNullOrEmpty(self.birth_point) then
    local str = string.split(self.birth_point, "|")
    if #str == 2 then
      return Vector3.New(tonumber(str[1]), 0, tonumber(str[2]))
    end
  end
end

function TorchRelayBattleStageConfigTemplate:GetMainPlayerResPath()
  return self.soldier_path
end

function TorchRelayBattleStageConfigTemplate:GetInvincibleSpecialEffectResPath()
  return self.invincible_path
end

function TorchRelayBattleStageConfigTemplate:GetInvincibleSceneEffectResPath()
  return self.golden_stage
end

function TorchRelayBattleStageConfigTemplate:GetMagneticSpeed()
  return self.item_flyspeed
end

function TorchRelayBattleStageConfigTemplate:getMiniMileIcon()
  return self.main_mile_icon
end

function TorchRelayBattleStageConfigTemplate:getNextSoliderResPath()
  return self.model_give_torch
end

return TorchRelayBattleStageConfigTemplate
