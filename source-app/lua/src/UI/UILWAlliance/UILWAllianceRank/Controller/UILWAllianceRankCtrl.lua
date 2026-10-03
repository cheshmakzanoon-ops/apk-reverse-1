local UILWAllianceRankCtrl = BaseClass("UILWAllianceRankCtrl", UIBaseCtrl)

function UILWAllianceRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAllianceRank)
end

function UILWAllianceRankCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UILWAllianceRankCtrl:GetRankData(rankType)
  local rankData = {}
  local selfData
  local all = DataCenter.AllianceMemberDataManager:GetAllMember()
  if all ~= nil then
    for k, v in pairs(all) do
      local memberData = {}
      memberData.rank = -1
      memberData.isSelf = false
      memberData.data = v
      table.insert(rankData, memberData)
    end
    local sortName = self:GetValueNameByType(rankType)
    if rankType == AlRankType.DonateDaily or rankType == AlRankType.DonateWeek then
      local timeName = self:GetTimeNameByDonateRankType(rankType)
      table.sort(rankData, function(a, b)
        if a.data[sortName] ~= b.data[sortName] then
          return a.data[sortName] > b.data[sortName]
        end
        if a.data[timeName] and b.data[timeName] and a.data[timeName] ~= b.data[timeName] then
          return a.data[timeName] < b.data[timeName]
        end
        return a.data.uid < b.data.uid
      end)
    else
      table.sort(rankData, function(a, b)
        if a.data[sortName] ~= b.data[sortName] then
          return a.data[sortName] > b.data[sortName]
        end
        if a.data.mainCityLv ~= b.data.mainCityLv then
          return a.data.mainCityLv > b.data.mainCityLv
        end
        if a.data.power ~= b.data.power then
          return a.data.power > b.data.power
        end
        return a.data.uid > b.data.uid
      end)
    end
    local selfUid = LuaEntry.Player.uid
    for k, v in ipairs(rankData) do
      v.rank = k
      if v.data.uid == selfUid then
        v.isSelf = true
        selfData = v
      end
    end
  end
  return rankData, selfData
end

function UILWAllianceRankCtrl:GetValueNameByType(rankType)
  local sortName = "power"
  if rankType == AlRankType.Power then
    sortName = "power"
  elseif rankType == AlRankType.Kill then
    sortName = "armyKill"
  elseif rankType == AlRankType.DonateDaily then
    sortName = "donateTodayProgress"
  elseif rankType == AlRankType.DonateWeek then
    sortName = "donateWeeklyProgress"
  end
  return sortName
end

function UILWAllianceRankCtrl:GetTimeNameByDonateRankType(donateRankType)
  local timeName = "donateTime"
  if donateRankType == AlRankType.DonateDaily then
    timeName = "donateTime"
  elseif donateRankType == AlRankType.DonateWeek then
    timeName = "weeklyDonateTime"
  end
  return timeName
end

return UILWAllianceRankCtrl
