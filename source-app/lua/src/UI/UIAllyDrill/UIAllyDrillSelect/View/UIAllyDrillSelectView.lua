local UIAllyDrillSelectView = BaseClass("UIAllyDrillSelectView", UIBaseView)
local base = UIBaseView
local OptionData = CS.TMPro.TMP_Dropdown.OptionData
local AllyDrillDiffItem = require("UI.UIAllyDrill.UIAllyDrillSelect.Component.AllyDrillDiffItem")
local TWO_HOUR = 7200000
local HALF_HOUR = 1800000
local Localization = CS.GameEntry.Localization
local tankBanner = "Assets/Main/TextureEx/UIActivityBg/AllyBoss/lt_tongmengjunyan_xuanguan_beijing.png"
local hugeSandWormBanner = "Assets/Main/TextureEx/UIActivityBg/AllyBossSandWorm/lrb_shachongjunyan_tanchuang_banner.png"
local RoadHogBanner = "Assets/Main/SeasonRes/Shared/Textures/MadCowDrill/wxy_s5_tongmengjunyan_xuanze_banner.png"

function UIAllyDrillSelectView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UIAllyDrillSelectView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllyDrillSelectView:ComponentDefine()
  self.returnBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.closeBtn = self:AddComponent(UIButton, "Root/CloseBtn")
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.confirmBtn = self:AddComponent(UIButton, "Root/confirmBtn")
  self.confirmBtn:SetOnClick(function()
    self:OnClickConfirm()
  end)
  self.diffTitle = self:AddComponent(UIText, "Root/layout/diffDrop/diffTitle")
  self.diffBtn = self:AddComponent(UIButton, "Root/layout/diffDrop/Arrow")
  self.diffBtn:SetOnClick(function()
    self:OnClickDiffBtn()
  end)
  self.diffLabel = self:AddComponent(UIText, "Root/layout/diffDrop/Label")
  self.Blocker = self:AddComponent(UIButton, "Root/Blocker")
  self.Blocker:SetActive(false)
  self.Blocker:SetOnClick(function()
    self.Blocker:SetActive(false)
  end)
  self.content = self:AddComponent(UIBaseContainer, "Root/Blocker/layout/ScrollView/Viewport/Content")
  self.blockStageEmpty = self:AddComponent(UIBaseContainer, "Root/Blocker/layout/stageEmpty")
  self.stageDrop = self:AddComponent(UIDropdown, "Root/layout/stageDrop")
  self.stageDrop:SetOnValueChanged(function()
    self:OnStageChange()
  end)
  self.dateTxt = self:AddComponent(UIText, "Root/timeSelect/Date/dateTxt")
  self.hourDrop = self:AddComponent(UIDropdown, "Root/timeSelect/hourDrop")
  self.hourDrop:SetOnValueChanged(function()
    self:OnHourChange()
  end)
  self.minDrop = self:AddComponent(UIDropdown, "Root/timeSelect/minDrop")
  self.minDrop:SetOnValueChanged(function()
    self:OnMinuteChange()
  end)
  self.timeZone = self:AddComponent(UIText, "Root/timeSelect/timeZone")
  self.noTime = self:AddComponent(UIText, "Root/noTime")
  self.timeSelect = self:AddComponent(UIBaseComponent, "Root/timeSelect")
  self.selectToggle = self:AddComponent(UIToggle, "Root/Toggle/SelectToggle")
  self.toggleText = self:AddComponent(UITextMeshProUGUIEx, "Root/Toggle/ToggleText")
  self.toggleText:SetText(Localization:GetString("alliance_boss_tips_013"))
  self.selectToggle:SetOnValueChanged(function(isOn)
    self.isSelectLastTime = isOn
    if isOn then
      self:SetLastSelectTimeInfo()
    else
      self:RefreshDiff()
      self:RefreshTime()
      self.hourDrop:SetValue(0)
      self.hourDrop:SetText(string.format("%d", self.recommendHour))
    end
    CommonUtil.PlayerPrefsSetBool(SettingKeys.ALLY_DRILL_LAST_ATTEND_TIME, isOn)
  end)
  self.bannerImg = self:AddComponent(UIRawImage, "Root/bannerImg")
