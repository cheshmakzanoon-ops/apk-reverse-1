local LWEquipRankStar = BaseClass("LWEquipRankStar", UIBaseContainer)
local base = UIBaseContainer

function LWEquipRankStar:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWEquipRankStar:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWEquipRankStar:OnEnable()
  base.OnEnable(self)
end

function LWEquipRankStar:OnDisable()
  base.OnDisable(self)
end

function LWEquipRankStar:ComponentDefine()
  self.starMap = {}
  for i = 1, 5 do
    local star = self:AddComponent(UIImage, "Star" .. i)
    local data = {}
    data.root = star
    self.starMap[i] = data
  end
end

function LWEquipRankStar:ComponentDestroy()
end

function LWEquipRankStar:DataDefine()
end

function LWEquipRankStar:DataDestroy()
end

function LWEquipRankStar:ShowRank(rank, maxRank)
  rank = rank or 1
  local starNum = maxRank / 5
  for i = 1, 5 do
    if i <= starNum then
      self.starMap[i].root:SetActive(true)
      local rankGroup = math.floor(rank / 5) + 1
      local innerRank = rank % 5
      if i < rankGroup then
        self.starMap[i].root:LoadSpriteAsync("Assets/Main/Sprites/UI/LWUIEquipPromote/zyf_rongyuqiang_lvdian.png")
      elseif i == rankGroup and 0 < innerRank then
        self.starMap[i].root:LoadSpriteAsync("Assets/Main/Sprites/UI/LWUIEquipPromote/zyf_zhuangbeiyouhua_kong.png")
      else
        self.starMap[i].root:LoadSpriteAsync("Assets/Main/Sprites/UI/LWUIEquipPromote/zyf_zhuangbeiyouhua_kong.png")
      end
    else
      self.starMap[i].root:SetActive(false)
    end
  end
end

return LWEquipRankStar
