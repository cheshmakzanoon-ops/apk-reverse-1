local UIActBountyHunterExchangeView = BaseClass("UIActBountyHunterExchangeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUICommonExchangeShopPanelComponent_Base = require("UI.ActivityCommon.LWUICommonExchangeShop.LWUICommonExchangeShopPanelComponent_Base")
local LWUICommonExchangeShopItemComponent_BountyHunter = require("UI/ActivityCommon/LWUICommonExchangeShop/LWUICommonExchangeShop_BountyHunter/LWUICommonExchangeShopItemComponent_BountyHunter")
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")

function UIActBountyHunterExchangeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UIActBountyHunterExchangeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActBountyHunterExchangeView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compLWUICommonExchangeShopBase = self.viewSkin:AddComponent(self, LWUICommonExchangeShopPanelComponent_Base, 3)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle:SetLocalText("activity_hunter_shopname")
end

function UIActBountyHunterExchangeView:ComponentDestroy()
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.textTitle = nil
  self.compLWUICommonExchangeShopBase = nil
  self.btnClose = nil
end

function UIActBountyHunterExchangeView:DataDefine()
  self.hasSendGetInfoMsg = false
end

function UIActBountyHunterExchangeView:DataDestroy()
  self.hasSendGetInfoMsg = nil
end

function UIActBountyHunterExchangeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BountyHunterReceiveActInfo, self.OnGetActInfo)
end

function UIActBountyHunterExchangeView:OnRemoveListener()
  self:RemoveUIListener(EventId.BountyHunterReceiveActInfo, self.OnGetActInfo)
  base.OnRemoveListener(self)
end

function UIActBountyHunterExchangeView:Update1000MS()
  if self.activityData == nil then
    return
  end
  local refreshTime = self.activityData:GetExchangeShopBuyTimesRefreshTime()
  if 0 < refreshTime then
    local timeNow = UITimeManager:GetInstance():GetServerTime()
    if refreshTime < timeNow and not self.hasSendGetInfoMsg then
      SFSNetwork.SendMessage(MsgDefines.BountyHunterGetInfo, toInt(self.activityId))
      self.hasSendGetInfoMsg = true
    end
  end
end

function UIActBountyHunterExchangeView:OnOpen()
  self.activityId = self:GetUserData()
  if self.activityId == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.activityData = DataCenter.BountyHunterActDataManager:GetActData(self.activityId)
  if self.activityData == nil then
    self.ctrl:CloseSelf()
    return
  end
  self:ReInitExchangeComp()
end

function UIActBountyHunterExchangeView:ReInitExchangeComp()
  if self.activityData == nil then
    return
  end
  local param = {}
  param.dataList = self.activityData:GetExchangeShopDataList()
  
  function param.getIsShowToggle()
    if self.activityData then
      return self.activityData:IsExchangeShopRedOn()
    end
    return false
  end
  
  function param.onToggleValueChanged(value)
    if self.activityData then
      return self.activityData:SetExchangeShopRedOn(value)
    end
  end
  
  param.customItemComponent = LWUICommonExchangeShopItemComponent_BountyHunter
  self.compLWUICommonExchangeShopBase:ReInit(param)
end

function UIActBountyHunterExchangeView:OnGetActInfo()
  self:ReInitExchangeComp()
end

function UIActBountyHunterExchangeView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UIActBountyHunterExchangeView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UIActBountyHunterExchangeView
