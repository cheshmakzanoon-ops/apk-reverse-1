local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local AssistanceWarPlayerItem = BaseClass("AssistanceWarPlayerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local common_supple_path = "mainContent/Common_supple"
local name_path = "mainContent/nameTxt"
local power_path = "mainContent/PowerContent/powerTxt"
local power_des_path = "mainContent/PowerContent/powerDesTxt"
local state_path = "mainContent/ArriveArea/stateTxt"
local march_area_path = "mainContent/sliderLayout"
local arrive_area_path = "mainContent/ArriveArea"
local slider_path = "mainContent/sliderLayout/Slider"
local progress_txt_path = "mainContent/sliderLayout/Slider/FillArea/progressTxt"
local time_txt_path = "mainContent/sliderLayout/Slider/FillArea/TimeTxt"
local cancel_btn_path = "mainContent/sliderLayout/returnButton"
local cancel_btn2_path = "mainContent/ArriveArea/returnButton2"
local show_btn_path = "mainContent/showButton"
local close_img_path = "mainContent/ImgArrowNormal"
local open_img_path = "mainContent/ImgArrowSelect"
local content_path = "armyContent/Viewport/Content"
local playerHeadIcon_path = "mainContent/leftIcon/PlayIcon/UIPlayerHead"
local hp_slider = "mainContent/HpBar"
local hp_slider_text = "mainContent/HpBar/FillArea/HpTxt"
local show_ally_path = "mainContent/leftIcon/PlayIcon/showAlly"
local SliderLength = 210

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetUuid(uuid)
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.common_supple = self:AddComponent(UIImage, common_supple_path)
  self.name = self:AddComponent(UIText, name_path)
  self.power = self:AddComponent(UIText, power_path)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.power_des:SetText(Localization:GetString("393067") .. ": ")
  self.state = self:AddComponent(UIText, state_path)
  self.state:SetLocalText(GameDialogDefine.HAD_ARRIVED)
  self.march_area = self:AddComponent(UIBaseContainer, march_area_path)
  self.arrive_area = self:AddComponent(UIBaseContainer, arrive_area_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.progress_txt = self:AddComponent(UIText, progress_txt_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self.close_img = self:AddComponent(UIImage, close_img_path)
  self.open_img = self:AddComponent(UIImage, open_img_path)
  self.cancel_btn2 = self:AddComponent(UIButton, cancel_btn2_path)
  self.cancel_btn2:SetOnClick(function()
    self:OnCancelClick()
  end)
  self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
  self.cancel_btn:SetOnClick(function()
    self:OnCancelClick()
  end)
  self.show_btn = self:AddComponent(UIButton, show_btn_path)
  self.show_btn:SetOnClick(function()
    self:OnShowClick()
  end)
  self.heroCell = self.transform:Find("UIHeroCellSmall")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.playerHeadIcon = self:AddComponent(UICommonHead, playerHeadIcon_path)
  self.hpSlider = self:AddComponent(UISlider, hp_slider)
  self.hpSliderTxt = self:AddComponent(UIText, hp_slider_text)
  self.show_ally = self:TryAddComponent(UIImage, show_ally_path)
  self.model = {}
end

local function ComponentDestroy(self)
  self:SetAllCellDestroyHero()
  self.common_supple = nil
  self.name = nil
  self.power = nil
  self.show_ally = nil
  self.power_des = nil
  self.state = nil
  self.slider = nil
  self.progress_txt = nil
  self.time_txt = nil
  self.close_img = nil
  self.open_img = nil
  self.cancel_btn2 = nil
  self.cancel_btn = nil
  self.show_btn = nil
  self.heroCell = nil
  self.content = nil
  self.playerHeadIcon = nil
  self.model = nil
end

local function DataDefine(self)
  self.isUpdate = false
  self.lastChangeTextDeltaTime = 0
  self.lastChangeImageDeltaTime = 0
end

local function DataDestroy(self)
  self.isUpdate = nil
  self.lastChangeTextDeltaTime = nil
  self.lastChangeImageDeltaTime = nil
end

local function RefreshData(self)
  self.isUpdate = false
  self.lastChangeTextDeltaTime = 0
  self.lastChangeImageDeltaTime = 0
  self.governmentId = DataCenter.GovernmentManager:GetPositionId()
  if self.governmentId ~= nil and self.governmentId ~= 0 then
    self.governmentConfig = DataCenter.GovernmentTemplateManager:GetTemplate(self.governmentId)
  end
  self.dataInfo = self.view.ctrl:GetPlayerItemData(self.uuid, self.view.isCrossServerThrone)
  if not self.dataInfo.ownerUid then
    return
  end
  local selfUid = LuaEntry.Player.uid
  local selfAllianceId = LuaEntry.Player:GetAllianceUid()
  self.cancel = false
  if self.view.asType == AssistanceType.MainCity or self.view.asType == AssistanceType.Desert or self.view.asType == AssistanceType.AllianceBuild or self.view.asType == AssistanceType.DragonBuild or self.view.asType == AssistanceType.WinterEntity or self.view.asType == AssistanceType.EpidemicBuild then
    if selfUid == self.view.ctrl.ownerUid then
      self.cancel = true
    elseif self.dataInfo.ownerUid == selfUid then
      self.cancel = true
    elseif self.view.asType == AssistanceType.AllianceBuild and LuaEntry.Player:IsInAlliance() and DataCenter.AllianceBaseDataManager:IsR4orR5() and selfAllianceId == self.dataInfo.allianceId then
      self.cancel = true
    end
  elseif self.view.asType == AssistanceType.AllianceCity or self.view.asType == AssistanceType.CityStronghold then
    if self.isCrossServerThrone then
      self.cancel = true
    elseif LuaEntry.Player:IsInAlliance() and DataCenter.AllianceBaseDataManager:IsR4orR5() and selfAllianceId == self.dataInfo.allianceId then
      self.cancel = true
    elseif self.dataInfo.ownerUid == selfUid then
      self.cancel = true
    end
  elseif self.view.asType == AssistanceType.TradeState then
    if self.dataInfo.ownerUid == selfUid then
      self.cancel = true
    end
  elseif self.view.asType == AssistanceType.ASSISTANCE_OUTPOST then
    local ownerAllianceId = self.view.ownerAllianceId
    if LuaEntry.Player:IsInAlliance() and DataCenter.AllianceBaseDataManager:IsR4orR5() and ownerAllianceId == selfAllianceId then
      self.cancel = true
    elseif self.dataInfo.ownerUid == selfUid then
      self.cancel = true
    end
  end
  if self.show_ally then
    local mgr = DataCenter.SeasonAllyFriendManager
    local ownerAllianceId = self.view.ownerAllianceId
    if self.view.asType == AssistanceType.AllianceCity and not self.isCrossServerThrone and self.dataInfo.allianceId ~= ownerAllianceId and (mgr:IsMyFriendAlly(ownerAllianceId) or mgr:IsMyFriendAlly(self.dataInfo.allianceId)) then
      self.show_ally:SetActive(true)
      if LuaEntry.Player:IsInAlliance() and DataCenter.AllianceBaseDataManager:IsR4orR5() then
        self.cancel = true
      end
    else
      self.show_ally:SetActive(false)
    end
  end
  if self.dataInfo.ownerUid == selfUid then
    self.common_supple:SetColor(Color.New(0.9921568627450981, 0.9058823529411765, 0.7764705882352941, 1))
  else
    self.common_supple:SetColor(Color.New(1, 1, 1, 1))
  end
  self:RefreshPlayerHead()
  self.cancel_btn:SetActive(self.cancel)
  self.cancel_btn2:SetActive(self.cancel)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.dataInfo.endTime and curTime > self.dataInfo.startTime then
    if self.arrive_area:GetActive() then
      self.arrive_area:SetActive(false)
    end
    if self.march_area:GetActive() == false then
      self.march_area:SetActive(true)
    end
    self:UpdateSlider()
  else
    if self.arrive_area:GetActive() == false then
      self.arrive_area:SetActive(true)
    end
    if self.march_area:GetActive() then
      self.march_area:SetActive(false)
    end
  end
  self.open_img:SetActive(true)
  self.close_img:SetActive(false)
  self.close_img:SetActive(false)
  self.hpSliderTxt:SetText(string.GetFormattedPercentStr(math.min(1, self.dataInfo.curHp / self.dataInfo.maxHp)))
  self.hpSlider:SetValue(math.min(1, self.dataInfo.curHp / self.dataInfo.maxHp))
  self.power:SetText(string.GetFormattedSeparatorNum(self.dataInfo.power))
  self:RefreshArmy()
end

local function RefreshPlayerHead(self)
  if self.dataInfo then
    local playerInfo = self.dataInfo.playerInfo
    if playerInfo then
      local theServerId = playerInfo.serverId or self.dataInfo.serverId or self.theServerId
      local allianceAbbr = playerInfo.alAbbr or self.dataInfo.allianceAbbr
      self.playerHeadIcon:ParseHeadInfo(playerInfo)
      self.name:SetText(UIUtil.FormatServerAllianceName(theServerId, allianceAbbr, self.dataInfo.ownerName))
    else
      local theServerId = self.dataInfo.serverId or self.theServerId
      local allianceAbbr = self.dataInfo.allianceAbbr
      self.name:SetText(UIUtil.FormatServerAllianceName(theServerId, allianceAbbr, self.dataInfo.ownerName))
      local member = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(self.dataInfo.ownerUid)
      if member then
        local fgImg = member:GetHeadBgImg()
        self.playerHeadIcon:SetData(member.uid, member.pic, member.picVer, nil, fgImg)
      else
        self.playerHeadIcon:ParseHeadInfo(self.dataInfo)
      end
    end
  end
end

local function SetUuid(self, uuid, theServerId, isCrossServerThrone, index, expand)
  self.uuid = uuid
  self.theServerId = theServerId
  self.isCrossServerThrone = isCrossServerThrone
  self.index = index
  self.expand = expand
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
      if self.dataInfo.status == MarchStatus.BUILD_WORM_HOLE then
        dialog = Localization:GetString("390210")
      end
      self.progress_txt:SetText(dialog)
      self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    end
  else
    self.lastChangeTextDeltaTime = 0
    self.lastChangeImageDeltaTime = 0
    self.isUpdate = false
    if self.arrive_area:GetActive() == false then
      self.arrive_area:SetActive(true)
    end
    if self.march_area:GetActive() then
      self.march_area:SetActive(false)
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
  self:RefreshPlayerHead()
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
end

local function OnDisable(self)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
  base.OnDisable(self)
end

function AssistanceWarPlayerItem:OnGetNewUserInfoSucc()
  if self.dataInfo == nil or self.dataInfo.playerInfo then
    return
  end
  local playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.dataInfo.ownerUid, true)
  if playerInfo then
    self.dataInfo.playerInfo = playerInfo
    self:RefreshPlayerHead()
  end
end

local function SetAllCellDestroyHero(self)
  self.content:RemoveComponents(UIHeroCellSmall)
  if next(self.model) then
    for _, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function OnCancelClick(self)
  if self.cancel then
    if self.dataInfo.ownerUid == LuaEntry.Player.uid then
      self.view.ctrl:OnRetreatClick(self.uuid)
    else
      if self.isCrossServerThrone and self.view.asType == AssistanceType.AllianceCity then
        local selfAllianceId = LuaEntry.Player:GetAllianceUid()
        if LuaEntry.Player:IsInAlliance() and DataCenter.AllianceBaseDataManager:IsR4orR5() and selfAllianceId == self.dataInfo.allianceId then
        elseif self.governmentConfig ~= nil then
        else
          UIUtil.ShowTipsId(801497)
          return
        end
      end
      UIUtil.ShowMessage(Localization:GetString("300031", self.dataInfo.ownerName), 2, "100288", "100289", function()
        self.view.ctrl:OnRetreatClick(self.uuid)
      end, nil, nil)
    end
  end
end

local function RefreshArmy(self)
  self:SetAllCellDestroyHero()
  if not self.expand then
    self.open_img:SetActive(true)
    self.close_img:SetActive(false)
  else
    self.open_img:SetActive(false)
    self.close_img:SetActive(true)
    local list = self.view.ctrl:GetPlayerSoldierData(self.uuid)
    if list ~= nil and list.heros ~= nil and #list.heros > 0 then
      for i = 1, table.length(list.heros) do
        self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UIHeroCellSmall, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self.content.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.name = "item" .. i
          local cell = self.content:AddComponent(UIHeroCellSmall, go.name)
          cell:InitWithConfigId(list.heros[i].heroId, list.heros[i].quality, list.heros[i].lv, list.heros[i].rankLv, list.heros[i].weaponLevel, list.heros[i].awakenLv, list.heros[i].heroSkinId)
        end)
      end
    end
  end
end

local function OnShowClick(self)
  self.view:RefreshAllShownItem(self.index, not self.expand)
end

AssistanceWarPlayerItem.OnCreate = OnCreate
AssistanceWarPlayerItem.OnDestroy = OnDestroy
AssistanceWarPlayerItem.ComponentDefine = ComponentDefine
AssistanceWarPlayerItem.ComponentDestroy = ComponentDestroy
AssistanceWarPlayerItem.DataDefine = DataDefine
AssistanceWarPlayerItem.DataDestroy = DataDestroy
AssistanceWarPlayerItem.OnEnable = OnEnable
AssistanceWarPlayerItem.OnDisable = OnDisable
AssistanceWarPlayerItem.RefreshData = RefreshData
AssistanceWarPlayerItem.SetUuid = SetUuid
AssistanceWarPlayerItem.UpdateSlider = UpdateSlider
AssistanceWarPlayerItem.Update = Update
AssistanceWarPlayerItem.OnCancelClick = OnCancelClick
AssistanceWarPlayerItem.OnShowClick = OnShowClick
AssistanceWarPlayerItem.SetAllCellDestroyHero = SetAllCellDestroyHero
AssistanceWarPlayerItem.RefreshPlayerHead = RefreshPlayerHead
AssistanceWarPlayerItem.RefreshArmy = RefreshArmy
return AssistanceWarPlayerItem
