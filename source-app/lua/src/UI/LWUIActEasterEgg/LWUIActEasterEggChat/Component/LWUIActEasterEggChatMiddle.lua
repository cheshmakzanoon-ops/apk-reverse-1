local base = UIBaseContainer
local LWUIActEasterEggChatMiddle = BaseClass("LWUIActEasterEggChatMiddle", base)
local M = LWUIActEasterEggChatMiddle
local LWUIActEasterEggChatMessageArea = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.LWUIActEasterEggChatMessageArea")

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.scrollEggChatMessage = self:AddComponent(LWUIActEasterEggChatMessageArea, "messageScrollView")
  self.btnZone = self:AddComponent(UIButton, "btnZone")
  self.btnZone:SetOnClick(function()
    self:OnClickZone()
  end)
end

function M:ComponentDestroy()
  self.scrollEggChatMessage = nil
  self.btnZone = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EasterEggChatOnClickZone, self.OnClickZone)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.EasterEggChatOnClickZone, self.OnClickZone)
  base.OnRemoveListener(self)
end

function M:DataDefine()
  self.__reloadChatTimer = nil
  self.__firstTimeReloaded = nil
  self.__clickZoneCallback = nil
  self.__clickZoneToken = nil
end

function M:DataDestroy()
  if self.__reloadChatTimer then
    self.__reloadChatTimer:Stop()
    self.__reloadChatTimer = nil
  end
  self.__firstTimeReloaded = nil
  self.__clickZoneCallback = nil
  self.__clickZoneToken = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:OnChatNetErrorOrDisconnect()
  self.scrollEggChatMessage:OnChatNetErrorOrDisconnect()
end

function M:OnChatLoginSuccess()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
  if self.__firstTimeReloaded then
    self.scrollEggChatMessage:OnChatLoginSuccess()
  else
    if self.__reloadChatTimer then
      return
    end
    self.__reloadChatTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.__firstTimeReloaded = true
      self.scrollEggChatMessage:OnChatLoginSuccess()
    end, 0.2)
  end
end

function M:SetClickZoneActive(active, token, callback)
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

function M:OnClickZone()
  if self.__clickZoneCallback then
    self.__clickZoneCallback()
  end
end

return M
