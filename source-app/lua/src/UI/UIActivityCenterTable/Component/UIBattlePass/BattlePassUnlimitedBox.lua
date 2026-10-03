local BattlePassUnlimitedBox = BaseClass("BattlePassUnlimitedBox", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local boxImg_path = "boxImg"
local boxName_path = "boxName"
local boxNameTip_path = "boxNameTip"
local progressBackground_path = "progressBackground"
local progressAmount_path = "progressBackground/progressAmount"
local progressNum_path = "progressBackground/progressNum"
local lockContent_path = "lockContent"
local notEnoughContent_path = "notEnoughContent"
local enoughContent_path = "enoughContent"
local unGetBtn_path = "notEnoughContent/unGetBtn"
local unGetBtnTxt_path = "notEnoughContent/unGetBtn/unGetBtnTxt"
local getBtn_path = "enoughContent/getBtn"
local getBtnTxt_path = "enoughContent/getBtn/getBtnTxt"
local boxNumContent_path = "boxNumContent"
local boxNum_path = "boxNumContent/boxNum"

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
  self.boxImg = self:AddComponent(UIImage, boxImg_path)
  self.boxImgBtn = self:AddComponent(UIButton, boxImg_path)
  self.boxName = self:AddComponent(UIText, boxName_path)
  self.boxNameTip = self:AddComponent(UIText, boxNameTip_path)
  self.boxImgBtn:SetOnClick(function()
    self:OnBoxClick()
  end)
  self.progressBackground = self:AddComponent(UIBaseContainer, progressBackground_path)
  self.progressAmount = self:AddComponent(UIBaseContainer, progressAmount_path)
  self.progressNum = self:AddComponent(UIText, progressNum_path)
  self.lockContent = self:AddComponent(UIBaseContainer, lockContent_path)
  self.notEnoughContent = self:AddComponent(UIBaseContainer, notEnoughContent_path)
  self.enoughContent = self:AddComponent(UIBaseContainer, enoughContent_path)
  self.unGetBtn = self:AddComponent(UIButton, unGetBtn_path)
  self.unGetBtnTxt = self:AddComponent(UIText, unGetBtnTxt_path)
  self.getBtn = self:AddComponent(UIButton, getBtn_path)
  self.getBtnTxt = self:AddComponent(UIText, getBtnTxt_path)
  self.getBtn:SetOnClick(function()
    self:OnGetBtnClick()
  end)
  self.unGetBtn:SetOnClick(function()
    self:OnUnGetBtnClick()
  end)
  self.boxNumContent = self:AddComponent(UIBaseContainer, boxNumContent_path)
  self.boxNum = self:AddComponent(UIText, boxNum_path)
  self.boxName:SetLocalText(320555)
end

local function ComponentDestroy(self)
  self.boxImg = nil
  self.boxImgBtn = nil
  self.boxName = nil
  self.boxNameTip = nil
  self.progressBackground = nil
  self.progressAmount = nil
  self.progressNum = nil
  self.lockContent = nil
  self.notEnoughContent = nil
  self.enoughContent = nil
  self.unGetBtn = nil
  self.unGetBtnTxt = nil
  self.getBtn = nil
  self.getBtnTxt = nil
  self.boxNumContent = nil
  self.boxNum = nil
end

local function DataDefine(self)
  self.activityId = nil
  self.actData = nil
end

local function DataDestroy(self)
  self.activityId = nil
  self.actData = nil
end

local function ReInit(self, activityId)
  self.activityId = activityId
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  if self.actData == nil then
    return
  end
  local isHave = self.actData:IsHaveExtraReward()
  if not isHave then
    return
  end
  local tabData = LocalController:instance():getLine(TableName.Activity, self.activityId)
  if tabData ~= nil then
    local boxImgName = tabData.para_4
    if not string.IsNullOrEmpty(boxImgName) then
      local imgPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath("Assets/Main/Sprites/UI/UIBattlePass/%s.png", boxImgName)
      self.boxImg:LoadSprite(imgPath)
    end
  end
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.boxImg.transform:Set_localPosition(308.3, 73, 0)
  end
  local maxLv, para
  if self.actData.type == EnumActivity.BattlePass_new.Type then
    para = LocalController:instance():getValue(TableName.Activity, self.activityId, "tableInfoType")
  else
    para = toInt(self.activityId)
  end
  local maxLv = DataCenter.ActBattlePassTemplateManager:GetActMaxLv(para, self.actData.type) - 1
  local curLevel = self.actData.battlePass.level
  self.progressBackground:SetActive(false)
  self.boxNumContent:SetActive(false)
  self.lockContent:SetActive(false)
  self.notEnoughContent:SetActive(false)
  self.enoughContent:SetActive(false)
  if maxLv > curLevel then
    self.lockContent:SetActive(true)
    local maxExp = DataCenter.ActBattlePassTemplateManager:GetMaxExp(toInt(self.activityId), self.actData.type)
    self.boxNameTip:SetLocalText(320560, maxExp)
  else
    local curExp = self.actData.battlePass.exp
    local oneBoxExp = self.actData.extraExp
    if self.actData.type == EnumActivity.BattlePass_new.Type then
      local exp = oneBoxExp * self.actData.infiniteNum
      curExp = curExp - exp
    end
    if oneBoxExp > curExp then
      self.progressBackground:SetActive(true)
      self.notEnoughContent:SetActive(true)
      self.boxNameTip:SetLocalText(320557)
      local max = oneBoxExp
      local current = curExp
      local text = current .. "/" .. max
      local progressNum = current / max
      local fillSize = self.progressBackground:GetSizeDelta()
      self.progressAmount:SetSizeDelta(Vector2(progressNum * fillSize.x, fillSize.y))
      self.progressNum:SetText(text)
    else
      self.progressBackground:SetActive(true)
      self.boxNumContent:SetActive(true)
      self.enoughContent:SetActive(true)
      self.boxNameTip:SetLocalText(320557)
      local max = oneBoxExp
      local current = curExp % oneBoxExp
      local boxNum = math.floor(curExp / oneBoxExp)
      local text = current .. "/" .. max
      local progressNum = current / max
      local fillSize = self.progressBackground:GetSizeDelta()
      self.progressAmount:SetSizeDelta(Vector2(progressNum * fillSize.x, fillSize.y))
      self.progressNum:SetText(text)
      self.boxNum:SetText(boxNum)
    end
  end
end

local function OnBoxClick(self)
  if self.activityId == nil or self.actData == nil then
    return
  end
  local isHave = self.actData:IsHaveExtraReward()
  if not isHave then
    return
  end
  local openParam = {
    title = Localization:GetString("390334"),
    rewardTitle = Localization:GetString("320556"),
    listReward = self.actData.extraReward
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardShow, {anim = true}, openParam)
end

local function OnGetBtnClick(self)
  if self.activityId == nil or self.actData == nil then
    return
  end
  local isHave = self.actData:IsHaveExtraReward()
  if not isHave then
    return
  end
  if self.actData.type == EnumActivity.BattlePass_new.Type then
    SFSNetwork.SendMessage(MsgDefines.NewReceiveBPExtraReward, toInt(self.activityId))
  else
    SFSNetwork.SendMessage(MsgDefines.ReceiveBattlePassExtraReward, toInt(self.activityId))
  end
end

local function OnUnGetBtnClick(self)
  if self.activityId == nil or self.actData == nil then
    return
  end
  local isHave = self.actData:IsHaveExtraReward()
  if not isHave then
    return
  end
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local actname = ""
  if actListData then
    actname = Localization:GetString(actListData.name)
  end
  UIUtil.ShowTips(Localization:GetString("320558", actname))
end

BattlePassUnlimitedBox.OnCreate = OnCreate
BattlePassUnlimitedBox.OnDestroy = OnDestroy
BattlePassUnlimitedBox.ComponentDefine = ComponentDefine
BattlePassUnlimitedBox.ComponentDestroy = ComponentDestroy
BattlePassUnlimitedBox.DataDefine = DataDefine
BattlePassUnlimitedBox.DataDestroy = DataDestroy
BattlePassUnlimitedBox.ReInit = ReInit
BattlePassUnlimitedBox.OnBoxClick = OnBoxClick
BattlePassUnlimitedBox.OnGetBtnClick = OnGetBtnClick
BattlePassUnlimitedBox.OnUnGetBtnClick = OnUnGetBtnClick
return BattlePassUnlimitedBox
