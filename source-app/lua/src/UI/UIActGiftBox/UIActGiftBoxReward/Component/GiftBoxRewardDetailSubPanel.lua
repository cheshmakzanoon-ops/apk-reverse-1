local GiftBoxRewardDetailSubPanel = BaseClass("GiftBoxRewardDetailSubPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local GiftBoxDetailCell = require("UI.UIActGiftBox.UIActGiftBoxReward.Component.GiftBoxDetailCell")
local content1_path = "boxScrollView/Viewport/Content1"

function GiftBoxRewardDetailSubPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function GiftBoxRewardDetailSubPanel:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GiftBoxRewardDetailSubPanel:ComponentDefine()
  self.boxListContent = self:AddComponent(UIBaseContainer, content1_path)
end

function GiftBoxRewardDetailSubPanel:ComponentDestroy()
  self:SetAllCellDestroy()
  self.boxListContent = nil
end

function GiftBoxRewardDetailSubPanel:OnAddListener()
  base.OnAddListener(self)
end

function GiftBoxRewardDetailSubPanel:OnRemoveListener()
  base.OnRemoveListener(self)
end

function GiftBoxRewardDetailSubPanel:ReInit(actId)
  self.actId = actId
  if self.holder.boxopen_id then
    self:Refresh(self.holder.boxopen_id)
  end
end

function GiftBoxRewardDetailSubPanel:Refresh(boxOpenId)
  if self.boxOpenId ~= boxOpenId then
    local generateItemRewardList, boxList = DataCenter.ActGiftBoxData:GetBoxOpenDataByOpenId(boxOpenId)
    self:SetAllCellDestroy()
    self:RefreshBoxReward(boxList)
  end
  self.boxOpenId = boxOpenId
end

function GiftBoxRewardDetailSubPanel:RefreshBoxReward(boxList)
  if boxList == nil then
    return
  end
  local boxListAfterSort = boxList
  local freeBoxQuality = 6
  table.sort(boxListAfterSort, function(a, b)
    local aVal = a.quality == freeBoxQuality and -1 or a.quality
    local bVal = b.quality == freeBoxQuality and -1 or b.quality
    return aVal > bVal
  end)
  self.boxItemList = {}
  local count = 1
  for k, v in ipairs(boxListAfterSort) do
    self.boxItemList[count] = self:CreateGiftBoxDetailCell(count, v)
    count = count + 1
  end
end

function GiftBoxRewardDetailSubPanel:CreateGiftBoxDetailCell(index, param)
  local item = self:GameObjectInstantiateAsync(UIAssets.GiftBoxDetailCell, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.boxListContent.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.name = "box_cell_" .. index
    local cell = self.boxListContent:AddComponent(GiftBoxDetailCell, go.name)
    cell:ReInit(param, self.actId)
  end)
  return item
end

function GiftBoxRewardDetailSubPanel:SetAllCellDestroy()
  if self.boxItemList ~= nil then
    self.boxListContent:RemoveComponents(GiftBoxDetailCell)
    for k, v in ipairs(self.boxItemList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.boxItemList = nil
  end
end

return GiftBoxRewardDetailSubPanel
