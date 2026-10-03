local BattleCardDeckTemplate = BaseClass("BattleCardDeckTemplate")

function BattleCardDeckTemplate:__init()
  self.id = 0
  self.deck_name = ""
  self.deck_icon_up = ""
  self.deck_icon_down = ""
  self.deck_info = ""
  self.deck_banner = ""
  self.deck_color = ""
end

function BattleCardDeckTemplate:__delete()
  self.id = nil
  self.deck_name = nil
  self.deck_icon_up = nil
  self.deck_icon_down = nil
  self.deck_info = nil
  self.deck_banner = nil
  self.deck_color = nil
end

function BattleCardDeckTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.deck_name = rowData:getValue("deck_name") or ""
  self.deck_icon_up = rowData:getValue("deck_icon_up") or ""
  self.deck_icon_down = rowData:getValue("deck_icon_down") or ""
  self.deck_info = rowData:getValue("deck_info") or ""
  self.deck_banner = rowData:getValue("deck_banner") or ""
  self.deck_color = rowData:getValue("deck_color") or ""
end

return BattleCardDeckTemplate
