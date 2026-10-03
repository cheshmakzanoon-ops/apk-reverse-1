local UIActBossTipsView = BaseClass("UIActBossTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen

function UIActBossTipsView:OnCreate()
  base.OnCreate(self)
  local uuid, pointId = self:GetUserData()
  self.uuid = tonumber(uuid)
  self.pointId = tonumber(pointId)
  self.show_pos_obj = self:AddComponent(UIBaseContainer, "showPos")
  self.left_obj = self:AddComponent(UIBaseContainer, "showPos/left")
  self.right_obj = self:AddComponent(UIBaseContainer, "showPos/right")
  self.top_obj = self:AddComponent(UIBaseContainer, "showPos/top")
  self.bottom_obj = self:AddComponent(UIBaseContainer, "showPos/bottom")
  self.view_obj = self:AddComponent(UIBaseContainer, "Root")
  self.name_txt = self:AddComponent(UIText, "Root/NameTxt")
  self.pos_txt = self:AddComponent(UIText, "Root/posBg/distanceTxt")
  self.slider = self:AddComponent(UISlider, "Root/Slider")
  self.percent_txt = self:AddComponent(UIText, "Root/percentTxt")
  self.btn = self:AddComponent(UIButton, "Root/Button")
  self.btn:SetOnClick(function()
    self:OnGotoClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_txt = self:AddComponent(UIText, "Root/Button/btnTxt")
  self.btn_txt:SetLocalText(110003)
end

function UIActBossTipsView:OnDestroy()
  self.uuid = nil
  self.pointId = nil
  self.show_pos_obj = nil
  self.left_obj = nil
  self.right_obj = nil
  self.top_obj = nil
  self.bottom_obj = nil
  self.view_obj = nil
  self.name_txt = nil
  self.pos_txt = nil
  self.slider = nil
  self.percent_txt = nil
  self.btn = nil
  self.btn_txt = nil
  base.OnDestroy(self)
end

function UIActBossTipsView:OnAddListener()
  self:AddUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:AddUIListener(EventId.ShowActBossBattleValue, self.UpdateActBossBlood)
end

function UIActBossTipsView:OnRemoveListener()
  self:RemoveUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:RemoveUIListener(EventId.ShowActBossBattleValue, self.UpdateActBossBlood)
end

function UIActBossTipsView:OnEnable()
  base.OnEnable(self)
  CS.SceneManager.World:SetUseInput(true)
  self:SetPosition()
  self:SetData()
end

function UIActBossTipsView:OnDisable()
  base.OnDisable(self)
end

function UIActBossTipsView:SetData()
  self.data = DataCenter.ActBossDataManager:GetActBossDataByUuid(self.uuid)
  if self.data ~= nil then
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(self.data.monsterId)
    if monster ~= nil then
      local name = monster.name
      self.name_txt:SetLocalText(name)
    end
    local serverId = self.data.serverId
    local pos = SceneUtils.IndexToTilePos(self.data.startPos)
    if serverId then
      self.pos_txt:SetText(string.format("#%s (%s, %s)", serverId, pos.x, pos.y))
    else
      self.pos_txt:SetText(Localization:GetString(GameDialogDefine.SHOW_POS, pos.x, pos.y))
    end
  end
end

function UIActBossTipsView:SetBloodSlider(curBlood, maxBlood)
  local tempValue = math.min(curBlood / math.max(maxBlood, 1), 1)
  self.slider:SetValue(tempValue)
  self.percent_txt:SetText(string.GetFormattedPercentStr(tempValue))
end

function UIActBossTipsView:OnGotoClick()
  local pos = self.data.startPos
  local serverId = self.data.serverId
  self.view.ctrl:CloseSelf()
  GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(pos), CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, serverId, 0)
end

function UIActBossTipsView:SetPosition()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local screenPos = CS.SceneManager.World:WorldToScreenPoint(SceneUtils.TileIndexToWorld(self.pointId))
  self.lastPos = screenPos
  local screenCenterPos = Vector3.New(Screen.width / (2 * scaleFactor), Screen.height / (2 * scaleFactor), 0)
  local deltaX = screenPos.x - screenCenterPos.x
  local deltaY = screenPos.y - screenCenterPos.y
  local absX = math.abs(deltaX)
  local absY = math.abs(deltaY)
  self.left_obj:SetActive(deltaX <= 0 and absX >= absY)
  self.right_obj:SetActive(0 < deltaX and absX >= absY)
  self.top_obj:SetActive(0 < deltaY and absX < absY)
  self.bottom_obj:SetActive(deltaY <= 0 and absX < absY)
  local rect = self.show_pos_obj.rectTransform.rect
  local verticalOffset = rect.height / 2
  local horizontalOffset = rect.width / 2
  local posOffset = Vector3.New(0, 0, 0)
  if self.left_obj:GetActive() then
    posOffset.x = horizontalOffset + 70
  elseif self.right_obj:GetActive() then
    posOffset.x = -horizontalOffset - 70
  elseif self.top_obj:GetActive() then
    posOffset.y = -verticalOffset - 70
  elseif self.bottom_obj:GetActive() then
    posOffset.y = verticalOffset + 70
  end
  self.show_pos_obj.transform.position = screenPos
  local anchoredPosition = self.show_pos_obj.rectTransform.anchoredPosition
  local tempAnchoredPosition = Vector2.New(anchoredPosition.x + posOffset.x, anchoredPosition.y + posOffset.y)
  self.show_pos_obj.rectTransform.anchoredPosition = tempAnchoredPosition
  if 0 < tempAnchoredPosition.x then
    tempAnchoredPosition.x = math.min(tempAnchoredPosition.x + horizontalOffset, screenCenterPos.x) - horizontalOffset
  else
    tempAnchoredPosition.x = math.max(tempAnchoredPosition.x - horizontalOffset, -screenCenterPos.x) + horizontalOffset
  end
  if 0 < tempAnchoredPosition.y then
    tempAnchoredPosition.y = math.min(tempAnchoredPosition.y + verticalOffset, screenCenterPos.y) - verticalOffset
  else
    tempAnchoredPosition.y = math.max(tempAnchoredPosition.y - verticalOffset, -screenCenterPos.y) + verticalOffset
  end
  self.view_obj.rectTransform.anchoredPosition = tempAnchoredPosition
end

function UIActBossTipsView:UpdateLod(lod)
  self.ctrl:CloseSelf()
end

return UIActBossTipsView
