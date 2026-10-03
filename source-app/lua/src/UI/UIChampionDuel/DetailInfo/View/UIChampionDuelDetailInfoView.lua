local UIChampionDuelDetailInfoView = BaseClass("UIChampionDuelDetailInfoView", UIBaseView)
local base = UIBaseView
local UIChampionDuelDetailInfoItemBig = require("UI.UIChampionDuel.DetailInfo.Component.UIChampionDuelDetailInfoItemBig")
local UIChampionDuelDetailInfoItemSmall = require("UI.UIChampionDuel.DetailInfo.Component.UIChampionDuelDetailInfoItemSmall")
local title_path = "Common_bg_orange/Common_img_title/titleText"
local closeBtn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local scroll_view_path = "Common_bg_orange/Common_bg_orange2/ScrollView"
local content_path = "Common_bg_orange/Common_bg_orange2/ScrollView/Viewport/Content"
local itemBig_path = "Common_bg_orange/Common_bg_orange2/ItemBig"
local itemSmall_path = "Common_bg_orange/Common_bg_orange2/ItemSmall"

function UIChampionDuelDetailInfoView:OnCreate()
  base.OnCreate(self)
  self.guidePage = self:GetUserData()
  self.guideList = DataCenter.ChampionDuelManager:GetTemplateGuideByPage(self.guidePage)
  self:ComponentDefine()
  self:RefreshView()
end

function UIChampionDuelDetailInfoView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelDetailInfoView:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  local strKey = DataCenter.ChampionDuelManager:GetStageStrKey(self.guidePage)
  self.title:SetLocalText(strKey)
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.itemBig = self.transform:Find(itemBig_path).gameObject
  self.itemBig:GameObjectCreatePool()
  self.itemSmall = self.transform:Find(itemSmall_path).gameObject
  self.itemSmall:GameObjectCreatePool()
end

function UIChampionDuelDetailInfoView:ComponentDestroy()
  self:ClearAllItem()
  self.title = nil
  self.close_btn = nil
  self.closeBg = nil
  self.scroll_view = nil
  self.content = nil
  self.itemBig = nil
  self.itemSmall = nil
  base.OnDestroy(self)
end

function UIChampionDuelDetailInfoView:ClearAllItem()
  self.content:RemoveComponents(UIChampionDuelDetailInfoItemBig)
  self.content:RemoveComponents(UIChampionDuelDetailInfoItemSmall)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.itemBig:GameObjectRecycleAll()
  self.itemSmall:GameObjectRecycleAll()
end

function UIChampionDuelDetailInfoView:RefreshView()
  self:ClearAllItem()
  local count = self.guideList ~= nil and #self.guideList or 0
  if 0 < count then
    for i, data in ipairs(self.guideList) do
      local item
      if data.type == 3 then
        item = self.itemBig.gameObject:GameObjectSpawn(self.content.transform)
      else
        item = self.itemSmall.gameObject:GameObjectSpawn(self.content.transform)
      end
      item.name = i
      local obj
      if data.type == 3 then
        obj = self.content:AddComponent(UIChampionDuelDetailInfoItemBig, item.name)
      else
        obj = self.content:AddComponent(UIChampionDuelDetailInfoItemSmall, item.name)
      end
      obj:SetActive(true)
      obj:ReInit(data)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scroll_view.transform)
  end
  self.content:SetAnchoredPositionXY(0, 0)
end

return UIChampionDuelDetailInfoView
