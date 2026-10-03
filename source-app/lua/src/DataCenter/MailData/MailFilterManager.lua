local MailFilterManager = BaseClass("MailFilterManager")
local MailTemplate = require("DataCenter.MailData.MailTemplate")
local MAIL_SEARCH_RECORD_KEY = "MAIL_SEARCH_RECORD_KEY"

function MailFilterManager:__init()
  self.mailConfig = nil
  self.searchRecord = nil
  self.filters = nil
end

function MailFilterManager:__delete()
  self.mailConfig = nil
  self.searchRecord = nil
  self.filters = nil
end

function MailFilterManager:IsFilterOpen()
  local openDay = LuaEntry.DataConfig:TryGetNum("mail_optimize_102", "k1", -1)
  if openDay == nil then
    return false
  end
  if openDay < 0 then
    return false
  end
  local curOpenServerDay = UITimeManager:GetInstance():GetServerOpenDays()
  local startOpenServerDay = tonumber(openDay)
  return curOpenServerDay >= startOpenServerDay and LuaEntry.DataConfig:CheckSwitch("mail_optimize_101")
end

function MailFilterManager:GetMailConfig()
  if self.mailConfig ~= nil then
    return self.mailConfig
  end
  self.mailConfig = {}
  LocalController:instance():visitTable(TableName.Mail, function(id, lineData)
    local template = MailTemplate.New()
    template:InitData(lineData)
    if template.group and self.mailConfig[template.group] == nil then
      self.mailConfig[template.group] = {}
    end
    table.insert(self.mailConfig[template.group], template)
  end)
  return self.mailConfig
end

local function GetFilterRowData(lineData)
  local rowData = {}
  rowData.id = lineData.id or 0
  rowData.name = lineData.name or ""
  rowData.group = lineData.group or -1
  rowData.type = lineData.type or {}
  rowData.default_open_type = lineData.default_open_type or 0
  rowData.default_open_param = lineData.default_open_param or {}
  rowData.mail_id = lineData.mail_id or {}
  rowData.not_show_mail_id = lineData.not_show_mail_id or {}
  return rowData
end

function MailFilterManager:GetFilters(groupId)
  if self.filters ~= nil then
    return self.filters[groupId] or {}
  end
  local filters = {}
  LocalController:instance():visitTable(TableName.LW_MAIL_FILTER, function(id, lineData)
    if filters[lineData.group] == nil then
      filters[lineData.group] = {}
    end
    local rowData = GetFilterRowData(lineData)
    table.insert(filters[lineData.group], rowData)
  end)
  for id, list in pairs(filters) do
    local all = self:GetAllFilter(id)
    table.insert(list, 1, all)
  end
  self.filters = filters
  return filters[groupId] or {}
end

function MailFilterManager:GetAllFilter(groupId)
  local types = {}
  for k, v in pairs(MailTypeToInternalGroup) do
    if v == groupId then
      table.insert(types, k)
    end
  end
  return GetFilterRowData({
    name = "mail_filter_tips_16",
    type = types,
    group = groupId
  })
end

function MailFilterManager:GetLocalizationKeyByKeywords(group, types, key)
  local result = {}
  local map = {}
  local filterTypes = {}
  for _, v in pairs(types) do
    filterTypes[tostring(v)] = true
  end
  local needFilter = next(filterTypes)
  self:GetMailConfig()
  local config = self.mailConfig[group]
  if config == nil then
    return result
  end
  for _, v in pairs(config) do
    if needFilter and filterTypes[tostring(v.type)] then
      v:DoLocalization()
      local found, msg = v:ContainKeywords(key)
      if found and not map[msg] then
        map[msg] = true
        table.insert(result, msg)
      end
    end
  end
  return result
end

function MailFilterManager:GetSearchRecords()
  if self.searchRecord == nil then
    self.searchRecord = CommonUtil.PlayerPrefsGetTable(MAIL_SEARCH_RECORD_KEY)
  end
  return self.searchRecord or {}
end

function MailFilterManager:AddSearchRecords(record)
  if string.IsNullOrEmpty(record) then
    return
  end
  local records = self:GetSearchRecords()
  for i, v in pairs(records) do
    if v == record then
      table.remove(records, i)
      break
    end
  end
  table.insert(records, 1, record)
  if #records > self:GetRecordMaxNum() then
    table.remove(records, #records)
  end
  CommonUtil.PlayerPrefsSetTable(MAIL_SEARCH_RECORD_KEY, records)
end

function MailFilterManager:GetRecordMaxNum()
  local interval = LuaEntry.DataConfig:TryGetNum("mail_optimize_102", "k3", 20)
  return interval
end

return MailFilterManager
