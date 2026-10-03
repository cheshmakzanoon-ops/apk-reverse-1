local AutoBinder = {}
local btn_CloseBtn_path = "UICommonMiniPopUpTitle/CloseBtn"
local btn_panel_path = "panel"
local toggle_backToggle_path = "bottom/backToggle"
local btn_BtnAttck_path = "bottom/BtnAttack"
local txt_txtTip_path = "UICommonMiniPopUpTitle/txtTip"
local txt_GoText_path = "bottom/BtnAttack/GoText"
local txt_titleText_path = "UICommonMiniPopUpTitle/titleText"
local txt_value1_path = "content/buildDes/layout1/value/txt_value1"
local txt_value2_path = "content/buildDes/layout2/value/txt_value2"
local txt_value3_path = "content/buildDes/layout3/value/txt_value3"
local txt_value4_path = "content/buildDes/layout4/value/txt_value4"
local img_Icon1_path = "content/power/Content/itemPower1/bg/Icon1"
local txt_title1_path = "content/power/Content/itemPower1/bg/title1"
local txt_des1_path = "content/power/Content/itemPower1/bg/txt_des1"
local btn_goto1_path = "content/power/Content/itemPower1/bg/btn_goto1"
local txt_goto1_path = "content/power/Content/itemPower1/bg/btn_goto1/txt_goto1"
local go_img_finish1_path = "content/power/Content/itemPower1/bg/img_finish1"
local img_Icon2_path = "content/power/Content/itemPower2/bg/Icon2"
local txt_title2_path = "content/power/Content/itemPower2/bg/title2"
local txt_des2_path = "content/power/Content/itemPower2/bg/txt_des2"
local btn_goto2_path = "content/power/Content/itemPower2/bg/btn_goto2"
local txt_goto2_path = "content/power/Content/itemPower2/bg/btn_goto2/txt_goto2"
local go_img_finish2_path = "content/power/Content/itemPower2/bg/img_finish2"

function AutoBinder:bind(view)
  view.btn_CloseBtn = view:AddComponent(UIButton, btn_CloseBtn_path)
  view.btn_panel = view:AddComponent(UIButton, btn_panel_path)
  view.toggle_backToggle = view:AddComponent(UIToggle, toggle_backToggle_path)
  view.btn_BtnAttck = view:AddComponent(UIButton, btn_BtnAttck_path)
  view.txt_txtTip = view:AddComponent(UIText, txt_txtTip_path)
  view.txt_GoText = view:AddComponent(UIText, txt_GoText_path)
  view.txt_titleText = view:AddComponent(UIText, txt_titleText_path)
  view.txtValues = {
    view:AddComponent(UIText, txt_value1_path),
    view:AddComponent(UIText, txt_value2_path),
    view:AddComponent(UIText, txt_value3_path),
    view:AddComponent(UIText, txt_value4_path)
  }
  view.g_tipLinek1 = {
    img_Icon1 = view:AddComponent(UIImage, img_Icon1_path),
    txt_title1 = view:AddComponent(UIText, txt_title1_path),
    txt_des1 = view:AddComponent(UIText, txt_des1_path),
    btn_goto1 = view:AddComponent(UIButton, btn_goto1_path),
    txt_goto1 = view:AddComponent(UIText, txt_goto1_path),
    go_img_finish1 = view:AddComponent(UIBaseContainer, go_img_finish1_path)
  }
  view.g_tipLinek2 = {
    img_Icon2 = view:AddComponent(UIImage, img_Icon2_path),
    txt_title2 = view:AddComponent(UIText, txt_title2_path),
    txt_des2 = view:AddComponent(UIText, txt_des2_path),
    btn_goto2 = view:AddComponent(UIButton, btn_goto2_path),
    txt_goto2 = view:AddComponent(UIText, txt_goto2_path),
    go_img_finish2 = view:AddComponent(UIBaseContainer, go_img_finish2_path)
  }
end

function AutoBinder:unbind(view)
  view.btn_CloseBtn = nil
  view.btn_panel = nil
  view.toggle_backToggle = nil
  view.btn_BtnAttck = nil
  view.txt_txtTip = nil
  view.txt_GoText = nil
  view.txt_titleText = nil
  view.txtValues = nil
  view.g_tipLinek1 = nil
  view.g_tipLinek2 = nil
end

local UIResistanceWarningPanelView = BaseClass("UIResistanceWarningPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIResistanceWarningPanelView:OnCreate()
  base.OnCreate(self)
  AutoBinder:bind(self)
  self.btn_panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_CloseBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.toggle_backToggle:SetOnValueChanged(nil)
  self.toggle_backToggle:SetOnValueChanged(function()
    local isOn = self.toggle_backToggle:GetIsOn()
    DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.ResistanceWarningTip, not isOn)
  end)
  self.g_tipLinek1.btn_goto1:SetOnClick(BindCallback(self, self.ClickGoToLink1))
  self.g_tipLinek2.btn_goto2:SetOnClick(BindCallback(self, self.ClickGoToLink2))
  self.btn_BtnAttck:SetOnClick(BindCallback(self, self.ClickBtnAttack))
  self:SetData()
  self:Execute()
end

function UIResistanceWarningPanelView:OnDestroy()
  base.OnDestroy(self)
  AutoBinder:unbind(self)
end

