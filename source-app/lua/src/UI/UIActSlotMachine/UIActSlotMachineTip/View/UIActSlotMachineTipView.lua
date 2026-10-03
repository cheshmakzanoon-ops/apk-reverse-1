local UIActSlotMachineTipView = BaseClass("UIActSlotMachineTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActSlotMachineTipRateComp = require("UI.UIActSlotMachine.UIActSlotMachineTip.Component.UIActSlotMachineTipRateComp")
local UIActSlotMachineTipPicComp = require("UI.UIActSlotMachine.UIActSlotMachineTip.Component.UIActSlotMachineTipPicComp")
local bg1DefaultPath = "Assets/Main/Sprites/UI/UILWPlayerInfo/common_pop_bg/common_windows_bg.png"
local bg2DefaultPath = "Assets/Main/Sprites/UI/UILWPlayerInfo/common_pop_bg/common_textarea_bg@2x.png"
local tabUnselectBgDefaultPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_erji_2.png"
local tabSelectBgDefaultPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_erji_1.png"
local tabTextUnselectDefaultColor = Color.New(1.0, 1.0, 1.0, 0.49411764705882355)
local tabTextSelectDefaultColor = Color.white
local btn_close_path = "BgContent/bg/BtnClose"
local btn_panel_path = "Panel"
local toggle_path = "mainObj/Tab/Toggle"
local tip1_content_path = "mainObj/MiddleBg/tip1Content"
local tip2_content_path = "mainObj/MiddleBg/tip2Content"
local bg_1_path = "BgContent/bg/bg_1"
local bg_2_path = "BgContent/bg/bg_2"
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
  self.bg_1 = self:AddComponent(UIImage, bg_1_path)
  self.bg_2 = self:AddComponent(UIImage, bg_2_path)
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
end

local function ComponentDestroy(self)
  self.btn_close = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.tip1_content = nil
  self.tip2_content = nil
  self.top_bar = nil
  self.bg_1 = nil
  self.bg_2 = nil
  self.v_f_x_effect:Remove()
  self.v_f_x_effect = nil
end

local function RefreshView(self)
  self:SetDefaultPacking()
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

function UIActSlotMachineTipView:SetDefaultPacking()
  self.top_bar:SetActive(true)
  self.v_f_x_effect:Remove()
  self.v_f_x_effect:SetActive(false)
  for _, v in pairs(self.toggleList) do
    if v ~= nil then
      v.tab_text:SetColor(tabTextUnselectDefaultColor)
      v.tab_text2:SetColor(tabTextSelectDefaultColor)
      v.tabUnselectBgImg:LoadSprite(tabUnselectBgDefaultPath)
      v.tabSelectBgImg:LoadSprite(tabSelectBgDefaultPath)
    end
  end
  self.tip1_content:SetDefaultPacking()
end

function UIActSlotMachineTipView:ModifyPanelPacking(festivalInterfaceCfgId)
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalInterfaceCfgId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalInterfaceCfgId)
    return
  end
  if string.IsNullOrEmpty(lineData.board_di) then
    self.top_bar:SetActive(true)
    self.bg_1:LoadSprite(bg1DefaultPath)
  else
    self.top_bar:SetActive(false)
    local path = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActLWUIActEasterCommonPath, lineData.board_di)
    self.bg_1:LoadSprite(path)
  end
  if string.IsNullOrEmpty(lineData.board_di_text) then
    self.bg_2:LoadSprite(bg2DefaultPath)
    self.tip1_content:SetDefaultPacking()
  else
    local configList = string.split(lineData.board_di_text, "|")
    local path = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActLWUIActEasterCommonPath, configList[1])
    self.bg_2:LoadSprite(path)
    local tmpColor255 = string.string2array_i_oneSep(configList[2], ",")
    local targetColor = Color.New(tmpColor255[1] / 255, tmpColor255[2] / 255, tmpColor255[3] / 255, tmpColor255[4] / 255)
    self.tip1_content:ModifyPanelPacking(targetColor)
  end
  if string.IsNullOrEmpty(lineData.board_prefab) then
    self.v_f_x_effect:SetActive(false)
    self.v_f_x_effect:Remove()
  else
    self.v_f_x_effect:SetActive(true)
    self.v_f_x_effect:PlayByStay(lineData.board_prefab, {isBreak = true})
  end
  if string.IsNullOrEmpty(lineData.board_page) then
    for _, v in pairs(self.toggleList) do
      if v ~= nil then
        v.tab_text:SetColor(tabTextUnselectDefaultColor)
        v.tab_text2:SetColor(tabTextSelectDefaultColor)
        v.tabUnselectBgImg:LoadSprite(tabUnselectBgDefaultPath)
        v.tabSelectBgImg:LoadSprite(tabSelectBgDefaultPath)
      end
    end
  else
    local configList = string.split(lineData.board_page, "|")
    for _, v in pairs(self.toggleList) do
      if v ~= nil then
        local path1 = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActLWUIActEasterCommonPath, configList[1])
        local path2 = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActLWUIActEasterCommonPath, configList[2])
        v.tabSelectBgImg:LoadSprite(path1)
        v.tabUnselectBgImg:LoadSprite(path2)
        local tmpColor255 = string.string2array_i_oneSep(configList[3], ",")
        local targetColor = Color.New(tmpColor255[1] / 255, tmpColor255[2] / 255, tmpColor255[3] / 255, tmpColor255[4] / 255)
        v.tab_text2:SetColor(targetColor)
        tmpColor255 = string.string2array_i_oneSep(configList[4], ",")
        targetColor = Color.New(tmpColor255[1] / 255, tmpColor255[2] / 255, tmpColor255[3] / 255, tmpColor255[4] / 255)
        v.tab_text:SetColor(targetColor)
      end
    end
  end
end

local function OnSelectIndex(self, select)
  if select == self.selectType then
    return
  end
  self.selectType = select
  self:RefreshView()
end

UIActSlotMachineTipView.OnCreate = OnCreate
UIActSlotMachineTipView.OnDestroy = OnDestroy
UIActSlotMachineTipView.ComponentDefine = ComponentDefine
UIActSlotMachineTipView.ComponentDestroy = ComponentDestroy
UIActSlotMachineTipView.RefreshView = RefreshView
UIActSlotMachineTipView.OnSelectIndex = OnSelectIndex
return UIActSlotMachineTipView
