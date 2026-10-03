local base = UIBaseContainer
local LLRewardBaseItem = BaseClass("LLRewardBaseItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")

function LLRewardBaseItem:OnCreate()
  base.OnCreate(self)
  self.asyncs = {}
  self.items = {}
end

function LLRewardBaseItem:OnDestroy()
  if self.compContent ~= nil then
    self.compContent:RemoveAllComponentes()
  end
  self.asyncs = nil
  self.items = nil
  self.rewards = nil
  base.OnDestroy(self)
end

function LLRewardBaseItem:RefreshIcons(rewardId)
  if self.compContent == nil then
    return
  end
  self.rewards = RewardUtil.GetRewardsById(rewardId)
  self.asyncs = self.asyncs or {}
  self.items = self.items or {}
  local iCnt = #self.items
  local rCnt = #self.rewards
  local max = math.max(iCnt, rCnt)
  for i = 1, max do
    local info = self.rewards[i]
    local item = self.items[i]
    if info ~= nil then
      if item ~= nil then
        self:RefreshIcon(i)
      else
        local async = self.asyncs[i]
        if async == nil then
          local idx = i
          async = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go.name = "Item_" .. idx
            go.gameObject:SetActive(true)
            local tf = go.transform
            tf:SetParent(self.compContent.transform)
            tf:Reset()
            local cell = self.compContent:AddComponent(UICommonResItem, go.name)
            cell:SetSizeDeltaXY(COMMON_RES_ITEM_DEF_SIZE, COMMON_RES_ITEM_DEF_SIZE)
            cell:SetLocalScaleXYZ(0.7, 0.7, 1)
            self.items[idx] = cell
            self:RefreshIcon(idx)
          end)
          self.asyncs[i] = async
        end
      end
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
end

function LLRewardBaseItem:RefreshIcon(i)
  local item = self.items[i]
  if item == nil then
    return
  end
  local info = self.rewards[i]
  item:SetActive(info ~= nil)
  if info ~= nil then
    item:ReInit(info)
  end
end

return LLRewardBaseItem
