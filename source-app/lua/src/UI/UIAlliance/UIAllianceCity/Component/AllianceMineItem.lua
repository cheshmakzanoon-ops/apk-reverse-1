local AllianceMineItem = BaseClass("AllianceMineItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local mineIcon_path = "Bg/icon"
local mineLv_path = "Bg/icon/level"
local collectImg_path = "Bg/collecting"
local mineName_path = "Bg/name"
local minePos_path = "Bg/pos"
local jumpBtn_path = "Bg/posBtn"
local conditionTxt_path = "Bg/layout/condition"
local desTxt_path = "Bg/desTxt"
local fitImg_path = "Bg/layout/condition/fit"
local prog_path = "Bg/ProgressSlider"
local progTip_path = "Bg/ProgressSlider/tip"
local progNum_path = "Bg/ProgressSlider/Txt_Progress"
local buildBtn_path = "Bg/buildBtn"
local buildBtnTxt_path = "Bg/buildBtn/build"
local lockedMask_path = "Bg/locked"
local lockedTip_path = "Bg/locked/lockedTip"

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

local function ComponentDefine(self)
  self.mineIconN = self:AddComponent(UIImage, mineIcon_path)
  self.mineLvN = self:AddComponent(UIText, mineLv_path)
  self.mineNameN = self:AddComponent(UIText, mineName_path)
  self.statusImgN = self:AddComponent(UIImage, collectImg_path)
  self.minePosN = self:AddComponent(UIText, minePos_path)
  self.jumpBtnN = self:AddComponent(UIButton, jumpBtn_path)
  self.jumpBtnN:SetOnClick(function()
    self:OnClickJumpBtn()
  end)
  self.conditionTbN = {}
  for i = 1, 3 do
    local conditionTxt = self:AddComponent(UIText, conditionTxt_path .. i)
    local tempGo = self:AddComponent(UIBaseContainer, conditionTxt_path .. i)
    local fitImg = tempGo:AddComponent(UIImage, "fit")
    local newCond = {}
    newCond.conditionTxtN = conditionTxt
    newCond.fitImgN = fitImg
    table.insert(self.conditionTbN, newCond)
  end
  self.desTxtN = self:AddComponent(UIText, desTxt_path)
  self.desTxtN:SetLocalText(300788)
  self.progN = self:AddComponent(UISlider, prog_path)
  self.progTipN = self:AddComponent(UIText, progTip_path)
  self.progNumN = self:AddComponent(UIText, progNum_path)
  self.buildBtnN = self:AddComponent(UIButton, buildBtn_path)
  self.buildBtnN:SetOnClick(function()
    self:OnClickBuildBtn()
  end)
  self.buildBtnTxtN = self:AddComponent(UIText, buildBtnTxt_path)
  self.buildBtnTxtN:SetLocalText(300751)
end

local function ComponentDestroy(self)
  self:DelCountDownTimer()
  self.mineIconN = nil
  self.mineLvN = nil
  self.mineNameN = nil
  self.statusImgN = nil
  self.minePosN = nil
  self.conditionTxtN = nil
  self.conditionFitN = nil
  self.progN = nil
  self.progTipN = nil
  self.progNumN = nil
  self.buildBtnN = nil
  self.buildBtnTxtN = nil
end

local function DataDefine(self)
  self.mineTemplate = nil
end

local function DataDestroy(self)
  self.mineTemplate = nil
end

local function SetItemShow(self, mineTemplate)
  self.mineTemplate = mineTemplate
  self.mineInfo = DataCenter.AllianceMineManager:GetMineInfoById(self.mineTemplate.id)
  self:RefreshAll()
end

local function RefreshAll(self)
  self.mineIconN:LoadSprite(self.mineTemplate:GetIconPath())
  self.mineNameN:SetLocalText(self.mineTemplate.name)
  self.mineLvN:SetText(self.mineTemplate.level)
  self:RefreshMine()
end

local function RefreshMine(self)
  if self.mineInfo then
    self.buildBtnN:SetActive(false)
    self.progN:SetActive(true)
    self.statusImgN:SetActive(true)
    self.minePosN:SetActive(true)
    local tilePos = SceneUtils.IndexToTilePos(self.mineInfo.pointId, ForceChangeScene.World)
    self.minePosN:SetText(" ( " .. tilePos.x .. "," .. tilePos.y .. " ) ")
    if self.mineInfo.status == AllianceMineStatus.Normal then
      self.curNum = self.mineInfo.remainNum
      self:AddCountDownTimer()
      self:RefreshRemainTime()
      self.desTxtN:SetActive(true)
      self.progTipN:SetLocalText(300039)
      self.statusImgN:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/UIlmk_chanzi.png")
    else
      local remain = self.mineTemplate.resDurable - self.mineInfo.durability
      local remainT = remain / self.mineInfo.buildSpeed
      local endT = self.mineInfo.lastBuildTime + remainT * 1000
      self.buildEndTime = endT
      self:AddCountDownTimer()
      self:RefreshRemainTime()
      self.progTipN:SetLocalText(390210)
      self.desTxtN:SetActive(false)
      self.statusImgN:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/UImk_chuizi.png")
    end
    self:RefreshConditions(false)
  else
    self.desTxtN:SetActive(false)
    self.statusImgN:SetActive(false)
    self.progN:SetActive(false)
    self.minePosN:SetActive(false)
    local allFit, fitDic = DataCenter.AllianceMineManager:CheckIfConditionFits(self.mineTemplate)
    if allFit then
      if DataCenter.AllianceBaseDataManager:IsR4orR5() then
        self.buildBtnN:SetActive(true)
        self:RefreshConditions(false)
      else
        self.buildBtnN:SetActive(false)
        self:RefreshConditions(true)
      end
    else
      self.buildBtnN:SetActive(false)
      self:RefreshConditions(true)
    end
  end
end

local function RefreshConditions(self, showFit)
  for i, v in ipairs(self.conditionTbN) do
    if showFit then
      local ok, condDesc = DataCenter.AllianceMineManager:GetConditionInfo(self.mineTemplate, i)
      if condDesc == nil or condDesc == "" then
        v.conditionTxtN:SetActive(false)
        v.fitImgN:SetActive(false)
      else
        v.conditionTxtN:SetActive(true)
        v.conditionTxtN:SetText(condDesc)
        local tempFit = DataCenter.AllianceMineManager:CheckIfConditionFits(self.mineTemplate, i)
        v.fitImgN:SetActive(true)
        local fitImg = tempFit and "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_img_select_yes.png" or "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_img_select_no.png"
        v.fitImgN:LoadSprite(fitImg)
      end
    else
      v.conditionTxtN:SetActive(false)
      v.fitImgN:SetActive(false)
    end
  end
end

local function AddCountDownTimer(self)
  function self.CountDownTimerAction()
    self:RefreshRemainTime()
  end
  
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction, self, false, false, false)
  end
  self.countDownTimer:Start()
