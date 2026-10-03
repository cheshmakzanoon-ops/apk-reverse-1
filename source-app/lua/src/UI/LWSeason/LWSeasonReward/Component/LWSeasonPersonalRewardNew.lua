local base = UIBaseContainer
local LWSeasonPersonalRewardNew = BaseClass("LWSeasonPersonalRewardNew", base)
local Localization = CS.GameEntry.Localization
local LWSeasonPersonalRewardItem = require("UI.LWSeason.LWSeasonReward.Component.LWSeasonPersonalRewardItem")
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local LWSeasonAchievementTab = require("UI.LWSeason.LWSeasonReward.Component.LWSeasonAchievementTab")
local content_path = "Root/mid/Mask/ScrollView/Content"
local scroll_view_path = "Root/mid/Mask/ScrollView"
local progress_bar_path = "Root/mid/Mask/ScrollView/Content/ProgressBar"
local rect_on_get_red_path = "Btn_List/Btn_OneGet/Rect_OnGetRed"
local btn_one_get_path = "Btn_List/Btn_OneGet"
local tab_btns_path = "Root/tabBtns"
local occupy_num_path = "Root/top/topArea/occupyNum"
local occupyland_path = "Root/top/topArea/occupyland"
local occupy_des_path = "Root/top/topArea/occupyDes"
local goto_btn_path = "Root/top/gotoBtn"
local goto_des_path = "Root/top/gotoBtn/gotoDes"
local top_area_path = "Root/top/topArea"
local join_ali_hit_path = "Root/top/joinAliHit"
local raw_image_path = "Root/top/RawImage"
local score_icon_path = "Root/top/topArea/scoreIcon"
local top_bar_path = "Root/tabBtns/TopBar"
local tab_path = "Root/tabBtns/TopBar/Tab"
local tab_item_path = "Root/tabBtns/TopBar/Tab/TabItem"
local intro_btn_path = "Root/top/IntroBtn"

function LWSeasonPersonalRewardNew:OnCreate()
  base.OnCreate(self)
  self.scroll_content = self:AddComponent(GridInfinityScrollView, content_path)
  self.scroll_view = self:AddComponent(UIBaseContainer, scroll_view_path)
  self.progressSlider = self:AddComponent(UISlider, progress_bar_path)
  self.occupy_num = self:AddComponent(UITextMeshProUGUIEx, occupy_num_path)
  self.btn_one_get = self:AddComponent(UIButton, btn_one_get_path)
  self.score_icon = self:AddComponent(UIImage, score_icon_path)
  self.btn_one_get:SetOnClick(function()
    self:GetAllBtn()
  end)
  self.btn_one_get:SetActive(false)
  self.progressSliderInstanceId = self.progressSlider.transform:GetInstanceID()
  self.itemList = {}
  self.rect_on_get_red = self:AddComponent(UIImage, rect_on_get_red_path)
  self.rect_on_get_red:SetActive(false)
  self.tab_btns = self:AddComponent(UIBaseContainer, tab_btns_path)
  self.tab_btns:SetActive(false)
  self.top_area = self:AddComponent(UIBaseContainer, top_area_path)
  self.join_ali_hit = self:AddComponent(UITextMeshProUGUIEx, join_ali_hit_path)
  self.raw_image = self:AddComponent(UIRawImage, raw_image_path)
  self.occupyland = self:AddComponent(UITextMeshProUGUIEx, occupyland_path)
  self.occupy_des = self:AddComponent(UITextMeshProUGUIEx, occupy_des_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_des = self:AddComponent(UIText, goto_des_path)
  self.tab_root = self:AddComponent(UIBaseContainer, tab_path)
  self.top_bar = self:AddComponent(UIScrollRect, top_bar_path)
  self.tab_item = self.transform:Find(tab_item_path).gameObject
  self.tab_item:GameObjectCreatePool()
  self.goto_btn:SetActive(false)
  self.goto_btn:SetOnClick(function()
    self:GotoBtn()
  end)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetActive(false)
  self.intro_btn:SetOnClick(function()
    self:IntroBtn()
  end)
  self.tabList = {}
end

function LWSeasonPersonalRewardNew:OnDestroy()
  self:ClearScroll()
  self.tab_root:RemoveComponents(LWSeasonAchievementTab)
  self.tab_item:GameObjectRecycleAll()
  self.tab_btns = nil
  self.rect_on_get_red = nil
  self.btn_one_get = nil
  self.content = nil
  self.scroll_view = nil
  self.progressSlider = nil
  self.itemList = nil
  self.listGOReward = nil
  self.occupy_num = nil
  self.occupyland = nil
  self.occupy_des = nil
  self.goto_btn = nil
  self.goto_des = nil
  self.top_area = nil
  self.join_ali_hit = nil
  self.raw_image = nil
  self.score_icon = nil
  self.tab_root = nil
  self.tab_item = nil
  self.top_bar = nil
  self.tabList = nil
  self.tabActive = nil
  base.OnDestroy(self)
end

function LWSeasonPersonalRewardNew:OnEnable()
  base.OnEnable(self)
  self.first = true
end

function LWSeasonPersonalRewardNew:OnDisable()
  self:ClearScroll()
  self.listGOReward = nil
  self.first = false
  self.tab_root:RemoveComponents(LWSeasonAchievementTab)
  self.tab_item:GameObjectRecycleAll()
  self.tabList = {}
  base.OnDisable(self)
end

function LWSeasonPersonalRewardNew:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonPersonalRewardInfo, self.RefreshAll)
  self:AddUIListener(EventId.LWSeasonPersonalRewardGetSuccess, self.RefreshAll)
  self:AddUIListener(EventId.LWSeasonScoreRewardInfo, self.RefreshAll)
