local UISubWayMapView = BaseClass("UISubWayMapView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local WorldToMaoScale = {x = 0.037, y = 0.031}
local MaxX = 410
local MaxY = 320
local offset = 27

function UISubWayMapView:OnCreate()
  base.OnCreate(self)
  self.marchInfo, self.ASubwayPos, self.BSubwayPos, self.buildLv, self.AorB = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UISubWayMapView:ComponentDefine()
  self._close_btn = self:AddComponent(UIButton, "UICommonMidPopUpTitle/CloseBtn")
  self._close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._return_btn = self:AddComponent(UIButton, "UICommonMidPopUpTitle/panel")
  self._return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._title_txt = self:AddComponent(UIText, "UICommonMidPopUpTitle/titleText")
  self._duration_txt = self:AddComponent(UIText, "Root/Rect_Left/Rect_CountDown/Txt_Duration")
  self._countDown_txt = self:AddComponent(UIText, "Root/Rect_Left/Rect_CountDown/Txt_CountDown")
  self._endTime_txt = self:AddComponent(UIText, "Root/Rect_Left/Txt_EndTime")
  self._rect_map = self:AddComponent(UIImage, "Root/Rect_Map")
  self._rect_a = self:AddComponent(UIBaseContainer, "Root/Rect_Map/Rect_A")
  self._rect_b = self:AddComponent(UIBaseContainer, "Root/Rect_Map/Rect_B")
  self._rect_march = self:AddComponent(UIBaseContainer, "Root/Rect_Map/Rect_March")
  self._img_line1 = self:AddComponent(UIBaseContainer, "Root/Rect_Map/Rect_B/Img_Line1")
  self._img_line2 = self:AddComponent(UIBaseContainer, "Root/Rect_Map/Rect_March/Img_Line2")
end

function UISubWayMapView:DataDefine()
  self._timer_march = nil
  
  function self._timer_action(temp)
    self:UpdateMarchTime()
  end
end

function UISubWayMapView:OnDestroy()
  self._img_line1.transform:SetParent(self._rect_b.transform)
  self._img_line2.transform:SetParent(self._rect_march.transform)
  self._close_btn = nil
  self._title_txt = nil
  self:DeleteMarchTimer()
  base.OnDestroy(self)
end

function UISubWayMapView:OnEnable()
  base.OnEnable(self)
end

function UISubWayMapView:OnDisable()
  base.OnDisable(self)
end

function UISubWayMapView:OnAddListener()
  base.OnAddListener(self)
end

function UISubWayMapView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISubWayMapView:ReInit()
  self._title_txt:SetLocalText(142516)
  self._duration_txt:SetLocalText(142503)
  if self.marchInfo then
    self.extraTime = 0
    if self.marchInfo:GetMarchStatus() == MarchStatus.IN_WORM_HOLE then
      self._endTime_txt:SetText(Localization:GetString("142504") .. UITimeManager:GetInstance():TimeStampToTimeForLocalSimple(self.marchInfo.endTime + self.extraTime))
      self:UpdateMarchTime()
      self:AddMarchTimer()
    elseif self.marchInfo:GetMarchTargetType() == MarchTargetType.GO_WORM_HOLE then
      local buildLvTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.APS_BUILD_WORMHOLE_MAIN, self.buildLv)
      local speed = self.marchInfo.speed * tonumber(buildLvTemplate.para1)
      local Distance = math.ceil(SceneUtils.TileDistance(SceneUtils.IndexToTilePos(self.ASubwayPos), SceneUtils.IndexToTilePos(self.BSubwayPos)))
      local time = Distance / speed
      self.extraTime = time * 1000
      self._endTime_txt:SetText(Localization:GetString("142504") .. UITimeManager:GetInstance():TimeStampToTimeForLocalSimple(self.marchInfo.endTime + self.extraTime))
      self:UpdateMarchTime()
      self:AddMarchTimer()
    else
      local targetPos = self.AorB == 1 and self.ASubwayPos or self.BSubwayPos
      local Distance1 = math.ceil(SceneUtils.TileDistance(SceneUtils.IndexToTilePos(targetPos), SceneUtils.WorldToTile(self.marchInfo:GetMarchCurPos())))
      local Distance2 = math.ceil(SceneUtils.TileDistance(SceneUtils.IndexToTilePos(self.ASubwayPos), SceneUtils.WorldToTile(self.BSubwayPos)))
      local time1 = 0
      if Distance1 < 2 then
        Distance1 = 0
      else
        time1 = Distance1 / self.marchInfo.speed
      end
      local buildLvTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.APS_BUILD_WORMHOLE_MAIN, self.buildLv)
      local speed = self.marchInfo.speed * tonumber(buildLvTemplate.para1)
      local time = Distance2 / speed
      self.extraTime = time * 1000 + time1 * 1000
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local deltaTime = self.extraTime + curTime
      self._countDown_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.extraTime))
      self._endTime_txt:SetText(Localization:GetString("142504") .. UITimeManager:GetInstance():TimeStampToTimeForLocalSimple(deltaTime))
    end
  end
  self:SetSubwayToUIPos()
