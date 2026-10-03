local FarmDesItem = require("UI.UIFarm.Component.FarmDesItem")
local FarmResourceItemNew = require("UI.UIFarm.Component.FarmResourceItemNew")
local FarmGatherItem = require("UI.UIFarm.Component.FarmGatherItem")
local UIProductLevelState = require("UI.UIFactory.Component.UIProductLevelState")
local UIFarmNewView = BaseClass("UIFarmNewView", UIBaseView)
local base = UIBaseView
local search_obj_path = "Search"
local tab_img_path_2 = "Tab/hide/tab_img2"
local tab_img_path_3 = "Tab/hide/tab_img3"
local tab_img_path_4 = "Tab/hide/tab_img4"
local tab_img_path_5 = "Tab/hide/tab_img5"
local tab_content_path = "Tab/hide/content"
local drag_item_img_path = "dragImg"
local tab_alpha_path = "Tab/hide"
local tab_obj_path = "Tab"
local gray_img_path = "GrayImage"
local light_img_path = "LightImage"
local more_path = "Tab/hide/more_content"
local more_btn_path = "Tab/hide/more_content/more_next"
local more1_cover_path = "Tab/hide/more_content/more_1/more_1_cover"
local more2_cover_path = "Tab/hide/more_content/more_2/more_2_cover"
local productLevelState_path = "Tab/hide/UIProductLevelState"
local max_num_per_page = 5

local function OnCreate(self)
  base.OnCreate(self)
  self.search_obj = self:AddComponent(FarmDesItem, search_obj_path)
  self.tab_obj = self:AddComponent(UIBaseContainer, tab_obj_path)
  self.tab_content = self:AddComponent(UIBaseContainer, tab_content_path)
  self.tab_img2 = self:AddComponent(UIImage, tab_img_path_2)
  self.tab_img3 = self:AddComponent(UIImage, tab_img_path_3)
  self.tab_img4 = self:AddComponent(UIImage, tab_img_path_4)
  self.tab_img5 = self:AddComponent(UIImage, tab_img_path_5)
  self.content_anim = self:AddComponent(UIAnimator, tab_content_path)
  self.content_alpha = self:AddComponent(UICanvasGroup, tab_alpha_path)
  self.drag_item_img = self:AddComponent(UIImage, drag_item_img_path)
  self.animator = self:AddComponent(UIAnimator, drag_item_img_path)
  self.gray_img = self:AddComponent(UIImage, gray_img_path)
  self.light_img = self:AddComponent(UIImage, light_img_path)
  self.grayMaterial = self.gray_img:GetMaterial()
  self.lightMaterial = self.light_img:GetMaterial()
  self.more = self:AddComponent(UIBaseContainer, more_path)
  self.more_btn = self:AddComponent(UIButton, more_btn_path)
  self.more1_cover = self:AddComponent(UIImage, more1_cover_path)
  self.more2_cover = self:AddComponent(UIImage, more2_cover_path)
  self.more:SetActive(false)
  self.more_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:SetCurrentPage(self.currentPage + 1)
  end)
  self.showDrag = false
  self.showDes = false
  self.animatorIndex = 1
  self.currentPage = 1
  self.showTab = true
  self.cellList = {}
  self.timer = nil
  
  function self.timer_action(temp)
    self:ShowTabEnterAnimator()
  end
  
  self.startPlant = false
  self.content_alpha:SetAlpha(1)
  self.needResetOpen = false
  self.currentItemIndex = -1
  self.productLevelState = self:AddComponent(UIProductLevelState, productLevelState_path)
end

local function OnDestroy(self)
  DataCenter.RecommendShowManager:ResetState()
  EventManager:GetInstance():Broadcast(EventId.CloseGuideMoveArrow)
  if self.needResetOpen then
    self.needResetOpen = nil
    EventManager:GetInstance():Broadcast(EventId.GuideNoOpenUI, false)
  end
  self.search_obj = nil
  self.tab_img = nil
  self.tab_content = nil
  self.content_anim = nil
  self.drag_item_img = nil
  self.animator = nil
  self.animatorIndex = nil
  self.currentPage = nil
  self.timer_action = nil
  self.tab_img2 = nil
  self.tab_img3 = nil
  self.tab_img4 = nil
  self.tab_img5 = nil
  self.targetId = nil
  self.gray_img = nil
  self.light_img = nil
  self.grayMaterial = nil
  self.lightMaterial = nil
  self.more = nil
  self.more_btn = nil
  self.more1_cover = nil
  self.more2_cover = nil
  EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIFarm)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  local param = {}
  param.list = {
    ResourceType.Water
  }
  param.uiName = UIWindowNames.UIFarm
  EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
  local UIMain = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
  UIMain.View.anim:Play("ShowPlayer", 0, 0)
  self:UpdateView(self:GetUserData())
