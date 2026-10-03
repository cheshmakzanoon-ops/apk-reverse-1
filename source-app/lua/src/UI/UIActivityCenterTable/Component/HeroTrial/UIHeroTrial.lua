local UIHeroTrial = BaseClass("UIHeroTrial", UIBaseView)
local base = UIBaseView
local HeroTrialHeroItem = require("UI.UIActivityCenterTable.Component.HeroTrial.HeroTrialHeroItem")
local HeroTrialRewardItem = require("UI.UIActivityCenterTable.Component.HeroTrial.HeroTrialRewardItem")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local hero_name_item1_path = "Root/NameList/HeroNameItem1"
local hero_name_item2_path = "Root/NameList/HeroNameItem2"
local hero_name_item3_path = "Root/NameList/HeroNameItem3"
local info_detail1_path = "Root/NameList/HeroNameItem1/InfoDetail1"
local info_detail2_path = "Root/NameList/HeroNameItem2/InfoDetail2"
local info_detail3_path = "Root/NameList/HeroNameItem3/InfoDetail3"
local hero_name1_path = "Root/NameList/HeroNameItem1/InfoDetail1/HeroName1"
local hero_name2_path = "Root/NameList/HeroNameItem2/InfoDetail2/HeroName2"
local hero_name3_path = "Root/NameList/HeroNameItem3/InfoDetail3/HeroName3"
local left_line1_path = "Root/Lines/LeftLine/LeftLine1"
local left_line2_path = "Root/Lines/LeftLine/LeftLine2"
local right_line1_path = "Root/Lines/RightLine/RightLine1"
local right_line2_path = "Root/Lines/RightLine/RightLine2"
local add_symbol_mid_path = "Root/HeroScroll/Viewport/AddSymbols/AddSymbolMid"
local add_symbol_left_path = "Root/HeroScroll/Viewport/AddSymbols/AddSymbolLeft"
local add_symbol_right_path = "Root/HeroScroll/Viewport/AddSymbols/AddSymbolRight"

function UIHeroTrial:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIHeroTrial:OnDestroy()
  self:DeleteTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIHeroTrial:OnEnable()
  base.OnEnable(self)
  self:SendRequest()
end

function UIHeroTrial:OnDisable()
  base.OnDisable(self)
end

function UIHeroTrial:OnCreateCell(itemObj, index)
  itemObj.transform:Set_localScale(1, 1, 1)
  itemObj.name = tostring(index)
  local item = self._reward_scroll_view:AddComponent(HeroTrialRewardItem, itemObj)
  local reward
  if type(self.rewardList[index].value) == "table" then
    reward = {
      rewardType = self.rewardList[index].type,
      count = self.rewardList[index].value.num,
      itemId = self.rewardList[index].value.id
    }
  else
    reward = {
      rewardType = self.rewardList[index].type,
      count = self.rewardList[index].value
    }
  end
  item:ReInit(reward, self.curStateInfo.state == 1)
  CS.UIGray.SetGray(item.transform, self.isHighest, true)
end

function UIHeroTrial:OnDeleteCell(itemObj, index)
  self._reward_scroll_view:RemoveComponent(itemObj.name, HeroTrialRewardItem)
end

function UIHeroTrial:ClearScroll()
  if self._reward_scroll_view == nil then
    return
  end
  self._reward_scroll_view:ClearCells()
  self._reward_scroll_view:RemoveComponents(HeroTrialRewardItem)
end

function UIHeroTrial:DisposeRequest()
  if self.heroSpineLoadRequest then
    table.walk(self.heroSpineLoadRequest, function(k, v)
      if v ~= nil then
        if v.gameObject then
          local rectTransform = v.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
          rectTransform:Set_anchorMin(0.5, 0.5)
          rectTransform:Set_anchorMax(0.5, 0.5)
          rectTransform.pivot = Vector2.New(0.5, 0.9)
        end
        v:Destroy()
      end
    end)
  end
  self.heroSpineLoadRequest = {}
end

