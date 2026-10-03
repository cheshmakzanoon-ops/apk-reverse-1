local UIBattlePassRewardItem = BaseClass("UIBattlePassRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIBattlePassItemCell = require("UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePassItemCell")
local root_path = "Root"
local cell_top_path = "Root/CellTop"
local cell_bottom_1_path = "Root/CellBottom1"
local cell_bottom_2_path = "Root/CellBottom2"
local desc_path = "Root/Desc"
local black_img_path = "Root/Img_Black"
local btn_continueClaim_path = "Root/Btn_ContinueClaim"
local btn_continueClaim_text_path = "Root/Btn_ContinueClaim/Txt_Go"
local btn_claim_path = "Root/Btn_Claim"
local btn_claim_text_path = "Root/Btn_Claim/Txt_Reward"
local btn_locked_path = "Root/Btn_Locked"
local btn_locked_text_path = "Root/Btn_Locked/Txt_Locked"
local completed_text_path = "Root/Txt_Completed"
local icon_path = "Root/Icon"
local greed = Color.New(0.18, 1, 0, 1)

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
  base.OnDisable(self)
end

function UIBattlePassRewardItem:SendMessage(specialState)
  if self.data.type == EnumActivity.BattlePass_new.Type then
    SFSNetwork.SendMessage(MsgDefines.NewReceiveBPStageReward, self.data.actId, self.data.level, specialState)
  else
    SFSNetwork.SendMessage(MsgDefines.ReceiveBattlePassStageReward, self.data.actId, self.data.level, specialState)
  end
end

local function OnBtnClaimClick(self)
  if self.data == nil then
    return
  end
  local locked = self.data.curLv < self.data.level
  local checked = self.data.normalState == 1
  if locked or checked then
    return
  end
  if self.data.unlock == 1 then
    local specialChecked = self.data.specialState == 1
    if not specialChecked then
      self:SendMessage(1)
      return
    end
  else
    self:SendMessage(0)
  end
end

local function OnBtnContinueClaimClick(self)
  if self.data == nil then
    return
  end
  local locked = self.data.curLv < self.data.level
  local specialChecked = self.data.specialState == 1
  if locked or specialChecked then
    return
  end
  if self.data.unlock == 0 then
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(self.data.actId))
    if activityData and activityData.subViewType == BattlePassType.Christmas then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassGiftPackagePopUpChristmas, tonumber(self.data.actId))
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassGiftPackagePopUp, self.data.actId)
    end
    return
  else
    UIUtil.ShowTips(Localization:GetString("320443", self.data.level))
    self:SendMessage(1)
  end
end

