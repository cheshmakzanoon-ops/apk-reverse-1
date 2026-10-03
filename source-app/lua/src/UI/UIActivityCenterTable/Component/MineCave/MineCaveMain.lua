local MineCaveMain = BaseClass("MineCaveMain", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local MyMineCaveItem = require("UI.UIActivityCenterTable.Component.MineCave.MyMineCaveItem")
local MineCaveItem = require("UI.UIActivityCenterTable.Component.MineCave.MineCaveItem")
local infoOffset_path = "Offset"
local title_path = "Offset/title"
local infoBtn_path = "Offset/infoBtn"
local score_path = "Offset/score"
local scoreNum_path = "Offset/score/scoreNum"
local minesPreviewTip_path = "Offset/previewTip"
local minesPreview_path = "Offset/minesPreview/minePreview"
local minesList_path = "Offset/minesList/mine"
local battleTip_path = "Offset/battleTip"
local occupyTip_path = "Offset/occupyTip"
local battleNum_path = "Offset/battleTip/battleNum"
local occupyNum_path = "Offset/occupyTip/occupyNum"
local myCanves_path = "Offset/MyCaves/myCave"
local detectTxt_path = "Offset/detectBtn/freeTxt"
local detectBtn_path = "Offset/detectBtn"
local detectBtnTxt1_path = "Offset/detectBtn/firstUseText"
local detectCost_path = "Offset/detectBtn/UseItem"
local detectCostTxt_path = "Offset/detectBtn/UseItem/txt2"
local detectBtnTxt2_path = "Offset/detectBtn/UseItem/Txt1"
local logBtn_path = "Offset/logBtn"
local logBtnTxt_path = "Offset/logBtn/logBtnTxt"
local logBtnRed_path = "Offset/logBtn/logBtnRed"
local dispatchBg_path = "Offset/MyCaves/dispatchBg"
local troopName_path = "Offset/MyCaves/myCave%s/title_tips%s"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  DataCenter.DailyActivityManager:UpdateActViewHistory(5)
  DataCenter.MineCaveManager:UpdateToUnlockList(true)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.infoOffsetN = self:AddComponent(UIBaseContainer, infoOffset_path)
  self.titleN = self:AddComponent(UIText, title_path)
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.titleN:SetLocalText(302207)
  self.scoreN = self:AddComponent(UIText, score_path)
  self.scoreNumN = self:AddComponent(UIText, scoreNum_path)
  self.minesPreviewTipN = self:AddComponent(UIText, minesPreviewTip_path)
  self.minesPreviewTipN:SetLocalText(302209)
  self.minesPreviewTb = {}
  for i = 1, 10 do
    local strPath = minesPreview_path .. i
    local minePreview = self:AddComponent(MyMineCaveItem, strPath)
    table.insert(self.minesPreviewTb, minePreview)
  end
  self.minesTb = {}
  for i = 1, 5 do
    local strPath = minesList_path .. i
    local mine = self:AddComponent(MineCaveItem, strPath)
    table.insert(self.minesTb, mine)
  end
  self.battleTipN = self:AddComponent(UIText, battleTip_path)
  self.occupyTipN = self:AddComponent(UIText, occupyTip_path)
  self.occupyTipN:SetActive(false)
  self.myCavesTb = {}
  for i = 1, 3 do
    local strPath = myCanves_path .. i
    local my = self:AddComponent(MyMineCaveItem, strPath)
    table.insert(self.myCavesTb, my)
  end
  self.detectTxtN = self:AddComponent(UIText, detectTxt_path)
  self.detectBtnN = self:AddComponent(UIButton, detectBtn_path)
  self.detectBtnN:SetOnClick(function()
    self:OnClickDetectBtn()
  end)
  self.detectBtnTxt1N = self:AddComponent(UIText, detectBtnTxt1_path)
  self.detectBtnTxt1N:SetLocalText(302214)
  self.detectBtnTxt2N = self:AddComponent(UIText, detectBtnTxt2_path)
  self.detectBtnTxt2N:SetLocalText(302214)
  self.detectCostN = self:AddComponent(UIBaseContainer, detectCost_path)
  self.detectCostTxtN = self:AddComponent(UIText, detectCostTxt_path)
  self.logBtnN = self:AddComponent(UIButton, logBtn_path)
  self.logBtnN:SetOnClick(function()
    self:OnClickLogBtn()
  end)
  self.logBtnTxtN = self:AddComponent(UIText, logBtnTxt_path)
  self.logBtnTxtN:SetLocalText(390264)
  self.logBtnRedN = self:AddComponent(UIBaseContainer, logBtnRed_path)
  self.dispatchBgN = self:AddComponent(UIButton, dispatchBg_path)
  self.dispatchBgN:SetActive(false)
  self.dispatchBgN:SetOnClick(function()
    self:OnClickDispatchBg()
  end)
  for i = 1, 3 do
    local tempPath = string.format(troopName_path, i, i)
    local tempName = self:AddComponent(UIText, tempPath)
    tempName:SetText(Localization:GetString(tostring(302031 + i)))
  end
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.scoreN = nil
  self.scoreNumN = nil
  self.minesPreviewTb = nil
  self.minesTb = nil
  self.battleTipN = nil
  self.occupyTipN = nil
  self.myCavesTb = nil
  self.detectTimesN = nil
  self.detectBtnN = nil
  self.detectBtnTxt1N = nil
  self.detectBtnTxt2N = nil
  self.detectCostN = nil
  self.detectCostTxtN = nil
end

local function DataDefine(self)
  self.mineCaveInfo = nil
  self.isShowDispatch = nil
  self.toUnlockMinesInfo = nil
  self.toUnlockMineItems = {}
  self.cacheOldScore = nil
end

local function DataDestroy(self)
  self.mineCaveInfo = nil
  self.isShowDispatch = nil
  self.toUnlockMinesInfo = nil
  self.toUnlockMineItems = nil
  self.cacheOldScore = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateMineCaveInfo, self.RefreshAll)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.RefreshLogRed)
  self:AddUIListener(EventId.MineCaveShowDispatch, self.ShowDispatch)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateMineCaveInfo, self.RefreshAll)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.RefreshLogRed)
  self:RemoveUIListener(EventId.MineCaveShowDispatch, self.ShowDispatch)
  base.OnRemoveListener(self)
