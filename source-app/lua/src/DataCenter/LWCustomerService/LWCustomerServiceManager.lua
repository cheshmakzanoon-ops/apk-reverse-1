local LWCustomerServiceManager = BaseClass("LWCustomerServiceManager")
local Localization = CS.GameEntry.Localization

function LWCustomerServiceManager:__init()
  self.customerServiceRedPointCount = CS.AIHelp.AIHelpProxy.UnreadMsgCount or 0
  self.hasCustomerServiceRedPoint = self.customerServiceRedPointCount > 0
  self.GMPushRed = false
  
  function self.TimerAction()
    self:CheckCustomerServiceRedPoint()
  end
  
  self.timer = TimerManager:GetInstance():GetTimer(10, self.TimerAction, self, false, false, false)
  self.timer:Start()
end

function LWCustomerServiceManager:__delete()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  self.TimerAction = nil
  self.GMPushRed = nil
  self.customerServiceRedPointCount = 0
  self.hasCustomerServiceRedPoint = false
end

function LWCustomerServiceManager:Startup()
end

function LWCustomerServiceManager:GetCustomerServiceRedPointData()
  return self.hasCustomerServiceRedPoint
end

function LWCustomerServiceManager:GetCustomerServiceUnreadCount()
  return self.customerServiceRedPointCount
end

function LWCustomerServiceManager:CloseCustomerServiceRedPointData()
end

function LWCustomerServiceManager:DoCloseCustomerServiceRedPointData()
  if self.customerServiceRedPointCount > 0 or self.GMPushRed then
    self.customerServiceRedPointCount = 0
    self.hasCustomerServiceRedPoint = false
    self:CloseGMPushRed()
    EventManager:GetInstance():Broadcast(EventId.UpdateAIHelpRedPoint)
    EventManager:GetInstance():Broadcast(EventId.UpdateAIHelpUnreadCount, {count = 0})
  end
end

function LWCustomerServiceManager:OpenGMPushRed()
  if not self.GMPushRed then
    self.GMPushRed = true
    self:CheckCustomerServiceRedPoint()
  end
end

function LWCustomerServiceManager:CloseGMPushRed()
  if self.GMPushRed then
    self.GMPushRed = false
    SFSNetwork.SendMessage(MsgDefines.ResetCustomerEntrance)
  end
end

function LWCustomerServiceManager:CheckCustomerServiceRedPoint()
  local unreadCount = CS.AIHelp.AIHelpProxy.UnreadMsgCount or 0
  if self.GMPushRed then
    unreadCount = math.max(unreadCount, 1)
  end
  local show = 0 < unreadCount
  if self.hasCustomerServiceRedPoint ~= show then
    self.hasCustomerServiceRedPoint = show
    EventManager:GetInstance():Broadcast(EventId.UpdateAIHelpRedPoint)
    Logger.Log("[AiHelp] UpdateAIHelpRedPoint: " .. tostring(show))
  end
  if unreadCount ~= self.customerServiceRedPointCount then
    self.customerServiceRedPointCount = unreadCount
    EventManager:GetInstance():Broadcast(EventId.UpdateAIHelpUnreadCount, {count = unreadCount})
    Logger.Log("[AiHelp] UpdateAIHelpUnreadCount: " .. tostring(unreadCount))
  end
end

function LWCustomerServiceManager:OpenCustomerServiceByVipLevel(message, isMessaging)
  local vip = DataCenter.VIPManager.vipinfo
  local id = isMessaging and "E010" or "E006"
  if vip and vip.level then
    if vip.level <= 7 then
      id = isMessaging and "E010" or "E006"
    elseif vip.level <= 12 then
      id = isMessaging and "E011" or "E007"
    else
      id = isMessaging and "E012" or "E008"
    end
  end
  self:OpenMessage(id, message)
end

function LWCustomerServiceManager:OpenMessage(entranceId, message)
  CS.AIHelp.AIHelpProxy.Show(entranceId, Localization:GetString(message))
  self:CloseCustomerServiceRedPointData()
end

return LWCustomerServiceManager
