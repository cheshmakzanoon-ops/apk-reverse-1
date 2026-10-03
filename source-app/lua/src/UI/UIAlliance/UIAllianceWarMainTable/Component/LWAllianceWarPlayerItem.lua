local LWAllianceWarPlayerItem = BaseClass("LWAllianceWarPlayerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local bg_path = "bg"
local name_path = "nameTxt"
local power_path = "powerTxt"
local playerHead_path = "UIPlayerHead"
local state_path = "stateTxt"
local slider_path = "sliderLayout/slider"
local time_txt_path = "sliderLayout/slider/FillArea/TimeTxt"
local sl_Image_path = "sliderLayout"
local return_btn_path = "returnBtn"
local cancel_btn_path = "cancelBtn"
local _content_rect = "ScrollView/Viewport/Content"
local SliderLength = 200

function LWAllianceWarPlayerItem:OnCreate()
  base.OnCreate(self)
  self.isUpdate = false
  self.lastChangeTextDeltaTime = 0
  self.lastChangeImageDeltaTime = 0
  self.cachedOwnerUid = nil
  self.bg = self:AddComponent(UIImage, bg_path)
  self.name = self:AddComponent(UIText, name_path)
  self.power = self:AddComponent(UIText, power_path)
  self.playerHead = self:AddComponent(UICommonHead, playerHead_path)
  self.state = self:AddComponent(UIText, state_path)
  self.state:SetLocalText(390141)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.sl_Image = self:AddComponent(UIBaseContainer, sl_Image_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self:OnReturnClick()
  end)
  self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
  self.cancel_btn:SetOnClick(function()
    self:OnCancelClick()
  end)
  self._content_rect = self:AddComponent(UIBaseContainer, _content_rect)
  self.modelHero = {}
end

function LWAllianceWarPlayerItem:OnDestroy()
  self:ClearAllCellDestroyHero()
  self.heros = nil
  base.OnDestroy(self)
end

function LWAllianceWarPlayerItem:OnEnable()
  base.OnEnable(self)
end

function LWAllianceWarPlayerItem:OnDisable()
  base.OnDisable(self)
end

function LWAllianceWarPlayerItem:Update()
  if self.isUpdate then
    self:UpdateSlider()
  end
end

function LWAllianceWarPlayerItem:ClearAllCellDestroyHero()
  self._content_rect:RemoveComponents(UIHeroCellSmall)
  for k, v in ipairs(self.modelHero) do
    if v and v.request then
      self:GameObjectDestroy(v.request)
    end
  end
  self.modelHero = {}
end

function LWAllianceWarPlayerItem:OnCancelClick()
  UIUtil.ShowMessage(Localization:GetString("110151", self.dataInfo.ownerName), 2, nil, nil, function()
    self.view.ctrl:OnCancelClick(self.uuid)
  end, nil, nil)
end

function LWAllianceWarPlayerItem:OnReturnClick()
  MarchUtil.CancelRallyByMember(self.uuid, self.marchUuid)
end

function LWAllianceWarPlayerItem:CheckCancelShow()
  if self.dataInfo.cancel and self.view.ctrl:GetInMarchState(self.marchUuid) == false then
    local selfUid = LuaEntry.Player.uid
    if self.dataInfo.ownerUid == selfUid and self.dataInfo.attackUid == selfUid then
      self.cancel_btn:SetActive(true)
      self.return_btn:SetActive(false)
    else
      self.return_btn:SetActive(true)
      self.cancel_btn:SetActive(false)
    end
  else
    self.return_btn:SetActive(false)
    self.cancel_btn:SetActive(false)
  end
end

function LWAllianceWarPlayerItem:RefreshHeroCell(index)
  if not self.heros or not self.modelHero then
    return
  end
  local heroData = self.heros[index]
  local heroMd = self.modelHero[index]
  if heroData then
    if heroMd.cell then
      heroMd.cell.gameObject:SetActive(true)
      heroMd.cell:InitWithConfigId(heroData.heroId, heroData.quality, heroData.lv, heroData.rankId, heroData.weaponLevel, heroData.awakenLv, heroData.heroSkinId)
    end
  elseif heroMd.cell then
    heroMd.cell.gameObject:SetActive(false)
  end
end

local heroCellPath = "Assets/Main/Prefabs/UI/Alliance/LWAlHeroCell.prefab"

function LWAllianceWarPlayerItem:RefreshData(uuid, march_uuid, data_info, isAttack)
  local needRefreshPlayerDogHead = data_info and data_info.ownerUid and data_info.ownerUid ~= self.cachedOwnerUid
  self.uuid = uuid
  self.marchUuid = march_uuid
  self.dataInfo = data_info
  self.isUpdate = false
  self.lastChangeTextDeltaTime = 0
  self.lastChangeImageDeltaTime = 0
  if needRefreshPlayerDogHead then
    self.cachedOwnerUid = self.dataInfo.ownerUid
    self.name:SetText(self.dataInfo.ownerName)
    self.playerHead:SetData(self.dataInfo.ownerUid, self.dataInfo.ownerIcon, self.dataInfo.ownerIconVer, nil, self.dataInfo.headBg)
  end
  self.playerHead:SetEnableClickShowInfo(true)
  if self.dataInfo.status == MarchStatus.IN_TEAM or self.dataInfo.status == MarchStatus.WAIT_RALLY or self.dataInfo.leader then
    self.state:SetActive(true)
    self.sl_Image:SetActive(false)
    self.slider:SetActive(false)
  else
    self.state:SetActive(false)
    self.sl_Image:SetActive(true)
    self.slider:SetActive(true)
    self:UpdateSlider()
  end
  if isAttack then
    self.bg:SetColor(LWALAttackJbgColor)
  else
    local selfUid = LuaEntry.Player.uid
    if self.dataInfo.ownerUid == selfUid then
      self.bg:SetColor(LWALBGColor2)
    else
      self.bg:SetColor(LWALDefenseJbgColor)
    end
  end
  self:CheckCancelShow()
  local list = self:GetPlayerSoldierData(self.marchUuid)
  self.heros = list and list.heros
  if self.heros then
    table.sort(self.heros, function(a, b)
      local heroConfigA = DataCenter.HeroTemplateManager:GetTemplate(a.heroId)
      local heroConfigB = DataCenter.HeroTemplateManager:GetTemplate(b.heroId)
      if heroConfigA == nil or heroConfigB == nil then
        return false
      end
      if heroConfigA.heroData_type == HeroTemplateType.Dominator then
        return true
      end
      if heroConfigB.heroData_type == HeroTemplateType.Dominator then
        return false
      end
      if a.quality > b.quality then
        return true
      elseif a.quality == b.quality then
        if a.lv > b.lv then
          return true
        end
        return false
      end
    end)
  end
  local herosCount = #self.heros
  local goCount = #self.modelHero
  local maxCount = math.max(goCount, herosCount)
  for i = 1, maxCount do
    local heroData = self.heros[i]
    local heroMd = self.modelHero[i]
    if heroData then
      if heroMd then
        self:RefreshHeroCell(i)
      else
        local _new = {}
        self.modelHero[i] = _new
        _new.request = self:GameObjectInstantiateAsync(heroCellPath, function(request)
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
          _new.cell = self._content_rect:AddComponent(UIHeroCellSmall, go.transform:GetChild(0).gameObject)
          self:RefreshHeroCell(i)
        end)
      end
    else
      self:RefreshHeroCell(i)
    end
  end
  if list and list.power then
    self.power.gameObject:SetActive(true)
    self.power:SetText(Localization:GetString("100253") .. " " .. string.GetFormattedSeperatorNum(list.power))
  else
    self.power.gameObject:SetActive(false)
  end
end

function LWAllianceWarPlayerItem:GetPlayerSoldierData(marchUuid)
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.uuid)
  local showList
  if info ~= nil then
    if next(info.memberList) and info.memberList[marchUuid] then
      showList = {}
      local data = info.memberList[marchUuid].armyInfos
      local heros = data.heros
      showList.power = info.memberList[marchUuid].power
      showList.heros = {}
      for i = 1, #heros do
        showList.heros[i] = {}
        showList.heros[i].heroId = heros[i].heroId
        showList.heros[i].quality = heros[i].heroQuality
        showList.heros[i].lv = heros[i].heroLevel
        showList.heros[i].skillInfos = heros[i].skillInfos
        showList.heros[i].rankId = heros[i].rankLv
        showList.heros[i].weaponLevel = heros[i].weaponLevel
        showList.heros[i].awakenLv = heros[i].awakenLv
        showList.heros[i].heroSkinId = heros[i].heroSkinId
        showList.heros[i].index = i
      end
      local soldiers = data.soldiers
      showList.soldiers = {}
      for i = 1, #soldiers do
        showList.soldiers[i] = {}
        showList.soldiers[i].armsId = soldiers[i].armsId
        showList.soldiers[i].type = soldiers[i].type
        showList.soldiers[i].data = DataCenter.ArmyTemplateManager:GetArmyTemplate(soldiers[i].armsId)
        showList.soldiers[i].count = soldiers[i].total - soldiers[i].lost
      end
    elseif next(info.leaderMarch) and info.leaderMarch.uuid == marchUuid then
      showList = {}
      local data = info.leaderMarch
      showList.power = data.power
      if data.armyInfo ~= nil then
        local heros = data.armyInfo.heros or {}
        showList.heros = {}
        for i = 1, #heros do
          showList.heros[i] = {}
          showList.heros[i].heroId = heros[i].heroId
          showList.heros[i].quality = heros[i].heroQuality
          showList.heros[i].lv = heros[i].heroLevel
          showList.heros[i].skillInfos = heros[i].skillInfos
          showList.heros[i].rankId = heros[i].rankLv
          showList.heros[i].weaponLevel = heros[i].weaponLevel
          showList.heros[i].awakenLv = heros[i].awakenLv
          showList.heros[i].heroSkinId = heros[i].heroSkinId
          showList.heros[i].index = i
        end
        local soldiers = data.armyInfo.soldiers or {}
        showList.soldiers = {}
        for i = 1, #soldiers do
          showList.soldiers[i] = {}
          showList.soldiers[i].armsId = soldiers[i].armsId
          showList.soldiers[i].type = soldiers[i].type
          showList.soldiers[i].data = DataCenter.ArmyTemplateManager:GetArmyTemplate(soldiers[i].armsId)
          showList.soldiers[i].count = soldiers[i].total - soldiers[i].lost
        end
      end
    end
  end
  return showList
end

function LWAllianceWarPlayerItem:UpdateSlider()
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
      self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    end
  else
    self.lastChangeTextDeltaTime = 0
    self.lastChangeImageDeltaTime = 0
    self.isUpdate = false
    self.state:SetActive(true)
    self.sl_Image:SetActive(false)
    self.slider:SetActive(false)
    self:CheckCancelShow()
  end
end

return LWAllianceWarPlayerItem
