local base = UIBaseContainer
local UIAllianceStarMainChatMiddle = BaseClass("UIAllianceStarMainChatMiddle", base)
local compBook = {
  {
    path = "btnZone",
    name = "btnZone",
    type = UIButton,
    active = false,
    onClick = function(self)
      self:OnClickZone()
    end
  }
}

function UIAllianceStarMainChatMiddle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIAllianceStarMainChatMiddle:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceStarMainChatMiddle:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIAllianceStarMainChatMiddle:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIAllianceStarMainChatMiddle:OnAddListener()
  base.OnAddListener(self)
end

function UIAllianceStarMainChatMiddle:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAllianceStarMainChatMiddle:SetClickZoneActive(active, token, callback)
  if active then
    self.__clickZoneCallback = callback
    self.__clickZoneToken = token
    self.btnZone:SetActive(true)
    self.view:HideInteractionPanel()
  else
    if self.__clickZoneToken == token then
      self.__clickZoneCallback = nil
      self.__clickZoneToken = nil
      self.btnZone:SetActive(false)
    end
    self.view:ShowInteractionPanel()
  end
end

function UIAllianceStarMainChatMiddle:OnClickZone()
  if self.__clickZoneCallback then
    self.__clickZoneCallback()
  end
end

return UIAllianceStarMainChatMiddle
