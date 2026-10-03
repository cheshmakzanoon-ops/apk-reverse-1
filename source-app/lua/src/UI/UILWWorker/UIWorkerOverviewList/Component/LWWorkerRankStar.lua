local LWWorkerRankStar = BaseClass("LWWorkerRankStar", UIBaseContainer)
local base = UIBaseContainer

function LWWorkerRankStar:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWWorkerRankStar:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWWorkerRankStar:OnEnable()
  base.OnEnable(self)
end

function LWWorkerRankStar:OnDisable()
  base.OnDisable(self)
end

function LWWorkerRankStar:ComponentDefine()
  self.starMap = {}
  for i = 1, 5 do
    local star = self:AddComponent(UIImage, "Star" .. i)
    local data = {}
    data.root = star
    self.starMap[i] = data
  end
end

function LWWorkerRankStar:ComponentDestroy()
end

function LWWorkerRankStar:DataDefine()
end

function LWWorkerRankStar:DataDestroy()
end

function LWWorkerRankStar:ShowRank(rank, maxRank)
  rank = rank or 1
  local starNum = (maxRank - 1) / 5
  for i = 1, 5 do
    if i <= starNum then
      self.starMap[i].root:SetActive(true)
      local rankGroup = math.floor((rank - 1) / 5) + 1
      local innerRank = (rank - 1) % 5
      if i < rankGroup then
        self.starMap[i].root:LoadSprite("Assets/Main/Sprites/UI/UILWHeroDetail/cfm_biandui_xingxing_5")
      elseif i == rankGroup and 0 < innerRank then
        self.starMap[i].root:LoadSprite("Assets/Main/Sprites/UI/UILWHeroDetail/cfm_biandui_xingxing_" .. innerRank)
      else
        self.starMap[i].root:LoadSprite("Assets/Main/Sprites/UI/UILWHeroDetail/cfm_biandui_xingxing_6")
      end
    else
      self.starMap[i].root:SetActive(false)
    end
  end
end

return LWWorkerRankStar
