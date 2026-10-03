local ResourceManager = CS.GameEntry.Resource
local rapidjson = require("rapidjson")
local AllianceUnityConfig = BaseClass("AllianceUnityConfig")

function AllianceUnityConfig:__init(skillId)
  self.skillId = skillId
  self.luaData = nil
  self.AresScriptPath = nil
  self.NeedAresScriptPath = nil
  self.AresModelPath = nil
  self.NeedAresModelPath = nil
  self.AresEffects = nil
  self.IconIndex = nil
  self.BaseScriptPath = nil
  self.NeedBaseScriptPath = nil
  self.BaseModelPath = nil
  self.NeedBaseModelPath = nil
  self.NeedSkillIcon = nil
  self.BaseEffects = nil
  self.AlertIcon = nil
  self.PreBlackModel = nil
  self.baseEffect2TagsMap = {}
  self.baseEffect2TypeMap = {}
  self.skillEffect2TagsMap = {}
  self.skillEffect2TypeMap = {}
end

function AllianceUnityConfig:__delete()
  self.skillId = nil
  self.luaData = nil
  self.AresScriptPath = nil
  self.NeedAresScriptPath = nil
  self.AresModelPath = nil
  self.NeedAresModelPath = nil
  self.AresEffects = nil
  self.IconIndex = nil
  self.BaseScriptPath = nil
  self.NeedBaseScriptPath = nil
  self.BaseModelPath = nil
  self.NeedBaseModelPath = nil
  self.NeedSkillIcon = nil
  self.BaseEffects = nil
  self.AlertIcon = nil
  self.PreBlackModel = nil
  self.baseEffect2TagsMap = nil
  self.baseEffect2TypeMap = nil
  self.skillEffect2TagsMap = nil
  self.skillEffect2TypeMap = nil
end

function AllianceUnityConfig:InitData(data)
  self.luaData = data
  self.AresScriptPath = data.AresScriptPath or ""
  self.NeedAresScriptPath = data.NeedAresScriptPath or false
  self.AresModelPath = data.AresModelPath or ""
  self.NeedAresModelPath = data.NeedAresModelPath or false
  self.AresEffects = data.AresEffects or {}
  self.IconIndex = data.IconIndex or 0
  self.BaseScriptPath = data.BaseScriptPath or ""
  self.NeedBaseScriptPath = data.NeedBaseScriptPath or false
  self.BaseModelPath = data.BaseModelPath or ""
  self.NeedBaseModelPath = data.NeedBaseModelPath or false
  self.NeedSkillIcon = data.NeedSkillIcon or false
  self.BaseEffects = data.BaseEffects or {}
  self.AlertIcon = data.AlertIcon or ""
  self.PreBlackModel = data.PreBlackModel or ""
  self:BindEffectData()
end

function AllianceUnityConfig:Release()
  self.luaData = nil
end

function AllianceUnityConfig:Load(unityConfigPath)
  local fileName = PathUtil.GetFileNameWithoutExtension(unityConfigPath)
  local luaData = require("DataCenter.AllianceSkill.Data." .. fileName)
  self:InitData(luaData)
end

function AllianceUnityConfig:GetLuaData()
  return self.luaData
end

function AllianceUnityConfig:BindEffectData()
  local effects = self.BaseEffects
  for index = 1, #effects do
    local effect = effects[index]
    self.baseEffect2TagsMap[effect.Tags] = effect
    local code = effect.LogicType
    self.baseEffect2TypeMap[code] = self.baseEffect2TypeMap[code] or {}
    if code == AllianceEffectType.Start then
      table.insert(self.baseEffect2TypeMap[code], effect)
    elseif code == AllianceEffectType.Loop then
      table.insert(self.baseEffect2TypeMap[code], effect)
    elseif code == AllianceEffectType.End then
      table.insert(self.baseEffect2TypeMap[code], effect)
    end
  end
  effects = self.AresEffects
  for index = 1, #effects do
    local effect = effects[index]
    self.skillEffect2TagsMap[effect.Tags] = effect
    local code = effect.LogicType
    self.skillEffect2TypeMap[code] = self.skillEffect2TypeMap[code] or {}
    if code == AllianceEffectType.Start then
      table.insert(self.skillEffect2TypeMap[code], effect)
    elseif code == AllianceEffectType.Loop then
      table.insert(self.skillEffect2TypeMap[code], effect)
    elseif code == AllianceEffectType.End then
      table.insert(self.skillEffect2TypeMap[code], effect)
    end
  end
end

function AllianceUnityConfig:GetBaseEffectByTags(tags)
  return self.baseEffect2TagsMap[tags]
end

function AllianceUnityConfig:GetBaseEffectsByType(type)
  return self.baseEffect2TypeMap[type]
end

function AllianceUnityConfig:GetSkillEffectByTags(tags)
  return self.skillEffect2TagsMap[tags]
end

function AllianceUnityConfig:GetSkillEffectsByType(type)
  return self.skillEffect2TypeMap[type]
end

return AllianceUnityConfig
