local base = UIBaseContainer
local HSRRobVictimComponent = BaseClass("HSRRobVictimComponent", UIBaseContainer)
local UILW3V3TeamItem = require("UI.UILW3V3Campaign.Component.UILW3V3TeamItem")
local Localization = CS.GameEntry.Localization
local l_w_btn_info_path = "LW_Btn_Info"

function HSRRobVictimComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HSRRobVictimComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HSRRobVictimComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.head = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.textPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compSquad = self.viewSkin:AddComponent(self, UILW3V3TeamItem, 3)
  self.textGoods = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnRob = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnRob:SetOnClick(function()
    self:OnBtnRobClick()
  end)
  self.textRob = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.head:SetEnableClickShowInfo(true, true)
  self.l_w_btn_info = self:AddComponent(UIButton, l_w_btn_info_path)
  self.l_w_btn_info:SetOnClick(function()
    local content = Localization:GetString("season_mastery_s5_tips_4")
    if self.buffValue then
      content = Localization:GetString("season_mastery_s5_tips_3", self.buffValue)
    end
    UIUtil.ShowBubbleTips(content, self.l_w_btn_info.transform.position, 0, -20, 0)
  end)
  self.textRob:SetLocalText("activity_1200044_tips69")
  self.textGoods:SetLocalText("100377")
end

function HSRRobVictimComponent:ComponentDestroy()
  self.viewSkin = nil
  self.head = nil
  self.textPower = nil
  self.compSquad = nil
  self.textGoods = nil
  self.textServer = nil
  self.textName = nil
  self.btnRob = nil
  self.textRob = nil
  self.textCount = nil
end

function HSRRobVictimComponent:DataDefine()
end

function HSRRobVictimComponent:DataDestroy()
  self.data = nil
end

function HSRRobVictimComponent:OnAddListener()
  base.OnAddListener(self)
end

function HSRRobVictimComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function HSRRobVictimComponent:SetData(data)
  self.data = data
  if not self.data then
    return
  end
  self.compSquad:SetData(data.heroInfo, string.GetFormattedStr2(data.power), data.heroInfo[6])
  self.head:ParseHeadInfo(self.data)
  self.textServer:SetText(UIUtil.FormatServerName(self.data.serverId))
  self.textName:SetText(UIUtil.FormatAllianceAndName(self.data.abbr, self.data.name))
  self.textCount:SetText(self.data.lootNum)
  self.buffValue = nil
  if self.data.defaultLootNum then
    local buffValue = self.data.lootNum - self.data.defaultLootNum
    if 0 < buffValue then
      self.buffValue = buffValue
      self.textCount:SetText(self.data.defaultLootNum .. "<color=green>+" .. buffValue .. "</color>")
    end
  end
end

function HSRRobVictimComponent:OnBtnRobClick()
  RailwayUtil.ClickAttackHSR(self.data)
end

return HSRRobVictimComponent
