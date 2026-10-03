local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIBloodyNightMain = BaseClass("UIBloodyNightMain", base)
local Localization = CS.GameEntry.Localization
local UIBloodyMoon = require("UI.UIBloodyNight.UIBloodyMoon")
local LWSeasonTrendsRankItem = require("UI.LWSeason.LWSeasonTrendsRank.Component.LWSeasonTrendsRankItem")
local StageState = {
  Past = 1,
  Present = 2,
  Future = 3
}
local MAX_STAGE_NUM = 4
local bg_path = "Mask/Bg"
local bloody_moon_path = "Mask/Bottom/BloodyMoon"
local name_path = "Mask/LeftTop/Name"
local desc_path = "Mask/LeftTop/Desc"
local time_path = "Mask/LeftTop/TimeContent/Time"
local intro_btn_path = "Mask/RightNode/RightTop/IntroBtn"
local btn_guide_path = "Mask/RightNode/RightTop/BtnGuide"
local guide_text_path = "Mask/RightNode/RightTop/BtnGuide/GuideText"
local btn_task_path = "Mask/RightNode/RightTop/BtnTask"
local task_text_path = "Mask/RightNode/RightTop/BtnTask/TaskText"
local red_point_path = "Mask/RightNode/RightTop/BtnTask/RedPoint"
local instruct1_path = "Mask/Bottom/Instruct/Viewport/Content/instruct1"
local instruct2_path = "Mask/Bottom/Instruct/Viewport/Content/instruct2"
local instruct3_path = "Mask/Bottom/Instruct/Viewport/Content/instruct3"
local instruct4_path = "Mask/Bottom/Instruct/Viewport/Content/instruct4"
local slider_path = "Mask/LeftNode/Left/slider"
local stage_btn_path = "Mask/LeftNode/Left/StageBtn"
local box_path = "Mask/Bottom/Box"
local box_img_path = "Mask/Bottom/Box/img"
local num_path = "Mask/Bottom/Box/num"
local instruct_path = "Mask/Bottom/Instruct"
local rank_path = "Mask/Bottom/Rank"
local empty_tip_path = "Mask/Bottom/Rank/emptyTip"
local select_content_path = "Mask/Bottom/Rank/selectContent"
local one_select_path = "Mask/Bottom/Rank/OneSelect"
local one_title_path = "Mask/Bottom/Rank/OneSelect/OneTitle"
local content_path = "Mask/Bottom/Rank/ScrollView/Viewport/Content"
local box_tip_path = "Mask/BoxTip"
local toggle1_path = "Mask/Bottom/Rank/selectContent/Toggle1"
local checkmark_text_toggle1_path = "Mask/Bottom/Rank/selectContent/Toggle1/CheckmarkTextToggle1"
local toggle2_path = "Mask/Bottom/Rank/selectContent/Toggle2"
local checkmark_text_toggle2_path = "Mask/Bottom/Rank/selectContent/Toggle2/CheckmarkTextToggle2"
local count_path = "Mask/Bottom/Rank/count"
local backmark_text_toggle1_path = "Mask/Bottom/Rank/selectContent/Toggle1/BackmarkTextToggle1"
local backmark_text_toggle2_path = "Mask/Bottom/Rank/selectContent/Toggle2/BackmarkTextToggle2"
local tip_title_path = "Mask/BoxTip/bg/TipTitle"
local desc1_path = "Mask/BoxTip/bg/desc1"
local desc2_path = "Mask/BoxTip/bg/desc2"
local desc3_path = "Mask/BoxTip/bg/desc3"
local eff_ui_s4_u_i_bloody_night_red_path = "Mask/Eff_ui_S4_UIBloodyNight/Eff_ui_S4_UIBloodyNight_red"
local eff_ui_s4_u_i_bloody_night_blue_path = "Mask/Eff_ui_S4_UIBloodyNight/Eff_ui_S4_UIBloodyNight_blue"
local btn_go_path = "BtnGo"
local saint_mountain_path = "Mask/Bottom/SaintMountain"
local mount_path = "Mask/Bottom/SaintMountain/Mount"
local progress_path = "Mask/Bottom/SaintMountain/Mount/Progress"
local mount_name_path = "Mask/Bottom/SaintMountain/Mount/MountName"
local mount_desc_path = "Mask/Bottom/SaintMountain/MountDesc"
local progress_text_path = "Mask/Bottom/SaintMountain/Mount/ProgressText"

function UIBloodyNightMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIBloodyNightMain:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBloodyNightMain:ComponentDefine()
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.bloody_moon = self:AddComponent(UIBloodyMoon, bloody_moon_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
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
  self.instruct1 = self:AddComponent(UITextMeshProUGUIEx, instruct1_path)
  self.instruct2 = self:AddComponent(UITextMeshProUGUIEx, instruct2_path)
  self.instruct3 = self:AddComponent(UITextMeshProUGUIEx, instruct3_path)
  self.instruct4 = self:AddComponent(UITextMeshProUGUIEx, instruct4_path)
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
  self.box = self:AddComponent(UIButton, box_path)
  self.box_img = self:AddComponent(UIBaseComponent, box_img_path)
  self.box:SetOnClick(function()
    self:OnClickBox()
  end)
  self.box:SetSafeClickMode(true)
  self.num = self:AddComponent(UITextMeshProUGUIEx, num_path)
  self.instruct = self:AddComponent(UIScrollRect, instruct_path)
  self.rank = self:AddComponent(UICanvasGroup, rank_path)
  self.empty_tip = self:AddComponent(UITextMeshProUGUIEx, empty_tip_path)
  self.empty_tip:SetLocalText("371004")
  self.select_content = self:AddComponent(UIBaseContainer, select_content_path)
  self.one_select = self:AddComponent(UIImage, one_select_path)
  self.one_title = self:AddComponent(UITextMeshProUGUIEx, one_title_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.box_tip = self:AddComponent(UIButton, box_tip_path)
  self.box_tip:SetActive(false)
  self.box_tip:SetOnClick(function()
    self.box_tip:SetActive(false)
  end)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle1:SetIsOn(true)
  self.curTab = nil
  self.toggle1:SetOnValueChanged(function(bool)
    if bool then
      self:OnClickToggle(1)
    end
  end)
  self.checkmark_text_toggle1 = self:AddComponent(UITextMeshProUGUIEx, checkmark_text_toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle2:SetOnValueChanged(function(bool)
    if bool then
      self:OnClickToggle(2)
    end
  end)
  self.checkmark_text_toggle2 = self:AddComponent(UITextMeshProUGUIEx, checkmark_text_toggle2_path)
  self.count = self:AddComponent(UITextMeshProUGUIEx, count_path)
  self.count:SetText("")
  self.backmark_text_toggle1 = self:AddComponent(UITextMeshProUGUIEx, backmark_text_toggle1_path)
  self.backmark_text_toggle2 = self:AddComponent(UITextMeshProUGUIEx, backmark_text_toggle2_path)
  self.tip_title = self:AddComponent(UITextMeshProUGUIEx, tip_title_path)
  self.tip_title:SetLocalText()
  self.desc1 = self:AddComponent(UITextMeshProUGUIEx, desc1_path)
  self.desc1:SetLocalText("season_s4_activity_1200009_desc38")
  self.desc2 = self:AddComponent(UITextMeshProUGUIEx, desc2_path)
  self.desc2:SetLocalText("season_s4_activity_1200009_desc39")
  self.desc3 = self:AddComponent(UITextMeshProUGUIEx, desc3_path)
  self.desc3:SetLocalText("season_s4_activity_1200009_desc40")
  self.eff_ui_s4_u_i_bloody_night_red = self:AddComponent(UIBaseContainer, eff_ui_s4_u_i_bloody_night_red_path)
  self.eff_ui_s4_u_i_bloody_night_blue = self:AddComponent(UIBaseContainer, eff_ui_s4_u_i_bloody_night_blue_path)
  self.btn_jump = self:AddComponent(UIButton, btn_go_path)
  self.btn_jump:SetOnClick(function()
    self:OnClickJumpBtn()
  end)
  self.saint_mountain = self:AddComponent(UIImage, saint_mountain_path)
  self.mount = self:AddComponent(UIImage, mount_path)
  self.progress = self:AddComponent(UIImage, progress_path)
  self.mount_name = self:AddComponent(UITextMeshProUGUIEx, mount_name_path)
  self.mount_name:OnPointerClick(function(eventData)
    UIUtil.UseJumpLink(self.mount_name, eventData)
  end)
  self.mount_desc = self:AddComponent(UITextMeshProUGUIEx, mount_desc_path)
  self.progress_text = self:AddComponent(UITextMeshProUGUIEx, progress_text_path)
end

function UIBloodyNightMain:ComponentDestroy()
  self:RemoveRankList()
  if self.bgReq then
    self:GameObjectDestroy(self.bgReq)
    self.bgReq = nil
  end
  self.bg = nil
  self.bloody_moon = nil
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
  self.toggle1 = nil
  self.checkmark_text_toggle1 = nil
  self.toggle2 = nil
  self.checkmark_text_toggle2 = nil
  self.count = nil
  self.backmark_text_toggle1 = nil
  self.backmark_text_toggle2 = nil
  self.tip_title = nil
  self.desc1 = nil
  self.desc2 = nil
  self.desc3 = nil
  self.eff_ui_s4_u_i_bloody_night_red = nil
  self.eff_ui_s4_u_i_bloody_night_blue = nil
  self.saint_mountain = nil
  self.progress = nil
  self.mount = nil
  self.progress = nil
  self.mount_name = nil
  self.mount_desc = nil
  self.progress_text = nil
end

function UIBloodyNightMain:OnEnable()
  base.OnEnable(self)
end

function UIBloodyNightMain:OnDisable()
  base.OnDisable(self)
end

function UIBloodyNightMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BloodyNightActivityRefresh, self.OnBloodyNightActivityRefresh)
  self:AddUIListener(EventId.OnBloodyNightTaskRedRefresh, self.RefreshAwardRedPoint)
  self:AddUIListener(EventId.BloodyNightRankRefresh, self.RefreshBloodyNightRankInfo)
  self:AddUIListener(EventId.WhistleBoxNumRefresh, self.RefreshBoxCount)
  self:AddUIListener(EventId.END_SEARCH, self.OnSearchSuccess)
  self:AddUIListener(EventId.SearchMonsterFailed, self.OnSearchFailed)
  self:AddUIListener(EventId.SaintMountainProgressRefresh, self.RefreshBottom)
end

function UIBloodyNightMain:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.BloodyNightActivityRefresh, self.OnBloodyNightActivityRefresh)
  self:RemoveUIListener(EventId.OnBloodyNightTaskRedRefresh, self.RefreshAwardRedPoint)
  self:RemoveUIListener(EventId.BloodyNightRankRefresh, self.RefreshBloodyNightRankInfo)
  self:RemoveUIListener(EventId.WhistleBoxNumRefresh, self.RefreshBoxCount)
  self:RemoveUIListener(EventId.END_SEARCH, self.OnSearchSuccess)
  self:RemoveUIListener(EventId.SearchMonsterFailed, self.OnSearchFailed)
  self:RemoveUIListener(EventId.SaintMountainProgressRefresh, self.RefreshBottom)
end

function UIBloodyNightMain:SetData(activityId)
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
  local stageTemp = DataCenter.BloodyNightDataManager:GetStageTemplate(LuaEntry.Player:GetSelfServerId())
  if stageTemp and stageTemp.blood_night_switch then
    SFSNetwork.SendMessage(MsgDefines.BloodNightCloseScoreView, LuaEntry.Player:GetSelfServerId())
  end
  self:RefreshTop()
  self:RefreshBottom()
  self:RefreshLeft()
  self:RefreshRight()
end

function UIBloodyNightMain:OnBloodyNightActivityRefresh(serverId)
  if not self.data then
    return
  end
  if serverId == LuaEntry.Player:GetSelfServerId() then
    self:RefreshTop()
    self:RefreshBottom()
    self:RefreshLeft()
    self:RefreshRight()
  end
end

function UIBloodyNightMain:RefreshTop()
  if self.bgReq then
    self:GameObjectDestroy(self.bgReq)
    self.bgReq = nil
  end
  self.name:SetLocalText(self.data.activityName)
  local stageTemp = DataCenter.BloodyNightDataManager:GetStageTemplate(LuaEntry.Player:GetSelfServerId())
  if stageTemp then
    self.desc:SetLocalText(stageTemp.stage_name)
    if not DataCenter.BloodyNightDataManager:IsDawn() then
      local prefabPath = SeasonUtil.GetNewPrefabPathInBloodyNight(stageTemp.stage_bg)
      self.bgReq = self:GameObjectInstantiateAsync(prefabPath, function(request)
        if request.isError then
          return
        end
        local transform = request.gameObject.transform
        transform:SetParent(self.bg.transform)
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        transform:Set_anchoredPosition(0, 0, 0)
      end)
    end
  else
    self.desc:SetText("")
  end
  self:Update1000MS()
end

function UIBloodyNightMain:RefreshRight()
  self.rank_btn:SetActive(DataCenter.BloodyNightDataManager:GetStageRankCfgIdList())
  self:RefreshAwardRedPoint()
end

function UIBloodyNightMain:RefreshBottom()
  self.bloody_moon:Refresh()
  local state, bnTemplate = DataCenter.BloodyNightDataManager:GetBloodyNightState()
  local rankIdList = DataCenter.BloodyNightDataManager:GetStageRankCfgIdList()
  if rankIdList and state ~= BloodyNightState.Silent then
    self.rank:SetActive(true)
    self.instruct:SetActive(false)
    self:RefreshRank()
  elseif bnTemplate then
    self.rank:SetActive(false)
    self.instruct:SetActive(true)
    self:RefreshInstruct(bnTemplate)
  else
    self.rank:SetActive(false)
    self.instruct:SetActive(false)
  end
  self.eff_ui_s4_u_i_bloody_night_red:SetActive(state == BloodyNightState.Bloody)
  self.eff_ui_s4_u_i_bloody_night_blue:SetActive(state == BloodyNightState.Silent)
  if state == BloodyNightState.Bloody and bnTemplate and bnTemplate.running_boss_switch then
    self.box:SetActive(true)
    self:RefreshBoxCount()
    if self.view.param then
      DataCenter.ArrowManager:ShowArrow({
        positionType = PositionType.Screen,
        position = self.box_img.transform.position
      })
    end
  else
    self.box:SetActive(false)
  end
  local stageTemp = DataCenter.BloodyNightDataManager:GetStageTemplate(LuaEntry.Player:GetSelfServerId())
  self.btn_jump:SetActive(state == BloodyNightState.Bloody and stageTemp and (stageTemp.stage == 1 or stageTemp.stage == 2 or stageTemp.stage == 3))
  if stageTemp and stageTemp.blood_night_switch then
    if state == BloodyNightState.Bloody then
      self.bloody_moon:SetActive(false)
      self.saint_mountain:SetActive(true)
      self.mount:SetActive(true)
      local cur, max = DataCenter.BloodyNightDataManager:GetSaintMountainProgress(LuaEntry.Player:GetSelfServerId())
      self.progress_text:SetText(Localization:GetString("season_s4_activity_1200009_desc45") .. string.percentage(cur, max, 2))
      self.progress:SetFillAmount(cur / max)
      local fuji = DataCenter.AllianceCityTemplateManager:GetCityByType(WorldAllianceCityType.Mountain, LuaEntry.Player:GetSourceServerId())
      if fuji then
        self.mount_name:SetText(UIUtil.MakeJumpLink(fuji:GetPointId(), LuaEntry.Player:GetSourceServerId(), 0, Localization:GetString(fuji.name)))
      else
        self.mount_name:SetText("")
      end
      self.mount_desc:SetLocalText("season_s4_activity_1200009_desc43")
    elseif state == BloodyNightState.Silent then
      self.saint_mountain:SetActive(false)
    elseif state == BloodyNightState.None then
      self.saint_mountain:SetActive(true)
      self.mount:SetActive(false)
      self.mount_desc:SetLocalText("season_s4_activity_1200009_desc48")
    end
  else
    self.saint_mountain:SetActive(false)
  end
end

function UIBloodyNightMain:RefreshInstruct(bnTemplate)
  if bnTemplate then
    local desc = bnTemplate.night_desc
    for i = 1, 4 do
      if desc[i] then
        self["instruct" .. i]:SetLocalText(desc[i])
        self["instruct" .. i]:SetActive(true)
      else
        self["instruct" .. i]:SetActive(false)
      end
    end
  end
end

function UIBloodyNightMain:RefreshLeft()
  local curStageTemp, stageTempList = DataCenter.BloodyNightDataManager:GetStageTemplate(LuaEntry.Player:GetSelfServerId())
  if not curStageTemp then
    return
  end
  local curStage = curStageTemp.stage
  self.slider:SetFillAmount((curStage - 1) / (MAX_STAGE_NUM - 1))
  for i = 1, MAX_STAGE_NUM do
    self.head[i]:LoadSprite(stageTempList[i].stage_icon)
    self.icon[i]:LoadSprite(stageTempList[i].stage_icon)
  end
  for i = 1, curStage - 1 do
    self:RefreshStage(i, StageState.Past)
  end
  self:RefreshStage(curStage, StageState.Present)
  for i = curStage + 1, MAX_STAGE_NUM do
    self:RefreshStage(i, StageState.Future)
  end
end

function UIBloodyNightMain:RefreshStage(index, stageState)
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

function UIBloodyNightMain:RefreshAwardRedPoint()
  self.red_point:SetActive(DataCenter.BloodyNightDataManager:GetCanReceive())
end

function UIBloodyNightMain:RefreshBoxCount()
  self.num:SetText(DataCenter.MonsterManager:GetWhistleRewardNum())
end

function UIBloodyNightMain:Update1000MS()
  local endTime = DataCenter.BloodyNightDataManager:GetStageEndTime()
  if not endTime then
    self.time:SetText("")
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local countdown = UITimeManager:GetInstance():MilliSecondToFmtString(endTime - now)
  self.time:SetText(countdown)
end

function UIBloodyNightMain:OnClickGuideBtn()
  local actData = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.BloodyNight.Type)
  if actData then
    local param = {}
    param.howToPlayList = actData[1].howtoplay
    param.story = actData[1].story
    param.defaultTitle = actData[1].name
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
  end
