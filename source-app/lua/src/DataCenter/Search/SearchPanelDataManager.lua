local SearchPanelDataManager = BaseClass("SearchPanelDataManager")
local rapidjson = require("rapidjson")

local function __init(self)
  self.map = {}
  self.selectCache = {}
  self:LoadFromPrefs()
end

local function __delete(self)
  self.map = nil
  self.selectCache = nil
end

local function LoadFromPrefs(self)
  local prefString = CommonUtil.PlayerPrefsGetString("UI_SEARCH_RECORD_V1", "{}")
  local data = rapidjson.decode(prefString)
  if not data then
    return
  end
  if data.map then
    for k, v in pairs(data.map) do
      self.map[tonumber(k)] = {}
      for subType, level in pairs(v) do
        self.map[tonumber(k)][tonumber(subType)] = level
      end
    end
  end
  self.selectCache = data.selectCache or {}
  self.pageIndex = data.pageIndex
  self.group = data.group
end

local function SaveToPrefs(self)
  local data = {}
  data.map = {}
  for k, v in pairs(self.map) do
    data.map[tostring(k)] = {}
    for subType, level in pairs(v) do
      data.map[tostring(k)][tostring(subType)] = level
    end
  end
  data.selectCache = self.selectCache
  data.pageIndex = self.pageIndex
  if self.group then
    data.group = self.group
  end
  local prefString = rapidjson.encode(data)
  CommonUtil.PlayerPrefsSetString("UI_SEARCH_RECORD_V1", prefString)
end

local function RecordUserSearch(self, type, subType, value)
  if not self.map[type] then
    self.map[type] = {}
  end
  self.map[type][subType] = value
  self:SaveToPrefs()
end

local function GetUserSearch(self, type, subType)
  if self.map[type] and self.map[type][subType] then
    return self.map[type][subType]
  end
  return nil
end

local function RecordSelectPage(self, pageIndex, cellIndex)
  self.pageIndex = pageIndex
  self.selectCache[pageIndex] = cellIndex
  self:SaveToPrefs()
end

local function GetSelectCellIndex(self, pageIndex)
  return self.selectCache[pageIndex]
end

local function GetSelectPage(self)
  return self.pageIndex, self.selectCache[self.pageIndex]
end

function SearchPanelDataManager:RecordSelectPageForS5(pageIndex, cellIndex, group)
  self.pageIndex = pageIndex
  self.selectCache[pageIndex] = cellIndex
  self.group = group
  self:SaveToPrefs()
end

function SearchPanelDataManager:GetSelectGroup()
  return self.group
end

SearchPanelDataManager.__init = __init
SearchPanelDataManager.__delete = __delete
SearchPanelDataManager.RecordUserSearch = RecordUserSearch
SearchPanelDataManager.GetUserSearch = GetUserSearch
SearchPanelDataManager.RecordSelectPage = RecordSelectPage
SearchPanelDataManager.GetSelectPage = GetSelectPage
SearchPanelDataManager.GetSelectCellIndex = GetSelectCellIndex
SearchPanelDataManager.SaveToPrefs = SaveToPrefs
SearchPanelDataManager.LoadFromPrefs = LoadFromPrefs
return SearchPanelDataManager
