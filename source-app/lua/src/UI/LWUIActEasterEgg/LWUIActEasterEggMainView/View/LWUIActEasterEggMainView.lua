local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LWUIActEasterEggMainView = BaseClass("LWUIActEasterEggMainView", base)
local UIModelView = require("Framework.UI.Component.UIModelView")
local M = LWUIActEasterEggMainView
local scenePrefabPath = "Assets/Main/ActivityRes/2025EasterMod/Prefabs/Model/Caidanqiyuji.prefab"
local sceneEggCount = 6
local Localization = CS.GameEntry.Localization

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.ActEasterEggManager:CheckFirstEnterActivity()
end

function M:OnDestroy()
  self:StopDelayHookTimer()
  self:StopRedDotTimer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
  self:SetBtnEnable(true)
  DataCenter.ActEasterEggManager:SetIsPlayingHook(false)
  self:OnReceiveUnpackEggs()
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:ComponentDefine()
  self.textRemainTime = self:AddComponent(UITextMeshProUGUIEx, "Root/rect/TopArea/BaseInfo/RemainTimeContent/RemainTimeText")
  self.textTxtActName = self:AddComponent(UITextMeshProUGUIEx, "Root/rect/TopArea/BaseInfo/Txt_ActName")
  self.btnTask = self:AddComponent(UIButton, "Root/rect/TopArea/BtnNode/TaskBtn")
  self.btnTask:SetOnClick(function()
    self:OnBtnTaskClick()
  end)
  self.textTaskBtn = self:AddComponent(UITextMeshProUGUIEx, "Root/rect/TopArea/BtnNode/TaskBtn/TaskBtnText")
  self.btnReward = self:AddComponent(UIButton, "Root/rect/TopArea/BtnNode/RewardBtn")
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textRewardBtn = self:AddComponent(UITextMeshProUGUIEx, "Root/rect/TopArea/BtnNode/RewardBtn/RewardBtnText")
  self.btnHotEgg = self:AddComponent(UIButton, "Root/rect/TopArea/BtnNode/HotEggBtn")
  self.btnHotEgg:SetOnClick(function()
    self:OnBtnHotEggClick()
  end)
  self.textHotEggBtn = self:AddComponent(UITextMeshProUGUIEx, "Root/rect/TopArea/BtnNode/HotEggBtn/HotEggBtnText")
  self.btnThrow = self:AddComponent(UIButton, "Root/rect/MiddleArea/ThrowBtn")
  self.btnThrow:SetOnClick(function()
    self:OnBtnThrowClick()
  end)
  self.textThrowBtn = self:AddComponent(UITextMeshProUGUIEx, "Root/rect/MiddleArea/ThrowBtn/ThrowBtnText")
  self.btnAmazingEgg = self:AddComponent(UIButton, "Root/rect/TopArea/BtnNode/AmazingEggBtn")
  self.btnAmazingEgg:SetOnClick(function()
    self:OnBtnAmazingEggClick()
  end)
  self.btnGetOne = self:AddComponent(UIButton, "Root/rect/MiddleArea/GetOneBtn")
  self.btnGetOne:SetOnClick(function()
    self:OnBtnGetOneClick()
  end)
  self.textItemNum = self:AddComponent(UITextMeshProUGUIEx, "Root/rect/TopArea/BaseInfo/Item/ItemNum")
  self.btnAdd = self:AddComponent(UIButton, "Root/rect/TopArea/BaseInfo/Item/AddBtn")
  self.btnAdd:SetOnClick(function()
    self:OnBtnAddClick()
  end)
  self.textGetOneBtn = self:AddComponent(UITextMeshProUGUIEx, "Root/rect/MiddleArea/GetOneBtn/LW_Btn_Common_New_Base/GetOneBtnText")
  self.btnMyEgg = self:AddComponent(UIButton, "Root/rect/MiddleArea/MyEggButton")
  self.btnMyEgg:SetOnClick(function()
    self:OnClickMyEgg()
  end)
  self.textMyEgg = self:AddComponent(UITextMeshProUGUIEx, "Root/rect/MiddleArea/MyEggButton/MyEggText")
  self.compEggBtnNode = self:AddComponent(UIBaseContainer, "Root/rect/MiddleArea/EggBtnNode")
  self.compRTSceneNode = self:AddComponent(UIBaseContainer, "RTSceneBg/RTSceneNode")
  self.btnAutoTranslate = self:AddComponent(UIButton, "AutoTranslate/AutoTranslateBtn")
  self.btnAutoTranslate:SetOnClick(function()
    self:OnBtnAutoTranslateClick()
  end)
  self.autoTranslateSelect = self:AddComponent(UIBaseContainer, "AutoTranslate/AutoTranslateBtn/AutoTranslateSelect")
  self.textAutoTranslateBtnTip = self:AddComponent(UITextMeshProUGUIEx, "AutoTranslate/AutoTranslateBtnTip")
  self.rawImgRTSceneBg = self:AddComponent(UIModelView, "RTSceneBg", true)
  self.btnAmazingEgg:SetActive(false)
  self.eggBtnList = {}
  for i = 1, sceneEggCount do
    local path = "Root/rect/MiddleArea/EggBtnNode/EggBtn" .. i
    local btn = self:AddComponent(UIButton, path)
    btn:SetOnClick(function()
      self:OnBtnEggBtnClick(i)
    end)
    table.insert(self.eggBtnList, btn)
  end
  self.textTxtActName:SetLocalText("activity_name_99144")
  self.textTaskBtn:SetLocalText("activity_99144_ui_7")
  self.textRewardBtn:SetLocalText("activity_99144_ui_8")
  self.textHotEggBtn:SetLocalText("activity_99144_ui_9")
  self.textThrowBtn:SetLocalText("activity_99144_ui_11")
  self.textGetOneBtn:SetLocalText("activity_99144_ui_12")
  self.textAutoTranslateBtnTip:SetLocalText("activity_99144_ui_61")
  self.introBtn = self:AddComponent(UIButton, "Root/rect/TopArea/BaseInfo/IntroBtn")
  self.introBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEasterEggRules)
  end)
  self.redDot = self:AddComponent(UIBaseContainer, "Root/rect/RedDot")
  self.redDot:SetActive(false)
  self.taskRedDot = self:AddComponent(UIBaseContainer, "Root/rect/TopArea/BtnNode/TaskBtn/taskRedDot")
