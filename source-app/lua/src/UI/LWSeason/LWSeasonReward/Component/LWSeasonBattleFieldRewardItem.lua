local LWSeasonBattleFieldRewardItem = BaseClass("LWSeasonBattleFieldRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_common_res_item_path = "bg/UICommonResItem"
local content_path = "bg/Content"
local title_path = "bg/Image/title"
local title1_path = "bg/title1"

function LWSeasonBattleFieldRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWSeasonBattleFieldRewardItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonBattleFieldRewardItem:OnEnable()
  base.OnEnable(self)
end

function LWSeasonBattleFieldRewardItem:OnDisable()
  base.OnDisable(self)
end

function LWSeasonBattleFieldRewardItem:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.title1 = self:AddComponent(UIText, title1_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.common_res_item = self.transform:Find(u_i_common_res_item_path).gameObject
  self.common_res_item:GameObjectCreatePool()
end

function LWSeasonBattleFieldRewardItem:ComponentDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.content = nil
  if self.common_res_item then
    self.common_res_item:GameObjectRecycleAll()
  end
  self.common_res_item = nil
  self.title = nil
  self.title1 = nil
  self.content = nil
end

function LWSeasonBattleFieldRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function LWSeasonBattleFieldRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWSeasonBattleFieldRewardItem:OnClaimBtn()
end

function LWSeasonBattleFieldRewardItem:SetData(data, tittle1, tittle2)
  if SeasonUtil.IsInSeasonPrepareMode() then
    self.title:SetLocalText("season_pre_start_desc01")
  else
    self.title:SetText(tittle1)
  end
  self.title1:SetText(tittle2)
  local reward = data.reward
  self.content:RemoveComponents(UICommonResItem)
  self.common_res_item:GameObjectRecycleAll()
  self.content:SetAnchoredPositionXY(0, 0)
  if reward then
    for index, value in ipairs(reward) do
      local go = self.common_res_item:GameObjectSpawn(self.content.transform)
      go.gameObject:SetActive(true)
      go.transform:Set_localScale(0.86, 0.86, 0.86)
      go.name = "item" .. tostring(index)
      local cell = self.content:AddComponent(UICommonResItem, go.name)
      cell:ReInit(value)
    end
  end
end

return LWSeasonBattleFieldRewardItem
