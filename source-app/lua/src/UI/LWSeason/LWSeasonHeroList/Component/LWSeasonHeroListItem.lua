local LWSeasonHeroListItem = BaseClass("LWSeasonHeroListItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LWHeroRankStar = require("UI.UIHero2.Common.LWHeroRankStar")
local img_bg_path = "LayerNormal/ImgBg"
local img_icon1_path = "LayerNormal/ImgBg/Mask/ImgIcon1"
local level_bg_path = "LevelBg"
local frag_count_text_path = "LevelBg/fragCountText"
local job_icon_path = "typeLayOut/jobIcon"
local type_icon_path = "typeLayOut/TypeIcon"
local select_flag_path = "selectFlag"
local text_level_path = "LevelBg/TextLevel"
local hero_rank_star_path = "HeroRankStar"

function LWSeasonHeroListItem:OnCreate()
  base.OnCreate(self)
  self.text_level = self:AddComponent(UIText, text_level_path)
  self.btn_go = self:AddComponent(UIButton, "")
  self.img_bg = self:AddComponent(UIImage, img_bg_path)
  self.img_icon1 = self:AddComponent(UIImage, img_icon1_path)
  self.level_bg = self:AddComponent(UIImage, level_bg_path)
  self.fragCountText = self:AddComponent(UIText, frag_count_text_path)
  self.jobIcon = self:AddComponent(UIImage, job_icon_path)
  self.typeIcon = self:AddComponent(UIImage, type_icon_path)
  self.btn_go:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnHeroBtnClick()
  end)
  self.select_flag = self:AddComponent(UIImage, select_flag_path)
  self.select_flag:SetActive(false)
  self.rankItem = self:AddComponent(LWHeroRankStar, hero_rank_star_path)
end

function LWSeasonHeroListItem:OnDestroy()
  base.OnDestroy(self)
end

function LWSeasonHeroListItem:OnEnable()
  base.OnEnable(self)
end

function LWSeasonHeroListItem:OnDisable()
  base.OnDisable(self)
end

function LWSeasonHeroListItem:ReInit(index, data, clickType, select, cardShowType)
  self.index = index
  self.data = data
  self.clickType = clickType
  self.select_flag:SetActive(select and true or select)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(data)
  if heroData ~= nil then
    self:SetQuality(heroData.quality, false)
    if self.typeIcon then
      self.typeIcon:LoadSpriteAuto(HeroUtils.GetHeroTypeIcon(heroData.heroType, heroData:IsUniqueWeaponOpen() and heroData:HasUniqueWeapon(), heroData:IsHeroAwakened()))
    end
    local iconPath = HeroUtils.GetHeroIconPath(heroData.modelId, HeroIconType.half_portrait)
    self.img_icon1:LoadSpriteAuto(iconPath)
    if self.jobIcon then
      if heroData.meta then
        self.jobIcon:LoadSprite(HeroUtils.GetHeroJobIcon(heroData.meta.job, 2))
        self.jobIcon:SetActive(true)
      else
        self.jobIcon:SetActive(false)
      end
    end
    self.level_bg:SetActive(true)
    self.fragCountText:SetText("")
    self.heroId = heroData.heroId
    self.fragCountText:SetLocalText(heroData.firstName)
    self.text_level:SetActive(true)
    self.text_level:SetText("Lv." .. tostring(heroData.level))
    if cardShowType == HeroListCardType.ShowHeroRank then
      self.rankItem:SetActive(true)
      self.fragCountText:SetActive(false)
      local rank = heroData:GetRank()
      self.rankItem:ShowRank(rank, heroData.meta.maxRank)
    else
      self.rankItem:SetActive(false)
      self.fragCountText:SetActive(true)
    end
  else
    self.text_level:SetActive(false)
    local item = DataCenter.ItemTemplateManager:GetItemTemplate(data)
    local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(toInt(item.para2))
    if heroConfig ~= nil then
      self:SetQuality(heroConfig.quality, true, false)
    end
    local iconPath = HeroUtils.GetHeroIconPath(heroConfig.appearance, HeroIconType.half_portrait)
    self.img_icon1:LoadSpriteAuto(iconPath)
    self.typeIcon:LoadSprite(HeroUtils.GetHeroTypeIcon(heroConfig.type))
    if self.jobIcon then
      self.jobIcon:LoadSprite(HeroUtils.GetHeroJobIcon(heroConfig.job, 2))
      self.jobIcon:SetActive(true)
    end
    local itemCount = DataCenter.ItemData:GetItemCount(data)
    local itemNeed = HeroUtils.GetJigsawCost(data)
    self.level_bg:SetActive(true)
    self.fragCountText:SetText(itemCount .. "/" .. itemNeed)
    self.heroId = heroConfig.id
    self.rankItem:SetActive(false)
    self.fragCountText:SetActive(true)
  end
end

function LWSeasonHeroListItem:SetQuality(quality)
  self.img_bg:LoadSprite(HeroUtils.GetQualityIconPath(quality, true, false))
  self.level_bg:LoadSprite(HeroUtils.GetLevelBg(quality))
end

function LWSeasonHeroListItem:OnHeroBtnClick()
  local heroId = self.heroId
  if self.clickType == 1 then
    local hero_data = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
    if hero_data ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, hero_data.uuid, {
        hero_data.uuid
      })
    else
      local meta = DataCenter.HeroTemplateManager:GetTemplate(heroId)
      if meta ~= nil and meta.fragId > 0 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, meta.fragId, {
          meta.fragId
        })
        return
      end
    end
  elseif self.clickType == 2 then
    self.view:SelectHero(self.data)
  end
end

function LWSeasonHeroListItem:ResetSelect(selectHeroUud)
  self.select_flag:SetActive(selectHeroUud == self.data)
end

return LWSeasonHeroListItem
