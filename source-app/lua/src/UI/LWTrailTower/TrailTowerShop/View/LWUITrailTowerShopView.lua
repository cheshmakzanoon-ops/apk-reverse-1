local LWUITrailTowerShopView = BaseClass("LWUITrailTowerShopView", UIBaseView)
local base = UIBaseView
local TrailTowerShopItem = require("UI.LWTrailTower.TrailTowerShop.Component.LWUICommonTrailTowerShopItemRender")
local Localization = CS.GameEntry.Localization
local scroll_view_path = "ScrollBg/ScrollView"

function LWUITrailTowerShopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUITrailTowerShopView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUITrailTowerShopView:ComponentDefine()
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
end

function LWUITrailTowerShopView:ComponentDestroy()
  if not IsNull(self.clickFingerHandle) then
    self.clickFingerHandle:Destroy()
    self.clickFingerHandle = nil
  end
  self.txt_title = nil
  self.scroll_view = nil
  self.return_btn = nil
  self.return2_btn = nil
  self.tip_txt = nil
  self.donate_txt = nil
  self.donate_img = nil
end

function LWUITrailTowerShopView:DataDefine()
  self.needItemId = 0
  self.shopList = {}
  self.refreshTime = nil
  self.sentReq = false
  self.focusShopId = nil
  self.hasRefreshOnce = false
  self.focusShopItemIndex = nil
end

function LWUITrailTowerShopView:DataDestroy()
  if self.delayDestroyFingerTimer then
    self.delayDestroyFingerTimer:Stop()
    self.delayDestroyFingerTimer = nil
  end
  if self.delayCreateFingerTimer then
    self.delayCreateFingerTimer:Stop()
    self.delayCreateFingerTimer = nil
  end
  self.needItemId = nil
  self.shopList = nil
  self.refreshTime = nil
  self.sentReq = false
  self.focusShopId = nil
  self.hasRefreshOnce = nil
  self.focusShopItemIndex = nil
end

function LWUITrailTowerShopView:OnEnable()
  base.OnEnable(self)
  if self.hasRefreshOnce then
    self:RefreshScrollView()
  end
  local cacheKey = "trailTower_shop_open1_" .. LuaEntry.Player.uid
  local lastTimeS = CS.GameEntry.Setting:GetInt(cacheKey, 0)
  local serverTime = UITimeManager:GetInstance():GetServerSeconds()
  local sameDay = UITimeManager:GetInstance():IsSameDayForServer(lastTimeS, serverTime)
  if not sameDay then
    CS.GameEntry.Setting:SetInt(cacheKey, serverTime)
    DataCenter.CommonShopManager:UpdateRed(CommonShopType.TrailTowerShop)
  end
end

function LWUITrailTowerShopView:OnDisable()
  base.OnDisable(self)
end

function LWUITrailTowerShopView:OnDisable()
  base.OnDisable(self)
end

function LWUITrailTowerShopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateOneCommonShop, self.PreRefresh)
  self:AddUIListener(EventId.RefreshItems, self.UpdateTopBarItemCount)
end

function LWUITrailTowerShopView:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateOneCommonShop, self.PreRefresh)
  self:RemoveUIListener(EventId.RefreshItems, self.UpdateTopBarItemCount)
  base.OnRemoveListener(self)
end

function LWUITrailTowerShopView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(TrailTowerShopItem)
end

function LWUITrailTowerShopView:OnCellMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(TrailTowerShopItem, itemObj)
  cellItem:SetItemShow(self.shopList[index])
  if self.focusShopItemIndex and index == self.focusShopItemIndex then
    self.delayCreateFingerTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.clickFingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
      self.clickFingerHandle:completed("+", function(handle)
        if handle.isError then
          return
        end
        CommonUtil.CallAutoArabicMirrorManually(handle)
        local gameObject = handle.gameObject
        local transform = gameObject.transform
        transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Normal.Name).transform, false)
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        if IsNotNull(itemObj) and IsNotNull(itemObj.transform) then
          local rewardTrans = itemObj.transform:Find("Bg/RewardItem")
          if IsNotNull(rewardTrans) then
            transform.position = rewardTrans.position
          end
        end
        self.delayDestroyFingerTimer = TimerManager:GetInstance():DelayInvoke(function()
          if self.clickFingerHandle then
            self.clickFingerHandle:Destroy()
            self.clickFingerHandle = nil
          end
        end, 1)
      end)
    end, 1)
    self.focusShopItemIndex = nil
  end
end

function LWUITrailTowerShopView:OnCellMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, TrailTowerShopItem)
end

function LWUITrailTowerShopView:PreRefresh(shopId)
  if shopId == CommonShopType.TrailTowerShop then
    self:RefreshScrollView(self.focusShopId)
  end
end

function LWUITrailTowerShopView:RefreshScrollView(focusShopId)
  self.hasRefreshOnce = true
  self:ClearScroll()
  self.refreshTime = UITimeManager:GetInstance():GetNextWeekDay(1)
  self.shopList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.TrailTowerShop)
  if #self.shopList > 0 then
    local focusItemIndex
    if focusShopId then
      for i, v in ipairs(self.shopList) do
        if v.id == focusShopId then
          self.focusShopItemIndex = i
          focusItemIndex = i
          break
        end
      end
    end
    local shopGoodsConfig = self.shopList[1]
    self.needItemId = shopGoodsConfig.currencyId
    self.ScrollView:SetTotalCount(#self.shopList)
    self.ScrollView:RefillCells()
    if focusItemIndex then
      self.ScrollView:ScrollToCell(focusItemIndex, 2000)
    end
  elseif self.sentReq == false then
    self.sentReq = true
    SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.TrailTowerShop)
  end
  self:UpdateTopBarItemCount()
  self:Update1000MS()
end

function LWUITrailTowerShopView:Update1000MS()
  if self.refreshTime == nil then
    return
  end
  if not self:GetActive() then
    return
  end
  local t = "00:00:00"
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.refreshTime then
    local timeLeft = self.refreshTime - curTime
    t = UITimeManager:GetInstance():MilliSecondToFmtString(timeLeft)
  end
  if self.refresh_time_txt ~= nil then
    self.refresh_time_txt:SetText(t)
  end
end

function LWUITrailTowerShopView:UpdateTopBarItemCount()
  local itemCount = DataCenter.ItemData:GetItemCount(tonumber(self.needItemId))
  if self.spe_res_num ~= nil then
    self.spe_res_num:SetText(string.GetFormattedGoldNum(itemCount or 0))
  end
end

function LWUITrailTowerShopView:SetNodeList(refresh_time_root, refresh_time_title, refresh_time_txt, spe_res_num)
  self.refresh_time_root = refresh_time_root
  self.refresh_time_title = refresh_time_title
  self.refresh_time_txt = refresh_time_txt
  self.spe_res_num = spe_res_num
end

function LWUITrailTowerShopView:ShowPanel(shopType, focusShopId)
  self.refresh_time_root:SetActive(true)
  self.refresh_time_title:SetLocalText("shop_cycle_tips_01")
  self.refresh_time_txt:SetText("")
  self.focusShopId = focusShopId
  self:RefreshScrollView()
end

return LWUITrailTowerShopView
