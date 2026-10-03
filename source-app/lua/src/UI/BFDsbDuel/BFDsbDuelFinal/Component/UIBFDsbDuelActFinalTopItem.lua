local base = UIBaseContainer
local UIBFDsbDuelActFinalTopItem = BaseClass("UIBFDsbDuelActFinalTopItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActFinalTopItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActFinalTopItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActFinalTopItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textServerAndAbbrTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
end

function UIBFDsbDuelActFinalTopItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textServerAndAbbrTxt = nil
  self.textName = nil
  self.textRank = nil
end

function UIBFDsbDuelActFinalTopItem:DataDefine()
end

function UIBFDsbDuelActFinalTopItem:DataDestroy()
end

function UIBFDsbDuelActFinalTopItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActFinalTopItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActFinalTopItem:SetData(data)
  self:SetActive(data ~= nil)
  if data then
    self.textRank:SetText(data.rank)
    self.textName:SetText(data.name)
    self.textServerAndAbbrTxt:SetText(string.format("#%s [%s]", data.serverId, data.abbr))
    self.imgIcon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, data.icon))
    if data.allianceId == LuaEntry.Player.allianceId then
      self.textName:SetColorHex("#54C4F2")
      self.textServerAndAbbrTxt:SetColorHex("#54C4F2")
    else
      self.textName:SetColorHex("#FFFFFF")
      self.textServerAndAbbrTxt:SetColorHex("#FFFFFF")
    end
  end
end

return UIBFDsbDuelActFinalTopItem
