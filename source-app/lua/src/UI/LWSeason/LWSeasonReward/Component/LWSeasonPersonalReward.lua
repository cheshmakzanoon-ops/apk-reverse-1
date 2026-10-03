local base = UIBaseContainer
local LWSeasonPersonalReward = BaseClass("LWSeasonPersonalReward", base)
local Localization = CS.GameEntry.Localization
local LWSeasonPersonalRewardItem = require("UI.LWSeason.LWSeasonReward.Component.LWSeasonPersonalRewardItem")
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local content_path = "Root/mid/Mask/ScrollView/Content"
local scroll_view_path = "Root/mid/Mask/ScrollView"
local progress_bar_path = "Root/mid/Mask/ScrollView/Content/ProgressBar"
local rect_on_get_red_path = "Btn_List/Btn_OneGet/Rect_OnGetRed"
local btn_one_get_path = "Btn_List/Btn_OneGet"
local tab_btns_path = "Root/tabBtns"
local tab_path = "Root/tabBtns/ConditionBtns/Tab%d"
local occupy_num_path = "Root/top/topArea/occupyNum"
local occupyland_path = "Root/top/topArea/occupyland"
local occupy_des_path = "Root/top/topArea/occupyDes"
local goto_btn_path = "Root/top/gotoBtn"
local goto_des_path = "Root/top/gotoBtn/gotoDes"
local top_area_path = "Root/top/topArea"
local join_ali_hit_path = "Root/top/joinAliHit"
local raw_image_path = "Root/top/RawImage"
local score_icon_path = "Root/top/topArea/scoreIcon"

function LWSeasonPersonalReward:OnCreate()
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
  self.goto_btn:SetOnClick(function()
    self:GotoBtn()
  end)
  self.tabs = {}
  for i = 1, 2 do
    local tab = {}
    local rootPath = string.format(tab_path, i)
    tab.tab = self:AddComponent(UIBaseContainer, rootPath)
    tab.tab_select = tab.tab:AddComponent(UIBaseContainer, "select")
    tab.tab_name = tab.tab:AddComponent(UITextMeshProUGUIEx, "activityName")
    tab.tab_btn = tab.tab:AddComponent(UIButton, "TypeButton")
    tab.redPoint = tab.tab:AddComponent(UIBaseContainer, "RedPoint")
    tab.redPoint:SetActive(false)
    local index = i
    tab.tab_btn:SetOnClick(function()
      self:DoSelectTabIndex(index)
    end)
    self.tabs[i] = tab
  end
end

function LWSeasonPersonalReward:OnDestroy()
  self:ClearScroll()
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
  base.OnDestroy(self)
end

function LWSeasonPersonalReward:OnEnable()
  base.OnEnable(self)
  self.first = true
end

function LWSeasonPersonalReward:OnDisable()
  self:ClearScroll()
  self.listGOReward = nil
  self.first = false
  base.OnDisable(self)
end

function LWSeasonPersonalReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonPersonalRewardInfo, self.RefreshAll)
  self:AddUIListener(EventId.LWSeasonPersonalRewardGetSuccess, self.RefreshAll)
  self:AddUIListener(EventId.LWSeasonScoreRewardInfo, self.RefreshAll)
end

function LWSeasonPersonalReward:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardInfo, self.RefreshAll)
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardGetSuccess, self.RefreshAll)
  self:RemoveUIListener(EventId.LWSeasonScoreRewardInfo, self.RefreshAll)
end

function LWSeasonPersonalReward:SetData(activityId, panelTypeData, defaultType)
  local count = #panelTypeData
  self.panelTypeData = panelTypeData
  local defaltIndex = 1
  if defaultType then
    for index, value in ipairs(self.panelTypeData) do
      if value.type == defaultType then
        defaltIndex = index
        break
      end
    end
  end
  if count == 2 then
    self.panelType = panelTypeData[defaltIndex].type
    self.tab_btns:SetActive(true)
    for i = 1, 2 do
      self.tabs[i].tab_name:SetText(Localization:GetString(panelTypeData[i].key))
      self.tabs[i].redPoint:SetActive(DataCenter.SeasonRewardDataManager:IsGetRewardTabRed(panelTypeData[i].type))
    end
    self.selectIndex = 1
    self:RefreshBar()
  elseif count == 1 then
    self.panelType = panelTypeData[1].type
    self.tab_btns:SetActive(false)
  end
  self.raw_image:LoadSprite(self:GetBgPath())
  self.curScore = DataCenter.SeasonRewardDataManager:GetPersonalOccupyLandCount(self.panelType)
  self.occupy_num:SetText(self.curScore)
  self:ShowCells(true)
  self:RefreshText()
  self:GetGotoBtnDes()
  self:GetAllBtnState()
