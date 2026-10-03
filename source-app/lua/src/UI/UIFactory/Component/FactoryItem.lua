local FactoryItem = BaseClass("FactoryItem", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local img_path = "icon"
local gray_path = "Gray"
local lack_icon_path = "lackIcon"
local curNum_path = "num/num_text"
local Num_path = "num"
local open_effect_path = "VFX_ui_jiagongchang"
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.img = self:AddComponent(UIImage, img_path)
  self.animator = self:AddComponent(UIAnimator, this_path)
  self.iconAnimator = self:AddComponent(UIAnimator, img_path)
  self.gray_image = self:AddComponent(UIImage, gray_path)
  self.gray = self.gray_image:GetMaterial()
  self.lack_icon = self:AddComponent(UIImage, lack_icon_path)
  self.event_trigger = self:AddComponent(UIEventTrigger, this_path)
  self.curNum = self:AddComponent(UIText, curNum_path)
  self.curNumObj = self:AddComponent(UIImage, Num_path)
  self.open_effect = self:AddComponent(UIBaseContainer, open_effect_path)
  self.open_effect:SetActive(false)
  self.img:SetActive(true)
  self.curNumObj:SetActive(true)
  self.event_trigger:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.event_trigger:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.event_trigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.event_trigger:OnPointerDown(function(eventData)
    self:OnPointerDown(eventData)
  end)
  self.event_trigger:OnPointerUp(function(eventData)
    self:OnPointerUp(eventData)
  end)
end

local function OnDestroy(self)
  self.event_trigger = nil
  self.gray_image = nil
  self.gray = nil
  self.iconAnimator = nil
  self.lack_icon = nil
  self.img = nil
  self.unlock_obj = nil
  self.lock_obj = nil
  self.item_name = nil
  self.need_num = nil
  self.need_icon = nil
  self.lack_icon = nil
  self.need_num = nil
  self.lock_des = nil
  self.curNum = nil
  self:DeleteTimer()
  if self.openEffectTimer ~= nil then
    self.openEffectTimer:Stop()
    self.openEffectTimer = nil
  end
  base.OnDestroy(self)
end

local function OnDrag(self, eventData)
  self.view:OnDragItem(eventData, self.data)
end

local function OnBeginDrag(self, eventData)
  self.view:OnCloseArrow()
  self.iconAnimator:Enable(false)
  local checkState = true
  if self.data.unlock_type ~= nil then
    if self.data.unlock_type == TemplateUnlockType.Build then
      checkState = CommonUtil.CheckIsBuildEnough(self.data.needConditionId, self.data.needConditionLv)
    elseif self.data.unlock_type == TemplateUnlockType.Science then
      checkState = CommonUtil.CheckIsScienceEnough(self.data.needConditionId, self.data.needConditionLv)
    elseif self.data.unlock_type == TemplateUnlockType.Career then
      local selfCareer = DataCenter.PlayerCareerManager:GetCareerType()
      local selfCareerLv = DataCenter.PlayerCareerManager:GetCareerLv()
      checkState = self.data.needConditionId == selfCareer and selfCareerLv >= self.data.needConditionLv
    elseif self.data.unlock_type == TemplateUnlockType.Talent then
      checkState = DataCenter.TalentDataManager:IsTalentOpen(self.data.needConditionId)
    end
  end
  if not DataCenter.PlayerLevelManager:ReachLevel(self.data.unlock_player_level) then
    checkState = false
  end
  if checkState then
    self.canDrag = true
    if self.data.needGoodList ~= nil then
      table.walk(self.data.needGoodList, function(k, v)
        if v.needType == "good" then
          local result, diamondNum = DataCenter.ResourceItemDataManager:GetResourceItemBuyPriceTotal(v.needGoodsId, v.needGoodsNum)
          if result == false then
            self.canDrag = false
          end
        end
      end)
    end
    if self.canDrag == true then
      Logger.Log("Begin drag")
      self.view:OnBeginDragItem(eventData, self.data)
    else
      self.animator:Play("farm_tip_shake", 0, 0)
      self:ShowLackResWindow()
    end
  end
end

local function ShowLackResWindow(self)
  local showResLack, rss = self:GetResNeed()
  if showResLack == true then
    local lackTab = {}
    for k, v in pairs(rss) do
      local param = {}
      param.type = v.type
      if v.type == ResLackType.ResItem then
        param.itemId = k
      elseif v.type == ResLackType.Res then
        param.resType = k
      end
      param.targetNum = v.num
      table.insert(lackTab, param)
    end
    GoToResLack.GoToItemResLackList(lackTab)
  end
  return showResLack
end

local function GetResNeed(self)
  local tmp = {}
  if self.data.needGoodList ~= nil then
    for k, v in ipairs(self.data.needGoodList) do
      if v.needType == "good" then
        local result = DataCenter.ResourceItemDataManager:CheckResourceItemNum(v.needGoodsId, v.needGoodsNum)
        if result == false then
          tmp[v.needGoodsId] = {}
          tmp[v.needGoodsId].num = v.needGoodsNum
          tmp[v.needGoodsId].type = ResLackType.ResItem
        end
      elseif v.needType == "resource" and CommonUtil.CheckIsResourceEnough(v.needGoodsId, v.needGoodsNum) == false then
        tmp[v.needGoodsId] = {}
        tmp[v.needGoodsId].num = v.needGoodsNum
        tmp[v.needGoodsId].type = ResLackType.Res
      end
    end
  end
  return table.count(tmp) ~= 0, tmp
end

local function OnEndDrag(self, eventData)
  if self.view.isEnterBox == true and self.view.ctrl:CheckHasFreeQueue(self.view.factoryUid) == true then
    local tmp = {}
    table.walk(self.data.needGoodList, function(k, v)
      if v.needType == "good" then
        tmp[v.needGoodsId] = v.needGoodsNum
      end
    end)
    if self:ShowLackResWindow() == true then
      self.view:RemoveItemFromBox()
      self.view:OnEndDragItem(eventData, self.data)
      return
    end
    local param = DataCenter.ResourceItemDataManager:GetAllLackResourceItemParams(tmp, function()
      self.view:AddItemToBox()
      self.view:OnEndDragItem(eventData, self.data)
    end, function()
      self.view:OnEndDragItem(eventData, self.data)
    end)
    if param.canBuy == true and param.totalDiamond > 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceItemLack, {anim = true}, param)
    else
      self.view:OnEndDragItem(eventData, self.data)
    end
  else
    self.view:OnEndDragItem(eventData, self.data)
  end
