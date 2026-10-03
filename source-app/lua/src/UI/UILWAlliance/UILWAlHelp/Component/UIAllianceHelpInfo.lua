local UIAllianceHelpInfo = BaseClass("UIAllianceHelpInfo", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local click_btn_path = "Btn"

function UIAllianceHelpInfo:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAllianceHelpInfo:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceHelpInfo:ComponentDefine()
  self.textHelpCount = self:AddComponent(UITextMeshProUGUIEx, "Bg/Horizon/HelpCount")
  self.textReduceSec = self:AddComponent(UITextMeshProUGUIEx, "Bg/Horizon/ReduceSec")
end

function UIAllianceHelpInfo:OnSetInfo(curCount, totalCount, reduceSec)
  self.textHelpCount:SetLocalText("newbies_alliance_helplist_desc", curCount, totalCount)
  self.textReduceSec:SetText("-" .. UITimeManager:GetInstance():SecondToFmtString(reduceSec))
end

function UIAllianceHelpInfo:ComponentDestroy()
  self.clickBtn = nil
end

function UIAllianceHelpInfo:DataDefine()
end

function UIAllianceHelpInfo:DataDestroy()
end

function UIAllianceHelpInfo:OnEnable()
  base.OnEnable(self)
end

function UIAllianceHelpInfo:OnDisable()
  base.OnDisable(self)
end

function UIAllianceHelpInfo:OnAddListener()
  base.OnAddListener(self)
end

function UIAllianceHelpInfo:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UIAllianceHelpInfo
