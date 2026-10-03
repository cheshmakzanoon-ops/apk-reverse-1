local base = UIBaseContainer
local UIChatMonment = BaseClass("UIChatMonment", UIBaseContainer)
local UIChatMonmentMsgArea = require("UI.UIChatNewV2.Component.Monment.UIChatMonmentMsgArea")
local UIChatNotMonmentCom = require("UI.UIChatNewV2.Component.Monment.UIChatNotMonmentCom")
local timeout = 5

function UIChatMonment:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UIChatMonment:ComponentDefine()
  self.monmentMsgArea = self:AddComponent(UIChatMonmentMsgArea, "Monment_Scroll_View")
  self.notMonmentCom = self:AddComponent(UIChatNotMonmentCom, "notMoment")
  self.loadingImg = self:AddComponent(UIImage, "momentLoading")
  self.notMonmentCom:SetOnRefreshCallBack(function()
    self:UpdateMsg(true)
  end)
end

function UIChatMonment:OnDestroy()
  self:RemoveDelay()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatMonment:DataDefine()
  self.group = nil
end

function UIChatMonment:DataDestroy()
  self.group = nil
end

function UIChatMonment:ComponentDestroy()
  self.monmentMsgArea = nil
  self.notMonmentCom = nil
  self.loadingImg = nil
end

function UIChatMonment:UpdateMsg(noCooldown)
  local clearAndGet = ChatInterface.getMoment():IsCanGetNewData(self.group)
  self:RemoveDelay()
  if clearAndGet or noCooldown then
    ChatInterface.getMoment():ClearMomentRoom(self.group)
    ChatInterface.getMoment():GetMomentServerByGroup(self.group)
    self.monmentMsgArea:SetActive(false)
    self.notMonmentCom:SetActive(false)
    self.loadingImg:SetActive(true)
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      self:RefreshMomentDatasByGroup(self.group)
    end, timeout)
  else
    self:RefreshMomentDatasByGroup(self.group)
  end
end

function UIChatMonment:RemoveDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function UIChatMonment:ReInit(group)
  self.group = group
  self.monmentMsgArea:SetGroupType(group)
  self.monmentMsgArea._scrollView:MovePanelToItemIndex(0, 0)
  self:UpdateMsg()
end

function UIChatMonment:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_MOMENT_MSG_UPDATE, self.RefreshMomentDatasByGroup)
  self:AddUIListener(ChatEventEnum.CHAT_MOMENT_MYSEND, self.UpdateMsg)
  self:AddUIListener(ChatEventEnum.ChatDeleteMessage, self.RefreshMomentDatasByGroup)
end

function UIChatMonment:RefreshMomentDatasByGroup(group)
  if self.group ~= group then
    return
  end
  self:RemoveDelay()
  self.loadingImg:SetActive(false)
  local room = ChatInterface.getMoment():GetMomentData(group)
  if room then
    self.msgs = room.msgs
    if #self.msgs == 0 then
      self.monmentMsgArea:SetActive(false)
      self.notMonmentCom:SetActive(true)
      self.notMonmentCom:ReInit(group)
    else
      self.notMonmentCom:SetActive(false)
      self.monmentMsgArea:SetActive(true)
      self.monmentMsgArea:RefreshRoomData(group)
    end
  end
end

function UIChatMonment:UpdateMessage()
  if self.group then
    self:RefreshMomentDatasByGroup(self.group)
  end
end

function UIChatMonment:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(ChatEventEnum.CHAT_MOMENT_MSG_UPDATE, self.RefreshMomentDatasByGroup)
  self:RemoveUIListener(ChatEventEnum.CHAT_MOMENT_MYSEND, self.UpdateMsg)
  self:RemoveUIListener(ChatEventEnum.ChatDeleteMessage, self.RefreshMomentDatasByGroup)
end

return UIChatMonment