end

local function RefreshRemainTime(self)
  if self.mineInfo ~= nil and self.mineTemplate ~= nil then
    if self.mineInfo.status == AllianceMineStatus.Normal then
      self.curNum = self.curNum - self.mineInfo.collectSpeed
      if self.curNum <= 0 then
        self.progN:SetValue(0)
        self.progNumN:SetLocalText(150033, 0, string.GetFormattedStr(self.mineInfo.initNum))
        self:DelCountDownTimer()
        return
      end
      local tempProg = self.curNum / self.mineInfo.initNum
      self.progN:SetValue(tempProg)
      self.progNumN:SetLocalText(150033, string.GetFormattedStr(self.curNum), string.GetFormattedStr(self.mineInfo.initNum))
    else
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local remainTime = self.buildEndTime - curTime
      if remainTime ~= nil and 0 < remainTime then
        self.progNumN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(math.floor(remainTime)))
        local tempProg = self.mineInfo:GetConstructDurability() / self.mineTemplate.resDurable
        self.progN:SetValue(tempProg)
      else
        self.progNumN:SetText("")
        self.progN:SetValue(1)
        self:DelCountDownTimer()
      end
    end
  end
end

local function DelCountDownTimer(self)
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

local function OnClickBuildBtn(self)
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId(803040)
    return
  end
  local myAlMines = DataCenter.AllianceMineManager:GetMyAlMines()
  if myAlMines ~= nil and table.count(myAlMines) > 0 then
    UIUtil.ShowTipsId(300750)
    return
  end
  local hasAlTerritory = DataCenter.WorldAllianceCityDataManager:CheckIfHasAlCity()
  if hasAlTerritory then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCitySelect, self.mineTemplate.id)
  else
    local mineId = self.mineTemplate.id
    local pointId = LuaEntry.Player:GetMainWorldPos()
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), nil, 0.02, function()
      BuildingUtils.ShowPutAllianceBuild(mineId, 0, pointId, PlaceBuildType.Build)
    end, LuaEntry.Player:GetSelfServerId())
  end
end

local function OnClickJumpBtn(self)
  if self.mineInfo then
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(self.mineInfo.pointId, ForceChangeScene.World))
  end
end

AllianceMineItem.OnCreate = OnCreate
AllianceMineItem.OnDestroy = OnDestroy
AllianceMineItem.ComponentDefine = ComponentDefine
AllianceMineItem.ComponentDestroy = ComponentDestroy
AllianceMineItem.DataDefine = DataDefine
AllianceMineItem.DataDestroy = DataDestroy
AllianceMineItem.SetItemShow = SetItemShow
AllianceMineItem.RefreshAll = RefreshAll
AllianceMineItem.RefreshMine = RefreshMine
AllianceMineItem.RefreshConditions = RefreshConditions
AllianceMineItem.DelCountDownTimer = DelCountDownTimer
AllianceMineItem.RefreshRemainTime = RefreshRemainTime
AllianceMineItem.AddCountDownTimer = AddCountDownTimer
AllianceMineItem.OnClickBuildBtn = OnClickBuildBtn
AllianceMineItem.OnClickJumpBtn = OnClickJumpBtn
return AllianceMineItem
