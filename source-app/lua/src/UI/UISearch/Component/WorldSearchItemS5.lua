local WorldSearchItemS5 = BaseClass("WorldSearchItemS5", UIAsyncContainer)
local WorldSearchItemCellS5 = require("UI.UISearch.Component.WorldSearchItemCellS5")
local base = UIAsyncContainer
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local ToggleGroup = CS.UnityEngine.UI.ToggleGroup
local rapidjson = require("rapidjson")
local slider_path = "Bottom/Slider"
local add_btn_path = "Bottom/AddButton"
local sub_btn_path = "Bottom/ReduceButton"
local search_txt_path = "Bottom/searchBtn/searchText"
local remain_time_path = "Bottom/searchBtn/remainTime"
local search_btn_path = "Bottom/searchBtn"
local des_txt_path = "DesBg/desTxt"
local level_txt_path = "Bottom/levelTxt"
local num_txt_path = "Bottom/Slider/HandleSlideArea/Handle/numTxt"
local this_path = ""
local arrow_path = "Searchmark_Arrow"
local rewards_path = "DesBg/ScrollView2/Viewport/Content2"
local reward_item_path = "DesBg/UICommonResItem"
local red_point_path = "index/toggle3/RedPoint"
local activity_boss_tips_path = "ActivityBossTips"
local info_path = "ActivityBossTips/Info"
local detail1_path = "ActivityBossTips/Info/detail1"
local detail2_path = "ActivityBossTips/Info/detail2"
local detail_icon_path = "ActivityBossTips/Info/icon"
local selection_path = "subIndexS5/selection"
local close_back_btn_path = "subIndexS5/selection/closeBackBtn"
local icon1_path = "subIndexS5/selection/icon1"
local icon2_path = "subIndexS5/selection/icon2"
local icon3_path = "subIndexS5/selection/icon3"
local bottom_tip_path = "BottomTip"
local LEVEL_GROUP = {
  [1] = {min = 1, max = 30},
  [2] = {min = 31, max = 60},
  [3] = {min = 61, max = 90}
}
local SEARCH_PAGE = {
  {
    type = UISearchType.Monster,
    table = TableName.Monster,
    title = 450024,
    cell = {
      {
        type = LWWorldMonsterType.ResMetal
      },
      {
        type = LWWorldMonsterType.ResFood
      },
      {
        type = LWWorldMonsterType.ResGold
      }
    }
  },
  {
    type = UISearchType.Resource,
    table = TableName.GatherResource,
    title = 450025,
    cell = {
      {
        type = ResourceType.Metal
      },
      {
        type = ResourceType.Food
      },
      {
        type = ResourceType.Wood
      }
    }
  },
  {
    type = UISearchType.Boss,
    table = TableName.Monster,
    title = 300602,
    cell = {
      {
        maxLevel = 20,
        type = LWWorldMonsterType.Boss
      }
    }
  },
  {
    type = UISearchType.WorldDesert,
    table = TableName.Desert,
    title = 803068,
    cell = {
      {
        type = LWWorldMonsterType.ResObsidian
      },
      {
        type = LWWorldMonsterType.ResFlint
      }
    }
  }
}
local ACTIVITY_CELL_LIST = {
  {
    type = LWWorldMonsterType.Lockhart,
    activityType = EnumActivity.LockhartActivity.Type,
    special = 5,
    maxLevel = 20,
    icon = "Assets/Main/Sprites/ItemIcons/zyf_luoha_mingpai",
    detail1 = 2010118,
    detail2 = 2010119,
    itemId = "710001",
    rewardId = 2270021,
    hideSlider = false,
    needRedPoint = true,
    exclusiveMode = true
  }
}

function WorldSearchItemS5:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Init()
  self:SetAsFirstSibling()
end

