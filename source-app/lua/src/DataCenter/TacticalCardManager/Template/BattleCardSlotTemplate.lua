local BattleCardSlotTemplate = BaseClass("BattleCardSlotTemplate")

function BattleCardSlotTemplate:__init()
  self.id = 0
  self.mastery = 0
  self.season = 0
  self.slot_id = 0
  self.type = 0
  self.slot_condition = ""
end

function BattleCardSlotTemplate:__delete()
  self.id = nil
  self.mastery = nil
  self.season = nil
  self.slot_id = nil
  self.type = nil
  self.slot_condition = nil
end

function BattleCardSlotTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.mastery = rowData:getValue("mastery") or 0
  self.season = rowData:getValue("season") or 0
  self.slot_id = rowData:getValue("slot_id") or 0
  self.type = rowData:getValue("type") or 0
  self.slot_condition = rowData:getValue("slot_condition") or ""
end

return BattleCardSlotTemplate
