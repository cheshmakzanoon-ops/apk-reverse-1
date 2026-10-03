local UILWTorchRelayBattleWinView = BaseClass("UILWTorchRelayBattleWinView", UIBaseView)
local TorchRelayBattleStageCheerConfigTemplate = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Config/TorchRelayBattleStageCheerConfigTemplate")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILWTorchRelayBattleWinView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWTorchRelayBattleWinView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTorchRelayBattleWinView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compLayout = self:AddComponent(UIBaseContainer, "Layout")
  self.animatorVictoryGo = self:AddComponent(UIAnimator, "Layout/Title/VictoryGo")
  self.textTitle = self:AddComponent(UIText, "Layout/Title/VictoryGo/VictoryText")
  self.textTitle:SetLocalText("activity_torch_relay_title_7")
  self.btnBack = self:AddComponent(UIButton, "Layout/BackBtn")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.textBackBtn = self:AddComponent(UIText, "Layout/BackBtn/BackBtnText")
  self.textBackBtn:SetText(Localization:GetString("multiply_door_tips_008"))
  self.textDes = self:AddComponent(UIText, "Layout/DesText")
  self.textDes:SetText(Localization:GetString("activity_torch_relay_desc_25"))
  self.compNewTag = self:AddComponent(UIBaseContainer, "Layout/Score/NewTag")
  self.textScore = self:AddComponent(UIText, "Layout/Score/ScoreText")
  self.textNew = self:AddComponent(UIText, "Layout/NewText")
  self.textNew:SetText(Localization:GetString("activity_torch_relay_desc_26"))
  self.compCheerContent = self:AddComponent(UIBaseContainer, "Layout/CheerContent")
  self.textCheerTitle = self:AddComponent(UIText, "Layout/CheerContent/CheerTitle")
  self.textCheerTitle:SetText(Localization:GetString("activity_torch_relay_desc_27"))
  self.compCheerItem1 = self:AddComponent(UIBaseContainer, "Layout/CheerContent/CheerItem1")
  self.compUIPlayerHead1 = self:AddComponent(UICommonHead, "Layout/CheerContent/CheerItem1/UIPlayerHead1")
  self.textServerText1 = self:AddComponent(UIText, "Layout/CheerContent/CheerItem1/ServerText1")
  self.textPlayerText1 = self:AddComponent(UIText, "Layout/CheerContent/CheerItem1/PlayerText1")
  self.compCheerItem2 = self:AddComponent(UIBaseContainer, "Layout/CheerContent/CheerItem2")
  self.compUIPlayerHead2 = self:AddComponent(UICommonHead, "Layout/CheerContent/CheerItem2/UIPlayerHead2")
  self.textServerText2 = self:AddComponent(UIText, "Layout/CheerContent/CheerItem2/ServerText2")
  self.textPlayerText2 = self:AddComponent(UIText, "Layout/CheerContent/CheerItem2/PlayerText2")
  self.compCheerEmptyContent = self:AddComponent(UIBaseContainer, "Layout/CheerEmptyContent")
  self.textCheerRareText1 = self:AddComponent(UIText, "Layout/CheerContent/CheerItem1/CheerRareText1")
  self.textCheerRareText1:SetText(Localization:GetString("activity_torch_relay_desc_30"))
  self.textCheerRareText2 = self:AddComponent(UIText, "Layout/CheerContent/CheerItem2/CheerRareText2")
  self.textCheerRareText2:SetText(Localization:GetString("activity_torch_relay_desc_30"))
  self.textRewardTitle1 = self:AddComponent(UIText, "Layout/Reward/RewardTitle1")
  self.textRewardTitle1:SetText(Localization:GetString("activity_torch_relay_desc_31"))
  self.compReward = self:AddComponent(UIBaseContainer, "Layout/Reward")
  self.compContent = self:AddComponent(UIBaseContainer, "Layout/Reward/ScrollRect/Viewport/Content")
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "Layout/UICommonResItem")
end

function UILWTorchRelayBattleWinView:ComponentDestroy()
  self:ClearContent()
  self.btnPanel = nil
  self.compLayout = nil
  self.animatorVictoryGo = nil
  self.btnBack = nil
  self.textBackBtn = nil
  self.textTitle = nil
  self.textDes = nil
  self.compNewTag = nil
  self.textScore = nil
  self.textNew = nil
  self.compCheerContent = nil
  self.textCheerTitle = nil
  self.compCheerItem1 = nil
  self.compUIPlayerHead1 = nil
  self.textServerText1 = nil
  self.textPlayerText1 = nil
  self.compCheerItem2 = nil
  self.compUIPlayerHead2 = nil
  self.textServerText2 = nil
  self.textPlayerText2 = nil
  self.textCheerRareText1 = nil
  self.textCheerRareText2 = nil
  self.textRewardTitle1 = nil
  self.compReward = nil
  self.compContent = nil
  self.compUICommonResItem = nil
  self.compCheerEmptyContent = nil
