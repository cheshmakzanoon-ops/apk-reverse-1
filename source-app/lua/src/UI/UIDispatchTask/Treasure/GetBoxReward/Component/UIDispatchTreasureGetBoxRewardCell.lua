local UIDispatchTreasureGetBoxRewardCell = BaseClass("UIDispatchTreasureGetBoxRewardCell", UIBaseContainer)
local base = UIBaseContainer

function UIDispatchTreasureGetBoxRewardCell:OnCreate()
  base.OnCreate(self)
  self._giftIcon_img = self:AddComponent(UIRawImage, "BoxImg")
  self._giftIcon_img_sprite = self:AddComponent(UIImage, "BoxSprite")
  self._tip1_txt = self:AddComponent(UITextMeshProUGUIEx, "TipText1")
  self._tip2_txt = self:AddComponent(UIText, "TipText2")
  self._tip2_txt:SetLocalText("Treasure_map_reward_show_5")
  self._name_txt = self:AddComponent(UIText, "NameText")
  self._prop_txt = self:AddComponent(UIText, "PropText")
  self.LayoutGroup = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "")
  self.LayoutElement = self:AddComponent(UILayoutElement, "ScrollView")
  self.LayoutElement:SetPreferredHeight(188)
  self._itemContent_rect = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content1")
  self.commonRes = self:AddComponent(UICommonResItem, "UICommonResItem")
  self._tip2_txt:SetActive(true)
  self._tip3_txt = self:AddComponent(UITextMeshProUGUIEx, "TipText3")
  self._tip3_txt:SetActive(false)
  self.layout = self:AddComponent(UIBaseContainer, "layout")
  self.layout2 = self:AddComponent(UIBaseContainer, "layout2")
  self.commonRes2 = self:AddComponent(UICommonResItem, "layout/UICommonResItem2")
  self.layout.gameObject:SetActive(false)
  self.layout2.gameObject:SetActive(false)
end

function UIDispatchTreasureGetBoxRewardCell:OnDestroy()
  self:SetAllCellDestroy()
  base.OnDestroy(self)
end

function UIDispatchTreasureGetBoxRewardCell:SetTip2TextActive(flag)
  self._tip2_txt:SetActive(flag)
end

function UIDispatchTreasureGetBoxRewardCell:ReInit(rewardData, showType)
  if showType == TreasureRewardType.ExplorerTreasure then
    self:SetSpriteIcon(rewardData.boxIconPath)
    self:SetTip2TextActive(false)
    self._name_txt:SetLocalText(rewardData.nameStrId)
  elseif showType == TreasureRewardType.DigTreasure then
    self:SetSpriteIcon(rewardData.boxIconPath)
    self:SetTip2TextActive(false)
    self._name_txt:SetText(rewardData.nameStrId)
  else
    self:SetRawImageIcon(rewardData.boxIconPath)
    self:SetTip2TextActive(true)
    self._name_txt:SetLocalText(rewardData.nameStrId)
    if showType == TreasureRewardType.MapNew then
      self:SetExtraIcon(rewardData)
    elseif showType == TreasureRewardType.BoxRewardAct then
      self:SetExtraBoxIcon(rewardData)
    end
  end
  if showType == TreasureRewardType.DigTreasure then
    self._prop_txt:SetLocalText("treasure_map_reward_show_04")
  elseif rewardData.prob then
    self._prop_txt:SetLocalText("Treasure_map_reward_show_4", string.formatDecimal(rewardData.prob * 100, 1) .. "%")
  else
    self._prop_txt:SetText("")
  end
  self:RefreshItemReward(rewardData.rewardInfo)
end

function UIDispatchTreasureGetBoxRewardCell:SetSpriteIcon(path)
  self._giftIcon_img_sprite:LoadSprite(path)
  self._giftIcon_img_sprite:SetNativeSize()
  self._giftIcon_img_sprite:SetActive(true)
  self._giftIcon_img:SetActive(false)
end

function UIDispatchTreasureGetBoxRewardCell:SetRawImageIcon(path)
  self._giftIcon_img:LoadSprite(path)
  self._giftIcon_img:SetActive(true)
  self._giftIcon_img_sprite:SetActive(false)
end

function UIDispatchTreasureGetBoxRewardCell:RefreshItemReward(listReward)
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
        cell:ReInit(listReward[i].rewardParam)
        if listReward[i].prop then
          cell.name_text:SetActive(true)
          cell:SetNameText(string.formatDecimal(listReward[i].prop * 100, 2) .. "%", 16, 28)
        end
        self.cells[i] = cell
      end)
    end
  end
end

function UIDispatchTreasureGetBoxRewardCell:SetAllCellDestroy()
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
    self.modelItem = nil
  end
  if self.cells2 then
    for key, value in pairs(self.cells2) do
      if value and value.name_text then
        value.name_text:SetActive(false)
      end
    end
    self.cells2 = nil
  end
  self.layout2:RemoveComponents(UICommonResItem)
  if self.modelItem2 ~= nil then
    for k, v in pairs(self.modelItem2) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.modelItem2 = nil
  end
end

function UIDispatchTreasureGetBoxRewardCell:SetExtraIcon(rewardData)
  if rewardData.hummerId == nil then
    return
  end
  self.LayoutElement:SetPreferredHeight(315)
  self._tip3_txt:SetActive(true)
  self._tip3_txt:SetLocalText("treasure_map_reward_show_01")
  self.layout.gameObject:SetActive(true)
  self.layout2.gameObject:SetActive(false)
  local param = {}
  param.rewardType = RewardType.GOODS
  param.itemId = rewardData.hummerId
  param.count = rewardData.hummerNum
  self.commonRes2.gameObject:SetActive(true)
  self.commonRes2:ReInit(param)
  self.commonRes2.name_text:SetActive(true)
  self.commonRes2:SetNameText(string.formatDecimal(rewardData.hummerProb * 1, 2) .. "%", 16, 28)
end

function UIDispatchTreasureGetBoxRewardCell:SetExtraBoxIcon(rewardData)
  if table.IsNullOrEmpty(rewardData.pointRewardList) then
    return
  end
  self.commonRes2.gameObject:SetActive(false)
  self.LayoutElement:SetPreferredHeight(315)
  self._tip3_txt:SetActive(true)
  self._tip3_txt:SetLocalText("treasure_map_reward_show_01")
  self.layout.gameObject:SetActive(false)
  self.layout2.gameObject:SetActive(true)
  self.modelItem2 = {}
  self.cells2 = {}
  for i, v in ipairs(rewardData.pointRewardList) do
    self.modelItem2[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:Set_sizeDelta(100, 100)
      go.transform:SetParent(self.layout2.transform)
      go.transform:Set_localScale(0.9, 0.9, 0.9)
      go.name = "item_reward2_" .. i
      local cell = self.layout2:AddComponent(UICommonResItem, go.name)
      local param = {}
      param.rewardType = RewardType.GOODS
      param.itemId = rewardData.pointRewardList[i].id
      param.count = rewardData.pointRewardList[i].value
      cell:ReInit(param)
      if rewardData.pointRewardList[i].probability then
        cell.name_text:SetActive(true)
        cell:SetNameText(string.formatDecimal(rewardData.pointRewardList[i].probability, 2) .. "%", 16, 28)
      end
      self.cells2[i] = cell
    end)
  end
end

return UIDispatchTreasureGetBoxRewardCell