end

function M:ComponentDestroy()
  self.textRemainTime = nil
  self.textTxtActName = nil
  self.btnTask = nil
  self.textTaskBtn = nil
  self.btnReward = nil
  self.textRewardBtn = nil
  self.btnHotEgg = nil
  self.textHotEggBtn = nil
  self.btnThrow = nil
  self.textThrowBtn = nil
  self.btnAmazingEgg = nil
  self.btnGetOne = nil
  self.textItemNum = nil
  self.btnAdd = nil
  self.textGetOneBtn = nil
  self.compEggBtnNode = nil
  self.compRTSceneNode = nil
  self.btnAutoTranslate = nil
  self.autoTranslateSelect = nil
  self.textAutoTranslateBtnTip = nil
  self.btnMyEgg = nil
  self.textMyEgg = nil
  self.rawImgRTSceneBg = nil
  self.redDot = nil
end

function M:DataDefine()
  self.activityId = 0
  self.activityInfo = {}
  self.eggConfigData = nil
  self.days = 0
  self.sceneEggObjList = {}
  self.corners = {}
  self.effList = {}
  DataCenter.ActEasterEggManager:SetIsPlayingHook(false)
end

function M:DataDestroy()
  self.activityId = nil
  self.activityInfo = nil
  self.eggConfigData = nil
  self.days = nil
  self.sceneEggObjList = nil
  self.corners = nil
  self.effList = nil
  DataCenter.ActEasterEggManager:SetIsPlayingHook(false)
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EasterEggGetActivityReceiveData, self.OnActivityReceiveDataUpdate)
  self:AddUIListener(EventId.EasterEggRefreshUnpackEggs, self.OnReceiveUnpackEggs)
  self:AddUIListener(EventId.EasterEggGetActivityPlayRobotRelease, self.PlayRelease)
  self:AddUIListener(EventId.EasterEggGetActivityRefreshMainEggAni, self.PlayEggBornData)
  self:AddUIListener(EventId.OnFinishHandleInitMsg, self.OnFinishHandleInitMsg)
  self:AddUIListener(EventId.EasterEggChatRemindGet, self.OnRecGetOneRemind)
  self:AddUIListener(EventId.EasterEggChatRemindThrow, self.OnRecThrowOneRemind)
  self:AddUIListener(EventId.EasterEggUpdateMainRedDot, self.OnRecUpdateRedDot)
  self:AddUIListener(EventId.RefreshItems, self.RefreshItems)
  self:AddUIListener(EventId.EasterEggTaskUpdate, self.RefreshRedDot)
  self:AddUIListener(EventId.EasterEggTaskRewardGet, self.RefreshRedDot)
  self:AddUIListener(EventId.EasterEggTaskStageRewardGet, self.RefreshRedDot)
  self:AddUIListener(EventId.BoxItemDrawShowDrawSuccess, self.RefreshRedDot)
  self:AddUIListener(EventId.EasterEggChatHandlePickUpEggs, self.OnRecPickUp)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EasterEggGetActivityReceiveData, self.OnActivityReceiveDataUpdate)
  self:RemoveUIListener(EventId.EasterEggRefreshUnpackEggs, self.OnReceiveUnpackEggs)
  self:RemoveUIListener(EventId.EasterEggGetActivityPlayRobotRelease, self.PlayRelease)
  self:RemoveUIListener(EventId.EasterEggGetActivityRefreshMainEggAni, self.PlayEggBornData)
  self:RemoveUIListener(EventId.OnFinishHandleInitMsg, self.OnFinishHandleInitMsg)
  self:RemoveUIListener(EventId.EasterEggChatRemindGet, self.OnRecGetOneRemind)
  self:RemoveUIListener(EventId.EasterEggChatRemindThrow, self.OnRecThrowOneRemind)
  self:RemoveUIListener(EventId.EasterEggUpdateMainRedDot, self.OnRecUpdateRedDot)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshItems)
  self:RemoveUIListener(EventId.EasterEggTaskUpdate, self.RefreshRedDot)
  self:RemoveUIListener(EventId.EasterEggTaskRewardGet, self.RefreshRedDot)
  self:RemoveUIListener(EventId.EasterEggTaskStageRewardGet, self.RefreshRedDot)
  self:RemoveUIListener(EventId.BoxItemDrawShowDrawSuccess, self.RefreshRedDot)
  self:RemoveUIListener(EventId.EasterEggChatHandlePickUpEggs, self.OnRecPickUp)
