local UIAlCompeteTipsView = BaseClass("UIAlCompeteTipsView", UIBaseView)
local base = UIBaseView
local Screen = CS.UnityEngine.Screen
local ShowType = {
  Fight = 1,
  Desert = 2,
  Glory = 3
}

function UIAlCompeteTipsView:OnCreate()
  base.OnCreate(self)
  self.showType = ShowType.Fight
  self.isCross = false
  self.targetServerId, self.showType = self:GetUserData()
  SFSNetwork.SendMessage(MsgDefines.CrossGetAlliancePoint)
  if self.showType == ShowType.Desert then
    DataCenter.AllianceCompeteDataManager:RequestFightServerAllianceCity()
  end
  if self.targetServerId > 0 and self.targetServerId ~= LuaEntry.Player:GetSelfServerId() then
    self.isCross = true
  end
  self._title_txt = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self._title_txt:SetLocalText(143600)
  self.close_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.return_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.scroll_view = self:AddComponent(UIScrollPage, "ScrollView")
  local OnUpdateScroll = BindCallback(self, self.OnUpdateScroll)
  self.scroll_view:SetPageChangedCallback(OnUpdateScroll)
  self.scroll_view:SetPageCount(3)
  self.content = self:AddComponent(UIBaseContainer, "ScrollView/View/Content")
  self.pointArea = {}
  for i = 1, 3 do
    local progress_img = "PointArea/progress_img" .. i
    local select_img = "PointArea/progress_img" .. i .. "/select_img" .. i
    self.pointArea[i] = {
      progress = self:AddComponent(UIImage, progress_img),
      select = self:AddComponent(UIImage, select_img)
    }
  end
  self.cellTab = {}
  for i = 1, 3 do
    local DesNameTip = "ScrollView/View/Content/Cell" .. i .. "/DesNameTip" .. i
    self.cellTab[i] = {
      desNameTip = self:AddComponent(UIText, DesNameTip)
    }
  end
  self._btn_txt = self:AddComponent(UIText, "UseBtn/UseBtnName")
  self._btn_txt:SetLocalText(143584)
  self.use_btn = self:AddComponent(UIButton, "UseBtn")
  self.use_btn:SetOnClick(function()
    self:ClickJump()
  end)
  self.pointId = 0
  self:ReInit()
end

function UIAlCompeteTipsView:OnDestroy()
  self.content:SetAnchoredPosition(Vector2.New(0, 0))
  self.content = nil
  self.close_btn = nil
  self.return_btn = nil
  self.scroll_view = nil
  self.pointArea = nil
  self._desNameTip_txt = nil
  self._desName_txt = nil
  base.OnDestroy(self)
end

function UIAlCompeteTipsView:ReInit()
  self.cellTab[1].desNameTip:SetLocalText(143601)
  self.cellTab[2].desNameTip:SetLocalText(143602)
  self.cellTab[3].desNameTip:SetLocalText(302876)
  if self.showType == ShowType.Glory then
    local period = DataCenter.GloryManager:GetPeriod()
    local battleState = DataCenter.GloryManager:GetBattleState()
    if period == GloryPeriod.Start and (battleState == GloryBattleState.Before or battleState == GloryBattleState.Ongoing) then
      self.use_btn:SetActive(true)
    else
      self.use_btn:SetActive(false)
    end
  else
    self.use_btn:SetActive(true)
  end
end

function UIAlCompeteTipsView:OnUpdateScroll(index)
  self.pointArea[index].select:SetActive(true)
  self.pointArea[self.lastIndex].select:SetActive(false)
  self.lastIndex = index
end

function UIAlCompeteTipsView:OnEnable()
  base.OnEnable(self)
  self.pointArea[1].select:SetActive(true)
  self.pointArea[2].select:SetActive(false)
  self.pointArea[3].select:SetActive(false)
  self.lastIndex = 1
end

function UIAlCompeteTipsView:OnDisable()
  base.OnDisable(self)
end

function UIAlCompeteTipsView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CrossServerAlliancePoint, self.OnCallBack)
end

function UIAlCompeteTipsView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CrossServerAlliancePoint, self.OnCallBack)
end

function UIAlCompeteTipsView:OnCallBack(data)
  local str = tostring(data)
  local arr = string.split(str, ";")
  if 2 <= #arr then
    local serverId = tonumber(arr[1])
    local pointId = tonumber(arr[2])
    if serverId == self.targetServerId then
      self.pointId = pointId
    end
  end
end

function UIAlCompeteTipsView:ClickJump()
  GoToUtil.CloseAllWindows()
  local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  if isR4orR5 == true then
    if self.showType == ShowType.Fight then
      self:GotoCrossWorm()
    elseif self.showType == ShowType.Desert then
      self:GotoAllianceFlag()
    end
  elseif self.showType == ShowType.Fight then
    self:GotoCrossWorm()
  elseif self.showType == ShowType.Desert then
    local flagData = DataCenter.AllianceMineManager:GetAllianceFlagData()
    if flagData ~= nil then
      self:GotoAllianceFlag()
    elseif self.isCross then
      self:GotoCrossWorm()
    else
      self:JumpSelfServerPoint()
    end
  end
  if self.showType == ShowType.Glory then
    DataCenter.GloryManager:GoToOpponent()
  end
end

function UIAlCompeteTipsView:GotoCrossWorm()
  CrossServerUtil.JumpToServerByServerId(self.targetServerId, MoveCrossServerType.AllianceDuel, self.pointId, MoveCityCameraHeight)
end

function UIAlCompeteTipsView:GotoAllianceFlag()
  local flagData = DataCenter.AllianceMineManager:GetAllianceFlagData()
  if flagData ~= nil then
    local targetServerId = flagData.curServerId
    local pointId = flagData.pointId
    if 0 < pointId then
      local position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
      position.x = position.x - 1
      position.y = position.y
      position.z = position.z - 1
      GoToUtil.GotoWorldPos(position, nil, nil, nil, targetServerId)
      WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
    end
  elseif self.pointId > 0 then
    local position = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World)
    position.x = position.x - 1
    position.y = position.y
    position.z = position.z - 1
    WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
    GoToUtil.GotoWorldPos(position, 55, nil, function()
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.BuildAllianceFlag, SaveGuideDoneValue)
    end, self.targetServerId)
  else
    local position = {}
    position.x = 1000
    position.y = 0
    position.z = 1000
    GoToUtil.GotoWorldPos(position, 55, nil, nil, self.targetServerId)
    EventManager:GetInstance():Broadcast(EventId.ShowCreateAllianceFlag)
  end
end

function UIAlCompeteTipsView:JumpSelfServerPoint()
  if self.pointId > 0 then
    local position = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World)
    position.x = position.x - 1
    position.y = position.y
    position.z = position.z - 1
    GoToUtil.GotoWorldPos(position, 55, LookAtFocusTime, nil)
    WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
  else
    local position = {}
    position.x = 1000
    position.y = 0
    position.z = 1000
    GoToUtil.GotoWorldPos(position, 55)
    WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
  end
end

return UIAlCompeteTipsView