end

local function OnPointerDown(self, eventData)
  if self.data ~= nil then
    local posX = self.img.transform.position.x
    local posY = self.img.transform.position.y
    self.view:OnHoldItem(self.data, posX, posY, self.checkState and self.canDrag)
    if self.checkState == true and self.canDrag == true then
      self.img:SetActive(false)
      self.curNumObj:SetActive(false)
    end
    if self.isArrow and not DataCenter.GuideManager:InGuide() then
      self:DeleteTimer()
      EventManager:GetInstance():Broadcast(EventId.CloseGuideMoveArrow)
    end
  end
  self.isArrow = false
end

local function OnPointerUp(self, eventData)
  self.view:OnCancelItem()
  if self.checkState == true then
    self.img:SetActive(true)
    self.curNumObj:SetActive(self.data.showNum)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self.animator:Play("CellChangeDefault", 0, 0)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data, productId)
  self.data = data
  self.isArrow = false
  if self.data ~= nil then
    local checkState = true
    if self.data.unlock_type ~= nil then
      if self.data.unlock_type == TemplateUnlockType.Build then
        checkState = CommonUtil.CheckIsBuildEnough(self.data.needConditionId, self.data.needConditionLv)
      elseif self.data.unlock_type == TemplateUnlockType.Science then
        checkState = CommonUtil.CheckIsScienceEnough(self.data.needConditionId, self.data.needConditionLv)
      elseif self.data.unlock_type == TemplateUnlockType.Career then
        local selfCareer = DataCenter.PlayerCareerManager:GetCareerType()
        local selfCareerLv = DataCenter.PlayerCareerManager:GetCareerLv()
        checkState = self.data.needConditionId == selfCareer and selfCareerLv >= self.data.needConditionLv
      elseif self.data.unlock_type == TemplateUnlockType.Talent then
        checkState = DataCenter.TalentDataManager:IsTalentOpen(self.data.needConditionId)
      end
    end
    if not DataCenter.PlayerLevelManager:ReachLevel(self.data.unlock_player_level) then
      checkState = false
    end
    self.checkState = checkState
    self.img:LoadSprite(self.data.icon)
    if checkState == false then
      self.img:SetMaterial(self.gray)
      self.lack_icon:SetActive(false)
      self.curNumObj:SetActive(false)
    else
      self.canDrag = true
      if self.data.needGoodList ~= nil then
        table.walk(self.data.needGoodList, function(k, v)
          if v.needType == "good" then
            local result, diamondNum = DataCenter.ResourceItemDataManager:GetResourceItemBuyPriceTotal(v.needGoodsId, v.needGoodsNum)
            if result == false then
              self.canDrag = false
            end
          end
        end)
      end
      if self.canDrag then
        self.lack_icon:SetActive(false)
        self.curNumObj:SetActive(self.data.showNum)
        self.img:SetMaterial(nil)
      else
        self.lack_icon:SetActive(false)
        self.curNumObj:SetActive(self.data.showNum)
        self.img:SetMaterial(self.gray)
      end
      local flag = DataCenter.FactoryDataManager:GetShowFactoryItemOpenFlag(self.data.productId)
      if flag then
        self:ShowOpenEffect()
      end
      self.curNum:SetText(self.data.curNum)
    end
  end
  if self.data.productId == productId then
    self.isArrow = true
    self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
      self:CheckRecommend()
    end, 0.5)
  end
