local AllianceWarPlayerSoliderItem = require("UI.UIAlliance.UIAllianceWarDetail.Component.AllianceWarPlayerSoliderItem")
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local UIHeroCell = require("UI.UIChatNew.Component.RadarAlarmCells.UIRadarHeroICell")
local UIRadarSoliderICell = require("UI.UIChatNew.Component.RadarAlarmCells.UIRadarSoliderICell")
local UIPersonalWarPlayerItem = BaseClass("UIPersonalWarPlayerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local leader_path = "mainContent/leader"
local name_path = "mainContent/nameTxt"
local power_path = "mainContent/powerDesTxt/powerTxt"
local power_des_path = "mainContent/powerDesTxt"
local state_path = "mainContent/stateTxt"
local slider_path = "mainContent/Image/Slider"
local progress_txt_path = "mainContent/Image/Slider/FillArea/progressTxt"
local time_txt_path = "mainContent/Image/Slider/FillArea/TimeTxt"
local cancel_btn_path = "mainContent/returnButton"
local show_btn_path = "mainContent/showButton"
local close_img_path = "mainContent/ImgArrowNormal"
local open_img_path = "mainContent/ImgArrowSelect"
local _content_rect = "mainContent/Content"
local leader_img_path = "mainContent/Img_leader"
local content_path = "armyContent"
local playerHead_btn_path = "mainContent/leftIcon/PlayIcon/UIPlayerHead"
local playerHead_path = "mainContent/leftIcon/PlayIcon/UIPlayerHead/HeadIcon"
local playerHeadBg_path = "mainContent/leftIcon/PlayIcon/UIPlayerHead/Foreground"

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self:SetUuid(uuid)
  self.name = self:AddComponent(UIText, name_path)
  self.power = self:AddComponent(UIText, power_path)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.power_des:SetText(Localization:GetString("130068") .. ": ")
  self._content_rect = self:AddComponent(UIBaseContainer, _content_rect)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.playerHead_btn = self:AddComponent(UIButton, playerHead_btn_path)
  self.playerHead_btn:SetOnClick(function()
    self:OnClickPlayerHeadBtn()
  end)
  self.playerHead = self:AddComponent(UIPlayerHead, playerHead_path)
  self.playerHeadBg = self:AddComponent(UIImage, playerHeadBg_path)
  self._leader_img = self:AddComponent(UIImage, leader_img_path)
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self:SetAllCellDestroyHero()
  self.otherPlayerUid = nil
  base.OnDestroy(self)
end

local function SetUuid(self, uuid)
  self.uuid = uuid
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self)
  self.modelHero = {}
  self:SetAllCellDestroyHero()
  self.dataInfo = self.view.ctrl:GetPlayerItemData(self.uuid)
  self.name:SetText(self.dataInfo.ownerName)
  self.otherPlayerUid = self.dataInfo.ownerUid
  self.playerHead:SetData(self.dataInfo.ownerUid, self.dataInfo.ownerIcon, self.dataInfo.ownerIconVer)
  if self.dataInfo.headBg then
    self.playerHeadBg:SetActive(true)
  else
    self.playerHeadBg:SetActive(false)
  end
  self._content_rect:RemoveComponents(UIHeroCellSmall)
  self._leader_img:SetActive(self.dataInfo.leader)
  local list = self.view.ctrl:GetPlayerSoldierData(self.uuid)
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
        local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(list.heros[i].heroId, list.heros[i].rankLv, list.heros[i].stage)
        cell:InitWithConfigId(list.heros[i].heroId, list.heros[i].quality, list.heros[i].lv, nil, list.heros[i].skillInfos, curMilitaryRankId)
      end)
    end
    local count = 0
    for i = 1, table.length(list.soldiers) do
      count = list.soldiers[i].count + count
    end
    self.power:SetText(string.GetFormattedSeperatorNum(count))
  end
  self:OnShowSoldier()
end

