local UIActivityDetailCommonView = BaseClass("UIActivityDetailCommonView", UIBaseView)
local base = UIBaseView
local M = UIActivityDetailCommonView
local Localization = CS.GameEntry.Localization
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local contentBodyDefaultColor = Color.New(0.45098039215686275, 0.40784313725490196, 0.38823529411764707, 1.0)

function M:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
  self:RefreshViewPacking()
end

function M:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.activityTitleText = self:AddComponent(UIText, "Content/TitleText")
  if self.param.hideSubTile then
    self.activityTitleText:SetActive(false)
  else
    self.activityTitleText:SetActive(true)
    self.activityTitleText:SetLocalText(self.param.subTitle or 2000048)
  end
  self.contentText = self:AddComponent(UIText, "Content/ContentScroll/Viewport/ContentText")
  self.contentText:SetText(self.param.activityRulesStr)
  self.contentText:SetAnchoredPositionXY(self.contentText:GetAnchoredPositionX(), 0)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "CommonActivityPopUpBgPart")
  if self.param.titleLocalText then
    self.commonActivityPopUpBgPart:SetTitle(self.param.titleLocalText)
  else
    self.commonActivityPopUpBgPart:SetTitle("2901005")
  end
  self.commonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.panel = self:AddComponent(UIButton, "panel")
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function M:ComponentDestroy()
  self.activityTitleText = nil
  self.contentText = nil
  self.closeBtn = nil
  self.panel = nil
end

function M:RefreshViewPacking()
  if self.param and self.param.activityId then
    local lineData = LocalController:instance():getLine(TableName.Activity, self.param.activityId)
    if lineData == nil then
      Logger.LogError("Activity GetTemplate lineData is nil id:" .. self.param.activityId)
      return nil
    end
    if string.IsNullOrEmpty(lineData.festival_interface_config) then
      self:SetDefaultPacking()
      return
    end
    local isUse = DataCenter.ActFestivalPopUpManager:CheckActFestivalUseNewSkin(self.param.activityId, UIWindowNames.UIActivityDetailCommon)
    if not isUse then
      self:SetDefaultPacking()
      return
    end
    local configId = tonumber(lineData.festival_interface_config)
    configId = DataCenter.ActFestivalPopUpManager:TryChangeActPackingId(self.param.activityId) or configId
    self:ModifyPanelPacking(configId)
  else
    self:SetDefaultPacking()
  end
end

function M:SetDefaultPacking()
  self.commonActivityPopUpBgPart:SetDefaultPacking()
  self.contentText:SetColor(contentBodyDefaultColor)
end

function M:ModifyPanelPacking(festivalInterfaceCfgId)
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalInterfaceCfgId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalInterfaceCfgId)
    return
  end
  self.commonActivityPopUpBgPart:ModifyPanelPacking(lineData)
  if string.IsNullOrEmpty(lineData.board_di_text) then
    self.contentText:SetColor(contentBodyDefaultColor)
  else
    local configList = string.split(lineData.board_di_text, "|")
    local tmpColor255 = string.string2array_i_oneSep(configList[2], ",")
    local targetColor = Color.New(tmpColor255[1] / 255, tmpColor255[2] / 255, tmpColor255[3] / 255, tmpColor255[4] / 255)
    self.contentText:SetColor(targetColor)
  end
end

return M
