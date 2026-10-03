local UIAllianceRallyView = BaseClass("UIAllianceRallyView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen
local title_path = "ImgObj/titleTxt"
local des_path = "ImgObj/DesBg/desTxt"
local toggle1_path = "ImgObj/checkObj/item1"
local toggle2_path = "ImgObj/checkObj/item2"
local toggle3_path = "ImgObj/checkObj/item3"
local toggle4_path = "ImgObj/checkObj/item4"
local rally_txt_path = "ImgObj/rallyBtn/rallyText"
local rally_btn_path = "ImgObj/rallyBtn"
local left_path = "showPos/left"
local right_path = "showPos/right"
local top_path = "showPos/top"
local buttom_path = "showPos/buttom"
local show_pos_obj_path = "showPos"
local img_obj_path = "ImgObj"

local function OnCreate(self)
  base.OnCreate(self)
  local rallyType, point, uuid = self:GetUserData()
  self.uuid = tonumber(uuid)
  self.rallyType = tonumber(rallyType)
  self.targetPoint = tonumber(point)
  local list = self.ctrl:InitData()
  self.view_obj = self:AddComponent(UIBaseContainer, img_obj_path)
  self.show_pos_obj = self:AddComponent(UIBaseContainer, show_pos_obj_path)
  self.left_obj = self:AddComponent(UIBaseContainer, left_path)
  self.right_obj = self:AddComponent(UIBaseContainer, right_path)
  self.top_obj = self:AddComponent(UIBaseContainer, top_path)
  self.bottom_obj = self:AddComponent(UIBaseContainer, buttom_path)
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText(390575)
  self.des = self:AddComponent(UIText, des_path)
  self.des:SetLocalText(390138)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle1:SetIsOn(true)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toggle1.text = self.toggle1:AddComponent(UIText, "Text")
  self.toggle1.text:SetText(list[1] .. Localization:GetString("100165"))
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle2:SetIsOn(false)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toggle2.text = self.toggle2:AddComponent(UIText, "Text")
  self.toggle2.text:SetText(list[2] .. Localization:GetString("100165"))
  self.toggle3 = self:AddComponent(UIToggle, toggle3_path)
  self.toggle3:SetIsOn(false)
  self.toggle3:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toggle3.text = self.toggle3:AddComponent(UIText, "Text")
  self.toggle3.text:SetText(list[3] .. Localization:GetString("100165"))
  self.toggle4 = self:AddComponent(UIToggle, toggle4_path)
  self.toggle4:SetIsOn(false)
  self.toggle4:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toggle4.text = self.toggle4:AddComponent(UIText, "Text")
  self.toggle4.text:SetText(list[4] .. Localization:GetString("100165"))
  self.rally_btn = self:AddComponent(UIButton, rally_btn_path)
  self.rally_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickBtn()
  end)
  self.rally_txt = self:AddComponent(UIText, rally_txt_path)
  self.rally_txt:SetLocalText(300038)
  self.isUpdate = false
  self.frameCount = 0
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
end

local function OnDestroy(self)
  self.name = nil
  self.toggle1.text = nil
  self.toggle1 = nil
  self.toggle2.text = nil
  self.toggle2 = nil
  self.toggle3.text = nil
  self.toggle3 = nil
  self.toggle4.text = nil
  self.toggle4 = nil
  self.rally_btn = nil
  self.rally_txt = nil
  self.des = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ToggleControlBorS(self)
  self:SetPosition()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ToggleControlBorS(self)
  self.index = 0
  if self.toggle1:GetIsOn() then
    self.index = 1
  elseif self.toggle2:GetIsOn() then
    self.index = 2
  elseif self.toggle3:GetIsOn() then
    self.index = 3
  elseif self.toggle4:GetIsOn() then
    self.index = 4
  end
end

local function OnClickBtn(self)
  self.ctrl:OnClickRally(self.targetPoint, self.index, self.uuid, self.rallyType)
end