end

function M:RefreshRedDot()
  self.taskRedDot:SetActive(DataCenter.ActEasterEggTaskManager:GetRedDotNum() > 0)
end

function M:SetData(activityId)
  self:RequestMainRedDot()
  self.activityId = tonumber(activityId)
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.textTxtActName:SetLocalText(self.activityInfo.name)
  SFSNetwork.SendMessage(MsgDefines.EasterEggInfo, toInt(self.activityId), 2)
  self.eggConfigData = DataCenter.ActEasterEggManager:GetEggConfigData(self.activityId)
  self.throwCostItem = self.eggConfigData.throwingCost
  local num = DataCenter.ItemData:GetItemCount(self.throwCostItem)
  self.textItemNum:SetText(num)
  self:CalCurActDay()
  self:RefreshRTSceneBg()
  self:SetAutoTranslate()
  local packingParams = {
    activityId = self.activityId,
    isShowItemTopBar = false
  }
  EventManager:GetInstance():Broadcast(EventId.ActivityCommonGroupView_FestivalPackagingModify, packingParams)
end

function M:OnBtnTaskClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEasterEggTask)
end

function M:OnBtnRewardClick()
  if not self.eggConfigData then
    return
  end
  local thumbUpGiveItemId = self.eggConfigData.thumbUpGiveItemId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBoxItemDraw, {anim = true}, {itemId = thumbUpGiveItemId})
end

function M:OnBtnHotEggClick()
  if not self.activityId then
    return
  end
  local activityId = self.activityId
  SFSNetwork.SendMessage(MsgDefines.EasterJumpToWorld, activityId)
end

function M:OnBtnThrowClick()
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if DataCenter.ItemData:GetItemCount(self.throwCostItem) <= 0 then
    UIUtil.ShowTipsId("activity_99144_14")
    LWResourceLackUtil:GotoGoodsItemLack(self.throwCostItem, 1)
    return
  end
  if activityData:ReachThrowLimit() then
    UIUtil.ShowTipsId("activity_99144_15")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActEasterEggEditView)
end

function M:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityInfo.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.textRemainTime:SetText(countDownTimeStr)
  self:RefreshEggBtnPos()
