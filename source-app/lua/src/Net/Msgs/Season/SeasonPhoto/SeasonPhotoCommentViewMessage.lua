local SeasonPhotoCommentViewMessage = BaseClass("SeasonPhotoCommentViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPhotoCommentViewMessage:OnCreate(targetSeason, targetAllianceId)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetSeason", targetSeason)
  self.sfsObj:PutUtfString("targetAllianceId", targetAllianceId)
end

local function __SortComment(a, b)
  return a.refreshTime > b.refreshTime
end

function SeasonPhotoCommentViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local SeasonPhotoCommentInfo = require("DataCenter.SeasonPhoto.SeasonPhotoCommentInfo")
  local list, thumbsUpDic = {}, {}
  if t.thumbsUpArr then
    for i, v in ipairs(t.thumbsUpArr) do
      thumbsUpDic[v.targetUuid] = v
    end
  end
  local commentArr = t.photoCommentArr or {}
  for i, v in ipairs(commentArr) do
    local data = SeasonPhotoCommentInfo.New()
    data:UpdateData(v)
    data:UpdateThumbsUp(data.uuid and thumbsUpDic[data.uuid])
    list[i] = data
  end
  local id = DataCenter.SeasonPhotoManager:GetPhotoId(t.targetSeason, t.targetAllianceId)
  table.sort(list, __SortComment)
  DataCenter.SeasonPhotoManager.commentDic[id] = list
  EventManager:GetInstance():Broadcast(EventId.SeasonPhotoCommentView, id)
end

function SeasonPhotoCommentViewMessage:GetTestData(targetSeason, targetAllianceId)
  local t = {}
  local curTime = UITimeManager:GetInstance():GetServerTime()
  t.targetSeason = targetSeason
  t.targetAllianceId = targetAllianceId
  t.photoCommentArr = {
    {
      uid = tostring(math.random(1, 100000)),
      uuid = 100,
      name = string.format("User%d", math.random(1, 100)),
      picVer = 0,
      pic = "",
      firstRecordTime = curTime - 3600,
      refreshTime = curTime - 1800,
      message = "Nice photo!Nice photo!Nice photo!Nice photo!Nice photo!Nice photo!Nice photo!Nice photo!Nice photo!Nice photo!Nice photo!Nice photo!Nice photo!"
    },
    {
      uid = tostring(math.random(1, 100000)),
      uuid = 101,
      name = string.format("User%d", math.random(1, 100)),
      picVer = 0,
      pic = "",
      firstRecordTime = curTime - 7200,
      refreshTime = curTime - 3600,
      message = "Great job!Great job!Great job!Great job!Great job!Great job!Great job!Great job!Great job!Great job!Great job!Great job!Great job!Great job!Great job!Great job!"
    },
    {
      uid = tostring(math.random(1, 100000)),
      uuid = 102,
      name = string.format("User%d", math.random(1, 100)),
      picVer = 0,
      pic = "",
      firstRecordTime = curTime - 10800,
      refreshTime = curTime - 5400,
      message = "Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!Amazing work!"
    },
    {
      uid = tostring(math.random(1, 100000)),
      uuid = 103,
      name = string.format("User%d", math.random(1, 100)),
      picVer = 0,
      pic = "",
      firstRecordTime = curTime - 14400,
      refreshTime = curTime - 7200,
      message = "Love this!"
    },
    {
      uid = tostring(math.random(1, 100000)),
      uuid = 104,
      name = string.format("User%d", math.random(1, 100)),
      picVer = 0,
      pic = "",
      firstRecordTime = curTime - 18000,
      refreshTime = curTime - 9000,
      message = "So beautiful!"
    }
  }
  t.thumbsUpArr = {
    {
      targetUuid = 100,
      thumbsArray = {
        {
          thumbsType = 1,
          thumbsCount = math.random(0, 2),
          hasThumbs = math.random(0, 1) == 1
        },
        {
          thumbsType = 2,
          thumbsCount = math.random(0, 2),
          hasThumbs = math.random(0, 1) == 1
        }
      }
    },
    {
      targetUuid = 103,
      thumbsArray = {
        {
          thumbsType = 1,
          thumbsCount = math.random(0, 2),
          hasThumbs = math.random(0, 1) == 1
        },
        {
          thumbsType = 2,
          thumbsCount = math.random(0, 2),
          hasThumbs = math.random(0, 1) == 1
        }
      }
    },
    {
      targetUuid = 104,
      thumbsArray = {
        {
          thumbsType = 1,
          thumbsCount = math.random(0, 2),
          hasThumbs = math.random(0, 1) == 1
        },
        {
          thumbsType = 2,
          thumbsCount = math.random(0, 2),
          hasThumbs = math.random(0, 1) == 1
        }
      }
    }
  }
  return t
end

return SeasonPhotoCommentViewMessage