end

function UIAllyDrillSelectView:OnDiffDropChange()
  local choiceIndex = self.hourDrop:GetValue()
end

function UIAllyDrillSelectView:ComponentDestroy()
  self:RemoveDiffItems()
  self.returnBtn = nil
  self.closeBtn = nil
  self.toggleText = nil
  self.selectToggle = nil
  self.diffTitle = nil
end

function UIAllyDrillSelectView:DataDefine()
  self.selectHour = 0
  self.selectMinute = 0
  self.diffReqs = {}
  self.diffItems = {}
  self.actInfo = DataCenter.AllyDrillDataManager:GetActInfo()
  self.timeInfo = DataCenter.AllyDrillDataManager:GetLastTimeInfo()
  self.isSelectLastTime = DataCenter.AllyDrillDataManager:GetLastAttendTime()
end

function UIAllyDrillSelectView:DataDestroy()
  self.actInfo = nil
  self.timeInfo = nil
  self.isSelectLastTime = nil
end

function UIAllyDrillSelectView:OnEnable()
  base.OnEnable(self)
end

function UIAllyDrillSelectView:OnDisable()
  base.OnDisable(self)
end

function UIAllyDrillSelectView:OnAddListener()
  base.OnAddListener(self)
end

function UIAllyDrillSelectView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAllyDrillSelectView:SetLastSelectTimeInfo()
  if self.timeInfo and self.timeInfo.startTimeHour and self.timeInfo.startTimeHour ~= -1 then
    local lastLevel = self.timeInfo.lastDifficultyLevel
    local lastHour = self.timeInfo.startTimeHour
    local lastMin = self.timeInfo.startTimeMinute
    self:ChooseDiff(lastLevel)
    if lastHour > self.recommendHour then
      self.hourDrop:SetValue(lastHour - self.recommendHour)
      self.hourDrop:SetText(string.format("%d", lastHour))
      self.minDrop:SetValue(lastMin == 0 and 0 or 1)
      self.minDrop:SetText(lastMin)
      self.selectHour = lastHour
      self.selectMinute = lastMin
    end
  elseif self.timeInfo and self.timeInfo.lastDifficultyLevel and self.timeInfo.lastDifficultyLevel > 0 then
    local lastLevel = self.timeInfo.lastDifficultyLevel
    self:ChooseDiff(lastLevel)
  end
  self:RefreshLocalTime()
end

function UIAllyDrillSelectView:Refresh()
  self:RefreshBanner()
  self:RefreshDiff()
  self:RefreshTime()
  self:UIAllyDrillLastSelectIsOn()
end

function UIAllyDrillSelectView:UIAllyDrillLastSelectIsOn()
  self.selectToggle:SetIsOn(self.isSelectLastTime)
  if self.isSelectLastTime then
    self:SetLastSelectTimeInfo()
  end
end

function UIAllyDrillSelectView:CalRecommendTime()
  local now = UITimeManager:GetInstance():GetServerSeconds()
  local secondDayZero = (self.actInfo.battleDayTime + TWO_HOUR) / 1000
  local delay = now - secondDayZero
  local hourDelay = 0
  local halfHourDelay = true
  if now * 1000 > self.actInfo.actEndTime - HALF_HOUR then
    self.recommendTime = nil
    self.recommendHour = 0
    self.recommendMinute = 0
    self.recommendDate = 0
  elseif 0 < delay then
    halfHourDelay = delay % OneHourTime >= 1800
    hourDelay = halfHourDelay and delay // OneHourTime + 1 or delay // OneHourTime
    self.recommendTime = (halfHourDelay and secondDayZero + hourDelay * OneHourTime or secondDayZero + hourDelay * OneHourTime + 1800) * 1000
    self.recommendHour = hourDelay % 24
    self.recommendMinute = halfHourDelay and 0 or 30
    self.recommendDate = (delay + 1800) // OneDayTime
  else
    self.recommendTime = secondDayZero * 1000
    self.recommendHour = 0
    self.recommendMinute = 0
    self.recommendDate = 0
  end
  if not self.recommendTime then
    self.noTime:SetActive(true)
    self.timeSelect:SetActive(false)
  else
    self.noTime:SetActive(false)
    self.timeSelect:SetActive(true)
  end
