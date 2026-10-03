local SeasonTetrisGameDataSource = require("UI.LWSeason1.UILWSeasonTetris.Common.SeasonTetrisGameDataSource")
local SeasonSelectLocationGameDataSource = require("UI.LWSeason5.SeasonSelectLocationGame.Common.SeasonSelectLocationGameDataSource")
local SeasonTetrisGameData = require("DataCenter.SeasonTetris.SeasonTetrisGameData")
local SeasonTetrisManager = BaseClass("SeasonTetrisManager")

function SeasonTetrisManager:__init()
  self.ActId = nil
  self.GameData = nil
  self.rankData = {
    [1] = {},
    [2] = {}
  }
  self.reward = {}
  self.MapX = 8
  self.MapY = 8
  self.PieceX = 5
  self.PieceY = 5
  self.BlockSizeSmall = 38
  self.BlockSizeLarge = 74
  self.BlockScale = self.BlockSizeLarge / self.BlockSizeSmall
  self.ShadowAlpha = 0.3
  self.GameMode = {
    Tetris = 0,
    SeasonSelectLocation = 2,
    UnKnown = 999
  }
end

function SeasonTetrisManager:__delete()
  self.ActId = nil
  self.GameData = nil
  self.rankData = nil
  self.reward = nil
end

function SeasonTetrisManager:SetActId(actId)
  self.ActId = actId
  local gameMode = self:GetGameMode()
  if gameMode == self.GameMode.Tetris then
    self.DataSource = SeasonTetrisGameDataSource.New("old")
  elseif gameMode == self.GameMode.SeasonSelectLocation then
    self.DataSource = SeasonSelectLocationGameDataSource.New("new")
  else
    self.DataSource = nil
  end
end

function SeasonTetrisManager:GetActData()
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.ActId)
end

function SeasonTetrisManager:GetActCell()
  if checknumber(self.ActId) > 0 then
    return LocalController:instance():getLine(TableName.Activity, checknumber(self.ActId))
  end
  return nil
end

function SeasonTetrisManager:GetCurLevelIndex()
  return self.DataSource:GetCurLevelIndex()
end

function SeasonTetrisManager:GetCurLevelCell()
  if self.GameData ~= nil then
    return self.GameData.GameCell
  end
  return nil
end

function SeasonTetrisManager:GetTotalLevelCountToday()
  return self.DataSource:GetTotalLevelCountToday()
end

function SeasonTetrisManager:IsValid()
  local actData = self:GetActData()
  if actData == nil then
    return false
  end
  return true
end

function SeasonTetrisManager:GetRankConfigId()
  if self:IsValid() then
    local actData = self:GetActData()
    return actData.rankRewardParam[1]
  end
end

function SeasonTetrisManager:StopAMBSound()
end

function SeasonTetrisManager:ResumeAMBSound()
end

function SeasonTetrisManager:IsInGame()
  if self.GameData ~= nil then
    return checknumber(self.GameData.StartTime) > 0
  end
  return false
end

function SeasonTetrisManager:IsAllFinished()
  local curLevel = self:GetCurLevelIndex()
  local curTotal = self:GetTotalLevelCountToday()
  return 0 < curTotal and curLevel > curTotal
end

function SeasonTetrisManager:GetLeftCount()
  local curLevel = self:GetCurLevelIndex()
  local curTotal = self:GetTotalLevelCountToday()
  return math.max(0, curTotal - curLevel + 1)
end

function SeasonTetrisManager:HandleTetrisRewardList(msg, rewardType)
  self.reward[rewardType] = msg
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisGetRankReward)
end

function SeasonTetrisManager:GetRankData(type)
  if self.rankData == nil then
    return nil
  end
  return self.rankData[type] or nil
end

function SeasonTetrisManager:UpdateRank(t)
  local rankList = {}
  for k, v in pairs(t.userranklist) do
    local oneData = PlayerRankData.New()
    oneData:ParseData(v)
    oneData:SetRank(v.rank)
    table.insert(rankList, oneData)
  end
  local parseDataPerson = {
    rankArr = rankList,
    owner = t.userinfo
  }
  self.rankData[SeasonTetrisRankType.Owner] = parseDataPerson
  local langList = {}
  for k, v in pairs(t.langranklist) do
    local oneData = PlayerRankData.New()
    oneData:ParseData(v)
    oneData:SetRank(v.rank)
    table.insert(langList, oneData)
  end
  local parseDataLang = {
    rankArr = langList,
    owner = t.langinfo
  }
  self.rankData[SeasonTetrisRankType.Language] = parseDataLang
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisGetRankInfo)
end

