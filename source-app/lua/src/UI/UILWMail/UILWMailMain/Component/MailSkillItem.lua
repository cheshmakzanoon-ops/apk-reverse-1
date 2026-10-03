local MailSkillItem = BaseClass("MailSkillItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellTiny = require("UI.UIHero2.Common.UIHeroCellTiny")
local LWHeroRankStar = require("UI.UIHero2.Common.LWHeroRankStar")
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local Localization = CS.GameEntry.Localization

function MailSkillItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailSkillItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailSkillItem:ComponentDefine()
  self.left = self:AddComponent(UIBaseComponent, "left")
  self.right = self:AddComponent(UIBaseComponent, "right")
  self.HeroCellTiny1 = self:AddComponent(UIHeroCellTiny, "left/UIHeroCellTiny1")
  self.HeroCellTiny2 = self:AddComponent(UIHeroCellTiny, "right/UIHeroCellTiny2")
  self.HeroName1 = self:AddComponent(UIText, "left/HeroName1")
  self.HeroName2 = self:AddComponent(UIText, "right/HeroName2")
  self.HeroType1 = self:AddComponent(UIImage, "left/HeroType1")
  self.HeroType2 = self:AddComponent(UIImage, "right/HeroType2")
  self.HeroRankStar1 = self:AddComponent(LWHeroRankStar, "left/HeroRankStar1")
  self.HeroRankStar2 = self:AddComponent(LWHeroRankStar, "right/HeroRankStar2")
  self.skillItemReq = {}
  self.leftContent = self:AddComponent(UIBaseContainer, "left/leftContent")
  self.rightContent = self:AddComponent(UIBaseContainer, "right/rightContent")
end

function MailSkillItem:ComponentDestroy()
  self:RemoveAllSkillItems()
  self.HeroCellTiny1 = nil
  self.HeroCellTiny2 = nil
  self.HeroName1 = nil
  self.HeroName2 = nil
  self.textLevel1 = nil
  self.textLevel2 = nil
  self.HeroType1 = nil
  self.HeroType2 = nil
  self.HeroRankStar1 = nil
  self.HeroRankStar2 = nil
  self.SkillItems = nil
end

function MailSkillItem:RemoveAllSkillItems()
  self.leftContent:RemoveComponents(UIHeroSkillItem)
  self.rightContent:RemoveComponents(UIHeroSkillItem)
  if self.skillItemReq then
    for _, v in pairs(self.skillItemReq) do
      v:Destroy()
    end
    self.skillItemReq = {}
  end
end

function MailSkillItem:SetData(hero1, hero2)
  self:RemoveAllSkillItems()
  if hero1 then
    self.left:SetActive(true)
    self.HeroCellTiny1:SetData(hero1.heroId, nil, nil, hero1.weaponLevel, nil, hero1.heroSkinId)
    local heroConfig1 = DataCenter.HeroTemplateManager:GetTemplate(hero1.heroId)
    self.HeroName1:SetLocalText(GameDialogDefine.LEVEL_AND_NAME, hero1.heroLevel, Localization:GetString(heroConfig1.name))
    self.HeroType1:LoadSpriteAuto(HeroUtils.GetHeroTypeIcon(heroConfig1.type, nil, hero1.awakenLv ~= nil and hero1.awakenLv > 0))
    self.HeroRankStar1:ShowRank(hero1.rankLv, heroConfig1.maxRank, hero1.awakenLv)
    for i = 1, 4 do
      local skillInfo = hero1.heroInfo:GetHeroSkillBySlotIndex(i)
      if skillInfo then
        self.skillItemReq[i] = self:GameObjectInstantiateAsync(UIAssets.UIHeroSkillItem, function(req)
          if req == nil or IsNull(req.gameObject) then
            return
          end
          local go = req.gameObject
          go.name = "UIHeroSkillItem" .. i
          go:SetActive(true)
          go.transform:SetParent(self.leftContent.transform)
          go.transform:Set_localScale(0.61, 0.62, 1)
          go.transform:Set_sizeDelta(132, 160)
          go.transform:Set_pivot(0.5, 0.5)
          local item = self.leftContent:AddComponent(UIHeroSkillItem, go.name)
          item:SetData(skillInfo, {
            showSkillName = false,
            showSkillLevel = true,
            showLock = true,
            showRedPoint = false,
            unlockLevel = 0,
            showStar = true
          })
        end)
      end
    end
  else
    self.left:SetActive(false)
  end
  if hero2 then
    self.right:SetActive(true)
    self.HeroCellTiny2:SetData(hero2.heroId, nil, nil, hero2.weaponLevel, nil, hero2.heroSkinId)
    local heroConfig2 = DataCenter.HeroTemplateManager:GetTemplate(hero2.heroId)
    self.HeroName2:SetLocalText(GameDialogDefine.LEVEL_AND_NAME, hero2.heroLevel, Localization:GetString(heroConfig2.name))
    self.HeroType2:LoadSpriteAuto(HeroUtils.GetHeroTypeIcon(heroConfig2.type, nil, hero2.awakenLv ~= nil and hero2.awakenLv > 0))
    self.HeroRankStar2:ShowRank(hero2.rankLv, heroConfig2.maxRank, hero2.awakenLv)
    for i = 8, 5, -1 do
      local skillInfo = hero2.heroInfo:GetHeroSkillBySlotIndex(i - 4)
      if skillInfo then
        self.skillItemReq[i] = self:GameObjectInstantiateAsync(UIAssets.UIHeroSkillItem, function(req)
          if req == nil or IsNull(req.gameObject) then
            return
          end
          local go = req.gameObject
          go.name = "UIHeroSkillItem" .. i
          go:SetActive(true)
          go.transform:SetParent(self.rightContent.transform)
          go.transform:Set_localScale(0.61, 0.62, 1)
          go.transform:Set_sizeDelta(132, 160)
          go.transform:Set_pivot(0.5, 0.5)
          local item = self.rightContent:AddComponent(UIHeroSkillItem, go.name)
          item:SetData(skillInfo, {
            showSkillName = false,
            showSkillLevel = true,
            showLock = true,
            showRedPoint = false,
            unlockLevel = 0,
            showStar = true
          })
        end)
      end
    end
  else
    self.right:SetActive(false)
  end
end

function MailSkillItem:DataDefine()
end

function MailSkillItem:DataDestroy()
end

function MailSkillItem:OnEnable()
  base.OnEnable(self)
end

function MailSkillItem:OnDisable()
  base.OnDisable(self)
end

function MailSkillItem:OnAddListener()
  base.OnAddListener(self)
end

function MailSkillItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

return MailSkillItem
