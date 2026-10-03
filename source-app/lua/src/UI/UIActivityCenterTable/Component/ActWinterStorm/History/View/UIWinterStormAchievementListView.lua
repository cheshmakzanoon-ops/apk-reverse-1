local UIWinterStormAchievementListView = BaseClass("UIWinterStormAchievementListView", UIBaseView)
local base = UIBaseView
local CLS = "UI.UIActivityCenterTable.Component.ActWinterStorm.History.Component.UIWS_A_Cell"
local PREFAB = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/S0/UIWS_A_Cell.prefab"
local BG_PATH = "ChatItems/cfm_tongyon_tanchuang_erjichen.png"

function UIWinterStormAchievementListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWinterStormAchievementListView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWinterStormAchievementListView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollRect, 3)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.imgDi = self.viewSkin:AddComponent(self, UIImage, 5)
end

function UIWinterStormAchievementListView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.scrollView = nil
  self.content = nil
  self.imgDi = nil
end

function UIWinterStormAchievementListView:DataDefine()
  local achievements, ignoreNight = self:GetUserData()
  if table.IsNullOrEmpty(achievements) then
    local rules = BattleFieldUtil.GetRuleList(BattleFieldType.WinterStorm, 7)
    for _, rule in ipairs(rules) do
      local line = LocalController:instance():getLine(TableName.LW_BattleField_RewardPointShow, rule.reward_point)
      if line ~= nil then
        local pType = line:getIntValue("reward_point_type")
        if pType == BF_RewardPointType.ACHIEVEMENT then
          achievements = line:getValue("type_id_list")
          break
        end
      end
    end
  end
  self.achievements = achievements or {}
  DataCenter.ActWinterStormManager:SortAchievement(self.achievements)
  local chatMode = ChatUIThemeConfig.ChatMode.Normal
  if ignoreNight ~= true then
    chatMode = ChatInterface.GetChatTheme()
  end
  self.chatMode = chatMode
  self.imgDi:LoadSpriteAuto(ChatUIThemeConfig.UIPrefix[chatMode] .. BG_PATH)
  local cnt = #self.achievements
  self.scrollView:SetActive(0 < cnt)
  if 0 < cnt then
    for i, v in ipairs(self.achievements) do
      local item = self:LoadComponentAsync(CLS, PREFAB, self.content, function(_, go, _, callback_param)
        go.transform:SetSiblingIndex(toInt(callback_param))
      end, i - 1)
      item:SetData(v)
    end
  end
end

function UIWinterStormAchievementListView:DataDestroy()
  self.achievements = nil
end

function UIWinterStormAchievementListView:OnAddListener()
  base.OnAddListener(self)
end

function UIWinterStormAchievementListView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWinterStormAchievementListView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIWinterStormAchievementListView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UIWinterStormAchievementListView