function WorldSearchItemS5:ComponentDefine()
  self.search_btn = self:AddComponent(UIButton, search_btn_path)
  self.search_btn:SetSafeClickMode(true)
  self.search_btn:SetOnClick(function()
    self:OnSearchClick()
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider:SetOnValueChanged(function(value)
    self:OnValueChange(value)
  end)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(function()
    self:OnAdd()
  end)
  self.sub_btn = self:AddComponent(UIButton, sub_btn_path)
  self.sub_btn:SetOnClick(function()
    self:OnSub()
  end)
  self.search_txt = self:AddComponent(UIText, search_txt_path)
  self.remain_time = self:AddComponent(UIText, remain_time_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.level_txt = self:AddComponent(UIText, level_txt_path)
  self.num_txt = self:AddComponent(UIText, num_txt_path)
  self.addBtnGray = nil
  self.subBtnGray = nil
  self.panel = self:AddComponent(UIBaseContainer, this_path)
  self.animator = self:AddComponent(UIAnimator, this_path)
  self.arrow = self:AddComponent(UIBaseContainer, arrow_path)
  self.minValue = 1
  self.page = self.page or 1
  self.reward_content = self:AddComponent(UIBaseContainer, rewards_path)
  self.theRewardItem = self.transform:Find(reward_item_path).gameObject
  self.theRewardItem:GameObjectCreatePool()
  self.activity_boss_tips = self:AddComponent(UIButton, activity_boss_tips_path)
  self.info = self:AddComponent(UIBaseContainer, info_path)
  self.detail1 = self:AddComponent(UIText, detail1_path)
  self.detail2 = self:AddComponent(UIText, detail2_path)
  self.detail_icon = self:AddComponent(UIImage, detail_icon_path)
  self.red_point_tab3 = self:AddComponent(UIBaseContainer, red_point_path)
  self.activity_boss_tips:SetActive(false)
  self.red_point_tab3:SetActive(false)
  self.toggle = {}
  self.toggle_txt = {}
  self.subToggle = {}
  self.cells = {}
  for i = 1, 3 do
    self.toggle[i] = self:AddComponent(UIToggle, "index/toggle" .. i)
    self.toggle[i]:SetOnValueChanged(function(t)
      if t then
        DataCenter.LWSoundManager:PlaySound(80079, false)
        self.page = i
        self:RefreshPage()
      end
    end)
    self.toggle_txt[i] = self:AddComponent(UIText, "index/toggle" .. i .. "/toggle_txt" .. i)
    self.toggle_txt[i]:SetLocalText(SEARCH_PAGE[i].title)
    self.subToggle[i] = self:AddComponent(UIToggle, "subIndexS5/layout/cell" .. i)
    self.subToggle[i]:SetOnValueChanged(function(t)
      if t then
        DataCenter.LWSoundManager:PlaySound(80079, false)
        if self.page == 1 then
          self.group = i
        else
          self.index = i
        end
        self:RefreshPanel()
      end
    end)
    self.cells[i] = self:AddComponent(WorldSearchItemCellS5, "subIndexS5/layout/cell" .. i)
  end
  self.autoAdjustLevel = {
    [UISearchType.Monster] = {
      [LWWorldMonsterType.ResMetal] = true,
      [LWWorldMonsterType.ResFood] = true,
      [LWWorldMonsterType.ResGold] = true
    },
    [UISearchType.Boss] = {
      [LWWorldMonsterType.Boss] = true,
      [LWWorldMonsterType.Lockhart] = true
    }
  }
  self.xiao_i_btn = self:AddComponent(UIButton, "subIndexS5/xiaoIBtn")
  self.xiao_i_btn:SetOnClick(function()
    local nextTime = self.nextGroupUnlockTime
    local now = UITimeManager:GetInstance():GetServerTime()
    if nextTime and nextTime > now then
      local remain = UITimeManager:GetInstance():MilliSecondToFmtString(nextTime - now)
      local content = Localization:GetString("activity_1200043_tips9", remain)
      UIUtil.ShowBubbleTips(content, self.xiao_i_btn.transform.position, 0, -30, -50)
    end
  end)
  self.selection = self:AddComponent(UIImage, selection_path)
  self.selection:SetActive(false)
  self.close_back_btn = self:AddComponent(UIButton, close_back_btn_path)
  self.close_back_btn:SetOnClick(function()
    self.selection:SetActive(false)
  end)
  self.icon1 = self:AddComponent(UIButton, icon1_path)
  self.icon1:SetOnClick(function()
    self:OnClickChooseArmyType(1)
  end)
  self.icon2 = self:AddComponent(UIButton, icon2_path)
  self.icon2:SetOnClick(function()
    self:OnClickChooseArmyType(2)
  end)
  self.icon3 = self:AddComponent(UIButton, icon3_path)
  self.icon3:SetOnClick(function()
    self:OnClickChooseArmyType(3)
  end)
  self.bottom = self:AddComponent(UIBaseComponent, "Bottom")
  self.bottom_tip = self:AddComponent(UITextMeshProUGUIEx, bottom_tip_path)
  self.btn_bottom_tip = self:AddComponent(UIButton, bottom_tip_path)
  self.btn_bottom_tip:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWestwardExpansionMap, {anim = true}, self.group)
  end)
