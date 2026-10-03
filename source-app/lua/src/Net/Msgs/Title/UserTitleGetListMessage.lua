local UserTitleGetListMessage = BaseClass("UserTitleGetListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserTitleGetListMessage:OnCreate(param)
  base.OnCreate(self)
end

local function __SortTitleList(a, b)
  if a.order == b.order then
    return a.rank < b.rank
  end
  return a.order > b.order
end

function UserTitleGetListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local ls = t.ls
  if not ls then
    return
  end
  for i, v in pairs(ls) do
    local info = DataCenter.PlayerTitleTemplateManager:GetTitleInfo(v.cfgId)
    if info then
      v.order = info.order
    else
      v.order = 0
    end
  end
  table.sort(ls, __SortTitleList)
  DataCenter.PlayerInfoDataManager:UpdateTitleList(ls)
end

function UserTitleGetListMessage:GetTestData()
  local result = {
    title = 0,
    ls = {}
  }
  local playerInfo = UIUtil.GetPlayerInfoShowByUid(LuaEntry.Player.uid)
  if not playerInfo then
    return result
  end
  if playerInfo.title then
    result.title = playerInfo.title
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if playerInfo.titleWall then
    for i, v in pairs(playerInfo.titleWall) do
      local titleInfo = {}
      titleInfo.globalNum = 0
      titleInfo.uid = LuaEntry.Player.uid
      titleInfo.cfgId = v.title
      titleInfo.rank = i
      titleInfo.createTime = curTime - math.random(10000, 10000000)
      titleInfo.endTime = curTime + math.random(-1000000, 1000000)
      titleInfo.position = v.position
      table.insert(result.ls, titleInfo)
    end
  end
  local idList = {
    10001,
    10002,
    10003,
    10004,
    10005,
    10006,
    10007,
    10008,
    10009,
    10010,
    10011,
    10012
  }
  for i, v in pairs(idList) do
    local titleInfo = {}
    titleInfo.globalNum = 0
    titleInfo.uid = LuaEntry.Player.uid
    titleInfo.cfgId = v
    titleInfo.rank = i
    titleInfo.createTime = curTime - math.random(10000, 10000000)
    titleInfo.endTime = curTime + math.random(-1000000, 1000000)
    titleInfo.position = 0
    table.insert(result.ls, titleInfo)
  end
  return result
end

return UserTitleGetListMessage
