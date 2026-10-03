local MailZombieRush = BaseClass("MailZombieRush")
local LWZombieRushMailRankingInfo = require("DataCenter.LWZombieRush.LWZombieRushMailRankingInfo")

function MailZombieRush:__init()
  self.rankList = {}
end

function MailZombieRush:__delete()
  self.rankList = nil
end

function MailZombieRush:ParseContent(mailContent)
  if table.IsNullOrEmpty(mailContent) then
    return
  end
  if mailContent.rank then
    local rankList = mailContent.rank
    for i, v in pairs(rankList) do
      local rankingInfo = LWZombieRushMailRankingInfo.New()
      rankingInfo:InitData(v)
      table.insert(self.rankList, rankingInfo)
    end
  end
end

function MailZombieRush:GetRankList()
  return self.rankList
end

return MailZombieRush
