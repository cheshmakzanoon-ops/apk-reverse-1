local ServerBattleRankTab2Item = BaseClass("ServerBattleRankTab2Item", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local rank_icon_path = "RankIcon"
local rank_icon_num_path = "RankIconNum"
local content_path = "ScrollRect/ViewPort/Content"

function ServerBattleRankTab2Item:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.rank_icon = self:AddComponent(UIImage, rank_icon_path)
  self.rank_icon_num = self:AddComponent(UIText, rank_icon_num_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function ServerBattleRankTab2Item:OnDestroy()
  self:DeInit()
  base.OnDestroy(self)
end

function ServerBattleRankTab2Item:ReInit(data, template)
  local goItem, theItem
  self:DeInit()
  for i, v in ipairs(data.reward) do
    goItem = template:GameObjectSpawn(self.content.transform)
    goItem.name = "item_" .. i
    goItem:SetActive(true)
    theItem = self.content:AddComponent(UICommonResItem, goItem.name)
    theItem:ParseInfo(v)
  end
  self.rank_icon_num:SetText(data.rankIndex)
  if data.rankIndex == "1" or data.rankIndex == 1 then
    self.rank_icon:SetActive(true)
    self.rank_icon:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_1.png")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao.png")
  elseif data.rankIndex == "2" or data.rankIndex == 2 then
    self.rank_icon:SetActive(true)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao.png")
    self.rank_icon:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_2.png")
  elseif data.rankIndex == "3" or data.rankIndex == 3 then
    self.rank_icon:SetActive(true)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao.png")
    self.rank_icon:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_3.png")
  else
    self.rank_icon:SetActive(false)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao.png")
  end
end

function ServerBattleRankTab2Item:DeInit()
  self.content:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      v.gameObject:GameObjectRecycle()
    end
  end
end

return ServerBattleRankTab2Item
