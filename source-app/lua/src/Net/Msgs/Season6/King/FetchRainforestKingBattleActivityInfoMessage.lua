local FetchRainforestKingBattleActivityInfoMessage = BaseClass("FetchRainforestKingBattleActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function TestData()
  TimerManager:GetInstance():DelayInvoke(function()
    local now = UITimeManager:GetInstance():GetServerTime()
    local mySeverId = LuaEntry.Player:GetSourceServerId()
    local data = {
      serverId = mySeverId,
      destroyList = {65, 66},
      gatherDestroyList = {},
      weekShieldInfo = {
        {week = 1, breakShieldTime = 1111},
        {week = 2, breakShieldTime = 1111},
        {week = 3, breakShieldTime = 1111},
        {week = 4, breakShieldTime = 1111}
      },
      curWeek = 1,
      isFightEnd = 0,
      breakShieldTime = 210,
      curUuid = "uuid",
      heroEventId = 400002,
      id = 1200116,
      startTime = 12121,
      endTime = 12133,
      endViewTime = 1231123,
      needMainCityLevel = 3
    }
    local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonRainforestKingBattle.Type)
    if actData ~= nil then
      data.startTime = actData.startTime
      data.endTime = actData.endTime
      data.endViewTime = actData.endViewTime
    end
    data.gatherDestroyList["65"] = now
    DataCenter.SeasonRainforestKingBattleManager:SetBattleInfo(data)
  end, 1)
end

function FetchRainforestKingBattleActivityInfoMessage:OnCreate()
  base.OnCreate(self)
end

function FetchRainforestKingBattleActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonRainforestKingBattleManager:SetBattleInfo(t)
end

return FetchRainforestKingBattleActivityInfoMessage