local function ComponentDefine(self)
  self.root_go = self:AddComponent(UIBaseContainer, root_path)
  self.cell_top = self:AddComponent(UIBattlePassItemCell, cell_top_path)
  self.cell_bottom_1 = self:AddComponent(UIBattlePassItemCell, cell_bottom_1_path)
  self.cell_bottom_2 = self:AddComponent(UIBattlePassItemCell, cell_bottom_2_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.btn_continueClaim = self:AddComponent(UIButton, btn_continueClaim_path)
  self.btn_continueClaim:SetOnClick(function()
    OnBtnContinueClaimClick(self)
  end)
  self.btn_continueClaim_text = self:AddComponent(UIText, btn_continueClaim_text_path)
  self.btn_claim = self:AddComponent(UIButton, btn_claim_path)
  self.btn_claim:SetOnClick(function()
    OnBtnClaimClick(self)
  end)
  self.btn_claim_text = self:AddComponent(UIText, btn_claim_text_path)
  self.btn_locked = self:AddComponent(UIButton, btn_locked_path)
  self.btn_locked_text = self:AddComponent(UIText, btn_locked_text_path)
  self.completed_text = self:AddComponent(UIText, completed_text_path)
  self.icon = self:AddComponent(UIImage, icon_path)
end

local function ComponentDestroy(self)
  self.root_go = nil
  self.cell_top = nil
  self.cell_bottom_1 = nil
  self.cell_bottom_2 = nil
  self.desc_text = nil
  self.btn_continueClaim = nil
  self.btn_continueClaim_text = nil
  self.btn_claim = nil
  self.btn_claim_text = nil
  self.btn_locked = nil
  self.btn_locked_text = nil
  self.completed_text = nil
end

local function DataDefine(self)
  self.view = nil
  self.data = nil
  self.onClick = nil
end

local function DataDestroy(self)
  self.view = nil
  self.data = nil
  self.onClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data, view, scoreItemId)
  self.view = view
  self.data = data
  local itemId = GetTableData(TableName.Activity, data.actId, "para_5")
  if itemId and not scoreItemId then
    scoreItemId = itemId
  end
  if not string.IsNullOrEmpty(scoreItemId) then
    local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(scoreItemId))
    self.icon:LoadSprite(iconPath)
  else
    self.icon:LoadSprite(string.format(LoadPath.ItemPath, "zyf_battlepass_icon2"))
  end
  self.root_go:SetActive(true)
  local needAccuExp = DataCenter.ActBattlePassTemplateManager:GetLevelNeedAccuExp(data.actId, data.level, data.type)
  self.desc_text:SetText(math.floor(needAccuExp))
  local locked, checked, canGet
  locked = data.curLv < data.level
  checked = data.normalState == 1
  local specialChecked = data.specialState == 1
  canGet = not locked and not checked
  if data.normalReward[1] then
    local dataTop = {
      locked = locked,
      reward = data.normalReward[1],
      state = data.normalState,
      isTop = true,
      unlock = data.unlock,
      actId = data.actId,
      lv = data.level
    }
    self.cell_top:SetActive(true)
    self.cell_top:SetData(dataTop)
  else
    self.cell_top:SetActive(false)
  end
  self.desc_text:SetColor(WhiteColor)
  if locked then
    self.btn_locked:SetActive(true)
    self.btn_claim:SetActive(false)
    self.btn_continueClaim:SetActive(false)
    self.completed_text:SetActive(false)
  elseif checked and not specialChecked then
    self.btn_locked:SetActive(false)
    self.btn_claim:SetActive(false)
    self.btn_continueClaim:SetActive(true)
    self.completed_text:SetActive(false)
    self.desc_text:SetColor(greed)
  elseif not checked then
    self.btn_locked:SetActive(false)
    self.desc_text:SetColor(greed)
    self.btn_claim:SetActive(true)
    self.btn_continueClaim:SetActive(false)
    self.completed_text:SetActive(false)
  else
    self.btn_locked:SetActive(false)
    self.btn_claim:SetActive(false)
    self.btn_continueClaim:SetActive(false)
    self.completed_text:SetActive(true)
    self.desc_text:SetColor(greed)
  end
  checked = data.specialState == 1
  canGet = not locked and not checked
  if #data.specialReward == 2 then
    table.sort(data.specialReward, function(a, b)
      return a.type == RewardType.GOLD
    end)
  end
  if data.specialReward[1] then
    local dataBottom1 = {
      locked = locked,
      reward = data.specialReward[1],
      state = data.specialState,
      isTop = false,
      unlock = data.unlock,
      actId = data.actId,
      lv = data.level
    }
    self.cell_bottom_1:SetActive(true)
    self.cell_bottom_1:SetData(dataBottom1)
  else
    self.cell_bottom_1:SetActive(false)
  end
  if data.specialReward[2] then
    local dataBottom2 = {
      locked = locked,
      reward = data.specialReward[2],
      state = data.specialState,
      isTop = false,
      unlock = data.unlock,
      actId = data.actId,
      lv = data.level
    }
    self.cell_bottom_2:SetActive(true)
    self.cell_bottom_2:SetData(dataBottom2)
  else
    self.cell_bottom_2:SetActive(false)
  end
end

local function SetBlank(self)
  self.root_go:SetActive(false)
end

UIBattlePassRewardItem.OnCreate = OnCreate
UIBattlePassRewardItem.OnDestroy = OnDestroy
UIBattlePassRewardItem.OnEnable = OnEnable
UIBattlePassRewardItem.OnDisable = OnDisable
UIBattlePassRewardItem.ComponentDefine = ComponentDefine
UIBattlePassRewardItem.ComponentDestroy = ComponentDestroy
UIBattlePassRewardItem.DataDefine = DataDefine
UIBattlePassRewardItem.DataDestroy = DataDestroy
UIBattlePassRewardItem.OnAddListener = OnAddListener
UIBattlePassRewardItem.OnRemoveListener = OnRemoveListener
UIBattlePassRewardItem.SetData = SetData
UIBattlePassRewardItem.SetBlank = SetBlank
return UIBattlePassRewardItem
