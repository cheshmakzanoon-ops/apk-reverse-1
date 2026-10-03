local MailSurfingBattle = BaseClass("MailSurfingBattle")
local LWSurfingBattleMailRankingInfo = require("DataCenter.LWSurfing.LWSurfingBattleMailRankingInfo")

function MailSurfingBattle:__init()
  self.rankList = {}
  self.rankType = -1
end

function MailSurfingBattle:__delete()
  self.rankList = nil
  self.rankType = nil
end

function MailSurfingBattle:ParseContent(mailContent)
  if table.IsNullOrEmpty(mailContent) then
    return
  end
  if mailContent.rank then
    local rankList = mailContent.rank
    for i, v in pairs(rankList) do
      local rankingInfo = LWSurfingBattleMailRankingInfo.New()
      rankingInfo:InitData(v)
      table.insert(self.rankList, rankingInfo)
    end
  end
  if mailContent.rankType then
    self.rankType = mailContent.rankType
  end
end

function MailSurfingBattle:GetRankList()
  return self.rankList
end

function MailSurfingBattle:GetRankType()
  return self.rankType
end

return MailSurfingBattle
