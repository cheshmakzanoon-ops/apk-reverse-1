local FactoryNeedResItem = require("UI.UIFactory.Component.FactoryNeedResItem")
local FactoryDesItem = BaseClass("FactoryDesItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local name_txt_path = "showMainObj/nameTxt"
local price_des_path = "showMainObj/priceDesTxt"
local need_res_list_path = "showMainObj/needResList"
local total_txt_path = "showMainObj/totalTxt"
local time_txt_path = "showMainObj/timeObj/needTimeTxt"
local show_main_obj_path = "showMainObj"
local need_science_obj_path = "needScienceObj"
local need_science_txt_path = "needScienceObj/needScienceDes"
local need_name_txt_path = "needScienceObj/needNameTxt"
local this_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self.show_main_obj = self:AddComponent(UIBaseContainer, show_main_obj_path)
  self.need_science_obj = self:AddComponent(UIBaseContainer, need_science_obj_path)
  self.need_res_list = self:AddComponent(UIBaseContainer, need_res_list_path)
  self.total_txt = self:AddComponent(UIText, total_txt_path)
  self.price_des = self:AddComponent(UIText, price_des_path)
  self.need_science_txt = self:AddComponent(UIText, need_science_txt_path)
  self.need_name_txt = self:AddComponent(UIText, need_name_txt_path)
  self.animator = self:AddComponent(UIAnimator, this_path)
end

local function OnDestroy(self)
  self.name_txt = nil
  self.time_txt = nil
  self.show_main_obj = nil
  self.need_science_obj = nil
  self.need_res_list = nil
  self.total_txt = nil
  self.price_des = nil
  self.need_science_txt = nil
  self.need_name_txt = nil
  self.animator = nil
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
  local needPlayerLevel = false
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
    elseif self.data.unlock_type == TemplateUnlockType.Career then
      local careerTemplate = DataCenter.PlayerCareerManager:GetCareerTemplate(self.data.needConditionId, self.data.needConditionLv)
      if careerTemplate ~= nil then
        local str = Localization:GetString(tostring(careerTemplate.name)) .. " " .. NumToRoman(self.data.needConditionLv)
        descText = Localization:GetString("395128", str)
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
    self.total_txt:SetText(Localization:GetString(GameDialogDefine.CAPACITY) .. ": " .. self.data.curNum)
    self.price_des:SetLocalText(390662, "")
    self:SetAllCellDestroy()
    if self.data.needGoodList ~= nil then
      self.modelCount = 0
      table.walk(self.data.needGoodList, function(k, v)
        self.modelCount = self.modelCount + 1
        self.model[self.modelCount] = self:GameObjectInstantiateAsync(UIAssets.FactoryNeedResItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self.need_res_list.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local nameStr = tostring(NameCount)
          go.name = nameStr
          NameCount = NameCount + 1
          local cell = self.need_res_list:AddComponent(FactoryNeedResItem, nameStr)
          cell:RefreshData(v)
        end)
      end)
    end
  end
end

local function SetAllCellDestroy(self)
  self.need_res_list:RemoveComponents(FactoryNeedResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
  self.modelCount = 0
end

local function SetPosition(self, posX, posY)
  local v3 = self.transform.position
  v3.x = posX
  v3.y = posY
  self.transform.position = v3
  local rectPos = self.rectTransform.anchoredPosition
  local x = rectPos.x
  local y = rectPos.y + 60
  local tempAnchoredPosition = Vector2.New(x, y)
  self.rectTransform.anchoredPosition = tempAnchoredPosition
end

FactoryDesItem.OnDestroy = OnDestroy
FactoryDesItem.OnCreate = OnCreate
FactoryDesItem.OnEnable = OnEnable
FactoryDesItem.OnDisable = OnDisable
FactoryDesItem.RefreshData = RefreshData
FactoryDesItem.SetShowState = SetShowState
FactoryDesItem.SetAllCellDestroy = SetAllCellDestroy
FactoryDesItem.SetPosition = SetPosition
return FactoryDesItem
