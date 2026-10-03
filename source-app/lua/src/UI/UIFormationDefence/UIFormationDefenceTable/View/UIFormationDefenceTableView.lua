local FormationHeroSelectList = require("UI.UIFormationDefence.UIFormationDefenceTable.Component.FormationHeroSelectList")
local FormationDefenceCell = require("UI.UIFormationDefence.UIFormationDefenceTable.Component.FormationDefenceCell")
local FormationDefenceUnlock = require("UI.UIFormationDefence.UIFormationDefenceTable.Component.FormationDefenceUnlock")
local CityManage = require("UI.UIFormationDefence.UIFormationDefenceTable.Component.CityManage")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UIFormationDefenceTableView = BaseClass("UIFormationDefenceTableView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "ImgBg/UICommonPopUpTitle/panel"
local close_btn_path = "ImgBg/UICommonPopUpTitle/CloseBtn"
local txt_title_path = "ImgBg/UICommonPopUpTitle/Common_img_title/titleText"
local layout_content_path = "ImgBg/defence/ScrollView/Viewport/Content"
local build_name_path = "ImgBg/defence/mainObj/buildName"
local build_des_path = "ImgBg/defence/mainObj/buildDes"
local build_icon_path = "ImgBg/defence/mainObj/img_building"
local protect_time_text_path = "ImgBg/defence/mainObj/warProtectTimeText"
local fix_btn_path = "ImgBg/defence/mainObj/fixBtn"
local fix_btn_des_path = "ImgBg/defence/mainObj/fixBtn/btnDesObj/Txt1"
local fix_btn_num_path = "ImgBg/defence/mainObj/fixBtn/btnDesObj/txt2"
local fix_btn_icon_path = "ImgBg/defence/mainObj/fixBtn/btnDesObj/txt2/icon"
local slider_path = "ImgBg/defence/mainObj/defenceSlider"
local slider_txt_path = "ImgBg/defence/mainObj/defenceSliderTxt"
local cold_down_btn_path = "ImgBg/defence/mainObj/colddownBtn"
local cold_down_txt_path = "ImgBg/defence/mainObj/colddownBtn/colddownTxt"
local info_btn_path = "ImgBg/defence/mainObj/Common_btn_info"
local info_btn_path2 = "ImgBg/defence/mainObj/Common_btn_info2"
local mainObj_path = "ImgBg/defence/mainObj"
local protect_btn_path = "ImgBg/defence/Protect_Btn"
local protect_btn_text_path = "ImgBg/defence/Protect_Btn/Protect_Btn_Text"
local des_text_path = "ImgBg/defence/DetailGo/InfoScrollView/Viewport/Content/DesText"
local back_btn_path = "ImgBg/defence/DetailGo/BackBtn"
local character_path = "ImgBg/defence/character"
local intro_path = "ImgBg/defence/DetailGo"
local defence_path = "ImgBg/defence"
local cityBuff_path = "ImgBg/citybuff"
local defence_btn_path = "ImgBg/TabContent/DefenceTab"
local citybuff_btn_path = "ImgBg/TabContent/CityBuffTab"
local plyaerTab_icon_path = "ImgBg/TabContent/DefenceTab/playerIcon"
local forceTab_icon_path = "ImgBg/TabContent/CityBuffTab/forceIcon"
local TabType = {Defence = 1, CityBuff = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl:InitData()
  self.timer = nil
  
  function self.timer_action(temp)
    self:UpdateTime()
  end
  
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DeleteTimer()
  self:BackBtnClick()
  self.timer_action = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.main_obj = self.transform:Find("ImgBg").gameObject
  self.layout_content = self:AddComponent(UIBaseContainer, layout_content_path)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.character = self:AddComponent(UIImage, character_path)
  self.build_name = self:AddComponent(UIText, build_name_path)
  self.build_state = self:AddComponent(UIText, "ImgBg/defence/mainObj/buildState")
  self.capacityNum = self:AddComponent(UIText, "ImgBg/defence/mainObj/capacityNum")
  self.build_des = self:AddComponent(UIText, build_des_path)
  self.build_des:SetLocalText(GameDialogDefine.SOLDIERS_NUM_ON_WALL)
  self.build_icon = self:AddComponent(UIImage, build_icon_path)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.mainObj = self:AddComponent(UIBaseContainer, mainObj_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn2 = self:AddComponent(UIButton, info_btn_path2)
  self.intro = self:AddComponent(UIBaseContainer, intro_path)
  self.myCell = self:AddComponent(FormationDefenceCell, "ImgBg/defence/MyFormationDefenceCell")
  self.troop_des = self:AddComponent(UIText, "ImgBg/defence/mainObj/troopsDes")
  self.troop_des:SetLocalText(GameDialogDefine.DEFENCE_FORMATION)
  self.back_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:BackBtnClick()
  end)
  self.info_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:InfoBtnClick(1)
  end)
  self.info_btn2:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:InfoBtnClick(2)
  end)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnReturnClick()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.fix_btn = self:AddComponent(UIButton, fix_btn_path)
  self.fix_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:fixDefencePower()
  end)
  self.fix_btn_des = self:AddComponent(UIText, fix_btn_des_path)
  self.cold_down_btn = self:AddComponent(UIButton, cold_down_btn_path)
  self.cold_down_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  end)
  self.cold_down_txt = self:AddComponent(UIText, cold_down_txt_path)
  self.protect_btn = self:AddComponent(UIButton, protect_btn_path)
  self.protect_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:OnProtectClick()
  end)
  self.protect_btn_text = self:AddComponent(UIText, protect_btn_text_path)
  self.protect_btn_text:SetLocalText(129026)
  self.fix_btn_num = self:AddComponent(UIText, fix_btn_num_path)
  self.fix_btn_icon_path = self:AddComponent(UIText, fix_btn_icon_path)
  self.slider_txt = self:AddComponent(UIText, slider_txt_path)
  self.protect_time_text = self:AddComponent(UIText, protect_time_text_path)
  self.defence = self:AddComponent(UIBaseContainer, defence_path)
  self.cityBuff = self:AddComponent(CityManage, cityBuff_path)
  self.defence_btn = self:AddComponent(UIButton, defence_btn_path)
  self.defence_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:TabClick(TabType.Defence)
  end)
  self.citybuff_btn = self:AddComponent(UIButton, citybuff_btn_path)
  self.citybuff_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:TabClick(TabType.CityBuff)
  end)
  self.forceTab_icon = self:AddComponent(UIImage, forceTab_icon_path)
  self.plyaerTab_icon = self:AddComponent(UIImage, plyaerTab_icon_path)
  self.itemList = {}
  self.model = {}
  self.curFormationUuid = 0
  self.isUpdate = false
  self:SetPic()
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