end

function UILWTorchRelayBattleWinView:DataDefine()
end

function UILWTorchRelayBattleWinView:DataDestroy()
end

function UILWTorchRelayBattleWinView:OnAddListener()
  base.OnAddListener(self)
end

function UILWTorchRelayBattleWinView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWTorchRelayBattleWinView:OnOpen()
  local function IsAdvanceCheer(cheerId)
    local line = LocalController:instance():getLine(TableName.Activity_Torch_Relay_Stage_Cheer, tonumber(cheerId))
    
    if line then
      local template = TorchRelayBattleStageCheerConfigTemplate.New()
      template:InitData(line)
      return template.cheer_rare == 1
    end
    return false
  end
  
  self.param = self:GetUserData()
  if self.param == nil then
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_stage_win_bgm)
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic and logic.data then
    self.textScore:SetText(math.ceil(checknumber(self.param.score) * logic.data:GetScoreCoefficient()) .. "m")
  end
  self.compNewTag:SetActive(self.param.isMax == true)
  self.textNew:SetActive(self.param.isMax == true)
  self:ClearContent()
  self.requests = {}
  if not table.IsNullOrEmpty(self.param.reward) then
    local rewards = DataCenter.RewardManager:ReturnRewardParamForView(self.param.reward)
    local index = 1
    local totalCount = #rewards
    for _, v in pairs(rewards) do
      local request = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        if self.compContent == nil then
          return
        end
        go.transform:SetParent(self.compContent.transform)
        go.gameObject:SetActive(true)
        go.transform:Set_localScale(1, 1, 1)
        go.name = "item_" .. tostring(index)
        local cell = self.compContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(v)
        index = index + 1
        if index > totalCount and self.compLayout then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compLayout.transform)
        end
      end)
      table.insert(self.requests, request)
    end
  end
  local hasCheerData = not table.IsNullOrEmpty(self.param.helpsDetails)
  self.compCheerContent:SetActive(hasCheerData)
  self.textCheerRareText1:SetActive(false)
  self.textCheerRareText2:SetActive(false)
  self.compCheerEmptyContent:SetActive(not hasCheerData)
  if hasCheerData then
    self.compCheerItem1:SetActive(self.param.helpsDetails[1] ~= nil)
    self.compCheerItem2:SetActive(self.param.helpsDetails[2] ~= nil)
    if self.param.helpsDetails[1] ~= nil then
      self.compUIPlayerHead1:SetData(self.param.helpsDetails[1].uid, self.param.helpsDetails[1].pic, self.param.helpsDetails[1].picver)
      self.textServerText1:SetText(UIUtil.FormatServerAllianceName(nil, self.param.helpsDetails[1].abbr, self.param.helpsDetails[1].name))
      self.textCheerRareText1:SetActive(self.param.helpsDetails[1].cheerId ~= nil and IsAdvanceCheer(self.param.helpsDetails[1].cheerId))
      if IsAdvanceCheer(self.param.helpsDetails[1].cheerId) then
        self.textPlayerText1:SetColorRGBA255(253, 200, 57, 255)
        self.textPlayerText1:SetLocalText("activity_torch_relay_desc_28")
      else
        self.textPlayerText1:SetColorRGBA255(95, 239, 135, 255)
        self.textPlayerText1:SetLocalText("activity_torch_relay_desc_29")
      end
    end
    if self.param.helpsDetails[2] ~= nil then
      self.compUIPlayerHead2:SetData(self.param.helpsDetails[2].uid, self.param.helpsDetails[2].pic, self.param.helpsDetails[2].picver)
      self.textServerText2:SetText(UIUtil.FormatServerAllianceName(nil, self.param.helpsDetails[2].abbr, self.param.helpsDetails[2].name))
      self.textCheerRareText2:SetActive(self.param.helpsDetails[2].cheerId ~= nil and IsAdvanceCheer(self.param.helpsDetails[2].cheerId))
      if IsAdvanceCheer(self.param.helpsDetails[2].cheerId) then
        self.textPlayerText2:SetColorRGBA255(253, 200, 57, 255)
        self.textPlayerText2:SetLocalText("activity_torch_relay_desc_28")
      else
        self.textPlayerText2:SetColorRGBA255(95, 239, 135, 255)
        self.textPlayerText2:SetLocalText("activity_torch_relay_desc_29")
      end
    end
  end
end

function UILWTorchRelayBattleWinView:OnBtnPanelClick()
  self:OnBtnBackClick()
end

function UILWTorchRelayBattleWinView:OnBtnBackClick()
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "win")
end

function UILWTorchRelayBattleWinView:ClearContent()
  if self.requests then
    if self.compContent then
      self.compContent:RemoveComponents(UICommonResItem)
    end
    for i, v in pairs(self.requests) do
      v:Destroy()
    end
  end
  self.requests = nil
end

return UILWTorchRelayBattleWinView
