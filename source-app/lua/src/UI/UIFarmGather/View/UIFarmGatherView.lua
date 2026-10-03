local FarmGatherItem = require("UI.UIFarmGather.Component.FarmGatherItem")
local UIFarmGatherView = BaseClass("UIFarmGatherView", UIBaseView)
local base = UIBaseView
local gather_obj_path = "tips"
local drag_item_img_path = "dragImg"
local item_img_path = "tips/item"

local function OnCreate(self)
  base.OnCreate(self)
  self.gather_obj = self:AddComponent(FarmGatherItem, gather_obj_path)
  self.drag_item_img = self:AddComponent(UIImage, drag_item_img_path)
  self.drag_item_img:SetActive(false)
  self.animator = self:AddComponent(UIAnimator, drag_item_img_path)
  self.item_img = self:AddComponent(UIAnimator, item_img_path)
  self.guide_item_img = self:AddComponent(UIImage, item_img_path)
  self.showDrag = false
  self.showTip = true
  self.needResetOpen = false
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Ground2, false)
end

local function OnDestroy(self)
  DataCenter.RecommendShowManager:ResetState()
  EventManager:GetInstance():Broadcast(EventId.CloseGuideMoveArrow)
  if self.needResetOpen then
    self.needResetOpen = nil
    EventManager:GetInstance():Broadcast(EventId.GuideNoOpenUI, false)
  end
  self.gather_obj = nil
  self.drag_item_img = nil
  self.item_img = nil
  self.animator = nil
  self.showDrag = nil
  self.showTip = nil
  self.guide_item_img = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  local param = {}
  param.list = {
    ResourceType.Water
  }
  param.uiName = UIWindowNames.UIFarmGather
  EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
  self:UpdateView(self:GetUserData())
end

local function UpdateView(self, data)
  self.buildUuid = tonumber(data)
  local info = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
  if info ~= nil then
    local pointId = info.pointId
    local worldPos = SceneUtils.TileIndexToWorld(pointId)
    local pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
    self.gather_obj.transform.position = pos
  end
  EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShowEffect, tostring(self.buildUuid))
  self.ctrl:InitData(self.buildUuid)
  self:SetData()
  self:CheckGuide()
  self:CheckRecommend()
end

local function OnDisable(self)
  EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHideEffect)
  EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIFarmGather)
  base.OnDisable(self)
end

local function SetData(self)
  self.showTip = true
  local list = self.ctrl:GetItemList()
  if list ~= nil then
    self.gather_obj:RefreshData(list[1])
  end
end

local function Update(self)
  if self.drag_item_img == nil or self.drag_item_img:GetActive() == false then
    return
  end
  if DataCenter.RecommendShowManager:IsCanMoving() then
    local pos = self.drag_item_img.transform.position
    self:AdjustCameraPosition(pos.x, pos.y)
  end
end

local function AdjustCameraPosition(self, fingerX, fingerY)
  local totalW = Screen.width
  local totalH = Screen.height
  local checkBorderMinX = 100
  local checkBorderMaxX = totalW - checkBorderMinX
  local checkBorderMinY = 100
  local checkBorderMaxY = totalH - checkBorderMinY
  local adjustFlag = false
  local adjustX = 0
  local adjustY = 0
  local maxSpeed = 13
  if fingerX < checkBorderMinX then
    adjustFlag = true
    adjustX = -maxSpeed
  end
  if fingerX > checkBorderMaxX then
    adjustFlag = true
    adjustX = maxSpeed
  end
  if fingerY < checkBorderMinY then
    adjustFlag = true
    adjustY = -maxSpeed
  end
  if fingerY > checkBorderMaxY then
    adjustFlag = true
    adjustY = maxSpeed
  end
  adjustX = Mathf.Clamp(adjustX, -maxSpeed, maxSpeed)
  adjustY = Mathf.Clamp(adjustY, -maxSpeed, maxSpeed)
  if adjustFlag then
    local pos = CS.SceneManager.World:ScreenPointToWorld(Vector3.New(totalW / 2 + adjustX, totalH / 2 + adjustY), 0)
    CS.SceneManager.World:Lookat(pos)
  end
