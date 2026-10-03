local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIWestwardExpansion = BaseClass("UIWestwardExpansion", base)
local Localization = CS.GameEntry.Localization
local UICommonRankItem = require("UI.UICommonRank.UICommonRankItem")
local StageState = {
  Past = 1,
  Present = 2,
  Future = 3
}
local MAX_STAGE_NUM = 2
local bg_path = "Mask/Bg"
local name_path = "Mask/LeftTop/Name"
local time_path = "Mask/LeftTop/TimeContent/TimeBg/Time"
local intro_btn_path = "Mask/RightNode/RightTop/IntroBtn"
local btn_guide_path = "Mask/RightNode/RightTop/BtnGuide"
local guide_text_path = "Mask/RightNode/RightTop/BtnGuide/GuideText"
local btn_task_path = "Mask/RightNode/RightTop/BtnTask"
local task_text_path = "Mask/RightNode/RightTop/BtnTask/TaskText"
local red_point_path = "Mask/RightNode/RightTop/BtnTask/RedPoint"
local slider_path = "Mask/LeftNode/Left/slider"
local stage_btn_path = "Mask/LeftNode/Left/StageBtn"
local rank_path = "Mask/Bottom/Rank"
local empty_tip_path = "Mask/Bottom/Rank/emptyTip"
local content_path = "Mask/Bottom/Rank/ScrollView/Viewport/Content"
local btn_go_path = "BtnGo"
local stage_title_path = "Mask/Bottom/Middle/stageTitle"
local stage_time_path = "Mask/Bottom/Middle/stageTime"
local stage_desc_path = "Mask/Bottom/Middle/stageDesc"
local rank_des_path = "Mask/Bottom/Rank/rankTitle/rankDes"
local name_des_path = "Mask/Bottom/Rank/rankTitle/nameDes"
local power_des_path = "Mask/Bottom/Rank/rankTitle/powerDes"

function UIWestwardExpansion:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  local serverId = LuaEntry.Player:GetSelfServerId()
  local pointId = LuaEntry.Player:GetMainWorldPos()
  local zoneId = SceneUtils.GetZoneIdByPosId(pointId, serverId)
end

function UIWestwardExpansion:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWestwardExpansion:ComponentDefine()
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    self:OnClickIntroBtn()
  end)
  self.btn_guide = self:AddComponent(UIButton, btn_guide_path)
  self.btn_guide:SetOnClick(function()
    self:OnClickGuideBtn()
  end)
  self.guide_text = self:AddComponent(UITextMeshProUGUIEx, guide_text_path)
  self.guide_text:SetLocalText(170001)
  self.btn_task = self:AddComponent(UIButton, btn_task_path)
  self.btn_task:SetOnClick(function()
    self:OnClickTaskBtn()
  end)
  self.task_text = self:AddComponent(UITextMeshProUGUIEx, task_text_path)
  self.task_text:SetLocalText(130065)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.slider = self:AddComponent(UIImage, slider_path)
  self.past = {}
  self.head = {}
  self.present = {}
  self.icon = {}
  self.future = {}
  for i = 1, MAX_STAGE_NUM do
    self.past[i] = self:AddComponent(UIImage, "Mask/LeftNode/Left/Stage" .. i .. "/past" .. i)
    self.head[i] = self:AddComponent(UIImage, "Mask/LeftNode/Left/Stage" .. i .. "/past" .. i .. "/mask/head" .. i)
    self.present[i] = self:AddComponent(UIImage, "Mask/LeftNode/Left/Stage" .. i .. "/present" .. i)
    self.icon[i] = self:AddComponent(UIImage, "Mask/LeftNode/Left/Stage" .. i .. "/present" .. i .. "/mask/icon" .. i)
    self.future[i] = self:AddComponent(UIImage, "Mask/LeftNode/Left/Stage" .. i .. "/future" .. i)
  end
  self.stage_btn = self:AddComponent(UIButton, stage_btn_path)
  self.stage_btn:SetOnClick(function()
    self:OnClickStageBtn()
  end)
  self.rank_btn = self:AddComponent(UIButton, "Mask/RightNode/RightTop/BtnRank")
  self.rank_btn:SetOnClick(function()
    self:OnClickRankBtn()
  end)
  self.rank = self:AddComponent(UICanvasGroup, rank_path)
  self.empty_tip = self:AddComponent(UITextMeshProUGUIEx, empty_tip_path)
  self.empty_tip:SetLocalText("371004")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.btn_jump = self:AddComponent(UIButton, btn_go_path)
  self.btn_jump:SetOnClick(function()
    self:OnClickRankBtn()
  end)
  self.stage_title = self:AddComponent(UITextMeshProUGUIEx, stage_title_path)
  self.stage_time = self:AddComponent(UITextMeshProUGUIEx, stage_time_path)
  self.stage_desc = self:AddComponent(UITextMeshProUGUIEx, stage_desc_path)
  self.rank_des = self:AddComponent(UITextMeshProUGUIEx, rank_des_path)
  self.rank_des:SetLocalText("activity_1200043_tips6")
  self.name_des = self:AddComponent(UITextMeshProUGUIEx, name_des_path)
  self.name_des:SetLocalText("activity_1200043_tips7")
  self.power_des = self:AddComponent(UITextMeshProUGUIEx, power_des_path)
  self.power_des:SetLocalText("activity_1200043_tips8")