end

function LWSeasonPersonalRewardNew:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardInfo, self.RefreshAll)
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardGetSuccess, self.RefreshAll)
  self:RemoveUIListener(EventId.LWSeasonScoreRewardInfo, self.RefreshAll)
end

function LWSeasonPersonalRewardNew:SetData(activityId, panelTypeData, defaultType)
  local count = #panelTypeData.achieveData
  self.panelTypeData = panelTypeData.achieveData
  self.isFarmer = panelTypeData.isFarmer
  if self.isFarmer then
    self.intro_btn:SetActive(true)
  end
  local defaltIndex = 1
  if defaultType then
    for index, value in ipairs(self.panelTypeData) do
      if value.type == defaultType then
        defaltIndex = index
        break
      end
    end
  end
  if 1 < count then
    self.panelType = self.panelTypeData[defaltIndex].type
    self.tab_btns:SetActive(true)
    self.selectIndex = defaltIndex
    self.curPanelData = self.panelTypeData[self.selectIndex]
    for i = 1, count do
      self:RegisterTab(self.panelTypeData[i])
    end
    local activeTab = self.tabList[self.selectIndex]
    if activeTab then
      activeTab:SetIsOn(true)
      local count = #self.tabList
      if self.tabActive == nil then
        activeTab:OnSelectStatusChanged(true)
      end
      if 3 < count then
        self.top_bar:SetHorizontalNormalizedPosition((self.selectIndex - 1) / (count - 1))
      else
        self.top_bar:SetHorizontalNormalizedPosition(0)
      end
    end
  elseif count == 1 then
    self.panelType = self.panelTypeData[1].type
    self.curPanelData = self.panelTypeData[1]
    self.tab_btns:SetActive(false)
  end
  self.raw_image:LoadSprite(self.curPanelData.banner)
  self:SetScore()
  self:ShowCells(true)
  self:RefreshText()
  self:GetGotoBtnDes()
  self:GetAllBtnState()
end

function LWSeasonPersonalRewardNew:ShowCells(flag)
  if self.listGOReward then
    return
  end
  self.personalReward = DataCenter.SeasonRewardDataManager:GetSeasonAchievementRewardData(flag, self.panelType)
  if self.first then
    self.first = false
    self.personalReward = nil
  end
  if self.personalReward then
    self.listGOReward = {}
    local bindFunc1 = BindCallback(self, self.OnInitRewardScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateRewardScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyRewardScrollItem)
    self.scroll_content:Init(bindFunc1, bindFunc2, bindFunc3)
    local count = #self.personalReward
    if count == 0 then
      self.scroll_view:SetActive(false)
    else
      self.scroll_view:SetActive(true)
      self.scroll_content:SetItemCount(count)
      self.scroll_content:ForceUpdate()
      local focus = DataCenter.SeasonRewardDataManager:GetPersonalRewardClaimIndex(self.panelType)
      if focus then
        self.scroll_content:MoveItemByIndex(focus - 1, 0)
      end
    end
    local renderItemSizeY = self.scroll_content:GetRenderItemSizeY()
    if count < 1 then
      self.progressSlider.rectTransform:Set_sizeDelta(37, 0)
    else
      self.progressSlider.rectTransform:Set_sizeDelta(37, (count - 1) * renderItemSizeY)
    end
    self:RefreshProgressBar()
  else
    self.scroll_view:SetActive(false)
  end
