local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SeasonPreviewProgressItem = require("UI.LWSeason3.SeasonPreview.Main.Component.SeasonPreviewProgressItem")
local SeasonPreviewMain = BaseClass("SeasonPreviewMain", base)
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local infoBtn_path = "rightTop/InfoBtn"
local rankBtn_path = "rightTop/RankBtn/rightTopRankBtn"
local timeTxt_path = "TimeIcon/Time"
local taskTxt_path = "BottomImg/Task"
local descTxt_path = "BottomImg/Desc"
local infoImg_path = "InfoImage"
local leftBtn_path = "LeftBtn"
local rightBtn_path = "RightBtn"
local openTipTxt_path = "OpenTipText"
local subTitleTxt_path = "BottomImg/SubTitle"
local goBtn_path = "BottomImg/GoBtn"
local render_path = "VFX_open/Eff_ui_S3_preview_dissolve/bg"
local effect1_path = "VFX_open/Eff_ui_S3_preview_dissolve"
local effect2_path = "VFX_open/Eff_ui_S3_blocks_dust"
local vfxTrans_path = "VFX_open"
local lockEffctGo_path = "InfoImage/Eff_ui_S3_preview_lock"
local progress_path = {
  "BottomImg/Progress/Progress/SeasonPreviewProgressItem7",
  "BottomImg/Progress/Progress/SeasonPreviewProgressItem6",
  "BottomImg/Progress/Progress/SeasonPreviewProgressItem5",
  "BottomImg/Progress/Progress/SeasonPreviewProgressItem4",
  "BottomImg/Progress/Progress/SeasonPreviewProgressItem3",
  "BottomImg/Progress/Progress/SeasonPreviewProgressItem2",
  "BottomImg/Progress/Progress/SeasonPreviewProgressItem1"
}
local OneDayTime = 86400000
local PREVIEW_ANIM_PLAY_LIST = "PREVIEW_ANIM_PLAY_LIST"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
  self.timeTxt = self:AddComponent(UIText, timeTxt_path)
  self.taskTxt = self:AddComponent(UIText, taskTxt_path)
  self.descTxt = self:AddComponent(UIText, descTxt_path)
  self.infoImg = self:AddComponent(UIRawImage, infoImg_path)
  self.leftBtn = self:AddComponent(UIButton, leftBtn_path)
  self.rightBtn = self:AddComponent(UIButton, rightBtn_path)
  self.openTipTxt = self:AddComponent(UIText, openTipTxt_path)
  self.subTitleTxt = self:AddComponent(UIText, subTitleTxt_path)
  self.goBtn = self:AddComponent(UIButton, goBtn_path)
  self.render = self:AddComponent(UIBaseContainer, render_path)
  self.vfxTrans = self:AddComponent(UIBaseContainer, vfxTrans_path)
  self.lockEffctGo = self:AddComponent(UIBaseContainer, lockEffctGo_path)
  self.progress = {
    self:AddComponent(UIBaseContainer, progress_path[1]),
    self:AddComponent(UIBaseContainer, progress_path[2]),
    self:AddComponent(UIBaseContainer, progress_path[3]),
    self:AddComponent(UIBaseContainer, progress_path[4]),
    self:AddComponent(UIBaseContainer, progress_path[5]),
    self:AddComponent(UIBaseContainer, progress_path[6]),
    self:AddComponent(UIBaseContainer, progress_path[7])
  }
  self.progressComponent = {}
  for i, v in ipairs(self.progress) do
    self.progressComponent[i] = v:AddComponent(SeasonPreviewProgressItem, v.gameObject)
  end
  self.infoBtn:SetOnClick(function()
    self:OnHelpBtnClick()
  end)
  self.rankBtn:SetOnClick(function()
    self:OnRankBtnClick()
  end)
  self.goBtn:SetOnClick(function()
    self:OnGoBtnClick()
  end)
  self.leftBtn:SetOnClick(function()
    self:OnDayChangeClick(false)
  end)
  self.rightBtn:SetOnClick(function()
    self:OnDayChangeClick(true)
  end)
end

