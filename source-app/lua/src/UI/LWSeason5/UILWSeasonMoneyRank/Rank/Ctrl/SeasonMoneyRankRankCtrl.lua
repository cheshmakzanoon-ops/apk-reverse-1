local SeasonMoneyRankRankCtrl = BaseClass("SeasonMoneyRankRankCtrl", UIBaseCtrl)

function SeasonMoneyRankRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonMoneyRankRank)
end

function SeasonMoneyRankRankCtrl:ParseRankData(rankData)
  if rankData == nil then
    return nil
  end
  local rankType = rankData.rankType
  local rankList = rankData.ranks
  local ret = {}
  for _, v in ipairs(rankList) do
    local oneData = {}
    oneData.uid = v.uid
    oneData.allianceId = v.allianceId
    oneData.serverId = v.serverId
    oneData.type = rankType
    oneData.isAlliance = self:IsAlliance(rankType)
    oneData.rank = v.rank
    oneData.score = v.score
    oneData.pic = v.pic
    oneData.picVer = v.picver
    oneData.headFrame = DataCenter.DecorationDataManager:GetHeadFrame(v.headSkinId, v.headSkinET, false)
    oneData.icon = v.icon
    oneData.firstName = v.name
    if not string.IsNullOrEmpty(v.abbr) then
      oneData.firstName = "[" .. v.abbr .. "] " .. v.name
    end
    table.insert(ret, oneData)
  end
  return ret
end

function SeasonMoneyRankRankCtrl:GetSelfData(rankData)
  if rankData == nil then
    return nil
  end
  local rankType = rankData.rankType
  local oneData = {}
  oneData.uid = LuaEntry.Player.uid
  oneData.allianceId = LuaEntry.Player.allianceId
  oneData.serverId = LuaEntry.Player.serverId
  oneData.type = rankType
  oneData.isAlliance = self:IsAlliance(rankType)
  if oneData.isAlliance then
    local allianceBaseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceBaseData ~= nil then
      oneData.icon = allianceBaseData.icon
    end
    oneData.firstName = LuaEntry.Player:GetFullAllianceName()
  else
    oneData.pic = LuaEntry.Player:GetPic()
    oneData.picVer = LuaEntry.Player.picVer
    oneData.headFrame = LuaEntry.Player:GetHeadBgImg()
    oneData.firstName = LuaEntry.Player:GetFullName()
  end
  local curData = rankData.self
  if curData ~= nil then
    oneData.rank = checknumber(curData.rank)
    oneData.score = checknumber(curData.score)
  end
  return oneData
end

function SeasonMoneyRankRankCtrl:IsAlliance(rankType)
  rankType = toInt(rankType)
  local rankEnum = DataCenter.SeasonMoneyRankManager.RankType
  return rankType == rankEnum.AllAlliance or rankType == rankEnum.BankManageAlliance or rankType == rankEnum.BankRobAlliance or rankType == rankEnum.TrainAlliance
end

return SeasonMoneyRankRankCtrl
