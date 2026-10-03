local UIDispatchTaskMainTabItem = BaseClass("UIDispatchTaskMainTabItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local name_path = "activityName"
local red_point_path = "RedPoint"
local red_num_path = "RedPoint/RedNum"
local common_red_point_path = "CommonRedPoint"
local new_dot_path = "NewDot"
local select_img_path = "select"
local btn_path = "TypeButton"
local icon_path = "Mask/Icon"

function UIDispatchTaskMainTabItem:OnCreate(activityId)
  base.OnCreate(self)
  self.activityId = activityId
  self.canvasGroup = self:AddComponent(UICanvasGroup, this_path)
  self.name = self:AddComponent(UIText, name_path)
  self.redPoint = self:AddComponent(UIImage, red_point_path)
  self.redNum = self:AddComponent(UIText, red_num_path)
  self.commonRedPoint = self:AddComponent(UICommonRedPoint, common_red_point_path)
  self.commonRedPoint:SetType(CommonRedPointPriority.Level1)
  self.newDot = self:AddComponent(UIBaseContainer, new_dot_path)
  self.select = self:AddComponent(UIImage, select_img_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.select:SetActive(false)
end

function UIDispatchTaskMainTabItem:OnDestroy()
  self.activityId = nil
  self.canvasGroup = nil
  self.name = nil
  self.redPoint = nil
  self.redNum = nil
  self.commonRedPoint = nil
  self.newDot = nil
  self.select = nil
  self.btn = nil
  self.icon = nil
  base.OnDestroy(self)
end

function UIDispatchTaskMainTabItem:SetData()
  self.data = self.view.ctrl:GetActivityDataById(self.activityId)
  self.name:SetText(self.data.name)
  self.newDot:SetActive(false)
  self:RefreshRedPoint()
  local currentId = self.view.ctrl:GetCurrentActivityId()
  if currentId == self.data.id then
    self:SetSelect()
  else
    self:SetUnSelect()
  end
  if not string.IsNullOrEmpty(self.data.list_icon) then
    if self.data.type == EnumActivity.DispatchTreasure.Type and DataCenter.DigTreasureManager:IsActivityOpen() then
      self.icon:LoadSprite(string.format(LoadPath.ActivityIconPath, "FX_icon_WB_bt"))
    else
      self.icon:LoadSprite(string.format(LoadPath.ActivityIconPath, self.data.list_icon))
    end
  end
end

function UIDispatchTaskMainTabItem:SetUnSelect()
  self.select:SetActive(false)
  self.icon:SetActive(false)
  self.name:SetActive(true)
end

function UIDispatchTaskMainTabItem:SetSelect()
  self.select:SetActive(true)
  self.icon:SetActive(true)
  self.name:SetActive(false)
end

function UIDispatchTaskMainTabItem:OnClick()
  DataCenter.ArrowManager:RemoveArrow()
  self.view:OnTabItemClick(self.activityId)
end

function UIDispatchTaskMainTabItem:RefreshRedPoint(data)
  local data = data or self.view.ctrl:GetActivityDataById(self.activityId)
  if data and data.canGet then
    self.commonRedPoint:SetNum(data.rewardCount, data.tipCount)
  else
    self.commonRedPoint:SetActive(false)
  end
end

function UIDispatchTaskMainTabItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DispatchTreasureRefreshTabRedPoint, self.RefreshRedPoint)
  self:AddUIListener(EventId.GhostreconRefreshRedPoint, self.RefreshRedPoint)
  self:AddUIListener(EventId.DispatchTaskUpdateSingle, self.RefreshRedPoint)
end

function UIDispatchTaskMainTabItem:OnRemoveListener()
  self:RemoveUIListener(EventId.DispatchTreasureRefreshTabRedPoint, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.GhostreconRefreshRedPoint, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.DispatchTaskUpdateSingle, self.RefreshRedPoint)
  base.OnRemoveListener(self)
end

return UIDispatchTaskMainTabItem
