local LWPropUsePanelView = BaseClass("LWUIResourceInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function LWPropUsePanelView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function LWPropUsePanelView:ComponentDefine()
  self.scrollView = self:AddComponent(UIScrollView, "panel/Common_bg_orange/Scroll View")
  self.comfirmText = self:AddComponent(UIText, "panel/Common_bg_orange/Comfirm/BtnName")
  self.comfirmBtn = self:AddComponent(UIButton, "panel/Common_bg_orange/Comfirm")
  self.cancelBtn = self:AddComponent(UIButton, "panel/Common_bg_orange/Cancel")
  self.cancelText = self:AddComponent(UIText, "panel/Common_bg_orange/Cancel/cancelBtnName")
  self.bgCloseBtn = self:AddComponent(UIButton, "panel")
  self.closeBtn = self:AddComponent(UIButton, "panel/Common_bg_orange/closeBtn")
  self.text_titleText = self:AddComponent(UIText, "panel/Common_bg_orange/text_title")
  self.totalSpeedRoot = self:AddComponent(UIText, "panel/Common_bg_orange/Text/TotalSpeed")
  self.totalSpeedNameText = self:AddComponent(UIText, "panel/Common_bg_orange/Text/TotalSpeed/TotalSpeedName")
  self.totalSpeedTimeText = self:AddComponent(UIText, "panel/Common_bg_orange/Text/TotalSpeed/TotalSpeedTime")
  self.remainingTimeText = self:AddComponent(UIText, "panel/Common_bg_orange/Text/RemainingTime")
  self.textPart = self:AddComponent(UIBaseComponent, "panel/Common_bg_orange/Text")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.bgCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.cancelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.comfirmBtn:SetOnClick(function()
    if self.callBack then
      self.callBack()
    end
    self.ctrl:CloseSelf()
  end)
  self.comfirmBtn:SetSafeClickMode(true)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.cancelText:SetLocalText(110106)
  self.comfirmText:SetLocalText(110006)
  self.text_titleText:SetLocalText(100159)
  self.desert_battle_tips_btn = self:AddComponent(UIButton, "panel/Common_bg_orange/DesertBattleTipsBtn")
  self.desert_battle_tips_btn:SetOnClick(function()
    UIUtil.ShowTipsId("Desert_strom_tips1017")
  end)
  local worldId = LuaEntry.Player:GetCurWorldId()
  self.desert_battle_tips_btn:SetActive(0 < worldId)
  self.layout = self.totalSpeedRoot.gameObject:GetComponent(typeof(CS.BidirectionalHorizontalLayoutGroup))
end

function LWPropUsePanelView:ComponentDestroy()
  self.scrollView = nil
  self.scrollView = nil
  self.comfirmText = nil
  self.comfirmBtn = nil
  self.cancelBtn = nil
  self.cancelText = nil
  self.bgCloseBtn = nil
  self.closeBtn = nil
  self.desert_battle_tips_btn = nil
  self.totalSpeedNameText = nil
  self.totalSpeedTimeText = nil
  self.remainingTimeText = nil
end

function LWPropUsePanelView:ShowScroll()
  self:ClearScroll()
  local count = #self.resItems
  self.scrollView:SetTotalCount(count)
  if 0 < count then
    self.scrollView:RefillCells()
  end
end

function LWPropUsePanelView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UICommonResItem)
end

function LWPropUsePanelView:OnDeleteCell(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

function LWPropUsePanelView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scrollView:AddComponent(UICommonResItem, itemObj)
  item:ReInit(self.resItems[index].item)
end

function LWPropUsePanelView:DataDefine()
  self.resItems = {}
end

function LWPropUsePanelView:ReInit()
  self.resItems = self:GetUserData().itemList
  self.callBack = self:GetUserData().callBack
  self.remainingTime = self:GetUserData().remainingTime or 0
  self:ShowScroll()
  local time = 0
  for i, v in pairs(self.resItems) do
    time = time + tonumber(v.item.para3) * v.item.count
  end
  self.totalSpeedNameText:SetLocalText("quick_return_5_limit10")
  self.totalSpeedTimeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time * 1000))
  local isFunctionOn = LuaEntry.DataConfig:CheckSwitch("quick_return_switch")
  self.remainingTimeText:SetActive(isFunctionOn)
  if isFunctionOn then
    local exceedTime = math.floor((time * 1000 - self.remainingTime) / 60000)
    exceedTime = math.max(0, exceedTime)
    self.remainingTimeText:SetActive(0 < exceedTime)
    if 0 < exceedTime then
      local exceedTimeStr = tostring(exceedTime)
      self.remainingTimeText:SetLocalText("quick_return_1_limit25", exceedTimeStr)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.textPart.transform)
  if self.layout then
    self.layout.IsReverse = CommonUtil.IsArabic()
  end
  PostEventLog.Track(PostEventLog.Defines.oneTapSpeedUp_item_open, {})
end

function LWPropUsePanelView:OnDeleteCell(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

function LWPropUsePanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWPropUsePanelView:DataDestroy()
  self.resItems = nil
end

return LWPropUsePanelView
