local base = UIBaseContainer
local BattleCheer = BaseClass("BattleCheer", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function BattleCheer:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function BattleCheer:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BattleCheer:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.compQL = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compIconL = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compQR = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compIconR = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compUIPlayerHead:SetEnableClickShowInfo(true, false)
end

function BattleCheer:ComponentDestroy()
  self.viewSkin = nil
  self.compUIPlayerHead = nil
  self.compQL = nil
  self.compIconL = nil
  self.compQR = nil
  self.compIconR = nil
end

function BattleCheer:SetData(bCheerS, player, bTest)
  self.compQL:SetActive(not bCheerS)
  self.compQR:SetActive(bCheerS)
  self.compUIPlayerHead:SetActive(player ~= nil or bTest)
  if player ~= nil then
    self.compUIPlayerHead:SetHeadAndFrame(player.uid, player.headPic, player.headPicVer, nil, player.headSkinId, player.headSkinET)
  end
end

return BattleCheer
