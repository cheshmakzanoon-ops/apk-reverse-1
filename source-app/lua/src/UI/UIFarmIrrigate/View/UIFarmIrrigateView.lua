local FarmIrrigateItem = require("UI.UIFarmIrrigate.Component.FarmIrrigateItem")
local UIFarmIrrigateView = BaseClass("UIFarmIrrigateView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local irrigate_obj_path = "tips"
local drag_item_img_path = "dragImg"
local item_img_path = "tips/item"
local remainTimeBg_path = "tips/remainTimesBg"
local remainTimes_path = "tips/remainTimesBg/remainTimes"
local recoverTime_path = "tips/recoverTime"
local desObj_path = "desObj"
local desTitle_path = "desObj/UIFarmshowMainObj/nameTxt"
local desTip_path = "desObj/UIFarmshowMainObj/need/desc"
local desTip1_path = "desObj/UIFarmshowMainObj/need/tipTxt1"
local desTip2_path = "desObj/UIFarmshowMainObj/need/tipTxt2"
local desNum1_path = "desObj/UIFarmshowMainObj/need/tipNum1"
local desNum2_path = "desObj/UIFarmshowMainObj/need/tipNum2"
local desTime_path = "desObj/UIFarmshowMainObj/need/timeTip/time"
local desTimeTip_path = "desObj/UIFarmshowMainObj/need/timeTip"

local function OnCreate(self)
  base.OnCreate(self)
  self.irrigate_obj = self:AddComponent(FarmIrrigateItem, irrigate_obj_path)
  self.drag_item_img = self:AddComponent(UIImage, drag_item_img_path)
  self.drag_item_img:SetActive(false)
  self.animator = self:AddComponent(UIAnimator, drag_item_img_path)
  self.item_img = self:AddComponent(UIAnimator, item_img_path)
  self.guide_item_img = self:AddComponent(UIImage, item_img_path)
  self.remainTimes = self:AddComponent(UIText, remainTimes_path)
  self.remainTimeBgN = self:AddComponent(UIText, remainTimeBg_path)
  self.recoverTimeN = self:AddComponent(UIText, recoverTime_path)
  self.descObjN = self:AddComponent(UIBaseContainer, desObj_path)
  self.descAnimN = self:AddComponent(UIAnimator, desObj_path)
  self.descTitleN = self:AddComponent(UIText, desTitle_path)
  self.descTipN = self:AddComponent(UIText, desTip_path)
  self.descTip1N = self:AddComponent(UIText, desTip1_path)
  self.descTip2N = self:AddComponent(UIText, desTip2_path)
  self.descNum1N = self:AddComponent(UIText, desNum1_path)
  self.descNum2N = self:AddComponent(UIText, desNum2_path)
  self.descTimeN = self:AddComponent(UIText, desTime_path)
  self.descTimeTipN = self:AddComponent(UIText, desTimeTip_path)
  self.isAllCareerEffectShow = false
  self.showDrag = false
  self.showTip = true
  self.needResetOpen = false
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Ground2, false)
end

local function OnDestroy(self)
  self.irrigate_obj = nil
  self.drag_item_img = nil
  self.item_img = nil
  self.animator = nil
  self.showDrag = nil
  self.showTip = nil
  self.guide_item_img = nil
  self.remainTimes = nil
  self.recoverTimeN = nil
  self.descObjN = nil
  self.descTitleN = nil
  self.descTip1N = nil
  self.descTip2N = nil
  self.descNum1N = nil
  self.descNum2N = nil
  self.descTimeN = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:UpdateView(self:GetUserData())
end

local function UpdateView(self, data)
  self.buildUuid = tonumber(data)
  local info = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
  if info ~= nil then
    local pointId = info.pointId
    local worldPos = SceneUtils.TileIndexToWorld(pointId)
    local pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
    self.irrigate_obj.transform.position = pos
  end
  EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShowEffect, tostring(self.buildUuid))
  self.ctrl:InitData(self.buildUuid)
  self:SetData()
end

local function OnDisable(self)
  EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHideEffect)
  EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIFarmIrrigate)
  base.OnDisable(self)
end

