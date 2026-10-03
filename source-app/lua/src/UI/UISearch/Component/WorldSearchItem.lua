local WorldSearchItem = BaseClass("WorldSearchItem", UIAsyncContainer)
local WorldSearchItemCell = require("UI.UISearch.Component.WorldSearchItemCell")
local base = UIAsyncContainer
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local ToggleGroup = CS.UnityEngine.UI.ToggleGroup
local rapidjson = require("rapidjson")
local slider_path = "Slider"
local add_btn_path = "AddButton"
local sub_btn_path = "ReduceButton"
local search_txt_path = "searchBtn/searchText"
local remain_time_path = "searchBtn/remainTime"
local search_btn_path = "searchBtn"
local des_txt_path = "DesBg/desTxt"
local level_txt_path = "levelTxt"
local num_txt_path = "Slider/HandleSlideArea/Handle/numTxt"
local this_path = ""
local arrow_path = "Searchmark_Arrow"
local rewards_path = "DesBg/ScrollView2/Viewport/Content2"
local reward_item_path = "DesBg/UICommonResItem"
local toggle1_path = "index/toggle1"
local toggle2_path = "index/toggle2"
local toggle3_path = "index/toggle3"
local toggle4_path = "index/toggle4"
local toggle1_txt_path = "index/toggle1/toggle_txt1"
local toggle2_txt_path = "index/toggle2/toggle_txt2"
local toggle3_txt_path = "index/toggle3/toggle_txt3"
local toggle4_txt_path = "index/toggle4/toggle_txt4"
local red_point_path = "index/toggle3/RedPoint"
local sub_toggle1_path = "subIndex/cell1"
local sub_toggle2_path = "subIndex/cell2"
local sub_toggle3_path = "subIndex/cell3"
local activity_boss_tips_path = "ActivityBossTips"
local info_path = "ActivityBossTips/Info"
local detail1_path = "ActivityBossTips/Info/detail1"
local detail2_path = "ActivityBossTips/Info/detail2"
local detail_icon_path = "ActivityBossTips/Info/icon"
local bloody_night_b_g_path = "BloodyNightBG"
local bloody_title_path = "BloodyNightBG/BloodyTitle"
local bloody_night_fg_path = "BloodyNightFg"
local bg_path = "subIndexS4/cellBg"
local icon_path = "subIndexS4/cellBg/monsterIcon"
local icon_type_path = "subIndexS4/cellBg/nameBg/armyType"
local txt_path = "subIndexS4/cellBg/nameBg/txttt"
local selection_path = "subIndexS4/selection"
local icon1_path = "subIndexS4/selection/icon1"
local icon2_path = "subIndexS4/selection/icon2"
local icon3_path = "subIndexS4/selection/icon3"
local change_btn_path = "subIndexS4/changeBtn"
local BLOODY_NIGHT_CELL_BG = "Assets/Main/Sprites/UI/UISearch/mjc_s4_shijiesouguai_xueye_box01.png"
local NORMAL_NIGHT_CELL_BG = "Assets/Main/Sprites/UI/UISearch/zyf_shijiesouguai_guaiwudikuang.png"
local ARMY_TYPE_SPRITE = {
  "Assets/Main/Sprites/UI/UISearch/mjc_zhiye_icon_bai_tanke.png",
  "Assets/Main/Sprites/UI/UISearch/mjc_zhiye_icon_bai_feiji.png",
  "Assets/Main/Sprites/UI/UISearch/mjc_zhiye_icon_bai_huojian.png"
}
local BLOODY_ARMY_TYPE_SPRITE = {
  "Assets/Main/Sprites/UI/UISearch/mjc_zhiye_icon_hong_tanke.png",
  "Assets/Main/Sprites/UI/UISearch/mjc_zhiye_icon_hong_feiji.png",
  "Assets/Main/Sprites/UI/UISearch/mjc_zhiye_icon_hong_huojian.png"
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

function WorldSearchItem:OnCreate()
  base.OnCreate(self)
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
  self.page = 1
  self.reward_content = self:AddComponent(UIBaseContainer, rewards_path)
  self.theRewardItem = self.transform:Find(reward_item_path).gameObject
  self.theRewardItem:GameObjectCreatePool()
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle3 = self:AddComponent(UIToggle, toggle3_path)
  self.toggle4 = self:AddComponent(UIToggle, toggle4_path)
  self.toggle1_txt = self:AddComponent(UIText, toggle1_txt_path)
  self.toggle2_txt = self:AddComponent(UIText, toggle2_txt_path)
  self.toggle3_txt = self:AddComponent(UIText, toggle3_txt_path)
  self.toggle4_txt = self:AddComponent(UIText, toggle4_txt_path)
  self.activity_boss_tips = self:AddComponent(UIButton, activity_boss_tips_path)
  self.info = self:AddComponent(UIBaseContainer, info_path)
  self.detail1 = self:AddComponent(UIText, detail1_path)
  self.detail2 = self:AddComponent(UIText, detail2_path)
  self.detail_icon = self:AddComponent(UIImage, detail_icon_path)
  self.red_point_tab3 = self:AddComponent(UIBaseContainer, red_point_path)
  self.activity_boss_tips:SetActive(false)
  self.red_point_tab3:SetActive(false)
  for i = 1, 3 do
    self["toggle" .. tostring(i)]:SetOnValueChanged(function(t)
      if t then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
        self:RefreshPage(i)
      end
    end)
    self["toggle" .. tostring(i) .. "_txt"]:SetLocalText(SEARCH_PAGE[i].title)
  end
  if SeasonUtil.IsInSeasonDesertMode() then
    self.toggle4:SetActive(true)
    self.toggle4:SetOnValueChanged(function(t)
      if t then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
        self:RefreshPage(4)
      end
    end)
  else
    self.toggle4:SetActive(false)
  end
  self.subIndexComp = self:AddComponent(UIBaseComponent, "subIndex")
  self.subtoggle1 = self:AddComponent(UIToggle, sub_toggle1_path)
  self.subtoggle2 = self:AddComponent(UIToggle, sub_toggle2_path)
  self.subtoggle3 = self:AddComponent(UIToggle, sub_toggle3_path)
  for i = 1, 3 do
    self["subtoggle" .. tostring(i)]:SetOnValueChanged(function(t)
      if t then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
        self:RefreshPanel(i)
      end
    end)
  end
  self.cells = {
    self:AddComponent(WorldSearchItemCell, sub_toggle1_path),
    self:AddComponent(WorldSearchItemCell, sub_toggle2_path),
    self:AddComponent(WorldSearchItemCell, sub_toggle3_path)
  }
  self.autoAdjustLevel = {
    [UISearchType.Monster] = {
      [LWWorldMonsterType.ResMetal] = true,
      [LWWorldMonsterType.ResFood] = true,
      [LWWorldMonsterType.ResGold] = true,
      [LWWorldMonsterType.S4Tank] = true,
      [LWWorldMonsterType.S4Airplane] = true,
      [LWWorldMonsterType.S4Missile] = true,
      [LWWorldMonsterType.S4TankBN] = true,
      [LWWorldMonsterType.S4AirplaneBN] = true,
      [LWWorldMonsterType.S4MissileBN] = true
    },
    [UISearchType.Boss] = {
      [LWWorldMonsterType.Boss] = true,
      [LWWorldMonsterType.Lockhart] = true,
      [LWWorldMonsterType.S4Boss] = true,
      [LWWorldMonsterType.S4BossBN] = true
    }
  }
  self.bloody_night_b_g = self:AddComponent(UIBaseContainer, bloody_night_b_g_path)
  self.bloody_title = self:AddComponent(UITextMeshProUGUIEx, bloody_title_path)
  self.bloody_title:SetLocalText(GameDialogDefine.BLOODY_NIGHT)
  self.bloody_night_fg = self:AddComponent(UIRawImage, bloody_night_fg_path)
  self.subIndexCompS4 = self:AddComponent(UIBaseComponent, "subIndexS4")
  self.xiao_i_btn = self:AddComponent(UIButton, "subIndexS4/xiaoIBtn")
  self.xiao_i_btn:SetOnClick(function()
    local content = Localization:GetString("season_s4_monster_tips_02")
    UIUtil.ShowBubbleTips(content, self.xiao_i_btn.transform.position, 0, -30, -50)
  end)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.icon_type = self:AddComponent(UIImage, icon_type_path)
  self.txt = self:AddComponent(UITextMeshProUGUIEx, txt_path)
  self.selection = self:AddComponent(UIImage, selection_path)
  self.selection:SetActive(false)
  self.icon1 = self:AddComponent(UIButton, icon1_path)
  self.icon1:SetOnClick(function()
    self:OnClickChooseArmyTypeS4(1)
  end)
  self.icon1Img = self:AddComponent(UIImage, icon1_path)
  self.icon2 = self:AddComponent(UIButton, icon2_path)
  self.icon2:SetOnClick(function()
    self:OnClickChooseArmyTypeS4(2)
  end)
  self.icon2Img = self:AddComponent(UIImage, icon2_path)
  self.icon3 = self:AddComponent(UIButton, icon3_path)
  self.icon3:SetOnClick(function()
    self:OnClickChooseArmyTypeS4(3)
  end)
  self.icon3Img = self:AddComponent(UIImage, icon3_path)
  self.change_btn = self:AddComponent(UIButton, change_btn_path)
  self.change_btn:SetOnClick(function()
    self.selection:SetActive(not self.selection:GetActive())
  end)
  self.closeBackBtn = self:AddComponent(UIButton, "subIndexS4/selection/closeBackBtn")
  self.closeBackBtn:SetOnClick(function()
    self.selection:SetActive(false)
  end)
  self:SetSizeDeltaXY(850, 850)
end

function WorldSearchItem:OnDestroy()
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
  base.OnDestroy(self)
end

function WorldSearchItem:OnEnable()
  base.OnEnable(self)
  self.animator:Play("CommonPopup_movein", 0, 0)
end

function WorldSearchItem:OnDisable()
  self.animator:Play("CommonPopup_moveout", 0, 0)
  base.OnDisable(self)
end

function WorldSearchItem:SetData(index, posX)
  self.index = index
  self.posX = posX
  self:UpdateData()
end

function WorldSearchItem:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  local index = self.index or 1
  local posX = self.posX or 1
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
  if SeasonUtil.IsInSeasonDarknessMode() then
    if DataCenter.BloodyNightDataManager:IsBloodyNight(LuaEntry.Player:GetSelfServerId()) then
      defaultBoss = {
        maxLevel = DataCenter.MonsterTemplateManager:GetMaxLevel(LWWorldMonsterType.S4BossBN, 0, false),
        type = LWWorldMonsterType.S4BossBN
      }
    else
      defaultBoss = {
        maxLevel = DataCenter.MonsterTemplateManager:GetMaxLevel(LWWorldMonsterType.S4Boss, 0, false),
        type = LWWorldMonsterType.S4Boss
      }
    end
  else
    defaultBoss = {
      maxLevel = DataCenter.MonsterTemplateManager:GetMaxLevel(LWWorldMonsterType.Boss, 0, false),
      type = LWWorldMonsterType.Boss
    }
  end
  if 0 < activityCellCount then
    if hasExclusiveModeCell == false and activityCellCount < 3 then
      table.insert(cell3, activityCellCount + 1, defaultBoss)
    end
    SEARCH_PAGE[3].cell = cell3
  else
    SEARCH_PAGE[3].cell = {defaultBoss}
  end
  if SeasonUtil.IsInSeasonDarknessMode() then
    if DataCenter.BloodyNightDataManager:IsBloodyNight(LuaEntry.Player:GetSelfServerId()) then
      SEARCH_PAGE[1].cell[1].maxLevel = DataCenter.SeasonDataManager:GetMonsterMaxLevel(LWWorldMonsterType.S4TankBN)
      SEARCH_PAGE[1].cell[1].type = LWWorldMonsterType.S4TankBN
      SEARCH_PAGE[1].cell[2].maxLevel = DataCenter.SeasonDataManager:GetMonsterMaxLevel(LWWorldMonsterType.S4AirplaneBN)
      SEARCH_PAGE[1].cell[2].type = LWWorldMonsterType.S4AirplaneBN
      SEARCH_PAGE[1].cell[3].maxLevel = DataCenter.SeasonDataManager:GetMonsterMaxLevel(LWWorldMonsterType.S4MissileBN)
      SEARCH_PAGE[1].cell[3].type = LWWorldMonsterType.S4MissileBN
    else
      SEARCH_PAGE[1].cell[1].maxLevel = DataCenter.SeasonDataManager:GetMonsterMaxLevel(LWWorldMonsterType.S4Tank)
      SEARCH_PAGE[1].cell[1].type = LWWorldMonsterType.S4Tank
      SEARCH_PAGE[1].cell[2].maxLevel = DataCenter.SeasonDataManager:GetMonsterMaxLevel(LWWorldMonsterType.S4Airplane)
      SEARCH_PAGE[1].cell[2].type = LWWorldMonsterType.S4Airplane
      SEARCH_PAGE[1].cell[3].maxLevel = DataCenter.SeasonDataManager:GetMonsterMaxLevel(LWWorldMonsterType.S4Missile)
      SEARCH_PAGE[1].cell[3].type = LWWorldMonsterType.S4Missile
    end
  elseif SeasonUtil.IsOpenAttackMonsterByLevel(1, 0) then
    SEARCH_PAGE[1].cell[1].maxLevel = DataCenter.SeasonDataManager:GetMonsterMaxLevel(SEARCH_PAGE[1].cell[1].type)
    SEARCH_PAGE[1].cell[2].maxLevel = DataCenter.SeasonDataManager:GetMonsterMaxLevel(SEARCH_PAGE[1].cell[2].type)
    SEARCH_PAGE[1].cell[3].maxLevel = DataCenter.SeasonDataManager:GetMonsterMaxLevel(SEARCH_PAGE[1].cell[3].type)
  else
    SEARCH_PAGE[1].cell[1].maxLevel = nil
    SEARCH_PAGE[1].cell[2].maxLevel = nil
    SEARCH_PAGE[1].cell[3].maxLevel = nil
  end
  self:ChangeToPage(index, posX)
  if DataCenter.BloodyNightDataManager:IsBloodyNight(LuaEntry.Player:GetSelfServerId()) then
    self.bloody_night_b_g:SetActive(true)
    self.bloody_night_fg:SetActive(true)
    self.bloody_night_fg:LoadSprite("Assets/Main/SeasonRes/S4/Textures/BloodyNight/mjc_s4_shijiesouguai_xueye_bg_3.png")
  else
    self.bloody_night_b_g:SetActive(false)
    self.bloody_night_fg:SetActive(false)
  end
end

function WorldSearchItem:ChangeToPage(page, index)
  index = index or self.subIndex or 1
  self:RefreshPage(page, index)
  self["toggle" .. tostring(page)]:SetIsOn(true)
end

function WorldSearchItem:ChangeToCell(index)
  self:RefreshPanel(index)
  self["subtoggle" .. tostring(index)]:SetIsOn(true)
end

function WorldSearchItem:RefreshPage(page, index)
  local newbieGuideRunning = false
  if not newbieGuideRunning and page == 1 then
    UIUtil.CheckEventTrigger(OpMode.ClickBtnSearchMonster, 0, 0.5)
  end
  index = index or DataCenter.SearchPanelDataManager:GetSelectCellIndex(page) or self.subIndex or 1
  self.search_txt:SetLocalText(GameDialogDefine.SEARCH)
  self.page = page
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
  self:RefreshPageForS4(page, index)
  self:ChangeToCell(index)
end

function WorldSearchItem:CheckAutoAdjustLevel(mainType, subType)
  if self.autoAdjustLevel and self.autoAdjustLevel[mainType] and self.autoAdjustLevel[mainType][subType] then
    self.autoAdjustLevel[mainType][subType] = false
    return true
  end
  return false
end

function WorldSearchItem:RefreshPanel(index)
  local cell = SEARCH_PAGE[self.page].cell[index]
  if cell == nil then
    index = 1
    cell = SEARCH_PAGE[self.page].cell[1]
  end
  self.subIndex = index
  self.view.ctrl.cellIndex = self.subIndex
  self.view.ctrl:RecordSelectPage()
  self.subType = cell.type
  for i = 1, 3 do
    self.cells[i]:SetGray(i ~= index)
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
      local cell = SEARCH_PAGE[self.page].cell[self.subIndex]
      local config = self.view.ctrl:GetSearchItemConfig(SEARCH_PAGE[self.page].table, nextNum, SEARCH_PAGE[self.page].type, cell)
      if config and config.firstReward then
        self.view.ctrl:SetCurNumBySearchType(self.searchType, nextNum, self.subType)
      end
    end
  end
  self.slider.unity_uislider.maxValue = 99999
  self.slider.unity_uislider.minValue = 1
  self:RefreshSlider()
  self.slider.unity_uislider.maxValue = self.maxNum
  self.slider.unity_uislider.minValue = 1
  self:RefreshReward()
  self:RefreshText()
  self:CheckButtonState()
end

function WorldSearchItem:OnSearchClick()
  local cell = SEARCH_PAGE[self.page].cell[self.subIndex]
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

function WorldSearchItem:OnAdd()
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

function WorldSearchItem:OnSub()
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

function WorldSearchItem:OnValueChange(val)
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

function WorldSearchItem:RefreshSlider(isClick)
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

function WorldSearchItem:CheckChange(willNun)
  if willNun ~= nil and willNun >= self.minValue and willNun <= self.maxNum then
    return true
  end
  return false
end

function WorldSearchItem:RefreshText()
  local curNun = self.view.ctrl:GetCurNumBySearchType(self.searchType, self.subType)
  curNun = curNun > self.maxNum and self.maxNum or curNun
  self.level_txt:SetLocalText("320439", curNun)
end

function WorldSearchItem:RefreshReward()
  local cell = SEARCH_PAGE[self.page].cell[self.subIndex]
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

function WorldSearchItem:CheckButtonState()
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

function WorldSearchItem:GetSubtypeByIndex(pageIndex, cellIndex)
  cellIndex = cellIndex or 1
  if SEARCH_PAGE[pageIndex].cell[cellIndex] == nil then
    cellIndex = 1
  end
  return SEARCH_PAGE[pageIndex].cell[cellIndex].type
end

function WorldSearchItem:GetTypeByIndex(pageIndex)
  return SEARCH_PAGE[pageIndex].type
end

function WorldSearchItem:AddCountDownTimer()
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.RefreshRemainTime, self, false, false, false)
  end
  self.remain_time:SetActive(true)
  self.countDownTimer:Start()
