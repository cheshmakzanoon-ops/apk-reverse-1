local DecorationDazzleManager = BaseClass("DecorationDazzleManager")
local DecorationDazzleTemplate = require("DataCenter.DecorationDataManager.DecorationDazzleTemplate")

local function __init(self)
  self.dazzleSkinDic = {}
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

function DecorationDazzleManager:GetDazzleSkinList(decorationId)
  local list = self.dazzleSkinDic[decorationId]
  if not list then
    list = {}
    self.dazzleSkinDic[decorationId] = list
    local index = 1
    LocalController:instance():visitTable(TableName.DecorationDazzle, function(id, lineData)
      if lineData and lineData.decoration_id == decorationId then
        local item = DecorationDazzleTemplate.New()
        item:InitData(lineData)
        list[index] = item
        index = index + 1
      end
    end)
  end
  return list
end

function DecorationDazzleManager:GetAllDazzleSkins()
  local list = {}
  local index = 1
  LocalController:instance():visitTable(TableName.DecorationDazzle, function(id, lineData)
    if lineData then
      list[index] = tonumber(lineData:getValue("id")) or 0
      index = index + 1
    end
  end)
  return list
end

function DecorationDazzleManager:GetDazzleSkinTemplateById(decorationId, colourId)
  if not colourId or colourId <= 0 then
    return
  end
  local list = self:GetDazzleSkinList(decorationId)
  if table.IsNullOrEmpty(list) then
    return
  end
  for i, v in ipairs(list) do
    if v.id == colourId then
      return v
    end
  end
end

function DecorationDazzleManager:GetDazzleSkinTemplateFirst(decorationId)
  local list = self:GetDazzleSkinList(decorationId)
  if table.IsNullOrEmpty(list) then
    return
  end
  return list[1]
end

function DecorationDazzleManager:GetWearDazzleTemp(decorationId, checkWear_)
  local skinData = DataCenter.DecorationDataManager:GetSkinDataById(decorationId)
  if skinData and (not checkWear_ or skinData:IsWear()) and skinData.colourId and skinData.colourId > 0 and 0 < skinData.colourTime and UITimeManager:GetInstance():GetServerTime() < skinData.colourTime then
    local list = self:GetDazzleSkinList(decorationId)
    if table.IsNullOrEmpty(list) then
      return
    end
    for i, v in ipairs(list) do
      if v.id == skinData.colourId then
        return v
      end
    end
  end
end

function DecorationDazzleManager:GetDazzleSkinListShow(decorationId)
  local list = self:GetDazzleSkinList(decorationId)
  if table.IsNullOrEmpty(list) then
    return
  end
  local result, index = {}, 1
  for i, v in ipairs(list) do
    if v:CheckTemplateCanShow() then
      result[index] = v
      index = index + 1
    end
  end
  return result
end

function DecorationDazzleManager:HasDazzleSkin(decorationId, isShow)
  local list = self:GetDazzleSkinList(decorationId)
  if table.IsNullOrEmpty(list) then
    return false
  end
  if isShow then
    for i, v in ipairs(list) do
      if v:CheckTemplateCanShow() then
        return true
      end
    end
    return false
  end
  return true
end

DecorationDazzleManager.__init = __init
DecorationDazzleManager.__delete = __delete
DecorationDazzleManager.AddListener = AddListener
DecorationDazzleManager.RemoveListener = RemoveListener
return DecorationDazzleManager
