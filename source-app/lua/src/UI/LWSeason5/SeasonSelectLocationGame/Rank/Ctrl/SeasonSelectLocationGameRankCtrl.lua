local SeasonSelectLocationGameRankCtrl = BaseClass("SeasonSelectLocationGameRankCtrl", UIBaseCtrl)

function SeasonSelectLocationGameRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonSelectLocationGameRank)
end

function SeasonSelectLocationGameRankCtrl:ParseRankData(rankData)
  if rankData == nil then
    return nil
  end
  local rankType = rankData.rankType
  local serverId = checknumber(rankData.serverId)
  local rankList = rankData.rankList
  local ret = {}
  for _, v in ipairs(rankList) do
    local oneData = {}
    oneData.uid = v.uid
    oneData.rank = v.rank
    oneData.type = rankType
    oneData.score = v.score
    oneData.time = checknumber(v.costtimesec)
    oneData.pic = v.pic
    oneData.picVer = v.picVer
    oneData.headFrame = DataCenter.DecorationDataManager:GetHeadFrame(v.headSkinId, v.headSkinET, false)
    if rankType == DataCenter.SeasonSelectLocationGameManager.RankType.Server then
      oneData.serverId = v.sid
      oneData.firstName = string.format("# %s", v.sid)
    else
      oneData.serverId = v.serverId
      oneData.firstName = v.name
      if string.IsNullOrEmpty(v.abbr) then
        oneData.firstName = v.name
      else
        oneData.firstName = "[" .. v.abbr .. "] " .. v.name
      end
    end
    table.insert(ret, oneData)
  end
  return ret
end

function SeasonSelectLocationGameRankCtrl:GetSelfData(rankData)
  if rankData == nil then
    return nil
  end
  local rankType = rankData.rankType
  local serverId = checknumber(rankData.serverId)
  if rankType == DataCenter.SeasonSelectLocationGameManager.RankType.Server then
    return nil
  end
  local oneData = {}
  oneData.uid = LuaEntry.Player.uid
  oneData.serverId = LuaEntry.Player.serverId
  oneData.type = rankType
  oneData.firstName = LuaEntry.Player:GetFullName()
  oneData.pic = LuaEntry.Player:GetPic()
  oneData.picVer = LuaEntry.Player.picVer
  oneData.headFrame = LuaEntry.Player:GetHeadBgImg()
  local curData = rankData.userRankInfo
  if curData ~= nil then
    oneData.score = checknumber(curData.score)
    oneData.rank = checknumber(curData.rank)
    oneData.time = checknumber(curData.costtimesec)
  end
  return oneData
end

return SeasonSelectLocationGameRankCtrl
