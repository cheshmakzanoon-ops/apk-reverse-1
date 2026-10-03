local BattleCardLevelTemplate = BaseClass("BattleCardLevelTemplate")

function BattleCardLevelTemplate:__init()
  self.id = 0
  self.type = 0
  self.color = 0
  self.level = 0
  self.cost = {}
  self.resolve_reward = ""
end

function BattleCardLevelTemplate:__delete()
  self.id = nil
  self.type = nil
  self.color = nil
  self.level = nil
  self.cost = nil
  self.resolve_reward = nil
end

function BattleCardLevelTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.color = rowData:getValue("color") or 0
  self.level = rowData:getValue("level") or 0
  self.cost = rowData:getValue("cost") or {}
  self.resolve_reward = rowData:getValue("resolve_reward") or {}
end

return BattleCardLevelTemplate