end

function M:OnActivityReceiveDataUpdate()
  local targetData = DataCenter.ActEasterEggManager:GetActivityData()
  if not targetData then
    Logger.LogError("targetData is nil")
    return
  end
  if targetData.activityId ~= self.activityId then
    return
  end
  self:OpenThumbsUpGloryView()
  self.btnAmazingEgg:SetActive(table.length(targetData.unpackedAmazingEggArr) > 0)
  self.btnHotEgg:SetActive(self.days ~= 1)
end

function M:OnReceiveUnpackEggs()
  local targetData = DataCenter.ActEasterEggManager:GetActivityData()
  self.btnAmazingEgg:SetActive(table.length(targetData.unpackedAmazingEggArr) > 0)
end

function M:PlayRelease()
  if self.robotAni then
    self.robotAni:Play("release")
    self.robotAni:PlayQueued("Default")
  end
end

function M:OpenThumbsUpGloryView()
  local showThumbsUpView = DataCenter.ActEasterEggManager:GetShowThumbsUpView()
  if showThumbsUpView then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActEasterThumbsUpGlory)
  end
end

function M:OnBtnAmazingEggClick()
  DataCenter.ActEasterEggManager:HandleUnpackedAmazingEgg()
end

function M:OnBtnGetOneClick()
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if activityData:ReachPickUpLimit() then
    UIUtil.ShowTipsId("activity_99144_13")
    return
  end
  local canNotDig, digTimeDelta = self:CanNotDig()
  if canNotDig then
    local time = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(digTimeDelta)
    UIUtil.ShowTips(Localization:GetString("activity_99144_23", time))
    return
  end
  local eggMainAniEggData = DataCenter.ActEasterEggManager:GetMainAniEggData()
  if eggMainAniEggData then
    local eggList = eggMainAniEggData:GetCanCaptureEggList()
    local count = table.count(eggList)
    if not count or count < 1 then
      count = 1
    end
    local randomIndex = math.random(1, count)
    local egg = eggList[randomIndex]
    self:OnBtnEggBtnClick(egg)
  end
end

function M:OnClickMyEgg()
  self.redDot:SetActive(false)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActEasterEggMessage)
end

function M:OnBtnAddClick()
  if self.throwCostItem then
    LWResourceLackUtil:GotoGoodsItemLack(self.throwCostItem, 1)
  end
end

function M:CalCurActDay()
  if not self.activityInfo then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.endTime = self.activityInfo.endTime
  local actTotalDays = (self.activityInfo.endTime - self.activityInfo.startTime) / (OneDayTime * 1000) + 1
  if curTime >= self.activityInfo.startTime and curTime < self.activityInfo.endTime then
    local value = (curTime - self.activityInfo.startTime) / 1000
    for i = 1, actTotalDays do
      if value <= i * OneDayTime then
        self.days = i
        break
      end
    end
  end
end

