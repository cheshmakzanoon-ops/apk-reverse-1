local LWUINewBeeMigrateCtrl = BaseClass("LWUINewBeeMigrateCtrl", UIBaseCtrl)
local NBM_MSG_SEND_TIME = 0

function LWUINewBeeMigrateCtrl:ClearData()
  NBM_MSG_SEND_TIME = 0
end

function LWUINewBeeMigrateCtrl:CloseSelf()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUINewBeeMigrate) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUINewBeeMigrate)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUINewBeeMigrateLoading) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUINewBeeMigrateLoading, {anim = false})
  end
end

function LWUINewBeeMigrateCtrl:OnCustomKeyCodeEscape()
end

function LWUINewBeeMigrateCtrl:HandleNewBeeMigrateMsg(status, accept)
  local remainTime = UITimeManager:GetInstance():GetServerTime() - NBM_MSG_SEND_TIME
  Logger.LogInfo("[LWUINewBeeMigrateCtrl:HandleNewBeeMigrateMsg] costTime=", remainTime, ", status=", status, ", accept=", tostring(accept))
  if accept and status == 0 and remainTime < 3000 then
    TimerManager:GetInstance():DelayInvoke(function()
      self:DealNewBeeMigrate(status, accept)
    end, (3000 - remainTime) / 1000)
  else
    self:DealNewBeeMigrate(status, accept)
  end
end

function LWUINewBeeMigrateCtrl:DealNewBeeMigrate(status, accept)
  LuaEntry.Player:ClearNewBeeMigrate()
  if accept and status == 0 then
    CS.ApplicationLaunch.Instance:ReloadGame()
  else
    self:CloseSelf()
    if not CS.ApplicationLaunch.Instance.Loading.IsLoading then
      CS.ApplicationLaunch.Instance.Loading:CloseUILoading()
    else
      CS.ApplicationLaunch.Instance.Loading.isCanCloseLoading = true
    end
    DataCenter.LoginPopManager:LoginPop()
    if status == 1 then
      UIUtil.ShowTipsId("newbee_migration_tips1019")
    end
  end
end

function LWUINewBeeMigrateCtrl:SendNewBeeMigrateMsg(accept)
  NBM_MSG_SEND_TIME = UITimeManager:GetInstance():GetServerTime()
  local newBeeMigrateWay = LuaEntry.Player:GetNewBeeMigrateWay()
  if 2 < newBeeMigrateWay then
    self:HandleNewBeeMigrateMsg(0, accept)
  else
    SFSNetwork.SendMessage(MsgDefines.NewBeeMigrate, accept)
  end
end

return LWUINewBeeMigrateCtrl
