local AllianceWarPlayerSoliderItem = require("UI.UIAlliance.UIAllianceWarDetail.Component.AllianceWarPlayerSoliderItem")
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local AllianceWarPlayerItem = BaseClass("AllianceWarPlayerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local leader_path = "mainContent/leader"
local name_path = "mainContent/nameTxt"
local power_path = "mainContent/powerDesTxt/powerTxt"
local state_path = "mainContent/stateTxt"
local sl_Image_path = "mainContent/sliderLayout/Image"
local slider_path = "mainContent/sliderLayout/Slider"
local progress_txt_path = "mainContent/sliderLayout/Slider/FillArea/progressTxt"
local time_txt_path = "mainContent/sliderLayout/Slider/FillArea/TimeTxt"
local cancel_btn_path = "mainContent/sliderLayout/returnButton"
local show_btn_path = "mainContent/showButton"
local close_img_path = "mainContent/ImgArrowNormal"
local open_img_path = "mainContent/ImgArrowSelect"
local _content_rect = "mainContent/Content"
local leader_img_path = "mainContent/Img_leader"
local content_path = "armyContent"
local playerHead_path = "mainContent/leftIcon/PlayIcon/UIPlayerHead/HeadIcon"
local playerHeadBg_path = "mainContent/leftIcon/PlayIcon/UIPlayerHead/Foreground"
local SliderLength = 141

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self:SetUuid(uuid)
  self.isUpdate = false
  self.lastChangeTextDeltaTime = 0
  self.lastChangeImageDeltaTime = 0
  self.leader_icon = self:AddComponent(UIImage, leader_path)
  self.name = self:AddComponent(UIText, name_path)
  self.power = self:AddComponent(UIText, power_path)
  self.state = self:AddComponent(UIText, state_path)
  self.state:SetLocalText(390141)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.sl_Image = self:AddComponent(UIBaseContainer, sl_Image_path)
  self.progress_txt = self:AddComponent(UIText, progress_txt_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self.close_img = self:AddComponent(UIImage, close_img_path)
  self.open_img = self:AddComponent(UIImage, open_img_path)
  self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
  self.cancel_btn:SetOnClick(function()
    self:OnCancelClick()
  end)
  self.show_btn = self:AddComponent(UIButton, show_btn_path)
  self.show_btn:SetOnClick(function()
    self:OnShowClick()
  end)
  self.heroCell = self.transform:Find("UIHeroCellSmall")
  self._content_rect = self:AddComponent(UIBaseContainer, _content_rect)
  self.modelHero = {}
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self._leader_img = self:AddComponent(UIImage, leader_img_path)
  self.playerHead = self:AddComponent(UIPlayerHead, playerHead_path)
  self.playerHeadBg = self:AddComponent(UIImage, playerHeadBg_path)
  self.playerHeadBg.transform:SetAsLastSibling()
  self.model = {}
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self:SetAllCellDestroyHero()
  self.leader_icon = nil
  self.name = nil
  self.power = nil
  self.state = nil
  self.slider = nil
  self.progress_txt = nil
  self.time_txt = nil
  self.cancel_btn = nil
  self.isUpdate = nil
  self.playerHead = nil
  base.OnDestroy(self)
end

local function RefreshData(self, helpData)
  self:SetAllCellDestroyHero()
  self.helpData = helpData
  self.showSolider = false
  self.isUpdate = false
  self.lastChangeTextDeltaTime = 0
  self.lastChangeImageDeltaTime = 0
  self.dataInfo = self.view.ctrl:GetPlayerItemData(self.uuid, helpData)
  self.name:SetText(self.dataInfo.ownerName)
  self.cancel_btn:SetActive(self.dataInfo.cancel and self.view.ctrl:GetInMarchState(self.view.ctrl:GetSelfUuid()) == false)
  if helpData then
    self._leader_img:SetActive(false)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.cancel_btn:SetActive(self.dataInfo.cancel and curTime > self.dataInfo.endTime)
  else
    self._leader_img:SetActive(self.dataInfo.leader)
  end
  if self.dataInfo.status == MarchStatus.IN_TEAM or self.dataInfo.status == MarchStatus.WAIT_RALLY or self.dataInfo.leader then
    if self.state:GetActive() == false then
      self.state:SetActive(true)
    end
    if self.sl_Image:GetActive() then
      self.sl_Image:SetActive(false)
      self.slider:SetActive(false)
    end
  else
    if self.state:GetActive() then
      self.state:SetActive(false)
    end
    if self.sl_Image:GetActive() == false then
      self.sl_Image:SetActive(true)
      self.slider:SetActive(true)
    end
    self:UpdateSlider()
  end
  self.playerHead:SetData(self.dataInfo.ownerUid, self.dataInfo.ownerIcon, self.dataInfo.ownerIconVer)
  if self.dataInfo.headBg then
    self.playerHeadBg:SetActive(true)
  else
    self.playerHeadBg:SetActive(false)
  end
  self.open_img:SetActive(true)
  self.close_img:SetActive(false)
  self.content:SetActive(false)
  self._content_rect:RemoveComponents(UIHeroCellSmall)
  local list = self.view.ctrl:GetPlayerSoldierData(self.uuid, helpData)
  if next(list) then
    table.sort(list.heros, function(a, b)
      if a.quality > b.quality then
        return true
      elseif a.quality == b.quality then
        if a.lv > b.lv then
          return true
        end
        return false
      end
    end)
    for i = 1, table.length(list.heros) do
      self.modelHero[i] = self:GameObjectInstantiateAsync(UIAssets.AllianceHeroCell, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self._content_rect.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "item" .. i
        go.transform:GetChild(0).name = "cell" .. i
        go.transform:GetChild(0).gameObject:SetActive(true)
        local cell = self._content_rect:AddComponent(UIHeroCellSmall, go.transform:GetChild(0).gameObject)
        cell:InitWithConfigId(list.heros[i].heroId, list.heros[i].quality, list.heros[i].lv, nil, list.heros[i].skillInfos, list.heros[i].rankId, list.heros[i].weaponLevel)
      end)
    end
    local count = 0
    for i = 1, table.length(list.soldiers) do
      count = list.soldiers[i].count + count
    end
    self.power:SetText(Localization:GetString("130068") .. string.GetFormattedSeperatorNum(count))
  end
end

local function SetUuid(self, uuid)
  self.uuid = uuid
end

local function UpdateSlider(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = 0
  local maxTime = 0
  local dialog = Localization:GetString("390228")
  if curTime < self.dataInfo.endTime then
    self.isUpdate = true
    deltaTime = self.dataInfo.endTime - curTime
    maxTime = self.dataInfo.endTime - self.dataInfo.startTime
  else
    self.isUpdate = false
  end
  if self.isUpdate then
    if TimeBarUtil.CheckIsNeedChangeBar(deltaTime, self.lastChangeImageDeltaTime, maxTime, SliderLength) then
      self.lastChangeImageDeltaTime = deltaTime
      local tempValue = 1 - deltaTime / maxTime
      self.slider:SetValue(tempValue)
    end
    if TimeBarUtil.CheckIsNeedChangeText(deltaTime, self.lastChangeTextDeltaTime) then
      self.lastChangeTextDeltaTime = deltaTime
      self.progress_txt:SetActive(true)
      self.progress_txt:SetText(dialog)
      self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    end
  else
    self.progress_txt:SetActive(false)
    self.lastChangeTextDeltaTime = 0
    self.lastChangeImageDeltaTime = 0
    self.isUpdate = false
    if self.state:GetActive() == false then
      self.state:SetActive(true)
    end
    if self.sl_Image:GetActive() then
      self.sl_Image:SetActive(false)
      self.slider:SetActive(false)
    end
    if self.helpData then
      self.cancel_btn:SetActive(self.dataInfo.cancel)
    end
  end
end

local function Update(self)
  if self.isUpdate then
    self:UpdateSlider()
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self.content:RemoveComponents(AllianceWarPlayerSoliderItem)
  self._content_rect:RemoveComponents(UIHeroCellSmall)
  base.OnDisable(self)
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(AllianceWarPlayerSoliderItem)
  if next(self.model) then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function SetAllCellDestroyHero(self)
  self._content_rect:RemoveComponents(UIHeroCellSmall)
  if next(self.modelHero) then
    for k, v in pairs(self.modelHero) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.modelHero = {}
end

local function OnCancelClick(self)
  local selfUid = LuaEntry.Player.uid
  if self.dataInfo.ownerUid == selfUid then
    if self.dataInfo.attackUid == selfUid then
      UIUtil.ShowMessage(Localization:GetString("110151", self.dataInfo.ownerName), 2, nil, nil, function()
        self.view.ctrl:OnCancelClick(self.view.ctrl.uuid)
      end, nil, nil)
    elseif self.helpData then
      UIUtil.ShowMessage(Localization:GetString("141065", self.dataInfo.ownerName), 2, nil, nil, function()
        self.view.ctrl:OnLevelClick(self.uuid, self.helpData.targetUuid)
      end, nil, nil)
    else
      UIUtil.ShowMessage(Localization:GetString("141065", self.dataInfo.ownerName), 2, nil, nil, function()
        self.view.ctrl:OnRetreatClicks(self.uuid)
      end, nil, nil)
    end
  else
    UIUtil.ShowMessage(Localization:GetString("300515", self.dataInfo.ownerName), 2, nil, nil, function()
      self.view.ctrl:OnRetreatClicks(self.uuid)
    end, nil, nil)
  end
end

local function OnShowClick(self)
  self:SetAllCellDestroy()
  if self.showSolider then
    self.open_img:SetActive(true)
    self.close_img:SetActive(false)
    self.content:SetActive(false)
    self.showSolider = false
  else
    self.open_img:SetActive(false)
    self.close_img:SetActive(true)
    self.content:SetActive(true)
    self.showSolider = true
    local list = self.view.ctrl:GetPlayerSoldierData(self.uuid, self.helpData)
    if next(list) then
      table.sort(list.soldiers, function(a, b)
        local aData = DataCenter.ArmyTemplateManager:GetArmyTemplate(tonumber(a.armsId))
        local bData = DataCenter.ArmyTemplateManager:GetArmyTemplate(tonumber(b.armsId))
        if aData.level > bData.level then
          return true
        elseif aData.level == bData.level then
          if aData.arm > bData.arm then
            return true
          end
          return false
        end
      end)
      for i = 1, table.length(list.soldiers) do
        self.model[i] = self:GameObjectInstantiateAsync(UIAssets.AllianceWarPlayerSoliderItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go:SetActive(true)
          go.transform:SetParent(self.content.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.name = "item" .. i
          local cell = self.content:AddComponent(AllianceWarPlayerSoliderItem, go.name)
          cell:SetData(list.soldiers[i].data, list.soldiers[i].count)
        end)
      end
    end
  end
end

AllianceWarPlayerItem.OnCreate = OnCreate
AllianceWarPlayerItem.OnDestroy = OnDestroy
AllianceWarPlayerItem.OnEnable = OnEnable
AllianceWarPlayerItem.OnDisable = OnDisable
AllianceWarPlayerItem.RefreshData = RefreshData
AllianceWarPlayerItem.SetUuid = SetUuid
AllianceWarPlayerItem.UpdateSlider = UpdateSlider
AllianceWarPlayerItem.Update = Update
AllianceWarPlayerItem.OnCancelClick = OnCancelClick
AllianceWarPlayerItem.OnShowClick = OnShowClick
AllianceWarPlayerItem.SetAllCellDestroy = SetAllCellDestroy
AllianceWarPlayerItem.SetAllCellDestroyHero = SetAllCellDestroyHero
return AllianceWarPlayerItem
