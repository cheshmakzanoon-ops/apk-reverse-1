local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SeasonPreviewProgressItem = require("UI.LWSeason3.SeasonPreview.Main.Component.SeasonPreviewProgressItem")
local SeasonPreviewMain = BaseClass("SeasonPreviewMain", base)
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local NO_MASK_LOAD_PATH = "Assets/Main/SeasonRes/S4/Sprites/UI/SeasonPreview/LXY_S4_yure_tu_up2.png"
local MASK_LOAD_PATH = "Assets/Main/SeasonRes/S4/Sprites/UI/SeasonPreview/LXY_S4_yure_tu_up.png"
local infoBtn_path = "Mask/rightTop/InfoBtn"
local rankBtn_path = "Mask/rightTop/RankBtn/rightTopRankBtn"
local timeTxt_path = "Mask/TimeIcon/Time"
local taskTxt_path = "Mask/BottomImg/Task"
local descTxt_path = "Mask/BottomImg/Desc"
local infoImg_path = "Mask/BgMask/InfoImage"
local leftBtn_path = "Mask/LeftBtn"
local rightBtn_path = "Mask/RightBtn"
local openTipTxt_path = "Mask/OpenTipText"
local subTitleTxt_path = "Mask/BottomImg/SubTitle"
local goBtn_path = "GoBtn"
local vfxTrans_path = "Mask/VFX_open"
local bannerImg_path = "Mask/BannerImageTitle/BannerImage"
local animator_path = ""
local progress_path = {
  "Mask/BottomImg/Progress/Progress/SeasonPreviewProgressItem7",
  "Mask/BottomImg/Progress/Progress/SeasonPreviewProgressItem6",
  "Mask/BottomImg/Progress/Progress/SeasonPreviewProgressItem5",
  "Mask/BottomImg/Progress/Progress/SeasonPreviewProgressItem4",
  "Mask/BottomImg/Progress/Progress/SeasonPreviewProgressItem3",
  "Mask/BottomImg/Progress/Progress/SeasonPreviewProgressItem2",
  "Mask/BottomImg/Progress/Progress/SeasonPreviewProgressItem1"
}
local jiaopian_path = "Mask/Eff_ui_S5_preview_change/jiaopian"
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
  self.vfxTrans = self:AddComponent(UIBaseContainer, vfxTrans_path)
  self.bannerImg = self:AddComponent(UIRawImage, bannerImg_path)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.jiaopian = self:AddComponent(UIBaseContainer, jiaopian_path)
  self.progress = {
    self:AddComponent(UIBaseContainer, progress_path[1]),
    self:AddComponent(UIBaseContainer, progress_path[2]),
    self:AddComponent(UIBaseContainer, progress_path[3]),
    self:AddComponent(UIBaseContainer, progress_path[4]),
    self:AddComponent(UIBaseContainer, progress_path[5]),
    self:AddComponent(UIBaseContainer, progress_path[6]),
    self:AddComponent(UIBaseContainer, progress_path[7])
  }
  local success, time = self.animator:PlayAnimationReturnTime("SeasonPreview_open_s5")
  if success then
  end
  self.bannerImg:SetActive(false)
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
  self.vfxTrans = nil
  self.bannerImg = nil
  self.animator = nil
  self.progress = nil
  self.jiaopian = nil
  if self.asset ~= nil then
    self.asset:Release()
    self.asset = nil
  end
end

local function DataDefine(self)
  self.preDataList = {}
  self.isInitAnim = false
end

local function DataDestroy(self)
  self:StopAnimationTimer()
  self.preDataList = {}
  self.isInitAnim = nil
end

function SeasonPreviewMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetSeasonPreviewTaskList, self.OnTaskListUpdateHandle)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

function SeasonPreviewMain:OnRemoveListener()
  self:RemoveUIListener(EventId.GetSeasonPreviewTaskList, self.OnTaskListUpdateHandle)
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

function SeasonPreviewMain:OnTaskListUpdateHandle()
  self.isInitAnim = false
  self:OnTaskListUpdate()
end

function SeasonPreviewMain:OnTaskListUpdate()
  local data = DataCenter.SeasonPreviewManager:GetSelectingData()
  self:RefreshView(data)
end

function SeasonPreviewMain:UpdateImg(staticData, isMask)
  if staticData then
    self.bannerImg:LoadSprite(staticData.background)
    self.bannerImg:SetActive(not isMask)
  end
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
  if data.state > 1 or deltaTime < 0 then
    self.descTxt:SetActive(true)
    self.subTitleTxt:SetActive(true)
    self.openTipTxt:SetActive(false)
    self:UpdateImg(staticData, false)
    if self.isInitAnim == false then
      self:PlayChangeAnim()
      self.isInitAnim = true
    end
  else
    self.descTxt:SetActive(false)
    self.subTitleTxt:SetActive(false)
    self.openTipTxt:SetActive(true)
    self:UpdateOpenTime()
    self:UpdateImg(staticData, true)
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
end

function SeasonPreviewMain:PlayOpenAnim(data)
  local list = CommonUtil.PlayerPrefsGetTable(PREVIEW_ANIM_PLAY_LIST, {})
  local staticData = data:GetStaticData()
  if list[tostring(staticData.id)] then
    return
  end
  list[tostring(staticData.id)] = true
  CommonUtil.PlayerPrefsSetTable(PREVIEW_ANIM_PLAY_LIST, list)
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

function SeasonPreviewMain:StopAnimationTimer()
  if self.animatorTimer ~= nil then
    self.animatorTimer:Stop()
    self.animatorTimer = nil
  end
end

function SeasonPreviewMain:PlayChangeAnim(oldData, oldIndex)
  local todayIndex = DataCenter.SeasonPreviewManager:GetTodayIndex()
  local isOldDataMask
  if oldData then
    isOldDataMask = oldData.state <= 1 and oldIndex == todayIndex
  end
  local curData = DataCenter.SeasonPreviewManager:GetSelectingData()
  if not oldData or todayIndex > DataCenter.SeasonPreviewManager:GetSelectingIndex() then
    if self.vfxRender == nil then
      self.vfxRender = self.jiaopian.gameObject:GetComponent(typeof(CS.UnityEngine.ParticleSystemRenderer))
    end
    if not IsNull(self.vfxRender.material) then
      if self.asset ~= nil then
        self.asset:Release()
        self.asset = nil
      end
      if curData.staticData ~= nil then
        self.asset = Resource:LoadAssetAsync(curData.staticData.background, typeof(CS.UnityEngine.Texture2D))
        
        function self.asset.completed(asset)
          if asset == nil then
            return
          end
          if asset.asset == nil then
            return
          end
          self.vfxRender.material.mainTexture = asset.asset
        end
      end
    end
  end
  if not oldData or isOldDataMask and todayIndex > DataCenter.SeasonPreviewManager:GetSelectingIndex() then
    self:StopAnimationTimer()
    local success, time = self.animator:PlayAnimationReturnTime("SeasonPreview_change_s5")
  elseif DataCenter.SeasonPreviewManager:GetSelectingIndex() == todayIndex and curData and curData.state <= 1 then
    local success, time = self.animator:PlayAnimationReturnTime("SeasonPreview_open_s5")
  end
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
  local oldIndex = DataCenter.SeasonPreviewManager:GetSelectingIndex()
  local oldData = DataCenter.SeasonPreviewManager:GetSelectingData()
  DataCenter.SeasonPreviewManager:SetSelectingIndex(selectingIndex)
  if oldIndex == selectingIndex then
    return
  end
  self:PlayChangeAnim(oldData, oldIndex)
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