local function SetData(self)
  self.showTip = true
  local list = self.ctrl:GetItemList()
  if list ~= nil then
    self.irrigate_obj:RefreshData(list[1])
  end
  local remainTimes, recoverT = DataCenter.PlayerCareerManager:GetRemainIrrigationTimes(IrrigationType.Farmland)
  if 0 < remainTimes then
    UIGray.SetGray(self.item_img.transform, false, true)
    self.remainTimeBgN:SetActive(true)
    self.recoverTimeN:SetActive(false)
    self.remainTimes:SetText(remainTimes)
    self.recoverTimeN:SetText("")
  else
    UIGray.SetGray(self.item_img.transform, true, true)
    self.recoverTimeN:SetActive(true)
    self.remainTimeBgN:SetActive(false)
    self.remainTimes:SetText("")
    if 0 < recoverT then
      self.recoverTime = recoverT
    else
      self.recoverTime = nil
      self.recoverTimeN:SetText("")
    end
  end
end

local function Update(self)
  if self.recoverTime and self.recoverTime > 0 then
    local serverT = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.recoverTime - serverT
    if 0 < remainTime then
      self.recoverTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.recoverTimeN:SetText("")
    end
  else
    self.recoverTimeN:SetText("")
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
  local remainTimes, recoverT = DataCenter.PlayerCareerManager:GetRemainIrrigationTimes(IrrigationType.Farmland)
  if remainTimes <= 0 then
    self:OnEndDragItem(eventData, itemData)
  end
  if self.drag_item_img:GetActive() then
    local curPos = eventData.position
    local posV3 = Vector3.New(curPos.x, curPos.y, 0)
    if DataCenter.RecommendShowManager:IsCanMoving() then
      self:AdjustCameraPosition(curPos.x, curPos.y)
    end
    if self.showDes then
      self.showDes = false
      self:ShowDescObj(false)
    end
    self.drag_item_img.transform.position = posV3
    local tilePos = CS.SceneManager.World:GetRaycastGroundPoint(posV3)
    local posIndex = SceneUtils.WorldToTileIndex(tilePos)
    local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(posIndex)
    if buildData ~= nil and buildData.uuid ~= nil then
      local bUuid = buildData.uuid
      if itemData.farmState == FarmStateType.Irrigate then
        local queueData = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(bUuid)
        if queueData ~= nil then
          self.ctrl:OnDragTrigger(SceneUtils.TileIndexToWorld(buildData.pointId), itemData, queueData)
          if queueData:GetQueueState() == NewQueueState.Work then
            if self.ctrl ~= nil and not self.ctrl.isInGuide and self.showTip then
              self.showTip = false
              self.irrigate_obj:PlayMoveOutAnimator()
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
  local remainTimes, recoverT = DataCenter.PlayerCareerManager:GetRemainIrrigationTimes(IrrigationType.Farmland)
  if remainTimes <= 0 then
    self:OnEndDragItem(eventData, itemData)
  end
  if itemData ~= nil then
    self.drag_item_img:LoadSprite(itemData.icon)
    if itemData.sizeX ~= nil and itemData.sizeY ~= nil then
      self.drag_item_img.rectTransform:Set_sizeDelta(itemData.sizeX, itemData.sizeY)
    end
    self.showDrag = true
    self.drag_item_img:SetActive(self.showDrag)
    EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHideOnly)
    if self.isAllCareerEffectShow ~= true then
      DataCenter.CareerEffectManager:RefreshAll()
      self.isAllCareerEffectShow = true
    end
  end
end

local function OnEndDragItem(self, eventData, itemData)
  DataCenter.CareerEffectManager:RemoveAll()
  self.isAllCareerEffectShow = false
  self.showDrag = false
  self.drag_item_img:SetActive(self.showDrag)
  if not self.ctrl.isInGuide or table.count(self.ctrl.guideLeftPointIds) == 0 then
    self.ctrl:OnDragFinish(itemData)
  end
end

local function OnHoldItem(self, itemData, posX, posY)
  if itemData.hasDes then
    self.showDes = true
    self:ShowDescObj(true, posX, posY)
  end
end

