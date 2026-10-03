local ActivityValentineRankTemplate = BaseClass("ActivityValentineRankTemplate")
local Localization = CS.GameEntry.Localization

function ActivityValentineRankTemplate:__init()
  self.id = 0
  self.group = 0
  self.type = 0
  self.circulate = ""
  self.star = 0
  self.exp_cost = 0
  self.exp_all = 0
  self.reward_rank = ""
  self.reward_star = ""
  self.key_big = ""
  self.key_full = ""
  self.icon = ""
  self.reward_rank_status = ""
  self.index = 0
  self.frame = ""
  self.isTopRank = 0
  self.rankCount = 0
end

function ActivityValentineRankTemplate:__delete()
  self.id = nil
  self.group = nil
  self.type = nil
  self.circulate = nil
  self.star = nil
  self.exp_cost = nil
  self.exp_all = nil
  self.reward_rank = nil
  self.reward_star = nil
  self.key_big = nil
  self.key_full = nil
  self.icon = nil
  self.reward_rank_status = nil
  self.index = nil
  self.frame = nil
  self.isTopRank = nil
  self.rankCount = nil
end

function ActivityValentineRankTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or 0
  self.type = rowData:getValue("type") or 0
  self.circulate = rowData:getValue("circulate") or ""
  self.star = rowData:getValue("star") or 0
  self.exp_cost = rowData:getValue("exp_cost") or 0
  self.exp_all = rowData:getValue("exp_all") or 0
  self.reward_rank = rowData:getValue("reward_rank") or ""
  self.reward_star = rowData:getValue("reward_star") or ""
  self.key_big = rowData:getValue("key_big") or ""
  self.key_full = rowData:getValue("key_full") or ""
  self.icon = rowData:getValue("icon") or ""
  self.reward_rank_status = rowData:getValue("reward_rank_status") or ""
  self.index = rowData:getValue("index") or 0
  self.frame = rowData:getValue("frame") or ""
  self.isTopRank = toInt(rowData:getValue("isTopRank")) or 0
  self.rankCount = toInt(rowData:getValue("rankCount")) or 0
end

function ActivityValentineRankTemplate:GetRankFullName()
  if string.IsNullOrEmpty(self.key_full) then
    return
  end
  return Localization:GetString(self.key_full, self.star)
end

return ActivityValentineRankTemplate