end

function UIBloodyNightMain:OnClickIntroBtn()
  local param = {}
  param.activityRulesStr = Localization:GetString(self.data.story)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UIBloodyNightMain:OnClickTaskBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBloodyNightReward, {anim = true})
end

function UIBloodyNightMain:OnClickStageBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBloodyNightStageList)
end

function UIBloodyNightMain:OnClickRankBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTrendsRank, CommonRankPanelType.BloodyNightRank, self.activityId)
end

function UIBloodyNightMain:OnClickBox()
  local count = DataCenter.MonsterManager:GetWhistleRewardNum()
  if 0 < count then
    DataCenter.MonsterManager:ClaimWhistleBoxReward()
  else
    self.box_tip:SetActive(true)
  end
end

function UIBloodyNightMain:OnClickJumpBtn()
  local stageTemp = DataCenter.BloodyNightDataManager:GetStageTemplate(LuaEntry.Player:GetSelfServerId())
  if not stageTemp then
    return
  end
  local stage = stageTemp.stage
  if stage == 1 then
    SceneUtils.ChangeToWorld(function()
      if not IsNull(CS.SceneManager.World) then
        CS.SceneManager.World:SetTouchInputControllerEnable(false)
      end
      GoToUtil.GotoOpenViewOpenOptions(UIWindowNames.UISearch, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide,
        onFinish = function()
          if not IsNull(CS.SceneManager.World) then
            CS.SceneManager.World:SetTouchInputControllerEnable(true)
          end
        end
      }, UISearchType.Monster)
    end)
  elseif stage == 2 then
    SFSNetwork.SendMessage(MsgDefines.FindNearMonster, WorldMonsterSpecialType.FlowerBoss)
  elseif stage == 3 then
    SFSNetwork.SendMessage(MsgDefines.FindNearMonster, WorldMonsterSpecialType.S4RunningBoss)
  elseif stage == 4 then
    local fuji = DataCenter.AllianceCityTemplateManager:GetCityByType(WorldAllianceCityType.Mountain, LuaEntry.Player:GetSourceServerId())
    if fuji then
      local pos = SceneUtils.TileToWorld(fuji.pos)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, LuaEntry.Player:GetSourceServerId())
    end
  end
