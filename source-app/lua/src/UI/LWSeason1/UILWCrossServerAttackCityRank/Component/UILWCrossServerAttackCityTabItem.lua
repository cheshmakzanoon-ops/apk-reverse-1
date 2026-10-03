local UILWCrossServerAttackCityTabItem = BaseClass("UILWCrossServerAttackCityTabItem", UIButton)
local base = UIButton

function UILWCrossServerAttackCityTabItem:OnCreate()
  base.OnCreate(self)
  self.select = self:AddComponent(UIToggle, "select")
  self:SetOnClick(function()
    self:OnClick(true)
  end)
  self.select:SetOnValueChanged(function(tf)
    self.select_status = tf
  end)
end

function UILWCrossServerAttackCityTabItem:SetIsOn(select_it)
  if self.select_status == select_it then
    return
  end
  self.select_status = select_it
  self.select:SetIsOn(select_it == true)
  self:OnClick(false)
end

function UILWCrossServerAttackCityTabItem:OnDestroy()
  self.select = nil
  base.OnDestroy(self)
end

function UILWCrossServerAttackCityTabItem:OnClick(can_show_error)
  if self.callbackHandle ~= nil and self.week_index ~= nil and self.select ~= nil then
    CommonUtil.ProtectCall(function()
      if self.week_index == 0 or self.nowWeek and self.nowWeek >= self.week_index then
        self.select_status = true
        self.select:SetIsOn(true)
        self.callbackHandle:OnWeekChanged(self.week_index)
      elseif can_show_error then
        UIUtil.ShowTipsId("season_mastery_104")
      end
    end)
  end
end

function UILWCrossServerAttackCityTabItem:ReInit(nowWeek, week_index, view)
  self.nowWeek = nowWeek
  self.week_index = week_index
  self.callbackHandle = view
end

return UILWCrossServerAttackCityTabItem
