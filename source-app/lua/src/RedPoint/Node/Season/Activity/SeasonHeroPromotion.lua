local RedPoint = BaseClass("SeasonHeroPromotion", RedPointNode)
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function RedPoint:__init(nodeName)
  self.isSimpleCount = true
  self:AddListener(EventId.LWSeasonHeroPromote, self.Update)
  self:AddListener(EventId.SeasonMainViewOpen, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:SetCountBoolean(SeasonRedPointUtils.SeasonHeroPromotionRedPoint(activityId, true))
end

function RedPoint:Update()
  if not self.activityId then
    return
  end
  self:SetCountBoolean(SeasonRedPointUtils.SeasonHeroPromotionRedPoint(self.activityId, true))
end

return RedPoint
