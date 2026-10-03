local DetectEventLevelUpgradeInfoNewNormalView = BaseClass("DetectEventLevelUpgradeInfoNewNormalView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ItemShowNum = 4
local cur_lv_path = "levelContent/curLv"
local next_lv_path = "levelContent/nextLv"
local tip_btn_path = "levelContent/tipBtn"
local info_content_path = "infoContent"
local info_item_path = "infoContent/infoItem"
local line_content_path = "infoContent/lineContent"
local name_path = "upConditionContent/name"
local condition_txt_path = "upConditionContent/conditionTxt"
local level_fill_background_path = "upConditionContent/Level_Fill_Background"
local level_fill_amount_path = "upConditionContent/Level_Fill_Background/Level_Fill_Amount"
local num_path = "upConditionContent/Level_Fill_Background/num"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.cur_lv = self:AddComponent(UITextMeshProUGUIEx, cur_lv_path)
  self.next_lv = self:AddComponent(UITextMeshProUGUIEx, next_lv_path)
  self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
  self.info_content = self:AddComponent(UIBaseContainer, info_content_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.condition_txt = self:AddComponent(UITextMeshProUGUIEx, condition_txt_path)
  self.level_fill_background = self:AddComponent(UIImage, level_fill_background_path)
  self.level_fill_amount = self:AddComponent(UIImage, level_fill_amount_path)
  self.num = self:AddComponent(UITextMeshProUGUIEx, num_path)
  self.tip_btn:SetOnClick(function()
    self:OnRateTextPointerClick()
  end)
  self.info_items = {}
  for i = 1, ItemShowNum do
    local root = self:AddComponent(UIBaseContainer, info_item_path .. i)
    self.info_items[i] = {
      root = root,
      name = root:AddComponent(UITextMeshProUGUIEx, "name"),
      curNum = root:AddComponent(UITextMeshProUGUIEx, "curNum"),
      nextNum = root:AddComponent(UITextMeshProUGUIEx, "nextNum")
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
  self.next_lv = nil
  self.tip_btn = nil
  self.info_content = nil
  self.name = nil
  self.condition_txt = nil
  self.level_fill_background = nil
  self.level_fill_amount = nil
  self.num = nil
  self.info_items = nil
  self.line_contents = nil
end

local function RefreshView(self)
  local currentLv = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  local maxLv = self.view.ctrl:GetDetectEventMaxLevel()
  if currentLv >= maxLv then
    return
  end
  local nextLv = currentLv + 1
  self.cur_lv:SetLocalText(GameDialogDefine.DETECT_POWER, currentLv)
  self.next_lv:SetLocalText(GameDialogDefine.DETECT_POWER, nextLv)
  local curNum = 0
  local nextNum = 0
  local showName = ""
  local showCurTxt = ""
  local showNextTxt = ""
  local showInfoData = {}
  curNum = self.view.ctrl:GetEventRecoverNum(currentLv)
  nextNum = self.view.ctrl:GetEventRecoverNum(nextLv)
  if curNum ~= 0 or nextNum ~= 0 then
    showName = Localization:GetString(800804)
    showCurTxt = curNum
    showNextTxt = nextNum
    local showData = {
      showName = showName,
      showCurTxt = showCurTxt,
      showNextTxt = showNextTxt
    }
    table.insert(showInfoData, showData)
  end
  curNum = self.view.ctrl:GetEventStoreMax(currentLv)
  nextNum = self.view.ctrl:GetEventStoreMax(nextLv)
  if curNum ~= 0 or nextNum ~= 0 then
    showName = Localization:GetString(140069)
    showCurTxt = curNum
    showNextTxt = nextNum
    local showData = {
      showName = showName,
      showCurTxt = showCurTxt,
      showNextTxt = showNextTxt
    }
    table.insert(showInfoData, showData)
  end
  curNum = self.view.ctrl:GetDetectEventNum(currentLv)
  nextNum = self.view.ctrl:GetDetectEventNum(nextLv)
  if curNum ~= 0 or nextNum ~= 0 then
    showName = Localization:GetString(GameDialogDefine.DETECT_EVENT_MAX_NUM)
    showCurTxt = curNum
    showNextTxt = nextNum
    local showData = {
      showName = showName,
      showCurTxt = showCurTxt,
      showNextTxt = showNextTxt
    }
    table.insert(showInfoData, showData)
  end
  curNum = self.view.ctrl:GetEventResEffect(currentLv)
  nextNum = self.view.ctrl:GetEventResEffect(nextLv)
  if curNum ~= 0 or nextNum ~= 0 then
    showName = Localization:GetString("effectnumber_name_50206")
    showCurTxt = curNum .. "%"
    showNextTxt = nextNum .. "%"
    local showData = {
      showName = showName,
      showCurTxt = showCurTxt,
      showNextTxt = showNextTxt
    }
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
      self.info_items[i].nextNum:SetText(showData.showNextTxt)
    else
      self.info_items[i].root:SetActive(false)
      if 1 < i then
        self.line_contents[i - 1].root:SetActive(false)
      end
    end
  end
  local currentComplete = DataCenter.RadarCenterDataManager:GetDetectInfoCompleteNum()
  local nextLvNeed = self.view.ctrl:GetDetectEventLevelUpNum(currentLv)
  self.name:SetLocalText("140024")
  self.condition_txt:SetLocalText("170442", nextLvNeed)
  self.num:SetText(string.format("%d/%d", currentComplete, nextLvNeed))
  local fillSize = self.level_fill_background:GetSizeDelta()
  local progressNum = currentComplete / nextLvNeed
  if 1 < progressNum then
    progressNum = 1
  end
  self.level_fill_amount:SetSizeDelta(Vector2(progressNum * fillSize.x, fillSize.y))
end

local function OnRateTextPointerClick(self, clickPos)
  UIUtil.ShowIntro(Localization:GetString("drop_info_title1"), nil, Localization:GetString("drop_info_desc2"))
end

DetectEventLevelUpgradeInfoNewNormalView.OnCreate = OnCreate
DetectEventLevelUpgradeInfoNewNormalView.OnDestroy = OnDestroy
DetectEventLevelUpgradeInfoNewNormalView.ComponentDefine = ComponentDefine
DetectEventLevelUpgradeInfoNewNormalView.ComponentDestroy = ComponentDestroy
DetectEventLevelUpgradeInfoNewNormalView.RefreshView = RefreshView
DetectEventLevelUpgradeInfoNewNormalView.OnRateTextPointerClick = OnRateTextPointerClick
return DetectEventLevelUpgradeInfoNewNormalView
