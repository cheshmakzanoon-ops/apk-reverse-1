local T11IdleGameNodeTemplate = BaseClass("T11IdleGameNodeTemplate")

function T11IdleGameNodeTemplate:__init()
  self.id = 0
  self.node_type = 0
  self.asset_path = ""
  self.monster = ""
end

function T11IdleGameNodeTemplate:__delete()
  self.id = nil
  self.node_type = nil
  self.asset_path = nil
  self.monster = nil
end

function T11IdleGameNodeTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.node_type = rowData:getValue("node_type") or 0
  self.asset_path = rowData:getValue("asset_path") or ""
  self.monster = rowData:getValue("monster") or ""
end

function T11IdleGameNodeTemplate:GetMonsterData()
  local strList1 = string.split(self.monster, "|")
  if #strList1 == 2 then
    local bossStr = strList1[1]
    local zombieStr = strList1[2]
    local bossList = string.split(bossStr, ",")
    local zombieList = string.split(zombieStr, ",")
    local res = {}
    res.bossData = {}
    res.zombieData = {}
    for i, v in pairs(bossList) do
      table.insert(res.bossData, tonumber(v))
    end
    for i, v in pairs(zombieList) do
      table.insert(res.zombieData, tonumber(v))
    end
    return res
  end
end

return T11IdleGameNodeTemplate
