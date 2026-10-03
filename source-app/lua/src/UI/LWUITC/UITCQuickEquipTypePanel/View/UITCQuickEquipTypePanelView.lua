local UITCQuickEquipTypePanelView = BaseClass("UITCQuickEquipTypePanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SortTypeItem = require("UI.LWUITC.UITCQuickEquipTypePanel.Component.SortTypeItem")

function UITCQuickEquipTypePanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UITCQuickEquipTypePanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITCQuickEquipTypePanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compLayout = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.confirm_btn = self.viewSkin:AddComponent(self, UIButton, 2)
  self.confirm_btn:SetOnClick(function()
    self:OnConfirm_btnClick()
  end)
  self.cancel_btn = self.viewSkin:AddComponent(self, UIButton, 3)
  self.cancel_btn:SetOnClick(function()
    self:OnCancel_btnClick()
  end)
  self.panel_btn = self.viewSkin:AddComponent(self, UIButton, 4)
  self.panel_btn:SetOnClick(function()
    self:OnPanel_btnClick()
  end)
  self.close_btn = self.viewSkin:AddComponent(self, UIButton, 5)
  self.close_btn:SetOnClick(function()
    self:OnClose_btnClick()
  end)
end

function UITCQuickEquipTypePanelView:ComponentDestroy()
  self.viewSkin = nil
  self.compLayout = nil
  self.confirm_btn = nil
  self.cancel_btn = nil
  self.panel_btn = nil
  self.close_btn = nil
end

function UITCQuickEquipTypePanelView:DataDefine()
  self.quickEquipStyleTypes = {}
end

function UITCQuickEquipTypePanelView:DataDestroy()
  self.quickEquipStyleTypes = nil
end

function UITCQuickEquipTypePanelView:OnAddListener()
  base.OnAddListener(self)
end

function UITCQuickEquipTypePanelView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITCQuickEquipTypePanelView:OnConfirm_btnClick()
  self.ctrl:ConfirmQuickEquipStyleType(self.select_index)
end

function UITCQuickEquipTypePanelView:OnCancel_btnClick()
  self.ctrl:CloseSelf()
end

function UITCQuickEquipTypePanelView:OnPanel_btnClick()
  self.ctrl:CloseSelf()
end

function UITCQuickEquipTypePanelView:OnClose_btnClick()
  self.ctrl:CloseSelf()
end

function UITCQuickEquipTypePanelView:RefreshView()
  self.quickEquipStyleTypes = self.ctrl:GetCurSeasonSortTypes()
  self.select_index = CommonUtil.PlayerPrefsGetInt(SettingKeys.TACTICAL_EQUIP_SORT_TYPE, 1)
  if self.select_index < 1 or self.select_index > #self.quickEquipStyleTypes then
    self.select_index = 1
  end
  for i, v in ipairs(self.quickEquipStyleTypes) do
    self:GameObjectInstantiateAsync(UIAssets.UITCQuickEquipType, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.compLayout.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(i)
      go.name = nameStr
      local item = self.compLayout:AddComponent(SortTypeItem, nameStr)
      item:SetOnClick(function(indexCallback, itemCallback)
        self:OnSelectSortType(indexCallback, itemCallback)
      end)
      item:SetData(i, v.sort_name)
      item:SetSelectState(i == self.select_index)
      if i == self.select_index then
        self.cur_select_item = item
      end
    end)
  end
end

function UITCQuickEquipTypePanelView:OnSelectSortType(index, item)
  self.select_index = index
  if self.cur_select_item then
    self.cur_select_item:SetSelectState(false)
  end
  self.cur_select_item = item
  self.cur_select_item:SetSelectState(true)
end

return UITCQuickEquipTypePanelView
