local RedPoint = BaseClass("SeasonVirusResearch", RedPointNode)
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function RedPoint:__init(nodeName)
  self.isSimpleCount = true
  self:AddListener(EventId.SeasonVirusBossReddot, self.Update)
  self:AddListener(EventId.RefreshItems, self.Update)
  self:AddListener(EventId.SeasonPreSpreadResearchInfo, self.Update)
  self:AddListener(EventId.SeasonPreSpreadResearchExpChange, self.Update)
  self:AddListener(EventId.SeasonResearchLevelUpClose, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  self:SetCountBoolean(SeasonRedPointUtils.GetVirusResearchRedPoint())
end

return RedPoint
