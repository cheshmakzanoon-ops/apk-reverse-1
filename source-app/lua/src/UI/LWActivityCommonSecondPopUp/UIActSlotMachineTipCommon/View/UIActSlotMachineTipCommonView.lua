local UIActSlotMachineTipCommonView = BaseClass("UIActSlotMachineTipCommonView", UIBaseView)
local base = UIBaseView
local M = UIActSlotMachineTipCommonView
local UIActSlotMachineTipRateComp = require("UI.UIActSlotMachine.UIActSlotMachineTip.Component.UIActSlotMachineTipRateComp")
local UIActSlotMachineTipPicComp = require("UI.UIActSlotMachine.UIActSlotMachineTip.Component.UIActSlotMachineTipPicComp")
local activityThemPath = "Assets/Main/Sprites/UI/ActivityThemeSkin/%s"
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local btn_close_path = "BgContent/bg/BtnClose"
local btn_panel_path = "Panel"
local toggle_path = "CommonActivityPopUpBgPart/Tab/Toggle"
local tip1_content_path = "mainObj/MiddleBg/tip1Content"
local tip2_content_path = "mainObj/MiddleBg/tip2Content"
local top_bar_path = "BgContent/bg/TopBar"
local v_f_x_effect_path = "BgContent/bg/VFX_effect"
local viewIndexType = {RateTip = 1, PicTip = 2}
local toggleNum = 2

local function OnCreate(self)
  base.OnCreate(self)
  self.param = self:GetUserData()
  self.selectType = viewIndexType.RateTip
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.tip1_content = self:AddComponent(UIActSlotMachineTipRateComp, tip1_content_path)
  self.tip2_content = self:AddComponent(UIActSlotMachineTipPicComp, tip2_content_path)
  self.top_bar = self:AddComponent(UIImage, top_bar_path)
  self.v_f_x_effect = self:AddComponent(UIVfx, v_f_x_effect_path)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.toggleList = {}
  for i = 1, toggleNum do
    local root = self:AddComponent(UIButton, toggle_path .. i)
    self.toggleList[i] = {
      root = root,
      tab_text = root:AddComponent(UIText, "tab_text"),
      tab_text2 = root:AddComponent(UIText, "Choose/tab_text2"),
      Choose = root:AddComponent(UIBaseContainer, "Choose"),
      tabUnselectBgImg = root:AddComponent(UIImage, ""),
      tabSelectBgImg = root:AddComponent(UIImage, "Choose")
    }
    root:SetOnClick(function()
      self:OnSelectIndex(i)
    end)
  end
  self.panel_close = self:AddComponent(UIButton, btn_panel_path)
  self.panel_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "CommonActivityPopUpBgPart")
  self.commonActivityPopUpBgPart:SetTitle(self.param.title)
  self.commonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

local function ComponentDestroy(self)
  self.btn_close = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.tip1_content = nil
  self.tip2_content = nil
  self.top_bar = nil
  self.v_f_x_effect:Remove()
  self.v_f_x_effect = nil
end

local function RefreshView(self)
  if self.param.activityInfo and self.param.activityInfo:GetFestivalInterfaceCfgId() then
    self:ModifyPanelPacking(self.param.activityInfo:GetFestivalInterfaceCfgId())
  else
    Logger.LogError("UIActSlotMachineTipCommonView:\230\156\170\229\161\171\229\134\153\230\141\162\231\154\174\228\191\161\230\129\175")
  end
  for i = 1, toggleNum do
    self.toggleList[i].Choose:SetActive(i == self.selectType)
  end
  if self.selectType == viewIndexType.RateTip then
    self.tip1_content:SetActive(true)
    self.tip2_content:SetActive(false)
    self.tip1_content:SetData(self.param)
    PostEventLog.Track(PostEventLog.Defines.ActSlotMachineRateOpen, {})
  else
    self.tip1_content:SetActive(false)
    self.tip2_content:SetActive(true)
    self.tip2_content:SetData(self.param)
    PostEventLog.Track(PostEventLog.Defines.ActSlotMachineTipOpen, {})
  end
end

function M:ModifyPanelPacking(festivalInterfaceCfgId)
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalInterfaceCfgId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalInterfaceCfgId)
    return
  end
  self.commonActivityPopUpBgPart:ModifyPanelPacking(lineData, nil, self.param.activityId)
  if not string.IsNullOrEmpty(lineData.board_di_text) then
    local configList = string.split(lineData.board_di_text, "|")
    local tmpColor255 = string.string2array_i_oneSep(configList[2], ",")
    local targetColor = Color.New(tmpColor255[1] / 255, tmpColor255[2] / 255, tmpColor255[3] / 255, tmpColor255[4] / 255)
    self.tip1_content:ModifyPanelPacking(targetColor)
  end
end

local function OnSelectIndex(self, select)
  if select == self.selectType then
    return
  end
  self.selectType = select
  self:RefreshView()
end

M.OnCreate = OnCreate
M.OnDestroy = OnDestroy
M.ComponentDefine = ComponentDefine
M.ComponentDestroy = ComponentDestroy
M.RefreshView = RefreshView
M.OnSelectIndex = OnSelectIndex
return M