end

function LWSeasonPersonalReward:ShowCells(flag)
  if self.listGOReward then
    return
  end
  self.personalReward = DataCenter.SeasonRewardDataManager:GetPersonalRewardData(flag, self.panelType)
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

function LWSeasonPersonalReward:RefreshProgressBar()
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

function LWSeasonPersonalReward:OnInitRewardScroll(go, index)
  local item = self.scroll_view:AddComponent(LWSeasonPersonalRewardItem, go)
  self.listGOReward[go] = item
end

function LWSeasonPersonalReward:OnUpdateRewardScroll(go, index)
  index = index + 1
  local iconPath = self:GetIconPath()
  if self.personalReward then
    if index <= #self.personalReward then
      local item = self.listGOReward[go]
      local data = self.personalReward[index]
      item:SetData(data, self, iconPath, false)
      go:SetActive(true)
      self.itemList[index] = item
    end
  else
    go:SetActive(false)
  end
end

function LWSeasonPersonalReward:OnDestroyRewardScrollItem(go, index)
end

function LWSeasonPersonalReward:ClearScroll()
  self.scroll_view:RemoveComponents(LWSeasonPersonalRewardItem)
  self.scroll_content:DestroyChildNodeExceptIndex(self.progressSliderInstanceId)
end

function LWSeasonPersonalReward:GetAllBtn()
  SFSNetwork.SendMessage(MsgDefines.LWSeasonUserMaxForceRewardGetAll)
end

function LWSeasonPersonalReward:GetAllBtnState()
  local canGetAll = SeasonRedPointUtils.SeasonPersonalRewardAllGetBtnRedState(self.panelType)
  self.rect_on_get_red:SetActive(canGetAll)
  CS.UIGray.SetGray(self.btn_one_get.transform, not canGetAll, canGetAll)
end

function LWSeasonPersonalReward:RefreshAll()
  if self.listGOReward then
    self.curScore = DataCenter.SeasonRewardDataManager:GetPersonalOccupyLandCount(self.panelType)
    self.occupy_num:SetText(self.curScore)
    self.scroll_content:ForceUpdate()
    self:RefreshProgressBar()
  else
    self.curScore = DataCenter.SeasonRewardDataManager:GetPersonalOccupyLandCount(self.panelType)
    self.occupy_num:SetText(self.curScore)
    self:ShowCells(false)
  end
  self:RefreshTabRed()
end

function LWSeasonPersonalReward:DoSelectTabIndex(index)
  if index ~= self.selectIndex then
    self.selectIndex = index
  else
    return
  end
  self.panelType = self.panelTypeData[self.selectIndex].type
  self.curScore = DataCenter.SeasonRewardDataManager:GetPersonalOccupyLandCount(self.panelType)
  self.occupy_num:SetText(self.curScore)
  if self.listGOReward then
    self.personalReward = DataCenter.SeasonRewardDataManager:GetPersonalRewardData(true, self.panelType)
    self.curScore = DataCenter.SeasonRewardDataManager:GetPersonalOccupyLandCount(self.panelType)
    self.occupy_num:SetText(self.curScore)
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
  self.raw_image:LoadSprite(self:GetBgPath())
  self:RefreshBar()
  self:RefreshText()
  self:GetGotoBtnDes()
end

function LWSeasonPersonalReward:RefreshBar()
  for i = 1, #self.tabs do
    if self.tabs[i] ~= nil then
      self.tabs[i].tab_select:SetActive(i == self.selectIndex)
    end
  end
end

