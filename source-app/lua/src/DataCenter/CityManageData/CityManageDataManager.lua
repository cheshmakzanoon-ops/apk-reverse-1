local CityManageDataManager = BaseClass("CityManageDataManager")

local function __init(self)
  self.itemList = {}
  self.Cell = {}
end

local function __delete(self)
  self.itemList = nil
  self.Cell = nil
end

local function GetAllCityManageData(self)
  self.itemList = {}
  LocalController:instance():visitTable(TableName.CityManage, function(id, lineData)
    local item = CityManageData.New()
    item:InitData(lineData)
    if self.itemList[item.group] == nil then
      self.itemList[item.group] = {}
    end
    table.insert(self.itemList[item.group], item)
  end)
  for i, v in pairs(self.itemList) do
    table.sort(v, function(a, b)
      local iStatusA = tonumber(a.status)
      local iStatusB = tonumber(b.status)
      if iStatusA and iStatusB then
        return iStatusA < iStatusB
      else
        return false
      end
    end)
  end
  return self.itemList
end

CityManageDataManager.__init = __init
CityManageDataManager.__delete = __delete
CityManageDataManager.GetAllCityManageData = GetAllCityManageData
return CityManageDataManager
