local base = UIBaseContainer
local UIBattlefieldDsbDuelBattleRankViewRankItem = BaseClass("UIBattlefieldDsbDuelBattleRankViewRankItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBattlefieldDsbDuelBattleRankViewRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBattlefieldDsbDuelBattleRankViewRankItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattlefieldDsbDuelBattleRankViewRankItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTmpRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTmpPlayerName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTmpScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 6)
end

function UIBattlefieldDsbDuelBattleRankViewRankItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.imgIcon = nil
  self.textTmpRank = nil
  self.textTmpPlayerName = nil
  self.textTmpScore = nil
  self.compUIPlayerHead = nil
end

function UIBattlefieldDsbDuelBattleRankViewRankItem:DataDefine()
end

function UIBattlefieldDsbDuelBattleRankViewRankItem:DataDestroy()
end

function UIBattlefieldDsbDuelBattleRankViewRankItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBattlefieldDsbDuelBattleRankViewRankItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

local __RankBg = {
  [1] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png",
  [2] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png",
  [3] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png"
}
local __RankIcon = {
  [1] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang01.png",
  [2] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang02.png",
  [3] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang03.png"
}
local defBg = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png"
local myBg = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5.png"

function UIBattlefieldDsbDuelBattleRankViewRankItem:GetBgPath(data)
  local bg, icon
  if data.myDog then
    bg = myBg
  else
    bg = __RankBg[data.rank] or defBg
  end
  icon = __RankIcon[data.rank]
  return bg, icon
end

function UIBattlefieldDsbDuelBattleRankViewRankItem:ReInit(index, data)
  self.textTmpRank:SetText(data.rank or "-")
  self.textTmpPlayerName:SetText(data.name or "")
  self.textTmpScore:SetText(string.GetFormattedSeparatorNum(data.score or 0))
  self.compUIPlayerHead:SetHead(data.uid, data.pic, data.picVer)
  local bg, icon = self:GetBgPath(data)
  self.imgBg:LoadSpriteAsync(bg)
  if icon then
    self.imgIcon:SetActive(true)
    self.imgIcon:LoadSpriteAsync(icon)
  else
    self.imgIcon:SetActive(false)
  end
end

return UIBattlefieldDsbDuelBattleRankViewRankItem