function SeasonTetrisManager:GetRewardList(rewardType)
  return self.reward[rewardType] or {}
end

function SeasonTetrisManager:HandleGameData(res, trigger)
  if res ~= nil then
    if self.GameData == nil then
      self.GameData = SeasonTetrisGameData.New()
    end
    self.GameData:SetData(res)
    if trigger then
      EventManager:GetInstance():Broadcast(EventId.SeasonTetrisGetInfoPayloadUpdate)
    end
  end
end

function SeasonTetrisManager:SendGetInfo()
  if self:IsValid() then
    SFSNetwork.SendMessage(MsgDefines.ActivityTetrisInfo)
  end
end

function SeasonTetrisManager:OnGetInfoCallback(res)
  if res ~= nil then
    self:HandleGameData(res, true)
    EventManager:GetInstance():Broadcast(EventId.SeasonTetrisGetInfoPayload)
  end
end

function SeasonTetrisManager:SendStart()
  SFSNetwork.SendMessage(MsgDefines.ActivityTetrisStart)
end

function SeasonTetrisManager:OnStartCallback(res)
  if res ~= nil then
    self:HandleGameData(res, true)
    self.DataSource:HandleStart(res)
    EventManager:GetInstance():Broadcast(EventId.SeasonTetrisStartGame)
  end
end

function SeasonTetrisManager:SendReset(isRestart)
  self.DataSource:SendReset(isRestart)
end

function SeasonTetrisManager:OnResetCallback(res)
  if res ~= nil then
    self:HandleGameData(res, true)
    EventManager:GetInstance():Broadcast(EventId.SeasonTetrisResetUpdate)
  end
end

function SeasonTetrisManager:SendGetRank()
  SFSNetwork.SendMessage(MsgDefines.ActivityTetrisRanklist)
end

function SeasonTetrisManager:SendPut(id, x, y)
  local args = {}
  args.pieceid = id
  args.x = x
  args.y = y
  SFSNetwork.SendMessage(MsgDefines.ActivityTetrisPut, args)
end

function SeasonTetrisManager:OnPutCallback(res)
  if res ~= nil then
    if checknumber(res.needreset) == 1 then
      self:HandleGameData(res, false)
      EventManager:GetInstance():Broadcast(EventId.SeasonTetrisResetWithError)
      return
    elseif checknumber(res.iswin) == 1 then
      self:HandleWin(res)
    elseif self.GameData ~= nil then
      if table.IsNullOrEmpty(self.GameData.PieceList) then
        self.GameData:HandlePieceList(res.piecelist)
        EventManager:GetInstance():Broadcast(EventId.SeasonTetrisPieceListUpdate)
      end
      self.GameData:HandlePutTimes(res.puttimes)
      self.GameData:HandleFinishItem(res.itemList)
      self.GameData.IsFail = checknumber(res.isFail)
    end
    EventManager:GetInstance():Broadcast(EventId.SeasonTetrisOnPutCallback)
  end
end

function SeasonTetrisManager:GetGameMode()
  local actCell = self:GetActCell()
  if actCell ~= nil then
    return checknumber(actCell.para_4)
  end
  return self.GameMode.UnKnown
end

function SeasonTetrisManager:HandleWin(res)
  local evtData = {}
  evtData.CfgId = self.GameData.GameCell.id
  evtData.Time = toInt(res.stagecostinmills)
  evtData.PutTimes = toInt(res.puttimes)
  evtData.ItemList = res.itemList
  self.DataSource:HandleWin(res, evtData)
  self:HandleGameData(res, true)
end

function SeasonTetrisManager:OpenSuccess(winData)
  self.DataSource:OpenSuccess(winData)
end

function SeasonTetrisManager:OpenFail()
  local data = {}
  if self.GameData ~= nil and self.GameData.GameCell ~= nil then
    data.CfgId = self.GameData.GameCell.id
  end
  self.DataSource:OpenFail(data)
end

return SeasonTetrisManager
