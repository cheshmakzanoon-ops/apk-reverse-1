local CookingNeedItem = BaseClass("CookingNeedItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function CookingNeedItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CookingNeedItem:OnDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function CookingNeedItem:ComponentDefine()
  self._add_btn = self:AddComponent(UIButton, "AddBtn")
  self._uiCommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self._num_txt = self:AddComponent(UIText, "NumText")
  self._add_btn:SetOnClick(function()
    self:OnClickAddBtn()
  end)
end

function CookingNeedItem:DataDefine()
end

function CookingNeedItem:DataDestroy()
end

function CookingNeedItem:ReInit(param, activityId)
  self.param = param
  self.activityId = activityId
  if self.param then
    local itemParam = {
      itemId = param.itemId,
      count = param.costNum,
      rewardType = RewardType.GOODS
    }
    self._uiCommonResItem:ReInit(itemParam)
    local haveCount = DataCenter.ItemData:GetItemCount(param.itemId)
    self._add_btn:SetActive(haveCount < param.costNum)
    local haveCountStr = haveCount
    if haveCount < param.costNum then
      haveCountStr = "<color=#ff0000>" .. haveCountStr .. "</color>"
    end
    self._num_txt:SetText(haveCountStr .. "/" .. param.costNum)
  end
end

function CookingNeedItem:OnClickAddBtn()
  if self.param then
    LWResourceLackUtil:GotoGoodsItemLack(self.param.itemId, 1)
  end
end

return CookingNeedItem