function UIHeroTrial:ComponentDefine()
  self._hero_container1 = self:AddComponent(UIBaseContainer, "Root/Mask/Hero1")
  self._hero_container2 = self:AddComponent(UIBaseContainer, "Root/Mask/Hero2")
  self._hero_container3 = self:AddComponent(UIBaseContainer, "Root/Mask/Hero3")
  self._hero_container_list = {
    self._hero_container1,
    self._hero_container2,
    self._hero_container3
  }
  self._actName_txt = self:AddComponent(UIText, "Root/NameText")
  self._time_txt = self:AddComponent(UIText, "Root/RemainTimeContent/RemainTimeText")
  self._intro_btn = self:AddComponent(UIButton, "Root/InfoBtn")
  self._intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnIntroClick()
  end)
  self._receive_btn_img = self:AddComponent(UIImage, "Root/BottomBar/ReceiveBtn/BtnImg")
  self._receive_btn_text = self:AddComponent(UIText, "Root/BottomBar/ReceiveBtn/BtnImg/BtnText")
  self._receive_btn = self:AddComponent(UIButton, "Root/BottomBar/ReceiveBtn")
  self._receive_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnReceiveClick()
  end)
  self._desc_txt = self:AddComponent(UIText, "Root/BG3/DescText")
  self._hero_content = self:AddComponent(UIBaseContainer, "Root/HeroScroll/Viewport/HeroContent")
  self._hero_content_horizonLayout = self._hero_content.gameObject:GetComponent(typeof(CS.BidirectionalHorizontalLayoutGroup))
  self._reward_can_receive_img = self:AddComponent(UIImage, "Root/Reward/Scroll View/Viewport/BG")
  self._reward_scroll_view = self:AddComponent(UIScrollView, "Root/Reward/Scroll View")
  self._reward_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self._reward_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.hero_name_item1 = self:AddComponent(UIBaseContainer, hero_name_item1_path)
  self.hero_name_item2 = self:AddComponent(UIBaseContainer, hero_name_item2_path)
  self.hero_name_item3 = self:AddComponent(UIBaseContainer, hero_name_item3_path)
  self._hero_name_list = {
    self.hero_name_item1,
    self.hero_name_item2,
    self.hero_name_item3
  }
  self.info_detail1 = self:AddComponent(UIButton, info_detail1_path)
  self.info_detail1:SetOnClick(function()
    self:OnHeroIntroClick(1)
  end)
  self.info_detail2 = self:AddComponent(UIButton, info_detail2_path)
  self.info_detail2:SetOnClick(function()
    self:OnHeroIntroClick(2)
  end)
  self.info_detail3 = self:AddComponent(UIButton, info_detail3_path)
  self.info_detail3:SetOnClick(function()
    self:OnHeroIntroClick(3)
  end)
  self.hero_name1 = self:AddComponent(UITextMeshProUGUIEx, hero_name1_path)
  self.hero_name2 = self:AddComponent(UITextMeshProUGUIEx, hero_name2_path)
  self.hero_name3 = self:AddComponent(UITextMeshProUGUIEx, hero_name3_path)
  self.left_line1 = self:AddComponent(UIImage, left_line1_path)
  self.left_line2 = self:AddComponent(UIImage, left_line2_path)
  self.right_line1 = self:AddComponent(UIImage, right_line1_path)
  self.right_line2 = self:AddComponent(UIImage, right_line2_path)
  self.add_symbol_mid = self:AddComponent(UIImage, add_symbol_mid_path)
  self.add_symbol_left = self:AddComponent(UIImage, add_symbol_left_path)
  self.add_symbol_right = self:AddComponent(UIImage, add_symbol_right_path)
end

