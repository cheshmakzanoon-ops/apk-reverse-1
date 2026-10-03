local base = UIAsyncContainer
local LLGroupChoosePanelItem = BaseClass("LLGroupChoosePanelItem", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local LLServerItem = require("UI.Landlord.Main.Component.LLServerItem")
local ActMgr = DataCenter.LandlordMgr

function LLGroupChoosePanelItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLGroupChoosePanelItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLGroupChoosePanelItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compLLServerItem = self.viewSkin:AddComponent(self, LLServerItem, 2)
  self.btnInvite = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnInvite:SetOnClick(function()
    self:OnBtnInviteClick()
  end)
end

function LLGroupChoosePanelItem:ComponentDestroy()
  self.viewSkin = nil
  self.textName = nil
  self.compLLServerItem = nil
  self.btnInvite = nil
end

function LLGroupChoosePanelItem:DataDefine()
end

function LLGroupChoosePanelItem:DataDestroy()
  self.sInfo = nil
end

function LLGroupChoosePanelItem:OnAddListener()
  base.OnAddListener(self)
end

function LLGroupChoosePanelItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLGroupChoosePanelItem:OnBtnInviteClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local partInfo = ActMgr:GetCurGroupPartInfo()
  local partIdx = partInfo ~= nil and partInfo.partIdx or 0
  if partIdx == 0 then
    UIUtil.ShowTipsId("zonewar_landlord_tips_1003")
    return
  end
  local camp = partInfo.camp
  local canOperate = false
  local defNum = 1
  if camp == LLConst.LandLordGroup.LORD then
    canOperate = ActMgr:IsBigKing()
    defNum = LLConst.INIT_BIG_LORD_COUNT
  elseif camp == LLConst.LandLordGroup.FARMER then
    canOperate = ActMgr:IsBigFarmerKing()
    defNum = LLConst.INIT_BIG_FARMER_COUNT
  end
  if not canOperate then
    UIUtil.ShowTipsId("zonewar_landlord_tips_1003")
    return
  end
  local limitNum = partInfo.totalLimit
  local lList = ActMgr:GetServersByGroup(camp)
  local cntTeamMate = #lList - defNum
  if limitNum <= cntTeamMate then
    local str = Localization:GetString("zonewar_landlord_tips_1005", partInfo.curBp)
    UIUtil.ShowTips(str)
    return
  end
  local sInfo = self.sInfo
  if sInfo == nil then
    return
  end
  local info = {sInfo = sInfo, isInvite = true}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLGroupInvitation, {anim = true}, info)
end

function LLGroupChoosePanelItem:SetServer(sInfo)
  self.sInfo = sInfo
  self:RefreshView()
end

function LLGroupChoosePanelItem:UpdateData()
  local sInfo = self.sInfo
  if sInfo == nil then
    self.textName:SetText("")
    self.compLLServerItem:SetServer()
    return
  end
  self.textName:SetText(sInfo.king.name or "")
  self.compLLServerItem:SetServer(sInfo, LLConst.LandLordGroup.NONE, LLConst.LandlordStage.GROUP)
end

return LLGroupChoosePanelItem
