local base = UIAsyncContainer
local LWCityDefenceWallBar = BaseClass("LWCityDefenceWallBar", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local wall_bar_tips_btn_path = "WallBarDesc/WallBarTipsBtn"
local wall_bar_desc_text_path = "WallBarDesc/WallBarDescText"
local fill_path = "WallBarSlider/Fill"
local bar_text_path = "WallBarSlider/BarText"

function LWCityDefenceWallBar:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWCityDefenceWallBar:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWCityDefenceWallBar:ComponentDefine()
  self.wall_bar_tips_btn = self:AddComponent(UIButton, wall_bar_tips_btn_path)
  self.wall_bar_tips_btn:SetOnClick(function()
    if self.view and self.view.InfoBtnClick then
      self.view:InfoBtnClick(3, self.wall_bar_tips_btn.transform.position)
    end
  end)
  self.wall_bar_desc_text = self:AddComponent(UITextMeshProUGUIEx, wall_bar_desc_text_path)
  self.fill = self:AddComponent(UIImage, fill_path)
  self.health_bar_ctrl = self.fill.gameObject:GetComponent(typeof(CS.UIHealthBarController))
  self.bar_text = self:AddComponent(UITextMeshProUGUIEx, bar_text_path)
end

function LWCityDefenceWallBar:ComponentDestroy()
  self.wall_bar_tips_btn = nil
  self.wall_bar_desc_text = nil
  self.fill = nil
  self.bar_text = nil
  self.health_bar_ctrl = nil
end

function LWCityDefenceWallBar:DataDefine()
end

function LWCityDefenceWallBar:DataDestroy()
end

function LWCityDefenceWallBar:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshMyWallBar, self.Refresh)
end

function LWCityDefenceWallBar:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshMyWallBar, self.Refresh)
  base.OnRemoveListener(self)
end

function LWCityDefenceWallBar:Refresh()
  if IsNotNull(self.gameObject) then
    self:UpdateData()
  end
end

function LWCityDefenceWallBar:UpdateData()
  local cur, max = DataCenter.DefenceWallDataManager:GetWallBarCurAndMax()
  if max <= 0 then
    return
  end
  self.bar_text:SetText(cur .. "/" .. max)
  if self.health_bar_ctrl then
    self.health_bar_ctrl:SetHealth(cur, max)
  end
  if cur <= 0 then
    self.wall_bar_desc_text:SetLocalText("season_mastery_s6_ui_1_limit")
  elseif max <= cur then
    self.wall_bar_desc_text:SetLocalText("season_mastery_s6_ui_3_limit")
  else
    self.wall_bar_desc_text:SetLocalText("season_mastery_s6_ui_2_limit")
  end
end

return LWCityDefenceWallBar