end

function UIAllyDrillSelectView:RefreshTime()
  self:CalRecommendTime()
  if not self.recommendTime then
    return
  end
  local monthDate = UITimeManager:GetInstance():TimeStampToMDForServer(self.actInfo.battleDayTime / 1000 + TWO_HOUR / 1000 + OneDayTime * self.recommendDate)
  self.dateTxt:SetText(monthDate)
  self.hourDrop:Clear()
  local maxHour = 23
  if UITimeManager:GetInstance():IsSameDayForServer(self.recommendTime / 1000, self.actInfo.actEndTime / 1000) then
    maxHour = 21
  end
  for i = self.recommendHour, maxHour do
    local temp = OptionData()
    temp.text = string.format("%d", i)
    self.hourDrop:Add(temp)
  end
  self.selectHour = self.recommendHour
  self.minDrop:Clear()
  if self.recommendMinute == 0 then
    local temp = OptionData()
    temp.text = "0"
    self.minDrop:Add(temp)
  end
  local temp2 = OptionData()
  temp2.text = "30"
  self.minDrop:Add(temp2)
  self.minDrop:SetText(string.format("%d", self.recommendMinute))
  self.selectMinute = self.recommendMinute
  self:RefreshLocalTime()
end

function UIAllyDrillSelectView:RefreshBanner()
  local bossType = DataCenter.AllyDrillDataManager:GetBossType()
  if bossType == AllyDrillBoss.HugeSandWorm then
    self.bannerImg:LoadSpriteAuto(hugeSandWormBanner)
  elseif bossType == AllyDrillBoss.TankBoss then
    self.bannerImg:LoadSprite(tankBanner)
  elseif bossType == AllyDrillBoss.RoadHog then
    self.bannerImg:LoadSprite(RoadHogBanner)
  end
end

