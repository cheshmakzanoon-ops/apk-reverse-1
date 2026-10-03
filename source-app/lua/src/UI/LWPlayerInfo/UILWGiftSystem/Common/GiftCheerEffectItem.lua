local base = UIBaseContainer
local GiftCheerEffectItem = BaseClass("GiftCheerEffectItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local bubblePath = "Assets/Main/Sprites/UI/LWUIGiftSystem/zyf_songlizujian_qipao1.png"
local UICommonHead = require("Framework.UI.Component.UICommonHead")

function GiftCheerEffectItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GiftCheerEffectItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GiftCheerEffectItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.compQL = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.imgIconL = self.viewSkin:AddComponent(self, UIImage, 3)
  self.compQR = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.imgIconR = self.viewSkin:AddComponent(self, UIImage, 5)
  self.imgQipaoR = self.viewSkin:AddComponent(self, UIImage, 6)
  self.imgQipaoL = self.viewSkin:AddComponent(self, UIImage, 7)
end

function GiftCheerEffectItem:ComponentDestroy()
  self.viewSkin = nil
  self.compUIPlayerHead = nil
  self.compQL = nil
  self.imgIconL = nil
  self.compQR = nil
  self.imgIconR = nil
  self.imgQipaoR = nil
  self.imgQipaoL = nil
end

function GiftCheerEffectItem:DataDefine()
  self.playerUid = nil
end

function GiftCheerEffectItem:DataDestroy()
  self.playerUid = nil
end

function GiftCheerEffectItem:ReInit(playerUid, isLeft, giftId)
  self.playerUid = playerUid
  local userInfo = ChatInterface.getUserData(playerUid)
  local giftIconPath = DataCenter.GiftSystemManager:GetGiftIconByGroup(giftId)
  self.imgQipaoR:LoadSpriteAsync(bubblePath)
  self.imgQipaoL:LoadSpriteAsync(bubblePath)
  local iconCom = isLeft and self.imgIconL or self.imgIconR
  self.compQL:SetActive(isLeft)
  self.compQR:SetActive(not isLeft)
  iconCom:LoadSpriteAsync(giftIconPath)
  self.compUIPlayerHead:SetHeadAndFrame(userInfo.uid, userInfo.headPic, userInfo.headPicVer, false, userInfo.headSkinId, userInfo.headSkinET)
end

function GiftCheerEffectItem:UpdateDataUserInfo(uid)
  if self.playerUid == uid then
    local userInfo = ChatInterface.getUserData(self.playerUid)
    self.compUIPlayerHead:SetHeadAndFrame(userInfo.uid, userInfo.headPic, userInfo.headPicVer, false, userInfo.headSkinId, userInfo.headSkinET)
  end
end

function GiftCheerEffectItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.UpdateDataUserInfo)
end

function GiftCheerEffectItem:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.UpdateDataUserInfo)
  base.OnRemoveListener(self)
end

return GiftCheerEffectItem
