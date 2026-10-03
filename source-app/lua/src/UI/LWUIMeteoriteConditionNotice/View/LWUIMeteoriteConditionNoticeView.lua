local base = UIBaseView
local LWUIMeteoriteConditionNotice = BaseClass("LWUIMeteoriteConditionNotice", base)
local LWUIMeteoriteConditionNoticeIR = require("UI.LWUIMeteoriteConditionNotice.Component.LWUIMeteoriteConditionNoticeIR")
local Localization = CS.GameEntry.Localization
local btnConfirm_path = "MainRect/btnConfirm"
local tmpBottomNotice_path = "MainRect/tmpBottomNotice"
local scrollView_path = "MainRect/ScrollRect"
local content_path = "MainRect/ScrollRect/Content"
local btnBackground_path = "btnBackground"
local btnClose_path = "MainRect/UICommonWindow/bg_3/CloseBtn"
local tmpTitle_path = "MainRect/UICommonWindow/bg_3/TitleTxt"
local tmpConfirm_path = "MainRect/btnConfirm/LW_Btn_Common_New_Base/BtnText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  local userData = self:GetUserData()
  local conditions = userData.conditions
  self.ctrl:SortConditions(conditions)
  self:SetData(conditions)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnConfirm = self:AddComponent(UIButton, btnConfirm_path)
  self.tmpBottomNotice = self:AddComponent(UIText, tmpBottomNotice_path)
  self.scrollView = self:AddComponent(UILoopListView2, scrollView_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.btnBackground = self:AddComponent(UIButton, btnBackground_path)
  self.btnClose = self:AddComponent(UIButton, btnClose_path)
  self.tmpTitle = self:AddComponent(UIText, tmpTitle_path)
  self.tmpConfirm = self:AddComponent(UIText, tmpConfirm_path)
  self.items = {}
  self.scrollView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  local close = Bind(self.ctrl, self.ctrl.CloseSelf)
  self.btnClose:SetOnClick(close)
  self.btnConfirm:SetOnClick(close)
  self.tmpTitle:SetLocalText("building_finish_remind_title")
  self.tmpConfirm:SetLocalText("building_finish_confirm_button")
end

local function ComponentDestroy(self)
  self.items = {}
  self.content:RemoveComponents(LWUIMeteoriteConditionNoticeIR)
  self.scrollView:ClearAllItems()
  self.btnConfirm = nil
  self.tmpBottomNotice = nil
  self.scrollView = nil
  self.content = nil
  self.btnBackground = nil
  self.btnClose = nil
  self.tmpTitle = nil
  self.tmpConfirm = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function LWUIMeteoriteConditionNotice:SetData(data)
  self.dataList = data or {}
  self.scrollView:SetListItemCount(#self.dataList, false, false)
  self.scrollView:RefreshAllShownItem()
end

function LWUIMeteoriteConditionNotice:TryGetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem
  local data = dataList[index]
  local theScript
  csItem = listview:NewListViewItem("UIMeteoriteConditionNoticeIR")
  theScript = LWUIMeteoriteConditionNoticeIR
  if self.items[csItem] == nil then
    local nameStr = "UIMeteoriteConditionNoticeIR" .. index
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(theScript, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(index, data)
  end
  return csItem
end

LWUIMeteoriteConditionNotice.OnCreate = OnCreate
LWUIMeteoriteConditionNotice.OnDestroy = OnDestroy
LWUIMeteoriteConditionNotice.OnEnable = OnEnable
LWUIMeteoriteConditionNotice.OnDisable = OnDisable
LWUIMeteoriteConditionNotice.ComponentDefine = ComponentDefine
LWUIMeteoriteConditionNotice.ComponentDestroy = ComponentDestroy
LWUIMeteoriteConditionNotice.DataDefine = DataDefine
LWUIMeteoriteConditionNotice.DataDestroy = DataDestroy
return LWUIMeteoriteConditionNotice
