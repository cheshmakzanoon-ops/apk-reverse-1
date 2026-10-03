local base = UIBaseView
local UICampEffectOverviewPreviewView = BaseClass("UICampEffectOverviewPreviewView", base)
local UICampBuffEffectPreviewItem = require("UI.LWSeasonShared.UICampEffectOverviewPreview.Component.UICampBuffEffectPreviewItem")
local UILoopListViewSimple = require("Framework.UI.Component.UILoopListViewSimple")
local txt_TitleText_path = "UICommonPopUpPanel_NoToggle/Content/UICommonPopUpTop/TitleText"
local btn_CloseBtn_path = "UICommonPopUpPanel_NoToggle/Content/UICommonPopUpTop/CloseBtn"
local btn_Mask_path = "UICommonPopUpPanel_NoToggle/Mask"
local sr_UICommonLoopListViewVertical_path = "UICommonPopUpPanel_NoToggle/Content/MainRoot/UICommonLoopListViewVertical"

function UICampEffectOverviewPreviewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.showList, self.buffInfo = self:GetUserData()
  self:RefreshView()
end

function UICampEffectOverviewPreviewView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICampEffectOverviewPreviewView:ComponentDefine()
  self.txt_TitleText = self:AddComponent(UIText, txt_TitleText_path)
  self.btn_CloseBtn = self:AddComponent(UIButton, btn_CloseBtn_path)
  self.btn_Mask = self:AddComponent(UIButton, btn_Mask_path)
  self.sr_UICommonLoopListViewVertical = self:AddComponent(UILoopListViewSimple, sr_UICommonLoopListViewVertical_path)
  self.btn_Mask:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.btn_CloseBtn:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.sr_UICommonLoopListViewVertical:Init(UICampBuffEffectPreviewItem)
end

function UICampEffectOverviewPreviewView:ComponentDestroy()
  self.txt_TitleText = nil
  self.btn_CloseBtn = nil
  self.btn_Mask = nil
  self.sr_UICommonLoopListViewVertical = nil
end

function UICampEffectOverviewPreviewView:RefreshView()
  if self.buffInfo.type == 1 then
    self.txt_TitleText:SetLocalText("season_camp_science_ui_9_title")
  else
    self.txt_TitleText:SetLocalText("season_camp_science_ui_12_title")
  end
  table.sort(self.showList, function(a, b)
    return toInt(a.tier) < toInt(b.tier)
  end)
  local defaultIndex = 0
  self.sr_UICommonLoopListViewVertical:Clear()
  for k, v in ipairs(self.showList) do
    v.currentBuffId = self.buffInfo.buffId
    if v.currentBuffId == v.id then
      defaultIndex = k - 1
    end
    self.sr_UICommonLoopListViewVertical:AddData(v, 1)
  end
  self.sr_UICommonLoopListViewVertical:Show()
  self.sr_UICommonLoopListViewVertical:MovePanelToItemIndex(defaultIndex)
end

return UICampEffectOverviewPreviewView