end

function WorldSearchItem:RefreshRemainTime()
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

function WorldSearchItem:DelCountDownTimer()
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
  self.remain_time:SetActive(false)
end

function WorldSearchItem:RefreshPageForS4(page, index)
  if page ~= 1 or not SeasonUtil.IsInSeasonDarknessMode(true) then
    self.subIndexComp:SetActive(true)
    self.subIndexCompS4:SetActive(false)
    return
  end
  self.subIndexComp:SetActive(false)
  self.subIndexCompS4:SetActive(true)
  local isBloodyNight = DataCenter.BloodyNightDataManager:IsBloodyNight(LuaEntry.Player:GetSelfServerId())
  self.bg:LoadSprite(isBloodyNight and BLOODY_NIGHT_CELL_BG or NORMAL_NIGHT_CELL_BG)
  local cfg = self.view.ctrl:GetSearchItemConfig(SEARCH_PAGE[1].table, 1, SEARCH_PAGE[1].type, SEARCH_PAGE[1].cell[index])
  if cfg == nil then
    Logger.LogError("WorldSearchItem:RefreshPageForS4 cfg == nil" .. tostring(page) .. " " .. tostring(index))
  else
    self.icon:LoadSprite(cfg.icon)
    self.icon:SetNativeSize()
    self.txt:SetLocalText(cfg.name)
    self.icon_type:LoadSprite(isBloodyNight and BLOODY_ARMY_TYPE_SPRITE[index] or ARMY_TYPE_SPRITE[index])
    self.icon1Img:LoadSprite(isBloodyNight and BLOODY_ARMY_TYPE_SPRITE[1] or ARMY_TYPE_SPRITE[1])
    self.icon2Img:LoadSprite(isBloodyNight and BLOODY_ARMY_TYPE_SPRITE[2] or ARMY_TYPE_SPRITE[2])
    self.icon3Img:LoadSprite(isBloodyNight and BLOODY_ARMY_TYPE_SPRITE[3] or ARMY_TYPE_SPRITE[3])
  end
end

function WorldSearchItem:OnClickChooseArmyTypeS4(index)
  self:RefreshPanel(index)
  self:RefreshPageForS4(1, index)
  self.selection:SetActive(false)
end

return WorldSearchItem
