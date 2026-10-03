local UIDeviceManageCell = require("UI.UIAccount2.UIDeviceManage.Component.UIDeviceManageCell")
local UIDeviceManageView = BaseClass("UIDeviceManageView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIDeviceManageView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDeviceManageView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDeviceManageView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, "CloseBtn")
  self.return_btn = self:AddComponent(UIButton, "panel")
  self.l_w_btn_common_new = self:AddComponent(UIButton, "bottomBtn/LW_Btn_Common_New")
  self.content = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content")
  self.itemTemplateGo = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/ItemTemplate").gameObject
  self.itemTemplateGo:GameObjectCreatePool()
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.l_w_btn_common_new:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UIDeviceManageView:ComponentDestroy()
  self:ClearScroll()
  self.close_btn = nil
  self.return_btn = nil
  self.layout = nil
  self.content = nil
  self.itemTemplateGo = nil
end

function UIDeviceManageView:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.AccountDeviceAccountList)
  self.pageTimer = TimerManager:GetInstance():GetTimer(0.1, self.CheckRequestPage, self, false, false, false)
  self.pageTimer:Start()
end

function UIDeviceManageView:DataDestroy()
  if self.pageTimer then
    self.pageTimer:Stop()
    self.pageTimer = nil
  end
end

function UIDeviceManageView:UpdateCells(message)
  self:ClearScroll()
  local deviceAccountList = message.deviceAccountList
  if deviceAccountList == nil then
    return
  end
  local myDeviceId = CS.GameEntry.Setting:GetString(SettingKeys.DEVICE_ID, "")
  table.sort(deviceAccountList, function(a, b)
    if a.deviceId == myDeviceId and b.deviceId ~= myDeviceId then
      return true
    elseif a.deviceId ~= myDeviceId and b.deviceId == myDeviceId then
      return false
    elseif a.modelInfo and b.modelInfo then
      return a.modelInfo.lastTime > b.modelInfo.lastTime
    elseif a.modelInfo then
      return true
    elseif b.modelInfo then
      return false
    else
      return false
    end
  end)
  for k, v in ipairs(deviceAccountList) do
    local item = self.itemTemplateGo:GameObjectSpawn(self.content.transform)
    item.name = "account_item_" .. k
    local cell = self.content:AddComponent(UIDeviceManageCell, item.name)
    cell:SetData(v)
  end
end

function UIDeviceManageView:ClearScroll()
  self.content:RemoveComponents(UIDeviceManageCell)
  self.itemTemplateGo:GameObjectRecycleAll()
end

function UIDeviceManageView:CheckRequestPage()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

return UIDeviceManageView
