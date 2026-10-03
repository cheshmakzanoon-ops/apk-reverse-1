local CellPointGood = BaseClass("CellPointGood", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function CellPointGood:OnCreate()
  base.OnCreate(self)
  self.itemComp = self:AddComponent(UICommonResItem, "Rect_item")
  self._quality_img = self:AddComponent(UIImage, "Rect_item/clickBtn/ImgQuality")
  self._icon_img = self:AddComponent(UIImage, "Rect_item/clickBtn/ItemIcon")
  self._flag_txt = self:AddComponent(UIText, "Rect_item/clickBtn/FlagGo/FlagText")
  self._name_txt = self:AddComponent(UIText, "Txt_Name")
  self._desc_txt = self:AddComponent(UIText, "Txt_Desc")
  self._purchase_btn = self:AddComponent(UIButton, "Btn_Purchase")
  self._purchase_txt = self:AddComponent(UIText, "Btn_Purchase/BuyBtnLabel/BuyBtnName")
  self._purchase_txt:SetLocalText(110001)
  self._price_txt = self:AddComponent(UIText, "Btn_Purchase/BuyBtnLabel/BuyBtnValue")
  self._use_btn = self:AddComponent(UIButton, "Btn_Use")
  self._use_txt = self:AddComponent(UIText, "Btn_Use/Txt_Use")
  self._use_txt:SetLocalText(110046)
  self._count_txt = self:AddComponent(UIText, "Txt_Count")
  self._batchBuy_rect = self:AddComponent(UIImage, "Rect_BatchBuy")
  self._batchBuy_btn = self:AddComponent(UIButton, "Rect_BatchBuy/Btn_BatchBuy")
  self._batchBuy_txt = self:AddComponent(UIText, "Rect_BatchBuy/Btn_BatchBuy/Txt_BatchBuy")
  self._batchUse_rect = self:AddComponent(UIImage, "Rect_BatchUse")
  self._batchUse_btn = self:AddComponent(UIButton, "Rect_BatchUse/Btn_BatchUse")
  self._batchUse_txt = self:AddComponent(UIText, "Rect_BatchUse/Btn_BatchUse/Txt_BatchUse")
  self._batchUse_btn:SetOnClick(function()
    self:OnBatchUseClick()
  end)
  self._purchase_btn:SetOnClick(function()
    self:OnBuyClick(1)
  end)
  self._use_btn:SetOnClick(function()
    self:OnUseClick()
  end)
end

function CellPointGood:OnDestroy()
  self.itemComp = nil
  self._quality_img = nil
  self._icon_img = nil
  self._flag_txt = nil
  self._name_txt = nil
  self._desc_txt = nil
  self._purchase_btn = nil
  self._purchase_txt = nil
  self._price_txt = nil
  self._use_btn = nil
  self._use_txt = nil
  self._count_txt = nil
  self._batchBuy_rect = nil
  self._batchBuy_btn = nil
  self._batchBuy_txt = nil
  self._batchUse_rect = nil
  self._batchUse_btn = nil
  self._batchUse_txt = nil
  self.item = nil
  self.callBack = nil
  self.index = nil
  base.OnDestroy(self)
end

function CellPointGood:OnEnable()
  base.OnEnable(self)
end

function CellPointGood:OnDisable()
  base.OnDisable(self)
end

function CellPointGood:RefreshPriceTextColor()
  if self.id then
    local good = DataCenter.ItemTemplateManager:GetItemTemplate(self.id)
    if good and LuaEntry.Player.gold < good.price then
      self._price_txt:SetColor(RedColor)
    else
      self._price_txt:SetColor(WhiteColor)
    end
  end
end

function CellPointGood:RefreshData(id, callBack, index)
  self.id = tonumber(id)
  self.callBack = callBack
  self.index = index
  self._batchUse_rect:SetActive(false)
  self.item = DataCenter.ItemData:GetItemById(self.id)
  if self.item == nil then
    self._use_btn:SetActive(false)
    self._purchase_btn:SetActive(true)
    self._count_txt:SetActive(false)
  else
    self._use_btn:SetActive(true)
    self._purchase_btn:SetActive(false)
    self._count_txt:SetActive(true)
    self._count_txt:SetLocalText(GameDialogDefine.OWN, self.item.count)
  end
  local good = DataCenter.ItemTemplateManager:GetItemTemplate(self.id)
  if good ~= nil then
    local para = {}
    para.rewardType = RewardType.GOODS
    para.itemId = self.id
    self.itemComp:ReInit(para)
    self._name_txt:SetText(DataCenter.ItemTemplateManager:GetName(self.id))
    self._desc_txt:SetLocalText(good.description)
    self._price_txt:SetText(good.price)
    self.addPoint = good.para
    self:RefreshPriceTextColor()
  end
end

function CellPointGood:UpdateNum(id)
  self.item = DataCenter.ItemData:GetItemById(id)
  if self.item == nil then
    self._use_btn:SetActive(false)
    self._purchase_btn:SetActive(true)
    self._count_txt:SetActive(false)
  else
    self._use_btn:SetActive(true)
    self._purchase_btn:SetActive(false)
    self._count_txt:SetActive(true)
    self._count_txt:SetLocalText(GameDialogDefine.OWN, self.item.count)
  end
end

function CellPointGood:GetNeedNum()
  if self.addPoint == 0 then
    return
  end
  local dis = DataCenter.VIPManager:GetNextVipData().point - DataCenter.VIPManager:GetVipData().score - self.addPoint
  local num = math.ceil(dis / self.addPoint)
  return num
end

function CellPointGood:OnBuyClick(count)
  local good = DataCenter.ItemTemplateManager:GetItemTemplate(self.id)
  if LuaEntry.Player.gold < good.price * count then
    GoToUtil.GotoPayTips(good.price * count)
    return
  end
  UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING, string.GetFormattedSeperatorNum(good.price), Localization:GetString(GameDialogDefine.DIAMOND), Localization:GetString(good.name, good.para2)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self.batchNum = 0
    self._use_btn:SetActive(false)
    SFSNetwork.SendMessage(MsgDefines.ItemBuyAndUse, {
      itemId = tostring(self.id),
      num = count
    })
  end)