end

function LWSeasonPersonalRewardNew:RefreshProgressBar()
  if self.curScore == nil then
    self.curScore = DataCenter.SeasonRewardDataManager:GetPersonalOccupyLandCount(self.panelType)
  end
  local count = self.personalReward ~= nil and #self.personalReward or 0
  local progress = 0
  local step = 1 / (count - 1)
  local exp = self.curScore
  progress = 0
  local lastNeedExp = 0
  if 0 < count then
    local needExp = DataCenter.SeasonRewardDataManager:GetPersonalRewardScore(self.panelType, 1)
    lastNeedExp = needExp
    if exp >= needExp then
    else
      exp = 0
    end
    if 0 < exp then
      for i = 2, count do
        needExp = DataCenter.SeasonRewardDataManager:GetPersonalRewardScore(self.panelType, i)
        if exp >= needExp then
          progress = progress + step
          lastNeedExp = needExp
        else
          needExp = needExp - lastNeedExp
          exp = exp - lastNeedExp
          progress = exp / needExp * step + progress
          break
        end
      end
    end
  end
  progress = math.max(progress, 0)
  self.progressSlider:SetValue(progress)
end

function LWSeasonPersonalRewardNew:OnInitRewardScroll(go, index)
  local item = self.scroll_view:AddComponent(LWSeasonPersonalRewardItem, go)
  self.listGOReward[go] = item
end

function LWSeasonPersonalRewardNew:OnUpdateRewardScroll(go, index)
  index = index + 1
  local iconPath = self.curPanelData.icon
  if self.personalReward then
    if index <= #self.personalReward then
      local item = self.listGOReward[go]
      local data = self.personalReward[index]
      item:SetData(data, self, iconPath, true, self.isFarmer)
      go:SetActive(true)
      self.itemList[index] = item
    end
  else
    go:SetActive(false)
  end
end

function LWSeasonPersonalRewardNew:OnDestroyRewardScrollItem(go, index)
end

function LWSeasonPersonalRewardNew:ClearScroll()
  self.scroll_view:RemoveComponents(LWSeasonPersonalRewardItem)
  self.scroll_content:DestroyChildNodeExceptIndex(self.progressSliderInstanceId)
end

function LWSeasonPersonalRewardNew:GetAllBtn()
  SFSNetwork.SendMessage(MsgDefines.LWSeasonUserMaxForceRewardGetAll)
end

function LWSeasonPersonalRewardNew:GetAllBtnState()
  local canGetAll = SeasonRedPointUtils.SeasonPersonalRewardAllGetBtnRedState(self.panelType)
  self.rect_on_get_red:SetActive(canGetAll)
  CS.UIGray.SetGray(self.btn_one_get.transform, not canGetAll, canGetAll)
end

function LWSeasonPersonalRewardNew:RefreshAll()
  if self.listGOReward then
    self:SetScore()
    local count = self.personalReward ~= nil and #self.personalReward or 0
    if count == 0 then
      self.personalReward = DataCenter.SeasonRewardDataManager:GetSeasonAchievementRewardData(false, self.panelType)
      count = self.personalReward ~= nil and #self.personalReward or 0
      local focus = DataCenter.SeasonRewardDataManager:GetPersonalRewardClaimIndex(self.panelType)
      if focus then
        self.scroll_content:MoveItemByIndex(focus - 1, 0)
      else
        self.scroll_content:MoveItemByIndex(0)
      end
      self.scroll_content:SetItemCount(count)
      self.scroll_content:ForceUpdate()
      local renderItemSizeY = self.scroll_content:GetRenderItemSizeY()
      if count < 1 then
        self.progressSlider.rectTransform:Set_sizeDelta(37, 0)
      else
        self.progressSlider.rectTransform:Set_sizeDelta(37, (count - 1) * renderItemSizeY)
      end
    else
      self.scroll_content:ForceUpdate()
    end
    self:RefreshProgressBar()
  else
    self:SetScore()
    self:ShowCells(false)
  end
  self:RefreshTabRed()
end

function LWSeasonPersonalRewardNew:SetScore()
  self.curScore = DataCenter.SeasonRewardDataManager:GetPersonalOccupyLandCount(self.panelType)
  if string.IsNullOrEmpty(self.curPanelData.value) then
    self.occupy_num:SetText(self.curScore)
  else
    self.occupy_num:SetText(Localization:GetString(self.curPanelData.value, self.curScore))
  end
