local RedPoint = BaseClass("SeasonMainReward", RedPointNode)
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function RedPoint:__init(nodeName)
  self:AddListener(EventId.OnEnterWorld, self.Update)
  self:AddListener(EventId.SeasonMainViewClose, self.Update)
  self:AddListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.Update)
end

function RedPoint:SetData()
  self:Update()
end

function RedPoint:Update()
  self:SetCountBoolean(SeasonRedPointUtils.SeasonMainRewardBtnRed())
end

return RedPoint