end

local function OnRefreshSignal(self, data)
  self:UpdateView(data)
end

local function UpdateView(self, data, targetId)
  self.buildUuid = tonumber(data)
  local info = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
  if info ~= nil then
    local pointId = info.pointId
    local worldPos = SceneUtils.TileIndexToWorld(pointId)
    local pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
    self.tab_obj.transform.position = pos
  end
  EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShowEffect, tostring(self.buildUuid))
  self.targetId = targetId or DataCenter.RecommendShowManager:GetPanelShowPara(RecommendShowType.FarmPlant)
  self.ctrl:InitData(self.buildUuid)
  self:RefreshProductLevel()
  self:SetData()
end

local function OnDisable(self)
  base.OnDisable(self)
  EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHideEffect)
end

local function SetAllCellDestroy(self)
  self.tab_content:RemoveComponents(FarmResourceItemNew)
  self.tab_content:RemoveComponents(FarmGatherItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cellList = {}
  self.animatorIndex = 1
end

local function SetCurrentPage(self, page)
  local total = #self.list
  if total == 0 then
    return
  end
  local maxPage = math.ceil(total / max_num_per_page)
  if page > maxPage then
    page = 1
  end
  page = math.min(maxPage, math.max(1, page))
  self.currentPage = page
  self:RefreshCurrentPage()
end

local function RefreshCurrentPage(self)
  self:SetAllCellDestroy()
  self.model = {}
  local count = 0
  if self.list ~= nil then
    count = #self.list
    local firstLockedFlag = false
    table.walk(self.list, function(k, v)
      if firstLockedFlag then
        return
      end
      if k <= (self.currentPage - 1) * max_num_per_page or k > self.currentPage * max_num_per_page then
        return
      end
      if v.farmState == FarmStateType.Plant then
        self.model[k] = self:GameObjectInstantiateAsync(UIAssets.FarmResourceItemNew, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self.tab_content.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local nameStr = tostring(v.productId)
          go.name = nameStr
          local cell = self.tab_content:AddComponent(FarmResourceItemNew, nameStr)
          cell:RefreshData(v, self.targetId, self.grayMaterial, self.lightMaterial)
          table.insert(self.cellList, cell)
          self:ResetCellPosition()
          self:CheckGuide()
          self:CheckRecommend()
        end)
        if not v.lockStatus then
          firstLockedFlag = true
        end
      end
    end)
    self.tab_img2:SetActive(count <= 2)
    self.tab_img3:SetActive(count == 3)
    self.tab_img4:SetActive(count == 4)
    self.tab_img5:SetActive(5 <= count)
    self.animatorIndex = 1
    self:AddTimer()
  end
  if count > max_num_per_page then
    self.more:SetActive(true)
    self.more2_cover:SetActive(1 >= self.currentPage)
    self.more1_cover:SetActive(1 < self.currentPage)
  else
    self.more:SetActive(false)
  end
  self.search_obj:SetActive(self.showDes)
  self.drag_item_img:SetActive(self.showDrag)
  if 3 < count then
    self.productLevelState.transform.anchoredPosition = Vector3.New(-265, -9, 0)
  else
    self.productLevelState.transform.anchoredPosition = Vector3.New(-153, -92, 0)
  end
end

local function SetData(self)
  self.list = self.ctrl:GetItemList(self.currentItemIndex)
  self:RefreshCurrentPage()
end

local function ResetCellPosition(self)
  local total = #self.list
  if total <= table.count(UIFarmViewResourceItemPositions) then
    local pos = UIFarmViewResourceItemPositions[total]
    local totalPosNum = table.count(pos)
    table.walk(self.cellList, function(k, v)
      if k <= totalPosNum then
        v.transform.anchoredPosition = pos[k]
      else
        v.transform.anchoredPosition = pos[totalPosNum] + Vector3.New(200 * (k - totalPosNum), 0, 0)
      end
    end)
  else
    local pos = UIFarmViewResourceItemPositions[table.count(UIFarmViewResourceItemPositions)]
    local totalPosNum = table.count(pos)
    table.walk(self.cellList, function(k, v)
      if k <= totalPosNum then
        v.transform.anchoredPosition = pos[k]
      else
        v.transform.anchoredPosition = pos[totalPosNum] + Vector3.New(200 * (k - totalPosNum), 0, 0)
      end
    end)
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

local function ShowTabEnterAnimator(self)
  local cellCount = #self.cellList
  local dataCount = #self.list
  if dataCount == cellCount and 0 < cellCount then
    if cellCount >= self.animatorIndex then
      self.cellList[self.animatorIndex]:DoEnterAnim()
      self.animatorIndex = self.animatorIndex + 1
    else
      self:DeleteTimer()
    end
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    local time = self.content_anim:GetFloat("DuringTime")
    self.timer = TimerManager:GetInstance():GetTimer(time / 10, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
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

local function OnDragItem(self, eventData, itemData)
  if self.ctrl.isInGuide and itemData.productId ~= self.ctrl.needDragId then
    return
  end
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
    if itemData.farmState == FarmStateType.Plant or itemData.farmState == FarmStateType.Feed then
      if self.showDes then
        self.search_obj:SetPosition(curPos.x, curPos.y)
      end
    elseif itemData.farmState == FarmStateType.Irrigate then
      if self.showDes then
        self.search_obj:SetPosition(curPos.x, curPos.y)
      end
    elseif self.showDes then
      self.showDes = false
      self.search_obj:SetShowState(self.showDes)
    end
    if buildData ~= nil and buildData.uuid ~= nil then
      local bUuid = buildData.uuid
      if itemData.farmState == FarmStateType.Feed or itemData.farmState == FarmStateType.Plant then
        if bUuid == self.buildUuid or self.startPlant or self.ctrl.isInGuide then
          self.startPlant = true
          local queueData = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(bUuid)
          if queueData ~= nil then
            if not self.ctrl.isInGuide then
              if self.showDes then
                self.showDes = false
                self.search_obj:SetShowState(self.showDes)
              end
              if self.showTab then
                self.showTab = false
                self.content_alpha:SetAlpha(0)
                EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHideEffect)
              end
            end
            self.ctrl:OnDragTrigger(SceneUtils.TileIndexToWorld(buildData.pointId), itemData, queueData)
            if self.ctrl ~= nil and not self.ctrl.isInGuide then
              self:OnCancelItem()
            end
          end
        end
      elseif itemData.farmState == FarmStateType.Harvest or itemData.farmState == FarmStateType.HarvestSecond then
        local queueData = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(bUuid)
        if queueData ~= nil then
          if self.showDes then
            self.showDes = false
            self.search_obj:SetShowState(self.showDes)
          end
          if self.showTab then
            self.showTab = false
            self.content_alpha:SetAlpha(0)
            EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHideEffect)
          end
          self.ctrl:OnDragTrigger(SceneUtils.TileIndexToWorld(buildData.pointId), itemData, queueData)
          if queueData:GetQueueState() == NewQueueState.Finish then
          end
        end
      end
    end
  end
