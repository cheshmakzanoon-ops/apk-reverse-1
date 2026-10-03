local RedPoint = BaseClass("SeasonCrossDeclareWar", RedPointNode)
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function RedPoint:__init(nodeName)
  self:AddListener(EventId.LWSeasonCrossDeclareWarInfo, self.Update)
  self:AddListener(EventId.LWSeasonCrossDeclareWarRedPointUpdate, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  self:SetCount(SeasonRedPointUtils.GetCrossDeclareWarRedPoint())
end

return RedPoint
