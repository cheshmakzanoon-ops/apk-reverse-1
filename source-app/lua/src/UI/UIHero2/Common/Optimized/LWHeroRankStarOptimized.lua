local base = UIBaseContainer
local LWHeroRankStarOptimized = BaseClass("LWHeroRankStarOptimized", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWHeroRankStarOptimized:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWHeroRankStarOptimized:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWHeroRankStarOptimized:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.star1 = self.viewSkin:AddComponent(self, UIImage, 1)
  self.star2 = self.viewSkin:AddComponent(self, UIImage, 2)
  self.star3 = self.viewSkin:AddComponent(self, UIImage, 3)
  self.star4 = self.viewSkin:AddComponent(self, UIImage, 4)
  self.star5 = self.viewSkin:AddComponent(self, UIImage, 5)
  self.starMap = {
    self.star1,
    self.star2,
    self.star3,
    self.star4,
    self.star5
  }
end

function LWHeroRankStarOptimized:ComponentDestroy()
  self.viewSkin = nil
  self.star1 = nil
  self.star2 = nil
  self.star3 = nil
  self.star4 = nil
  self.star5 = nil
  self.starMap = nil
end

function LWHeroRankStarOptimized:DataDefine()
end

function LWHeroRankStarOptimized:DataDestroy()
end

function LWHeroRankStarOptimized:OnAddListener()
  base.OnAddListener(self)
end

function LWHeroRankStarOptimized:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWHeroRankStarOptimized:ShowRank(rank, maxRank, heroAwakenRankLv)
  for i = 1, 5 do
    local imagePath = HeroUtils.GetHeroCellRankStarImageAssetPath(i, rank, maxRank, heroAwakenRankLv)
    self.starMap[i]:SetActive(imagePath ~= nil)
    if imagePath ~= nil then
      self.starMap[i]:LoadSpriteAuto(imagePath)
    end
  end
end

return LWHeroRankStarOptimized
