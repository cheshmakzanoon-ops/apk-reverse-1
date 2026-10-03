local base = require("UI.UIRaceEntrance.Component.ActDownloadNodeBase")
local UIBFDsbDuelActMainRoot = BaseClass("UIBFDsbDuelActMainRoot", base)
local Resource = CS.GameEntry.Resource
local UIBFDsbDuelActScheduleSign = require("UI.BFDsbDuel.BFDsbDuelMain.Component.Schedule.UIBFDsbDuelActScheduleSign")
local UIBFDsbDuelActBattle = require("UI.BFDsbDuel.BFDsbDuelMain.Component.Battle.UIBFDsbDuelActBattle")
local UIBFDsbDuelActScoreRank = require("UI.BFDsbDuel.BFDsbDuelMain.Component.ScoreRank.UIBFDsbDuelActScoreRank")
local BFDsbDuelMainComponentEnum = {
  Sign = 1,
  EditBattle = 2,
  ScoreRank = 3
}
local ComponentConfig = {
  [BFDsbDuelMainComponentEnum.Sign] = {
    prefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/SignUp/UIBFDsbDuelActScheduleSign.prefab",
    classType = UIBFDsbDuelActScheduleSign
  },
  [BFDsbDuelMainComponentEnum.EditBattle] = {
    prefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Battle/UIBFDsbDuelActBattle.prefab",
    classType = UIBFDsbDuelActBattle
  },
  [BFDsbDuelMainComponentEnum.ScoreRank] = {
    prefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/ScoreRank/UIBFDsbDuelActScoreRank.prefab",
    classType = UIBFDsbDuelActScoreRank
  }
}

function UIBFDsbDuelActMainRoot:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActMainRoot:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActMainRoot:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContentContainer = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.toggleEditPlayer = self.viewSkin:AddComponent(self, UIToggle, 2)
  self.toggleSignUp = self.viewSkin:AddComponent(self, UIToggle, 3)
  self.toggleScoreRank = self.viewSkin:AddComponent(self, UIToggle, 4)
  self.textSignUp1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textSignUp2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textOther1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textOther2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textFormation1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textFormation2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textSignUp1:SetLocalText("dsb_duel_interface_1001")
  self.textSignUp2:SetLocalText("dsb_duel_interface_1001")
  self.textOther1:SetLocalText("dsb_duel_interface_1002")
  self.textOther2:SetLocalText("dsb_duel_interface_1002")
  self.textFormation1:SetLocalText("dsb_duel_interface_1003")
  self.textFormation2:SetLocalText("dsb_duel_interface_1003")
  self.contents = {}
  self.toggleSignUp:SetIsOn(false)
  self.toggleEditPlayer:SetIsOn(false)
  self.toggleScoreRank:SetIsOn(false)
  self.toggleSignUp:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleChanged(BFDsbDuelMainComponentEnum.Sign)
    end
  end)
  self.toggleEditPlayer:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleChanged(BFDsbDuelMainComponentEnum.EditBattle)
    end
  end)
  self.toggleScoreRank:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleChanged(BFDsbDuelMainComponentEnum.ScoreRank)
    end
  end)
  self.toggles = {
    self.toggleSignUp,
    self.toggleEditPlayer,
    self.toggleScoreRank
  }
end

function UIBFDsbDuelActMainRoot:ComponentDestroy()
  self.viewSkin = nil
  self.compContentContainer = nil
  self.toggleEditPlayer = nil
  self.toggleSignUp = nil
  self.toggleScoreRank = nil
  self.textSignUp1 = nil
  self.textSignUp2 = nil
  self.textOther1 = nil
  self.textOther2 = nil
  self.textFormation1 = nil
  self.textFormation2 = nil
end

function UIBFDsbDuelActMainRoot:DataDefine()
  self.reqs = {}
  self.curToggleIndex = 0
end

function UIBFDsbDuelActMainRoot:DataDestroy()
  for k, v in pairs(ComponentConfig) do
    self.compContentContainer:RemoveComponents(v.classType)
  end
  if self.reqs then
    for k, v in pairs(self.reqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.reqs = nil
  self.contents = nil
  self.toggles = nil
  self.reqs = nil
  self.curToggleIndex = nil
  self.targetToggleIndex = nil
end

function UIBFDsbDuelActMainRoot:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.DsbDuelActSignUpSuccess, self.OnDsbDuelActSignUpSuccess)
end

function UIBFDsbDuelActMainRoot:OnDisable()
  self:RemoveUIListener(EventId.DsbDuelActSignUpSuccess, self.OnDsbDuelActSignUpSuccess)
  base.OnDisable(self)
end

function UIBFDsbDuelActMainRoot:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActBattleMainToggleChange, self.OnDsbDuelActBattleMainToggleChange)
end

function UIBFDsbDuelActMainRoot:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActBattleMainToggleChange, self.OnDsbDuelActBattleMainToggleChange)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActMainRoot:GetActType()
  return EnumActivity.ActDsbDuel.Type
end

function UIBFDsbDuelActMainRoot:OnEnterNode()
  if BattlefieldDsbDuelUtils.ActInfo then
    BattlefieldDsbDuelUtils.ActInfo:SendActInfoMsg()
  end
end

function UIBFDsbDuelActMainRoot:EnterToggle(userData)
  self.targetToggleIndex = userData or BFDsbDuelMainComponentEnum.Sign
  if self.toggles[self.targetToggleIndex]:GetIsOn() then
    self:OnToggleChanged(self.targetToggleIndex)
  else
    self:SetToggle(self.targetToggleIndex)
  end
end

function UIBFDsbDuelActMainRoot:OnToggleChanged(index)
  for k, v in pairs(self.contents) do
    v:SetActive(false)
  end
  local config = ComponentConfig[index]
  if not config then
    return
  end
  self.curToggleIndex = index
  if self.contents[index] then
    self.contents[index]:SetActive(true)
    self.contents[index]:ReInit()
    return
  end
  local prefabPath = config.prefabPath
  local classType = config.classType
  self.reqs[index] = self:GameObjectInstantiateAsync(prefabPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.compContentContainer.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    go.transform:Set_sizeDelta(0, 0)
    go.name = "content" .. index
    local comp = self.compContentContainer:AddComponent(classType, go.name)
    self.contents[index] = comp
    comp:SetActive(index == self.curToggleIndex)
    if index == self.curToggleIndex then
      comp:ReInit()
    end
  end)
end

function UIBFDsbDuelActMainRoot:OnDsbDuelActBattleMainToggleChange(idx)
  if idx >= BattlefieldDsbConst.BF_DSB_MAIN_VIEW_TOGGLE_INDEX.SignUp and idx <= BattlefieldDsbConst.BF_DSB_MAIN_VIEW_TOGGLE_INDEX.ScoreRank then
    self:SetToggle(idx)
  end
end

function UIBFDsbDuelActMainRoot:SetToggle(idx)
  if idx == BFDsbDuelMainComponentEnum.Sign then
    self.toggleSignUp:SetIsOn(true)
  elseif idx == BFDsbDuelMainComponentEnum.EditBattle then
    self.toggleEditPlayer:SetIsOn(true)
  elseif idx == BFDsbDuelMainComponentEnum.ScoreRank then
    self.toggleScoreRank:SetIsOn(true)
  end
end

function UIBFDsbDuelActMainRoot:OnDsbDuelActInfoUpdate()
end

function UIBFDsbDuelActMainRoot:OnDsbDuelActSignUpSuccess()
end

return UIBFDsbDuelActMainRoot
