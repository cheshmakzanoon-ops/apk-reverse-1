local LWWorldTipManager = BaseClass("LWWorldTipManager")
local LWWorldTipData = require("DataCenter.LWWorldTip.LWWorldTipData")

function LWWorldTipManager:__init()
  self.dataInit = false
end

function LWWorldTipManager:__delete()
end

function LWWorldTipManager:InitData()
  self.groupList = {}
  self.seasonList = {}
  self.tabGroupList = {}
  self.dataInit = true
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.LW_PPT_Show), function(id, lineData)
    local group = lineData:getIntValue("group", 0) or 0
    local season_group = lineData:getIntValue("season_group", 0) or 0
    local item = LWWorldTipData.New()
    item:InitData(lineData)
    if toInt(season_group) == 0 then
      local data = self.groupList[group]
      if not data then
        data = {}
        self.groupList[group] = data
      end
      table.insert(data, item)
    else
      local dataWeek = self.seasonList[season_group]
      if not dataWeek then
        dataWeek = {}
        self.seasonList[season_group] = dataWeek
      end
      local season_week = lineData:getIntValue("week", 0) or 0
      if dataWeek[season_week] == nil then
        dataWeek[season_week] = {item}
      else
        table.insert(dataWeek[season_week], item)
      end
    end
  end)
  for i, v in pairs(self.groupList) do
    table.sort(v, function(a, b)
      return a.id < b.id
    end)
  end
end

function LWWorldTipManager:GetDataByGroup(group)
  if not self.dataInit then
    self:InitData()
  end
  return self.groupList[toInt(group)]
end

function LWWorldTipManager:GetDataBySeason(season_group)
  if not self.dataInit then
    self:InitData()
  end
  return self.seasonList[toInt(season_group)]
end

return LWWorldTipManager
