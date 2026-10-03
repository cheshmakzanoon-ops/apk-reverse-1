local BuildingReportOneData = {
  rank = 0,
  name = "",
  num = 0,
  maintenance = 0,
  efficiency = 0,
  damage = 0,
  repair = 0
}
local ResourceReportOneData = {
  own = 0,
  name = "",
  need = 0,
  output = 0,
  capacity = 0,
  space = 0,
  month = 0
}
local ShowResourceType = {
  CS.ResourceType.Water,
  CS.ResourceType.Electricity,
  CS.ResourceType.Oil,
  CS.ResourceType.Metal
}
local BuildingDesOneData = {itemId = 0, name = ""}
local BuildOneData = DataClass("BuildOneData", BuildingReportOneData)
local BuildDesOneData = DataClass("BuildingDesOneData", BuildingDesOneData)
local ResourceOneData = DataClass("ResourceOneData", ResourceReportOneData)
local UIMainPlayerReportTableCtrl = BaseClass("UIMainPlayerReportTableCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMainPlayerReportTable)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitBuildList(self)
  self.buildTab = {}
  local buildTable
  if buildTable ~= nil then
    table.walk(buildTable, function(k, v)
      local tab = v.build_show_type
      local oneData = BuildDesOneData.New()
      if self.buildTab[tab] == nil then
        self.buildTab[tab] = {}
      end
      oneData.name = v.name
      oneData.itemId = k
      table.insert(self.buildTab[tab], oneData)
    end)
  end
end

local function GetBuildCurrentShowList(self, buildTog1IsOn, buildTog2IsOn, buildTog3IsOn)
  local tempList = {}
  local showList = {}
  local i = 0
  if buildTog1IsOn then
    table.insertto(tempList, self.buildTab[1])
  end
  if buildTog2IsOn then
    table.insertto(tempList, self.buildTab[2])
  end
  if buildTog3IsOn then
    table.insertto(tempList, self.buildTab[3])
  end
  table.walk(tempList, function(k, v)
    local oneData = BuildOneData.New()
    i = i + 1
    oneData.rank = i
    oneData.name = v.name
    oneData.num = 0
    table.insert(showList, oneData)
  end)
  return showList
end

local function GetResourceShowList(self)
  local showList = {}
  table.walk(ShowResourceType, function(k, v)
    local oneData = ResourceOneData.New()
    oneData.name = CommonUtil.GetResourceNameByType(v)
    oneData.own = LuaEntry.Resource:GetCntByResType(v)
    oneData.need = 0
    oneData.output = math.ceil(LuaEntry.Resource:GetResAddSpeedByResType(v))
    oneData.capacity = math.ceil(LuaEntry.Resource:GetMaxStorageByResType(v))
    oneData.space = LuaEntry.Resource:GetMaxStorageByResType(v) - LuaEntry.Resource:GetCntByResType(v)
    table.insert(showList, oneData)
  end)
  return showList
end

UIMainPlayerReportTableCtrl.OnEnable = OnEnable
UIMainPlayerReportTableCtrl.OnDisable = OnDisable
UIMainPlayerReportTableCtrl.InitBuildList = InitBuildList
UIMainPlayerReportTableCtrl.GetBuildCurrentShowList = GetBuildCurrentShowList
UIMainPlayerReportTableCtrl.GetResourceShowList = GetResourceShowList
UIMainPlayerReportTableCtrl.CloseSelf = CloseSelf
UIMainPlayerReportTableCtrl.Close = Close
return UIMainPlayerReportTableCtrl