function UIAllyDrillSelectView:RefreshDiff()
  self:RemoveDiffItems()
  self.stageList = {}
  self.stageMap = {}
  self.selectStage = nil
  local useLastDifficulty = self.isSelectLastTime
  local lastDifficultyValid = self.timeInfo and self.timeInfo.lastDifficultyLevel and self.timeInfo.lastDifficultyLevel > 0
  local isNewBoss = DataCenter.AllyDrillDataManager:IsNewBoss()
  if isNewBoss then
    local unlockMaxLevel, unlockedLevels = DataCenter.AllyDrillDataManager:GetNewBossUnlockedLevels()
    local levelCount = #unlockedLevels
    local minUnlockLevel = 1
    if 0 < levelCount then
      minUnlockLevel = unlockedLevels[1]
    end
    self.actInfo.openDifficultyLevel = 0 < self.actInfo.openDifficultyLevel and self.actInfo.openDifficultyLevel or minUnlockLevel
    local curCanSelectMaxLevel = math.min(self.actInfo.openDifficultyLevel, unlockMaxLevel)
    local lastChoice = 0
    if useLastDifficulty and lastDifficultyValid then
      self.selectDiff = self.timeInfo.lastDifficultyLevel
      lastChoice = self.timeInfo.lastDifficultyLevel
    else
      self.selectDiff = curCanSelectMaxLevel
    end
    self.diffLabel:SetText("Lv." .. self.selectDiff)
    self.diffTitle:SetLocalText("new_alliance_boss_tips_22")
    for i = 1, levelCount do
      self.diffReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/AllyDrill/AllyDrillDiffItem.prefab", function(req)
        if IsNull(req.gameObject) then
          return
        end
        local go = req.gameObject
        local transform = go.transform
        go:SetActive(true)
        transform:SetParent(self.content.transform)
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(i)
        go.name = nameStr
        local cell = self.content:AddComponent(AllyDrillDiffItem, nameStr)
        local unlockCondition = DataCenter.AllyDrillDataManager:GetNewBossUnlockCondition(unlockedLevels[i])
        local level = unlockedLevels[i]
        local lockTips = "2010376"
        cell:Refresh(level == lastChoice, level > curCanSelectMaxLevel, level == curCanSelectMaxLevel, level, unlockCondition.unlockLevel, unlockCondition.unlockStage, lockTips)
        cell:SetCheckmark(self.selectDiff == level)
        self.diffItems[i] = cell
      end)
    end
  else
    self.actInfo.openDifficultyLevel = 0 < self.actInfo.openDifficultyLevel and self.actInfo.openDifficultyLevel or 1
    local maxRevealLevel = DataCenter.AllyDrillDataManager:GetMaxRevealLevel()
    local curCanSelectMaxLevel = math.min(self.actInfo.openDifficultyLevel, maxRevealLevel)
    local lastChoice = 0
    if useLastDifficulty and lastDifficultyValid then
      self.selectDiff = self.timeInfo.lastDifficultyLevel
      lastChoice = self.timeInfo.lastDifficultyLevel
    else
      self.selectDiff = curCanSelectMaxLevel
    end
    local seasonCondition = 0
    local cfg = SeasonUtil.GetSeasonInfo(LuaEntry.Player:GetSourceServerId())
    if cfg ~= nil then
      local seasonId = cfg.seasonId
      if cfg:InHaltMode() then
        seasonCondition = seasonId
      else
        seasonCondition = Mathf.Max(seasonId - 1, 0)
      end
    end
    local selectMeta = DataCenter.AllyDrillDataManager:GetAllyDrillTankCfg(self.selectDiff)
    if selectMeta ~= nil then
      self.selectStage = selectMeta.stage
    end
    local metaList = DataCenter.AllyDrillDataManager:GetAllyDrillTankCfg()
    local newStageAB = DataCenter.AllyDrillDataManager:GetNewStageAB()
    for _, v in ipairs(metaList) do
      local AllyDrillMeta = v
      local stage = AllyDrillMeta.stage
      if (stage == 1 or seasonCondition >= AllyDrillMeta.show_condition) and self.selectStage ~= nil and stage <= self.selectStage and (stage == 1 or newStageAB) then
        local list = self.stageMap[stage]
        if list == nil then
          list = {}
          self.stageMap[stage] = list
          table.insert(self.stageList, stage)
        end
        table.insert(list, AllyDrillMeta)
        if self.selectStage == nil then
          self.selectStage = stage
        end
      end
    end
    metaList = self.stageMap[self.selectStage]
    if metaList == nil then
      for i, v in pairs(self.stageMap) do
        self.selectStage = i
        metaList = v
        local metaCount = #metaList
        if 0 < metaCount then
          local meta = metaList[metaCount]
          self.selectDiff = meta.difficulty
        end
        break
      end
    end
    self.diffLabel:SetText("Lv." .. self.selectDiff)
    local levelCount = math.min(#metaList, maxRevealLevel)
    for i = 1, levelCount do
      self.diffReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/AllyDrill/AllyDrillDiffItem.prefab", function(req)
        if IsNull(req.gameObject) then
          return
        end
        local go = req.gameObject
        local transform = go.transform
        go:SetActive(true)
        transform:SetParent(self.content.transform)
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(i)
        go.name = nameStr
        local cell = self.content:AddComponent(AllyDrillDiffItem, nameStr)
        local meta = metaList[i]
        local difficulty = meta.difficulty
        local lockTips = "2010376"
        cell:Refresh(difficulty == lastChoice, difficulty > self.actInfo.openDifficultyLevel, difficulty == self.selectDiff, meta.difficulty, meta.unlockLevelLimit, meta.unlockStageLimit, lockTips)
        cell:SetCheckmark(self.selectDiff == difficulty)
        self.diffItems[i] = cell
      end)
    end
    self.diffTitle:SetLocalText("2010339")
  end
  self.stageOpen = #self.stageList > 1
  if self.stageOpen then
    self.stageDrop:Clear()
    for i, v in ipairs(self.stageList) do
      local temp = OptionData()
      temp.text = Localization:GetString(DataCenter.AllyDrillDataManager:GetStageLanguageKey(i))
      self.stageDrop:Add(temp)
    end
    local index = table.indexof(self.stageList, self.selectStage) or 1
    self.stageDrop:SetValue(index - 1)
    self.stageDrop:SetText(Localization:GetString(DataCenter.AllyDrillDataManager:GetStageLanguageKey(self.selectStage)))
  end
  self.stageDrop:SetActive(self.stageOpen)
  self.blockStageEmpty:SetActive(self.stageOpen)
