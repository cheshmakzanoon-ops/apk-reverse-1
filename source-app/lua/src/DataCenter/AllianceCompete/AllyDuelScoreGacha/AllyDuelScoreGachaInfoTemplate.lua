local AllyDuelScoreGachaInfoTemplate = BaseClass("AllyDuelScoreGachaInfoTemplate")

function AllyDuelScoreGachaInfoTemplate:__init()
  self.id = 0
  self.groupId = 0
  self.season = 0
  self.costNum = 0
  self.buttonPara = 0
end

function AllyDuelScoreGachaInfoTemplate:__delete()
  self.id = nil
  self.groupId = nil
  self.season = nil
  self.costNum = nil
  self.buttonPara = nil
end

function AllyDuelScoreGachaInfoTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.groupId = tonumber(row:getValue("group_id")) or 0
  self.season = tonumber(row:getValue("season")) or 0
  self.costNum = 1
  self.buttonPara = 3
end

return AllyDuelScoreGachaInfoTemplate
