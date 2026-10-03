local base = UIBaseContainer
local UIChatViewNoticeMiddle = BaseClass("UIChatViewNoticeMiddle", base)
local UIChatViewMessageArea = require("UI.LWUIAllianceNoticeDetail.Component.UIChatViewNoticeRemark")
local compBook = {
  {
    path = "btnZone",
    name = "btnZone",
    type = UIButton,
    active = false,
    onClick = function(self)
      self:OnClickZone()
    end
  },
  {
    path = "Scroll_View_mainView",
    name = "scrollMsgs",
    type = UIChatViewMessageArea
  }
}

function UIChatViewNoticeMiddle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIChatViewNoticeMiddle:OnDestroy()
  if self.__reloadChatTimer then
    self.__reloadChatTimer:Stop()
    self.__reloadChatTimer = nil
  end
  self.__firstTimeReloaded = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatViewNoticeMiddle:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIChatViewNoticeMiddle:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIChatViewNoticeMiddle:UpdateMessages(room)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
  if self.__firstTimeReloaded then
    self.scrollMsgs:ReLoadChat()
  else
    if self.__reloadChatTimer then
      return
    end
    self.__reloadChatTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.__firstTimeReloaded = true
      self.scrollMsgs:ReLoadChat()
    end, 0.2)
  end
end

function UIChatViewNoticeMiddle:UpdateNoticeData(data)
  data.isNotice = true
  self.scrollMsgs:SetNoticeData(data)
end

function UIChatViewNoticeMiddle:SetClickZoneActive(active, token, callback)
  if active then
    self.__clickZoneCallback = callback
    self.__clickZoneToken = token
    self.btnZone:SetActive(true)
  elseif self.__clickZoneToken == token then
    self.__clickZoneCallback = nil
    self.__clickZoneToken = nil
    self.btnZone:SetActive(false)
  end
end

function UIChatViewNoticeMiddle:OnClickZone()
  if self.__clickZoneCallback then
    self.__clickZoneCallback()
  end
end

return UIChatViewNoticeMiddle
