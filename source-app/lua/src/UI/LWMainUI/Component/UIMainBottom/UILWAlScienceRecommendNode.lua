local UILWAlScienceRecommendNode = BaseClass("UILWAlScienceRecommendNode", UIAsyncProxy)
local base = UIAsyncProxy
local LuaPath = "UI.LWMainUI.Component.UIMainBottom.UILWAlScienceRecommend"
local PrefabPath = "Assets/Main/Prefabs/UI/Alliance/Component/UILWAlScienceRecommend.prefab"
local Localization = CS.GameEntry.Localization

function UILWAlScienceRecommendNode:OnCreate()
  base.OnCreate(self)
end

function UILWAlScienceRecommendNode:OnDestroy()
  self.hide = nil
  base.OnDestroy(self)
end

function UILWAlScienceRecommendNode:OnEnable()
  base.OnEnable(self)
  local getAllianceTechMessage = DataCenter.AllianceScienceDataManager.getAllianceTechMessage
  self.getAllianceTechMessage = getAllianceTechMessage
  self:OnRefreshShow()
end

function UILWAlScienceRecommendNode:OnDisable()
  base.OnDisable(self)
end

function UILWAlScienceRecommendNode:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceQuitOK, self.OnAllianceQuit)
  self:AddUIListener(EventId.OnAlScienceRecommendChange, self.OnDataChanged)
  self:AddUIListener(EventId.Al_UpdateSelfRank, self.OnDataChanged)
  self:AddUIListener(EventId.OnGetAllianceTechMessage, self.OnGetAllianceTechMessage)
end

function UILWAlScienceRecommendNode:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceQuitOK, self.OnAllianceQuit)
  self:RemoveUIListener(EventId.OnAlScienceRecommendChange, self.OnDataChanged)
  self:RemoveUIListener(EventId.Al_UpdateSelfRank, self.OnDataChanged)
  self:RemoveUIListener(EventId.OnGetAllianceTechMessage, self.OnGetAllianceTechMessage)
  base.OnRemoveListener(self)
end

function UILWAlScienceRecommendNode:OnHideTip()
  self.hide = true
  self:TrySetShow(not self.hide)
end

function UILWAlScienceRecommendNode:OnAllianceQuit()
  self:OnHideTip()
end

function UILWAlScienceRecommendNode:OnGetAllianceTechMessage()
  if self.getAllianceTechMessage then
    return
  end
  self.getAllianceTechMessage = true
  self:OnRefreshShow()
end

function UILWAlScienceRecommendNode:OnRefreshShow()
  if not self.getAllianceTechMessage then
    self:TrySetShow(false)
    return
  end
  if not self.hide then
    local isHide = true
    local flag = DataCenter.AllianceBaseDataManager:IsR4orR5()
    if flag then
      local science = DataCenter.AllianceScienceDataManager:GetCurRecommendScience()
      if science == nil then
        science = DataCenter.AllianceScienceDataManager:FindCanRecommendScience()
        if science ~= nil then
          isHide = false
        end
      end
    end
    self:TrySetShow(not isHide)
  end
end

function UILWAlScienceRecommendNode:OnDataChanged()
  if self.hide then
    return
  end
  local flag = DataCenter.AllianceBaseDataManager:IsR4orR5()
  if not flag then
    self:OnHideTip()
    return
  end
  local science = DataCenter.AllianceScienceDataManager:GetCurRecommendScience()
  if science ~= nil then
    self:OnHideTip()
    return
  end
end

function UILWAlScienceRecommendNode:OnClick()
  self:OnHideTip()
  local recommendScience = DataCenter.AllianceScienceDataManager:FindCanRecommendScience()
  if recommendScience == nil then
    UIUtil.ShowTips(Localization:GetString("alliance_system019"))
    return
  end
  local flag = DataCenter.AllianceBaseDataManager:IsR4orR5()
  if not flag then
    UIUtil.ShowTips(Localization:GetString("alliance_system020"))
    return
  end
  local science = DataCenter.AllianceScienceDataManager:GetCurRecommendScience()
  if science ~= nil then
    UIUtil.ShowTips(Localization:GetString("alliance_system020"))
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScience, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide,
    hideTop = true
  }, {
    autoOpenRecScience = false,
    openScienceId = toInt(recommendScience.scienceId),
    recommendEffect = true
  })
end

function UILWAlScienceRecommendNode:TrySetShow(bool)
  if not bool then
    self:SetShow(false)
  end
  self.holder:TrySetShow(MainAlBubbleType.Science, bool)
end

function UILWAlScienceRecommendNode:SetShow(bool)
  self:SetActiveAsync(bool, LuaPath, PrefabPath)
end

return UILWAlScienceRecommendNode