local function OnCancelItem(self)
  if self.showDes then
    self.showDes = false
    self:ShowDescObj(false)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshFarmIrrigateUI, self.OnRefreshSignal)
  self:AddUIListener(EventId.RefreshRecommendShow, self.RefreshRecommendShowSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshFarmIrrigateUI, self.OnRefreshSignal)
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

local function ShowDescObj(self, isShow, posX, posY)
  if isShow then
    local irrigateInfo = DataCenter.PlayerCareerManager:GetIrrigationInfo(IrrigationType.Farmland)
    self:SetDescObjPosition(posX, posY)
    self.descObjN:SetActive(true)
    self.descTitleN:SetLocalText(395184)
    self.descTipN:SetLocalText(395411, irrigateInfo.maxTimes)
    self.descTip1N:SetLocalText(110040)
    self.descTip2N:SetLocalText(120121)
    self.descTimeTipN:SetLocalText(104199)
    self.descNum1N:SetText(irrigateInfo.cost)
    if irrigateInfo.remainTimes >= irrigateInfo.maxTimes then
      self.descTimeTipN:SetActive(false)
    else
      self.descTimeTipN:SetActive(true)
      self.descNum2N:SetText(irrigateInfo.remainTimes)
      local serverT = UITimeManager:GetInstance():GetServerTime()
      local nextRecoverT = irrigateInfo.lastRecoverTime + irrigateInfo.recoverTimeS * 1000 - serverT
      local allNeedT = (irrigateInfo.maxTimes - irrigateInfo.remainTimes - 1) * irrigateInfo.recoverTimeS * 1000 + nextRecoverT
      self.descTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(allNeedT))
    end
    self.descAnimN:Play("MenuOpen", 0, 0)
  else
    self.descAnimN:Play("MenuClose", 0, 0)
  end
end

local function SetDescObjPosition(self, posX, posY)
  local screenSizeW = Screen.width
  local screenSizeH = Screen.height
  local v3 = self.descObjN.transform.position
  local scale = screenSizeH / 750.0
  if posX < screenSizeW / 2 then
    posX = posX + (self.descObjN.rectTransform.rect.width + 85) * scale
  else
    posX = posX - 35 * scale
  end
  v3.x = posX
  v3.y = posY
  self.descObjN.transform.position = v3
  local rectPos = self.descObjN.rectTransform.anchoredPosition
  local x = rectPos.x
  local y = rectPos.y + 60
  local tempAnchoredPosition = Vector2.New(x, y)
  self.descObjN.rectTransform.anchoredPosition = tempAnchoredPosition
end

local function RefreshRecommendShowSignal(self)
  local info = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
  if info ~= nil then
    local pointId = info.pointId
    local worldPos = SceneUtils.TileIndexToWorld(pointId)
    local pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
    self.irrigate_obj.transform.position = pos
  end
  self:CheckRecommend()
end

UIFarmIrrigateView.OnCreate = OnCreate
UIFarmIrrigateView.OnDestroy = OnDestroy
UIFarmIrrigateView.OnEnable = OnEnable
UIFarmIrrigateView.OnDisable = OnDisable
UIFarmIrrigateView.SetData = SetData
UIFarmIrrigateView.OnDragItem = OnDragItem
UIFarmIrrigateView.OnBeginDragItem = OnBeginDragItem
UIFarmIrrigateView.OnEndDragItem = OnEndDragItem
UIFarmIrrigateView.OnHoldItem = OnHoldItem
UIFarmIrrigateView.OnCancelItem = OnCancelItem
UIFarmIrrigateView.UpdateView = UpdateView
UIFarmIrrigateView.OnAddListener = OnAddListener
UIFarmIrrigateView.OnRemoveListener = OnRemoveListener
UIFarmIrrigateView.AdjustCameraPosition = AdjustCameraPosition
UIFarmIrrigateView.Update = Update
UIFarmIrrigateView.CheckGuide = CheckGuide
UIFarmIrrigateView.OnRefreshSignal = OnRefreshSignal
UIFarmIrrigateView.CheckRecommend = CheckRecommend
UIFarmIrrigateView.ShowDescObj = ShowDescObj
UIFarmIrrigateView.SetDescObjPosition = SetDescObjPosition
UIFarmIrrigateView.RefreshRecommendShowSignal = RefreshRecommendShowSignal
return UIFarmIrrigateView
