local UIGhostParkourRecordPopView = BaseClass("UIGhostParkourRecordPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RecordScrollView = require("UI.UIGhostParkour.Outside.RecordPop.Component.RecordScrollViewComponent")
local SelectItem = require("UI.UIGhostParkour.Outside.RecordPop.Component.SelectItemComponent")
local textString = {
  "ghost_parkour_record_all",
  "ghost_parkour_record_attack",
  "ghost_parkour_record_defense"
}

function UIGhostParkourRecordPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

function UIGhostParkourRecordPopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourRecordPopView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textVictories = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textFights = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textDefeats = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnArrow = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnArrow:SetOnClick(function()
    self:OnBtnArrowClick()
  end)
  self.imgArrow = self.viewSkin:AddComponent(self, UIImage, 9)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.RecordScrollView = self.viewSkin:AddComponent(self, RecordScrollView, 11)
  self.imgTemplate = self.viewSkin:AddComponent(self, UIImage, 12)
end

function UIGhostParkourRecordPopView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textVictories = nil
  self.textFights = nil
  self.textDefeats = nil
  self.textLabel = nil
  self.btnArrow = nil
  self.imgArrow = nil
  self.content = nil
  self.RecordScrollView = nil
  self.imgTemplate = nil
end

function UIGhostParkourRecordPopView:DataDefine()
  self.diffItems = {}
  self.diffReqs = {}
end

function UIGhostParkourRecordPopView:DataDestroy()
  self:RemoveDiffItems()
  self.ChooseDiffFun = nil
  self.selectType = nil
  self.recordInfos = nil
end

function UIGhostParkourRecordPopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostParkourRecordRefresh, self.UpdateUI)
end

function UIGhostParkourRecordPopView:OnRemoveListener()
  self:RemoveUIListener(EventId.GhostParkourRecordRefresh, self.UpdateUI)
  base.OnRemoveListener(self)
end

function UIGhostParkourRecordPopView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourRecordPopView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourRecordPopView:OnBtnArrowClick()
  if self.imgTemplate:GetActive() then
    self.imgTemplate:SetActive(false)
    self.imgArrow:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png")
  else
    self.imgTemplate:SetActive(true)
    self.imgArrow:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png")
  end
end

function UIGhostParkourRecordPopView:InitUI()
  self.selectType = GhostParkourRecordType.All
  self.textLabel:SetLocalText(textString[self.selectType])
  self:InitDropDown()
  DataCenter.LWGhostParkourDataManager:SendGhostParkourGetChallengeRecordMessage()
end

function UIGhostParkourRecordPopView:UpdateUI()
  self.recordInfos = DataCenter.LWGhostParkourDataManager:GetGhostParkourRecord()
  if self.recordInfos then
    self.textVictories:SetLocalText("ghost_parkour_win_count", self.recordInfos.winCount)
    self.textDefeats:SetLocalText("ghost_parkour_lose_count", self.recordInfos.defeatCount)
    self.textFights:SetLocalText("ghost_parkour_pk_count", self.recordInfos.defeatCount + self.recordInfos.winCount)
  end
  self:RefreshList(self.selectType)
end

function UIGhostParkourRecordPopView:InitDropDown()
  function self.ChooseDiffFun(level)
    return UIGhostParkourRecordPopView.ChooseDiff(self, level)
  end
  
  for i = 1, 3 do
    local diffIndex = i
    self.diffReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/GhostParkourBattle/OutsideUI/UIGhostParkourRecordSelectItem.prefab", function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local transform = go.transform
      go:SetActive(true)
      transform:SetParent(self.content.transform)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(diffIndex)
      go.name = nameStr
      local cell = self.content:AddComponent(SelectItem, nameStr)
      cell:Refresh(diffIndex)
      cell:ExecuteCallback(self.ChooseDiffFun)
      cell:SetCheckmark(self.selectType == diffIndex)
      self.diffItems[diffIndex] = cell
    end)
  end
end

function UIGhostParkourRecordPopView:ChooseDiff(type)
  self.selectType = type
  self.textLabel:SetLocalText(textString[self.selectType])
  if self.diffItems then
    for k, v in pairs(self.diffItems) do
      local diff = v.type and v.type or 1
      v:SetCheckmark(diff == type)
    end
  end
  self.imgTemplate:SetActive(false)
  self.imgArrow:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png")
  self:RefreshList(type)
end

function UIGhostParkourRecordPopView:RefreshList(type)
  self.RecordScrollView:RefreshList(type)
end

function UIGhostParkourRecordPopView:RemoveDiffItems()
  self.diffItems = nil
  self.content:RemoveComponents(SelectItem)
  if self.diffReqs then
    for _, v in pairs(self.diffReqs) do
      v:Destroy()
    end
    self.diffReqs = nil
  end
end

return UIGhostParkourRecordPopView
