local RedPoint = BaseClass("SeasonCrossAttackCity", RedPointNode)
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function RedPoint:__init(nodeName)
  self:AddListener(EventId.LWSeasonCrossAttackCityInfo, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  self:SetCount(SeasonRedPointUtils.GetCrossAttackCityRedPoint())
end

return RedPoint
