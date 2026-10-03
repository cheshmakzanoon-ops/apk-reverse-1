local AllianceWarPlayerSoliderItem = require("UI.UIAlliance.UIAllianceAlertDetail.Component.AllianceAlertSoliderItem")
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local AllianceAlertPlayerItem = BaseClass("AllianceAlertPlayerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local name_path = "mainContent/nameTxt"
local power_path = "mainContent/powerDesTxt/powerTxt"
local power_des_path = "mainContent/powerDesTxt"
local sl_Image_path = "mainContent/Image"
local slider_path = "mainContent/Image/Slider"
local progress_txt_path = "mainContent/Image/Slider/FillArea/progressTxt"
local time_txt_path = "mainContent/Image/Slider/FillArea/TimeTxt"
local state_path = "mainContent/stateTxt"
local show_btn_path = "mainContent/showButton"
local close_img_path = "mainContent/ImgArrowNormal"
local open_img_path = "mainContent/ImgArrowSelect"
local marchPos_btn_path = "mainContent/Btn_MarchPos"
local _content_rect = "mainContent/Content"
local content_path = "armyContent"
local playerHead_path = "mainContent/leftIcon/PlayIcon/UIPlayerHead/HeadIcon"
local playerHeadBg_path = "mainContent/leftIcon/PlayIcon/UIPlayerHead/Foreground"
local SliderLength = 141

local function OnCreate(self)
  base.OnCreate(self)
  self.isUpdate = false
  self.lastChangeTextDeltaTime = 0
  self.lastChangeImageDeltaTime = 0
  self.name = self:AddComponent(UIText, name_path)
  self.power = self:AddComponent(UIText, power_path)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.power_des:SetText(Localization:GetString("130068") .. ": ")
  self.state = self:AddComponent(UIText, state_path)
  self.state:SetLocalText(390141)
  self.close_img = self:AddComponent(UIImage, close_img_path)
  self.open_img = self:AddComponent(UIImage, open_img_path)
  self.show_btn = self:AddComponent(UIButton, show_btn_path)
  self.show_btn:SetOnClick(function()
    self:OnShowClick()
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.sl_Image = self:AddComponent(UIImage, sl_Image_path)
  self.progress_txt = self:AddComponent(UIText, progress_txt_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self._content_rect = self:AddComponent(UIBaseContainer, _content_rect)
  self.modelHero = {}
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.playerHead = self:AddComponent(UIPlayerHead, playerHead_path)
  self.playerHeadBg = self:AddComponent(UIImage, playerHeadBg_path)
  self.playerHeadBg.transform:SetAsLastSibling()
  self.marchPos_btn = self:AddComponent(UIButton, marchPos_btn_path)
  self.marchPos_btn:SetOnClick(function()
    self:OnClickPos()
  end)
  self.model = {}
end

local function OnDestroy(self)
  self:DeleteTimer()
  self:SetAllCellDestroy()
  self:SetAllCellDestroyHero()
  self.name = nil
  self.power = nil
  self.power_des = nil
  self.state = nil
  self.isUpdate = nil
  self.playerHead = nil
  base.OnDestroy(self)
end

local function RefreshData(self, data, isAlert)
  self.data = data
  self.marchPos_btn:SetActive(isAlert)
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self:AddTimer()
  self:RefreshTime()
  self:SetAllCellDestroyHero()
  self.showSolider = false
  self.name:SetText(data.baseInfo.ownerName)
  if data.baseInfo.allianceAbbr then
    self.name:SetText("[" .. data.baseInfo.allianceAbbr .. "]" .. data.baseInfo.ownerName)
  end
  self.playerHead:SetData(data.baseInfo.ownerUid, data.baseInfo.pic, data.baseInfo.picVer)
  if data.baseInfo.headFrame == 1 then
    self.playerHeadBg:SetActive(true)
  else
    self.playerHeadBg:SetActive(false)
  end
  self.open_img:SetActive(true)
  self.close_img:SetActive(false)
  self.content:SetActive(false)
  self._content_rect:RemoveComponents(UIHeroCellSmall)
  self.heroList = {}
  local list = data.armyInfo
  if next(list) then
    table.sort(list.heros, function(a, b)
      if a.heroQuality > b.heroQuality then
        return true
      elseif a.heroQuality == b.heroQuality then
        if a.heroLevel > b.heroLevel then
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
        cell:InitWithConfigId(list.heros[i].heroId, list.heros[i].heroQuality, list.heros[i].heroLevel, nil, list.heros[i].skillInfos, list.heros[i].rankId, list.heros[i].weaponLevel)
        self.heroList[i] = cell
      end)
    end
    local count = 0
    for i = 1, table.length(list.soldiers) do
      count = list.soldiers[i].total + count
    end
    self.power:SetText(string.GetFormattedSeperatorNum(count))
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  if self.data.baseInfo.status == MarchStatus.MOVING then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.data.baseInfo.endTime then
      local deltaTime = self.data.baseInfo.endTime - curTime
      local maxTime = self.data.baseInfo.endTime - self.data.baseInfo.startTime
      local tempValue = 1 - deltaTime / maxTime
      self.slider:SetValue(tempValue)
      self.state:SetActive(false)
      self.progress_txt:SetLocalText(390228)
      self.time_txt:SetActive(true)
      self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
      self.time_txt:SetActive(false)
      self:DeleteTimer()
      self.sl_Image:SetActive(false)
      self.state:SetActive(true)
      self.state:SetLocalText(141029)
    end
  else
    self.time_txt:SetActive(false)
    self:DeleteTimer()
    self.sl_Image:SetActive(false)
    self.state:SetActive(true)
    self.state:SetLocalText(141029)
  end
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

local function SetHeroAct(self)
  if self.heroList then
    for i = 1, #self.heroList do
      self.heroList[i]:SetActive(true)
    end
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
    local list = self.data.armyInfo
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
          cell:SetData(list.soldiers[i].armsId, list.soldiers[i].total)
        end)
      end
    end
  end
end

local function OnClickPos(self)
  local worldPos = SceneUtils.GetMarchCurPos(self.data.baseInfo)
  local pos = SceneUtils.WorldToTileIndex(worldPos, ForceChangeScene.World)
  local serverId = DataCenter.SeasonDataManager:GetNinePalacesServerByWorldPos(worldPos)
  self.view.ctrl:OnClickPosBtn(pos, true, self.data.uuid)
end

AllianceAlertPlayerItem.OnCreate = OnCreate
AllianceAlertPlayerItem.OnDestroy = OnDestroy
AllianceAlertPlayerItem.OnEnable = OnEnable
AllianceAlertPlayerItem.OnDisable = OnDisable
AllianceAlertPlayerItem.RefreshData = RefreshData
AllianceAlertPlayerItem.SetHeroAct = SetHeroAct
AllianceAlertPlayerItem.OnShowClick = OnShowClick
AllianceAlertPlayerItem.SetAllCellDestroy = SetAllCellDestroy
AllianceAlertPlayerItem.SetAllCellDestroyHero = SetAllCellDestroyHero
AllianceAlertPlayerItem.DeleteTimer = DeleteTimer
AllianceAlertPlayerItem.AddTimer = AddTimer
AllianceAlertPlayerItem.RefreshTime = RefreshTime
AllianceAlertPlayerItem.OnClickPos = OnClickPos
return AllianceAlertPlayerItem
