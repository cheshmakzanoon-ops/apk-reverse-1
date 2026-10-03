local RedPoint = BaseClass("SeasonTrendsReward", RedPointNode)
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function RedPoint:__init(nodeName)
  self:AddListener(EventId.LWSeasonTrendsRewardRedPoint, self.Update)
  self:AddListener(EventId.LWSeasonTrendsDonateSuccess, self.Update)
end

function RedPoint:SetData()
  self:Update()
end

function RedPoint:Update()
  self:SetCountBoolean(SeasonRedPointUtils.SeasonTrendRewardRedPoint())
end

return RedPoint