function UIHeroTrial:ComponentDestroy()
  self:ClearScroll()
  self:DisposeRequest()
  self._time_txt = nil
  self._reward_scroll_view = nil
  self._intro_btn = nil
  self._desc_txt = nil
  self._reward_can_receive_img = nil
  self.hero_name_item1 = nil
  self.hero_name_item2 = nil
  self.hero_name_item3 = nil
  self.info_detail1 = nil
  self.info_detail2 = nil
  self.info_detail3 = nil
  self.hero_name1 = nil
  self.hero_name2 = nil
  self.hero_name3 = nil
  self.left_line1 = nil
  self.left_line2 = nil
  self.right_line1 = nil
  self.right_line2 = nil
  self.add_symbol_mid = nil
  self.add_symbol_left = nil
  self.add_symbol_right = nil
end

function UIHeroTrial:DataDefine()
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
  
  self.heroModel = {}
  self.heroScriptList = {}
  self.heroSpineLoadRequest = {}
end

function UIHeroTrial:DataDestroy()
  self:SetAllHeroCellDestroy()
end

function UIHeroTrial:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnHeroTrialRewardGet, self.OnGetReward)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.OnRefresh)
  self:AddUIListener(EventId.HeroUpgradeRank, self.SendRequest)
end

function UIHeroTrial:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnHeroTrialRewardGet, self.OnGetReward)
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.OnRefresh)
  self:RemoveUIListener(EventId.HeroUpgradeRank, self.SendRequest)
end

function UIHeroTrial:SetData(activityId)
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.activityId = activityId
  self:SendRequest()
  self:SetConstTxt()
  self:OnRefresh()
end

function UIHeroTrial:OnRefresh()
  self.actDetailInfo = DataCenter.ActivityListDataManager:GetActEventInfo(self.activityId)
  if self.actDetailInfo then
    local stageArr = self.actDetailInfo.stageArr
    self.rewardList = {}
    if not table.IsNullOrEmpty(stageArr) then
      for k, v in pairs(stageArr) do
        if tonumber(v.id) == self.actDetailInfo.heroTrialCurStageId then
          self.curStateInfo = v
          self.rewardList = v.reward
          break
        end
      end
    end
    local stageTemplate = DataCenter.ActivityStageTemplateManager:GetTemplate(self.actDetailInfo.heroTrialCurStageId)
    if self.curStateInfo.state == 2 then
      self._desc_txt:SetLocalText(2000727)
    else
      self._desc_txt:SetLocalText(stageTemplate.stage_des)
    end
    self.showDataList = self.actDetailInfo:GetHeroTrialStageQuests()
    local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if actListData then
      self.actListData = actListData
      self:RefreshTime(actListData)
      self:AddTimer(actListData)
      self:RefreshTitle(actListData)
      self:RefreshBottom()
      self:RefreshHeroes()
      self:RefreshReward()
    end
  end
end

function UIHeroTrial:RefreshHeroes()
  local taskNum = #self.showDataList
  table.walk(self._hero_container_list, function(k, v)
    v:SetActive(true)
  end)
  table.walk(self._hero_name_list, function(k, v)
    v:SetActive(true)
  end)
  for i = taskNum + 1, #self._hero_container_list do
    self._hero_container_list[i]:SetActive(false)
    self._hero_name_list[i]:SetActive(false)
  end
  local heroItemCount = math.min(taskNum, #self._hero_container_list)
  for i = 1, heroItemCount do
    local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(self.showDataList[i])
    local heroId = tonumber(questTemplate.para1)
    local heroScript = self.heroScriptList[heroId]
    if heroScript then
      heroScript:ReInit(self.showDataList[i])
    else
      if self.heroModel[heroId] then
        self:GameObjectDestroy(self.heroModel[heroId])
      end
      self.heroModel[heroId] = self:GameObjectInstantiateAsync(UIAssets.UIHeroTrialHeroItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self._hero_content.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.name = "heroTrialItem" .. i
        local cell = self._hero_content:AddComponent(HeroTrialHeroItem, go.name)
        cell:ReInit(self.showDataList[i])
        self.heroScriptList[heroId] = cell
      end)
    end
    local spineRequest = self.heroSpineLoadRequest[heroId]
    if spineRequest == nil then
      do
        local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(self.showDataList[i])
        local heroId = tonumber(questTemplate.para1)
        local spineRequest = self:ReloadHeroSpine(self._hero_container_list[i], heroId, heroItemCount, i)
        if spineRequest then
          self.heroSpineLoadRequest[heroId] = spineRequest
        end
      end
    end
  end
  for i = 1, heroItemCount do
    self:SetHeroName(self.showDataList[i], self["hero_name" .. i])
  end
  self:RefreshLinesAndAddSymbols(heroItemCount)
  if self._hero_content_horizonLayout then
    if 3 <= heroItemCount then
      self._hero_content_horizonLayout.spacing = 81.9
    else
      self._hero_content_horizonLayout.spacing = 186.61
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._hero_content_horizonLayout.transform)
  end
