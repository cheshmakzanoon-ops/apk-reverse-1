local base = UIBaseContainer
local LWUIPopupActivityDataPanelItemRender = BaseClass("LWUIPopupActivityDataPanelItemRender", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIPopupActivityDataPanelItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIPopupActivityDataPanelItemRender:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIPopupActivityDataPanelItemRender:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgBanner = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textExplain = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textLeftTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.imgNewIcon = self.viewSkin:AddComponent(self, UIImage, 6)
  self.imgRedPoint = self.viewSkin:AddComponent(self, UIImage, 7)
end

function LWUIPopupActivityDataPanelItemRender:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgBanner = nil
  self.textTitle = nil
  self.textExplain = nil
  self.textLeftTime = nil
  self.btnGo = nil
  self.imgNewIcon = nil
  self.imgRedPoint = nil
end

function LWUIPopupActivityDataPanelItemRender:DataDefine()
end

function LWUIPopupActivityDataPanelItemRender:DataDestroy()
end

function LWUIPopupActivityDataPanelItemRender:OnAddListener()
  base.OnAddListener(self)
end

function LWUIPopupActivityDataPanelItemRender:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIPopupActivityDataPanelItemRender:ReInit(data)
  self.data = data
  if not self.data then
    return
  end
  self.rawImgBanner:LoadSpriteAuto(self.data.icon)
  self.textTitle:SetLocalText(self.data:GetTitle())
  self.textExplain:SetLocalText(self.data:GetDesc())
  local showRedPoint = self:CheckShowRedPoint()
  self.imgRedPoint:SetActive(showRedPoint)
end

function LWUIPopupActivityDataPanelItemRender:CheckShowRedPoint()
  if self.data then
    local clickCanClear = self.data:CheckCanClear(PopupCleanType.Click)
    return clickCanClear
  end
  return false
end

function LWUIPopupActivityDataPanelItemRender:OnBtnGoClick()
  local activityType = self.data.popupType
  if activityType == PopupActivityType.KingActivity then
    self:JumpToKingActivity()
  elseif activityType == PopupActivityType.CrossKingActivity then
    self:JumpToCrossKingActivity()
  elseif activityType == PopupActivityType.NewPeakArena then
    self:JumpToNewPeakArena()
  elseif activityType == PopupActivityType.NewGaleArena then
    self:JumpToNewGaleArena()
  elseif activityType == PopupActivityType.ThreeVThreeArena then
    self:JumpTo3V3Arena()
  elseif activityType == PopupActivityType.ChampionDuel then
    self:JumpToChampionDuel()
  elseif activityType == PopupActivityType.ActDsbDuel then
    self:JumpToDsbDuel()
  end
  DataCenter.LWPopupManager:ClearPopupActivityByClick(activityType)
end

function LWUIPopupActivityDataPanelItemRender:JumpToKingActivity()
  if self.view then
    self.view:ClosePanel()
  end
  UIUtil.ShowGovernmentActivityMain()
end

function LWUIPopupActivityDataPanelItemRender:JumpToCrossKingActivity()
  local fightInfo = DataCenter.ZoneWarManager:GetCrossKingFightInfo(true)
  if fightInfo then
    local leftInfo = fightInfo.curVsRound[1] or {
      serverId = 0,
      score = 0,
      campId = 0
    }
    local rightInfo = fightInfo.curVsRound[2] or {
      serverId = 0,
      score = 0,
      campId = 0
    }
    if 0 < leftInfo.campId and 0 < rightInfo.campId and leftInfo.campId < rightInfo.campId then
      local temp = leftInfo
      leftInfo = rightInfo
      rightInfo = temp
    end
    local battleServerId = 0
    if leftInfo.score > rightInfo.score or leftInfo.score == rightInfo.score and leftInfo.serverId > rightInfo.serverId then
      battleServerId = rightInfo.serverId
    else
      battleServerId = leftInfo.serverId
    end
    if 0 < battleServerId then
      if DataCenter.LWZombieRushManager:IsChallenging() then
        UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("zombieRush_tips_12"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          if self.view then
            self.view:ClosePanel()
          end
          CrossServerUtil.JumpToKingdomAround(battleServerId, MoveCrossServerType.CrossServerKingBattle)
        end, function()
        end)
      else
        if self.view then
          self.view:ClosePanel()
        end
        CrossServerUtil.JumpToKingdomAround(battleServerId, MoveCrossServerType.CrossServerKingBattle)
      end
    elseif self.view then
      self.view:ClosePanel()
    end
  elseif self.view then
    self.view:ClosePanel()
  end
end

function LWUIPopupActivityDataPanelItemRender:JumpToNewPeakArena()
  if self.view then
    self.view:ClosePanel()
  end
  DataCenter.NewPeakArenaManager.arenaMainGotoTab = PVPArenaType.NewPeakArena
  GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_PVP_ARENA, WorldTileBtnType.PVPArena)
end

function LWUIPopupActivityDataPanelItemRender:JumpToNewGaleArena()
  if self.view then
    self.view:ClosePanel()
  end
  DataCenter.NewPeakArenaManager.arenaMainGotoTab = PVPArenaType.NewGaleArena
  GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_PVP_ARENA, WorldTileBtnType.PVPArena)
end

function LWUIPopupActivityDataPanelItemRender:JumpTo3V3Arena()
  local state = DataCenter.LW3V3ArenaManager.state
  if state ~= PVPArenaState.Invalide then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PVP_ARENA)
    if buildData == nil then
      return
    end
    local posEnd = buildData.pointId
    if self.view then
      self.view:ClosePanel()
    end
    GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), nil, nil, function()
      DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.Arena3V3, nil)
    end)
  elseif self.view then
    self.view:ClosePanel()
  end
end

function LWUIPopupActivityDataPanelItemRender:JumpToChampionDuel()
  DataCenter.NewPeakArenaManager:GoToChampionDuelMain()
  if self.view then
    self.view:ClosePanel()
  end
end

function LWUIPopupActivityDataPanelItemRender:JumpToDsbDuel()
  if self.view then
    self.view:ClosePanel()
  end
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_RACE_ENTRANCE)
  if buildData ~= nil then
    local worldPos = buildData:GetCenterVec()
    SceneUtils.ChangeToCity(function()
      GoToUtil.GotoCityPos(worldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        local param = {}
        worldPos.y = worldPos.y + 8
        param.position = CS.CSUtils.WorldPositionToUISpacePosition(worldPos)
        param.position.x = param.position.x + 5
        param.arrowType = ArrowType.Building
        param.positionType = PositionType.Screen
        DataCenter.ArrowManager:ShowArrow(param)
      end)
    end)
  end
end

return LWUIPopupActivityDataPanelItemRender