end

function UIWestwardExpansion:ComponentDestroy()
  self:RemoveRankList()
  if self.bgReq then
    self:GameObjectDestroy(self.bgReq)
    self.bgReq = nil
  end
  self.bg = nil
  self.name = nil
  self.desc = nil
  self.time = nil
  self.intro_btn = nil
  self.btn_guide = nil
  self.guide_text = nil
  self.btn_task = nil
  self.task_text = nil
  self.red_point = nil
  self.instruct1 = nil
  self.instruct2 = nil
  self.instruct3 = nil
  self.instruct4 = nil
  self.slider = nil
  self.past = nil
  self.head = nil
  self.present = nil
  self.icon = nil
  self.future = nil
  self.stage_btn = nil
  self.box = nil
  self.num = nil
  self.instruct = nil
  self.rank = nil
  self.empty_tip = nil
  self.select_content = nil
  self.one_select = nil
  self.one_title = nil
  self.content = nil
  self.box_tip = nil
  self.tip_title = nil
  self.desc1 = nil
  self.desc2 = nil
  self.desc3 = nil
  self.saint_mountain = nil
  self.progress = nil
  self.mount = nil
  self.progress = nil
  self.mount_name = nil
  self.mount_desc = nil
  self.progress_text = nil
  self.stage_title = nil
  self.stage_time = nil
  self.stage_desc = nil
  self.rank_des = nil
  self.name_des = nil
  self.power_des = nil
end

function UIWestwardExpansion:OnEnable()
  base.OnEnable(self)
end

function UIWestwardExpansion:OnDisable()
  base.OnDisable(self)
end

function UIWestwardExpansion:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WestwardExpansionRankRefresh, self.RefreshRankList)
end

function UIWestwardExpansion:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WestwardExpansionRankRefresh, self.RefreshRankList)
end

function UIWestwardExpansion:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.data = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if not self.data then
    return
  end
  DataCenter.WestwardExpansionDataManager:FetchRankData(true)
  self:RefreshTop()
  self:RefreshBottom()
  self:RefreshLeft()
  self:RefreshRight()
end

function UIWestwardExpansion:RefreshTop()
  self.name:SetLocalText(self.data.activityName)
  self:Update1000MS()
end

function UIWestwardExpansion:RefreshRight()
  self.rank_btn:SetActive(DataCenter.WestwardExpansionDataManager:GetStageRankId())
end

function UIWestwardExpansion:RefreshBottom()
  local rankId = DataCenter.WestwardExpansionDataManager:GetStageRankId()
  if rankId then
    self.rank:SetActive(true)
    self:RefreshRankList()
  else
    self.rank:SetActive(false)
  end
end

local LangKey = {
  [1] = "activity_1200043_tips33",
  [2] = "activity_1200043_tips34",
  [3] = "activity_1200043_tips35"
}

function UIWestwardExpansion:RefreshLeft()
  local curStageTemp, stageTempList = DataCenter.WestwardExpansionDataManager:GetStageTemplate()
  if not curStageTemp then
    return
  end
  local curStage = curStageTemp.stage
  self.slider:SetFillAmount((curStage - 1) / (MAX_STAGE_NUM - 1))
  for i = 1, MAX_STAGE_NUM do
    if stageTempList[i] then
      self.head[i]:LoadSprite(stageTempList[i].stage_icon)
      self.icon[i]:LoadSprite(stageTempList[i].stage_icon)
    end
  end
  for i = 1, curStage - 1 do
    self:RefreshStage(i, StageState.Past)
  end
  self:RefreshStage(curStage, StageState.Present)
  for i = curStage + 1, MAX_STAGE_NUM do
    self:RefreshStage(i, StageState.Future)
  end
  self.stage_title:SetLocalText(LangKey[curStage])