end

local function OnBeginDragItem(self, eventData, itemData)
  if itemData ~= nil then
    if self.ctrl.isInGuide and itemData.productId ~= self.ctrl.needDragId then
      return
    end
    self.drag_item_img:LoadSprite(itemData.icon)
    if itemData.sizeX ~= nil and itemData.sizeY ~= nil then
      self.drag_item_img.rectTransform:Set_sizeDelta(itemData.sizeX, itemData.sizeY)
    end
    self.showDrag = true
    self.drag_item_img:SetActive(self.showDrag)
  end
end

local function OnEndDragItem(self, eventData, itemData)
  if self.ctrl.isInGuide and itemData.productId ~= self.ctrl.needDragId then
    return
  end
  self.showDrag = false
  self.drag_item_img:SetActive(self.showDrag)
  self.ctrl:OnDragFinish(itemData)
  self.startPlant = false
end

local function OnHoldItem(self, itemData, posX, posY)
  if itemData.hasDes then
    self.showDes = true
    if self.search_obj:GetActive() == false then
      self.search_obj:SetActive(true)
    end
    self.search_obj:SetShowState(self.showDes)
    self.search_obj:RefreshData(itemData, posX, posY)
  end
end

local function OnCancelItem(self)
  if self.showDes then
    self.showDes = false
    self.search_obj:SetShowState(self.showDes)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshFarmUI, self.OnRefreshSignal)
  self:AddUIListener(EventId.RefreshRecommendShow, self.RefreshRecommendShowSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshFarmUI, self.OnRefreshSignal)
  self:RemoveUIListener(EventId.RefreshRecommendShow, self.RefreshRecommendShowSignal)
end

