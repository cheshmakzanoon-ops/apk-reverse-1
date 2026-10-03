local FarmResourceItemNew = BaseClass("FarmResourceItemNew", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local img_path = "icon"
local num_path = "num_text"

local function OnCreate(self)
  base.OnCreate(self)
  self.img = self:AddComponent(UIImage, img_path)
  self.recommend_anim = self:AddComponent(UIAnimator, this_path)
  self.event_trigger = self:AddComponent(UIEventTrigger, this_path)
  self.numText = self:AddComponent(UIText, num_path)
  self.recommend_light_anim = self:AddComponent(UIAnimator, img_path)
  self.event_trigger:OnBeginDrag(function(eventData)
    if self:CheckIfNeedJump() then
      return
    end
    self:OnBeginDrag(eventData)
  end)
  self.event_trigger:OnDrag(function(eventData)
    if self:CheckIfNeedJump() then
      return
    end
    self:OnDrag(eventData)
  end)
  self.event_trigger:OnEndDrag(function(eventData)
    if self:CheckIfNeedJump() then
      return
    end
    self:OnEndDrag(eventData)
  end)
  self.event_trigger:OnPointerDown(function(eventData)
    if self:CheckIfNeedJump() then
      return
    end
    self:OnPointerDown(eventData)
  end)
  self.event_trigger:OnPointerUp(function(eventData)
    if self:CheckIfNeedJump() then
      return
    end
    self:OnPointerUp(eventData)
  end)
  self.event_trigger:OnPointerClick(function(eventData)
    if self:CheckIfNeedJump() then
      self:OnClickResourceItem()
    end
  end)
end

local function OnDestroy(self)
  self.event_trigger = nil
  self.img = nil
  self.recommend_anim = nil
  self.recommend_light_anim = nil
  base.OnDestroy(self)
end

local function OnDrag(self, eventData)
  self.view:OnDragItem(eventData, self.data)
end

local function OnBeginDrag(self, eventData)
  local checkState = true
  if self.data.unlock_type ~= nil then
    if self.data.unlock_type == TemplateUnlockType.Build then
      checkState = self.view.ctrl:CheckIsBuildEnough(self.data.needConditionId, self.data.needConditionLv)
    elseif self.data.unlock_type == TemplateUnlockType.Science then
      checkState = self.view.ctrl:CheckIsScienceEnough(self.data.needConditionId, self.data.needConditionLv)
    end
  end
  if not DataCenter.PlayerLevelManager:ReachLevel(self.data.unlock_player_level) then
    checkState = false
  end
  if self.data.farmState == FarmStateType.Harvest or self.data.farmState == FarmStateType.HarvestSecond then
    self.img.gameObject:SetActive(false)
    self.view:OnBeginDragItem(eventData, self.data)
  elseif checkState then
    self.img.gameObject:SetActive(false)
    self.view:OnBeginDragItem(eventData, self.data)
  end
end

local function OnEndDrag(self, eventData)
  self.img.gameObject:SetActive(true)
  self.view:OnEndDragItem(eventData, self.data)
end

local function OnPointerDown(self, eventData)
  if self.data ~= nil then
    local posX = self.img.transform.position.x
    local posY = self.img.transform.position.y
    self.view:OnHoldItem(self.data, posX, posY)
  end
end

local function OnClickResourceItem(self, eventData)
  UIUtil.ShowMessage(Localization:GetString("320345"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    GoToUtil.GoToMonthCard()
  end)
end

local function OnPointerUp(self, eventData)
  self.view:OnCancelItem()
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data, targetId, grayMaterial, lightMaterial)
  self.data = data
  if self.data ~= nil then
    local checkState = true
    if self.data.unlock_type ~= nil then
      if self.data.unlock_type == TemplateUnlockType.Build then
        checkState = self.view.ctrl:CheckIsBuildEnough(self.data.needConditionId, self.data.needConditionLv)
      elseif self.data.unlock_type == TemplateUnlockType.Science then
        checkState = self.view.ctrl:CheckIsScienceEnough(self.data.needConditionId, self.data.needConditionLv)
      elseif self.data.unlock_type == TemplateUnlockType.MonthCard then
        checkState = self.data.lockStatus
      elseif self.data.unlock_type == TemplateUnlockType.Talent then
        checkState = DataCenter.TalentDataManager:IsTalentOpen(self.data.needConditionId)
      end
    end
    if not DataCenter.PlayerLevelManager:ReachLevel(self.data.unlock_player_level) then
      checkState = false
    end
    self.img.gameObject:SetActive(true)
    self.img:LoadSprite(self.data.icon)
    local curNum = 0
    local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self.data.itemId)
    if itemData ~= nil then
      curNum = itemData.number
    end
    self.numText:SetText(string.GetFormattedSeperatorNum(curNum))
    if checkState == false then
      self.img:SetMaterial(grayMaterial)
    elseif targetId == self.data.productId then
      self.img:SetMaterial(lightMaterial)
      self.img_hdr = self:AddComponent(GetHDRIntensity, img_path)
      self.img_hdr:Init(lightMaterial)
      self:PlayRecommendShowAnim()
    else
      self.img:SetMaterial(nil)
    end
  end
end

local function CheckIfNeedJump(self)
  if self.data and self.data.unlock_type == TemplateUnlockType.MonthCard and not self.data.lockStatus then
    return true
  end
end

local function DoEnterAnim(self)
end

local function GetCenterPoint(self)
  return self.img.transform.position
end

local function PlayRecommendShowAnim(self)
  self.recommend_anim:Play(RecommendShowAnimName[RecommendShowAnimType.Show], 0, 0)
  self.recommend_light_anim:Play(RecommendShowImgAnimName[RecommendShowAnimType.Show], 0, 0)
end

local function GetIcon(self)
  return self.img
end

FarmResourceItemNew.OnDestroy = OnDestroy
FarmResourceItemNew.OnCreate = OnCreate
FarmResourceItemNew.OnEnable = OnEnable
FarmResourceItemNew.OnDisable = OnDisable
FarmResourceItemNew.OnDrag = OnDrag
FarmResourceItemNew.OnBeginDrag = OnBeginDrag
FarmResourceItemNew.OnEndDrag = OnEndDrag
FarmResourceItemNew.OnPointerDown = OnPointerDown
FarmResourceItemNew.OnPointerUp = OnPointerUp
FarmResourceItemNew.RefreshData = RefreshData
FarmResourceItemNew.DoEnterAnim = DoEnterAnim
FarmResourceItemNew.GetCenterPoint = GetCenterPoint
FarmResourceItemNew.PlayRecommendShowAnim = PlayRecommendShowAnim
FarmResourceItemNew.GetIcon = GetIcon
FarmResourceItemNew.OnClickResourceItem = OnClickResourceItem
FarmResourceItemNew.CheckIfNeedJump = CheckIfNeedJump
return FarmResourceItemNew
