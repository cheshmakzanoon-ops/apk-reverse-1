local DetectEventLevelUpgradeInfoNewMaxView = BaseClass("DetectEventLevelUpgradeInfoNewMaxView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ItemShowNum = 4
local cur_lv_path = "levelContent/curLv"
local tip_btn_path = "levelContent/tipBtn"
local info_content_path = "infoContent"
local info_item_path = "infoContent/infoItem"
local line_content_path = "infoContent/lineContent"
local condition_txt_path = "upConditionContent/conditionTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.cur_lv = self:AddComponent(UITextMeshProUGUIEx, cur_lv_path)
  self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
  self.info_content = self:AddComponent(UIBaseContainer, info_content_path)
  self.condition_txt = self:AddComponent(UITextMeshProUGUIEx, condition_txt_path)
  self.tip_btn:SetOnClick(function()
    self:OnRateTextPointerClick()
  end)
  self.info_items = {}
  for i = 1, ItemShowNum do
    local root = self:AddComponent(UIBaseContainer, info_item_path .. i)
    self.info_items[i] = {
      root = root,
      name = root:AddComponent(UITextMeshProUGUIEx, "name"),
      curNum = root:AddComponent(UITextMeshProUGUIEx, "curNum")
    }
  end
  self.line_contents = {}
  for i = 1, ItemShowNum do
    local root = self:AddComponent(UIBaseContainer, line_content_path .. i)
    self.line_contents[i] = {root = root}
  end
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  self.cur_lv = nil
  self.tip_btn = nil
  self.info_content = nil
  self.condition_txt = nil
  self.info_items = nil
  self.line_contents = nil
end

local function RefreshView(self)
  local currentLv = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  local maxLv = self.view.ctrl:GetDetectEventMaxLevel()
  if currentLv < maxLv then
    return
  end
  self.cur_lv:SetLocalText(GameDialogDefine.DETECT_POWER, currentLv)
  local curNum = 0
  local showName = ""
  local showCurTxt = ""
  local showInfoData = {}
  curNum = self.view.ctrl:GetEventRecoverNum(currentLv)
  if curNum ~= 0 then
    showName = Localization:GetString(800804)
    showCurTxt = curNum
    local showData = {showName = showName, showCurTxt = showCurTxt}
    table.insert(showInfoData, showData)
  end
  curNum = self.view.ctrl:GetEventStoreMax(currentLv)
  if curNum ~= 0 then
    showName = Localization:GetString(140069)
    showCurTxt = curNum
    local showData = {showName = showName, showCurTxt = showCurTxt}
    table.insert(showInfoData, showData)
  end
  curNum = self.view.ctrl:GetDetectEventNum(currentLv)
  if curNum ~= 0 then
    showName = Localization:GetString(GameDialogDefine.DETECT_EVENT_MAX_NUM)
    showCurTxt = curNum
    local showData = {showName = showName, showCurTxt = showCurTxt}
    table.insert(showInfoData, showData)
  end
  curNum = self.view.ctrl:GetEventResEffect(currentLv)
  if curNum ~= 0 then
    showName = Localization:GetString("effectnumber_name_50206")
    showCurTxt = curNum .. "%"
    local showData = {showName = showName, showCurTxt = showCurTxt}
    table.insert(showInfoData, showData)
  end
  self.line_contents[ItemShowNum].root:SetActive(false)
  for i = 1, ItemShowNum do
    local showData = showInfoData[i]
    if showData then
      self.info_items[i].root:SetActive(true)
      if 1 < i then
        self.line_contents[i - 1].root:SetActive(true)
      end
      self.info_items[i].name:SetText(showData.showName)
      self.info_items[i].curNum:SetText(showData.showCurTxt)
    else
      self.info_items[i].root:SetActive(false)
      if 1 < i then
        self.line_contents[i - 1].root:SetActive(false)
      end
    end
  end
  self.condition_txt:SetLocalText("radar_tips_1")
end

local function OnRateTextPointerClick(self, clickPos)
  UIUtil.ShowIntro(Localization:GetString("drop_info_title1"), nil, Localization:GetString("drop_info_desc2"))
end

DetectEventLevelUpgradeInfoNewMaxView.OnCreate = OnCreate
DetectEventLevelUpgradeInfoNewMaxView.OnDestroy = OnDestroy
DetectEventLevelUpgradeInfoNewMaxView.ComponentDefine = ComponentDefine
DetectEventLevelUpgradeInfoNewMaxView.ComponentDestroy = ComponentDestroy
DetectEventLevelUpgradeInfoNewMaxView.RefreshView = RefreshView
DetectEventLevelUpgradeInfoNewMaxView.OnRateTextPointerClick = OnRateTextPointerClick
return DetectEventLevelUpgradeInfoNewMaxView
