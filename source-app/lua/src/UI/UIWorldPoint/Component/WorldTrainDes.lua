local FormationHeroItem = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationHeroItem")
local TeamCell = require("UI.UIWorldPoint.Component.TeamCell")
local WorldTrainDes = BaseClass("WorldTrainDes", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local main_obj_path = "BuildInfo"
local des_obj_path = "BuildDetails"
local content_path = "BuildInfo/ScrollView/Viewport/Content"
local content3_path = "BuildInfo/ScrollView3/Viewport/Content3"
local tips1_txt_path = "BuildInfo/tips/commendText"
local animator_path = ""
local failure_count_limit_tips_path = "BuildInfo/FailureCountLimitTips"
local failure_count_limit_tips_text_path = "BuildInfo/FailureCountLimitTips/FailureCountLimitTipsText"
local vipImage_path = "BuildInfo/AllyTrain/vipIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self:OnReturnClick()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.tips_txt = self:AddComponent(UIText, tips1_txt_path)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.main_obj = self:AddComponent(UIBaseContainer, main_obj_path)
  self.des_obj = self:AddComponent(UIBaseContainer, des_obj_path)
  self.main_obj_canvas = self:AddComponent(UICanvasGroup, main_obj_path)
  self.des_obj_canvas = self:AddComponent(UICanvasGroup, des_obj_path)
  self.main_obj_canvas:SetAlpha(1)
  self.des_obj_canvas:SetAlpha(1)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.commonResItemPrefab = self.transform:Find("BuildInfo/ScrollView/Viewport/Content/UICommonResItem").gameObject
  self.commonResItemPrefab:GameObjectCreatePool()
  self.commonResItemPrefab:SetActive(false)
  self.lineUp_content = self:AddComponent(UIBaseContainer, content3_path)
  self.heroItemPrefab = self.transform:Find("BuildInfo/ScrollView3/Viewport/Content3/FormationSelectHeroItem").gameObject
  self.heroItemPrefab:GameObjectCreatePool()
  self.heroItemPrefab:SetActive(false)
  self.des_txt = self:AddComponent(UIText, "BuildDetails/ScrollView/Viewport/Content0/desTxt")
  self.des_txt:SetLocalText(457574)
  self.player_head = self:AddComponent(UICommonHead, "BuildInfo/info/UIPlayerHead")
  self.player_head:SetEnableClickShowInfo(true)
  self.allyFlag = self:AddComponent(UIImage, "BuildInfo/info/AllyFlag")
  self.driver_head = self:AddComponent(UICommonHead, "BuildInfo/AllyTrain/DriverHead")
  self.driver_head:SetEnableClickShowInfo(true)
  self.nameDes = self:AddComponent(UIText, "BuildInfo/info/NameContent/nameDes")
  self.nameTxt = self:AddComponent(UIText, "BuildInfo/info/NameContent/nameTxt")
  self.hpDes = self:AddComponent(UIText, "BuildInfo/info/HpContent/hpDes")
  self.hpTxt = self:AddComponent(UIText, "BuildInfo/info/HpContent/hpTxt")
  self.timeDes = self:AddComponent(UIText, "BuildInfo/info/TimeContent/timeDes")
  self.timeTxt = self:AddComponent(UIText, "BuildInfo/info/TimeContent/timeTxt")
  self.weightBtn = self:AddComponent(UIButton, "BuildInfo/info/WeightBtn")
  self.weightBtn:SetOnClick(function()
    self:OnInfoClick2()
  end)
  self.weightBtn:SetActive(false)
  self.detailBtn = self:AddComponent(UIButton, "BuildInfo/DetailBtn")
  self.detailBtn:SetOnClick(function()
    self:OnDetailClick()
  end)
  self.detailBtnTxt = self:AddComponent(UIText, "BuildInfo/DetailBtn/BtnTxt")
  self.detailBtnTxt:SetLocalText(393089)
  self.allyTrainNode = self:AddComponent(UIBaseComponent, "BuildInfo/AllyTrain")
  self.driverName = self:AddComponent(UIText, "BuildInfo/AllyTrain/driverName")
  self.driverLv = self:AddComponent(UIText, "BuildInfo/AllyTrain/driverLv")
  self.power1 = self:AddComponent(UIText, "BuildInfo/AllyTrain/team1/power1")
  self.power2 = self:AddComponent(UIText, "BuildInfo/AllyTrain/team2/power2")
  self.power3 = self:AddComponent(UIText, "BuildInfo/AllyTrain/team3/power3")
  self.infoBtn = self:AddComponent(UIButton, "BuildInfo/AllyTrain/infoBtn")
  self.infoBtn:SetOnClick(function()
    self:OnInfoClick()
    self.view.btn_detail:SetActive(false)
    self.view.btn_return:SetActive(true)
  end)
  self.content0 = self:AddComponent(UIBaseContainer, "BuildDetails/ScrollView/Viewport/Content0")
  self.truckNode = self:AddComponent(UIBaseComponent, "BuildInfo/ScrollView3")
  self.failure_count_limit_tips = self:AddComponent(UIBaseContainer, failure_count_limit_tips_path)
  self.failureCountLimitTipsText = self:AddComponent(UIText, failure_count_limit_tips_text_path)
  self.vipImage = self:AddComponent(UIImage, vipImage_path)
end

local function ComponentDestroy(self)
  self.lineUp_content:RemoveComponents(FormationHeroItem)
  self.heroItemPrefab.gameObject:GameObjectRecycleAll()
  self.heroItemPrefab = nil
  self.content:RemoveComponents(UICommonResItem)
  self.commonResItemPrefab.gameObject:GameObjectRecycleAll()
  self.commonResItemPrefab = nil
end

local function DataDefine(self)
  self.data = nil
end

local function DataDestroy(self)
  self.data = nil
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function SetAllHeroSmallCellDestroy(self)
  self.lineUp_content:RemoveComponents(FormationHeroItem)
  if self.heroSmallModel ~= nil then
    for k, v in pairs(self.heroSmallModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.heroSmallModel = {}
end

local function SetAllTeamCellDestroy(self)
  self.content0:RemoveComponents(TeamCell)
  if self.teamCellReq ~= nil then
    for k, v in pairs(self.teamCellReq) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.teamCellReq = {}
end

local function RefreshData(self, data)
  self.data = data
  local today, daily = DataCenter.LWMyStationDataManager:GetRobCount()
  self.tips_txt:SetText(Localization:GetString("457510") .. ": " .. today .. "/" .. daily)
  self.nameDes:SetLocalText(100031)
  self.hpDes:SetLocalText("alliance_train_061")
  self.timeDes:SetLocalText(457511)
  local curRobTimes = 0
  if data and data.marchInfo then
    curRobTimes = data.marchInfo.robTimes or 0
  end
  local maxRobTimes = RailwayUtil.GetTrainMaxRobCount(data)
  if curRobTimes >= maxRobTimes then
    self.hpTxt:SetText(string.format("<color=#f53c3d>%s/%s</color>", curRobTimes, maxRobTimes))
  else
    self.hpTxt:SetText(string.format("<color=#099b4a>%s/%s</color>", curRobTimes, maxRobTimes))
  end
  self:Update1000MS()
  self:AddRewardToContainer(data:GetCurRewardData())
  self.detailBtn:SetActive(true)
  local isTruck = data.type == TrainType.Truck
  local isTrain = data.type == TrainType.Train
  self.des_txt:SetActive(isTruck)
  self.allyTrainNode:SetActive(isTrain)
  self.truckNode:SetActive(isTruck)
  self.player_head:SetActive(isTruck)
  self.allyFlag:SetActive(isTrain)
  self.driver_head:SetActive(isTrain)
  if isTruck then
    self.player_head:SetHeadAndFrame(data.ownerId, data.pic, data.picVer, false, data.headSkinId, data.headSkinET)
    self.nameTxt:SetText(data:GetAbbrAndName())
    self:AddHeroToContainer(data.heroInfo)
  else
    self.driver_head:SetHeadAndFrame(data.ownerId, data.pic, data.picVer, false, data.headSkinId, data.headSkinET)
    self.allyFlag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, data.allianceFlag))
    self.nameTxt:SetText(data.allianceName)
    self.driverName:SetText(data:GetAbbrAndName())
    self.driverLv:SetText("Lv." .. data.ownerLv)
    self.vipImage:SetActive(data.vipInfo and data.vipInfo.vipType == 1)
    local team1Power = 0
    local team2Power = 0
    local team3Power = 0
    if data.teamList[1] then
      team1Power = data.teamList[1].totalPower or 0
    end
    if data.teamList[2] then
      team2Power = data.teamList[2].totalPower or 0
    end
    if data.teamList[3] then
      team3Power = data.teamList[3].totalPower or 0
    end
    self.power1:SetText(string.GetFormattedStr(team1Power))
    self.power2:SetText(string.GetFormattedStr(team2Power))
    self.power3:SetText(string.GetFormattedStr(team3Power))
  end
  local effectValue = self.data:GetEffectValue(EffectDefine.LW_TRAIN_FAILURE_COUNT_LIMIT)
  if 0 < effectValue then
    self.failure_count_limit_tips:SetActive(true)
    local failureCount = self.data:GetFailureCountByUuid(LuaEntry.Player.uid)
    local str = failureCount .. "/" .. math.floor(effectValue)
    self.failureCountLimitTipsText:SetText(Localization:GetString("trade_person_tips1018") .. ": " .. str)
  else
    self.failure_count_limit_tips:SetActive(false)
  end
