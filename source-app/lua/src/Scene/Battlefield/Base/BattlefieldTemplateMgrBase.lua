local BattlefieldTemplateMgrBase = BaseClass("BattlefieldTemplateMgrBase")
local BFTimeCtrlTemplate = require("Scene.Battlefield.Common.BattlefieldTimeCtrlTemplate")
local BFBuildTemplate = "Scene.Battlefield.Common.BattlefieldBuildTemplate"

function BattlefieldTemplateMgrBase:__init()
  self:OnInit()
  self.baseConfig = BattleFieldUtil.GetBaseConfig(self.bfType)
end

function BattlefieldTemplateMgrBase:__delete()
  self:OnDelete()
  self.dataDic = nil
  self.dataTimeDic = nil
  self.dataEffectDic = nil
  self.bfType = nil
  self.baseConfig = nil
end

function BattlefieldTemplateMgrBase:InitTemplates()
  local templateDic = {}
  local mgr = BattleFieldUtil.GetMgr(self.bfType)
  local tbName = mgr:GetCfgValue(BattleFieldTableKey.ENTITY)
  local BuildTemplate = require(self.baseConfig.BuildTemplate or BFBuildTemplate)
  LocalController:instance():visitTable(tbName, function(id, line)
    local template = BuildTemplate.New(self.bfType)
    template:InitData(line)
    if template.id ~= nil and template.id ~= 0 then
      templateDic[template.id] = template
    end
  end)
  self.dataDic = templateDic
  local templateDic2 = {}
  tbName = mgr:GetCfgValue(BattleFieldTableKey.TIME_CTRL)
  LocalController:instance():visitTable(tbName, function(id, line)
    local template = BFTimeCtrlTemplate.New()
    template:InitData(line)
    if template.id ~= nil and template.id ~= 0 then
      templateDic2[template.id] = template
    end
  end)
  self.dataTimeDic = templateDic2
end

function BattlefieldTemplateMgrBase:GetTemplate(templateId, season)
  if season ~= nil then
    local tbName = BattleFieldUtil.GetBattleFieldCfgValue(self.bfType, BattleFieldTableKey.ENTITY, season)
    if not string.IsNullOrEmpty(tbName) then
      local line = LocalController:instance():getLine(tbName, templateId)
      if line ~= nil then
        local BuildTemplate = require(self.baseConfig.BuildTemplate)
        local template = BuildTemplate.New(self.bfType)
        template:InitData(line)
        return template
      end
    end
  end
  if self.dataDic == nil then
    self:InitTemplates()
  end
  return self.dataDic[templateId]
end

function BattlefieldTemplateMgrBase:GetBuildTemplate(id)
  return self:GetTemplate(id)
end

function BattlefieldTemplateMgrBase:GetTemplateByIndex(pointIndex)
  if self.dataDic == nil then
    self:InitTemplates()
  end
  for _, v in pairs(self.dataDic) do
    if v and v.mainIndex == pointIndex then
      return v
    end
  end
  return nil
end

function BattlefieldTemplateMgrBase:GetAllBuildTemplates()
  if self.dataDic == nil then
    self:InitTemplates()
  end
  local ret = {}
  if self.IsBuild then
    local MyInsert = table.insert
    for _, v in pairs(self.dataDic) do
      if self:IsBuild(v.id) then
        MyInsert(ret, v)
      end
    end
  else
    ret = table.values(self.dataDic)
  end
  return ret
end

function BattlefieldTemplateMgrBase:GetTypesBuild()
  if self.dataDic == nil then
    self:InitTemplates()
  end
  local tmpDic = {}
  for _, v in pairs(self.dataDic) do
    if not tmpDic[v.type] then
      tmpDic[v.type] = v
    end
  end
  return tmpDic
end

function BattlefieldTemplateMgrBase:GetALLBuildSize()
  local ret = {}
  if self.dataDic == nil then
    self:InitTemplates()
  end
  local MyInsert = table.insert
  for _, v in pairs(self.dataDic) do
    local data = {}
    data.itemId = v.id
    data.size = v.size
    MyInsert(ret, data)
  end
  return ret
end

function BattlefieldTemplateMgrBase:GetTimeTemplate(templateId)
  if self.dataTimeDic == nil then
    self:InitTemplates()
  end
  return self.dataTimeDic[templateId]
end

function BattlefieldTemplateMgrBase:GetALLTime()
  if self.dataTimeDic == nil then
    self:InitTemplates()
  end
  return self.dataTimeDic
end

function BattlefieldTemplateMgrBase:SetEffectInfo(effectId, data)
  if self.dataEffectDic == nil then
    self.dataEffectDic = {}
  end
  self.dataEffectDic[tostring(effectId)] = data
end

function BattlefieldTemplateMgrBase:GetEffectInfo(effectId)
  if self.dataEffectDic == nil then
    self.dataEffectDic = {}
  end
  if self.dataDic == nil then
    self:InitTemplates()
  end
  return self.dataEffectDic[tostring(effectId)]
end

function BattlefieldTemplateMgrBase:OnInit()
  self.bfType = BattleFieldType.Default
end

function BattlefieldTemplateMgrBase:OnDelete()
end

return BattlefieldTemplateMgrBase