end

function UIAllyDrillSelectView:RefreshStageDifficultyView()
  if not self.stageOpen then
    return
  end
  self:RemoveDiffItems()
  local isNewBoss = DataCenter.AllyDrillDataManager:IsNewBoss()
  if isNewBoss then
  else
    local maxRevealLevel = DataCenter.AllyDrillDataManager:GetMaxRevealLevel()
    local lastChoice = self.actInfo.lastDifficultyLevel or 0
    self.selectDiff = math.min(self.actInfo.openDifficultyLevel, maxRevealLevel)
    local metaList = self.stageMap[self.selectStage]
    local stageMaxMeta = metaList[#metaList]
    local stageMaxDifficulty = stageMaxMeta.difficulty
    self.selectDiff = math.min(stageMaxDifficulty, self.selectDiff)
    self.diffLabel:SetText("Lv." .. self.selectDiff)
    local levelCount = math.min(#metaList, maxRevealLevel)
    for i = 1, levelCount do
      self.diffReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/AllyDrill/AllyDrillDiffItem.prefab", function(req)
        if IsNull(req.gameObject) then
          return
        end
        local go = req.gameObject
        local transform = go.transform
        go:SetActive(true)
        transform:SetParent(self.content.transform)
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(i)
        go.name = nameStr
        local cell = self.content:AddComponent(AllyDrillDiffItem, nameStr)
        local meta = metaList[i]
        local difficulty = meta.difficulty
        local lockTips = "2010376"
        cell:Refresh(difficulty == lastChoice, difficulty > self.actInfo.openDifficultyLevel, difficulty == self.selectDiff, meta.difficulty, meta.difficulty, meta.unlockLevelLimit, meta.unlockStageLimit, lockTips)
        cell:SetCheckmark(self.selectDiff == difficulty)
        self.diffItems[i] = cell
      end)
    end
  end
end

function UIAllyDrillSelectView:RemoveDiffItems()
  self.diffItems = {}
  self.content:RemoveComponents(AllyDrillDiffItem)
  if self.diffReqs then
    for _, v in pairs(self.diffReqs) do
      v:Destroy()
    end
    self.diffReqs = {}
  end
end

function UIAllyDrillSelectView:OnStageChange()
  local index = self.stageDrop:GetValue() + 1
  self.selectStage = self.stageList[index]
  self:RefreshStageDifficultyView()
end

function UIAllyDrillSelectView:OnHourChange()
  self:CalRecommendTime()
  if not self.recommendTime then
    return
  end
  self.selectHour = tonumber(self.hourDrop:GetText())
  if self.selectHour == self.recommendHour then
    self.minDrop:Clear()
    if self.recommendMinute == 0 then
      local temp = OptionData()
      temp.text = "0"
      self.minDrop:Add(temp)
    end
    local temp2 = OptionData()
    temp2.text = "30"
    self.minDrop:Add(temp2)
    self.minDrop:SetValue(self.recommendMinute == 0 and 0 or 1)
    self.minDrop:SetText(string.format("%d", self.recommendMinute))
    self.selectMinute = self.recommendMinute
  else
    self.minDrop:Clear()
    local temp = OptionData()
    temp.text = "0"
    self.minDrop:Add(temp)
    local temp2 = OptionData()
    temp2.text = "30"
    self.minDrop:Add(temp2)
    self.minDrop:SetValue(0)
    self.minDrop:SetText("0")
    self.selectMinute = 0
  end
  self:RefreshLocalTime()
end

function UIAllyDrillSelectView:OnMinuteChange()
  self:CalRecommendTime()
  if not self.recommendTime then
    return
  end
  self.selectMinute = tonumber(self.minDrop:GetText())
  self:RefreshLocalTime()
end

function UIAllyDrillSelectView:RefreshLocalTime()
  local time
  if self.selectHour and self.selectMinute then
    if self.selectHour == 0 then
      local hour = tonumber(self.hourDrop:GetText())
      local min = tonumber(self.minDrop:GetText())
      self.selectHour = hour and hour or 0
      self.selectMinute = min and min or 0
    end
    time = (self.selectHour * 60 + self.selectMinute) * 60 * 1000 + self.recommendDate * OneDayTime * 1000 + self.actInfo.battleDayTime + TWO_HOUR
  else
    time = self.recommendTime
  end
  local localTime = UITimeManager:GetInstance():TimeStampToTimeForLocal(time)
  self.timeZone:SetLocalText(2010345, localTime)
end

function UIAllyDrillSelectView:OnClickConfirm()
  local hour = self.selectHour
  local min = self.selectMinute
  local day = self.recommendDate or 0
  local selectDelay = ((hour * 60 + min) * 60 + day * OneDayTime) * 1000
  local selectTime = self.actInfo.battleDayTime + TWO_HOUR + selectDelay
  self:CalRecommendTime()
  if not self.recommendTime or selectTime > self.actInfo.actEndTime then
    UIUtil.ShowTipsId(2010390)
  elseif selectTime < self.recommendTime then
    UIUtil.ShowTipsId(2010357)
  else
    local bossType = DataCenter.AllyDrillDataManager:GetBossType()
    local isConfirm = true
    local content = ""
    if bossType == AllyDrillBoss.HugeSandWorm then
      content = Localization:GetString("new_alliance_boss_tips_18", self.selectDiff)
    elseif bossType == AllyDrillBoss.TankBoss then
      local selectMeta = DataCenter.AllyDrillDataManager:GetAllyDrillTankCfg(self.selectDiff)
      isConfirm = selectMeta and selectMeta.isConfirm
      content = Localization:GetString("alliance_boss_tips_005", self.selectDiff)
    elseif bossType == AllyDrillBoss.RoadHog then
      local selectMeta = DataCenter.AllyDrillDataManager:GetAllyDrillRoadHogCfg(self.selectDiff)
      isConfirm = selectMeta and selectMeta.isConfirm
      content = Localization:GetString("activity_alliance_boss_challenge_limit_20", self.selectDiff)
    end
    if isConfirm then
      UIUtil.ShowMessage(content, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        DataCenter.AllyDrillDataManager:SendMsgAllianceBossSelectTime(selectTime, self.selectDiff)
      end)
    else
      DataCenter.AllyDrillDataManager:SendMsgAllianceBossSelectTime(selectTime, self.selectDiff)
    end
  end
end

function UIAllyDrillSelectView:OnClickDiffBtn()
  self.Blocker:SetActive(true)
end

function UIAllyDrillSelectView:ChooseDiff(difficulty)
  self.selectDiff = difficulty
  self.diffLabel:SetText("Lv." .. self.selectDiff)
  if self.diffItems then
    for k, v in pairs(self.diffItems) do
      v:SetCheckmark(v.difficulty == difficulty)
    end
  end
  self.Blocker:SetActive(false)
end

return UIAllyDrillSelectView