end

function UIWestwardExpansion:RefreshStage(index, stageState)
  if stageState == StageState.Past then
    self.past[index]:SetActive(true)
    self.present[index]:SetActive(false)
    self.future[index]:SetActive(false)
  elseif stageState == StageState.Present then
    self.past[index]:SetActive(false)
    self.present[index]:SetActive(true)
    self.future[index]:SetActive(false)
  elseif stageState == StageState.Future then
    self.past[index]:SetActive(false)
    self.present[index]:SetActive(false)
    self.future[index]:SetActive(true)
  end
end

function UIWestwardExpansion:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.data and self.data.endTime then
    local countdown = UITimeManager:GetInstance():MilliSecondToFmtString(self.data.endTime - now)
    self.time:SetText(countdown)
  else
    self.time:SetText("")
  end
  local curStageTemp = DataCenter.WestwardExpansionDataManager:GetStageTemplate()
  if curStageTemp and curStageTemp.endTime then
    if now < curStageTemp.endTime then
      local countdown = UITimeManager:GetInstance():MilliSecondToFmtString(curStageTemp.endTime - now)
      self.stage_time:SetText(countdown)
      self.stage_desc:SetLocalText("activity_1200043_tips31")
    elseif curStageTemp.nextTime then
      local countdown = UITimeManager:GetInstance():MilliSecondToFmtString(curStageTemp.nextTime - now)
      self.stage_time:SetLocalText("activity_1200043_tips9", countdown)
      self.stage_desc:SetLocalText("activity_1200043_tips29")
    else
      self.stage_time:SetText("")
      self.stage_desc:SetLocalText("activity_1200043_tips29")
    end
  else
    self.stage_time:SetText("")
  end
end

function UIWestwardExpansion:OnClickGuideBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWestwardExpansionMap, {anim = true})
end

function UIWestwardExpansion:OnClickIntroBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWestwardExpansionInstruction, {anim = true})
end

function UIWestwardExpansion:OnClickTaskBtn()
end

function UIWestwardExpansion:OnClickStageBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWestwardExpansionMap, {anim = true})
end

function UIWestwardExpansion:OnClickRankBtn()
  local descStr
  local curStageTemp, stageTempList = DataCenter.WestwardExpansionDataManager:GetStageTemplate()
  if curStageTemp and curStageTemp.stage == 2 then
    descStr = Localization:GetString("activity_1200043_rule", curStageTemp.world_monster_level)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTrendsRank, {anim = true}, CommonRankPanelType.WestwardExpansionRank, tonumber(self.activityId), nil, descStr)
end

function UIWestwardExpansion:OnSearchSuccess(param)
  if param and param.pointId and param.uuid then
    GoToUtil.CloseAllWindows()
    GoToUtil.MoveToWorldPointAndOpen(param.pointId, nil, param.uuid)
  end
end

function UIWestwardExpansion:RemoveRankList()
  self.content:RemoveComponents(UICommonRankItem)
  if self.reqs then
    for _, v in pairs(self.reqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.reqs = {}
end

function UIWestwardExpansion:RefreshRankList()
  self:RemoveRankList()
  local stageTemplate = DataCenter.WestwardExpansionDataManager:GetStageTemplate()
  if not stageTemplate then
    return
  end
  local rankId = stageTemplate.rank
  local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, rankId)
  local rankData = DataCenter.WestwardExpansionDataManager:GetRankData()
  if not (rankConfig and rankData and rankData.ranks) or #rankData.ranks == 0 then
    self.empty_tip:SetActive(true)
    return
  end
  self.empty_tip:SetActive(false)
  local list = {}
  local count = math.min(#rankData.ranks, 3)
  for i = 1, count do
    table.insert(list, rankData.ranks[i])
  end
  for i = 1, #list do
    self.reqs[i] = self:GameObjectInstantiateAsync(UIAssets.CommonRankItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "LWSeasonTrendsRankItem" .. i
      item.transform:SetParent(self.content.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.content:AddComponent(UICommonRankItem, item.name)
      obj:SetItemShow(list[i], nil, CommonRankType.PERSONAL)
    end)
  end
end

return UIWestwardExpansion
