local S6MilitaryTrendPopupCtrl = BaseClass("S6MilitaryTrendPopupCtrl", UIBaseCtrl)

function S6MilitaryTrendPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.S6MilitaryTrendPopupView)
end

function S6MilitaryTrendPopupCtrl:GetRankList(rankPayload)
  if rankPayload == nil then
    return nil
  end
  local ranks = rankPayload.ranks
  if table.IsNullOrEmpty(ranks) then
    return nil
  end
  local tradeCells = {}
  local serverId = LuaEntry.Player:GetSourceServerId()
  local mapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(serverId)
  local table_name = SeasonUtil.GetWorldCityTableNameByServerId(serverId)
  LocalController:instance():visitTable(table_name, function(id, cell)
    if cell.type == WorldAllianceCityType.TradingStation and cell.zoneId == mapIndex then
      table.insert(tradeCells, DeepCopy(cell))
    end
  end)
  table.sort(tradeCells, function(a, b)
    return a.level > b.level or a.level == b.level and a.id < b.id
  end)
  
  local function getTradeId(rank)
    if rank <= table.count(tradeCells) then
      return tradeCells[rank].id
    end
    return 0
  end
  
  local cellCount = 0
  local rankIndex = 0
  local rankList = {}
  for _, rankData in pairs(ranks) do
    local data = {}
    data.Uid = rankData.uid
    data.Rank = rankData.rank
    data.IsSelf = false
    data.IsAlliance = false
    data.Pic = rankData.pic
    data.PicVer = rankData.picver
    data.HeadFrame = rankData.headFrame
    local userName = rankData.name
    if not string.IsNullOrEmpty(rankData.abbr) then
      userName = string.format("[%s] %s", rankData.abbr, rankData.name)
    end
    data.Name = string.format("#%s %s", rankData.srcServer, userName)
    data.ExtraData = {}
    data.ExtraData.Score = rankData.score
    if not string.IsNullOrEmpty(rankData.allianceId) then
      rankIndex = rankIndex + 1
      data.ExtraData.TradeId = getTradeId(rankIndex)
    end
    table.insert(rankList, data)
    cellCount = cellCount + 1
    if 50 <= cellCount and rankIndex >= table.count(tradeCells) then
      break
    end
  end
  return rankList
end

function S6MilitaryTrendPopupCtrl:GetSettlementRankList(ranks)
  if table.IsNullOrEmpty(ranks) then
    return nil
  end
  local rankList = {}
  for _, rankData in pairs(ranks) do
    local data = {}
    data.Uid = rankData.uid
    data.Rank = rankData.rank
    data.IsSelf = false
    data.IsAlliance = false
    if rankData.UserInfo ~= nil then
      data.Pic = rankData.UserInfo.pic
      data.PicVer = rankData.UserInfo.picVer
      data.HeadFrame = rankData.UserInfo:GetHeadBgImg()
      data.Name = string.format("#%s %s", rankData.UserInfo.srcServer, rankData.UserInfo:GetShowName())
    end
    data.ExtraData = {}
    data.ExtraData.TradeId = rankData.tradeId
    data.ExtraData.RealTradeId = rankData.tradeId
    data.ExtraData.Score = rankData.score
    table.insert(rankList, data)
  end
  return rankList
end

function S6MilitaryTrendPopupCtrl:GetRankData(rankData, auto)
  if rankData == nil then
    return nil
  end
  local data = {}
  data.Uid = rankData.Uid
  data.Rank = rankData.Rank
  data.IsSelf = false
  data.IsAlliance = false
  data.ExtraData = {}
  data.ExtraData.Auto = auto
  if auto then
    data.ExtraData.Score = string.GetFormattedSeparatorNum(checknumber(rankData.MilitaryNum))
    data.ExtraData.Date = UITimeManager:GetInstance():GetTimeToMD(rankData.RefreshTime / 1000)
  else
    data.ExtraData.Time = UITimeManager:GetInstance():TimeStampToTimeForServer(rankData.RefreshTime)
  end
  if rankData.UserInfo ~= nil then
    data.Pic = rankData.UserInfo.pic
    data.PicVer = rankData.UserInfo.picVer
    data.HeadFrame = rankData.UserInfo:GetHeadBgImg()
    data.Name = string.format("#%s %s", rankData.UserInfo.srcServer, rankData.UserInfo:GetShowName())
  end
  return data
end

return S6MilitaryTrendPopupCtrl
