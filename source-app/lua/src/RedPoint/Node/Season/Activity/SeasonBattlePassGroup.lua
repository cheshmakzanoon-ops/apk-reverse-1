local RedPoint = BaseClass("SeasonBattlePassGroup", RedPointGroup)

function RedPoint:__init(nodeName)
  self.isSimpleCount = true
  self:AddListener(EventId.SeasonMainViewOpen, self.Update)
  self:AddListener(EventId.LWSeasonBattlePassTabRedPoint, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update(activityId)
  if activityId and self.activityId ~= tostring(activityId) then
    return
  end
  local actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  if actData and actData.GetRedNum then
    for i = 1, 3 do
      local node = self:GetOrAddChild(RedDef.SeasonBattlePassTab, i)
      node:SetCount(actData:GetRedNum(i))
    end
  else
    self:Reset()
  end
end

return RedPoint
