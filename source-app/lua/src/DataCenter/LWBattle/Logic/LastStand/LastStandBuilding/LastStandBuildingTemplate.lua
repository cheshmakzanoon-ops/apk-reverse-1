local LastStandBuildingTemplate = BaseClass("LastStandBuildingTemplate")

function LastStandBuildingTemplate:__init()
  self.id = 0
  self.type = 0
  self.lv = 0
  self.max_lv = 0
  self.front_building = ""
  self.prefab = ""
  self.icon = ""
  self.scale = ""
  self.hp = 0
  self.cost = 0
  self.para1 = ""
  self.para2 = ""
  self.para3 = ""
end

function LastStandBuildingTemplate:__delete()
  self.id = nil
  self.type = nil
  self.lv = nil
  self.max_lv = nil
  self.front_building = nil
  self.prefab = nil
  self.icon = nil
  self.scale = nil
  self.hp = nil
  self.cost = nil
  self.para1 = nil
  self.para2 = nil
  self.para3 = nil
end

function LastStandBuildingTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.lv = rowData:getValue("lv") or 0
  self.max_lv = rowData:getValue("max_lv") or 0
  self.front_building = rowData:getValue("front_building") or ""
  self.prefab = rowData:getValue("prefab") or ""
  self.icon = rowData:getValue("icon") or ""
  self.scale = rowData:getValue("scale") or ""
  self.hp = rowData:getValue("hp") or 0
  self.cost = rowData:getValue("cost") or 0
  self.para1 = rowData:getValue("para1") or ""
  self.para2 = rowData:getValue("para2") or ""
  self.para3 = rowData:getValue("para3") or ""
  self.front_building_list = {}
  local frontBuildingArr = string.split(self.front_building, "|")
  for _, v in ipairs(frontBuildingArr) do
    local idArr = string.split(v, ";")
    local idList = {}
    for _, buildId in ipairs(idArr) do
      local id = tonumber(buildId)
      if id then
        table.insert(idList, id)
      end
    end
    if 0 < #idList then
      table.insert(self.front_building_list, idList)
    end
  end
end

return LastStandBuildingTemplate