end

local function OnDragItem(self, eventData, itemData)
  if self.drag_item_img:GetActive() then
    local curPos = eventData.position
    local posV3 = Vector3.New(curPos.x, curPos.y, 0)
    if DataCenter.RecommendShowManager:IsCanMoving() then
      self:AdjustCameraPosition(curPos.x, curPos.y)
    end
    self.drag_item_img.transform.position = posV3
    local tilePos = CS.SceneManager.World:GetRaycastGroundPoint(posV3)
    local posIndex = SceneUtils.WorldToTileIndex(tilePos)
    local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(posIndex)
    if buildData ~= nil and buildData.uuid ~= nil then
      local bUuid = buildData.uuid
      if itemData.farmState == FarmStateType.Harvest or itemData.farmState == FarmStateType.HarvestSecond then
        local queueData = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(bUuid)
        if queueData ~= nil then
          self.ctrl:OnDragTrigger(SceneUtils.TileIndexToWorld(buildData.pointId), itemData, queueData)
          if queueData:GetQueueState() == NewQueueState.Finish then
            if self.ctrl ~= nil and not self.ctrl.isInGuide and self.showTip then
              self.showTip = false
              self.gather_obj:PlayMoveOutAnimator()
              EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHideEffect)
            end
            if self.animator ~= nil then
              self.animator:Play("farm_darg_shake", 0, 0)
            end
          end
        end
      end
    end
  end
end

local function OnBeginDragItem(self, eventData, itemData)
  if itemData ~= nil then
    self.drag_item_img:LoadSprite(itemData.icon)
    if itemData.sizeX ~= nil and itemData.sizeY ~= nil then
      self.drag_item_img.rectTransform:Set_sizeDelta(itemData.sizeX, itemData.sizeY)
    end
    self.showDrag = true
    self.drag_item_img:SetActive(self.showDrag)
  end
end

local function OnEndDragItem(self, eventData, itemData)
  self.showDrag = false
  self.drag_item_img:SetActive(self.showDrag)
  if not self.ctrl.isInGuide or table.count(self.ctrl.guideLeftPointIds) == 0 then
    self.ctrl:OnDragFinish(itemData)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshFarmGatherUI, self.OnRefreshSignal)
  self:AddUIListener(EventId.RefreshRecommendShow, self.RefreshRecommendShowSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshFarmGatherUI, self.OnRefreshSignal)
  self:RemoveUIListener(EventId.RefreshRecommendShow, self.RefreshRecommendShowSignal)
end

local function OnRefreshSignal(self, data)
  self:UpdateView(data)
end

local function CheckGuide(self)
  self.ctrl.isInGuide = false
  local guideType = DataCenter.GuideManager:GetGuideType()
  if guideType == GuideType.GetFarm then
    self.ctrl.isInGuide = true
    self.ctrl.guideLeftPointIds = {}
    local param = {}
    param.pointList = {}
    local para2 = DataCenter.GuideManager:GetGuideTemplateParam("para2")
    if para2 ~= nil and para2 ~= "" then
      local spl = string.split(para2, ";")
      local mainPos = DataCenter.BuildManager.main_city_pos
      self.ctrl.guideStartPos = self.item_img.transform.position
      local startParam = {}
      startParam.pointType = PositionType.Screen
      startParam.pointPosition = self.ctrl.guideStartPos
      table.insert(param.pointList, startParam)
      for k2, v2 in ipairs(spl) do
        local spl1 = string.split(v2, ",")
        if table.count(spl) > 1 then
          local vec2 = CS.UnityEngine.Vector2Int(mainPos.x + tonumber(spl1[1]), mainPos.y + tonumber(spl1[2]))
          table.insert(self.ctrl.guideLeftPointIds, SceneUtils.TilePosToIndex(vec2))
          local posParam = {}
          posParam.pointType = PositionType.World
          posParam.pointPosition = SceneUtils.TileToWorld(vec2)
          table.insert(param.pointList, posParam)
        end
      end
    end
    param.arrowtype = tonumber(DataCenter.GuideManager:GetGuideTemplateParam("arrowtype"))
    param.arrowdirection = tonumber(DataCenter.GuideManager:GetGuideTemplateParam("arrowdirection"))
    param.notUseEndFlag = true
    DataCenter.GuideManager:SetCompleteNeedParam(param)
    EventManager:GetInstance():Broadcast(EventId.GuideNoOpenUI, true)
    self.needResetOpen = true
  end
