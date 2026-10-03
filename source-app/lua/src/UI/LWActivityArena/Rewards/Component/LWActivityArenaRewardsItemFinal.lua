local LWActivityArenaRewardsItemFinal = BaseClass("LWActivityArenaRewardsItemFinal", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "txtRank",
    name = "txtRank",
    type = UIText
  },
  {
    path = "scrollRewards/Viewport/Content",
    name = "scrollContent",
    type = nil
  },
  {
    path = "scrollRewards/Viewport/Content/rewardTemplate",
    name = "rewardTemplate",
    type = nil,
    active = false
  },
  {
    path = "imgBadge",
    name = "imgBadge",
    type = UIImage
  },
  {
    path = "imgBadge/txtBadgeRank",
    name = "txtBadgeRank",
    type = UIText
  }
}

function LWActivityArenaRewardsItemFinal:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWActivityArenaRewardsItemFinal:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWActivityArenaRewardsItemFinal:ComponentDefine()
  self.rewardComps = {}
  self:DefineCompsByBook(compBook)
end

function LWActivityArenaRewardsItemFinal:ComponentDestroy()
  for _, rewardComp in ipairs(self.rewardComps) do
    if rewardComp then
      local go = rewardComp.gameObject
      self:RemoveComponent(rewardComp)
      if not IsNull(go) then
        CS.UnityEngine.GameObject.Destroy(go)
      end
    end
  end
  self.rewardComps = nil
  self:ClearCompsByBook(compBook)
end

function LWActivityArenaRewardsItemFinal:Refresh(data)
  if data.badge then
    self:SetRankIcon(tonumber(data.rank) or 1)
    self.imgBadge:SetActive(true)
    self.txtRank:SetText(nil)
    self.txtBadgeRank:SetText(data.rank)
  else
    self.imgBadge:SetActive(false)
    self.txtRank:SetText(data.rank)
  end
  local idx = 1
  for _, reward in ipairs(data.rewards) do
    local rewardComp = self.rewardComps[idx]
    if not rewardComp then
      local rewardObj = CS.UnityEngine.GameObject.Instantiate(self.rewardTemplate, self.scrollContent.transform)
      rewardObj.name = "reward_" .. idx
      rewardComp = self:AddComponent(UICommonResItem, rewardObj)
      self.rewardComps[idx] = rewardComp
    end
    rewardComp:SetActive(true)
    rewardComp:ReInit(reward)
    idx = idx + 1
  end
  for i = idx, #self.rewardComps do
    self.rewardComps[i]:SetActive(false)
  end
end

function LWActivityArenaRewardsItemFinal:SetRankIcon(rank)
  if rank == 1 then
    self.imgBadge:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_1.png")
  elseif rank == 2 then
    self.imgBadge:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_2.png")
  elseif rank == 3 then
    self.imgBadge:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_3.png")
  end
end

return LWActivityArenaRewardsItemFinal
