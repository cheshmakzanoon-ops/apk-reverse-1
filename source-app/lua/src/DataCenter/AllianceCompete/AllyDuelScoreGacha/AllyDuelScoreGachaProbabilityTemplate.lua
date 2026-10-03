local AllyDuelScoreGachaProbabilityTemplate = BaseClass("AllyDuelScoreGachaProbabilityTemplate")

function AllyDuelScoreGachaProbabilityTemplate:__init()
  self.id = 0
  self.groupId = 0
  self.pos = 0
  self.reward = ""
  self.para = 0
  self.showPara = 0
end

function AllyDuelScoreGachaProbabilityTemplate:__delete()
  self.id = nil
  self.groupId = nil
  self.pos = nil
  self.reward = nil
  self.para = nil
  self.showPara = nil
end

function AllyDuelScoreGachaProbabilityTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.groupId = tonumber(row:getValue("group_id")) or 0
  self.pos = tonumber(row:getValue("pos")) or 0
  self.reward = tostring(row:getValue("reward")) or ""
  self.para = tonumber(row:getValue("para")) or 0
  self.showPara = tonumber(row:getValue("show_para")) or 0
  local line = LocalController:instance():getLine(TableName.RewardConfig, self.reward)
  if line ~= nil then
    self.itemId = tonumber(line:getValue("item"))
    self.itemCount = tonumber(line:getValue("num")) or 1
  end
end

function AllyDuelScoreGachaProbabilityTemplate:GetRewardConfig()
end

return AllyDuelScoreGachaProbabilityTemplate
