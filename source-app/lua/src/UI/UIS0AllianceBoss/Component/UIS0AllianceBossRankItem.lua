local base = UIBaseContainer
local UIS0AllianceBossRankItem = BaseClass("UIS0AllianceBossRankItem", UIBaseContainer)
local UICommonHead = require("Framework.UI.Component.UICommonHead")
local BG_PIC_PATH = {
  "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png",
  "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png",
  "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png"
}
local RANK_ICON_PATH = {
  "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang01.png",
  "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang02.png",
  "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang03.png"
}

function UIS0AllianceBossRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIS0AllianceBossRankItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossRankItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBgTop3 = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgIconTop3 = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textRankNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgBgNormal = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgBgSelf = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textRankNormal = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 7)
  self.textPlayerName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textPlayerTotalDamage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
end

function UIS0AllianceBossRankItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBgTop3 = nil
  self.imgIconTop3 = nil
  self.textRankNum = nil
  self.imgBgNormal = nil
  self.imgBgSelf = nil
  self.textRankNormal = nil
  self.compUIPlayerHead = nil
  self.textPlayerName = nil
  self.textPlayerTotalDamage = nil
end

function UIS0AllianceBossRankItem:DataDefine()
end

function UIS0AllianceBossRankItem:DataDestroy()
end

function UIS0AllianceBossRankItem:OnAddListener()
  base.OnAddListener(self)
end

function UIS0AllianceBossRankItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIS0AllianceBossRankItem:RefreshItem(info)
  if info == nil then
    return
  end
  local rank = info.rank
  local isSelf = info.isSelf
  if 3 < rank then
    self.imgBgSelf:SetActive(isSelf)
    self.imgBgNormal:SetActive(not isSelf)
    self.imgBgTop3:SetActive(false)
    self.textRankNormal:SetActive(true)
    self.textRankNormal:SetText(rank)
  elseif rank ~= -1 and rank <= 3 then
    self.imgBgTop3:SetActive(true)
    self.imgBgNormal:SetActive(false)
    self.imgBgSelf:SetActive(false)
    self.textRankNormal:SetActive(false)
    self.imgBgTop3:LoadSpriteAuto(BG_PIC_PATH[rank])
    self.imgIconTop3:LoadSpriteAuto(RANK_ICON_PATH[rank])
    self.textRankNum:SetText(rank)
  else
    self.imgBgTop3:SetActive(false)
    self.imgBgNormal:SetActive(true)
    self.imgBgSelf:SetActive(false)
    self.textRankNormal:SetActive(true)
  end
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(info.headSkinId, info.headSkinET, false)
  self.compUIPlayerHead:SetData(info.uid, info.headPic, info.headPicVer, nil, headBgImg)
  self.textPlayerName:SetText(info.name)
  local dmgStr = string.GetFormattedStr2(info.damage)
  self.textPlayerTotalDamage:SetText(dmgStr)
end

return UIS0AllianceBossRankItem
