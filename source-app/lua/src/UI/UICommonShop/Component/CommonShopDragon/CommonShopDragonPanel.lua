local base = UIBaseView
local CommonShopDragonPanel = BaseClass("CommonShopDragonPanel", base)
local Localization = CS.GameEntry.Localization
local CommonShopDragonItem = require("UI.UICommonShop.Component.CommonShopDragon.CommonShopDragonItem")
local svGoods_path = "ScrollView"
local content_path = "ScrollView/Content"

function CommonShopDragonPanel:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function CommonShopDragonPanel:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function CommonShopDragonPanel:ComponentDefine()
  self.svGoodsN = self:AddComponent(UIBaseContainer, svGoods_path)
  self.contentN = self:AddComponent(GridInfinityScrollView, content_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.contentN:Init(bindFunc1, bindFunc2, bindFunc3)
end

function CommonShopDragonPanel:ComponentDestroy()
  if not IsNull(self.clickFingerHandle) then
    self.clickFingerHandle:Destroy()
    self.clickFingerHandle = nil
  end
  self:ClearItemCell()
  self.svGoodsN = nil
  self.contentN = nil
end

function CommonShopDragonPanel:DataDefine()
  self.curShowType = nil
  self.goodsList = {}
  self.goodsItemsList = {}
  self.listGO = {}
  self.focusShopId = nil
  self.focusShopItemId = nil
end

function CommonShopDragonPanel:DataDestroy()
  if self.delayCreateFingerTimer then
    self.delayCreateFingerTimer:Stop()
    self.delayCreateFingerTimer = nil
  end
  if self.delayDestroyFingerTimer then
    self.delayDestroyFingerTimer:Stop()
    self.delayDestroyFingerTimer = nil
  end
  self.curShowType = nil
  self.goodsList = nil
  self.goodsItemsList = nil
  self.listGO = nil
  self.focusShopId = nil
  self.focusShopItemId = nil
end

function CommonShopDragonPanel:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateOneCommonShop, self.OnUpdateCommonShop)
  self:AddUIListener(EventId.RefreshItems, self.RefreshAll)
  self:AddUIListener(EventId.UpdateGold, self.RefreshAll)
end

function CommonShopDragonPanel:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateOneCommonShop, self.OnUpdateCommonShop)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshAll)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshAll)
  base.OnRemoveListener(self)
end

function CommonShopDragonPanel:ShowPanel(shopType, focusShopId)
  self.curShowType = CommonShopType.HonorShop
  self.focusShopId = focusShopId
  self.refresh_time_root:SetActive(true)
  self.refresh_time_title:SetLocalText("shop_cycle_tips_02")
  self.refresh_time_txt:SetText("")
  self.endTime = UITimeManager:GetInstance():GetNextMonth()
  self:RefreshAll(self.curShowType)
  self:Update1000MS()
  self:SendGetHonorShopItemsCacheMessage()
end

function CommonShopDragonPanel:Update1000MS()
  if not self:GetActive() then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.endTime ~= nil then
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      local txt = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
      self.refresh_time_txt:SetText(txt)
    else
      self.refresh_time_root:SetActive(false)
    end
  else
    self.refresh_time_root:SetActive(false)
  end
  self.spe_res_num:SetText(string.GetFormattedGoldNum(LuaEntry.Resource.honorScore))
end

function CommonShopDragonPanel:RefreshAll(shopType, focusShopId)
  if shopType and shopType == CommonShopType.HonorShop then
    local focusItemIndex
    if focusShopId then
      self.focusShopItemId = focusShopId
      self.focusShopId = nil
      for i, v in ipairs(self.goodsList) do
        if v.id == focusShopId then
          focusItemIndex = i
          break
        end
      end
      self:HandleFocusShopItemGuide()
    end
    self.goodsList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.HonorShop)
    self.contentN:SetItemCount(#self.goodsList)
    if focusItemIndex then
      self.contentN.gameObject.transform:Set_anchoredPosition(0, 0)
      self.contentN:MoveItemByIndex(focusItemIndex - 1, 0.5)
    end
  end
end

function CommonShopDragonPanel:OnInitScroll(go, index)
  local item = self.svGoodsN:AddComponent(CommonShopDragonItem, go)
  self.listGO[go] = item
end

function CommonShopDragonPanel:OnUpdateScroll(go, index)
  local conf = self.goodsList[index + 1]
  if conf == nil then
    return
  end
  go.name = conf.id
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  cellItem:SetItem(self.goodsList[index + 1])
end

function CommonShopDragonPanel:OnDestroyScrollItem(go, index)
end

function CommonShopDragonPanel:ClearItemCell()
  self.svGoodsN:RemoveComponents(CommonShopDragonItem)
  self.contentN:DestroyChildNode()
end

function CommonShopDragonPanel:SetNodeList(refresh_time_root, refresh_time_title, refresh_time_txt, spe_res_num)
  self.refresh_time_root = refresh_time_root
  self.refresh_time_title = refresh_time_title
  self.refresh_time_txt = refresh_time_txt
  self.spe_res_num = spe_res_num
end

function CommonShopDragonPanel:OnUpdateCommonShop(shopType)
  self:RefreshAll(shopType, self.focusShopId)
end

function CommonShopDragonPanel:GetCellItemByShopId(id)
  if self.listGO then
    for i, v in pairs(self.listGO) do
      if v.goodsConf and v.goodsConf.id == id then
        return v
      end
    end
  end
end

function CommonShopDragonPanel:HandleFocusShopItemGuide()
  if self.focusShopItemId then
    local focusShopItemId = self.focusShopItemId
    self.delayCreateFingerTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.clickFingerHandle = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
      self.clickFingerHandle:completed("+", function(handle)
        if handle.isError then
          return
        end
        CommonUtil.CallAutoArabicMirrorManually(handle)
        local gameObject = handle.gameObject
        local transform = gameObject.transform
        transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Normal.Name).transform, false)
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local item = self:GetCellItemByShopId(focusShopItemId)
        if item and item.goodsItemN then
          transform.position = item.goodsItemN.transform.position
        end
        self.delayDestroyFingerTimer = TimerManager:GetInstance():DelayInvoke(function()
          if self.clickFingerHandle then
            self.clickFingerHandle:Destroy()
            self.clickFingerHandle = nil
          end
        end, 1)
      end)
    end, 1)
    self.focusShopItemId = nil
  end
end

function CommonShopDragonPanel:SendGetHonorShopItemsCacheMessage()
  local curShopIdList = {}
  if not table.IsNullOrEmpty(self.goodsList) then
    for i, v in ipairs(self.goodsList) do
      table.insert(curShopIdList, v.id)
    end
  end
  DataCenter.CommonShopManager:SendGetHonorShopItemsCacheMessage(curShopIdList)
end

return CommonShopDragonPanel
