local AllianceGovernmentSkillConfig = BaseClass("AllianceGovernmentSkillConfig")

function AllianceGovernmentSkillConfig:__init()
end

function AllianceGovernmentSkillConfig:__delete()
end

function AllianceGovernmentSkillConfig:InitData(data)
  self.id = data.id
  self.type = data.type
  self.skill_flag = data.skill_flag
  self.skill_icon = data.skill_icon
  self.name = data.name
  self.desc = data.desc
  self.rule = data.rule
  self.pre_time = toInt(data.pre_time)
  self.during_time = toInt(data.during_time)
  self.cd_time = toInt(data.cd_time)
  self.activity_type = data.activity_type
  self.effect_scope = toInt(data.effect_scope)
  self.effect_desc = data.effect_desc or ""
  self.effect_desc_num = data.effect_desc_num or ""
  self.skill_para1 = data.skill_para1
  self.skill_para4 = toInt(data.skill_para4)
  self.skill_para5 = toInt(data.skill_para5)
  self.skill_para6 = toInt(data.skill_para6)
  self.skill_para7 = toInt(data.skill_para7)
  self.skill_para8 = toInt(data.skill_para8)
  if toInt(data.skill_sound) == 1 then
    self.skill_vibrate = data.skill_vibrate
    self.skill_shake = data.skill_shake
  end
  self.announce_success = toInt(data.announce_id)
  self.announce_prepare = toInt(data.announce_id_prepare)
  self.announce_fail = toInt(data.announce_id_defeat)
  self.consume_energy = toInt(data.consume_energy)
  self.prerequisites_effect = toInt(data.prerequisites_effect)
  self.unlock_condition_desc = data.unlock_condition_desc
  self.double_check_desc = data.double_check_desc
  self.skill_score = data.skill_score
  self.skill_name = data.skill_name
  self.unity_config = data.UnityConfigPath
  self.skill_show = data.Skill_Icon_Path
end

function AllianceGovernmentSkillConfig:IsLinkedActivityOpen()
  local activity_type = self.activity_type
  if activity_type == nil or activity_type == "" or activity_type == 0 then
    return false
  end
  local activity_type_list
  local theType = type(activity_type)
  if theType == "number" then
    activity_type_list = {
      toInt(activity_type)
    }
  elseif theType == "string" then
    activity_type_list = string.split(activity_type, "|")
  elseif theType == "table" then
    activity_type_list = activity_type
  end
  for _, v in pairs(activity_type_list) do
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(v)
    if 0 < #dataList then
      local data = dataList[1]
      if data and type(data.IsValid) == "function" and data:IsValid() then
        return true
      end
    end
  end
  return false
end

function AllianceGovernmentSkillConfig:IsActivePreEffect()
  if self.prerequisites_effect == 0 then
    return true
  end
  local effectValue = LuaEntry.Effect:GetGameEffect(self.prerequisites_effect)
  return 0 < effectValue
end

return AllianceGovernmentSkillConfig
