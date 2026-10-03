local MailExtraEffectTemplateManager = BaseClass("MailExtraEffectTemplateManager")
local MailExtraEffectTemplate = require("DataCenter.MailEffect.MailExtraEffectTemplate")

local function __init(self)
  self.templateDict = {}
  self.byOtherTabAndEffectId = {}
  self:InitAllTemplate()
end

local function __delete(self)
  self.byOtherTabAndEffectId = nil
end

local function GetAllTemplate(self)
  return self.templateDict
end

local function InitAllTemplate(self)
  self.templateDict = {}
  self.byOtherTabAndEffectId = {}
  LocalController:instance():visitTable(TableName.LW_Extra_Power_Report_New, function(id, lineData)
    if lineData ~= nil then
      local item = MailExtraEffectTemplate.New()
      item:InitData(lineData)
      self.templateDict[id] = item
      local ott = item.othertabtype
      if ott and ott ~= 0 and item.effectId then
        if self.byOtherTabAndEffectId[ott] == nil then
          self.byOtherTabAndEffectId[ott] = {}
        end
        local map = self.byOtherTabAndEffectId[ott]
        for _, eid in ipairs(item.effectId) do
          eid = tonumber(eid)
          if eid and eid ~= 0 and map[eid] == nil then
            map[eid] = item
          end
        end
      end
    end
  end)
end

local function GetTemplateByOtherTabAndEffectId(self, tabType, effectId)
  local t = tonumber(tabType)
  local eid = tonumber(effectId)
  if not (t and t ~= 0 and eid) or eid == 0 then
    return nil
  end
  local map = self.byOtherTabAndEffectId[t]
  return map and map[eid] or nil
end

local function GetGotoByOtherTabType(self, tabType, effectId)
  local tpl = self:GetTemplateByOtherTabAndEffectId(tabType, effectId)
  if not (tpl and tpl.gotoType) or #tpl.gotoType == 0 then
    return 0, 0
  end
  local gotoType = tonumber(tpl.gotoType[1]) or 0
  local gotoParam = 0
  if tpl.gotoParam and tpl.gotoParam[1] ~= nil then
    gotoParam = tonumber(tpl.gotoParam[1]) or 0
  end
  return gotoType, gotoParam
end

MailExtraEffectTemplateManager.__init = __init
MailExtraEffectTemplateManager.__delete = __delete
MailExtraEffectTemplateManager.GetAllTemplate = GetAllTemplate
MailExtraEffectTemplateManager.InitAllTemplate = InitAllTemplate
MailExtraEffectTemplateManager.GetTemplateByOtherTabAndEffectId = GetTemplateByOtherTabAndEffectId
MailExtraEffectTemplateManager.GetGotoByOtherTabType = GetGotoByOtherTabType
return MailExtraEffectTemplateManager
