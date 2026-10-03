local base = UIBaseView
local SeasonHunterConvert = BaseClass("SeasonHunterConvert", base)
local SeasonHunterConvertItem = require("UI.LWSeason.LWSeasonHunter.Component.SeasonHunterConvertItem")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local btnBack_path = "Root/title/CloseBtn"
local btnClose_path = "panel"
local txtTitle_path = "Root/title/titleText"
local content_path = "Root/Content"
local tipsItem1_path = "Root/Content/SeasonHunterConvertItem"
local tipsItem2_path = "Root/Content/SeasonHunterConvertItem2"
local tipsItem3_path = "Root/Content/SeasonHunterConvertItem3"
local tipsItem4_path = "Root/Content/SeasonHunterConvertItem4"
local btnConvert_path = "Root/bot/BtnConvert"
local txtTips_path = "Root/bot/tips"
local txtBtn_path = "Root/bot/BtnConvert/btnTxt"
local contentDesc_path = "Root/ContentDesc"
local descItem_path = "Root/ContentDesc/desc"
local __ItemInfoList = {
  {
    name = "season_s4_activity_1200011_name13",
    icon = "Assets/Main/SeasonRes/S4/Sprites/UI/Hunter/ljq_s4_xueselieren_icon_01.png",
    desc = {
      "season_s4_activity_1200011_desc55",
      "season_s4_activity_1200011_desc56",
      "season_s4_activity_1200011_desc57"
    },
    condition = {
      "CheckMasterySkillState",
      "CheckBanState",
      "CheckActive"
    }
  },
  {
    name = "season_s4_activity_1200011_name14",
    icon = "Assets/Main/SeasonRes/S4/Sprites/UI/Hunter/ljq_s4_xueselieren_icon_02.png",
    desc = {
      "season_s4_activity_1200011_desc58",
      "season_s4_activity_1200011_desc59"
    }
  },
  {
    name = "season_s4_activity_1200011_name15",
    icon = "Assets/Main/SeasonRes/S4/Sprites/UI/Hunter/ljq_s4_xueselieren_icon_03.png",
    desc = {
      "season_s4_activity_1200011_desc60",
      "season_s4_activity_1200011_desc63"
    }
  },
  {
    name = "season_s4_activity_1200011_name16",
    icon = "Assets/Main/SeasonRes/S4/Sprites/UI/Hunter/ljq_s4_xueselieren_icon_04.png",
    desc = {
      "season_s4_activity_1200011_desc61",
      "season_s4_activity_1200011_desc62"
    }
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
  SFSNetwork.SendMessage(MsgDefines.SeasonHunterGetActivityInfo)
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.btnClose = self:AddComponent(UIButton, btnClose_path)
  self.txtTitle = self:AddComponent(UIText, txtTitle_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.tipsItem1 = self:AddComponent(UIBaseContainer, tipsItem1_path)
  self.tipsItem2 = self:AddComponent(UIBaseContainer, tipsItem2_path)
  self.tipsItem3 = self:AddComponent(UIBaseContainer, tipsItem3_path)
  self.tipsItem4 = self:AddComponent(UIBaseContainer, tipsItem4_path)
  self.btnConvert = self:AddComponent(UIButton, btnConvert_path)
  self.txtTips = self:AddComponent(UIText, txtTips_path)
  self.txtBtn = self:AddComponent(UIText, txtBtn_path)
  self.contentDesc = self:AddComponent(UIBaseContainer, contentDesc_path)
  self.descItem = self:AddComponent(UIBaseContainer, descItem_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnConvert:SetOnClick(BindCallback(self, self.OnClickConvert))
  self.descObj = self.descItem.gameObject
  self.descObj:GameObjectCreatePool()
  self.descObj:SetActive(false)
  self.items = {}
  self.items[1] = self:AddComponent(SeasonHunterConvertItem, tipsItem1_path)
  self.items[2] = self:AddComponent(SeasonHunterConvertItem, tipsItem2_path)
  self.items[3] = self:AddComponent(SeasonHunterConvertItem, tipsItem3_path)
  self.items[4] = self:AddComponent(SeasonHunterConvertItem, tipsItem4_path)
end

local function ComponentDestroy(self)
  self.contentDesc:RemoveComponents(UIText)
  self.descObj:GameObjectRecycleAll()
  self.btnBack = nil
  self.btnClose = nil
  self.txtTitle = nil
  self.content = nil
  self.tipsItem1 = nil
  self.tipsItem2 = nil
  self.tipsItem3 = nil
  self.tipsItem4 = nil
  self.btnConvert = nil
  self.txtTips = nil
  self.txtBtn = nil
  self.contentDesc = nil
  self.descItem = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonHunterConvert:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonHunterGetActivityInfo, self.RefreshView)
  self:AddUIListener(EventId.MasteryUseSkill, self.RefreshView)
  self:AddUIListener(EventId.LWMasterySkillUp, self.RefreshView)
end

function SeasonHunterConvert:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonHunterGetActivityInfo, self.RefreshView)
  self:RemoveUIListener(EventId.MasteryUseSkill, self.RefreshView)
  self:RemoveUIListener(EventId.LWMasterySkillUp, self.RefreshView)
  base.OnRemoveListener(self)
end

function SeasonHunterConvert:Update1000MS()
  if self.clickTime then
    self.clickTime = self.clickTime - 1
    if self.clickTime <= 0 then
      self.clickTime = nil
    end
    self:RefreshBtnState()
  end
end

function SeasonHunterConvert:RefreshView()
  self.clickTime = nil
  local isBegin = DataCenter.SeasonHunterManager:IsBattleBegin()
  local isInBattle = DataCenter.SeasonHunterManager:IsInBattle()
  if not isBegin or isInBattle then
    self.txtBtn:SetLocalText("season_s4_activity_1200011_btn2")
  else
    local homeId, skillState, _, _, skillTemplate = DataCenter.SeasonHunterManager:GetMasterySkillState()
    if skillState == MasterySkillState.Normal then
      self.txtBtn:SetLocalText("season_s4_activity_1200011_btn2")
      self.clickTime = 5
    elseif skillState == MasterySkillState.CD then
      self.txtBtn:SetLocalText("season_s4_activity_1200011_btn2")
    else
      self.txtBtn:SetLocalText("season_s4_activity_1200011_btn5")
    end
  end
  self:RefreshBtnState()
  self:RefreshInfoList()
end

function SeasonHunterConvert:RefreshInfoList()
  local parent = self.content.transform
  local firstItem
  for i, v in ipairs(__ItemInfoList) do
    local theItem = self.items[i]
    if theItem then
      theItem.toggle:SetOnValueChanged(function(isOn)
        if isOn then
          self:RefreshItemDesc(v)
        end
      end)
      local flag
      if v.condition then
        flag = true
        for _, conditionStr in ipairs(v.condition) do
          if self[conditionStr] and not self[conditionStr](self) then
            flag = false
          end
        end
      end
      theItem:ReInit(i, v, flag)
      theItem:SetActive(true)
      if not firstItem then
        firstItem = theItem
        self:RefreshItemDesc(v)
      end
    end
  end
  if firstItem then
    firstItem.toggle:SetIsOn(true)
  end
end

function SeasonHunterConvert:RefreshItemDesc(data)
  self.contentDesc:RemoveComponents(UIText)
  self.descObj:GameObjectRecycleAll()
  if not table.IsNullOrEmpty(data.desc) then
    local parent = self.contentDesc.transform
    for i, v in ipairs(data.desc) do
      local goItem = self.descObj:GameObjectSpawn(parent)
      goItem.name = string.format("UIText_%d", i)
      local textComp = self.contentDesc:AddComponent(UIText, goItem.name)
      textComp:SetLocalText(v)
      local conditionStr = data.condition and data.condition[i]
      if conditionStr and self[conditionStr] and not self[conditionStr](self) then
        UIGray.SetGray(textComp.transform, true, false)
        textComp:SetColor(Color.gray)
      else
        UIGray.SetGray(textComp.transform, false, false)
        textComp:SetColor(Color.white)
      end
    end
  end
end

function SeasonHunterConvert:RefreshBtnState()
  if self.clickTime then
    CS.UIGray.SetGray(self.btnConvert.transform, true, true)
    self.txtTips:SetText(Localization:GetString("season_s4_activity_1200011_desc47", self.clickTime))
    self.txtTips:SetActive(true)
    return
  end
  self.txtTips:SetActive(false)
  CS.UIGray.SetGray(self.btnConvert.transform, false, true)
end

function SeasonHunterConvert:OnClickConvert()
  if self.clickTime then
    UIUtil.ShowTips(Localization:GetString("season_s4_activity_1200011_desc47", self.clickTime))
    return
  end
  if DataCenter.SeasonHunterManager:IsInBattle() then
    UIUtil.ShowTipsId("season_s4_activity_1200011_desc14")
    return
  end
  if not DataCenter.SeasonHunterManager:IsBattleBegin() then
    UIUtil.ShowTipsId("season_s4_activity_1200011_tips01")
    return
  end
  local homeId, skillState, _, masteryTemp, skillTemplate = DataCenter.SeasonHunterManager:GetMasterySkillState()
  if skillState == MasterySkillState.CD then
    UIUtil.ShowTipsId("season_s4_activity_1200011_tips02")
    return
  end
  if not masteryTemp or not skillTemplate then
    UIUtil.ShowTipsId("skill_use_tips")
    return
  end
  if skillState ~= MasterySkillState.Normal then
    local params = {}
    params.tabType = MasteryTabType.MasterSkillTab
    params.data = {
      homeId = homeId,
      jumpMasteryId = masteryTemp.mastery_id
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryCenterTab, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, params)
    return
  end
  if DataCenter.SeasonHunterManager:IsBanState() then
    UIUtil.ShowTipsId("season_s4_activity_1200011_tips05")
    return
  end
  DataCenter.MasteryManager:SendUseSkillMsg(skillTemplate)
end

function SeasonHunterConvert:CheckMasterySkillState()
  return DataCenter.SeasonHunterManager:CheckMasterySkillState()
end

function SeasonHunterConvert:CheckBanState()
  return not DataCenter.SeasonHunterManager:IsBanState()
end

function SeasonHunterConvert:CheckActive()
  return DataCenter.SeasonHunterManager:IsBattleBegin()
end

SeasonHunterConvert.OnCreate = OnCreate
SeasonHunterConvert.OnDestroy = OnDestroy
SeasonHunterConvert.OnEnable = OnEnable
SeasonHunterConvert.OnDisable = OnDisable
SeasonHunterConvert.ComponentDefine = ComponentDefine
SeasonHunterConvert.ComponentDestroy = ComponentDestroy
SeasonHunterConvert.DataDefine = DataDefine
SeasonHunterConvert.DataDestroy = DataDestroy
return SeasonHunterConvert