end

function UIHeroTrial:RefreshLinesAndAddSymbols(heroItemCount)
  self.add_symbol_mid:SetActive(heroItemCount == 2)
  self.add_symbol_left:SetActive(heroItemCount == 3)
  self.add_symbol_right:SetActive(heroItemCount == 3)
  self.left_line1:SetActive(true)
  self.right_line1:SetActive(true)
  self.left_line2:SetActive(false)
  self.right_line2:SetActive(false)
  if 2 <= #self.showDataList then
    local taskValue1 = DataCenter.TaskManager:FindTaskInfo(self.showDataList[1])
    self.left_line2:SetActive(taskValue1.state ~= TaskState.NotExist and taskValue1.state ~= TaskState.NotStart and taskValue1.state ~= TaskState.NoComplete)
    local taskValue2 = DataCenter.TaskManager:FindTaskInfo(self.showDataList[#self.showDataList])
    self.right_line2:SetActive(taskValue2.state ~= TaskState.NotExist and taskValue2.state ~= TaskState.NotStart and taskValue2.state ~= TaskState.NoComplete)
  end
end

function UIHeroTrial:GetHeroDataByQuestId(questId)
  local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(questId)
  local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(tonumber(questTemplate.para1))
  if heroUuid == nil then
    return nil
  end
  return DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
end

function UIHeroTrial:SetHeroName(questId, comTxt)
  local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(questId)
  local heroId = tonumber(questTemplate.para1)
  local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(tonumber(questTemplate.para1))
  if string.IsNullOrEmpty(heroUuid) then
    local type99Items = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_99)
    table.walk(type99Items, function(k, v)
      local itemId = toInt(v.id)
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      local heroIdTemp = toInt(itemTemplate.para2)
      if heroId == heroIdTemp then
        local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroIdTemp)
        comTxt:SetLocalText(heroTemplate.name)
      end
    end)
  else
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    comTxt:SetLocalText(heroData.firstName)
  end
end