function UIResistanceWarningPanelView:ClickGoToLink1()
  local buildId = BuildingTypes.LW_BUILDING_SEASON_VIRUS_INSTITUTE_CTIY
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
  local curBuildLevel = buildData == nil and 0 or buildData.level
  local isBuildMax = curBuildLevel == buildDesTemplate.max_level
  if isBuildMax then
    UIUtil.ShowTipsId(121202)
  else
    GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILDING_SEASON_VIRUS_INSTITUTE_CTIY)
  end
end

function UIResistanceWarningPanelView:ClickGoToLink2()
  local playerSeasonInfo = DataCenter.SeasonDataManager.playerSeasonInfo
  if playerSeasonInfo and playerSeasonInfo:GetConfig() and playerSeasonInfo:GetConfig().week_card then
    local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(tonumber(playerSeasonInfo:GetConfig().week_card))
    if cardData ~= nil and cardData:IsBought() then
      UIUtil.ShowTipsId(280124)
      return
    end
  end
  SeasonUtil.OpenSeasonActivityByType(EnumActivity.SeasonPeriodicCard.Type)
end

function UIResistanceWarningPanelView:ClickBtnAttack()
  if self.callback then
    self.callback()
    self.ctrl:CloseSelf()
  else
    self.ctrl:CloseSelf()
  end
end

function UIResistanceWarningPanelView:SetData()
  local data, callback = self:GetUserData()
  self.callback = callback
  self.data = data
end

function UIResistanceWarningPanelView:Execute()
  self.txt_GoText:SetLocalText(self.callback ~= nil and "button_attack_go_on" or 110006)
  self.toggle_backToggle:SetActive(self.data.checkResistance)
  local selfValue = toInt(self.data.selfValue)
  local resistance = toInt(self.data.resistance)
  self.txtValues[1]:SetText(string.GetFormattedSeparatorNum(resistance))
  self.txtValues[2]:SetText(string.GetFormattedSeparatorNum(selfValue))
  if self.data.selfPercent > 0 then
    self.txtValues[3]:SetText("+" .. string.GetFormattedPercentStr(math.abs(self.data.selfPercent)))
  else
    self.txtValues[3]:SetText("-" .. string.GetFormattedPercentStr(math.abs(self.data.selfPercent)))
  end
  self.txtValues[4]:SetText("+" .. string.GetFormattedPercentStr(math.abs(self.data.otherPercent)))
  if self.data.changeTitle then
    self.txt_titleText:SetLocalText(311045, Localization:GetString(self.data.monsterConfig.name))
  elseif selfValue >= resistance then
    self.txt_titleText:SetLocalText("season_tiles_popui_info007")
  else
    self.txt_titleText:SetLocalText("guide_S1_resistance_1")
  end
  local colorHex = "F97277"
  if selfValue >= resistance then
    colorHex = "5fef87"
    self.txt_txtTip:SetLocalText("guide_S1_resistance_4")
  elseif math.abs(self.data.selfPercent) > 0.5 then
    self.txt_txtTip:SetLocalText("guide_S1_resistance_2")
  elseif math.abs(self.data.selfPercent) < 0.5 then
    self.txt_txtTip:SetLocalText("guide_S1_resistance_3")
  end
  for _, txt in ipairs(self.txtValues) do
    txt:SetColorHex(colorHex)
  end
  local buildId = BuildingTypes.LW_BUILDING_SEASON_VIRUS_INSTITUTE_CTIY
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
  local curBuildLevel = buildData == nil and 0 or buildData.level
  local isBuildMax = curBuildLevel == buildDesTemplate.max_level
  self.g_tipLinek1.btn_goto1:SetActive(not isBuildMax)
  self.g_tipLinek1.go_img_finish1:SetActive(isBuildMax)
  self.g_tipLinek1.txt_goto1:SetLocalText(isBuildMax and 150027 or 110003)
  if isBuildMax then
    self.g_tipLinek1.txt_des1:SetLocalText(150027)
  else
    local curBuildResistance = 0
    if curBuildLevel ~= 0 then
      local buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, curBuildLevel)
      curBuildResistance = toInt(buildCurLevelTemplate.building_effect_last[EffectDefine.APS_SEASON_DESERT_RESISTANCE])
    end
    local buildNextLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, curBuildLevel + 1)
    local nextBuildResistance = toInt(buildNextLevelTemplate.building_effect_last[EffectDefine.APS_SEASON_DESERT_RESISTANCE])
    self.g_tipLinek1.txt_des1:SetLocalText("guide_S1_resistance_9", "<color=#0C9C4C>" .. nextBuildResistance - curBuildResistance .. "</color>")
  end
  local playerSeasonInfo = DataCenter.SeasonDataManager.playerSeasonInfo
  if playerSeasonInfo and playerSeasonInfo:GetConfig() and playerSeasonInfo:GetConfig().week_card then
    local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(tonumber(playerSeasonInfo:GetConfig().week_card))
    local isBought = cardData ~= nil and cardData:IsBought()
    self.g_tipLinek2.btn_goto2:SetActive(not isBought)
    self.g_tipLinek2.go_img_finish2:SetActive(isBought)
    self.g_tipLinek2.txt_goto2:SetLocalText(isBought and 280124 or 110003)
  else
    self.g_tipLinek2.btn_goto2:SetActive(true)
    self.g_tipLinek2.go_img_finish2:SetActive(false)
    self.g_tipLinek2.txt_goto2:SetLocalText(110003)
  end
  local isShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.ResistanceWarningTip)
  self.toggle_backToggle:SetIsOnWithoutNotify(not isShow)
end

return UIResistanceWarningPanelView
