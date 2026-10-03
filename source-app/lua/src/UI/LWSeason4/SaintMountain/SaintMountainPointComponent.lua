local base = UIAsyncContainer
local SaintMountainPointComponent = BaseClass("SaintMountainPointComponent", base)
local Localization = CS.GameEntry.Localization

function SaintMountainPointComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function SaintMountainPointComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SaintMountainPointComponent:ComponentDefine()
  self.btnLWInfo = self:AddComponent(UIButton, "bg/progressText/LW_Btn_Info")
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.textProgress = self:AddComponent(UITextMeshProUGUIEx, "bg/progressText")
  self.slider = self:AddComponent(UISlider, "bg/Slider")
  self.textTip = self:AddComponent(UITextMeshProUGUIEx, "bg/tip")
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "bg/descBg/desc")
end

function SaintMountainPointComponent:ComponentDestroy()
  self.btnLWInfo = nil
  self.textProgress = nil
  self.slider = nil
  self.textTip = nil
  self.textDesc = nil
end

function SaintMountainPointComponent:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.BloodNightCloseScoreView, LuaEntry.Player:GetSelfServerId())
end

function SaintMountainPointComponent:DataDestroy()
end

function SaintMountainPointComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SaintMountainProgressRefresh, self.RefreshProgress)
end

function SaintMountainPointComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.SaintMountainProgressRefresh, self.RefreshProgress)
  base.OnRemoveListener(self)
end

function SaintMountainPointComponent:Refresh()
  if IsNull(self.gameObject) then
    return
  end
  self:RefreshProgress()
  self.textDesc:SetLocalText("season_s4_activity_1200009_desc46")
  self.textTip:SetLocalText("season_s4_activity_1200009_desc47")
end

function SaintMountainPointComponent:OnBtnLWInfoClick()
  local scoreList = {}
  LocalController:instance():visitTable(TableName.LW_Season_Blood_Night_Score, function(id, lineData)
    table.insert(scoreList, {
      name = lineData.tips,
      score = lineData.points
    })
  end)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWCommonScoreDetail, {anim = false}, scoreList, "season_s4_activity_1200009_desc49")
end

function SaintMountainPointComponent:RefreshProgress()
  local cur, max = DataCenter.BloodyNightDataManager:GetSaintMountainProgress(LuaEntry.Player:GetCurServerId())
  self.textProgress:SetText(Localization:GetString("season_s4_activity_1200009_desc45") .. string.percentage(cur, max, 2))
  self.slider:SetValue(cur / max)
end

return SaintMountainPointComponent