end

local function SetData(self)
  SFSNetwork.SendMessage(MsgDefines.GetMineCaveInfo)
end

local function RefreshAll(self, forceRefresh)
  self.mineCaveInfo = DataCenter.MineCaveManager:GetMineCaveInfo()
  self.cacheOldScore = self.cacheOldScore or self.mineCaveInfo.curScore
  self.cacheOldScore = forceRefresh and self.mineCaveInfo.curScore or self.cacheOldScore
  if not self.mineCaveInfo then
    self.infoOffsetN:SetActive(false)
    return
  end
  self.infoOffsetN:SetActive(true)
  self.scoreN:SetLocalText(302208, self.mineCaveInfo.curScore)
  self.scoreNumN:SetText("")
  self:RefreshLogRed()
  local previewList = DataCenter.MineCaveManager:GetPreviewList(self.cacheOldScore)
  for i = 1, #self.minesPreviewTb do
    if i <= #previewList then
      self.minesPreviewTb[i]:SetActive(true)
      self.minesPreviewTb[i]:SetMinePreview(previewList[i])
    else
      self.minesPreviewTb[i]:SetActive(false)
    end
  end
  self:RefreshToUnlockMines()
  for i, v in ipairs(self.minesTb) do
    if i <= #self.mineCaveInfo.minesList then
      v:SetActive(true)
      v:SetItem(self.mineCaveInfo.minesList[i], i)
    else
      v:SetActive(false)
    end
  end
  local formationList = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
  local formationCount = #formationList
  local myList = self.mineCaveInfo:GetMyMinesList()
  for i, v in ipairs(self.myCavesTb) do
    if i <= formationCount then
      v:SetActive(true)
      v:SetMine(i, myList[i], function(tempIndex)
        self:SelectDispatch(tempIndex)
      end)
    else
      v:SetActive(true)
      v:SetMineLocked()
    end
  end
  local k3 = LuaEntry.DataConfig:TryGetNum("mine_cave", "k3")
  local addNum = LuaEntry.Effect:GetGameEffect(EffectDefine.REFRESH_MINE_CAVE_REFRESH_TIME_ADD)
  self.battleTipN:SetLocalText(302210, math.floor(k3 - self.mineCaveInfo.fightNum + addNum) .. "/" .. math.floor(k3 + addNum))
  local formationList = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
  local busyFormations = self.mineCaveInfo:GetBusyFormations()
  self.occupyTipN:SetLocalText(302211, #busyFormations .. "/" .. #formationList)
  local refreshTime = self.mineCaveInfo.refreshNum
  local tempCost, intervalMax = DataCenter.MineCaveManager:GetRefreshCost()
  local k4 = LuaEntry.DataConfig:TryGetNum("mine_cave", "k4")
  if tempCost == 0 then
    self.detectBtnN:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_btn_green101.png")
    self.detectTxtN:SetLocalText(302212, intervalMax - refreshTime .. "/" .. intervalMax)
    self.detectBtnTxt1N:SetActive(true)
    self.detectCostN:SetActive(false)
  else
    self.detectBtnN:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/common_btn_yellow101.png")
    local numDetectTimes = k4 - refreshTime
    if numDetectTimes <= 0 then
      self.detectTxtN:SetLocalText(302225)
    else
      self.detectTxtN:SetLocalText(302213, numDetectTimes .. "/" .. k4)
    end
    self.detectBtnTxt1N:SetActive(false)
    self.detectCostN:SetActive(true)
    self.detectCostTxtN:SetText(tempCost)
  end
  if DataCenter.MineCaveManager:CheckIfCanRefresh() then
    UIGray.SetGray(self.detectBtnN.transform, false, true)
  else
    UIGray.SetGray(self.detectBtnN.transform, true, false)
  end
end

local function RefreshToUnlockMines(self)
  local tempInfo = DataCenter.MineCaveManager:GetToUnlockMinesInfo()
  if not tempInfo then
    return
  end
  local previewList = DataCenter.MineCaveManager:GetPreviewList(self.mineCaveInfo.curScore)
  local toUnlockList = tempInfo.minesConfList
  self.toUnlockMineItems = {}
  if 0 < #toUnlockList then
    local previewCount = #previewList
    for i = previewCount + 1, #self.minesPreviewTb do
      local toUnlockIndex = i - previewCount
      if toUnlockIndex <= #toUnlockList then
        self.minesPreviewTb[i]:SetActive(true)
        self.minesPreviewTb[i]:SetMineToUnlock(toUnlockList[toUnlockIndex], tempInfo)
        table.insert(self.toUnlockMineItems, self.minesPreviewTb[i])
      else
        self.minesPreviewTb[i]:SetActive(false)
      end
    end
  end
  self.toUnlockMinesInfo = tempInfo
end

local function RefreshLogRed(self)
  local hasNewLog = DataCenter.MineCaveManager:CheckIfHasPlunderRed()
  self.logBtnRedN:SetActive(hasNewLog)
end

local function ShowMineCaveTip(self, showType, mineConf)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, showType, mineConf)
end