local function SetPosition(self)
  local troop = CS.SceneManager.World:GetTroop(self.uuid)
  if troop ~= nil then
    local troopPos = troop:GetPosition()
    local screenPos = CS.SceneManager.World:WorldToScreenPoint(troopPos)
    self.lastPos = screenPos
    local screenCenterPos = Vector3.New(Screen.width / 2, Screen.height / 2, 0)
    local deltaX = screenPos.x - screenCenterPos.x
    local deltaY = screenPos.y - screenCenterPos.y
    local absX = math.abs(deltaX)
    local absY = math.abs(deltaY)
    self.left_obj:SetActive(deltaX <= 0 and absX >= absY)
    self.right_obj:SetActive(0 < deltaX and absX >= absY)
    self.top_obj:SetActive(0 < deltaY and absX < absY)
    self.bottom_obj:SetActive(deltaY <= 0 and absX < absY)
    local rect = self.show_pos_obj.rectTransform.rect
    local verticalOffset = rect.height / 2 + 50
    local horizontalOffset = rect.width / 2 + 50
    local posOffset = Vector3.New(0, 0, 0)
    if self.left_obj:GetActive() then
      posOffset.x = horizontalOffset
    elseif self.right_obj:GetActive() then
      posOffset.x = -horizontalOffset
    elseif self.top_obj:GetActive() then
      posOffset.y = -verticalOffset
    elseif self.bottom_obj:GetActive() then
      posOffset.y = verticalOffset
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
    self.isUpdate = true
  end
end

local function Update(self)
  if not self.isUpdate then
    return
  end
  if math.fmod(self.frameCount, 2) ~= 0 then
    self.frameCount = 0
    return
  end
  self.frameCount = self.frameCount + 1
  self:UpdatePosition()
end

local function UpdatePosition(self)
  local troop = CS.SceneManager.World:GetTroop(self.uuid)
  if troop ~= nil then
    local troopPos = troop:GetPosition()
    local screenPos = CS.SceneManager.World:WorldToScreenPoint(troopPos)
    local offsetX = screenPos.x - self.lastPos.x
    local offsetY = screenPos.y - self.lastPos.y
    self.show_pos_obj.rectTransform.anchoredPosition = Vector2.New(self.show_pos_obj.rectTransform.anchoredPosition.x + offsetX, self.show_pos_obj.rectTransform.anchoredPosition.y + offsetY)
    self.view_obj.rectTransform.anchoredPosition = Vector2.New(self.view_obj.rectTransform.anchoredPosition.x + offsetX, self.view_obj.rectTransform.anchoredPosition.y + offsetY)
    self.lastPos = screenPos
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.MonsterMoveStart, self.OpenUpdate)
  self:AddUIListener(EventId.MonsterMoveEnd, self.CloseUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MonsterMoveStart, self.OpenUpdate)
  self:RemoveUIListener(EventId.MonsterMoveEnd, self.CloseUpdate)
end

local function OpenUpdate(self, uuid)
  if self.uuid == uuid then
    self.isUpdate = true
  end
end

local function CloseUpdate(self, uuid)
  if self.uuid == uuid then
    self.isUpdate = false
  end
end

UIAllianceRallyView.OnCreate = OnCreate
UIAllianceRallyView.OnDestroy = OnDestroy
UIAllianceRallyView.OnRefresh = OnRefresh
UIAllianceRallyView.OnEnable = OnEnable
UIAllianceRallyView.OnDisable = OnDisable
UIAllianceRallyView.ToggleControlBorS = ToggleControlBorS
UIAllianceRallyView.OnClickBtn = OnClickBtn
UIAllianceRallyView.SetPosition = SetPosition
UIAllianceRallyView.OpenUpdate = OpenUpdate
UIAllianceRallyView.CloseUpdate = CloseUpdate
UIAllianceRallyView.OnAddListener = OnAddListener
UIAllianceRallyView.OnRemoveListener = OnRemoveListener
UIAllianceRallyView.Update = Update
UIAllianceRallyView.UpdatePosition = UpdatePosition
return UIAllianceRallyView
