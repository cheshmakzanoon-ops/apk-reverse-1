local UILWAlSettingView = BaseClass("UILWAlSettingView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWAlSettingItem = require("UI.UILWAlliance.UILWAlSetting.Component.UILWAlSettingItem")
local text_title_path = "Root/TopBar/TextTitle"
local btn_back_path = "Root/BottomBar/BtnBack"
local scroll_view_path = "Root/ScrollView"

function UILWAlSettingView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlSettingView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlSettingView:ComponentDefine()
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText(455063)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UILWAlSettingView:ComponentDestroy()
  self.text_title = nil
  self.btn_back = nil
  self.scroll_view = nil
end

function UILWAlSettingView:DataDefine()
  self.btns = self.ctrl:GetBtnList()
  self.btnGos = {}
end

function UILWAlSettingView:DataDestroy()
  self.btns = nil
  self.btnGos = nil
end

function UILWAlSettingView:OnEnable()
  base.OnEnable(self)
  self:RefreshContent()
end

function UILWAlSettingView:OnDisable()
  base.OnDisable(self)
end

function UILWAlSettingView:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlSettingView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlSettingView:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UILWAlSettingItem)
end

function UILWAlSettingView:RefreshContent()
  self:ClearScroll()
  local count = table.count(self.btns)
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
end

function UILWAlSettingView:OnCellMoveIn(itemObj, index)
  itemObj.name = index
  local cellItem = self.scroll_view:AddComponent(UILWAlSettingItem, itemObj)
  local param = {
    type = self.btns[index],
    clickCall = function(type)
      self:OnClick(type)
    end,
    greyClicCall = function(type)
      self:OnGreyClick(type)
    end
  }
  cellItem:SetData(param)
  cellItem:SetActive(true)
  self.btnGos[param.type] = cellItem
end

function UILWAlSettingView:OnCellMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UILWAlSettingItem)
  local type = self.btns[index]
  self.btnGos[type] = nil
end

function UILWAlSettingView:OnClick(type)
  self.ctrl:OnSettingBtnClick(type)
end

function UILWAlSettingView:OnGreyClick(type)
  self.ctrl:OnSettingGreyClick(type)
end

return UILWAlSettingView