local function ShowDispatch(self, isShow)
  self.isShowDispatch = isShow
  self.dispatchBgN:SetActive(isShow)
  for i, v in ipairs(self.myCavesTb) do
    v:SetShowDispatch(self.isShowDispatch)
  end
end

local function SelectDispatch(self, index)
  if not self.isShowDispatch then
    return
  end
  if index then
    local formationInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByIndex(index)
    DataCenter.MineCaveManager:SetDispatchFormation(formationInfo.uuid)
    local id = MineCavePveLevelId
    local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(id)
    if pveTemplate ~= nil then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityCenterTable)
      local param = {}
      param.pveEntrance = PveEntrance.MineCave
      param.levelId = id
      param.isStart = true
      Logger.Log("UIMineCaveTipsView StartPve|", id)
      DataCenter.BattleLevel:Enter(param)
    end
  end
end

local function OnClickDispatchBg(self)
  self:ShowDispatch()
end

local function OnClickDetectBtn(self)
  SFSNetwork.SendMessage(MsgDefines.RefreshMineCaveList)
end

local function OnClickLogBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMineCaveLog)
end

local function OnClickInfoBtn(self)
  UIUtil.ShowIntro(Localization:GetString("302207"), "", Localization:GetString("302226"))
end

MineCaveMain.OnCreate = OnCreate
MineCaveMain.OnDestroy = OnDestroy
MineCaveMain.ComponentDefine = ComponentDefine
MineCaveMain.ComponentDestroy = ComponentDestroy
MineCaveMain.DataDefine = DataDefine
MineCaveMain.DataDestroy = DataDestroy
MineCaveMain.OnAddListener = OnAddListener
MineCaveMain.OnRemoveListener = OnRemoveListener
MineCaveMain.SetData = SetData
MineCaveMain.RefreshAll = RefreshAll
MineCaveMain.ShowMineCaveTip = ShowMineCaveTip
MineCaveMain.RefreshToUnlockMines = RefreshToUnlockMines
MineCaveMain.ShowDispatch = ShowDispatch
MineCaveMain.SelectDispatch = SelectDispatch
MineCaveMain.OnClickDetectBtn = OnClickDetectBtn
MineCaveMain.OnClickInfoBtn = OnClickInfoBtn
MineCaveMain.OnClickLogBtn = OnClickLogBtn
MineCaveMain.RefreshLogRed = RefreshLogRed
MineCaveMain.OnClickDispatchBg = OnClickDispatchBg
return MineCaveMain