end

function CellPointGood:OnUseClick()
  self.batchNum = 0
  self._batchUse_rect:SetActive(false)
  self.callBack(self.index)
  self:ShowUseBatch()
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = self.item.uuid,
    num = 1
  })
end

function CellPointGood:OnBatchUseClick()
  self._batchUse_rect:SetActive(false)
  self.callBack(self.index)
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = self.item.uuid,
    num = self.batchNum
  })
end

function CellPointGood:OnBatchBuyClick()
  self._batchBuy_rect:SetActive(false)
  self:OnBuyClick(self.batchNum)
end

function CellPointGood:ShowUseBatch()
  if self.batchNum > 0 then
    self.batchNum = 0
    return
  end
  local needNum = self:GetNeedNum()
  if needNum > self.item.count - 1 then
    needNum = self.item.count - 1
  else
    needNum = needNum - 1
  end
  self.batchNum = needNum
  if needNum < 1 then
    self._batchUse_rect:SetActive(false)
    return
  end
  self._batchUse_txt:SetText("X" .. needNum)
  self._batchUse_rect:SetActive(true)
end

function CellPointGood:ShowBuyBatch()
  if self.batchNum > 0 then
    self.batchNum = 0
    return
  end
  local needNum = self:GetNeedNum()
  if needNum > item.count then
    needNum = item.count
  end
  if needNum < 1 then
    self._batchBuy_rect:SetActive(false)
    return
  end
  self._batchBuy_txt:SetText("X" .. needNum)
  self._batchBuy_rect:SetActive(true)
end

return CellPointGood
