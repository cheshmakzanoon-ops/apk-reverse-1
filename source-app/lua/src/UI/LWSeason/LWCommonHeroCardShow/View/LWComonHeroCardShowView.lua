local LWComonHeroCardShowView = BaseClass("LWComonHeroCardShowView", UIBaseView)
local base = UIBaseView
local LWHeroRankStar = require("UI.UIHero2.Common.LWHeroRankStar")
local panel_path = "UICommonRewardPopUp/Panel"
local title_name_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local img_bg_path = "content/newHero/UIHeroCellBig/LayerNormal/ImgBg"
local img_icon1_path = "content/newHero/UIHeroCellBig/LayerNormal/ImgBg/Mask/ImgIcon1"
local hero_rank_star_path = "content/newHero/UIHeroCellBig/HeroRankStar"
local u_i_common_reward_pop_up_path = "UICommonRewardPopUp"
local eff_ui_saiji_yingxiong_jinji_path = "Eff_ui_saiji_yingxiong_jinji"
local content_path = "content"
local mask_path = "mask"
local black_mask_path = "blackMask"
local hero_mask_path = "content/newHero/UIHeroCellBig/heroMask"
local level_bg_path = "content/newHero/UIHeroCellBig/LevelBg"

function LWComonHeroCardShowView:OnCreate()
  base.OnCreate(self)
  self.param, self.title, self.activityId = self:GetUserData()
  self:ComponentDefine()
  self.title_name:SetText(self.title)
  self:SetData(self.param)
end

function LWComonHeroCardShowView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWComonHeroCardShowView:ComponentDefine()
  self.btn = self:AddComponent(UIButton, panel_path)
  self.title_name = self:AddComponent(UIText, title_name_path)
  self.mask = self:AddComponent(UIBaseContainer, mask_path)
  self.mask:SetActive(false)
  self.blackMask = self:AddComponent(UIButton, black_mask_path)
  self.hero_mask = self:AddComponent(UIImage, hero_mask_path)
  self.hero_mask_Img = self.hero_mask.transform:GetComponent(typeof(CS.UnityEngine.UI.Image))
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf(self.activityId)
  end)
  self.level_bg = self:AddComponent(UIImage, level_bg_path)
  self.img_bg = self:AddComponent(UIImage, img_bg_path)
  self.img_icon1 = self:AddComponent(UIImage, img_icon1_path)
  self.hero_rank_star = self:AddComponent(LWHeroRankStar, hero_rank_star_path)
  self.u_i_common_reward_pop_up = self:AddComponent(UICanvasGroup, u_i_common_reward_pop_up_path)
  self.eff_ui_saiji_yingxiong_jinji = self:AddComponent(UIBaseContainer, eff_ui_saiji_yingxiong_jinji_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function LWComonHeroCardShowView:ComponentDestroy()
  self.btn = nil
  self.title_name = nil
  self.img_bg = nil
  self.img_icon1 = nil
  self.hero_rank_star = nil
  self.title = nil
  self.u_i_common_reward_pop_up = nil
  self.eff_ui_saiji_yingxiong_jinji = nil
  self.content = nil
  self.mask = nil
  self.blackMask = nil
  self.hero_mask = nil
  self.level_bg = nil
end

function LWComonHeroCardShowView:SetData(heroId)
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
  if heroData then
    local iconPath = HeroUtils.GetHeroIconPath(heroData.modelId, HeroIconType.half_portrait)
    self.img_icon1:LoadSpriteAuto(iconPath)
    self.img_bg:LoadSprite(HeroUtils.GetQualityIconPath(heroData.quality - 1, true, false))
    self.level_bg:LoadSprite(HeroUtils.GetLevelBg(heroData.quality - 1))
    self:SetHeroRank(heroData, true)
    self.hero_mask:SetColor(Color.New(1, 1, 1, 0))
    self.blackMask:SetActive(true)
    self.mask:SetActive(true)
    self.u_i_common_reward_pop_up:SetActive(false)
    self.eff_ui_saiji_yingxiong_jinji:SetActive(true)
    self.seq = DOTween.Sequence()
    self.seq:AppendInterval(0.1)
    self.seq:AppendCallback(function()
      self.hero_mask:SetColor(Color.New(1, 1, 1, 1))
      self:SetHeroRank(heroData, false)
      self.img_bg:LoadSprite(HeroUtils.GetQualityIconPath(heroData.quality, true, false))
      self.level_bg:LoadSprite(HeroUtils.GetLevelBg(heroData.quality))
    end)
    self.seq:Append(self.content.transform:DOShakePosition(0.5, 10, 20):OnComplete(function()
      self.u_i_common_reward_pop_up:SetActive(true)
    end))
    self.seq:Join(self.hero_mask_Img:DOFade(0, 0.5):OnComplete(function()
      self.hero_mask:SetColor(Color.New(1, 1, 1, 0))
    end):SetDelay(0.2))
    self.seq:OnComplete(function()
      self.mask:SetActive(false)
    end)
  end
end

function LWComonHeroCardShowView:SetHeroRank(heroData, isMax)
  if heroData:GetRank() == nil and not isMax then
    self.hero_rank_star:SetActive(false)
  else
    self.hero_rank_star:SetActive(true)
    if heroData and heroData.meta then
      local rank = heroData:GetRank()
      if isMax then
        rank = heroData.meta.maxRank
      end
      self.hero_rank_star:ShowRank(rank, heroData.meta.maxRank)
    end
  end
end

return LWComonHeroCardShowView
