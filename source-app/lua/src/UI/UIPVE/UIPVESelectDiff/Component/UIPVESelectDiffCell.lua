local UIPVESelectDiffCell = BaseClass("UIPVESelectDiffCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local submit_btn_path = "Bg"
local diff_icon_path = "Bg/DiffIcon"
local diff_desc_path = "Bg/DiffDesc"
local exp_path = "Bg/Exp"
local level_path = "Bg/Level"
local reward_desc_path = "Bg/RewardDesc"
local DiffBg = {
  [1] = "UIBattleBuff_bg_green",
  [2] = "UIBattleBuff_bg_blue",
  [3] = "UIBattleBuff_bg_purple",
  [4] = "UIBattleBuff_bg_orange",
  [5] = "UIBattleBuff_bg_red"
}
local DiffName = {
  [1] = 400063,
  [2] = 110136,
  [3] = 400064,
  [4] = 400065,
  [5] = 400066
}

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.submit_btn = self:AddComponent(UIButton, submit_btn_path)
  self.diff_icon = self:AddComponent(UIImage, diff_icon_path)
  self.bg_icon = self:AddComponent(UIImage, submit_btn_path)
  self.diff_desc_text = self:AddComponent(UIText, diff_desc_path)
  self.exp_text = self:AddComponent(UIText, exp_path)
  self.level_text = self:AddComponent(UIText, level_path)
  self.reward_desc_text = self:AddComponent(UIText, reward_desc_path)
  self.reward_desc_text:SetLocalText(130065)
  self.submit_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSubmitBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.submit_btn = nil
  self.diff_icon = nil
  self.bg_icon = nil
  self.diff_desc_text = nil
  self.exp_text = nil
  self.level_text = nil
  self.reward_desc_text = nil
end

local function DataDefine(self)
  self.param = nil
  self.trigger = nil
end

local function DataDestroy(self)
  self.param = nil
  self.trigger = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, param)
  self.param = param
  self.trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(self.param.triggerId)
  local info = param.monsterGroupInfo
  local exp = info.exp
  local basicExp = info.basicExp or exp
  local extraExp = exp - basicExp
  local levelMin = 999
  local levelMax = 0
  local monsterId = PveUtil.GetRecommendMonsterId(param.diff)
  if monsterId == nil then
    Logger.LogError("Cannot get recommend monster id, diff = " .. param.diff)
    return
  end
  local armyId = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), monsterId, "army")
  armyId = armyId[1] or 0
  for i = 1, 5 do
    local str = GetTableData(TableName.Army, armyId, "hero" .. i)
    if not string.IsNullOrEmpty(str) then
      local spls = string.split(str, ";")
      if #spls == 3 then
        local level = tonumber(spls[2])
        levelMin = math.min(levelMin, level)
        levelMax = math.max(levelMax, level)
      end
    end
  end
  self.diff_desc_text:SetLocalText(DiffName[param.diff])
  self.level_text:SetText(Localization:GetString("100082") .. " " .. levelMax)
  self.bg_icon:LoadSprite(string.format(LoadPath.UIPveBattleBuff, DiffBg[param.diff]))
  local expStr = string.GetFormattedSeperatorNum(basicExp)
  if 0 < extraExp then
    expStr = expStr .. " <color=#00FF00FF>+" .. string.GetFormattedSeperatorNum(extraExp) .. "</color>"
  end
  self.exp_text:SetText(expStr)
end

local function OnSubmitBtnClick(self)
  self.view.ctrl:CloseSelf()
  local monsterId = PveUtil.GetRecommendMonsterId(self.param.diff)
  if monsterId == nil then
    Logger.LogError("Cannot get recommend monster id")
    return
  end
  PveActorMgr:GetInstance():SetMonsterDiff(self.param.diff, monsterId)
  DataCenter.BattleLevel.isShowingSelectDiff = false
  DataCenter.BattleLevel.diffParam.selectDiff = self.param.diff
  DataCenter.BattleLevel:DoTrigger(self.trigger)
end

UIPVESelectDiffCell.OnCreate = OnCreate
UIPVESelectDiffCell.OnDestroy = OnDestroy
UIPVESelectDiffCell.ComponentDefine = ComponentDefine
UIPVESelectDiffCell.ComponentDestroy = ComponentDestroy
UIPVESelectDiffCell.DataDefine = DataDefine
UIPVESelectDiffCell.DataDestroy = DataDestroy
UIPVESelectDiffCell.OnEnable = OnEnable
UIPVESelectDiffCell.OnDisable = OnDisable
UIPVESelectDiffCell.OnAddListener = OnAddListener
UIPVESelectDiffCell.OnRemoveListener = OnRemoveListener
UIPVESelectDiffCell.ReInit = ReInit
UIPVESelectDiffCell.OnSubmitBtnClick = OnSubmitBtnClick
return UIPVESelectDiffCell