end

function LWSeasonPersonalRewardNew:DoSelectTabIndex(index)
  if index ~= self.selectIndex then
    self.selectIndex = index
  else
    return
  end
  self.panelType = self.panelTypeData[self.selectIndex].type
  self.curPanelData = self.panelTypeData[self.selectIndex]
  self:SetScore()
  if self.listGOReward then
    self.personalReward = DataCenter.SeasonRewardDataManager:GetSeasonAchievementRewardData(true, self.panelType)
    self:SetScore()
    local count = self.personalReward ~= nil and #self.personalReward or 0
    local focus = DataCenter.SeasonRewardDataManager:GetPersonalRewardClaimIndex(self.panelType)
    if focus then
      self.scroll_content:MoveItemByIndex(focus - 1, 0)
    else
      self.scroll_content:MoveItemByIndex(0)
    end
    self.scroll_content:SetItemCount(count)
    self.scroll_content:ForceUpdate()
    local renderItemSizeY = self.scroll_content:GetRenderItemSizeY()
    if count < 1 then
      self.progressSlider.rectTransform:Set_sizeDelta(37, 0)
    else
      self.progressSlider.rectTransform:Set_sizeDelta(37, (count - 1) * renderItemSizeY)
    end
    self:RefreshProgressBar()
  else
    self.listGOReward = nil
    self:ShowCells(true)
  end
  self.raw_image:LoadSprite(self.curPanelData.banner)
  self:RefreshBar()
  self:RefreshText()
  self:GetGotoBtnDes()
end

function LWSeasonPersonalRewardNew:RefreshBar()
end

function LWSeasonPersonalRewardNew:RefreshText()
  local title, des
  title = Localization:GetString(self.curPanelData.title)
  des = Localization:GetString(self.curPanelData.description)
  self.occupyland:SetText(title)
  self.occupy_des:SetText(des)
  self.score_icon:LoadSprite(self.curPanelData.icon)
end

function LWSeasonPersonalRewardNew:GotoBtn()
  if self.curPanelData.flag == SeasonAchivementFlag.Personal then
  else
    if self.curPanelData.flag == SeasonAchivementFlag.Alliance and LuaEntry.Player:IsInAlliance() == false then
      if LuaEntry.Player:IsFirstJoinAlliance() == true then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
        return
      end
      local params = {guide = false}
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    else
    end
  end
end

function LWSeasonPersonalRewardNew:GetGotoBtnDes()
  if self.curPanelData.flag == SeasonAchivementFlag.Personal then
    self.top_area:SetActive(true)
    self.join_ali_hit:SetActive(false)
    self.goto_des:SetText(Localization:GetString("season_score_rank_jump"))
  elseif self.curPanelData.flag == SeasonAchivementFlag.Alliance then
    self.top_area:SetActive(LuaEntry.Player:IsInAlliance())
    self.join_ali_hit:SetActive(not LuaEntry.Player:IsInAlliance())
    self.goto_des:SetText(Localization:GetString("season_score_rank_jump"))
  else
    self.goto_btn:SetActive(false)
    self.goto_des:SetText("")
    self.top_area:SetActive(true)
    self.join_ali_hit:SetActive(false)
  end
end

function LWSeasonPersonalRewardNew:RefreshTabRed()
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  for key, value in pairs(self.tabList) do
    value:RefreshRed()
  end
end

function LWSeasonPersonalRewardNew:RegisterTab(data)
  local goItem = self.tab_item:GameObjectSpawn(self.tab_root.transform)
  local index = #self.tabList + 1
  goItem.name = "tab_" .. index
  goItem:SetActive(true)
  local theTabItem = self.tab_root:AddComponent(LWSeasonAchievementTab, goItem.name)
  theTabItem:ReInit(data, index, self)
  table.insert(self.tabList, theTabItem)
  return theTabItem
end

function LWSeasonPersonalRewardNew:OnTabActive(tab)
  self.tabActive = tab
  self:DoSelectTabIndex(tab.index)
end

function LWSeasonPersonalRewardNew:GetSeasonRoleData()
  if self.isFarmer then
    self.roleState = LuaEntry.Player:SeaonRoleState()
  end
end

function LWSeasonPersonalRewardNew:IntroBtn()
  if self.isFarmer then
    local mainCfg = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
    if not string.IsNullOrEmpty(mainCfg.grade_reward_help) then
      local param = {}
      param.activityRulesStr = Localization:GetString(mainCfg.achievements_help)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
    end
  end
end

return LWSeasonPersonalRewardNew
