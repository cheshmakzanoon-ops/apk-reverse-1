local UIHeroReportItem = BaseClass("UIHeroReportItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local base = UIBaseContainer
local LWHeroRankStar = require("UI.UIHero2.Common.LWHeroRankStar")
local attrItem = require("UI.LWSeason.LWSeasonHeroLevelChange.Component.UIHeroAttrItem")
local name_path = "name"
local levelchange_path = "levelchange"
local attr_prefab_path = "attrPrefab"
local attr_list_path = "attrList"
local img_bg_path = "UIHeroCellBig/LayerNormal/ImgBg"
local img_icon1_path = "UIHeroCellBig/LayerNormal/ImgBg/Mask/ImgIcon1"
local level_bg_path = "UIHeroCellBig/LevelBg"
local hero_rank_star_path = "UIHeroCellBig/HeroRankStar"

function UIHeroReportItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIHeroReportItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroReportItem:ComponentDefine()
  self.name = self:AddComponent(UIText, name_path)
  self.levelchange = self:AddComponent(attrItem, levelchange_path)
  self.attr_prefab = self:AddComponent(UIBaseContainer, attr_prefab_path)
  self.attrPrefabPool = self.attr_prefab.gameObject
  self.attrPrefabPool:GameObjectCreatePool()
  self.attr_list = self:AddComponent(UIBaseContainer, attr_list_path)
  self.img_bg = self:AddComponent(UIImage, img_bg_path)
  self.img_icon1 = self:AddComponent(UIImage, img_icon1_path)
  self.level_bg = self:AddComponent(UIImage, level_bg_path)
  self.hero_rank_star = self:AddComponent(LWHeroRankStar, hero_rank_star_path)
end

function UIHeroReportItem:ComponentDestroy()
  self.attr_list:RemoveComponents(attrItem)
  self.attrPrefabPool:GameObjectRecycleAll()
  self.attrPrefabPool = nil
  self.name = nil
  self.levelchange = nil
  self.attr_prefab = nil
  self.attr_list = nil
  self.img_bg = nil
  self.img_icon1 = nil
  self.level_bg = nil
  self.hero_rank_star = nil
end

function UIHeroReportItem:OnAddListener()
  base.OnAddListener(self)
end

function UIHeroReportItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIHeroReportItem:SetHeroReportData(data)
  self.attrPrefabPool:GameObjectRecycleAll()
  if data.heroUuid then
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(data.heroUuid)
    local iconPath = HeroUtils.GetHeroIconPath(heroData.modelId, HeroIconType.half_portrait)
    self.img_icon1:LoadSpriteAuto(iconPath)
    self.img_bg:LoadSprite(HeroUtils.GetQualityIconPath(heroData.quality, true, false))
    self.level_bg:LoadSprite(HeroUtils.GetLevelBg(heroData.quality))
    self:SetHeroRank(heroData)
    self.name:SetLocalText(heroData.firstName)
    local oldValue = data.heroData.level
    local newValue = heroData.level
    self.levelchange:SetHeroAttrData({
      des = Localization:GetString("151116"),
      oldValue = tostring(oldValue),
      newValue = tostring(newValue),
      isUpFlag = oldValue < newValue
    })
    local dataList = {}
    dataList[1] = {}
    dataList[1].des = Localization:GetString("season_level_replacement_006")
    dataList[1].oldV = data.heroData.atk
    dataList[1].newV = heroData:GetAtk()
    dataList[2] = {}
    dataList[2].des = Localization:GetString("season_level_replacement_007")
    dataList[2].oldV = data.heroData.hp
    dataList[2].newV = heroData:GetMaxHp()
    dataList[3] = {}
    dataList[3].des = Localization:GetString("season_level_replacement_008")
    dataList[3].oldV = data.heroData.def
    dataList[3].newV = heroData:GetDef()
    dataList[4] = {}
    dataList[4].des = Localization:GetString("season_level_replacement_009")
    dataList[4].oldV = data.heroData.soldiersCapacity
    dataList[4].newV = heroData:GetSoldierCapacity()
    for i = 1, #dataList do
      local goItem = self.attrPrefabPool:GameObjectSpawn(self.attr_list.transform)
      local itemData = dataList[i]
      goItem.name = "item_" .. i
      goItem:SetActive(true)
      local attrItemCom = self.attr_list:AddComponent(attrItem, goItem.name)
      attrItemCom:SetHeroAttrData({
        des = itemData.des,
        oldValue = string.GetFormattedStr(itemData.oldV),
        newValue = string.GetFormattedStr(itemData.newV),
        isUpFlag = itemData.oldV < itemData.newV
      })
    end
  end
end

function UIHeroReportItem:SetHeroRank(heroData)
  if heroData:GetRank() == nil then
    self.hero_rank_star:SetActive(false)
  else
    self.hero_rank_star:SetActive(true)
    if heroData and heroData.meta then
      self.hero_rank_star:ShowRank(heroData:GetRank(), heroData.meta.maxRank)
    end
  end
end

return UIHeroReportItem