local function OnShowSoldier(self)
  self.modelSoldier = {}
  self:SetAllCellDestroy()
  local list = self.view.ctrl:GetPlayerSoldierData(self.uuid)
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
      self.modelSoldier[i] = self:GameObjectInstantiateAsync(UIAssets.AllianceWarPlayerSoliderItem, function(request)
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

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(AllianceWarPlayerSoliderItem)
  self.content:RemoveComponents(UIRadarSoliderICell)
  if next(self.modelSoldier) then
    for k, v in pairs(self.modelSoldier) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function SetAllCellDestroyHero(self)
  self._content_rect:RemoveComponents(UIHeroCellSmall)
  self._content_rect:RemoveComponents(UIHeroCell)
  if next(self.modelHero) then
    for k, v in pairs(self.modelHero) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function ShowHeroAndSolider(self, param)
  self._leader_img:SetActive(false)
  self.modelSoldier = {}
  self.modelHero = {}
  self.power:SetText(string.GetFormattedSeperatorNum(param:GetSoliderNum()))
  local allianceAbbr = param.allianceAbbr or ""
  if allianceAbbr == "" then
    self.name:SetText(param.ownerName)
  else
    self.name:SetText("[" .. allianceAbbr .. "]" .. param.ownerName)
  end
  self.otherPlayerUid = param.ownerUid
  self.playerHead:SetData(param.ownerUid, param.pic, param.picVer)
  self.playerHeadBg:SetActive(false)
  self:SetAllCellDestroy()
  self:SetAllCellDestroyHero()
  local marchTargetType = param:GetMarchTargetType()
  if marchTargetType ~= MarchTargetType.SCOUT_BUILDING and marchTargetType ~= MarchTargetType.SCOUT_CITY and marchTargetType ~= MarchTargetType.SCOUT_WINTER_STORM_CITY and marchTargetType ~= MarchTargetType.SCOUT_EPIDEMIC_CITY and marchTargetType ~= MarchTargetType.SCOUT_ARMY_COLLECT and marchTargetType ~= MarchTargetType.SCOUT_BUILDING and marchTargetType ~= MarchTargetType.SCOUT_ARMY_COLLECT then
    local ArmyInfo = param:GetFirstArmyInfo()
    if ArmyInfo ~= nil then
      for i = 0, table.length(ArmyInfo.HeroInfos) do
        self.modelHero[ArmyInfo.HeroInfos[i].heroId] = self:GameObjectInstantiateAsync(UIAssets.AllianceHeroCell, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self._content_rect.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.name = "item" .. tonumber(i)
          local cell = self._content_rect:AddComponent(UIHeroCell, go.name)
          local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(ArmyInfo.HeroInfos[i].heroId, ArmyInfo.HeroInfos[i].rankLv, ArmyInfo.HeroInfos[i].stage)
          cell:InitWithConfigId(ArmyInfo.HeroInfos[i].heroId, ArmyInfo.HeroInfos[i].heroQuality, ArmyInfo.HeroInfos[i].heroLevel, curMilitaryRankId)
        end)
      end
      for i = 0, table.length(ArmyInfo.Soldiers) do
        self.modelSoldier[ArmyInfo.Soldiers[i].armsId] = self:GameObjectInstantiateAsync(UIAssets.AllianceWarPlayerSoliderItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self.content.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.name = "item" .. tonumber(i)
          local cell = self.content:AddComponent(UIRadarSoliderICell, go.name)
          local param = {}
          param.total = ArmyInfo.Soldiers[i].total
          param.armyId = ArmyInfo.Soldiers[i].armsId
          cell:ReInit(param)
        end)
      end
    end
  end
end

local function OnClickPlayerHeadBtn(self)
  if self.otherPlayerUid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.otherPlayerUid)
  end
end

UIPersonalWarPlayerItem.OnCreate = OnCreate
UIPersonalWarPlayerItem.OnDestroy = OnDestroy
UIPersonalWarPlayerItem.OnEnable = OnEnable
UIPersonalWarPlayerItem.OnDisable = OnDisable
UIPersonalWarPlayerItem.RefreshData = RefreshData
UIPersonalWarPlayerItem.SetUuid = SetUuid
UIPersonalWarPlayerItem.ShowHeroAndSolider = ShowHeroAndSolider
UIPersonalWarPlayerItem.OnClickPlayerHeadBtn = OnClickPlayerHeadBtn
UIPersonalWarPlayerItem.OnShowSoldier = OnShowSoldier
UIPersonalWarPlayerItem.SetAllCellDestroy = SetAllCellDestroy
UIPersonalWarPlayerItem.SetAllCellDestroyHero = SetAllCellDestroyHero
return UIPersonalWarPlayerItem
