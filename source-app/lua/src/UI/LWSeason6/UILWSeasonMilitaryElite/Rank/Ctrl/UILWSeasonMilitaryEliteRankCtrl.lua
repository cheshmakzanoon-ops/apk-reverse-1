local UILWSeasonMilitaryEliteRankCtrl = BaseClass("UILWSeasonMilitaryEliteRankCtrl", UIBaseCtrl)

function UILWSeasonMilitaryEliteRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonMilitaryEliteRank)
end

function UILWSeasonMilitaryEliteRankCtrl:ParseRankData(rankData)
  if rankData == nil then
    return nil
  end
  local rankType = rankData.militaryRankId
  local rankList = rankData.ranks
  local ret = {}
  for _, v in ipairs(rankList) do
    local oneData = {}
    oneData.uid = v.uid
    oneData.militaryLevel = checknumber(v.militaryLevel)
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

function UILWSeasonMilitaryEliteRankCtrl:GetSelfData(rankData)
  if rankData == nil then
    return nil
  end
  local rankType = rankData.militaryRankId
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
    oneData.militaryLevel = checknumber(curData.militaryLevel)
  end
  return oneData
end

function UILWSeasonMilitaryEliteRankCtrl:IsAlliance(rankType)
  rankType = toInt(rankType)
  local rankEnum = DataCenter.SeasonMilitaryEliteManager.RankType
  return rankType == rankEnum.Alliance_All or rankType == rankEnum.Alliance_Kill or rankType == rankEnum.Alliance_Destroy or rankType == rankEnum.Alliance_Assistant or rankType == rankEnum.Alliance_Donate or rankType == rankEnum.Alliance_Enhance or rankType == rankEnum.Alliance_Game
end

return UILWSeasonMilitaryEliteRankCtrl