end

function UIBloodyNightMain:OnSearchSuccess(param)
  if param and param.pointId and param.uuid then
    GoToUtil.CloseAllWindows()
    GoToUtil.MoveToWorldPointAndOpen(param.pointId, nil, param.uuid)
  end
end

function UIBloodyNightMain:OnSearchFailed(param)
  if param == WorldMonsterSpecialType.FlowerBoss then
    UIUtil.ShowTipsId("season_s4_activity_1200011_desc65")
  elseif param == WorldMonsterSpecialType.S4RunningBoss then
    UIUtil.ShowTipsId("season_s4_activity_1200011_desc66")
  end
end

function UIBloodyNightMain:RemoveRankList()
  self.content:RemoveComponents(LWSeasonTrendsRankItem)
  if self.reqs then
    for _, v in pairs(self.reqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.reqs = {}
end

function UIBloodyNightMain:RefreshRankList()
  self:RemoveRankList()
  local rankId = self:Tab2RankId(self.curTab)
  local rankData = DataCenter.BloodyNightDataManager:GetRankData(rankId)
  local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, rankId)
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
  local showList = {}
  for rank, v in ipairs(list) do
    local oneData = self:ParseBloodyNightData(v, rankConfig.rank_type == 2, rank)
    table.insert(showList, oneData)
  end
  for i = 1, #showList do
    self.reqs[i] = self:GameObjectInstantiateAsync(UIAssets.LWSeasonTrendsRankItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "LWSeasonTrendsRankItem" .. i
      item.transform:SetParent(self.content.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.content:AddComponent(LWSeasonTrendsRankItem, item.name)
      obj:SetItemShow(1, showList[i], false)
    end)
  end
end

function UIBloodyNightMain:OnClickToggle(tabType)
  if tabType == self.curTab then
    return
  end
  self.curTab = tabType
  DataCenter.BloodyNightDataManager:FetchRankData(self:Tab2RankId(tabType))
  if tabType == 1 then
    self.checkmark_text_toggle1:SetActive(true)
    self.checkmark_text_toggle2:SetActive(false)
  else
    self.checkmark_text_toggle1:SetActive(false)
    self.checkmark_text_toggle2:SetActive(true)
  end
  self:RefreshRankList()
end

function UIBloodyNightMain:RefreshRank()
  local rankIdList = DataCenter.BloodyNightDataManager:GetStageRankCfgIdList()
  if self.curTab == nil then
    self:OnClickToggle(1)
  end
  if rankIdList[2] then
    self.select_content:SetActive(true)
    self.one_select:SetActive(false)
    for i = 1, 2 do
      local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, rankIdList[i])
      if rankConfig then
        self["backmark_text_toggle" .. i]:SetLocalText(rankConfig.name)
        self["checkmark_text_toggle" .. i]:SetLocalText(rankConfig.name)
      end
    end
  else
    self.select_content:SetActive(false)
    self.one_select:SetActive(true)
    local rankConfig = LocalController:instance():getLine(TableName.LW_Season_rank, rankIdList[1])
    self.one_title:SetLocalText(rankConfig.name)
  end
