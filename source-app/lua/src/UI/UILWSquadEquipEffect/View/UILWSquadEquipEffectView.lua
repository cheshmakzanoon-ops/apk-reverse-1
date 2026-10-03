local UILWSquadEquipEffectView = BaseClass("UILWSquadEquipEffectView", UIBaseView)
local UILWSquadEquipEffectCell = require("UI.UILWSquadEquipEffect.Component.UILWSquadEquipEffectCell")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local titleTxt_path = "UICommonPopUpTitle/Common_img_title/titleText"
local return_path = "UICommonPopUpTitle/panel"
local scroll_view = "Rect_Content/ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.buildUuid = self:GetUserData()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self._title_txt = self:AddComponent(UIText, titleTxt_path)
  self._close_btn = self:AddComponent(UIButton, closeBtn_path)
  self._return_btn = self:AddComponent(UIButton, return_path)
  self._close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self._return_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.emtpyText = self:AddComponent(UIText, "Rect_Content/EmptyText")
  self.emtpyText:SetLocalText(2000576)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self._title_txt = nil
  self._close_btn = nil
  self._return_btn = nil
  self.emtpyText = nil
  self.scroll_view = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self._title_txt:SetLocalText(2000532)
  self.dataList = self.ctrl:GetPanelData(self.buildUuid)
  if not table.IsNullOrEmpty(self.dataList) then
    self.scroll_view:SetActive(true)
    self.scroll_view:SetTotalCount(#self.dataList)
    self.scroll_view:RefillCells()
    self.emtpyText:SetActive(false)
  else
    self.scroll_view:SetActive(false)
    self.emtpyText:SetActive(true)
  end
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UILWSquadEquipEffectCell, itemObj)
  local data = self.dataList[index]
  cellItem:ReInit(data)
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UILWSquadEquipEffectCell)
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UILWSquadEquipEffectCell)
end

UILWSquadEquipEffectView.OnCreate = OnCreate
UILWSquadEquipEffectView.OnDestroy = OnDestroy
UILWSquadEquipEffectView.OnEnable = OnEnable
UILWSquadEquipEffectView.OnDisable = OnDisable
UILWSquadEquipEffectView.ComponentDefine = ComponentDefine
UILWSquadEquipEffectView.ComponentDestroy = ComponentDestroy
UILWSquadEquipEffectView.DataDefine = DataDefine
UILWSquadEquipEffectView.DataDestroy = DataDestroy
UILWSquadEquipEffectView.ReInit = ReInit
UILWSquadEquipEffectView.OnCreateCell = OnCreateCell
UILWSquadEquipEffectView.OnDeleteCell = OnDeleteCell
UILWSquadEquipEffectView.ClearScroll = ClearScroll
return UILWSquadEquipEffectView
