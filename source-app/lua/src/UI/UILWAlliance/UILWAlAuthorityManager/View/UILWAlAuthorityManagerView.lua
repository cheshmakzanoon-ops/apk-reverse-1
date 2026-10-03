local UILWAlAuthorityManagerView = BaseClass("UILWAlAuthorityManagerView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local Item = require("UI.UILWAlliance.UILWAlAuthorityManager.Component.UILWAlAuthorityManagerItem")
local txt_title_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local close_btn_path = "Panel"
local return_btn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local player_icon_path = "Root/Content/Up/PlayerBtn/UIPlayerHead"
local name_text_path = "Root/Content/Up/NameText"
local rank_icon_path = "Root/Content/Up/RankIcon"
local content_path = "Root/Content/Mid/Content"
local item_path = "Root/Content/Mid/Item"
local confirm_btn_path = "Root/Content/Bottom/ConfirmBtn"
local confirm_txt_btn_path = "Root/Content/Bottom/ConfirmBtn/ConfirmText"
local transfer_Leader_btn_path = "Root/Content/Bottom/TransferLeaderBtn"
local transfer_Leader_txt_btn_path = "Root/Content/Bottom/TransferLeaderBtn/TransferLeaderBtnText"
local TITLE_TXT = 393070
local CONFIRM_TXT = 393010
local TRANSFORM_TXT = 390274

function UILWAlAuthorityManagerView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlAuthorityManagerView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlAuthorityManagerView:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, txt_title_path)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.returnBtn = self:AddComponent(UIButton, return_btn_path)
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.playerIcon = self:AddComponent(UICommonHead, player_icon_path)
  self.nameTxt = self:AddComponent(UIText, name_text_path)
  self.rankIcon = self:AddComponent(UIImage, rank_icon_path)
  self.listContent = self:AddComponent(UIBaseContainer, content_path)
  self.listItemPrefab = self.transform:Find(item_path).gameObject
  self.listItemPrefab:GameObjectCreatePool()
  self.confirmTxt = self:AddComponent(UIText, confirm_txt_btn_path)
  self.confirmBtn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirmBtn:SetOnClick(function()
    self:OnClickConfirm()
  end)
  self.transformTxt = self:AddComponent(UIText, transfer_Leader_txt_btn_path)
  self.transformBtn = self:AddComponent(UIButton, transfer_Leader_btn_path)
  self.transformBtn:SetOnClick(function()
    self:OnTransformClick()
  end)
  self.titleTxt:SetLocalText(TITLE_TXT)
  self.confirmTxt:SetLocalText(CONFIRM_TXT)
  self.transformTxt:SetLocalText(TRANSFORM_TXT)
end

function UILWAlAuthorityManagerView:ComponentDestroy()
  self.titleTxt = nil
  self.closeBtn = nil
  self.returnBtn = nil
  self.playerIcon = nil
  self.nameTxt = nil
  self.rankIcon = nil
  self.listContent = nil
  self.listItemPrefab = nil
  self.confirmTxt = nil
  self.confirmBtn = nil
end

function UILWAlAuthorityManagerView:DataDefine()
  self.ctrl:SetView(self)
  self.btnCells = {}
  self.data = {}
  self.selfRank = 0
  self.rank = 0
  self.official = ""
  self.curSelectType = 0
end

function UILWAlAuthorityManagerView:DataDestroy()
  self.ctrl:ClearView()
  self.btnCells = nil
  self.data = nil
  self.selfRank = nil
  self.rank = nil
  self.official = nil
  self.curSelectType = nil
end

function UILWAlAuthorityManagerView:OnEnable()
  base.OnEnable(self)
  self.data, self.selfRank, self.rank, self.official = self:GetUserData()
  self.curSelectType = DataCenter.AllianceMemberDataManager:GetTableIndex(self.rank, self.official)
  self:OnRrefresh()
end

function UILWAlAuthorityManagerView:OnDisable()
  base.OnDisable(self)
end

function UILWAlAuthorityManagerView:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlAuthorityManagerView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlAuthorityManagerView:OnRrefresh()
  local data = self.data
  local userId = data.uid
  local userPic = data.pic
  local userPicVer = data.picVer
  local headBg = data.headBg
  self.playerIcon:SetData(userId, userPic, userPicVer, true, headBg)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.uid, data.name)
  self.nameTxt:SetText(showName)
  if self.curSelectType then
    local line = LocalController:instance():getLine(TableName.LW_Alliance_Officer_Info, self.curSelectType)
    local icon = line.icon
    self.rankIcon:LoadSprite(icon)
    self.rankIcon:SetNativeSize()
  end
  self:RefreshContent()
end

function UILWAlAuthorityManagerView:ClearContent()
  self.listContent:RemoveComponents(Item)
end

function UILWAlAuthorityManagerView:RefreshContent()
  self:ClearContent()
  self.listItemPrefab.gameObject:GameObjectRecycleAll()
  local list = self.ctrl:GetShowList(self.selfRank)
  self.transformBtn:SetActive(self.selfRank == 5)
  for k, v in ipairs(list) do
    local item = self.listItemPrefab:GameObjectSpawn(self.listContent.transform)
    item.name = "item" .. k
    local cell = self.listContent:AddComponent(Item, item.name)
    cell:SetData(v, self.curSelectType)
    self.btnCells[v] = cell
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.listContent.rectTransform)
end

function UILWAlAuthorityManagerView:IsOfficial(type)
  return type == LWAlMemberAuthorityType.Official_1 or type == LWAlMemberAuthorityType.Official_2 or type == LWAlMemberAuthorityType.Official_3 or type == LWAlMemberAuthorityType.Official_4
end

function UILWAlAuthorityManagerView:OnClickItem(type)
  if self.curSelectType == type then
    if self:IsOfficial(type) then
      type = LWAlMemberAuthorityType.Rank_4
    else
      return
    end
  elseif type == LWAlMemberAuthorityType.Rank_4 and self:IsOfficial(self.curSelectType) then
    type = self.curSelectType
  end
  self.curSelectType = type
  table.walk(self.btnCells, function(v, cell)
    cell:RefreshSelect(self.curSelectType)
  end)
end

function UILWAlAuthorityManagerView:OnClickConfirm()
  local memberData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(self.data.uid)
  if memberData and memberData.rank ~= 4 and (self.curSelectType == LWAlMemberAuthorityType.Rank_4 or self.curSelectType < LWAlMemberAuthorityType.Rank_1) then
    local k1 = DataCenter.AllianceMemberDataManager:GetR4MaxMemberNum()
    local list, onlineNum = DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(4)
    if #list == k1 then
      UIUtil.ShowTips(Localization:GetString("455163", "R4"))
      return
    end
  end
  self.ctrl:OnChangeRank(self.data.uid, self.curSelectType)
  self.ctrl:CloseSelf()
end

function UILWAlAuthorityManagerView:OnTransformClick()
  self.ctrl:OnTransformLeader(self.data.uid)
  self.ctrl:CloseSelf()
end

return UILWAlAuthorityManagerView
