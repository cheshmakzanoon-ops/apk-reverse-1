local base = UIBaseContainer
local UIS0AllianceBossSelectTimeItem = BaseClass("UIS0AllianceBossSelectTimeItem", UIBaseContainer)
local OptionData = CS.TMPro.TMP_Dropdown.OptionData
local content_path = "Dropdown List/Viewport/Content"
local ITEM_HEIGHT = 55
local VIEWPORT_HEIGHT = 275
local TOP_OFFSET = 7

function UIS0AllianceBossSelectTimeItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIS0AllianceBossSelectTimeItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossSelectTimeItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compDrop = self.viewSkin:AddComponent(self, UIDropdown, 2)
  self.compTxtNum = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compDrop:SetOnValueChanged(function()
    self:OnValueChanged()
  end)
  self.compDrop:RegisterCreateDropdownListCallBack(function()
    self:SetDefaultDropDownPos()
  end)
  self:ResetTxtScale()
end

function UIS0AllianceBossSelectTimeItem:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.compDrop = nil
  self.compTxtNum = nil
end

function UIS0AllianceBossSelectTimeItem:DataDefine()
  self.type = nil
  self.contentPos = Vector2.New(0, 0)
end

function UIS0AllianceBossSelectTimeItem:DataDestroy()
  self.type = nil
  self.contentPos = nil
end

function UIS0AllianceBossSelectTimeItem:OnAddListener()
  base.OnAddListener(self)
end

function UIS0AllianceBossSelectTimeItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIS0AllianceBossSelectTimeItem:OnValueChanged()
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossTimeSelectChanged, self.type)
end

function UIS0AllianceBossSelectTimeItem:OnValueChanged()
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossTimeSelectChanged, self.type)
end

function UIS0AllianceBossSelectTimeItem:Clear()
  self.compDrop:Clear()
end

function UIS0AllianceBossSelectTimeItem:InitView(type)
  self.type = type
  if type == 1 then
    self.textTitle:SetLocalText("s0_alliance_boss_hour_select")
  else
    self.textTitle:SetLocalText("s0_alliance_boss_minute_select")
  end
end

function UIS0AllianceBossSelectTimeItem:RefreshHour(min, max)
  for i = min, max do
    local temp = OptionData()
    temp.text = i
    self.compDrop:Add(temp)
  end
end

function UIS0AllianceBossSelectTimeItem:RefreshMin(min, max)
  for i = min, max do
    local temp = OptionData()
    temp.text = i
    self.compDrop:Add(temp)
  end
end

function UIS0AllianceBossSelectTimeItem:GetText()
  return self.compDrop:GetText()
end

function UIS0AllianceBossSelectTimeItem:SetValue(value)
  self.compDrop:SetValue(value)
end

function UIS0AllianceBossSelectTimeItem:SetText(text)
  self.compDrop:SetText(text)
end

function UIS0AllianceBossSelectTimeItem:SetDefaultDropDownPos()
  if self.compDrop == nil then
    return
  end
  local content = self.compDrop.transform:Find(content_path)
  if IsNull(content) then
    return
  end
  local nSelectValue = tonumber(self.compDrop:GetText()) or 0
  local nTotalHeight = self.type == 1 and 24 * ITEM_HEIGHT or 60 * ITEM_HEIGHT
  nTotalHeight = nTotalHeight + TOP_OFFSET
  local targetPos = nSelectValue * ITEM_HEIGHT
  local nCenterOffset = VIEWPORT_HEIGHT / 2
  local nMaxScroll = nTotalHeight - VIEWPORT_HEIGHT
  local nTargetY = math.min(targetPos - nCenterOffset, nMaxScroll)
  nTargetY = math.max(nTargetY, 0)
  self.contentPos.y = nTargetY
  content.transform.anchoredPosition = self.contentPos
end

function UIS0AllianceBossSelectTimeItem:ResetTxtScale()
  self.compTxtNum:SetLocalScaleXYZ(1, 1, 1)
end

function UIS0AllianceBossSelectTimeItem:DOScale()
  return self.compTxtNum.transform:DOScale(Vector3.New(1.5, 1.5, 1.5), 0.2):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo)
end

return UIS0AllianceBossSelectTimeItem
