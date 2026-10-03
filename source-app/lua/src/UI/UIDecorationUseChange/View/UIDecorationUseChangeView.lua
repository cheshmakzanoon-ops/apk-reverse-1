local base = UIBaseView
local UIDecorationUseChangeView = BaseClass("UIDecorationUseChangeView", base)
local Localization = CS.GameEntry.Localization
local panel_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local content_path = "Root/content"
local u_i_common_res_item1_path = "Root/UICommonResItem1"
local u_i_common_res_item2_path = "Root/UICommonResItem2"
local btn_ok_path = "Root/BtnOk"
local btn_cancel_path = "Root/BtnCancel"

function UIDecorationUseChangeView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:OnOpen()
end

function UIDecorationUseChangeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationUseChangeView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.content = self:AddComponent(UIText, content_path)
  self.u_i_common_res_item1 = self:AddComponent(UICommonResItem, u_i_common_res_item1_path)
  self.u_i_common_res_item2 = self:AddComponent(UICommonResItem, u_i_common_res_item2_path)
  self.btn_ok = self:AddComponent(UIButton, btn_ok_path)
  self.btn_cancel = self:AddComponent(UIButton, btn_cancel_path)
  self.btn_ok:SetOnClick(function()
    self:UseItem()
  end)
  self.btn_cancel:SetOnClick(function()
    self:CancelClick()
  end)
end

function UIDecorationUseChangeView:ComponentDestroy()
  self.panel = nil
  self.close_btn = nil
  self.content = nil
  self.u_i_common_res_item1 = nil
  self.u_i_common_res_item2 = nil
  self.btn_ok = nil
  self.btn_cancel = nil
end

function UIDecorationUseChangeView:DataDefine()
  self.itemId = nil
  self.itemUuid = nil
end

function UIDecorationUseChangeView:DataDestroy()
  self.itemId = nil
  self.itemUuid = nil
end

function UIDecorationUseChangeView:OnAddListener()
  base.OnAddListener(self)
end

function UIDecorationUseChangeView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDecorationUseChangeView:OnOpen()
  self.itemId, self.itemUuid = self:GetUserData()
  self.itemId = tonumber(self.itemId)
  local rewardData1 = {
    rewardType = RewardType.GOODS,
    itemId = self.itemId,
    count = 1
  }
  self.u_i_common_res_item1:ReInit(rewardData1)
  local itemTemp = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
  local recycleData = {}
  if not string.IsNullOrEmpty(itemTemp.recycled_item) then
    recycleData = string.string2array_i_oneSep(itemTemp.recycled_item, ";")
  end
  local rewardData2 = {}
  if #recycleData == 2 then
    rewardData2 = {
      rewardType = recycleData[1],
      count = recycleData[2]
    }
  elseif #recycleData == 3 then
    rewardData2 = {
      rewardType = recycleData[1],
      itemId = recycleData[2],
      count = recycleData[3]
    }
  end
  self.u_i_common_res_item2:ReInit(rewardData2)
end

function UIDecorationUseChangeView:UseItem()
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = self.itemUuid,
    num = 1
  })
  self.ctrl:CloseSelf()
end

function UIDecorationUseChangeView:CancelClick()
  self.ctrl:CloseSelf()
end

return UIDecorationUseChangeView
