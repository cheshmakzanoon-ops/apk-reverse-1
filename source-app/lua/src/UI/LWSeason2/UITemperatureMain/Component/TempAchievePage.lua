local TempAchievePage = BaseClass("TempAchievePage", UIBaseContainer)
local base = UIBaseContainer
local content_path = "ViewPort/Content"
local TempAchieveCell = require("UI.LWSeason2.UITemperatureMain.Component.TempAchieveCell")

function TempAchievePage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function TempAchievePage:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TempAchievePage:ComponentDefine()
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function TempAchievePage:ComponentDestroy()
end

function TempAchievePage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetTempUserAchievementInfo, self.GetTempUserAchievementInfo)
end

function TempAchievePage:OnRemoveListener()
  self:RemoveUIListener(EventId.GetTempUserAchievementInfo, self.GetTempUserAchievementInfo)
  base.OnRemoveListener(self)
end

function TempAchievePage:Refresh()
  SFSNetwork.SendMessage(MsgDefines.GetTempUserAchievementInfo)
  if not self.cells then
    self:CreateCells()
  else
    for _, v in pairs(self.cells) do
      v:Refresh()
    end
  end
end

function TempAchievePage:GetTempUserAchievementInfo()
  if self.cells then
    for _, v in pairs(self.cells) do
      v:Refresh()
    end
  end
end

function TempAchievePage:CreateCells()
  local seasonNum = SeasonUtil.GetSeason()
  local seasonCheck = string.format(";%s;", seasonNum)
  local data = {}
  self.cells = {}
  LocalController:instance():visitTable(TableName.Temperature_Achievement, function(id, lineData)
    if lineData and (lineData.type == 1 or lineData.type == "1") and lineData.season and string.match(lineData.season, seasonCheck) then
      local meta = {
        id = lineData:getValue("id"),
        icon = lineData:getValue("icon"),
        desc = lineData:getValue("desc")
      }
      table.insert(data, meta)
    end
  end)
  table.sort(data, function(a, b)
    return a.id < b.id
  end)
  for k, v in pairs(data) do
    self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWSeason2/TempAchieveCell.prefab", function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "TempAchieveCell" .. k
      item.transform:SetParent(self.content.transform)
      item.transform:Set_localScale(1, 1, 1)
      self.cells[k] = self.content:AddComponent(TempAchieveCell, item.name)
      self.cells[k]:SetData(v)
    end)
  end
end

return TempAchievePage