local function ComponentDestroy(self)
  self.main_obj = nil
  self.layout_content = nil
  self.txt_title = nil
  self.slider = nil
  self.build_name = nil
  self.build_des = nil
  self.build_state = nil
  self.capacityNum = nil
  self.build_icon = nil
  self.btn = nil
  self.close_btn = nil
  self.fix_btn = nil
  self.fix_btn_des = nil
  self.cold_down_btn = nil
  self.cold_down_txt = nil
  self.protect_btn = nil
  self.protect_btn_text = nil
  self.fix_btn_num = nil
  self.fix_btn_icon_path = nil
  self.slider_txt = nil
  self.protect_time_text = nil
  self.des_text = nil
  self.back_btn = nil
  self.mainObj = nil
  self.character = nil
  self.intro = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:TabClick(TabType.Defence)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ArmyFormatUpdate, self.RefreshFormationList)
  self:AddUIListener(EventId.GetAssistanceData, self.RefreshFormationList)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ArmyFormatUpdate, self.RefreshFormationList)
  self:RemoveUIListener(EventId.GetAssistanceData, self.RefreshFormationList)
end

local function TabClick(self, tabType)
  if self.normalState == false then
    return
  end
  if tabType == TabType.Defence then
    self.defence_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_tab_up"))
    self.citybuff_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_tab_down"))
    self.defence:SetActive(true)
    self.cityBuff:SetActive(false)
    self:InitData()
  elseif tabType == TabType.CityBuff then
    self.defence_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_tab_down"))
    self.citybuff_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_tab_up"))
    self.defence:SetActive(false)
    self.cityBuff:SetActive(true)
    self.cityBuff:ReInit()
  end
end

local function InitData(self)
  SFSNetwork.SendMessage(MsgDefines.AllianceAssistanceInfo, nil, AssistanceType.MainCity)
  self.txt_title:SetLocalText(100532)
  self.normalState = true
  self:SetViewPos()
  self.build_name:SetLocalText(GameDialogDefine.DOME_DURABILITY)
  self.fix_btn_des:SetLocalText(GameDialogDefine.REPAIR_DEFENCE)
  self:RefreshFormationList()
  self:RefreshBuildData()
end

