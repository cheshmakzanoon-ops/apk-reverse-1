local UIWorldDeclareListView = BaseClass("UIWorldDeclareListView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen

function UIWorldDeclareListView:OnCreate()
  base.OnCreate(self)
  local pointId, cityId = self:GetUserData()
  self.pointId = tonumber(pointId)
  self.cityId = cityId
  self.show_pos_obj = self:AddComponent(UIBaseContainer, "showPos")
  self.left_obj = self:AddComponent(UIBaseContainer, "showPos/left")
  self.right_obj = self:AddComponent(UIBaseContainer, "showPos/right")
  self.top_obj = self:AddComponent(UIBaseContainer, "showPos/top")
  self.bottom_obj = self:AddComponent(UIBaseContainer, "showPos/bottom")
  self.view_obj = self:AddComponent(UIBaseContainer, "Root")
  self.title = self:AddComponent(UIText, "Root/titleText")
  self.title:SetText(Localization:GetString("302326"))
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scrollView = self:AddComponent(UIScrollView, "Root/ScrollView")
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UIWorldDeclareListView:OnDestroy()
  self.pointId = nil
  self.view_obj = nil
  self.show_pos_obj = nil
  self.left_obj = nil
  self.right_obj = nil
  self.top_obj = nil
  self.bottom_obj = nil
  self.empty = nil
  self:ClearScroll()
  base.OnDestroy(self)
end

function UIWorldDeclareListView:OnAddListener()
  self:AddUIListener(EventId.ChangeCameraLod, self.UpdateLod)
end

function UIWorldDeclareListView:OnRemoveListener()
  self:RemoveUIListener(EventId.ChangeCameraLod, self.UpdateLod)
end

function UIWorldDeclareListView:OnEnable()
  base.OnEnable(self)
  self:ClearScroll()
  CS.SceneManager.World:SetUseInput(true)
  self:SetPosition()
  self:SetData()
end

function UIWorldDeclareListView:OnDisable()
  base.OnDisable(self)
end

function UIWorldDeclareListView:SetData()
  self.data = DataCenter.AllianceDeclareWarManager:GetWarDataByCityId(self.cityId)
  if next(self.data) then
    self.scrollView:SetTotalCount(#self.data)
    self.scrollView:RefillCells()
  end
end

function UIWorldDeclareListView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UIText, itemObj)
  if self.data[index].aId == LuaEntry.Player.allianceId then
    cellItem:SetText("<color=#5FA3ED>[" .. self.data[index].alAbbr .. "]</color>")
  else
    cellItem:SetText("<color=#fd5454>[" .. self.data[index].alAbbr .. "]</color>")
  end
end

function UIWorldDeclareListView:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UIText)
end

function UIWorldDeclareListView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIText)
end

function UIWorldDeclareListView:SetPosition()
  local curServerId = LuaEntry.Player:GetCurServerId()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local info = SeasonUtil.GetSeasonInfo(curServerId)
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId, curServerId)
  local theServerId = info:GetNinePalacesServer(cityTemplate.bigMapIndex)
  local worldPointPos = SceneUtils.TileIndexToWorld(toInt(self.pointId), ForceChangeScene.World, theServerId)
  local screenPos = CS.SceneManager.World:WorldToScreenPoint(worldPointPos)
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

function UIWorldDeclareListView:UpdateLod(lod)
  self.ctrl:CloseSelf()
end

return UIWorldDeclareListView
