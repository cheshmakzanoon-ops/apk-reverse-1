local GiftBoxRewardCell = BaseClass("GiftBoxRewardCell", UIBaseContainer)
local base = UIBaseContainer

function GiftBoxRewardCell:OnCreate()
  base.OnCreate(self)
  self._giftIcon_img = self:AddComponent(UIImage, "BoxImg")
  self._tip1_txt = self:AddComponent(UIText, "TipText1")
  self._tip1_txt:SetLocalText(2800063)
  self._tip2_txt = self:AddComponent(UIText, "TipText2")
  self._tip2_txt:SetLocalText(2800077)
  self._name_txt = self:AddComponent(UIText, "NameText")
  self._prop_txt = self:AddComponent(UIText, "PropText")
  self._itemContent_rect = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content1")
  self.commonRes = self:AddComponent(UICommonResItem, "UICommonResItem")
end

function GiftBoxRewardCell:OnDestroy()
  self:SetAllCellDestroy()
  base.OnDestroy(self)
end

function GiftBoxRewardCell:ReInit(param, lotteryList, activityId)
  local count = param.time
  for i = 1, table.count(lotteryList) do
    if lotteryList[i].itemId == param.id then
      count = param.time - lotteryList[i].count
      break
    end
  end
  self._giftIcon_img:LoadSprite(string.format(LoadPath.UImystery, param.icon))
  local template = DataCenter.ActGiftBoxData:GetActBoxInfoByItemId(param.id)
  self._name_txt:SetLocalText(template.reward_name)
  local listReward = {}
  for k, v in pairs(param.propReward) do
    if v.itemId ~= 0 then
      table.insert(listReward, v)
    end
  end
  local prop = DataCenter.ActGiftBoxData:GetActBoxGetProp(activityId, template.quality)
  self._prop_txt:SetLocalText(2800064, string.format("%.1f", prop * 100) .. "%")
  self:RefreshItemReward(listReward)
end

function GiftBoxRewardCell:RefreshItemReward(listReward)
  self.modelItem = {}
  self.cells = {}
  if listReward then
    for i = 1, table.count(listReward) do
      self.modelItem[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self._itemContent_rect.transform)
        go.transform:Set_localScale(0.9, 0.9, 0.9)
        go.name = "item_reward_" .. i
        local cell = self._itemContent_rect:AddComponent(UICommonResItem, go.name)
        cell:ReInit(listReward[i])
        if listReward[i].resultProp then
          cell.name_text:SetActive(true)
          cell:SetNameText(string.format("%.2f%%", listReward[i].resultProp * 100), 16, 28)
        end
        self.cells[i] = cell
      end)
    end
  end
end

function GiftBoxRewardCell:SetAllCellDestroy()
  if self.cells then
    for key, value in pairs(self.cells) do
      if value and value.name_text then
        value.name_text:SetActive(false)
      end
    end
    self.cells = nil
  end
  self._itemContent_rect:RemoveComponents(UICommonResItem)
  if self.modelItem ~= nil then
    for k, v in pairs(self.modelItem) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

return GiftBoxRewardCell
