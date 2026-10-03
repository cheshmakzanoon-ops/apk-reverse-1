local RedPoint = BaseClass("SeasonWeekCardGroup", RedPointGroup)
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function RedPoint:__init(nodeName)
  self.isSimpleCount = true
  self:AddListener(EventId.LWSeasonWeekCardTabRedPoint, self.Update)
end

function RedPoint:SetData()
  local playerSeasonInfo = DataCenter.SeasonDataManager.playerSeasonInfo
  local week_card = playerSeasonInfo and playerSeasonInfo:GetConfig() and playerSeasonInfo:GetConfig().week_card
  if week_card then
    self:Update(week_card)
  end
end

function RedPoint:Update(cardId)
  node = self:GetOrAddChild(RedDef.SeasonWeekDailyGift)
  node:SetCountBoolean(SeasonRedPointUtils.GetWeekDailyGift(cardId))
end

return RedPoint