function UIHeroTrial:RefreshReward()
  self:ClearScroll()
  self._reward_scroll_view:SetTotalCount(#self.rewardList)
  self._reward_scroll_view:RefillCells()
end

function UIHeroTrial:SetAllHeroCellDestroy()
  self._hero_content:RemoveComponents(HeroTrialHeroItem)
  if self.heroModel ~= nil then
    for k, v in pairs(self.heroModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.heroModel = {}
  end
  self.heroScriptList = {}
end

function UIHeroTrial:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function UIHeroTrial:RefreshTime(actListData)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > actListData.endTime then
    self:DeleteTimer()
    self.actEnd = true
  else
    if actListData:CheckIfIsToEnd() then
      self._time_txt:SetColorRGBA(0.91, 0.26, 0.26, 1)
    else
      self._time_txt:SetColor(WhiteColor)
    end
    self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(actListData.endTime - curTime))
    self.actEnd = false
  end
end

function UIHeroTrial:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIHeroTrial:SetConstTxt()
  self._receive_btn_text:SetLocalText(2000722)
end

function UIHeroTrial:RefreshTitle(actListData)
  self._actName_txt:SetLocalText(actListData.name)
end

function UIHeroTrial:RefreshBottom()
  self:RefreshReceiveBtn()
end

function UIHeroTrial:RefreshReceiveBtn()
  local stageArr = self.actDetailInfo.stageArr
  self.isHighest = self.actDetailInfo.heroTrialCurStageId == tonumber(stageArr[table.count(stageArr)].id) and self.curStateInfo.state == 2
  self._receive_btn:SetActive(not self.isHighest)
  if self.curStateInfo.state == 1 then
    self._receive_btn_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
    self._reward_can_receive_img:SetEnable(true)
  else
    self._receive_btn_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_1.png")
    self._reward_can_receive_img:SetEnable(false)
  end
end

function UIHeroTrial:OnIntroClick()
  UIUtil.ShowIntro(Localization:GetString("302027"), Localization:GetString("2800015"), Localization:GetString(self.actListData.story))
end

function UIHeroTrial:OnReceiveClick()
  if self.curStateInfo.state == 1 then
    SFSNetwork.SendMessage(MsgDefines.HeroExperimentReward, self.activityId)
  elseif self.curStateInfo.state == 0 then
    UIUtil.ShowTipsId(2000723)
  end
end

local function ResetSpineTransform(self, obj, parentObj, heroItemCount, i)
  if not obj then
    return
  end
  local parent = parentObj
  if not parent then
    return
  end
  obj:SetActive(true)
  local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if rectTransform ~= nil then
    rectTransform:SetParent(parent.transform)
    rectTransform:Set_localScale(0.4, 0.4, 1)
    rectTransform:Set_anchorMin(0.5, 1)
    rectTransform:Set_anchorMax(0.5, 1)
    rectTransform.pivot = Vector2.New(0.5, 1)
    rectTransform:SetAsFirstSibling()
    if 3 <= heroItemCount and i == 2 then
      rectTransform:Set_anchoredPosition(0, 100, 0)
    else
      rectTransform:Set_anchoredPosition(0, 0, 0)
    end
  end
end

function UIHeroTrial:ReloadHeroSpine(container, heroId, heroItemCount, i)
  if container == nil or heroId == nil then
    return
  end
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(heroId)
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  if string.IsNullOrEmpty(spinePath) then
    return
  end
  local request = ResourceManager:InstantiateAsync(spinePath)
  request:completed("+", function()
    if request.isError or request.gameObject == nil then
      request = nil
      return
    end
    ResetSpineTransform(self, request.gameObject, container, heroItemCount, i)
  end)
  return request
end

function UIHeroTrial:OnGetReward(rewardList)
  DataCenter.RewardManager:ShowCommonReward(rewardList)
  self:SendRequest()
end

function UIHeroTrial:SendRequest()
  if self.activityId then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.activityId))
  end
end

function UIHeroTrial.GetEventCanRewardCount(id)
  local num = 0
  local actDetailInfo = DataCenter.ActivityListDataManager:GetActEventInfo(id)
  if actDetailInfo then
    local stageArr = actDetailInfo.stageArr
    if not table.IsNullOrEmpty(stageArr) then
      for k, v in pairs(stageArr) do
        if tonumber(v.id) == actDetailInfo.heroTrialCurStageId then
          num = v.state == 1 and 1 or 0
          break
        end
      end
    end
  end
  return num
end

function UIHeroTrial:OnHeroIntroClick(index)
  if self.showDataList[index] == nil then
    return
  end
  local questId = self.showDataList[index]
  local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(questId)
  if questTemplate == nil then
    return
  end
  local heroId = tonumber(questTemplate.para1)
  local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)
  if string.IsNullOrEmpty(heroUuid) then
    local type99Items = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_99)
    table.walk(type99Items, function(k, v)
      local itemId = toInt(v.id)
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      local heroIdTemp = toInt(itemTemplate.para2)
      if heroId == heroIdTemp then
        heroUuid = itemId
      end
    end)
  end
  local arrowData = {
    arrowType = HeroDetailGuideArrowType.Upgrade,
    heroUid = heroUuid
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, {heroUuid}, nil, arrowData)
end

return UIHeroTrial
