local RedPoint = BaseClass("SeasonWarZoneOutpostAttack", RedPointNode)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.OutpostBattleInfoUpdate, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  local FetchOutpostBattleInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostBattleInfoMessage")
  self:SetCountBoolean(FetchOutpostBattleInfo and FetchOutpostBattleInfo.HasRed())
end

return RedPoint
