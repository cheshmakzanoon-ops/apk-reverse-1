local UIActLotteryItemGetManualView = BaseClass("UIActLotteryItemGetManualView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActLotteryItemGetManualItem = require("UI.UIActLottery.UIActLotteryItemGetManual.Component.UIActLotteryItemGetManualItem")
local UIActLotteryItemGetManualItem_path = "Assets/Main/Prefabs/UI/ActivityCenter/ActLottery/UIActLotteryItemGetManualItem.prefab"
local manual_content_path = "ManualContent"
local manual_scroll_path = "ManualContent/Common_bg/ManualScroll"
local manual_layout_path = "ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout"
local can_drag_img_path = "ManualContent/Common_bg/canDragImg"

function UIActLotteryItemGetManualView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:UpdateContent()
end

function UIActLotteryItemGetManualView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActLotteryItemGetManualView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.textTitle:SetLocalText("decoration_recruit_desc26")
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.manual_content = self:AddComponent(UIBaseContainer, manual_content_path)
  self.manual_scroll = self:AddComponent(UIScrollRect, manual_scroll_path)
  self.manual_layout = self:AddComponent(UIBaseContainer, manual_layout_path)
  self.can_drag_img = self:AddComponent(UIButton, can_drag_img_path)
  self.can_drag_img:SetOnClick(function()
    self:TryToNextManualItem()
  end)
  self.manual_scroll:AddValueChangeListener(function()
    self:OnManualScrollDrag()
  end)
end

function UIActLotteryItemGetManualView:ComponentDestroy()
  self:ClearManualScroll()
  self.manual_scroll:RemoveAllListeners()
  self.manual_content = nil
  self.manual_scroll = nil
  self.manual_layout = nil
  self.can_drag_img = nil
end

function UIActLotteryItemGetManualView:DataDefine()
  self.activityId = self:GetUserData()
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.paraTemp = DataCenter.ActLotteryDataManager:GetTempByActInfo(self.activityInfo)
end

function UIActLotteryItemGetManualView:DataDestroy()
end

function UIActLotteryItemGetManualView:OnAddListener()
  base.OnAddListener(self)
end

function UIActLotteryItemGetManualView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActLotteryItemGetManualView:UpdateContent()
  if self.activityId == nil then
    return
  end
  self:UpdateManualContent()
end

function UIActLotteryItemGetManualView:UpdateManualContent()
  self.manual_layout:SetAnchoredPositionXY(0, 0)
  local guidIdList = {}
  if self.paraTemp and 0 < #self.paraTemp.getmore_way then
    guidIdList = self.paraTemp.getmore_way
  end
  local hasDoneManual = false
  self:ClearManualScroll()
  for i = 1, #guidIdList do
    self.reqsManual[i] = self:GameObjectInstantiateAsync(UIActLotteryItemGetManualItem_path, function(request)
      if request.isError or self.manual_layout == nil then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.manual_layout.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = "item_manual_" .. tostring(i)
      go.name = nameStr
      go.gameObject:SetActive(true)
      local cell = self.manual_layout:AddComponent(UIActLotteryItemGetManualItem, go.name)
      cell:ReInit(self.activityId, guidIdList[i], i, #guidIdList)
      self.itemsManual[i] = cell
      if i == #guidIdList then
        hasDoneManual = true
        if hasDoneManual and self.manual_layout then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.manual_layout.transform)
          self:OnManualScrollDrag()
        end
      end
    end)
  end
end

function UIActLotteryItemGetManualView:ClearManualScroll()
  self.manual_layout:RemoveComponents(UIActLotteryItemGetManualItem)
  if self.reqsManual and next(self.reqsManual) then
    for k, v in pairs(self.reqsManual) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.reqsManual = {}
  self.itemsManual = {}
end

function UIActLotteryItemGetManualView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIActLotteryItemGetManualView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIActLotteryItemGetManualView:OnManualScrollDrag()
  local scrollSize = self.manual_scroll:GetSizeDelta()
  local layoutSize = self.manual_layout:GetSizeDelta()
  local layoutPos = self.manual_layout:GetAnchoredPosition()
  local isArrowShow = false
  if layoutSize.y > scrollSize.y and layoutPos.y < layoutSize.y - scrollSize.y - 10 then
    isArrowShow = true
  end
  self.can_drag_img:SetActive(isArrowShow)
end

function UIActLotteryItemGetManualView:TryToNextManualItem()
  local scrollSize = self.manual_scroll:GetSizeDelta()
  local layoutSize = self.manual_layout:GetSizeDelta()
  local layoutPos = self.manual_layout:GetAnchoredPosition()
  local maxPos = 0
  if layoutSize.y > scrollSize.y then
    maxPos = layoutSize.y - scrollSize.y - 10
  end
  if maxPos <= layoutPos.y then
    return
  end
  local curIndex = 0
  local curH = 0
  local curItemH = 0
  for i, item in ipairs(self.itemsManual) do
    local itemSize = item:GetSizeDelta()
    if layoutPos.y < curH + itemSize.y - 10 then
      curIndex = i
      curItemH = itemSize.y
      break
    end
    curH = curH + itemSize.y
  end
  local needToPos = curH + curItemH
  if maxPos < needToPos then
    needToPos = maxPos
  end
  self.manual_layout:SetAnchoredPositionXY(0, needToPos)
end

return UIActLotteryItemGetManualView
