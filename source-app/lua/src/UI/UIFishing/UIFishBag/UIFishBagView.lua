local UIFishBagView = BaseClass("UIFishBagView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local FishBagItem = require("UI.UIFishing.UIFishBag.FishBagItemComponent")
local AllianceSkillDonateFishLogic = require("UI.LWSeason6.UILWSeasonDonateFish.Logic.AllianceSkillDonateFishLogic")
local use_text_path = "Root/BottomBar/UseBtn/UseText"

function UIFishBagView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UIFishBagView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFishBagView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.scrollRectItemHolder = self.viewSkin:AddComponent(self, UIScrollRect, 2)
  self.gridInfinityScrollViewItemContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 3)
  self.textInfoName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textInfoDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textNoItemTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnUse = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnUse:SetOnClick(function()
    self:OnBtnUseClick()
  end)
  self.compSelectFrame = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.textInfoName:SetLocalText("s6_fish_limit_9")
  self.textInfoDes:SetText("")
  self.textTitle:SetLocalText("s6_fish_title_3")
  self.textNoItemTxt:SetLocalText("s6_fish_limit_10")
  self.compSelectFrame:SetActive(false)
  self.listGO = {}
  self.use_text = self:AddComponent(UITextMeshProUGUIEx, use_text_path)
end

function UIFishBagView:ComponentDestroy()
  self.compSelectFrame.transform:SetParent(self.transform)
  self:ClearItemCell()
  self.listGO = {}
  self.viewSkin = nil
  self.textTitle = nil
  self.scrollRectItemHolder = nil
  self.gridInfinityScrollViewItemContent = nil
  self.textInfoName = nil
  self.textInfoDes = nil
  self.textNoItemTxt = nil
  self.btnUse = nil
  self.compSelectFrame = nil
  self.btnBack = nil
end

function UIFishBagView:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.SeasonFishGetPlayerFishInfo)
end

function UIFishBagView:DataDestroy()
end

function UIFishBagView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshMyFishList, self.RefreshList)
end

function UIFishBagView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshMyFishList, self.RefreshList)
  base.OnRemoveListener(self)
end

function UIFishBagView:OnEnable()
  base.OnEnable(self)
  self:RefreshList()
end

function UIFishBagView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIFishBagView:OnBtnUseClick()
  if self.curSelectIndex then
    local item = self.fishList[self.curSelectIndex]
    local meta = DataCenter.FishMetaManager:GetMeta(item.id)
    if meta.use_goods == 1 then
      do
        local function eatAction()
          DataCenter.FishingDataManager:FetchUseOneFish(item.id)
        end
        
        if DataCenter.FishingDataManager:HasAnyActiveStatus() then
          local tips = CS.GameEntry.Localization:GetString("s6_use_fish_buff_tips")
          
          local function leftCallback()
            eatAction()
          end
          
          UIUtil.ShowMessage(tips, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, leftCallback)
        else
          eatAction()
        end
        return
      end
    end
  end
  DataCenter.LWSoundManager:PlaySound(6100020, false)
  local energy = DataCenter.AllianceGovernmentCommonSkillManager:GetEnergyInfo()
  local logic = AllianceSkillDonateFishLogic.New(energy)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonDonateFish, {anim = true}, logic)
end

function UIFishBagView:Init()
  self:ClearItemCell()
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.gridInfinityScrollViewItemContent:Init(bindFunc1, bindFunc2, bindFunc3)
end

function UIFishBagView:OnInitScroll(go, index)
  local item = self.scrollRectItemHolder:AddComponent(FishBagItem, go)
  item:SetActive(false)
  self.listGO[go] = item
end

function UIFishBagView:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetData(theIndex, self.fishList[theIndex])
    cellItem:SetActive(true)
    if theIndex == self.curSelectIndex then
      self:OnSelectCell(cellItem.transform, theIndex)
    end
  end
end

function UIFishBagView:OnDestroyScrollItem(go, index)
  if index + 1 == self.curSelectIndex then
    self.compSelectFrame:SetActive(false)
  end
end

function UIFishBagView:RefreshList()
  self.fishList = DataCenter.FishingDataManager:GetMyFishList(true)
  local itemCount = #self.fishList
  if 0 < itemCount then
    if self.curSelectIndex == nil then
      self.curSelectIndex = 1
    else
      self.curSelectIndex = math.min(self.curSelectIndex, itemCount)
    end
    self.textNoItemTxt:SetActive(false)
  else
    self.textNoItemTxt:SetActive(true)
    self.curSelectIndex = nil
    self.textInfoName:SetLocalText("s6_fish_limit_9")
    self.textInfoDes:SetText("")
  end
  self.gridInfinityScrollViewItemContent:SetItemCount(itemCount)
  self.btnUse:SetActive(self.curSelectIndex ~= nil)
end

function UIFishBagView:ClearItemCell()
  self.scrollRectItemHolder:SetVerticalNormalizedPosition(1)
  self.scrollRectItemHolder:RemoveComponents(FishBagItem)
  self.gridInfinityScrollViewItemContent:DestroyChildNode()
end

function UIFishBagView:OnSelectCell(trans, index)
  self.curSelectIndex = index
  self.compSelectFrame.transform:SetParent(trans)
  self.compSelectFrame:SetAnchoredPositionXY(0, 5)
  self.compSelectFrame:SetLocalScaleXYZ(ResetScale.x, ResetScale.y, ResetScale.z)
  self.compSelectFrame:SetActive(true)
  self:RefreshInfo()
end

function UIFishBagView:RefreshInfo()
  if self.curSelectIndex then
    local item = self.fishList[self.curSelectIndex]
    local meta = DataCenter.FishMetaManager:GetMeta(item.id)
    self.textInfoDes:SetLocalText(meta.desc)
    self.textInfoName:SetLocalText(meta.name)
    self.use_text:SetLocalText(meta.use_goods == 0 and "s6_fish_btn_1" or "110046")
  else
    self.textInfoName:SetText("")
    self.textInfoDes:SetText("")
  end
end

return UIFishBagView
