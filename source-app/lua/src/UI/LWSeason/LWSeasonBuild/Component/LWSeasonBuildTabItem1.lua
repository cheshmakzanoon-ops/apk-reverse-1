local LWSeasonBuildTabItem1 = BaseClass("LWSeasonBuildTabItem1", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWSeasonBuildComboxItem = require("UI.LWSeason.LWSeasonBuild.Component.LWSeasonBuildComboxItem")
local LWSeasonBuildDesertItem = require("UI.LWSeason.LWSeasonBuild.Component.LWSeasonBuildDesertItem")
local lastActiveTab = 1
local info_btn_path = "InfoBtn"
local btn_rank_path = "BtnRank"
local txt_rank_path = "Txt_Rank"
local txt_score_path = "Txt_Score"
local txt_res1_path = "ResList/res1/Txt_Res1"
local txt_res2_path = "ResList/res2/Txt_Res2"
local txt_res3_path = "ResList/res3/Txt_Res3"
local txt_res4_path = "ResList/res4/Txt_Res4"
local scroll_view1_path = "ScrollView1"
local scroll_view2_path = "ScrollView2"
local cell_path = "cell"
local content1_path = "ScrollView1/Viewport/Content1"
local content2_path = "ScrollView2/Viewport/Content2"
local toggle1_path = "TabHolder/Tab/toggle1"
local toggle_txt_off1_path = "TabHolder/Tab/toggle1/toggle_txt_off1"
local toggle_txt_on1_path = "TabHolder/Tab/toggle1/on1/toggle_txt_on1"
local red_point1_path = "TabHolder/Tab/toggle1/RedPoint1"
local toggle2_path = "TabHolder/Tab/toggle2"
local toggle_txt_off2_path = "TabHolder/Tab/toggle2/toggle_txt_off2"
local toggle_txt_on2_path = "TabHolder/Tab/toggle2/on2/toggle_txt_on2"
local red_point2_path = "TabHolder/Tab/toggle2/RedPoint2"
local desc_path = "TabHolder/desc"
local content_path = "TabHolder/Combbox/expand/Viewport/Content"
local divide_path = "TabHolder/Divide"
local combox_path = "TabHolder/Combbox"
local combox_text_path = "TabHolder/Combbox/CombboxText"
local combox_btn_path = "TabHolder/Combbox/CombboxBtn"
local expand_path = "TabHolder/Combbox/expand"
local text_title1_path = "ScrollView1/Viewport/TextTitle1"
local text_title2_path = "ScrollView2/Viewport/TextTitle2"
local btn_close_combox_path = "TabHolder/Combbox/expand/BtnCloseCombox"
local btn_history_path = "BtnHistory"

function LWSeasonBuildTabItem1:OnCreate()
  base.OnCreate(self)
  self.theItem = self.transform:Find(divide_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.txt_rank = self:AddComponent(UIText, txt_rank_path)
  self.txt_score = self:AddComponent(UIText, txt_score_path)
  self.scroll_view1 = self:AddComponent(UIImage, scroll_view1_path)
  self.scroll_view2 = self:AddComponent(UIImage, scroll_view2_path)
  self.theDesertItem = self.transform:Find(cell_path).gameObject
  self.theDesertItem:GameObjectCreatePool()
  self.DesertContent1 = self:AddComponent(UIBaseContainer, content1_path)
  self.DesertContent2 = self:AddComponent(UIBaseContainer, content2_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.txt_res1 = self:AddComponent(UIText, txt_res1_path)
  self.txt_res2 = self:AddComponent(UIText, txt_res2_path)
  self.txt_res3 = self:AddComponent(UIText, txt_res3_path)
  self.txt_res4 = self:AddComponent(UIText, txt_res4_path)
  self.toggle_txt_off1 = self:AddComponent(UIText, toggle_txt_off1_path)
  self.toggle_txt_off2 = self:AddComponent(UIText, toggle_txt_off2_path)
  self.toggle_txt_on1 = self:AddComponent(UIText, toggle_txt_on1_path)
  self.toggle_txt_on2 = self:AddComponent(UIText, toggle_txt_on2_path)
  self.red_point1 = self:AddComponent(UIImage, red_point1_path)
  self.red_point2 = self:AddComponent(UIImage, red_point2_path)
  self.tab_item1 = self:AddComponent(UIToggle, toggle1_path)
  self.tab_item2 = self:AddComponent(UIToggle, toggle2_path)
  self.btn_history = self:AddComponent(UIButton, btn_history_path)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(1)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(2)
    end
  end)
  self.info_btn:SetOnClick(function()
    local title = "803068"
    local desc = Localization:GetString("803070")
    UIUtil.ShowDetail(desc, title)
  end)
  self.btn_rank:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank, {anim = true}, 2)
  end)
  self.btn_history:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDispatchTaskLog, {anim = true}, 3)
  end)
  self.combox = self:AddComponent(UIButton, combox_path)
  self.combox_text = self:AddComponent(UIText, combox_text_path)
  self.combox_btn = self:AddComponent(UIButton, combox_btn_path)
  self.expand = self:AddComponent(UICanvasGroup, expand_path)
  self.btn_close_combox = self:AddComponent(UIButton, btn_close_combox_path)
  self.text_title1 = self:AddComponent(UIText, text_title1_path)
  self.text_title2 = self:AddComponent(UIText, text_title2_path)
  self.text_title1:SetLocalText("season_desert_desc001")
  self.text_title2:SetLocalText("season_desert_desc001")
  self.toggle_txt_off1:SetLocalText("season_desert_desc002")
  self.toggle_txt_off2:SetLocalText("season_desert_desc003")
  self.toggle_txt_on1:SetLocalText("season_desert_desc002")
  self.toggle_txt_on2:SetLocalText("season_desert_desc003")
  self:RefreshNum()
  self.combox:SetOnClick(function()
    self:DoComboxExpand()
  end)
  self.combox_btn:SetOnClick(function()
    self:DoComboxExpand()
  end)
  self.btn_close_combox:SetOnClick(function()
    self:DoComboxCollapse(false)
  end)
  self.tabActive = nil
  self.theFilterLevel = {-1, -1}
  self.expand:SetActive(false)
  if lastActiveTab == 1 then
    self.tab_item1:SetIsOn(true)
  else
    self.tab_item2:SetIsOn(true)
  end
  if self.tabActive == nil then
    self:OnTabChanged(lastActiveTab)
  end
  self.refreshTime = 3
  
  function self.timer_action(temp)
    self:RefreshNum()
  end
  
  self:AddTimer()
  self.txt_rank:SetText("")
  self.txt_score:SetText("")
  self.rankData = nil
