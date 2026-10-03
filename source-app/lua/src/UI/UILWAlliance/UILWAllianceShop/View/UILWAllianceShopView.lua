local UILWAllianceShopView = BaseClass("UILWAllianceShopView", UIBaseView)
local base = UIBaseView
local UILWAllianceShopItem = require("UI.UILWAlliance.UILWAllianceShop.Component.UILWAllianceShopItem")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local Localization = CS.GameEntry.Localization
local title_txt_path = "UICommonPopUpTitle/Common_img_title/titleText"
local return_path2 = "UICommonPopUpTitle/panel"
local scroll_view_path = "ScrollBg/ScrollView"
local return_btn_path = "UICommonPopUpTitle/CloseBtn"
local tip_txt_path = "donatePro/tip_txt"
local cd_txt_path = "donatePro/cd_txt"
local donate_txt_path = "donatePro/donate_txt"
local donate_img_path = "donatePro/donate_img"

function UILWAllianceShopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAllianceShopView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAllianceShopView:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, title_txt_path)
  self.txt_title:SetLocalText(390168)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return2_btn = self:AddComponent(UIButton, return_path2)
  self.return2_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tip_txt = self:AddComponent(UIText, tip_txt_path)
  self.tip_txt:SetLocalText(104209, "")
  self.cd_txt = self:AddComponent(UIText, cd_txt_path)
  self.donate_txt = self:AddComponent(UIText, donate_txt_path)
  self.donate_img = self:AddComponent(UIButton, donate_img_path)
  self.donate_img:SetOnClick(function()
    self:OnShowDonateTip()
  end)
end

function UILWAllianceShopView:ComponentDestroy()
  if not IsNull(self.clickFingerHandle) then
    self.clickFingerHandle:Destroy()
    self.clickFingerHandle = nil
  end
  self.txt_title = nil
  self.scroll_view = nil
  self.return_btn = nil
  self.return2_btn = nil
  self.tip_txt = nil
  self.cd_txt = nil
  self.donate_txt = nil
  self.donate_img = nil
end

function UILWAllianceShopView:DataDefine()
  self.shopList = {}
  self.refreshTime = nil
  self.sentReq = false
  self.focusShopId = nil
  self.hasRefreshOnce = false
end

function UILWAllianceShopView:DataDestroy()
  if self.delayDestroyFingerTimer then
    self.delayDestroyFingerTimer:Stop()
    self.delayDestroyFingerTimer = nil
  end
  if self.delayCreateFingerTimer then
    self.delayCreateFingerTimer:Stop()
    self.delayCreateFingerTimer = nil
  end
  self.shopList = nil
  self.sentReq = false
  self.focusShopId = nil
  self.hasRefreshOnce = nil
end

function UILWAllianceShopView:OnEnable()
  base.OnEnable(self)
  self:UpdateDonate()
  if self.hasRefreshOnce then
    self:RefreshScrollView()
  end
  local click_count = UIUtil.GetWeekActiveCount("AllianceShopWeekOpenCount", true)
  if click_count == 0 then
    DataCenter.CommonShopManager:UpdateRed(CommonShopType.AllianceShop)
    EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
  end
end

function UILWAllianceShopView:OnDisable()
  base.OnDisable(self)
end

function UILWAllianceShopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.UpdateDonate)
  self:AddUIListener(EventId.UpdateOneCommonShop, self.PreRefresh)
end

function UILWAllianceShopView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.UpdateDonate)
  self:RemoveUIListener(EventId.UpdateOneCommonShop, self.PreRefresh)
  base.OnRemoveListener(self)
end

function UILWAllianceShopView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UILWAllianceShopItem)
end

function UILWAllianceShopView:OnCellMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UILWAllianceShopItem, itemObj)
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
        if cellItem and cellItem.reward_item then
          transform.position = cellItem.reward_item.transform.position
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

function UILWAllianceShopView:OnCellMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UILWAllianceShopItem)
end

function UILWAllianceShopView:PreRefresh(shopId)
  if shopId == CommonShopType.AllianceShop then
    self:RefreshScrollView(self.focusShopId)
  end
end

function UILWAllianceShopView:RefreshScrollView(focusShopId)
  self.hasRefreshOnce = true
  self:ClearScroll()
  self.refreshTime = UITimeManager:GetInstance():GetNextWeekDay(1)
  self.shopList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.AllianceShop)
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
    self.ScrollView:SetTotalCount(#self.shopList)
    self.ScrollView:RefillCells()
    if focusItemIndex then
      self.ScrollView:ScrollToCell(focusItemIndex, 2000)
    end
  elseif self.sentReq == false then
    self.sentReq = true
    SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, CommonShopType.AllianceShop)
  end
  self:UpdateDonate()
  self:Update1000MS()
end

function UILWAllianceShopView:UpdateDonate()
  local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if baseData ~= nil then
    self.donate_txt:SetText(baseData.accPoint)
    if self.spe_res_num ~= nil then
      self.spe_res_num:SetText(string.GetFormattedGoldNum(baseData.accPoint))
    end
  end
end

function UILWAllianceShopView:Update1000MS()
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
  self.cd_txt:SetText(t)
  if self.refresh_time_txt ~= nil then
    self.refresh_time_txt:SetText(t)
  end
end

function UILWAllianceShopView:OnShowDonateTip()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.donate_img.transform.position + Vector3.New(20, 0, 0) * scaleFactor
  local strTitle
  local strContent = Localization:GetString("391084")
  local param = UIHeroTipView.Param.New()
  param.title = strTitle
  param.content = strContent
  param.dir = UIHeroTipView.Direction.RIGHT
  param.defWidth = 240
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

function UILWAllianceShopView:SetNodeList(refresh_time_root, refresh_time_title, refresh_time_txt, spe_res_num)
  self.refresh_time_root = refresh_time_root
  self.refresh_time_title = refresh_time_title
  self.refresh_time_txt = refresh_time_txt
  self.spe_res_num = spe_res_num
end

function UILWAllianceShopView:ShowPanel(shopType, focusShopId)
  self.refresh_time_root:SetActive(true)
  self.refresh_time_title:SetLocalText("shop_cycle_tips_01")
  self.refresh_time_txt:SetText("")
  self.focusShopId = focusShopId
  self:RefreshScrollView()
end

return UILWAllianceShopView