function LWSeasonPersonalReward:RefreshText()
  local title, des
  if self.panelType == SeasonScoreRewardPanelType.PersonalOccupyLand then
    title = Localization:GetString("season_reward_ui_019")
    des = Localization:GetString("season_reward_ui_020")
  elseif self.panelType == SeasonScoreRewardPanelType.PersonalContributeAchievement then
    title = Localization:GetString("season_rules_ui_desc013")
    des = Localization:GetString("season_rules_ui_desc014")
  elseif self.panelType == SeasonScoreRewardPanelType.AllianceStrongholdAchivement then
    title = Localization:GetString("season_achievement_personal_01")
    des = Localization:GetString("season_achievement_personal_02")
  end
  self.occupyland:SetText(title)
  self.occupy_des:SetText(des)
  self.score_icon:LoadSprite(self:GetIconPath())
end

function LWSeasonPersonalReward:GetIconPath()
  if self.panelType == SeasonScoreRewardPanelType.PersonalOccupyLand then
    return "Assets/Main/Sprites/UI/UISeasonReward/Mjc_saijijiangli_icon_dikuai.png"
  elseif self.panelType == SeasonScoreRewardPanelType.PersonalContributeAchievement then
    return "Assets/Main/Sprites/UI/UISeasonReward/zyf_saijijiangli2_icon_1.png"
  elseif self.panelType == SeasonScoreRewardPanelType.AllianceStrongholdAchivement then
    return "Assets/Main/Sprites/UI/UISeasonReward/zyf_saijijiangli2_icon_2.png"
  end
  return "Assets/Main/Sprites/UI/UISeasonReward/Mjc_saijijiangli_icon_dikuai.png"
end

function LWSeasonPersonalReward:GotoBtn()
  if self.panelType == SeasonScoreRewardPanelType.PersonalOccupyLand then
  elseif self.panelType == SeasonScoreRewardPanelType.PersonalContributeAchievement then
    GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILDING_SEASON_VIRUS_INSTITUTE_CTIY)
  elseif self.panelType == SeasonScoreRewardPanelType.AllianceStrongholdAchivement then
    if LuaEntry.Player:IsInAlliance() == false then
      if LuaEntry.Player:IsFirstJoinAlliance() == true then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
        return
      end
      local params = {guide = false}
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    else
      GoToUtil.GotoNearestCityStronghold(true)
    end
  end
end

function LWSeasonPersonalReward:GetGotoBtnDes()
  if self.panelType == SeasonScoreRewardPanelType.PersonalOccupyLand then
    self.goto_btn:SetActive(false)
    self.goto_des:SetText("")
    self.top_area:SetActive(true)
    self.join_ali_hit:SetActive(false)
  elseif self.panelType == SeasonScoreRewardPanelType.PersonalContributeAchievement then
    self.top_area:SetActive(true)
    self.goto_btn:SetActive(true)
    self.join_ali_hit:SetActive(false)
    self.goto_des:SetText(Localization:GetString("season_score_rank_jump"))
  elseif self.panelType == SeasonScoreRewardPanelType.AllianceStrongholdAchivement then
    self.goto_btn:SetActive(LuaEntry.Player:IsInAlliance())
    self.top_area:SetActive(LuaEntry.Player:IsInAlliance())
    self.join_ali_hit:SetActive(not LuaEntry.Player:IsInAlliance())
    self.goto_des:SetText(Localization:GetString("season_score_rank_jump"))
  end
end

function LWSeasonPersonalReward:GetBgPath()
  if self.panelType == SeasonScoreRewardPanelType.PersonalOccupyLand then
    return "Assets/Main/TextureEx/Season/SeasonReward/Mjc_saijijiangli_gerenjiangli_bg.png"
  elseif self.panelType == SeasonScoreRewardPanelType.PersonalContributeAchievement then
    return "Assets/Main/TextureEx/Season/SeasonReward/Mjc_saiji2_jiangli_gerenjiangli_bg.png"
  elseif self.panelType == SeasonScoreRewardPanelType.AllianceStrongholdAchivement then
    return "Assets/Main/TextureEx/Season/SeasonReward/Mjc_saiji2_jiangli_gerenjiangli_bg.png"
  end
  return "Assets/Main/TextureEx/Season/SeasonReward/Mjc_saijijiangli_gerenjiangli_bg.png"
end

function LWSeasonPersonalReward:RefreshTabRed()
  for i = 1, 2 do
    self.tabs[i].redPoint:SetActive(DataCenter.SeasonRewardDataManager:IsGetRewardTabRed(self.panelTypeData[i].type))
  end
end

return LWSeasonPersonalReward
