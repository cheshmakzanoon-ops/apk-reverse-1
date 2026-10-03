local base = UIBaseContainer
local UIActValentineRankRewardItem = BaseClass("UIActValentineRankRewardItem", base)
local Localization = CS.GameEntry.Localization
local M = UIActValentineRankRewardItem
local rank_icon_path = "RankIcon"
local rank_text_path = "RankText"
local reward_node_path = "RewardNode/Scroll View/Viewport/RewardContent"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.rankImg = self:AddComponent(UIRawImage, rank_icon_path)
  self.rankText = self:AddComponent(UIText, rank_text_path)
  self.rewardNode = self:AddComponent(UIBaseContainer, reward_node_path)
end

function M:ComponentDestroy()
  self.rankImg = nil
  self.rankText = nil
  self.rewardNode = nil
end

function M:DataDefine()
  self.rewardData = {}
  self.rewardItemList = {}
end

function M:DataDestroy()
  self.rewardData = nil
  self.rewardItemList = nil
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:SetData(data, actId)
  self.rewardData = data
  self.activityId = actId
  if not self.rewardData then
    Logger.LogError("rank data is nil")
    return
  end
  self:RefreshAll()
end

function M:ClearRewards()
  self.rewardNode:RemoveComponents(UICommonResItem)
  if self.rewardItemList then
    for _, req in ipairs(self.rewardItemList) do
      self:GameObjectDestroy(req)
    end
  end
  self.rewardItemList = {}
end

function M:RefreshAll()
  if not self.rewardData then
    return
  end
  local level = self.rewardData.type
  local path = string.format("Assets/Main/TextureEx/UIActValentineMainTex/ljq_qingrenjie_duanwei_%s.png", level)
  self.rankImg:LoadSprite(path)
  self.rankImg:SetNativeSize()
  self.rankText:SetText(self.rewardData.rankName)
  self:ClearRewards()
  if not (self.rewardData and self.rewardData.rewardItemInfoList) or type(self.rewardData.rewardItemInfoList) ~= "table" or table.length(self.rewardData.rewardItemInfoList) == 0 then
    self.rewardNode:SetActive(false)
    return
  end
  local rewardList = self.rewardData.rewardItemInfoList
  for i, item in ipairs(rewardList) do
    local req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if req == nil then
        return
      end
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local rewardName = "item_" .. i
      obj.name = rewardName
      obj:SetActive(true)
      obj.transform:SetParent(self.rewardNode.transform)
      obj.transform:Set_localScale(0.85, 0.85, 1)
      obj.transform:Set_pivot(0.5, 0.5)
      local cell = self.rewardNode:AddComponent(UICommonResItem, rewardName)
      local param = {}
      param.itemId = item.itemId
      param.count = item.count
      param.rewardType = item.rewardType
      cell:ReInit(param)
    end)
    table.insert(self.rewardItemList, req)
  end
end

return UIActValentineRankRewardItem
