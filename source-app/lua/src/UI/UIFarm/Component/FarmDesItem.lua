local FarmDesItem = BaseClass("FarmDesItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local name_txt_path = "UIFarmshowMainObj/nameTxt"
local time_txt_path = "UIFarmshowMainObj/need/needTimeTxt"
local show_main_obj_path = "UIFarmshowMainObj"
local need_science_obj_path = "needScienceObj"
local res_img_path = "UIFarmshowMainObj/need/needResIcon"
local price_txt_path = "UIFarmshowMainObj/need/priceTxt"
local price_des_path = "UIFarmshowMainObj/need/priceDesTxt"
local num_txt_path = "UIFarmshowMainObj/need/numTxt"
local num_des_path = "UIFarmshowMainObj/need/numDesTxt"
local goods_img_path = "UIFarmshowMainObj/need/productIcon"
local need_science_txt_path = "needScienceObj/needScienceDes"
local need_name_txt_path = "needScienceObj/needNameTxt"
local arrow_left_path = "UIFarmshowMainObj/arrow_left"
local arrow_right_path = "UIFarmshowMainObj/arrow_right"
local this_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self.show_main_obj = self:AddComponent(UIBaseContainer, show_main_obj_path)
  self.need_science_obj = self:AddComponent(UIBaseContainer, need_science_obj_path)
  self.price_txt = self:AddComponent(UIText, price_txt_path)
  self.num_txt = self:AddComponent(UIText, num_txt_path)
  self.res_img = self:AddComponent(UIImage, res_img_path)
  self.goods_img = self:AddComponent(UIImage, goods_img_path)
  self.price_des = self:AddComponent(UIText, price_des_path)
  self.num_des = self:AddComponent(UIText, num_des_path)
  self.need_science_txt = self:AddComponent(UIText, need_science_txt_path)
  self.need_name_txt = self:AddComponent(UIText, need_name_txt_path)
  self.animator = self:AddComponent(UIAnimator, this_path)
  self.arrow_left = self:AddComponent(UIImage, arrow_left_path)
  self.arrow_right = self:AddComponent(UIImage, arrow_right_path)
end

local function OnDestroy(self)
  self.name_txt = nil
  self.time_txt = nil
  self.show_main_obj = nil
  self.need_science_obj = nil
  self.price_txt = nil
  self.num_txt = nil
  self.total_txt = nil
  self.res_img = nil
  self.goods_img = nil
  self.price_des = nil
  self.num_des = nil
  self.need_science_txt = nil
  self.need_name_txt = nil
  self.animator = nil
  self.arrow_left = nil
  self.arrow_right = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetShowState(self, isOpen)
  if isOpen then
    self.animator:Play("MenuOpen", 0, 0)
  else
    self.animator:Play("MenuClose", 0, 0)
  end
end

local function RefreshData(self, data, posX, posY)
  self:SetPosition(posX, posY)
  self.data = data
  self.name_txt:SetText(self.data.name)
  local checkState = true
  local needPlayerLevel = false
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
    needPlayerLevel = true
  end
  if checkState == false then
    self.show_main_obj:SetActive(false)
    self.need_science_obj:SetActive(true)
    self.need_name_txt:SetText(self.data.name)
    local descText = ""
    if needPlayerLevel then
      descText = Localization:GetString("120986", self.data.unlock_player_level)
    elseif self.data.unlock_type == TemplateUnlockType.Build then
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.data.needConditionId)
      if template then
        descText = Localization:GetString(GameDialogDefine.NEED_SOMETHING_REACH_SOMETHING, Localization:GetString(template.name), self.data.needConditionLv)
      end
    elseif self.data.unlock_type == TemplateUnlockType.Science then
      local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.data.needConditionId, self.data.needConditionLv)
      if template then
        descText = Localization:GetString(GameDialogDefine.FARM_IS_LOCK_SCIENCE, Localization:GetString(template.name), self.data.needConditionLv)
      end
    elseif self.data.unlock_type == TemplateUnlockType.Talent then
      local template = DataCenter.TalentTemplateManager:GetTemplate(self.data.needConditionId)
      if template then
        descText = Localization:GetString(GameDialogDefine.FARM_IS_LOCK_SCIENCE, template.name)
      end
    end
    if not string.IsNullOrEmpty(descText) then
      self.need_science_txt:SetText(descText)
    end
  else
    self.show_main_obj:SetActive(true)
    self.need_science_obj:SetActive(false)
    self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(self.data.produce_time))
    self.num_des:SetText(Localization:GetString("130067") .. ": ")
    self.price_des:SetLocalText(390662, "")
    self.num_txt:SetText(self.data.canGetItemNum)
    self.goods_img:LoadSprite(self.data.itemIcon)
    if self.data.needResourceType ~= nil then
      self.price_txt:SetText(self.data.needResourceNum)
      local resourceState = self.view.ctrl:CheckIsResourceEnough(self.data.needResourceType, self.data.needResourceNum, 1)
      if resourceState then
        self.price_txt:SetColor(BlueColor)
      else
        self.price_txt:SetColor(RedColor)
      end
      self.res_img:LoadSprite(self.data.needResourceIcon)
    elseif self.data.needGoodsId ~= nil then
      self.price_txt:SetText(self.data.needGoodsNum)
      local resourceState = self.view.ctrl:CheckIsResourceGoodsEnough(self.data.needGoodsId, self.data.needGoodsNum, 1)
      if resourceState then
        self.price_txt:SetColor(BlueColor)
      else
        self.price_txt:SetColor(RedColor)
      end
      self.res_img:LoadSprite(self.data.needGoodsIcon)
    end
  end
end

local function SetPosition(self, posX, posY)
  local screenSizeW = Screen.width
  local screenSizeH = Screen.height
  local v3 = self.transform.position
  local scale = screenSizeH / 750.0
  if posX < screenSizeW / 2 then
    posX = posX + (self.rectTransform.rect.width + 85) * scale
    self.arrow_left:SetActive(true)
    self.arrow_right:SetActive(false)
  else
    posX = posX - 35 * scale
    self.arrow_left:SetActive(false)
    self.arrow_right:SetActive(true)
  end
  v3.x = posX
  v3.y = posY
  self.transform.position = v3
  local rectPos = self.rectTransform.anchoredPosition
  local x = rectPos.x
  local y = rectPos.y + 60
  local tempAnchoredPosition = Vector2.New(x, y)
  self.rectTransform.anchoredPosition = tempAnchoredPosition
end

FarmDesItem.OnDestroy = OnDestroy
FarmDesItem.OnCreate = OnCreate
FarmDesItem.OnEnable = OnEnable
FarmDesItem.OnDisable = OnDisable
FarmDesItem.RefreshData = RefreshData
FarmDesItem.SetShowState = SetShowState
FarmDesItem.SetPosition = SetPosition
return FarmDesItem
