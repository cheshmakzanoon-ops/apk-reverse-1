local LWHeroRankStar = BaseClass("LWHeroRankStar", UIBaseContainer)
local base = UIBaseContainer

function LWHeroRankStar:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWHeroRankStar:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWHeroRankStar:OnEnable()
  base.OnEnable(self)
end

function LWHeroRankStar:OnDisable()
  base.OnDisable(self)
end

function LWHeroRankStar:ComponentDefine()
  self.starMap = {}
  for i = 1, 5 do
    local star = self:AddComponent(UIImage, "Star" .. i)
    local data = {}
    data.root = star
    self.starMap[i] = data
  end
end

function LWHeroRankStar:ComponentDestroy()
end

function LWHeroRankStar:DataDefine()
end

function LWHeroRankStar:DataDestroy()
end

function LWHeroRankStar:ShowRank(rank, maxRank, heroAwakenRankLv)
  for i = 1, 5 do
    local imagePath = HeroUtils.GetHeroCellRankStarImageAssetPath(i, rank, maxRank, heroAwakenRankLv)
    self.starMap[i].root:SetActive(imagePath ~= nil)
    if imagePath ~= nil then
      self.starMap[i].root:LoadSpriteAuto(imagePath)
    end
  end
end

return LWHeroRankStar
