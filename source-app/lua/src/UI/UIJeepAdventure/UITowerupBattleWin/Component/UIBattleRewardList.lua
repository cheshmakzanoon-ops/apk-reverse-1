local UIBattleRewardList = BaseClass("UIBattleRewardList", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")

function UIBattleRewardList:OnCreate(statisticalFieldName)
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIBattleRewardList:OnDestroy()
  self.param = nil
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
    self.reqs = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleRewardList:OnEnable()
  base.OnEnable(self)
end

function UIBattleRewardList:OnDisable()
  base.OnDisable(self)
end

function UIBattleRewardList:ComponentDefine()
  self.rewardContent = self:AddComponent(UIBaseContainer, "Viewport/RewardContent")
end

function UIBattleRewardList:ComponentDestroy()
  self.rewardContent = nil
end

function UIBattleRewardList:FadeIn()
end

function UIBattleRewardList:RefreshView()
  self:OnGetReward()
end

function UIBattleRewardList:OnGetReward()
  if self.view == nil then
    return
  end
  local param = self.view.rewardParam
  if param == nil or self.param == param then
    return
  end
  self.param = param
  self.rewardContent:RemoveComponents(UIHeroCellSmall)
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.reqs = {}
  local index = 0
  for _, v in pairs(param) do
    local req
    local p = v
    if p.rewardType == RewardType.HERO then
      req = Resource:InstantiateAsync(UIAssets.UIHeroCellSmall)
    else
      req = Resource:InstantiateAsync(UIAssets.UICommonResItem)
    end
    index = index + 1
    local name = index
    req:completed("+", function(req)
      local go = req.gameObject
      go.name = name
      CommonUtil.CallAutoArabicMirrorManually(req)
      go.transform:SetParent(self.rewardContent.transform)
      go.transform:Set_localScale(1, 1, 1)
      local cell
      if p.rewardType == RewardType.HERO then
        cell = self.rewardContent:AddComponent(UIHeroCellSmall, go)
        cell:SetData(p.heroUuid)
      else
        cell = self.rewardContent:AddComponent(UICommonResItem, go)
        cell:ReInit(p)
      end
      cell:SetActive(true)
    end)
    table.insert(self.reqs, req)
  end
end

return UIBattleRewardList
