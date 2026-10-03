local UILWT11IdleGameBattleRewardPreviewView = BaseClass("UILWT11IdleGameBattleRewardPreviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local UILWT11IdleGameBattleRewardPreviewItemComponent = require("UI/T11IdleGame/T11IdleGameBattleRewardPreview/Component/UILWT11IdleGameBattleRewardPreviewItemComponent")
local UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent = require("UI/T11IdleGame/T11IdleGameBattleRewardPreview/Component/UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent")

function UILWT11IdleGameBattleRewardPreviewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWT11IdleGameBattleRewardPreviewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameBattleRewardPreviewView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textCurLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compEmpty = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.compRewardContentNormal = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.compUICommonToggleList = self.viewSkin:AddComponent(self, UICommonToggleListComponent, 8)
  self.compRewardContentBoss = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.textTitle:SetLocalText("t11_idle_game_title_26")
end

function UILWT11IdleGameBattleRewardPreviewView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textTips = nil
  self.textCurLevel = nil
  self.compEmpty = nil
  self.compRewardContentNormal = nil
  self.compUICommonToggleList = nil
  self.compRewardContentBoss = nil
end

function UILWT11IdleGameBattleRewardPreviewView:DataDefine()
  self.itemReqs = {}
  self.hasInit = {}
end

function UILWT11IdleGameBattleRewardPreviewView:DataDestroy()
  self.itemReqs = nil
  self.hasInit = nil
end

function UILWT11IdleGameBattleRewardPreviewView:OnAddListener()
  base.OnAddListener(self)
end

function UILWT11IdleGameBattleRewardPreviewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWT11IdleGameBattleRewardPreviewView:OnOpen()
  self:InitToggle()
end

function UILWT11IdleGameBattleRewardPreviewView:InitToggle()
  local toggleData1 = {}
  toggleData1.name = Localization:GetString("t11_idle_game_desc_27")
  local toggleData2 = {}
  toggleData2.name = Localization:GetString("t11_idle_game_desc_28")
  local toggleListData = {}
  toggleListData.itemsDataList = {toggleData1, toggleData2}
  
  function toggleListData.onItemSelect(index, itemData)
    self:OnSelectToggle(index, itemData)
  end
  
  self.compUICommonToggleList:ReInit(toggleListData)
end

function UILWT11IdleGameBattleRewardPreviewView:OnSelectToggle(index, itemData)
  if index == 1 then
    self:RefreshIdleContent()
  elseif index == 2 then
    self:RefreshBossContent()
  end
end

function UILWT11IdleGameBattleRewardPreviewView:RefreshIdleContent()
  local infoData = DataCenter.T11IdleGameDataManager:GetIdleInfoData()
  if infoData == nil then
    return
  end
  local curLevelTemp = infoData:GetLevelTemplate()
  if curLevelTemp == nil then
    return
  end
  local previewData = curLevelTemp:GetPreviewData()
  if previewData == nil then
    return
  end
  self.compRewardContentBoss:SetActive(false)
  self.compRewardContentNormal:SetActive(true)
  self.textCurLevel:SetLocalText("t11_idle_game_desc_31", curLevelTemp:GetName())
  self.textTips:SetLocalText("t11_idle_game_desc_29")
  if self.hasInit[1] == true then
    return
  end
  self.hasInit[1] = true
  if not table.IsNullOrEmpty(previewData.fight_reward) then
    local req = self:GameObjectInstantiateAsync(Const.BattleRewardPreviewProb, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compRewardContentNormal.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = tostring("fight_reward")
      go:SetActive(true)
      local pageComp = self.compRewardContentNormal:AddComponent(UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent, go.name)
      local icon = Const.BattleRewardPreviewIconPath[Const.NodeType.Battle]
      local title = Localization:GetString("t11_idle_game_desc_61")
      local des = Localization:GetString("t11_idle_game_desc_34")
      local prob = Localization:GetString("t11_idle_game_desc_32", string.format("%.2f", previewData.fight_weight / 100) .. "%")
      local rewards = self.ctrl:GetShowRewards(previewData.fight_reward)
      pageComp:ReInit(icon, title, des, prob, rewards)
    end)
    table.insert(self.itemReqs, req)
  end
  if not table.IsNullOrEmpty(previewData.box_reward) then
    local req = self:GameObjectInstantiateAsync(Const.BattleRewardPreviewProb, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compRewardContentNormal.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = tostring("box_reward")
      go:SetActive(true)
      local pageComp = self.compRewardContentNormal:AddComponent(UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent, go.name)
      local icon = Const.BattleRewardPreviewIconPath[Const.NodeType.Chest]
      local title = Localization:GetString("t11_idle_game_desc_62")
      local prob = Localization:GetString("t11_idle_game_desc_32", string.format("%.2f", previewData.box_weight / 100) .. "%")
      local des = Localization:GetString("t11_idle_game_desc_35")
      local rewards = self.ctrl:GetShowRewards(previewData.box_reward)
      pageComp:ReInit(icon, title, des, prob, rewards)
    end)
    table.insert(self.itemReqs, req)
  end
  local req = self:GameObjectInstantiateAsync(Const.BattleRewardPreview, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.compRewardContentNormal.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.name = tostring("event_reward")
    go:SetActive(true)
    local pageComp = self.compRewardContentNormal:AddComponent(UILWT11IdleGameBattleRewardPreviewItemComponent, go.name)
    local icon = Const.BattleRewardPreviewIconPath[Const.NodeType.Event]
    local title = Localization:GetString("t11_idle_game_desc_63")
    local des = Localization:GetString("t11_idle_game_desc_65")
    pageComp:ReInit(icon, title, des, nil)
  end)
  table.insert(self.itemReqs, req)
end

function UILWT11IdleGameBattleRewardPreviewView:RefreshBossContent()
  self.textTips:SetLocalText("t11_idle_game_desc_30")
  self.compRewardContentBoss:SetActive(true)
  self.compRewardContentNormal:SetActive(false)
  local mainData = DataCenter.T11IdleGameDataManager:GetMainData()
  if mainData == nil then
    return
  end
  local infoData = DataCenter.T11IdleGameDataManager:GetIdleInfoData()
  if infoData == nil then
    return
  end
  local curLevelTemp = infoData:GetLevelTemplate()
  if curLevelTemp == nil then
    return
  end
  local previewData = curLevelTemp:GetPreviewData()
  if previewData == nil then
    return
  end
  self.textCurLevel:SetLocalText("t11_idle_game_desc_31", curLevelTemp:GetName())
  if self.hasInit[2] == true then
    return
  end
  self.hasInit[2] = true
  local req = self:GameObjectInstantiateAsync(Const.BattleRewardPreview, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.compRewardContentBoss.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.name = tostring("boss_reward")
    go:SetActive(true)
    local pageComp = self.compRewardContentBoss:AddComponent(UILWT11IdleGameBattleRewardPreviewItemComponent, go.name)
    local title = Localization:GetString("t11_idle_game_desc_64")
    local des = Localization:GetString("t11_idle_game_desc_36")
    local rewards = self.ctrl:GetShowRewards(previewData.boss_reward)
    pageComp:ReInit(nil, title, des, nil, rewards)
  end)
  table.insert(self.itemReqs, req)
end

function UILWT11IdleGameBattleRewardPreviewView:ClearScroll()
  if self.itemReqs then
    for i, v in pairs(self.itemReqs) do
      v:Destroy()
    end
    self.itemReqs = {}
  end
  self.compRewardContentNormal:RemoveComponents(UILWT11IdleGameBattleRewardPreviewItemComponent)
  self.compRewardContentNormal:RemoveComponents(UILWT11IdleGameBattleRewardPreviewProbabilityItemComponent)
  self.compRewardContentBoss:RemoveComponents(UILWT11IdleGameBattleRewardPreviewItemComponent)
end

function UILWT11IdleGameBattleRewardPreviewView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UILWT11IdleGameBattleRewardPreviewView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UILWT11IdleGameBattleRewardPreviewView
