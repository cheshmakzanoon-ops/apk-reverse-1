local base = UIAsyncContainer
local UIBFDsbDuelActFinalGroupItem = BaseClass("UIBFDsbDuelActFinalGroupItem", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActFinalGroupItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActFinalGroupItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActFinalGroupItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textRankTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textServerIdAbbrTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnIcon = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnIcon:SetOnClick(function()
    self:OnBtnIconClick()
  end)
end

function UIBFDsbDuelActFinalGroupItem:ComponentDestroy()
  self.viewSkin = nil
  self.textRankTxt = nil
  self.imgIcon = nil
  self.textServerIdAbbrTxt = nil
  self.textNameTxt = nil
  self.btnIcon = nil
end

function UIBFDsbDuelActFinalGroupItem:DataDefine()
end

function UIBFDsbDuelActFinalGroupItem:DataDestroy()
end

function UIBFDsbDuelActFinalGroupItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActFinalGroupItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActFinalGroupItem:SetData(data)
  self.data = data
  self.textRankTxt:SetText(data.rank)
  self.imgIcon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, data.icon))
  self.textServerIdAbbrTxt:SetText(string.format("#%s [%s]", data.serverId, data.abbr))
  self.textNameTxt:SetText(data.name)
  if data.allianceId == LuaEntry.Player.allianceId then
    self.textNameTxt:SetColorHex("#54C4F2")
    self.textServerIdAbbrTxt:SetColorHex("#54C4F2")
  else
    self.textNameTxt:SetColorHex("#FFFFFF")
    self.textServerIdAbbrTxt:SetColorHex("#FFFFFF")
  end
end

function UIBFDsbDuelActFinalGroupItem:OnBtnIconClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true, hideTop = false}, self.data.name, self.data.allianceId, self.data.serverId)
end

return UIBFDsbDuelActFinalGroupItem