end

function WorldSearchItemS5:Init()
  self:SetSizeDeltaXY(850, 850)
end

function WorldSearchItemS5:OnDestroy()
  self.reward_content:RemoveComponents(UICommonResItem)
  self.theRewardItem:GameObjectRecycleAll()
  for _, v in ipairs(self.reward_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self:DelCountDownTimer()
  self.content = nil
  self.search_btn = nil
  self.slider = nil
  self.add_btn = nil
  self.sub_btn = nil
  self.search_txt = nil
  self.des_txt = nil
  self.level_txt = nil
  self.num_txt = nil
  self.minValue = nil
  self.addBtnGray = nil
  self.subBtnGray = nil
  self.animator = nil
  self.cells = nil
  self.bg = nil
  self.icon = nil
  self.icon_type = nil
  self.txt = nil
  self.selection = nil
  self.icon1 = nil
  self.icon2 = nil
  self.icon3 = nil
  self.change_btn = nil
  self.selection = nil
  self.close_back_btn = nil
  self.bottom = nil
  self.bottom_tip = nil
  self.toggle = {}
  self.toggle_txt = {}
  self.subToggle = {}
  self.cells = {}
  base.OnDestroy(self)
end

function WorldSearchItemS5:OnEnable()
  base.OnEnable(self)
  self.animator:Play("CommonPopup_movein", 0, 0)
end

function WorldSearchItemS5:OnDisable()
  self.animator:Play("CommonPopup_moveout", 0, 0)
  base.OnDisable(self)
end

function WorldSearchItemS5:SetData(page, index)
  self.page = page or 1
  self.index = index or 1
  local monsterCellState, nextTime, recommendGroup, levelGroup = DataCenter.WestwardExpansionDataManager:GetMonsterSearchState()
  LEVEL_GROUP = levelGroup
  local historyGroup = DataCenter.SearchPanelDataManager:GetSelectGroup()
  if historyGroup and monsterCellState[historyGroup] == 3 then
    self.group = historyGroup
  else
    self.group = recommendGroup or 1
  end
  self.nextGroupUnlockTime = nextTime
  self.monsterCellState = monsterCellState
  local activityCellCount = 0
  local hasExclusiveModeCell = false
  local cell3 = {}
  for _, v in pairs(ACTIVITY_CELL_LIST) do
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(v.activityType)
    if 0 < #dataList then
      if v.type and v.special then
        for i = 1, #dataList do
          local activityInfoData = dataList[i]
          if not string.IsNullOrEmpty(activityInfoData.para) then
            local special = tonumber(activityInfoData.para)
            if special > v.special then
              v.special = special
            end
          end
        end
        v.maxLevel = DataCenter.MonsterTemplateManager:GetMaxLevel(LWWorldMonsterType.Boss, v.special, true)
      end
      table.insert(cell3, v)
      activityCellCount = activityCellCount + 1
      if v.activityType == EnumActivity.LockhartActivity.Type then
        local para5 = 0
        if not string.IsNullOrEmpty(dataList[1].para_5) then
          para5 = tonumber(dataList[1].para_5)
        end
        v.exclusiveMode = para5 == 0
      end
      if v.exclusiveMode == true then
        hasExclusiveModeCell = true
        break
      end
      if activityCellCount == 3 then
        break
      end
    end
  end
  local defaultBoss
  defaultBoss = {
    maxLevel = DataCenter.MonsterTemplateManager:GetMaxLevel(LWWorldMonsterType.Boss, 0, false),
    type = LWWorldMonsterType.Boss
  }
  if 0 < activityCellCount then
    if hasExclusiveModeCell == false and activityCellCount < 3 then
      table.insert(cell3, activityCellCount + 1, defaultBoss)
    end
    SEARCH_PAGE[3].cell = cell3
  else
    SEARCH_PAGE[3].cell = {defaultBoss}
  end
  if SeasonUtil.IsOpenAttackMonsterByLevel(1, 0) then
    SEARCH_PAGE[1].cell[1].maxLevel = DataCenter.SeasonDataManager:GetMonsterMaxLevel(SEARCH_PAGE[1].cell[1].type)
    SEARCH_PAGE[1].cell[2].maxLevel = DataCenter.SeasonDataManager:GetMonsterMaxLevel(SEARCH_PAGE[1].cell[2].type)
    SEARCH_PAGE[1].cell[3].maxLevel = DataCenter.SeasonDataManager:GetMonsterMaxLevel(SEARCH_PAGE[1].cell[3].type)
  else
    SEARCH_PAGE[1].cell[1].maxLevel = nil
    SEARCH_PAGE[1].cell[2].maxLevel = nil
    SEARCH_PAGE[1].cell[3].maxLevel = nil
  end
  self:UpdateData()
end

function WorldSearchItemS5:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  self.toggle[self.page]:SetIsOn(true)
  self:RefreshPage()
end

function WorldSearchItemS5:RefreshPage()
  local page = self.page
  self.index = DataCenter.SearchPanelDataManager:GetSelectCellIndex(page)
  local newbieGuideRunning = false
  if not newbieGuideRunning and page == 1 then
    UIUtil.CheckEventTrigger(OpMode.ClickBtnSearchMonster, 0, 0.5)
  end
  self.search_txt:SetLocalText(GameDialogDefine.SEARCH)
  self.view.ctrl.pageIndex = page
  self.searchType = SEARCH_PAGE[page].type
  self.des_txt:SetLocalText(2000055)
  if self.searchType == UISearchType.Monster then
    self.des_txt:SetActive(true)
    self.level_txt:SetActive(true)
  elseif self.searchType == UISearchType.Resource then
    self.des_txt:SetActive(true)
    self.level_txt:SetActive(true)
  elseif self.searchType == UISearchType.Boss then
    self.des_txt:SetActive(true)
    self.level_txt:SetActive(true)
  elseif self.searchType == UISearchType.WorldDesert then
    self.des_txt:SetActive(true)
    self.level_txt:SetActive(true)
  else
    self.des_txt:SetActive(false)
    self.level_txt:SetActive(false)
  end
  if page ~= 1 then
    for i = 1, 3 do
      self.cells[i]:SetActive(SEARCH_PAGE[page].cell[i] ~= nil)
    end
    for i, v in ipairs(SEARCH_PAGE[page].cell) do
      local data = self.view.ctrl:GetSearchItemConfig(SEARCH_PAGE[page].table, 1, SEARCH_PAGE[page].type, v)
      if data == nil then
        self.cells[i]:SetActive(false)
      else
        self.cells[i]:Refresh(data, v, SEARCH_PAGE[page].type == UISearchType.Monster)
      end
      if page == 3 and v ~= nil and v.activityType ~= nil and v.needRedPoint then
        CS.GameEntry.Setting:SetBool("WorldSearchItem_" .. LuaEntry.Player.uid .. "_" .. i, true)
      end
    end
  end
  if page ~= 3 then
    local hasActivityOpen = false
    for i, v in ipairs(SEARCH_PAGE[3].cell) do
      if v ~= nil and v.activityType ~= nil and v.needRedPoint then
        local flag = CS.GameEntry.Setting:GetBool("WorldSearchItem_" .. LuaEntry.Player.uid .. "_" .. i, false)
        if flag ~= true then
          local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(v.activityType)
          if 0 < #dataList then
            hasActivityOpen = true
          end
        end
      end
    end
    self.red_point_tab3:SetActive(hasActivityOpen)
  else
    self.red_point_tab3:SetActive(false)
  end
  local index = self.page == 1 and self.group or self.index
  self.subToggle[index or 1]:SetIsOn(true)
  self:RefreshPanel()
end

function WorldSearchItemS5:CheckAutoAdjustLevel(mainType, subType)
  if self.autoAdjustLevel and self.autoAdjustLevel[mainType] and self.autoAdjustLevel[mainType][subType] then
    self.autoAdjustLevel[mainType][subType] = false
    return true
  end
  return false
end

function WorldSearchItemS5:RefreshPanel(ignoreLock)
  local index = self.index
  local cell = SEARCH_PAGE[self.page].cell[index]
  if cell == nil then
    index = 1
    cell = SEARCH_PAGE[self.page].cell[1]
  end
  self.index = index
  self.view.ctrl.cellIndex = self.index
  self.view.ctrl:RecordSelectPageForS5(self.group)
  self.subType = cell.type
  self.minValue = 1
  if self.page == 1 then
    self.minValue = LEVEL_GROUP[self.group].min
    self.xiao_i_btn:SetActive(self.nextGroupUnlockTime)
    self.bottom_tip:SetActive(self.monsterCellState[self.group] == 2)
    if self.monsterCellState[self.group] == 2 then
      local str1 = Localization:GetString("activity_1200043_tips32")
      local str2 = Localization:GetString("activity_1200043_tips11")
      self.bottom_tip:SetText(str1 .. [[

<u>]] .. str2 .. "</u>")
    end
    self.bottom:SetActive(self.monsterCellState[self.group] == 3)
    for i = 1, 3 do
      local cfg = self.view.ctrl:GetSearchItemConfig(SEARCH_PAGE[1].table, LEVEL_GROUP[i].min, SEARCH_PAGE[1].type, SEARCH_PAGE[1].cell[index])
      if cfg == nil then
        Logger.LogError("WorldSearchItem:GetSearchItemConfig == nil" .. tostring(self.page) .. " " .. tostring(index) .. " " .. i)
      end
      if self.monsterCellState[i] == 1 then
        self.cells[i]:SetActive(false)
      elseif self.monsterCellState[i] == 2 then
        self.cells[i]:SetActive(true)
        if not ignoreLock then
          self.cells[i]:SetMonster(cfg, index, true)
        end
      elseif self.monsterCellState[i] == 3 then
        self.cells[i]:SetActive(true)
        self.cells[i]:SetMonster(cfg, index, false)
      end
    end
  else
    self.xiao_i_btn:SetActive(false)
    self.bottom_tip:SetActive(false)
    self.bottom:SetActive(true)
    for i = 1, 3 do
      self.cells[i]:SetGray(i ~= index)
    end
  end
  if self.page == 4 then
    local attackMaxLevel = DataCenter.SeasonDataManager:GetDesertMaxLevel()
    local configMaxLevel = DataCenter.DesertTemplateManager:GetDesertMaxLevel()
    self.maxNum = math.min(attackMaxLevel + 1, configMaxLevel)
  else
    if cell.maxLevel ~= nil and type(cell.maxLevel) == "number" then
      self.maxNum = cell.maxLevel
    else
      self.maxNum = self.view.ctrl:GetMaxNumBySearchType(self.searchType, self.subType)
    end
    if self.subType == LWWorldMonsterType.Lockhart and cell.activityType ~= nil then
      local configMaxLevel = math.min(DataCenter.BuildManager.MainLv, self.maxNum)
      local unlockMaxLevel = DataCenter.LWActivityLockhartManager:GetMaxLockHartUnlockLevel()
      unlockMaxLevel = 0 < unlockMaxLevel and unlockMaxLevel or DataCenter.BuildManager.MainLv
      self.maxNum = math.min(unlockMaxLevel, configMaxLevel)
    end
    if self.page == 1 and self.group ~= nil then
      self.maxNum = Mathf.Clamp(self.maxNum, LEVEL_GROUP[self.group].min, LEVEL_GROUP[self.group].max)
    end
  end
  local curNum = self.view.ctrl:GetCurNumBySearchType(self.searchType, self.subType)
  local nextNum = curNum + 1
  if self:CheckAutoAdjustLevel(self.searchType, self.subType) and nextNum <= self.maxNum then
    local isFirstKill = false
    if self.subType == LWWorldMonsterType.Lockhart and cell.activityType ~= nil then
      isFirstKill = DataCenter.LWActivityLockhartManager:IsLockHartFirstKill(nextNum)
    else
      isFirstKill = nextNum == self.maxNum
    end
    if isFirstKill then
      local newCell = SEARCH_PAGE[self.page].cell[self.index]
      local config = self.view.ctrl:GetSearchItemConfig(SEARCH_PAGE[self.page].table, nextNum, SEARCH_PAGE[self.page].type, newCell)
      if config and config.firstReward then
        self.view.ctrl:SetCurNumBySearchType(self.searchType, nextNum, self.subType)
      end
    end
  end
  self.slider.unity_uislider.maxValue = 99999
  self.slider.unity_uislider.minValue = 1
  self:RefreshSlider()
  if self.page == 1 and self.group ~= nil then
    self.slider.unity_uislider.maxValue = self.maxNum
    self.slider.unity_uislider.minValue = LEVEL_GROUP[self.group].min
  else
    self.slider.unity_uislider.maxValue = self.maxNum
    self.slider.unity_uislider.minValue = 1
  end
  self:RefreshReward()
  self:RefreshText()
  self:CheckButtonState()
end

function WorldSearchItemS5:OnSearchClick()
  local cell = SEARCH_PAGE[self.page].cell[self.index]
  if cell ~= nil and cell.activityType ~= nil then
    local curNun = self.view.ctrl:GetCurNumBySearchType(self.searchType, self.subType)
    curNun = curNun > self.maxNum and self.maxNum or curNun
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(cell.activityType)
    if table.count(dataList) == 0 then
      UIUtil.ShowTipsId("sevenday_event_des38")
      self.view.ctrl:CloseSelf()
      return
    end
    if cell.activityType == EnumActivity.LockhartActivity.Type then
      SFSNetwork.SendMessage(MsgDefines.SummonLockhartBoss, curNun, false)
    end
    return
  end
  self.view.ctrl:OnSearchClick(self.searchType, self.subType)
end

function WorldSearchItemS5:OnAdd()
  local curNum = self.view.ctrl:GetCurNumBySearchType(self.searchType, self.subType)
  curNum = curNum > self.maxNum and self.maxNum or curNum
  if self:CheckChange(curNum + 1) then
    self.view.ctrl:SetCurNumBySearchType(self.searchType, curNum + 1, self.subType)
    self:RefreshSlider(true)
    self:RefreshText()
    self:CheckButtonState()
    self:RefreshReward()
  end
end

function WorldSearchItemS5:OnSub()
  local curNum = self.view.ctrl:GetCurNumBySearchType(self.searchType, self.subType)
  curNum = curNum > self.maxNum and self.maxNum or curNum
  if self:CheckChange(curNum - 1) then
    self.view.ctrl:SetCurNumBySearchType(self.searchType, curNum - 1, self.subType)
    self:RefreshSlider(true)
    self:RefreshText()
    self:CheckButtonState()
    self:RefreshReward()
  end
end

function WorldSearchItemS5:OnValueChange(val)
  local cnt = val
  if cnt ~= self.view.ctrl:GetCurNumBySearchType(self.searchType, self.subType) then
    if self:CheckChange(cnt) then
      self.view.ctrl:SetCurNumBySearchType(self.searchType, cnt, self.subType)
      self:RefreshText()
      self:RefreshReward()
    else
      self:RefreshSlider(true)
    end
    self:CheckButtonState()
  end
end

function WorldSearchItemS5:RefreshSlider(isClick)
  local curNun = self.view.ctrl:GetCurNumBySearchType(self.searchType, self.subType)
  if curNun > self.maxNum then
    curNun = self.maxNum
    self.view.ctrl:SetCurNumBySearchType(self.searchType, curNun, self.subType)
  end
  if not isClick and self.searchType == UISearchType.Monster and self.maxNum <= 6 and curNun < self.maxNum then
    curNun = self.maxNum
    self.view.ctrl:SetCurNumBySearchType(self.searchType, curNun, self.subType)
  end
  self.slider:SetValue(curNun)
end

function WorldSearchItemS5:CheckChange(willNun)
  if willNun ~= nil and willNun >= self.minValue and willNun <= self.maxNum then
    return true
  end
  return false
end

function WorldSearchItemS5:RefreshText()
  local curNun = self.view.ctrl:GetCurNumBySearchType(self.searchType, self.subType)
  curNun = curNun > self.maxNum and self.maxNum or curNun
  self.level_txt:SetLocalText("320439", curNun)
end

function WorldSearchItemS5:RefreshReward()
  local cell = SEARCH_PAGE[self.page].cell[self.index]
  local curNum = self.view.ctrl:GetCurNumBySearchType(self.searchType, self.subType)
  curNum = toInt(curNum > self.maxNum and self.maxNum or curNum)
  local config = self.view.ctrl:GetSearchItemConfig(SEARCH_PAGE[self.page].table, curNum, SEARCH_PAGE[self.page].type, cell)
  if config == nil then
    return
  end
  if cell ~= nil and cell.activityType ~= nil then
    if cell.hideSlider == true then
      local itemCount = DataCenter.ItemData:GetItemCount(cell.itemId)
      self.activity_boss_tips:SetActive(true)
      self.detail_icon:LoadSprite(cell.icon)
      self.detail_icon:SetNativeSize()
      self.detail1:SetLocalText(cell.detail1)
      self.detail2:SetLocalText(cell.detail2, itemCount)
    else
      self.activity_boss_tips:SetActive(false)
    end
    if cell.rewardId ~= nil then
      table.sort(config.reward, function(a, b)
        if a.itemId == cell.rewardId then
          return true
        end
        if b.itemId == cell.rewardId then
          return false
        end
        return a.itemId < b.itemId
      end)
    end
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(cell.activityType)
    if dataList ~= nil then
      self.activityData = dataList[1]
    else
      self.activityData = nil
    end
  else
    self.activityData = nil
    self.activity_boss_tips:SetActive(false)
  end
  if config.firstReward then
    if config.firstRewardDes then
      self.des_txt:SetText(config.firstRewardDes)
    else
      self.des_txt:SetLocalText(800305)
    end
  else
    self.des_txt:SetLocalText(2000055)
  end
  local seasonType = SeasonUtil.GetCurWorldSeasonType(true, true)
  local rewards = config.reward
  local goItem, theItem
  self.reward_content:RemoveComponents(UICommonResItem)
  self.theRewardItem:GameObjectRecycleAll()
  for i, v in ipairs(rewards) do
    local levelName = "reward_item_" .. i
    goItem = self.theRewardItem:GameObjectSpawn(self.reward_content.transform)
    goItem.name = levelName
    goItem:SetActive(true)
    goItem.transform:Set_localScale(0.8, 0.8, 0.8)
    goItem.transform:Set_sizeDelta(150, 150)
    goItem.transform:Set_pivot(0, 1)
    theItem = self.reward_content:AddComponent(UICommonResItem, levelName)
    theItem:SetSeasonType(seasonType)
    theItem:ReInit(v)
    local flag = goItem.transform:Find("flag")
    if flag ~= nil and flag.gameObject ~= nil then
      flag.gameObject:SetActive(cell.rewardId ~= nil and v.itemId == cell.rewardId and cell.activityType ~= nil)
    end
  end
  if self.activityData ~= nil then
    self:RefreshRemainTime()
    self:AddCountDownTimer()
  else
    self:DelCountDownTimer()
  end
end

function WorldSearchItemS5:CheckButtonState()
  local curNum = self.view.ctrl:GetCurNumBySearchType(self.searchType, self.subType)
  curNum = curNum > self.maxNum and self.maxNum or curNum
  if curNum <= self.minValue then
    if self.subBtnGray ~= true then
      self.subBtnGray = true
      self.sub_btn:SetInteractable(false)
    end
  elseif self.subBtnGray ~= false then
    self.subBtnGray = false
    self.sub_btn:SetInteractable(true)
  end
  if curNum >= self.maxNum then
    if self.addBtnGray ~= true then
      self.addBtnGray = true
      self.add_btn:SetInteractable(false)
    end
  elseif self.addBtnGray ~= false then
    self.addBtnGray = false
    self.add_btn:SetInteractable(true)
  end
end

function WorldSearchItemS5:GetSubtypeByIndex(pageIndex, cellIndex)
  cellIndex = cellIndex or 1
  if SEARCH_PAGE[pageIndex].cell[cellIndex] == nil then
    cellIndex = 1
  end
  return SEARCH_PAGE[pageIndex].cell[cellIndex].type
end

function WorldSearchItemS5:GetTypeByIndex(pageIndex)
  return SEARCH_PAGE[pageIndex].type
end

function WorldSearchItemS5:AddCountDownTimer()
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.RefreshRemainTime, self, false, false, false)
  end
  self.remain_time:SetActive(true)
  self.countDownTimer:Start()
end

function WorldSearchItemS5:RefreshRemainTime()
  if not self.activityData then
    self:DelCountDownTimer()
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.activityData.endTime - curTime
  if 0 < remainTime then
    self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.remain_time:SetText("")
    self:DelCountDownTimer()
  end
end

function WorldSearchItemS5:DelCountDownTimer()
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
  self.remain_time:SetActive(false)
end

function WorldSearchItemS5:ShowSelection(position)
  if position then
    self.selection:SetActive(true)
    self.selection:SetPosition(position)
  else
    self.selection:SetActive(false)
  end
end

function WorldSearchItemS5:OnClickChooseArmyType(index)
  self.index = index
  self:RefreshPanel(true)
  self.selection:SetActive(false)
end

return WorldSearchItemS5