function M:RefreshRTSceneBg()
  self.rawImgRTSceneBg:Clear()
  local rtImgWidth = self.rawImgRTSceneBg.rectTransform.rect.width
  local rtImgHeight = self.rawImgRTSceneBg.rectTransform.rect.height
  local maxHeight = DefaultScreenHeight
  local newHeight = math.min(rtImgHeight, maxHeight)
  local newWidth = newHeight / (rtImgHeight / rtImgWidth)
  self.newWidth = newWidth
  self.newHeight = newHeight
  self.rawImgRTSceneBg:SetRTSize(math.ceil(newWidth), math.ceil(newHeight))
  self.rawImgRTSceneBg:SetDefaultSceneTrans(Vector3.New(500, 0, 500))
  self.rawImgRTSceneBg:SetRTFormat(CS.UnityEngine.RenderTextureFormat.ARGBHalf)
  self.rawImgRTSceneBg:ReInit(scenePrefabPath)
  self.rawImgRTSceneBg:SetActive(true)
  self.rawImgRTSceneBg:SetOnLoadSceneHandler(function()
    local aniPath = "Model/A_build_fuhuojie_diaoyu/A_build@fuhuojie_diaoyu_skin"
    local aniNode = self.rawImgRTSceneBg:GetSceneNode(aniPath)
    self.sceneCamera = self.rawImgRTSceneBg:GetRenderCamera()
    if not self.sceneCamera then
      Logger.LogError("camera is nil")
      return
    end
    local eggPath = "Model/A_build_fuhuojie_diaoyu/A_build@fuhuojie_diaoyu_skin/To_unity/DeformationSystem/Root/neidan"
    for i = 1, sceneEggCount do
      local path = eggPath .. i
      local eggObj = self.rawImgRTSceneBg:GetSceneNode(path)
      table.insert(self.sceneEggObjList, eggObj)
    end
    self.eggShell = self.rawImgRTSceneBg:GetSceneNode("Model/Danhejuanzhou")
    self.eggRoll = self.rawImgRTSceneBg:GetSceneNode("Model/Danhejuanzhou/UI_fuhuojiezhubaopifu_juanzhou")
    self.eggRoll:SetActive(DataCenter.ItemData:GetItemCount(self.throwCostItem) > 0)
    local pos = self:RTPos2UIPos(self.eggShell)
    self.btnThrow.transform.position = pos
    local my_egg_pos_path = "Model/MyEggPos"
    local eggPosNode = self.rawImgRTSceneBg:GetSceneNode(my_egg_pos_path)
    self.btnMyEgg.transform.position = self:RTPos2UIPos(eggPosNode)
    self.textMyEgg:SetLocalText("activity_99144_ui_10")
    local index = {
      1,
      2,
      5,
      3,
      6,
      4
    }
    for i = 1, sceneEggCount do
      local effPath = "Model/A_build_fuhuojie_diaoyu/A_build@fuhuojie_diaoyu_skin/Eff/Eff" .. index[i]
      local eff = self.rawImgRTSceneBg:GetSceneNode(effPath)
      table.insert(self.effList, eff)
    end
    self:RefreshSceneEgg()
    self.robotAni = aniNode:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    self.robotAni:Play("born")
    self.robotAni:PlayQueued("Default")
  end)
end

function M:SetAutoTranslate()
  local autoTranslate = DataCenter.ActEasterEggManager:GetIsOpenAutoTranslate()
  self.autoTranslateSelect:SetActive(autoTranslate)
end

function M:OnBtnAutoTranslateClick()
  local autoTranslate = DataCenter.ActEasterEggManager:GetIsOpenAutoTranslate()
  DataCenter.ActEasterEggManager:SetIsOpenAutoTranslate(not autoTranslate)
  self:SetAutoTranslate()
end

function M:OnBtnEggBtnClick(index)
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if activityData:ReachPickUpLimit() then
    UIUtil.ShowTipsId("activity_99144_13")
    return
  end
  local canNotDig, digTimeDelta = self:CanNotDig()
  if canNotDig then
    local time = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(digTimeDelta)
    UIUtil.ShowTips(Localization:GetString("activity_99144_23", time))
    return
  end
  local eggMainAniEggData = DataCenter.ActEasterEggManager:GetMainAniEggData()
  if eggMainAniEggData then
    eggMainAniEggData:RemoveEggFromList(index)
  end
  self:RequestPickUpEgg()
  if not IsNull(self.robotAni) then
    self.robotAni:Play("hook" .. index)
    DataCenter.ActEasterEggManager:SetIsPlayingHook(true)
    self.robotAni:PlayQueued("Default")
    self:StopDelayHookTimer()
    self:SetBtnEnable(false)
    self.delayHookTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayHookTimer ~= nil then
        self.delayHookTimer:Stop()
        self.delayHookTimer = nil
        DataCenter.ActEasterEggManager:SetIsPlayingHook(false)
      end
    end, 3)
    self.delayHookTimer:Start()
  else
    Logger.LogError("self.robotAni is null")
  end
end

function M:CanNotDig()
  local digLimitTime = self.eggConfigData.digLimitTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local timeDelta = digLimitTime * 60 * 1000 - (curTime - self.activityInfo.startTime)
  return 0 < timeDelta, timeDelta / 1000
end

function M:RequestPickUpEgg()
  SFSNetwork.SendMessage(MsgDefines.EasterEggPickUp, toInt(self.activityId))
end

function M:StopDelayHookTimer()
  if self.delayHookTimer then
    self.delayHookTimer:Stop()
    self.delayHookTimer = nil
  end
end