local function ComponentDestroy(self)
  self.infoBtn = nil
  self.rankBtn = nil
  self.timeTxt = nil
  self.taskTxt = nil
  self.descTxt = nil
  self.infoImg = nil
  self.leftBtn = nil
  self.rightBtn = nil
  self.openTipTxt = nil
  self.subTitleTxt = nil
  self.goBtn = nil
  self.render = nil
  self.effect1 = nil
  self.effect2 = nil
  self.vfxTrans = nil
  self.lockEffctGo = nil
  self.progress = nil
end

local function DataDefine(self)
  self.preDataList = {}
end

local function DataDestroy(self)
  self.preDataList = {}
end

function SeasonPreviewMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetSeasonPreviewTaskList, self.OnTaskListUpdate)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

function SeasonPreviewMain:OnRemoveListener()
  self:RemoveUIListener(EventId.GetSeasonPreviewTaskList, self.OnTaskListUpdate)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  base.OnRemoveListener(self)
end

function SeasonPreviewMain:OnPassDay()
  DataCenter.SeasonPreviewManager:UpdateTodayIndex()
  self:OnTaskListUpdate()
end

function SeasonPreviewMain:SetData(activityId)
  base.SetData(self, activityId)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data == nil then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ViewSeasonPreTaskMessage, self.activityId)
  self.activityData = data
end

function SeasonPreviewMain:OnTaskListUpdate()
  local data = DataCenter.SeasonPreviewManager:GetSelectingData()
  self:RefreshView(data)
end

function SeasonPreviewMain:RefreshView(data)
  if data == nil then
    return
  end
  local staticData = data:GetStaticData()
  local format = "<size=36><color=#f97099>(%d/%d)</color></size>"
  if data.num >= staticData.quest_para1 then
    format = "<size=36><color=#00FF00>(%d/%d)</color></size>"
  end
  self.taskTxt:SetLocalText(staticData.quest_description, string.format(format, data.num, staticData.quest_para1))
  self.descTxt:SetLocalText(staticData.event_description)
  local startTime = self.activityData.startTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = staticData.order * OneDayTime - (curTime - startTime)
  self.subTitleTxt:SetLocalText(staticData.event_title)
  if data.state >= 1 or deltaTime < 0 then
    self.descTxt:SetActive(true)
    self.subTitleTxt:SetActive(true)
    self.openTipTxt:SetActive(false)
    self.infoImg:LoadSprite(staticData.background)
  else
    self.descTxt:SetActive(false)
    self.subTitleTxt:SetActive(false)
    self.openTipTxt:SetActive(true)
    self:UpdateOpenTime()
    self.infoImg:LoadSprite(staticData.background_mask)
  end
  local selectingIndex = DataCenter.SeasonPreviewManager:GetSelectingIndex()
  local taskList = DataCenter.SeasonPreviewManager:GetTaskList()
  self.leftBtn:SetActive(selectingIndex ~= 1)
  self.rightBtn:SetActive(selectingIndex ~= #taskList)
  for i, v in ipairs(self.progressComponent) do
    v:SetData(i, function(index)
      self:TryChangeIndex(index)
    end)
  end
  self.vfxTrans:SetActive(false)
  local list = CommonUtil.PlayerPrefsGetTable(PREVIEW_ANIM_PLAY_LIST, {})
  if list[tostring(staticData.id)] then
    self.lockEffctGo:SetActive(false)
    if data.state >= 1 or deltaTime < 0 then
      self.infoImg:LoadSprite(staticData.background)
    else
      self.infoImg:LoadSprite(staticData.background_mask)
    end
  else
    self.infoImg:LoadSprite(staticData.background_mask)
    if data.state >= 1 or deltaTime < 0 then
      self.lockEffctGo:SetActive(true)
      self:PlayOpenAnim(data)
    else
      self.lockEffctGo:SetActive(false)
    end
  end
end

function SeasonPreviewMain:PlayOpenAnim(data)
  local list = CommonUtil.PlayerPrefsGetTable(PREVIEW_ANIM_PLAY_LIST, {})
  local staticData = data:GetStaticData()
  if list[tostring(staticData.id)] then
    return
  end
  list[tostring(staticData.id)] = true
  CommonUtil.PlayerPrefsSetTable(PREVIEW_ANIM_PLAY_LIST, list)
  if self.bgRender == nil then
    self.bgRender = self.render.gameObject:GetComponent(typeof(CS.UnityEngine.ParticleSystemRenderer))
  end
  if not IsNull(self.bgRender.material) then
    self.asset = Resource:LoadAssetAsync(staticData.background, typeof(CS.UnityEngine.Texture2D))
    
    function self.asset.completed(asset)
      if asset == nil then
        return
      end
      if asset.asset == nil then
        return
      end
      self.bgRender.material.mainTexture = asset.asset
    end
  end
  self.vfxTrans:SetActive(true)
end

function SeasonPreviewMain:Update1000MS()
  self:UpdateTotalTime()
  self:UpdateOpenTime()
end

function SeasonPreviewMain:UpdateTotalTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = self.activityData.endTime - curTime
  if 0 < deltaTime then
    local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
    self.timeTxt:SetText(showTime)
  else
    self.timeTxt:SetText("00:00:00")
  end
end

function SeasonPreviewMain:UpdateOpenTime()
  local data = DataCenter.SeasonPreviewManager:GetSelectingData()
  if data == nil then
    return
  end
  local startTime = self.activityData.startTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = data:GetStaticData().order * OneDayTime - (curTime - startTime)
  if 0 < deltaTime then
    local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
    self.openTipTxt:SetText(Localization:GetString("season_s3_season_pre_desc15", showTime))
  else
    self.openTipTxt:SetText(Localization:GetString("season_s3_season_pre_desc15", "00:00:00"))
  end
end

function SeasonPreviewMain:OnHelpBtnClick()
  if self.activityData ~= nil and self.activityData.story ~= nil then
    local msg = Localization:GetString(self.activityData.story)
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end
end

function SeasonPreviewMain:OnRankBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUISeasonPreviewRank, {anim = true}, 1)
end