end

local function CheckRecommend(self)
  if DataCenter.RecommendShowManager:GetPanelShowPara(RecommendShowType.FarmGet) ~= nil then
    self.item_img:Play(RecommendShowAnimName[RecommendShowAnimType.Show], 0, 0)
    local list = {}
    local waitAnimType = UIGuideMoveArrowNeedWaitType.No
    local recommendParam = DataCenter.RecommendShowManager:GetRecommendShowParam(RecommendShowType.FarmGet)
    if recommendParam ~= nil then
      local buildIdList = DataCenter.QueueDataManager:GetBuildUuidInFinishQueueByType(NewQueueType.Field)
      if buildIdList ~= nil then
        local orderCount = 0
        for k1, v1 in ipairs(recommendParam.buildUuidList) do
          if table.hasvalue(buildIdList, v1) then
            if v1 == self.buildUuid then
              orderCount = 100
            end
            local info = DataCenter.BuildManager:GetBuildingDataByUuid(v1)
            if info ~= nil then
              local posParam = {}
              posParam.pointType = PositionType.World
              posParam.pointPosition = info:GetCenterVec()
              posParam.order = k1 - orderCount
              table.insert(list, posParam)
            end
          end
        end
      end
      waitAnimType = recommendParam.waitAnimType
      recommendParam.waitAnimType = UIGuideMoveArrowNeedWaitType.No
    end
    if 0 < table.count(list) then
      local param = {}
      param.pointList = {}
      local startParam = {}
      startParam.pointType = PositionType.Screen
      startParam.pointPosition = self.item_img.transform.position
      table.insert(param.pointList, startParam)
      table.sort(list, function(a, b)
        return a.order < b.order
      end)
      for k2, v2 in ipairs(list) do
        table.insert(param.pointList, v2)
      end
      param.arrowtype = GuideArrowStyle.Finger
      param.arrowdirection = GuideArrowDirection.LeftDown
      param.notUseEndFlag = true
      local image = self.guide_item_img
      if image ~= nil then
        param.sprite = image:GetImage()
        param.spriteSize = image:GetSizeDelta()
      end
      param.waitAnimType = waitAnimType
      param.isRecommend = true
      if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideMoveArrow) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideMoveArrow, {anim = false, playEffect = false}, param)
      else
        EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
      end
    end
  end
end

local function RefreshRecommendShowSignal(self)
  local info = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
  if info ~= nil then
    local pointId = info.pointId
    local worldPos = SceneUtils.TileIndexToWorld(pointId)
    local pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
    self.gather_obj.transform.position = pos
  end
  self:CheckRecommend()
end

UIFarmGatherView.OnCreate = OnCreate
UIFarmGatherView.OnDestroy = OnDestroy
UIFarmGatherView.OnEnable = OnEnable
UIFarmGatherView.OnDisable = OnDisable
UIFarmGatherView.SetData = SetData
UIFarmGatherView.OnDragItem = OnDragItem
UIFarmGatherView.OnBeginDragItem = OnBeginDragItem
UIFarmGatherView.OnEndDragItem = OnEndDragItem
UIFarmGatherView.UpdateView = UpdateView
UIFarmGatherView.OnAddListener = OnAddListener
UIFarmGatherView.OnRemoveListener = OnRemoveListener
UIFarmGatherView.AdjustCameraPosition = AdjustCameraPosition
UIFarmGatherView.Update = Update
UIFarmGatherView.CheckGuide = CheckGuide
UIFarmGatherView.OnRefreshSignal = OnRefreshSignal
UIFarmGatherView.CheckRecommend = CheckRecommend
UIFarmGatherView.RefreshRecommendShowSignal = RefreshRecommendShowSignal
return UIFarmGatherView
