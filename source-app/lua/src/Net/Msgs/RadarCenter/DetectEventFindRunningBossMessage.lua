local DetectEventFindRunningBossMessage = BaseClass("DetectEventFindRunningBossMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.refreshTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = t.refreshTime - curTime
    local timeTxt = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
    local showTxt = Localization:GetString("radar_tips_2", timeTxt)
    UIUtil.ShowTips(showTxt)
  elseif t.bossInfo then
    GoToUtil.CloseAllWindows()
    DataCenter.WorldPointWaitOpenManager.byDetect = 1
    GoToUtil.MoveToWorldMarchAndOpen(t.bossInfo.point_id, t.bossInfo.uuid, LuaEntry.Player:GetSelfServerId(), 0)
  end
end

DetectEventFindRunningBossMessage.OnCreate = OnCreate
DetectEventFindRunningBossMessage.HandleMessage = HandleMessage
return DetectEventFindRunningBossMessage
