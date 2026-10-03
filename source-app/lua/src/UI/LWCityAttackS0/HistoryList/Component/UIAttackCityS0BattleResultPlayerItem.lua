local base = UIBaseContainer
local UIAttackCityS0BattleResultPlayerItem = BaseClass("UIAttackCityS0BattleResultPlayerItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIAttackCityS0BattleResultPlayerItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAttackCityS0BattleResultPlayerItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAttackCityS0BattleResultPlayerItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.playerHead = self.viewSkin:AddComponent(self, UICommonHead, 2)
  self.imgRankingBg = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textRanking = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnThumbs = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnThumbs:SetOnClick(function()
    self:OnBtnThumbsClick()
  end)
end

function UIAttackCityS0BattleResultPlayerItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.playerHead = nil
  self.imgRankingBg = nil
  self.textRanking = nil
  self.btnThumbs = nil
end

function UIAttackCityS0BattleResultPlayerItem:DataDefine()
end

function UIAttackCityS0BattleResultPlayerItem:DataDestroy()
end

function UIAttackCityS0BattleResultPlayerItem:OnAddListener()
  base.OnAddListener(self)
end

function UIAttackCityS0BattleResultPlayerItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAttackCityS0BattleResultPlayerItem:OnBtnThumbsClick()
  if self.rankData.isThumbsUp then
    UIUtil.ShowTipsId("new_city_activity_battle_tips1064")
  else
    DataCenter.AttackCityS0DataManager:SendThumpsUpRewardMsg(self.cityId, self.rankData.roleInfo.uid)
  end
end

function UIAttackCityS0BattleResultPlayerItem:ReInit(data, index, cityId)
  if data then
    self.cityId = cityId
    self.rankData = data
    local bgPath = "Assets/Main/Sprites/UI/UIAttackCityS0/UIAttackCityS0Main/lrb_csjs_jilu_0%s.png"
    self.imgBg:LoadSprite(string.format(bgPath, index))
    local rankPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang0%s.png"
    self.imgRankingBg:LoadSprite(string.format(rankPath, index))
    self.textRanking:SetText(index)
    self.playerHead.gameObject:SetActive(true)
    self.playerHead:SetData(data.roleInfo.uid, data.roleInfo.pic, data.roleInfo.picver)
    self.gameObject:SetActive(true)
  else
    self.gameObject:SetActive(false)
  end
end

return UIAttackCityS0BattleResultPlayerItem
