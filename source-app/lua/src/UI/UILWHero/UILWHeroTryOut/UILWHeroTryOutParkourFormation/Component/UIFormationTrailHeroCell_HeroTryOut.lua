local UIFormationTrailHeroCell = require("UI.UIParkour.FormationUI.Component.UIFormationTrailHeroCell")
local UIFormationTrailHeroCell_HeroTryOut = BaseClass("UIFormationTrailHeroCell", UIFormationTrailHeroCell)

function UIFormationTrailHeroCell_HeroTryOut:SetData(heroDisplayData, showFormation)
  if heroDisplayData == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.displayData = heroDisplayData
  local uniqueWeaponLv = 0
  if heroDisplayData.heroData.GetUniqueWeaponLv then
    uniqueWeaponLv = heroDisplayData.heroData:GetUniqueWeaponLv()
  end
  local awakenLv = 0
  if heroDisplayData.heroData.GetHeroAwakenRankLevel then
    awakenLv = heroDisplayData.heroData:GetHeroAwakenRankLevel()
  end
  local skinId = 0
  if heroDisplayData.heroData.GetSkinId then
    skinId = heroDisplayData.heroData:GetSkinId()
  end
  self.heroCell:InitWithConfigId(heroDisplayData.heroData.heroId, nil, heroDisplayData.heroData.level, heroDisplayData.heroData:GetRank(), uniqueWeaponLv, awakenLv, skinId)
  self.heroCell.callBack = self.clickCallBack
  self.trailIcon:SetActive(heroDisplayData.heroData.fromTemplate == true)
  local belongFormation = heroDisplayData.squadIndex
  if showFormation then
    if belongFormation then
      self.formationBg:SetActive(true)
      self.formationText:SetText(belongFormation)
      self.heroCell:SetMask(true)
    else
      self.formationBg:SetActive(false)
      self.heroCell:SetMask(false)
    end
  else
    self.formationBg:SetActive(false)
    self.heroCell:SetMask(false)
  end
  if heroDisplayData.canUse ~= nil then
    local canUse = heroDisplayData.canUse
    self.heroCell:SetAllImageGrey(not canUse, canUse)
  else
    self.heroCell:SetAllImageGrey(false, true)
  end
end

return UIFormationTrailHeroCell_HeroTryOut
