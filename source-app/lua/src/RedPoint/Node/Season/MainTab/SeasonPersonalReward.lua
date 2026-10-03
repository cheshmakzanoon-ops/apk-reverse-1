local RedPoint = BaseClass("SeasonPersonalReward", RedPointGroup)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.LWSeasonPersonalRewardGetRedPoint)
end

function RedPoint:SetData()
  self:Update()
end

function RedPoint:Update()
  local seasonScoreTabRed = DataCenter.SeasonRewardDataManager.seasonScoreTabRed
  if seasonScoreTabRed then
    for k, v in pairs(seasonScoreTabRed) do
      if v ~= nil then
        self:LWSeasonPersonalRewardGetRedPoint(k)
      end
    end
  end
end

function RedPoint:LWSeasonPersonalRewardGetRedPoint(type)
  if type == SeasonScoreRewardPanelType.PersonalOccupyLand then
    return
  end
  local node = self:GetOrAddChild(RedDef.SeasonPersonalRewardItem, type)
  node:SetCountBoolean(DataCenter.SeasonRewardDataManager:IsGetRewardTabRed(type))
end

return RedPoint
