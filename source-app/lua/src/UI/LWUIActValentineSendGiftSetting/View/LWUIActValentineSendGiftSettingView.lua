local LWUIActValentineSendGiftSettingView = BaseClass("LWUIActValentineSendGiftSettingView", UIBaseView)
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local setting_item_path = "SettingContent/SettingItemContent/SettingItem"

function LWUIActValentineSendGiftSettingView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function LWUIActValentineSendGiftSettingView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActValentineSendGiftSettingView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.itemList = {}
  for i = 1, 3 do
    local itemData = {}
    itemData.index = i
    local itemPath = setting_item_path .. tostring(i)
    itemData.objRoot = self:AddComponent(UIBaseContainer, itemPath)
    itemData.objSelect = itemData.objRoot:AddComponent(UIBaseContainer, "selectContent/selectImg")
    itemData.text = itemData.objRoot:AddComponent(UIText, "Text")
    itemData.btn = itemData.objRoot:AddComponent(UIButton, "")
    local index = i
    itemData.btn:SetOnClick(function()
      self:OnItemClick(index)
    end)
    self.itemList[index] = itemData
  end
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "CommonActivityPopUpBgPart")
  self.commonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.commonActivityPopUpBgPart:SetTitle("activity_99136_25")
end

function LWUIActValentineSendGiftSettingView:ComponentDestroy()
end

function LWUIActValentineSendGiftSettingView:DataDefine()
  self.activityId = self:GetUserData()
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.commonActivityPopUpBgPart:InitByActivityId(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.actTemp = DataCenter.ValentineDataManager:GetActSendTempByActId(self.activityId)
  if self.actTemp == nil then
    return
  end
end

function LWUIActValentineSendGiftSettingView:DataDestroy()
end

function LWUIActValentineSendGiftSettingView:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActValentineSendGiftSettingView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActValentineSendGiftSettingView:RefreshView()
  if self.activityInfo == nil or self.actTemp == nil then
    return
  end
  self.showData = self.actTemp.send_fast
  self.selectIndex = DataCenter.ValentineDataManager:GetSendFastIndexData(self.activityId)
  for i = 1, #self.itemList do
    if i <= #self.showData then
      self.itemList[i].objRoot:SetActive(true)
      local targetItemId = self.showData[i]
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(targetItemId)
      if itemTemplate then
        self.itemList[i].text:SetLocalText("activity_99136_26", "<sprite index=0>", Localization:GetString(itemTemplate.name))
      end
      if i == self.selectIndex then
        self.itemList[i].objSelect:SetActive(true)
      else
        self.itemList[i].objSelect:SetActive(false)
      end
    else
      self.itemList[i].objRoot:SetActive(false)
    end
  end
end

function LWUIActValentineSendGiftSettingView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function LWUIActValentineSendGiftSettingView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWUIActValentineSendGiftSettingView:OnItemClick(itemIndex)
  if self.selectIndex == itemIndex then
    self.selectIndex = 0
  else
    self.selectIndex = itemIndex
  end
  DataCenter.ValentineDataManager:SetSendFastIndexData(self.activityId, self.selectIndex)
  self:RefreshView()
end

return LWUIActValentineSendGiftSettingView
