local base = UIBaseContainer
local T11SkillChangeSoldierModelAreaComponent = BaseClass("T11SkillChangeSoldierModelAreaComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local nodePath = "Assets/Main/Prefabs/UI/T11/T11MainView/Component/CommonCpt/T11ChangeSoldierModelUnlockSkillNode.prefab"
local skillNode = require("UI.T11MainView.Component.State.Component.T11ChangeSoldierModelUnlockSkillNode")

function T11SkillChangeSoldierModelAreaComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11SkillChangeSoldierModelAreaComponent:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11SkillChangeSoldierModelAreaComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnChangeModel = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnChangeModel:SetOnClick(function()
    self:OnBtnChangeModelClick()
  end)
  self.simpleAnimationSelectSoldierAniItem = self.viewSkin:AddComponent(self, UISimpleAnimation, 3)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compUnlockedSkillArea = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
end

function T11SkillChangeSoldierModelAreaComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnChangeModel = nil
  self.simpleAnimationSelectSoldierAniItem = nil
  self.textBtn = nil
  self.compUnlockedSkillArea = nil
end

function T11SkillChangeSoldierModelAreaComponent:DataDefine()
  self.model = {}
  self.cellList = {}
end

function T11SkillChangeSoldierModelAreaComponent:DataDestroy()
  self.model = nil
  self.cellList = nil
end

function T11SkillChangeSoldierModelAreaComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11SuccessChangeSoldierMode, self.OnT11SuccessChangeSoldierMode)
  self:AddUIListener(EventId.T11DataUpdate, self.ShowCurSoldierSkill)
end

function T11SkillChangeSoldierModelAreaComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.T11SuccessChangeSoldierMode, self.OnT11SuccessChangeSoldierMode)
  self:RemoveUIListener(EventId.T11DataUpdate, self.ShowCurSoldierSkill)
  base.OnRemoveListener(self)
end

function T11SkillChangeSoldierModelAreaComponent:OnBtnChangeModelClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.T11SoldierSelect)
end

function T11SkillChangeSoldierModelAreaComponent:RefreshView(isShowAni)
  self:RefreshChangeSoldierArea(isShowAni)
  self:ShowCurSoldierSkill()
end

function T11SkillChangeSoldierModelAreaComponent:RefreshChangeSoldierArea(isShowAni)
  local targetSoldierTmp = T11Util.GetCurT11SoldierTmpData()
  if self.curSelSoldierTmp and self.curSelSoldierTmp == targetSoldierTmp then
    return
  end
  self.curSelSoldierTmp = T11Util.GetCurT11SoldierTmpData()
  if not self.curSelSoldierTmp then
    Logger.LogError("T11SkillChangeSoldierModelAreaComponent:RefreshView curSelSoldierTmp is nil")
    return
  end
  local titleStr = Localization:GetString("soldier_eleven_choose_now")
  local equipNameStr = Localization:GetString(self.curSelSoldierTmp.name)
  self.textTitle:SetLocalText(458570, titleStr, equipNameStr)
  local aniName = isShowAni and "SelectA" or "ImmedSelectA"
  if self.curSelSoldierTmp.soldierType == T11SoldierType.T11SoldierTypeB then
    aniName = isShowAni and "SelectB" or "ImmedSelectB"
  end
  self.simpleAnimationSelectSoldierAniItem:Play(aniName)
  self.textBtn:SetLocalText("soldier_eleven_change_out_btn")
end

function T11SkillChangeSoldierModelAreaComponent:OnT11SuccessChangeSoldierMode()
  self:RefreshView(true)
end

function T11SkillChangeSoldierModelAreaComponent:ShowCurSoldierSkill()
  local unlockSkillList = {}
  local stageList = DataCenter.T11DataManager.curT11LevelData.stageData:GetStageList()
  local initStage = T11Util.GetT11InitialStage()
  local curSelectSoldierType = T11Util.GetCurT11SoldierType()
  local otherStage = {}
  for _, v in ipairs(stageList) do
    if v ~= initStage then
      table.insert(otherStage, v)
    end
  end
  local coreSkillInfo = T11Util.GetSkillInfoByStage(initStage, curSelectSoldierType)
  table.insert(unlockSkillList, coreSkillInfo)
  for _, v in ipairs(otherStage) do
    local skillInfo = T11Util.GetSkillInfoByStage(v, curSelectSoldierType)
    if skillInfo then
      table.insert(unlockSkillList, skillInfo)
    end
  end
  if table.length(self.cellList) == 0 or table.length(self.cellList) ~= table.length(unlockSkillList) then
    self:ClearScroll()
    for i = 1, table.length(unlockSkillList) do
      self.model[i] = self:GameObjectInstantiateAsync(nodePath, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.compUnlockedSkillArea.transform)
        local size = 52
        if unlockSkillList[i].ifCoreEffect then
          size = 56
        end
        go.transform:Set_sizeDelta(size, size)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_pivot(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.compUnlockedSkillArea:AddComponent(skillNode, go.name)
        cell:ReInit(unlockSkillList[i])
        table.insert(self.cellList, cell)
      end)
    end
  else
    for i = 1, table.length(unlockSkillList) do
      local cell = self.cellList[i]
      if cell then
        cell:ReInit(unlockSkillList[i])
      end
    end
  end
end

function T11SkillChangeSoldierModelAreaComponent:ClearScroll()
  self.compUnlockedSkillArea:RemoveComponents(skillNode)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

return T11SkillChangeSoldierModelAreaComponent