end

function UIBloodyNightMain:RefreshBloodyNightRankInfo(rankId)
  if self:Tab2RankId(self.curTab) == rankId then
    self:RefreshRankList()
  end
end

function UIBloodyNightMain:Tab2RankId(tab)
  local rankIdList = DataCenter.BloodyNightDataManager:GetStageRankCfgIdList()
  return rankIdList and rankIdList[tab]
end

local CommonRankItemShow = {
  type = CommonRankPanelType.DEFAULT,
  isAlliance = false,
  uid = "",
  firstName = "",
  secondName = "",
  rank = -1,
  power = "",
  allianceName = "",
  icon = ""
}
local OneData = DataClass("OneData", CommonRankItemShow)

function UIBloodyNightMain:ParseBloodyNightData(item, isAlliance, rank)
  local oneData = OneData.New()
  oneData.isAlliance = isAlliance
  oneData.type = CommonRankPanelType.BloodyNightRank
  if item ~= nil then
    oneData.uid = item.uid
    oneData.rank = rank
    oneData.serverId = item.srcServer
    oneData.power = string.GetFormattedSeperatorNum(item.score or 0)
    if isAlliance then
      oneData.allianceName = item.allianceName
      oneData.firstName = UIUtil.FormatAllianceAndName(item.abbr, item.allianceName)
    else
      oneData.firstName = UIUtil.FormatAllianceAndName(item.abbr, item.name, item.uid)
      oneData.pic = item.pic
      oneData.picVer = item.picver
      oneData.headFrame = DataCenter.DecorationDataManager:GetHeadFrame(item.headSkinId, item.headSkinET)
    end
  else
    oneData.uid = ""
    oneData.firstName = "-"
    oneData.rank = "-"
    oneData.power = 0
  end
  return oneData
end

return UIBloodyNightMain