end

function LWSeasonBuildTabItem1:OnDestroy()
  self:DeleteTimer()
  self.DesertContent1:RemoveComponents(LWSeasonBuildDesertItem)
  self.DesertContent2:RemoveComponents(LWSeasonBuildDesertItem)
  self.theDesertItem:GameObjectRecycleAll()
  self.content:RemoveComponents(LWSeasonBuildComboxItem)
  self.theItem:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function LWSeasonBuildTabItem1:OnEnable()
  base.OnEnable(self)
  if self.rankData == nil then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonRankInfo, 2)
  end
end

function LWSeasonBuildTabItem1:OnDisable()
  base.OnDisable(self)
end

function LWSeasonBuildTabItem1:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonRankUpdate, self.OnSeasonRankUpdate)
  self:AddUIListener(EventId.UserGetDesert, self.OnDesertUpdate)
  self:AddUIListener(EventId.UserLostDesert, self.OnDesertUpdate)
end

function LWSeasonBuildTabItem1:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonRankUpdate, self.OnSeasonRankUpdate)
  self:RemoveUIListener(EventId.UserGetDesert, self.OnDesertUpdate)
  self:RemoveUIListener(EventId.UserLostDesert, self.OnDesertUpdate)
  base.OnRemoveListener(self)
end

function LWSeasonBuildTabItem1:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(self.refreshTime, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
end

function LWSeasonBuildTabItem1:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function LWSeasonBuildTabItem1:OnSeasonRankUpdate(data)
  if data and data.rank_type == 2 then
    if data.self and data.self.rank then
      self.txt_rank:SetText(Localization:GetString("season_power_rank", data.self.rank))
    else
      self.txt_rank:SetText(Localization:GetString("2800058"))
    end
    if data.self and data.self.score then
      self.txt_score:SetText(Localization:GetString("season_influence01") .. data.self.score)
    else
      self.txt_score:SetText(Localization:GetString("season_influence01") .. "0")
    end
    self.rankData = data
  end
end

function LWSeasonBuildTabItem1:RefreshNum()
  local mgr = DataCenter.DesertDataManager
  self.totalGasSpeed = mgr:GetSeasonResourceCollectSpeed(ResourceType.OBSIDIAN)
  self.totalFlintSpeed = mgr:GetSeasonResourceCollectSpeed(ResourceType.FLINT)
  self.totalMetalSpeed = mgr:GetSeasonResourceCollectSpeed(ResourceType.Metal)
  self.totalFoodSpeed = mgr:GetSeasonResourceCollectSpeed(ResourceType.Food)
  self.txt_res1:SetText(string.GetFormattedSeparatorNum(math.floor(self.totalGasSpeed)) .. "/h")
  self.txt_res2:SetText(string.GetFormattedSeparatorNum(math.floor(self.totalFlintSpeed)) .. "/h")
  self.txt_res3:SetText(string.GetFormattedSeparatorNum(math.floor(self.totalMetalSpeed)) .. "/h")
  self.txt_res4:SetText(string.GetFormattedSeparatorNum(math.floor(self.totalFoodSpeed)) .. "/h")
  local gasNum, flintNum, metalNum, foodNum, deltaTime = mgr:GetCanGatherResNum(self.totalGasSpeed, self.totalFlintSpeed, self.totalMetalSpeed, self.totalFoodSpeed)
  self.view.res1:SetText(string.GetFormattedStr(gasNum))
  self.view.res2:SetText(string.GetFormattedStr(flintNum))
  self.view.res3:SetText(string.GetFormattedStr(metalNum))
  self.view.res4:SetText(string.GetFormattedStr(foodNum))
  if self.totalGasSpeed >= 3.6 then
    self.view.animTxt1:SetText(string.format("+%.3f", self.totalGasSpeed / 3600))
    self:TryPlayResAnim(self.view.anim1)
  end
  if self.totalFlintSpeed >= 3.6 then
    self.view.animTxt2:SetText(string.format("+%.3f", self.totalFlintSpeed / 3600))
    self:TryPlayResAnim(self.view.anim2)
  end
  if self.totalMetalSpeed >= 3.6 then
    self.view.animTxt3:SetText(string.format("+%.3f", self.totalMetalSpeed / 3600))
    self:TryPlayResAnim(self.view.anim3)
  end
  if self.totalFoodSpeed >= 3.6 then
    self.view.animTxt4:SetText(string.format("+%.3f", self.totalFoodSpeed / 3600))
    self:TryPlayResAnim(self.view.anim4)
  end
  self.gasNum = gasNum
  self.flintNum = flintNum
  self.metalNum = metalNum
  self.foodNum = foodNum
  self.deltaTime = deltaTime
end

function LWSeasonBuildTabItem1:TryPlayResAnim(theItem)
  if not IsNull(theItem.unity_canvas_group) then
    theItem:SetActive(true)
    theItem.rectTransform:Set_anchoredPosition(0, 0)
    theItem.unity_canvas_group.alpha = 1
    theItem.unity_canvas_group:DOFade(0, 1.5)
    theItem.transform:DOLocalMoveY(60, 1.5)
  end
end

function LWSeasonBuildTabItem1:SetFilter(data)
  if self.whenComboxChanging ~= true then
    self.theFilterLevel[self.tabActive] = data
    self:DoComboxCollapse(true)
  end
end

function LWSeasonBuildTabItem1:DoComboxExpand()
  self.expand:SetAlpha(0)
  self.expand:SetActive(true)
  local select_level = self.theFilterLevel[self.tabActive]
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Join(self.expand:FadeIn(0.2))
  sequence:Join(self.expand.transform:DOScale(Vector3.New(1, 1, 1), 0.2))
  if self.combox_item_list then
    self.whenComboxChanging = true
    for _, theItem in ipairs(self.combox_item_list) do
      if select_level == theItem.data then
        theItem:SetIsOn(true)
        break
      end
    end
    self.whenComboxChanging = false
  end
end

function LWSeasonBuildTabItem1:DoComboxCollapse(refresh)
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Join(self.expand:FadeOut(0.2))
  sequence:Join(self.expand.transform:DOScale(Vector3.New(1, 0, 1), 0.2))
  sequence:AppendCallback(function()
    self.expand:SetActive(false)
  end)
  if refresh and self.tabActive ~= nil then
    self:UpdateData()
  end
end

function LWSeasonBuildTabItem1:OnDesertUpdate()
  self:OnTabChanged(self.tabActive)
end

function LWSeasonBuildTabItem1:OnTabChanged(index)
  lastActiveTab = index
  self.whenTabChanging = true
  self.tabActive = index
  self.scroll_view1:SetActive(index == 1)
  self.scroll_view2:SetActive(index == 2)
  self.DesertContent = index == 1 and self.DesertContent1 or self.DesertContent2
  self.expand:SetActive(false)
  self.dataList = DataCenter.DesertDataManager:GetSortList(index == 2)
  self.combox:SetActive(false)
  self.whenTabChanging = false
  self:UpdateData()
end

function LWSeasonBuildTabItem1:UpdateData()
  if self.whenTabChanging or self.tabActive == nil or self.DesertContent == nil then
    return
  end
  local myDesertList = DataCenter.DesertDataManager:GetAllMyDesert()
  local selfServerId = LuaEntry.Player:GetSourceServerId()
  local maxNum = DataCenter.DesertDataManager:GetDesertMaxNum()
  local select_level = -1
  local dataList = {}
  local ownCount = 0
  if self.tabActive == 1 then
    for k, v in pairs(myDesertList) do
      if v.serverId == selfServerId and (select_level == -1 or select_level == v.level) then
        table.insert(dataList, v)
      end
    end
    ownCount = #dataList
    self.text_title1:SetActive(ownCount == 0)
    self.text_title2:SetActive(false)
  else
    for k, v in pairs(myDesertList) do
      if v.serverId ~= selfServerId and (select_level == -1 or select_level == v.level) then
        table.insert(dataList, v)
      end
    end
    ownCount = #dataList
    self.text_title1:SetActive(false)
    self.text_title2:SetActive(ownCount == 0)
  end
  table.sort(dataList, function(a, b)
    if a.level == b.level then
      if a.desert_type == b.desert_type then
        return a.mineId > b.mineId
      end
      return a.desert_type > b.desert_type
    end
    return a.level > b.level
  end)
  self.desc:SetLocalText("season_desert_UI001", ownCount, maxNum)
  if select_level == nil or select_level == -1 then
    self.combox_text:SetLocalText("season_desert_UI002")
  elseif select_level == 0 then
    self.combox_text:SetLocalText("110245")
  else
    self.combox_text:SetLocalText("140002", select_level)
  end
  self.showDataList = dataList
  local goItem, theItem
  self.DesertContent1:RemoveComponents(LWSeasonBuildDesertItem)
  self.DesertContent2:RemoveComponents(LWSeasonBuildDesertItem)
  self.theDesertItem:GameObjectRecycleAll()
  for k, v in ipairs(dataList) do
    goItem = self.theDesertItem:GameObjectSpawn(self.DesertContent.transform)
    goItem.name = "item_" .. k
    goItem:SetActive(true)
    theItem = self.DesertContent:AddComponent(LWSeasonBuildDesertItem, goItem.name)
    theItem:ReInit(k, dataList[k], self.tabActive == 1)
  end
end

return LWSeasonBuildTabItem1