function SeasonPreviewMain:OnGoBtnClick()
  local data = DataCenter.SeasonPreviewManager:GetSelectingData()
  if data == nil then
    return
  end
  GoToUtil.CloseAllWindows()
  local staticData = data:GetStaticData()
  local template = DataCenter.QuestTemplateManager:GetQuestTemplate(staticData.go_to)
  GoToUtil.GoToByQuestId(template)
end

function SeasonPreviewMain:OnDayChangeClick(isRight)
  local selectingIndex = DataCenter.SeasonPreviewManager:GetSelectingIndex()
  local indexTryShow = isRight and selectingIndex + 1 or selectingIndex - 1
  self:TryChangeIndex(indexTryShow)
end

function SeasonPreviewMain:TryChangeIndex(selectingIndex)
  if selectingIndex < 1 then
    return
  end
  local todayIndex = DataCenter.SeasonPreviewManager:GetTodayIndex()
  local taskList = DataCenter.SeasonPreviewManager:GetTaskList()
  if selectingIndex > todayIndex then
    local data = taskList[selectingIndex - 1]
    if data == nil then
      return
    end
    local startTime = self.activityData.startTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = data:GetStaticData().order * OneDayTime - (curTime - startTime)
    deltaTime = math.max(deltaTime, 0)
    local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
    UIUtil.ShowTips(Localization:GetString("season_sever_intrusion_021", showTime))
    return
  end
  DataCenter.SeasonPreviewManager:SetSelectingIndex(selectingIndex)
  self:OnTaskListUpdate()
end

SeasonPreviewMain.OnCreate = OnCreate
SeasonPreviewMain.OnDestroy = OnDestroy
SeasonPreviewMain.OnEnable = OnEnable
SeasonPreviewMain.OnDisable = OnDisable
SeasonPreviewMain.ComponentDefine = ComponentDefine
SeasonPreviewMain.ComponentDestroy = ComponentDestroy
SeasonPreviewMain.DataDefine = DataDefine
SeasonPreviewMain.DataDestroy = DataDestroy
return SeasonPreviewMain