local function CheckGuide(self)
  self.ctrl.isInGuide = false
  local guideType = DataCenter.GuideManager:GetGuideType()
  if guideType == GuideType.PlantFarm then
    local para1 = DataCenter.GuideManager:GetGuideTemplateParam("para1")
    if para1 ~= nil and para1 ~= "" then
      self.ctrl.isInGuide = true
      self.ctrl.guideHasFarmPoint = {}
      self.ctrl.guideLeftCount = 0
      local id = tonumber(para1)
      self.ctrl.needDragId = id
      for k, v in pairs(self.cellList) do
        if v.data.productId == id then
          local param = {}
          param.pointList = {}
          local para2 = DataCenter.GuideManager:GetGuideTemplateParam("para2")
          if para2 ~= nil and para2 ~= "" then
            local spl = string.split(para2, ";")
            local mainPos = DataCenter.BuildManager.main_city_pos
            self.guideStartPos = v:GetCenterPoint()
            local startParam = {}
            startParam.pointType = PositionType.Screen
            startParam.pointPosition = self.guideStartPos
            table.insert(param.pointList, startParam)
            for k2, v2 in ipairs(spl) do
              local spl1 = string.split(v2, ",")
              if table.count(spl) > 1 then
                local vec2 = CS.UnityEngine.Vector2Int(mainPos.x + tonumber(spl1[1]), mainPos.y + tonumber(spl1[2]))
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
          local image = v:GetIcon()
          if image ~= nil then
            param.sprite = image:GetImage()
            param.spriteSize = image:GetSizeDelta()
          end
          DataCenter.GuideManager:SetCompleteNeedParam(param)
          local para3 = DataCenter.GuideManager:GetGuideTemplateParam("para3")
          if para3 ~= nil and para3 ~= "" then
            self.ctrl.guideLeftCount = tonumber(para3)
          end
        end
      end
      EventManager:GetInstance():Broadcast(EventId.GuideNoOpenUI, true)
      self.needResetOpen = true
    end
  end
end

local function CheckRecommend(self)
  if DataCenter.RecommendShowManager:GetPanelShowPara(RecommendShowType.FarmPlant) ~= nil then
    for k, v in pairs(self.cellList) do
      if v.data.productId == self.targetId then
        local list = {}
        local waitAnimType = UIGuideMoveArrowNeedWaitType.No
        local recommendParam = DataCenter.RecommendShowManager:GetRecommendShowParam(RecommendShowType.FarmPlant)
        if recommendParam ~= nil then
          local buildIdList = DataCenter.QueueDataManager:GetBuildUuidInFreeQueueByType(NewQueueType.Field)
          if buildIdList ~= nil and table.count(buildIdList) > 0 then
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
        if table.count(list) > 0 then
          local param = {}
          param.pointList = {}
          local startParam = {}
          startParam.pointType = PositionType.Screen
          startParam.pointPosition = v:GetCenterPoint()
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
          local image = v:GetIcon()
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
  end
end

local function RefreshRecommendShowSignal(self)
  local info = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
  if info ~= nil then
    local pointId = info.pointId
    local worldPos = SceneUtils.TileIndexToWorld(pointId)
    local pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
    self.tab_obj.transform.position = pos
  end
  self.targetId = DataCenter.RecommendShowManager:GetPanelShowPara(RecommendShowType.FarmPlant)
  self:CheckRecommend()
end

local function RefreshProductLevel(self)
  local productLevels = self.ctrl:GetProductLevels()
  self.productLevelState:ReInit(productLevels, BindCallback(self, self.OnProductLevelClick))
  self.productLevelState:SetActive(table.count(productLevels) > 1)
end

local function OnProductLevelClick(self, currentIndex)
  self.currentItemIndex = currentIndex
  self:SetData()
end

UIFarmNewView.OnCreate = OnCreate
UIFarmNewView.OnDestroy = OnDestroy
UIFarmNewView.OnEnable = OnEnable
UIFarmNewView.OnDisable = OnDisable
UIFarmNewView.SetData = SetData
UIFarmNewView.OnDragItem = OnDragItem
UIFarmNewView.OnBeginDragItem = OnBeginDragItem
UIFarmNewView.OnEndDragItem = OnEndDragItem
UIFarmNewView.OnHoldItem = OnHoldItem
UIFarmNewView.OnCancelItem = OnCancelItem
UIFarmNewView.SetAllCellDestroy = SetAllCellDestroy
UIFarmNewView.UpdateView = UpdateView
UIFarmNewView.OnAddListener = OnAddListener
UIFarmNewView.OnRemoveListener = OnRemoveListener
UIFarmNewView.AddTimer = AddTimer
UIFarmNewView.DeleteTimer = DeleteTimer
UIFarmNewView.ShowTabEnterAnimator = ShowTabEnterAnimator
UIFarmNewView.ResetCellPosition = ResetCellPosition
UIFarmNewView.AdjustCameraPosition = AdjustCameraPosition
UIFarmNewView.Update = Update
UIFarmNewView.CheckGuide = CheckGuide
UIFarmNewView.OnRefreshSignal = OnRefreshSignal
UIFarmNewView.CheckRecommend = CheckRecommend
UIFarmNewView.SetCurrentPage = SetCurrentPage
UIFarmNewView.RefreshCurrentPage = RefreshCurrentPage
UIFarmNewView.RefreshRecommendShowSignal = RefreshRecommendShowSignal
UIFarmNewView.RefreshProductLevel = RefreshProductLevel
UIFarmNewView.OnProductLevelClick = OnProductLevelClick
return UIFarmNewView
