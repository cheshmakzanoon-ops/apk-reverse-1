local PushHunterActivityShrinkCircleMessage = BaseClass("PushHunterActivityShrinkCircleMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushHunterActivityShrinkCircleMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushHunterActivityShrinkCircleMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonHunterManager:OnServerInfoChange(t)
end

function PushHunterActivityShrinkCircleMessage:GetTestData()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local data = {
    LastServerList = {
      {lastWolfNum = 0, sid = 122},
      {lastWolfNum = 1, sid = 129},
      {lastWolfNum = 0, sid = 131},
      {lastWolfNum = 0, sid = 146},
      {lastWolfNum = 0, sid = 600},
      {lastWolfNum = 0, sid = 604},
      {lastWolfNum = 0, sid = 699}
    },
    banServerList = {
      {
        banTime = curTime + 2592000,
        sid = 210
      },
      {
        banTime = curTime + 2592000,
        sid = 102
      }
    },
    waitBanServerList = {
      {
        lastWolfNum = 1,
        banTime = curTime + 2592000,
        sid = 123
      },
      {
        lastWolfNum = 0,
        banTime = curTime + 2592000,
        sid = 555
      }
    }
  }
  return data
end

return PushHunterActivityShrinkCircleMessage
