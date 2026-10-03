local base = UIBaseContainer
local UIRewardRankItem = BaseClass("UIRewardRankItem", UIBaseContainer)
local __RankBg = {
  [1] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png",
  [2] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png",
  [3] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png",
  [4] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png"
}
local __RankIcon = {
  [1] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang01.png",
  [2] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang02.png",
  [3] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang03.png"
}

function UIRewardRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIRewardRankItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRewardRankItem:ComponentDefine()
  self.imgBg = self:AddComponent(UIImage, "bg")
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "nameText")
  self.textPower = self:AddComponent(UITextMeshProUGUIEx, "powerTxt")
  self.imgFirst = self:AddComponent(UIImage, "firstImg")
  self.textNum = self:AddComponent(UITextMeshProUGUIEx, "num")
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.compUIPlayerHead:SetEnableClickShowInfo(true)
  self.imgAlliance = self:AddComponent(UIImage, "allianceImg")
  self.textRank = self:AddComponent(UITextMeshProUGUIEx, "rankTxt")
end

function UIRewardRankItem:ComponentDestroy()
  self.imgBg = nil
  self.textName = nil
  self.textPower = nil
  self.imgFirst = nil
  self.imgSecond = nil
  self.imgThird = nil
  self.textNum = nil
  self.compUIPlayerHead = nil
  self.imgAlliance = nil
  self.textRank = nil
end

function UIRewardRankItem:DataDefine()
end

function UIRewardRankItem:DataDestroy()
  self.data = nil
end

function UIRewardRankItem:OnAddListener()
  base.OnAddListener(self)
end

function UIRewardRankItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIRewardRankItem:ReInit(data, isSelf)
  self.data = data
  if self.data then
    if isSelf then
      self.compUIPlayerHead:SetAsMyself()
      self:UpdateUI()
      self.textPower:SetText(self.data.score)
      self.textName:SetText(LuaEntry.Player.name)
    else
      self.compUIPlayerHead:SetHeadAndFrame(self.data.uid, self.data.pic, self.data.picver, nil, self.data.headSkinId, self.data.headSkinET)
      self.textName:SetText(self.data.name)
      self:UpdateUI()
      if self.data.rank > 3 then
        self.imgBg:LoadSprite(__RankBg[4])
      else
        self.imgBg:LoadSprite(__RankBg[self.data.rank])
      end
      self.textPower:SetText(self.data.score)
    end
  end
end

function UIRewardRankItem:UpdateUI()
  if self.data.rank > 3 or self.data.rank < 1 then
    self.textRank.gameObject:SetActive(true)
    self.textNum.gameObject:SetActive(false)
    if self.data.rank < 1 then
      self.textRank:SetLocalText("challenge_zombie_no_rank")
    else
      self.textRank:SetText(self.data.rank)
    end
    self.imgFirst.gameObject:SetActive(false)
  else
    self.imgFirst.gameObject:SetActive(true)
    self.imgFirst:LoadSprite(__RankIcon[self.data.rank])
    self.imgFirst:SetNativeSize()
    self.textRank.gameObject:SetActive(false)
    self.textNum.gameObject:SetActive(true)
    self.textNum:SetText(self.data.rank)
  end
end

return UIRewardRankItem
