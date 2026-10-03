local UIWorldDeclareWarInfoView = BaseClass("UIWorldDeclareWarInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "UICommonMiniPopUpTitle/titleText"
local close_path = "UICommonMiniPopUpTitle/CloseBtn"
local return_path = "UICommonMiniPopUpTitle/panel"
local Txt_Tips = "Root/Txt_Tips"
local Txt_City = "Root/Txt_City"
local Txt_DeclareTime = "Root/Txt_DeclareTime"
local tips_btn_path = "Root/Txt_DeclareTime/Btn_Tips"
local Txt_DeclareTitle = "Root/Txt_DeclareTitle"
local Btn_GoDeclare = "Root/Btn_GoDeclare"
local Txt_GoDeclare = "Root/Btn_GoDeclare/Txt_GoDeclare"
local Txt_Content = "Root/ScrollView/Viewport/Content/desTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:DeleteTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self._title_txt = self:AddComponent(UIText, title_path)
  self._close_btn = self:AddComponent(UIButton, close_path)
  self._return_btn = self:AddComponent(UIButton, return_path)
  self._close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self._return_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self._tips_txt = self:AddComponent(UIText, Txt_Tips)
  self._city_txt = self:AddComponent(UIText, Txt_City)
  self._declareTitle_txt = self:AddComponent(UIText, Txt_DeclareTitle)
  self._declareTime_txt = self:AddComponent(UIText, Txt_DeclareTime)
  self._goDecelare_btn = self:AddComponent(UIButton, Btn_GoDeclare)
  self._goDecelare_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickPos()
  end)
  self._goDeclare_txt = self:AddComponent(UIText, Txt_GoDeclare)
  self._tips_btn = self:AddComponent(UIButton, tips_btn_path)
  self._tips_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickTips()
  end)
  self._content_txt = self:AddComponent(UIText, Txt_Content)
end

local function ComponentDestroy(self)
  self._title_txt = nil
  self._close_btn = nil
  self._return_btn = nil
  self._tips_txt = nil
  self._city_txt = nil
  self._declareTitle_txt = nil
  self._declareTime_txt = nil
  self._goDecelare_btn = nil
  self._tips_btn = nil
  self._goDeclare_txt = nil
end

local function DataDefine(self)
  self.k2 = DataCenter.AllianceDeclareWarManager:GetConfigData("k2")
  self.k3 = DataCenter.AllianceDeclareWarManager:GetConfigData("k3")
  self.k5 = DataCenter.AllianceDeclareWarManager:GetConfigData("k5")
  self.k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
  
  function self.timer_action(temp)
    self:RefreshTimer()
  end
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self._title_txt:SetLocalText(143549)
  local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
  if not data then
    return
  end
  self.data = data
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.data.content)
  if cityTemplate ~= nil then
    local str = ""
    local level = cityTemplate.level
    local userName = ""
    local name = cityTemplate.name
    local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(tonumber(self.data.content))
    if cityInfo ~= nil and cityInfo.cityName ~= nil and cityInfo.cityName ~= "" then
      userName = cityInfo.cityName
    end
    local tilePos = cityTemplate.pos
    if userName ~= nil and userName ~= "" then
      str = Localization:GetString("310128", level, userName)
    else
      str = Localization:GetString("310128", level, Localization:GetString(name))
    end
    self._tips_txt:SetLocalText(302309, str)
    local pointId = SceneUtils.TilePosToIndex(tilePos)
    local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
    local alAbbr = ""
    local alName = ""
    if pointInfo ~= nil then
      local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
      if allianceCityPointInfo ~= nil then
        alAbbr = allianceCityPointInfo.alAbbr
        alName = allianceCityPointInfo.alName
      end
    end
    local nameStr = Localization:GetString("100206")
    if alAbbr ~= "" and alName ~= "" then
      nameStr = "[" .. alAbbr .. "]" .. alName
    end
    self._city_txt:SetLocalText(302310, nameStr)
  end
  self:AddTimer()
  self:RefreshTimer()
  self._declareTitle_txt:SetText(Localization:GetString("143554") .. ": ")
  self._content_txt:SetText(self.data.anno)
  self._goDeclare_txt:SetLocalText(302313)
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
end

local function RefreshTimer(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.data.et - curTime
  if 0 < remainTime then
    self._declareTime_txt:SetLocalText(302311, UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self._declareTime_txt:SetText("00:00:00")
    self:DeleteTimer()
  end
end

local function DeleteTimer(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnClickPos(self)
  local cityData = LocalController:instance():getLine(TableName.WorldCity, tonumber(self.data.content))
  local cityLoc = string.split(cityData.location, "|")
  local v2 = Vector2.New(tonumber(cityLoc[1]), tonumber(cityLoc[2]))
  local worldPos = SceneUtils.TileToWorld(v2)
  worldPos.x = worldPos.x
  worldPos.z = worldPos.z
  local posIndex = SceneUtils.WorldToTileIndex(worldPos, ForceChangeScene.World)
  self.ctrl:JumpToTargetPoint(posIndex)
end

local function OnClickTips(self)
  local param = {}
  param.type = "desc"
  param.title = ""
  param.desc = Localization:GetString("302312")
  param.alignObject = self._tips_btn
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

UIWorldDeclareWarInfoView.OnCreate = OnCreate
UIWorldDeclareWarInfoView.OnDestroy = OnDestroy
UIWorldDeclareWarInfoView.OnEnable = OnEnable
UIWorldDeclareWarInfoView.OnDisable = OnDisable
UIWorldDeclareWarInfoView.ComponentDefine = ComponentDefine
UIWorldDeclareWarInfoView.ComponentDestroy = ComponentDestroy
UIWorldDeclareWarInfoView.DataDefine = DataDefine
UIWorldDeclareWarInfoView.DataDestroy = DataDestroy
UIWorldDeclareWarInfoView.ReInit = ReInit
UIWorldDeclareWarInfoView.IptOnValueChange = IptOnValueChange
UIWorldDeclareWarInfoView.OnClickPos = OnClickPos
UIWorldDeclareWarInfoView.OnClickTips = OnClickTips
UIWorldDeclareWarInfoView.AddTimer = AddTimer
UIWorldDeclareWarInfoView.RefreshTimer = RefreshTimer
UIWorldDeclareWarInfoView.DeleteTimer = DeleteTimer
return UIWorldDeclareWarInfoView