local function RefreshFormationList(self)
  local totalSoldierNum = DataCenter.SoldierDataManager:GetPlayerSoldiersTotalNum()
  self.capacityNum:SetText(string.GetFormattedSeperatorNum(math.floor(totalSoldierNum)))
  local squadData = DataCenter.ArmyFormationDataManager:GetDefenceFormation()
  if squadData then
    self.myCell:SetActive(true)
    self.myCell:RefreshData(squadData, 0)
  else
    self.myCell:SetActive(false)
  end
  self.ctrl:GetFormationIdList()
  local list = self.ctrl:GetMyAssistanceData()
  self:SetAllCellDestroy()
  if not list or 0 >= table.length(list) then
    return
  end
  for i = 1, table.length(list) do
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.FormationDefenceCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.layout_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = go.name .. i
      local cell = self.layout_content:AddComponent(FormationDefenceCell, go.name)
      cell:RefreshData(list[i], i)
      self.formationList[list[i]] = cell
    end)
  end
end

local function RefreshBuildData(self)
  local buildData = self.ctrl:GetBuildData()
  self.buildData = buildData
  if buildData ~= nil then
    self.slider_txt:SetText(string.GetFormattedSeperatorNum(math.floor(buildData.durability)) .. "/" .. string.GetFormattedSeperatorNum(math.floor(buildData.defDomeMaxNum)))
    self.fix_btn_num:SetText(string.GetFormattedSeperatorNum(math.floor(buildData.fixDiamond)))
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if buildData.durability < buildData.defDomeMaxNum then
      self.build_state:SetLocalText(GameDialogDefine.DOME_DURABILITY_DESTROY)
      local percent = buildData.durability / buildData.defDomeMaxNum
      self.slider:SetValue(percent)
      local k3 = LuaEntry.DataConfig:TryGetNum("city_wall", "k3")
      if curTime > buildData.lastGoldRecoverDurabilityTime + k3 * 1000 then
        self.fix_btn:SetActive(true)
        self.cold_down_btn:SetActive(false)
      else
        self.fix_btn:SetActive(false)
        self.cold_down_btn:SetActive(true)
      end
      self:AddTimer()
      self.isUpdate = true
      self:UpdateTime()
    else
      local protectEndTime = DataCenter.DefenceWallDataManager:GetDefenceWallData().protectEndTime
      local leftTime = protectEndTime - UITimeManager:GetInstance():GetServerTime()
      if 0 < leftTime then
        self:AddTimer()
        self:UpdateTime()
      else
        self:DeleteTimer()
      end
      self.isUpdate = false
      self.slider:SetValue(1)
      self.build_state:SetLocalText(GameDialogDefine.DOME_DURABILITY_FULL)
      self.fix_btn:SetActive(false)
      self.cold_down_btn:SetActive(false)
    end
  end
end

local function OnSelectHeroFinish(self, index)
  if self.formationList[self.curFormationUuid] ~= nil then
    self.formationList[self.curFormationUuid]:OnSelectHeroFinish(index)
  end
end

local function SetAllCellDestroy(self)
  self.layout_content:RemoveComponents(FormationDefenceCell)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
  self.formationList = {}
end

local function OnReturnClick(self)
  if self.normalState == false then
    self.normalState = true
    self:SetViewPos()
  else
    self.ctrl:CloseSelf()
  end
end

local function OnSelectClick(self, formationUuid, index)
  if self.normalState == false and index ~= nil then
    self.ctrl:OnDeleteHeroByIndex(index)
    self.view:OnSelectHeroFinish(index)
    return
  end
  self.curFormationUuid = formationUuid
  self.ctrl:SelectCurFormationUuid(formationUuid)
  self.normalState = false
  self:SetViewPos()
end

local function SetViewPos(self)
  if self.normalState then
    self.main_obj.transform:Set_localPosition(0, self.main_obj.transform.localPosition.y, 0)
    if self.formationList ~= nil then
      table.walk(self.formationList, function(k, v)
        v:SetSelectState(false)
      end)
    end
  else
    self.main_obj.transform:Set_localPosition(125, self.main_obj.transform.localPosition.y, 0)
  end
end

