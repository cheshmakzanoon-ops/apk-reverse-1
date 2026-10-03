local BattleCardStarTemplate = BaseClass("BattleCardStarTemplate")

function BattleCardStarTemplate:__init()
  self.id = 0
  self.card_id = 0
  self.star = 0
  self.cost = 0
  self.attr = {}
  self.skill_list = {}
  self.power = 0
end

function BattleCardStarTemplate:__delete()
  self.id = nil
  self.card_id = nil
  self.star = nil
  self.cost = nil
  self.attr = nil
  self.skill_list = nil
  self.power = nil
end

function BattleCardStarTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.card_id = rowData:getValue("card_id") or 0
  self.star = rowData:getValue("star") or 0
  self.cost = rowData:getValue("cost") or 0
  self.attr = rowData:getValue("attr") or {}
  self.skill_list = rowData:getValue("skill_list") or {}
  self.power = rowData:getValue("power") or 0
end

return BattleCardStarTemplate