end

local function RefreshInfo(self)
  self:AddTeamToContainer(self.data.teamList, self.content0)
end

local function AddRewardToContainer(self, list)
  self.content:RemoveComponents(UICommonResItem)
  self.commonResItemPrefab.gameObject:GameObjectRecycleAll()
  if list then
    for i, data in ipairs(list) do
      local go = self.commonResItemPrefab:GameObjectSpawn(self.content.transform)
      local nameStr = "UICommonResItem" .. i
      go.name = nameStr
      local cell = self.content:AddComponent(UICommonResItem, nameStr)
      local param = UICommonResItem.Param.New()
      param.rewardType = data.type
      if type(data.value) == "table" then
        param.itemId = data.value.id
        param.count = data.value.num
      else
        param.itemId = data.type
        param.count = data.value
        local effectValue = self.data:GetEffectValue(EffectDefine.LW_BASIC_RESOURCE_PRODUCT_PROMOTION)
        param.isShowArrow = 0 < effectValue
      end
      param.rewardType = data.type
      param.heroUuid = data.heroUuid
      param.isHeroBox = data.isHeroBox
      local isTruck = self.data.type == TrainType.Truck
      cell:ReInit(param)
      if isTruck then
        local curMultiVal = self.data.multiple
        if curMultiVal and 1 < curMultiVal then
          cell:ShowMultiMark(curMultiVal)
        end
      end
    end
  end
