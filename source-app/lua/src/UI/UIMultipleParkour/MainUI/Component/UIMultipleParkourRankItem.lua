local UIMultipleParkourRankItem = BaseClass("UIMultipleParkourRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rank_image_path = "rankImage"
local self_image_path = "selfImage"
local rank_path = "rank"
local score_path = "score"

function UIMultipleParkourRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMultipleParkourRankItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMultipleParkourRankItem:ComponentDefine()
  self.rank_image = self:AddComponent(UIImage, rank_image_path)
  self.self_image = self:AddComponent(UIImage, self_image_path)
  self.rank = self:AddComponent(UITextMeshProUGUIEx, rank_path)
  self.score = self:AddComponent(UITextMeshProUGUIEx, score_path)
end

function UIMultipleParkourRankItem:ComponentDestroy()
  self.rank_image = nil
  self.self_image = nil
  self.rank = nil
  self.score = nil
end

function UIMultipleParkourRankItem:Refresh(rank, playerData)
  self:SetActive(true)
  local mySelf = playerData.mySelf
  if mySelf then
    self.rank:SetText("<color=#5FEF87>" .. rank .. "</color>")
  else
    self.rank:SetText(rank)
  end
  self.self_image:SetActive(playerData.mySelf)
  local score = playerData:GetShowScore()
  if mySelf then
    self.score:SetText("<color=#5FEF87>" .. score .. "</color>")
  else
    self.score:SetText(score)
  end
  if rank == 1 then
    self.rank_image:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_1.png")
    self.rank_image:SetActive(true)
  elseif rank == 2 then
    self.rank_image:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_2.png")
    self.rank_image:SetActive(true)
  elseif rank == 3 then
    self.rank_image:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_3.png")
    self.rank_image:SetActive(true)
  else
    self.rank_image:SetActive(false)
  end
end

return UIMultipleParkourRankItem