end

function UISubWayMapView:SetSubwayToUIPos()
  local a = SceneUtils.TileIndexToWorld(self.ASubwayPos)
  local b = SceneUtils.TileIndexToWorld(self.BSubwayPos)
  local v3a = Vector3.New(a.x, a.y, a.z)
  local v3b = Vector3.New(b.x, b.y, b.z)
  local targetDir = v3b - v3a
  local dot = Vector3.Dot(Vector3.forward, Vector3.Normalize(targetDir))
  local dot1 = Vector3.Dot(Vector3.right, Vector3.Normalize(targetDir))
  local targetA = Vector2.New(a.x * WorldToMaoScale.x, a.z * WorldToMaoScale.y)
  local targetB = Vector2.New(b.x * WorldToMaoScale.x, b.z * WorldToMaoScale.y)
  local marchPos = Vector2.New(self.marchInfo.position.x * WorldToMaoScale.x, self.marchInfo.position.z * WorldToMaoScale.y)
  targetA.x = targetA.x >= MaxX and MaxX or targetA.x
  targetA.y = targetA.y >= MaxY and MaxY or targetA.y
  targetB.x = targetB.x >= MaxX and MaxX or targetB.x
  targetB.y = targetB.y >= MaxY and MaxY or targetB.y
  marchPos.x = marchPos.x >= MaxX and MaxX or marchPos.x
  marchPos.y = marchPos.y >= MaxY and MaxY or marchPos.y
  if targetA.x - targetB.x < offset and targetA.y - targetB.y < offset then
    if 0 < dot then
      targetB.y = targetB.y + 10
    elseif dot < 0 then
      targetB.y = targetB.y - 10
    end
    if 0 < dot1 then
      targetB.x = targetB.x + 10
    elseif dot1 < 0 then
      targetB.x = targetB.x - 10
    end
  end
  local angle1 = Mathf.Acos(Vector2.Dot(Vector2.Normalize({x = 0, y = 1}), Vector2.Normalize(targetA - targetB))) * Mathf.Rad2Deg
  local dot3 = Vector2.Dot(Vector2.right, Vector2.Normalize(targetA - targetB))
  if 0 < dot3 then
    angle1 = 0 - angle1
  end
  self._rect_a:SetAnchoredPosition(targetA)
  self._rect_b:SetAnchoredPosition(targetB)
  if self.marchInfo:GetMarchStatus() == MarchStatus.IN_WORM_HOLE then
    self._rect_march:SetActive(false)
    self._img_line2:SetActive(false)
  else
    self._rect_march:SetActive(true)
    self._rect_march:SetAnchoredPosition(marchPos)
  end
  local dis1 = SceneUtils.TileDistance(targetA, targetB)
  self._img_line1:SetSizeDelta({x = 10, y = dis1})
  self._img_line1:SetEulerAnglesXYZ(0, 0, angle1)
  self._img_line1.transform:SetParent(self._rect_map.transform)
  self._img_line1.transform:SetAsFirstSibling()
  self._img_line1:SetLocalScaleXYZ(1, 1, 1)
end

function UISubWayMapView:AddMarchTimer()
  if self._timer_march == nil then
    self._timer_march = TimerManager:GetInstance():GetTimer(1, self._timer_action, self, false, false, false)
    self._timer_march:Start()
  end
end

function UISubWayMapView:DeleteMarchTimer()
  if self._timer_march ~= nil then
    self._timer_march:Stop()
    self._timer_march = nil
  end
end

function UISubWayMapView:UpdateMarchTime()
  if self.marchInfo.endTime == 0 then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = 0
  deltaTime = self.marchInfo.endTime + self.extraTime - curTime
  self._countDown_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
  if deltaTime < 0 then
    self.ctrl:CloseSelf()
  end
end

return UISubWayMapView
