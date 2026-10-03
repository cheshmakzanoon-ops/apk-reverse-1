local LWSeasonPersonalRewardItem = BaseClass("LWSeasonPersonalRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local desc_path = "Root/Desc"
local bg_path = "Root/Bg"
local btn_claim_path = "Root/Btn_Claim"
local content_path = "Root/Rect_Reward/Viewport/Content"
local u_i_common_res_item_path = "Root/UICommonResItem"
local already_get_path = "Root/alreadyGet"
local icon_path = "Root/Icon"

function LWSeasonPersonalRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.cells = {}
end

function LWSeasonPersonalRewardItem:OnDestroy()
  self.cells = nil
  self.type = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonPersonalRewardItem:OnEnable()
  base.OnEnable(self)
end

function LWSeasonPersonalRewardItem:OnDisable()
  base.OnDisable(self)
end

function LWSeasonPersonalRewardItem:ComponentDefine()
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.btn_claim = self:AddComponent(UIButton, btn_claim_path)
  self.already_get = self:AddComponent(UITextMeshProUGUIEx, already_get_path)
  self.btn_claim:SetSafeClickMode(true)
  self.btn_claim:SetOnClick(function()
    self:OnClaimBtn()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.common_res_item = self.transform:Find(u_i_common_res_item_path).gameObject
  self.common_res_item:GameObjectCreatePool()
  self.icon = self:AddComponent(UIImage, icon_path)
end

function LWSeasonPersonalRewardItem:ComponentDestroy()
  self.desc = nil
  self.bg = nil
  self.btn_claim = nil
  self.content:RemoveComponents(UICommonResItem)
  self.content = nil
  self.already_get = nil
  if self.common_res_item then
    self.common_res_item:GameObjectRecycleAll()
  end
  self.common_res_item = nil
  self.icon = nil
end

function LWSeasonPersonalRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function LWSeasonPersonalRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWSeasonPersonalRewardItem:OnClaimBtn()
  if self.rewardState == 1 then
    UIUtil.ShowTips(Localization:GetString("season_builders_alliance_tips_42"))
    return
  end
  
  local function sendCall()
    if self.isNew then
      SFSNetwork.SendMessage(MsgDefines.UserSesaonAchievementV2Reward, toInt(self.type), self.data.score)
    elseif self.type == SeasonScoreRewardPanelType.PersonalOccupyLand then
      SFSNetwork.SendMessage(MsgDefines.LWSeasonUserMaxForceRewardGet, self.data.id)
    elseif self.type == SeasonScoreRewardPanelType.PersonalContributeAchievement then
      SFSNetwork.SendMessage(MsgDefines.LWSeasonContributeAchievement, 3, self.data.id)
    elseif self.type == SeasonScoreRewardPanelType.AllianceStrongholdAchivement then
      SFSNetwork.SendMessage(MsgDefines.LWSeasonStrongholdAchievement, 3, self.data.id)
    end
  end
  
  if self.isFarmer then
    if self.roleState == 3 then
      UIUtil.ShowTips(Localization:GetString("season_builders_alliance_tips_26"))
      return
    end
    if self.roleState == 1 then
      local param = {}
      param.panelType = CommonTipConfirmType.SeasonFarmerRewardTip
      
      function param.confirmCall()
        UIUtil.ShowSecondMessage("", Localization:GetString("season_builders_alliance_tips_25"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          sendCall()
        end, nil, nil, nil, nil, nil, nil, nil, nil, false)
      end
      
      UIManager:GetInstance():OpenWindow(UIWindowNames.CommonTipConfirm, {anim = true}, param)
    elseif self.roleState == 2 then
      sendCall()
    end
    return
  end
  sendCall()
end

function LWSeasonPersonalRewardItem:SetData(data, view, iconPath, isNew, isFarmer)
  if self.seasonType == nil then
    self.seasonType = SeasonUtil.GetSeasonType()
  end
  self.isFarmer = isFarmer
  self.data = data
  if self.seasonType == SeasonMapType.NineNation then
    self.desc:SetText(string.GetFormattedStr0(data.score))
  else
    self.desc:SetText(data.score)
  end
  self.rewardState = 1
  self.isNew = isNew
  local changeIcon = self.type ~= view.panelType
  self.type = view.panelType
  if data.score <= view.curScore then
    if data.receive then
      self.rewardState = 3
    else
      self.rewardState = 2
    end
  else
    self.rewardState = 1
  end
  self.btn_claim:SetActive(self.rewardState == 2 or self.rewardState == 1)
  if self.isFarmer then
    if self.rewardState == 2 then
      self.roleState = LuaEntry.Player:SeaonRoleState()
      if self.roleState == 3 then
        CS.UIGray.SetGray(self.btn_claim.transform, true, true)
      else
        CS.UIGray.SetGray(self.btn_claim.transform, false, true)
      end
    else
      CS.UIGray.SetGray(self.btn_claim.transform, self.rewardState == 1, true)
    end
  else
    CS.UIGray.SetGray(self.btn_claim.transform, self.rewardState == 1, true)
  end
  self.already_get:SetActive(self.rewardState == 3)
  local bgPath
  if self.rewardState == 2 then
    bgPath = string.format(LoadPath.SeasonReward, "Mjc_S2_chengjiu_list_02")
  else
    bgPath = string.format(LoadPath.SeasonReward, "Mjc_S2_chengjiu_list_01")
  end
  self.bg:LoadSprite(bgPath)
  local reward = data.rewards
  self.content:SetAnchoredPositionXY(0, 0)
  if reward then
    for index, value in ipairs(reward) do
      local cellCache = self.cells[index]
      if cellCache then
        cellCache:ReInit(value)
        cellCache:SetActive(true)
      else
        local go = self.common_res_item:GameObjectSpawn(self.content.transform)
        go.gameObject:SetActive(true)
        go.transform:Set_localScale(0.76, 0.76, 0.76)
        go.name = "item" .. tostring(index)
        local cell = self.content:AddComponent(UICommonResItem, go.name)
        cell:ReInit(value)
        table.insert(self.cells, cell)
      end
    end
    local cellsCount = #self.cells
    local rewardCount = #reward
    if cellsCount > #reward then
      for i = rewardCount + 1, cellsCount do
        self.cells[i]:SetActive(false)
      end
    end
  else
    local cellsCount = #self.cells
    if 0 < cellsCount then
      for i = 1, cellsCount do
        self.cells[i]:SetActive(false)
      end
    end
  end
  self.icon:LoadSprite(iconPath)
end

return LWSeasonPersonalRewardItem