end

local function DoEnterAnim(self)
  self.animator:Play("CellChangeForFactory", 0, 0)
end

local function GetGuideObj(self)
  return self.img.gameObject
end

local function GetGuideIcon(self)
  return self.img
end

local function DeleteTimer(self)
  if self.delayTime then
    self.delayTime:Stop()
    self.delayTime = nil
  end
end

local function CheckRecommend(self)
  if not DataCenter.GuideManager:InGuide() then
    local param = {}
    param.pointList = {}
    local startParam = {}
    startParam.pointType = PositionType.Screen
    startParam.pointObj = self:GetGuideObj()
    table.insert(param.pointList, startParam)
    local endParam = {}
    endParam.pointType = PositionType.Screen
    endParam.pointObj = self.view:GetGuideBox()
    table.insert(param.pointList, endParam)
    param.arrowtype = GuideArrowStyle.Finger
    param.arrowdirection = GuideArrowDirection.LeftDown
    local image = self:GetGuideIcon()
    if image ~= nil then
      param.sprite = image:GetImage()
      param.spriteSize = image:GetSizeDelta()
    end
    param.isRecommend = true
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideMoveArrow) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideMoveArrow, {anim = false, playEffect = false}, param)
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
    end
  end
end

local function ShowOpenEffect(self)
  local flag = DataCenter.FactoryDataManager:GetShowFactoryItemOpenFlag(self.data.productId)
  if flag then
    self.img:SetMaterial(self.gray)
    self.openEffectTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.open_effect:SetActive(true)
      self.openEffectTimer:Stop()
      self.openEffectTimer = nil
      self:RefreshData(self.data)
    end, 0.25)
    DataCenter.FactoryDataManager:RemoveShowFactoryItemOpenFlag(self.data.productId)
  end
end

FactoryItem.OnDestroy = OnDestroy
FactoryItem.OnCreate = OnCreate
FactoryItem.OnEnable = OnEnable
FactoryItem.OnDisable = OnDisable
FactoryItem.OnDrag = OnDrag
FactoryItem.OnBeginDrag = OnBeginDrag
FactoryItem.OnEndDrag = OnEndDrag
FactoryItem.OnPointerDown = OnPointerDown
FactoryItem.OnPointerUp = OnPointerUp
FactoryItem.RefreshData = RefreshData
FactoryItem.DoEnterAnim = DoEnterAnim
FactoryItem.GetGuideObj = GetGuideObj
FactoryItem.ShowLackResWindow = ShowLackResWindow
FactoryItem.GetResNeed = GetResNeed
FactoryItem.GetGuideIcon = GetGuideIcon
FactoryItem.CheckRecommend = CheckRecommend
FactoryItem.DeleteTimer = DeleteTimer
FactoryItem.ShowOpenEffect = ShowOpenEffect
return FactoryItem
