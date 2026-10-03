local NewPeakArenaKOFBattleResultViewItem = BaseClass("NewPeakArenaKOFBattleResultViewItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local UIGray = CS.UIGray
local NUMBER_PATH = {
  [0] = "Assets/Main/Sprites/UI/UIMultiKill/number_0.png",
  [1] = "Assets/Main/Sprites/UI/UIMultiKill/number_1.png",
  [2] = "Assets/Main/Sprites/UI/UIMultiKill/number_2.png",
  [3] = "Assets/Main/Sprites/UI/UIMultiKill/number_3.png",
  [4] = "Assets/Main/Sprites/UI/UIMultiKill/number_4.png",
  [5] = "Assets/Main/Sprites/UI/UIMultiKill/number_5.png",
  [6] = "Assets/Main/Sprites/UI/UIMultiKill/number_6.png",
  [7] = "Assets/Main/Sprites/UI/UIMultiKill/number_7.png",
  [8] = "Assets/Main/Sprites/UI/UIMultiKill/number_8.png",
  [9] = "Assets/Main/Sprites/UI/UIMultiKill/number_9.png"
}

function NewPeakArenaKOFBattleResultViewItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function NewPeakArenaKOFBattleResultViewItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function NewPeakArenaKOFBattleResultViewItem:ComponentDefine()
  self.heroItems = {}
  for i = 1, ArmyFormationSlot.Dominator do
    local item = self:AddComponent(UIHeroCellSmall, "Bg/HeroScrollRect/Viewport/HeroRoot/Hero" .. i)
    table.insert(self.heroItems, item)
  end
  self.heroContent = self:AddComponent(UIBaseContainer, "Bg/HeroScrollRect/Viewport/HeroRoot")
  self.power = self:AddComponent(UIBaseContainer, "Bg/Power")
  self.powerText = self:AddComponent(UIText, "Bg/Power/PowerText")
  self.number = self:AddComponent(UITextMeshProUGUIEx, "Bg/NumberImage/Number")
  self.killContent = self:AddComponent(UIBaseContainer, "Bg/killContent")
  self.killIcon = self:AddComponent(UIImage, "Bg/killContent/killIcon")
  self.killContent:SetActive(false)
end

function NewPeakArenaKOFBattleResultViewItem:ComponentDestroy()
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
  self.heroItems = nil
  self.heroBars = nil
  self.heroBarBgs = nil
  self.heroContent = nil
end

function NewPeakArenaKOFBattleResultViewItem:SetGray(gray)
  UIGray.SetGray(self.transform, gray, false)
end

function NewPeakArenaKOFBattleResultViewItem:SetData(heroes, powerStr, teamNo, killNumber)
  if heroes then
    local totalShowSlotCount = 0
    for i = 1, ArmyFormationSlot.Dominator do
      local heroItem = self.heroItems[i]
      if heroes[i] then
        local isSelfHero = DataCenter.HeroDataManager:GetHeroByUuid(heroes[i].heroUuid) ~= nil
        if isSelfHero then
          heroItem:SetData(heroes[i].heroUuid)
        else
          local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(heroes[i].heroUuid)
          local isSelfDominator = dominatorInfo ~= nil
          if isSelfDominator then
            heroItem:InitWithConfigId(dominatorInfo.dominatorId, nil, nil, dominatorInfo:GetCurRankLv())
          else
            heroItem:InitWithConfigId(heroes[i].heroId, nil, heroes[i].heroLevel, heroes[i].rankLv, heroes[i].weaponLevel, heroes[i].awakenLv, heroes[i].heroSkinId)
          end
        end
        heroItem:SetActive(true)
        totalShowSlotCount = totalShowSlotCount + 1
      else
        heroItem:SetActive(false)
      end
    end
    if totalShowSlotCount >= ArmyFormationSlot.Dominator then
      if self.tweenSeq then
        self.tweenSeq:Kill()
      end
      self.tweenSeq = DOTween.Sequence()
      self.tweenSeq:AppendInterval(3)
      self.tweenSeq:Append(self.heroContent.transform:DOAnchorPosX(CommonUtil.ArabicAutoMirrorFactor() * -66, 0.7):SetEase(CS.DG.Tweening.Ease.InOutQuad))
      self.tweenSeq:AppendInterval(0.5)
      self.tweenSeq:Append(self.heroContent.transform:DOAnchorPosX(0, 0.7):SetEase(CS.DG.Tweening.Ease.InOutQuad))
    end
  else
    for i = 1, ArmyFormationSlot.Dominator do
      local heroItem = self.heroItems[i]
      heroItem:SetActive(false)
    end
  end
  self.heroes = heroes
  if not string.IsNullOrEmpty(powerStr) then
    self.power:SetActive(true)
    self.powerText:SetText(powerStr)
  else
    self.power:SetActive(false)
  end
  if teamNo then
    self.number:SetText(teamNo)
  end
  if killNumber and 1 < killNumber then
    self.killContent:SetActive(true)
    local path = NUMBER_PATH[killNumber]
    if not string.IsNullOrEmpty(path) then
      self.killIcon:LoadSprite(path)
    end
  else
    self.killContent:SetActive(false)
  end
end

return NewPeakArenaKOFBattleResultViewItem
