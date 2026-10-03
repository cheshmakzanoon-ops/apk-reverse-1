local base = UIBaseContainer
local UIS0AllianceBossSelectLeveItem = BaseClass("UIS0AllianceBossSelectLeveItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIS0AllianceBossSelectLeveItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIS0AllianceBossSelectLeveItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossSelectLeveItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtNormalLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnItem = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnItem:SetOnClick(function()
    self:OnBtnItemClick()
  end)
  self.textTxtSelectLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compRedPoint = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
end

function UIS0AllianceBossSelectLeveItem:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtNormalLevel = nil
  self.btnItem = nil
  self.textTxtSelectLevel = nil
  self.compRedPoint = nil
end

function UIS0AllianceBossSelectLeveItem:DataDefine()
  self.isSelected = nil
  self.value = nil
  self.exclude = nil
  self.uiName = nil
end

function UIS0AllianceBossSelectLeveItem:DataDestroy()
  self.isSelected = nil
  self.value = nil
  self.exclude = nil
  self.uiName = nil
end

function UIS0AllianceBossSelectLeveItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnS0AllianceBossOnLevelSelectChanged, self.OnItemSelectChanged)
  self:AddUIListener(EventId.OnS0AllianceBossOnActInfoGot, self.OnRedPointChanged)
end

function UIS0AllianceBossSelectLeveItem:OnRemoveListener()
  self:RemoveUIListener(EventId.OnS0AllianceBossOnLevelSelectChanged, self.OnItemSelectChanged)
  self:RemoveUIListener(EventId.OnS0AllianceBossOnActInfoGot, self.OnRedPointChanged)
  base.OnRemoveListener(self)
end

function UIS0AllianceBossSelectLeveItem:SetData(value, isSelected, uiName, showRedPoint)
  if showRedPoint then
    local firstRewardList = DataCenter.S0AllianceBossDataManager.firstRewardList
    if firstRewardList then
      self.firstRewardList = firstRewardList
      local info = firstRewardList[value]
      if info then
        local firstRewardState = info.state
        self.compRedPoint:SetActive(firstRewardState == 1)
      else
        self.compRedPoint:SetActive(false)
      end
    end
  else
    self.compRedPoint:SetActive(false)
  end
  if self.value ~= value then
    self.textTxtNormalLevel:SetText(value)
    self.textTxtSelectLevel:SetText(value)
    self.value = value
  end
  self.uiName = uiName
  self.showRedPoint = showRedPoint
  self:UpdateSelected(isSelected)
end

function UIS0AllianceBossSelectLeveItem:OnItemSelectChanged(param)
  if param == nil or param.uiName ~= self.uiName then
    return
  end
  if self.exclude then
    self.exclude = false
    return
  end
  local select = self.value == param.value
  self:UpdateSelected(select)
end

function UIS0AllianceBossSelectLeveItem:OnRedPointChanged()
  if not self.showRedPoint then
    return
  end
  if self.firstRewardList then
    local info = self.firstRewardList[self.value]
    if info then
      local firstRewardState = info.state
      self.compRedPoint:SetActive(firstRewardState == 1)
      return
    end
  end
  self.compRedPoint:SetActive(false)
end

function UIS0AllianceBossSelectLeveItem:UpdateSelected(select)
  if self.isSelected ~= select then
    self.textTxtSelectLevel:SetActive(select)
    self.textTxtNormalLevel:SetActive(not select)
    self.isSelected = select
  end
end

function UIS0AllianceBossSelectLeveItem:OnBtnItemClick()
  self.exclude = true
  self:UpdateSelected(true)
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossOnLevelItemClick, {
    value = self.value,
    uiName = self.uiName
  })
end

return UIS0AllianceBossSelectLeveItem
