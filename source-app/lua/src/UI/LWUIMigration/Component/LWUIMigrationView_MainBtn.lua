local LWUIMigrationView_MainBtn = BaseClass("LWUIMigrationView_MainBtn", UIButton)
local base = UIButton
local tip_path = "Tip"
local time_text_path = "Tip/TimeText"
local CHECK_TIME = 60000

function LWUIMigrationView_MainBtn:OnCreate()
  base.OnCreate(self)
  self.tip = self:AddComponent(UIImage, tip_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self:SetOnClick(function()
    local mgr = DataCenter.ActMigrationManager
    local myInfo = mgr:GetMyInfo()
    if myInfo == nil then
      return
    end
    if myInfo.applyState == 2 then
      local _, stageInfo = mgr:GetCurStageInfo()
      if stageInfo ~= nil and stageInfo.state == ActMigrationState.Migrate then
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationResult)
        return
      end
    end
    local mailUuid = myInfo.mailUuid
    if not string.IsNullOrEmpty(mailUuid) then
      local mailInfo = DataCenter.MailDataManager:GetMailInfoById(mailUuid)
      if mailInfo and mailInfo.status == 0 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, mailUuid)
        DataCenter.MailDataManager:ReadMail(mailUuid)
        UIUtil.ShowTipsId(myInfo.applyState == 2 and "migration_activity_interface_10072" or "migration_activity_interface_10073")
        EventManager:GetInstance():Broadcast(EventId.ActMigrationInfoUpdate)
        return
      end
    end
  end)
end

function LWUIMigrationView_MainBtn:Refresh()
  local mgr = DataCenter.ActMigrationManager
  local flag = mgr:CheckCanMigrate()
  self:SetActive(flag)
  if flag then
    local _, stageInfo = mgr:GetCurStageInfo()
    self.endTime = mgr:GetStageEndTime(stageInfo)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    flag = 0 < remainTime and remainTime <= CHECK_TIME
    self.tip:SetActive(flag)
    self:Update1000MS()
  end
end

function LWUIMigrationView_MainBtn:Update1000MS()
  if not self:GetActive() then
    return
  end
  if not self.tip:GetActive() then
    return
  end
  if self.endTime == nil then
    self.tip:SetActive(false)
    return
  end
  local timeMgr = UITimeManager:GetInstance()
  local curTime = timeMgr:GetServerTime()
  local remainTime = self.endTime - curTime
  if 0 < remainTime and remainTime <= CHECK_TIME then
    local _, _, minute, second = timeMgr:MilliSecondToFmtFormat(remainTime)
    self.time_text:SetText(string.format("%02d:%02d", minute, second))
  else
    self.endTime = nil
    self.tip:SetActive(false)
    self:Refresh()
  end
end

return LWUIMigrationView_MainBtn