function M:RefreshSceneEgg()
  local eggAniData = DataCenter.ActEasterEggManager:GetMainAniEggData()
  if not eggAniData then
    return
  end
  local canCaptureEgg = eggAniData:GetCanCaptureEggList()
  if not canCaptureEgg or table.count(canCaptureEgg) == 0 then
    eggAniData:RecoverEggList()
  end
  canCaptureEgg = eggAniData:GetCanCaptureEggList()
  if self.sceneEggObjList then
    for k, v in pairs(self.sceneEggObjList) do
      local has = table.hasvalue(canCaptureEgg, k)
      v:SetActive(has)
      self.eggBtnList[k]:SetActive(has)
      self.effList[k]:SetActive(has)
    end
  end
end

function M:RefreshEggBtnPos()
  if table.count(self.sceneEggObjList) >= sceneEggCount then
    for k, v in pairs(self.sceneEggObjList) do
      local pos = self:RTPos2UIPos(v)
      self.eggBtnList[k].transform.position = pos
    end
  end
end

function M:RTPos2UIPos(target)
  if self.rawImgRTSceneBg and self.sceneCamera then
    local viewportPos = self.sceneCamera:WorldToViewportPoint(target.transform.position)
    if viewportPos.z <= 0 then
      return nil
    end
    local corners = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), 4)
    self.rawImgRTSceneBg.rectTransform:GetWorldCorners(corners)
    local rawImageWidth = corners[3].x - corners[0].x
    local rawImageHeight = corners[1].y - corners[0].y
    local uiWorldPos = CS.UnityEngine.Vector3(corners[0].x + viewportPos.x * rawImageWidth, corners[0].y + viewportPos.y * rawImageHeight, corners[0].z)
    return uiWorldPos
  end
end

function M:PlayEggBornData()
  if self.robotAni then
    local eggMainAniEggData = DataCenter.ActEasterEggManager:GetMainAniEggData()
    if eggMainAniEggData then
      local eggList = eggMainAniEggData:GetCanCaptureEggList()
      if table.count(eggList) == 0 then
        self:RefreshSceneEgg()
        self.robotAni:Play("born")
        self.robotAni:PlayQueued("Default")
      else
        self:RefreshSceneEgg()
      end
    end
  end
end

function M:SetBtnEnable(enable)
  self.btnTask:SetEnable(enable)
  self.btnReward:SetEnable(enable)
  self.btnHotEgg:SetEnable(enable)
  self.btnThrow:SetEnable(enable)
  self.btnAmazingEgg:SetEnable(enable)
  self.btnGetOne:SetEnable(enable)
  self.btnAdd:SetEnable(enable)
  for _, v in pairs(self.eggBtnList) do
    v:SetEnable(enable)
  end
  self.introBtn:SetEnable(enable)
end

function M:OnFinishHandleInitMsg()
  self:SetBtnEnable(true)
end

function M:OnRecGetOneRemind()
  self:ShowArrow(self.btnGetOne)
end

function M:OnRecThrowOneRemind()
  self:ShowArrow(self.btnThrow)
end

function M:ShowArrow(target)
  local param = {}
  param.position = target.transform.position
  param.position.y = param.position.y + 10
  param.arrowType = ArrowType.Normal
  param.positionType = PositionType.Screen
  param.isAutoClose = 2
  DataCenter.ArrowManager:ShowArrow(param)
end

function M:RequestMainRedDot()
  DataCenter.ActEasterEggManager:RequestRedDot()
  local delay = 300
  self:StopRedDotTimer()
  self.requestRedDotTimer = TimerManager:GetInstance():GetTimer(delay, function()
    DataCenter.ActEasterEggManager:RequestRedDot()
  end, self, false, false, false)
  self.requestRedDotTimer:Start()
end

function M:StopRedDotTimer()
  if self.requestRedDotTimer then
    self.requestRedDotTimer:Stop()
    self.requestRedDotTimer = nil
  end
end

function M:OnRecUpdateRedDot(comment)
  self.redDot:SetActive(comment and tonumber(comment) > 0)
end

function M:RefreshItems()
  if not self.throwCostItem then
    return
  end
  local num = DataCenter.ItemData:GetItemCount(self.throwCostItem)
  if self.eggRoll then
    self.eggRoll:SetActive(0 < num)
  end
  if self.textItemNum then
    self.textItemNum:SetText(num)
  end
end

function M:OnRecPickUp()
  self:SetBtnEnable(true)
end

return LWUIActEasterEggMainView
