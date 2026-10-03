local base = UIBaseContainer
local DirectionGiftListComponent = BaseClass("DirectionGiftListComponent", base)
local QuickGiftItem = require("UI/LWPlayerInfo/UILWGiftSystem/QuickGift/Component/QuickGiftItem")

function DirectionGiftListComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DirectionGiftListComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DirectionGiftListComponent:ShowGiftList(param, itemCallBack)
  if not (param and param.giftList) or #param.giftList == 0 then
    return
  end
  if not param.target or not param.target.rectTransform then
    return
  end
  self:ClearGifts()
  self.target = param.target
  self.param = param
  self.itemCallBack = itemCallBack
  self.sendUid = param.playerUid
  self.direction = param.dirType
  local giftList = param.giftList
  local itemParam = {
    showItemAnim = param.showItemAnim,
    showBubbleBg = param.showBubbleBg,
    playerUid = param.playerUid,
    itemClickCd = param.itemClickCd,
    clickAnim = param.clickAnim,
    dirType = param.dirType
  }
  local loadedCount = 0
  local listCount = #giftList
  self:OnGiftItemLoadFinish()
  for i = 1, listCount do
    local giftId = giftList[i]
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.LWUIQuickGiftItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.name = "item" .. i
      local newItem = self:AddComponent(QuickGiftItem, go.name)
      newItem:SetData(giftId, itemParam, function(id)
        self:OnItemClick(id)
      end)
      self.giftItemList[i] = newItem
      self.giftItemDic[giftId] = newItem
      loadedCount = loadedCount + 1
      if loadedCount == listCount then
        self:OnGiftItemLoadFinish()
        self:RefreshFirstItem()
      end
    end)
  end
end

function DirectionGiftListComponent:OnItemClick(id)
  if self.itemCallBack then
    self.itemCallBack(id, self.giftItemDic[id])
    self:RefreshFirstItem()
  end
end

function DirectionGiftListComponent:RefreshFirstItem()
  if not self.giftItemList then
    return
  end
  local first
  for i = 1, #self.giftItemList do
    local item = self.giftItemList[i]
    if item then
      item:SetAsFirst(false)
      if not first and item.gameObject and item.gameObject.activeSelf then
        first = item
      end
    end
  end
  if first then
    first:SetAsFirst(true)
  end
end

function DirectionGiftListComponent:OnGiftItemLoadFinish()
  if not self.target or not self.target.rectTransform then
    return
  end
  local directionType = GiftSystemConst.GiftSendPanelDirection
  local targetRect = self.target.rectTransform
  local parentTransform = self.transform.parent
  local worldPos = targetRect.position
  local pivotX, pivotY = targetRect.pivot.x, targetRect.pivot.y
  local width, height = targetRect.rect.width, targetRect.rect.height
  local posX, posY = worldPos.x, worldPos.y
  posY = worldPos.y + (0.5 - pivotY) * height
  posX = worldPos.x + (0.5 - pivotX) * width
  local localPos = parentTransform:InverseTransformPoint(Vector3.New(posX, posY, worldPos.z))
  if self.direction == directionType.Up then
    localPos.y = localPos.y + height / 2
  elseif self.direction == directionType.Down then
    localPos.y = localPos.y - height / 2
  elseif self.direction == directionType.Left then
    localPos.x = localPos.x - width / 2
  elseif self.direction == directionType.Right then
    localPos.x = localPos.x + width / 2
  end
  self:SetLocalPositionXYZ(localPos.x, localPos.y, localPos.z)
  self.transform:Set_localScale(1.5, 1.5, 1.5)
  self:SetActive(true)
end

function DirectionGiftListComponent:ComponentDefine()
end

function DirectionGiftListComponent:ComponentDestroy()
end

function DirectionGiftListComponent:DataDefine()
  self.giftItemList = {}
  self.giftItemDic = {}
  self.model = {}
end

function DirectionGiftListComponent:ClearGifts()
  self:RemoveComponents(QuickGiftItem)
  if self.model then
    for _, req in pairs(self.model) do
      if req then
        self:GameObjectDestroy(req)
      end
    end
  end
  self.model = {}
  self.giftItemList = {}
  self.giftItemDic = {}
end

function DirectionGiftListComponent:DataDestroy()
  self:ClearGifts()
  self.param = nil
  self.itemCallBack = nil
  self.sendUid = nil
  self.model = nil
  self.giftItemList = nil
  self.giftItemDic = nil
end

function DirectionGiftListComponent:SetTarget(target)
  self.target = target
end

function DirectionGiftListComponent:SetDirection(direction)
  self.direction = direction
end

function DirectionGiftListComponent:SetSendUid(uid)
  self.sendUid = uid
end

return DirectionGiftListComponent