end

local function AddTeamToContainer(self, list, container)
  self:SetAllTeamCellDestroy()
  if list ~= nil and container then
    local num = 0
    for i = 1, 3 do
      num = num + 1
      self.teamCellReq[i] = self:GameObjectInstantiateAsync(UIAssets.TeamCell, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(container.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = container:AddComponent(TeamCell, nameStr)
        cell:Refresh(i, list[i])
      end)
    end
  end
end

local function AddHeroToContainer(self, list)
  self.lineUp_content:RemoveComponents(FormationHeroItem)
  self.heroItemPrefab.gameObject:GameObjectRecycleAll()
  
  local function CreateOneHero(index, data, hideIfNoData)
    if data == nil and hideIfNoData then
      return
    end
    local go = self.heroItemPrefab:GameObjectSpawn(self.lineUp_content.transform)
    local nameStr = "FormationHeroItem" .. index
    go.name = nameStr
    local cell = self.lineUp_content:AddComponent(FormationHeroItem, nameStr)
    cell:SetActive(true)
    if data then
      cell:InitWithConfigId(data.id, nil, data.level, data.rankLv, data.weaponLevel, data.awakenLv, data.heroSkinId)
    else
      cell:InitWithConfigId(nil)
    end
  end
  
  if list then
    CreateOneHero(ArmyFormationSlot.Dominator, list[ArmyFormationSlot.Dominator], true)
    for i = 1, 5 do
      CreateOneHero(i, list[i], false)
    end
  end
end

local function Update1000MS(self)
  if self.data == nil or self.data.arriveTs == nil then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > self.data.arriveTs then
    self.timeTxt:SetLocalText(457520)
  else
    self.timeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.data.arriveTs - now))
  end
end

local function OnInfoClick(self)
  self.animator:Enable(true)
  self.animator:Play("switchEnter", 0, 0)
  self:RefreshInfo()
end

local function OnReturnClick(self)
  self.animator:Enable(true)
  self.animator:Play("switchOut", 0, 0)
end

local function OnInfoClick2(self)
  local content = Localization:GetString(457535)
  UIUtil.ShowBubbleTips(content, self.weightBtn.transform.position, 0, 0, -20)
end

local function OnDetailClick(self)
  if self.data and self.data.uuid then
    if self.data.type == TrainType.Train then
      RailwayUtil.OpenTrainInfoUI(self.data)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrainDetail, {anim = false}, self.data)
    end
  end
end

WorldTrainDes.OnCreate = OnCreate
WorldTrainDes.OnDestroy = OnDestroy
WorldTrainDes.OnEnable = OnEnable
WorldTrainDes.OnDisable = OnDisable
WorldTrainDes.ComponentDefine = ComponentDefine
WorldTrainDes.ComponentDestroy = ComponentDestroy
WorldTrainDes.DataDefine = DataDefine
WorldTrainDes.DataDestroy = DataDestroy
WorldTrainDes.Update1000MS = Update1000MS
WorldTrainDes.RefreshData = RefreshData
WorldTrainDes.AddRewardToContainer = AddRewardToContainer
WorldTrainDes.AddHeroToContainer = AddHeroToContainer
WorldTrainDes.AddTeamToContainer = AddTeamToContainer
WorldTrainDes.SetAllCellDestroy = SetAllCellDestroy
WorldTrainDes.SetAllHeroSmallCellDestroy = SetAllHeroSmallCellDestroy
WorldTrainDes.SetAllTeamCellDestroy = SetAllTeamCellDestroy
WorldTrainDes.OnReturnClick = OnReturnClick
WorldTrainDes.OnInfoClick = OnInfoClick
WorldTrainDes.OnInfoClick2 = OnInfoClick2
WorldTrainDes.OnDetailClick = OnDetailClick
WorldTrainDes.RefreshInfo = RefreshInfo
return WorldTrainDes
