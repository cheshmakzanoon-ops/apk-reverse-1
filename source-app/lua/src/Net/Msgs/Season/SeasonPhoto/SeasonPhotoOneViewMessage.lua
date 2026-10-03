local SeasonPhotoOneViewMessage = BaseClass("SeasonPhotoOneViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPhotoOneViewMessage:OnCreate(targetSeason, targetAllianceId)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetSeason", targetSeason)
  self.sfsObj:PutUtfString("targetAllianceId", targetAllianceId)
end

function SeasonPhotoOneViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if table.IsNullOrEmpty(t.alliancePhotoInfo) then
    return
  end
  local manager = DataCenter.SeasonPhotoManager
  local SeasonPhotoInfo = require("DataCenter.SeasonPhoto.SeasonPhotoInfo")
  local data = SeasonPhotoInfo.New()
  data:UpdateData(t.alliancePhotoInfo)
  manager.photoInfoDic[data.id] = data
  if t.userSeasonSettleRecordInfo then
    local SeasonPhotoSettleRecordInfo = require("DataCenter.SeasonPhoto.SeasonPhotoSettleRecordInfo")
    local settleData = SeasonPhotoSettleRecordInfo.New()
    settleData:UpdateData(t.userSeasonSettleRecordInfo)
    manager.userSettleRecordDic[settleData.id] = settleData
    local simpleData = manager:GetSelfPhotoSimple(data.season, data.allianceId)
    if simpleData then
      simpleData.abbr = data.abbr
      simpleData.photoConfigId = data.photoConfigId
      simpleData.picVer = data.picVer
      simpleData.seasonConfigId = data.seasonConfigId
    elseif data.allianceId == LuaEntry.Player.allianceId and data.season == DataCenter.SeasonDataManager:GetSeason() then
      if not manager.photoSimpleArr then
        manager.photoSimpleArr = {}
      end
      simpleData = {
        season = data.season,
        allianceId = data.allianceId,
        abbr = data.abbr,
        photoConfigId = data.photoConfigId,
        picVer = data.picVer,
        seasonConfigId = data.seasonConfigId
      }
      table.insert(manager.photoSimpleArr, simpleData)
      table.sort(manager.photoSimpleArr, function(a, b)
        return a.season > b.season
      end)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonPhotoOneView, {
    season = t.targetSeason,
    allianceId = t.targetAllianceId
  })
end

function SeasonPhotoOneViewMessage:GetTestData(targetSeason, targetAllianceId)
  local t = {}
  t.targetSeason = targetSeason
  t.targetAllianceId = targetAllianceId
  t.alliancePhotoInfo = {
    allianceId = targetAllianceId,
    season = targetSeason,
    seasonConfigId = 10001,
    photoConfigId = 10001,
    settleType = 1,
    leaderUid = "",
    serverId = 123,
    allianceName = "sdadw",
    abbr = "ssa",
    slotId = 0,
    icon = "1",
    picVer = 0,
    settleRank = 0,
    memberArr = {},
    picData = {}
  }
  t.userSeasonSettleRecordInfo = {
    season = 0,
    allianceId = "",
    settleType = 1,
    recordTime = 0,
    modifyPicTime = 0,
    commentTime = 0
  }
  return t
end

return SeasonPhotoOneViewMessage