local function UpdateTime(self)
  local inProtect = false
  local inResume = false
  if self.isUpdate then
    local curData = self.ctrl:GetBuildData()
    self.buildData = curData
    if curData ~= nil then
      local curNum = curData.durability
      if curNum >= self.buildData.defDomeMaxNum then
        self:RefreshBuildData()
        return
      else
        curNum = curNum + self.buildData.defDomeAddSpeed
        self.slider_txt:SetText(string.GetFormattedSeperatorNum(math.floor(curNum)) .. "/" .. string.GetFormattedSeperatorNum(math.floor(self.buildData.defDomeMaxNum)))
        local percent = curNum / self.buildData.defDomeMaxNum
        self.slider:SetValue(percent)
      end
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local k3 = LuaEntry.DataConfig:TryGetNum("city_wall", "k3")
    local deltaTime = self.buildData.lastGoldRecoverDurabilityTime + k3 * 1000 - curTime
    if 0 <= deltaTime then
      self.cold_down_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
      self.fix_btn:SetActive(false)
      self.cold_down_btn:SetActive(true)
      inResume = true
    else
      self.fix_btn:SetActive(true)
      self.cold_down_btn:SetActive(false)
    end
  end
  local protectEndTime = DataCenter.DefenceWallDataManager:GetDefenceWallData().protectEndTime
  local leftTime = protectEndTime - UITimeManager:GetInstance():GetServerTime()
  if 0 < leftTime then
    self.protect_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
    inProtect = true
  else
    self.protect_time_text:SetText("")
  end
  self:SetPic(inProtect, inResume)
end

local function GetPicPath(self, inProtect, inResume)
  if inProtect == true then
    return "Assets/Main/Sprites/UI/UIFormationDefence/UIFormationDefence_img_building_inProtect"
  end
  local isFeverStatu = DataCenter.StatusManager:WarFeverStatu()
  if isFeverStatu ~= nil then
    return "Assets/Main/Sprites/UI/UIFormationDefence/UIFormationDefence_img_building_inWarFeverStatu"
  end
  return "Assets/Main/Sprites/UI/UIFormationDefence/UIFormationDefence_img_building"
end

local function SetPic(self, inProtect, inResume)
end

local function BackBtnClick(self)
  self.protect_btn:SetActive(true)
  self.layout_content:SetActive(true)
  self.mainObj:SetActive(true)
  self.character:SetActive(false)
  self.intro:SetActive(false)
end

local function InfoBtnClick(self, num)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local param = UIHeroTipView.Param.New()
  param.dir = UIHeroTipView.Direction.LEFT
  param.defWidth = 200
  param.pivot = 0.5
  if num == 1 then
    param.position = self.info_btn.gameObject.transform.position + Vector3.New(-50, 0, 0) * scaleFactor
    param.content = Localization:GetString(GameDialogDefine.DEFENCE_FORMATION_TIPS1)
  else
    param.position = self.info_btn2.gameObject.transform.position + Vector3.New(-50, 0, 0) * scaleFactor
    param.content = Localization:GetString(GameDialogDefine.DEFENCE_FORMATION_TIPS2)
  end
  param.deltaX = 0
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function SwitchContent(self, param)
  self.cityBuff:SwitchContent(param)
end

UIFormationDefenceTableView.OnCreate = OnCreate
UIFormationDefenceTableView.OnDestroy = OnDestroy
UIFormationDefenceTableView.OnEnable = OnEnable
UIFormationDefenceTableView.OnDisable = OnDisable
UIFormationDefenceTableView.ComponentDefine = ComponentDefine
UIFormationDefenceTableView.ComponentDestroy = ComponentDestroy
UIFormationDefenceTableView.OnAddListener = OnAddListener
UIFormationDefenceTableView.OnRemoveListener = OnRemoveListener
UIFormationDefenceTableView.InitData = InitData
UIFormationDefenceTableView.SetAllCellDestroy = SetAllCellDestroy
UIFormationDefenceTableView.RefreshBuildData = RefreshBuildData
UIFormationDefenceTableView.RefreshFormationList = RefreshFormationList
UIFormationDefenceTableView.OnSelectHeroFinish = OnSelectHeroFinish
UIFormationDefenceTableView.OnReturnClick = OnReturnClick
UIFormationDefenceTableView.OnSelectClick = OnSelectClick
UIFormationDefenceTableView.SetViewPos = SetViewPos
UIFormationDefenceTableView.AddTimer = AddTimer
UIFormationDefenceTableView.DeleteTimer = DeleteTimer
UIFormationDefenceTableView.UpdateTime = UpdateTime
UIFormationDefenceTableView.GetPicPath = GetPicPath
UIFormationDefenceTableView.SetPic = SetPic
UIFormationDefenceTableView.BackBtnClick = BackBtnClick
UIFormationDefenceTableView.InfoBtnClick = InfoBtnClick
UIFormationDefenceTableView.TabClick = TabClick
UIFormationDefenceTableView.SwitchContent = SwitchContent
return UIFormationDefenceTableView
