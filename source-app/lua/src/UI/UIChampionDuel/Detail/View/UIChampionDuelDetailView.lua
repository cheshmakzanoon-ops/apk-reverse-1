local UIChampionDuelDetailView = BaseClass("UIChampionDuelDetailView", UIBaseView)
local base = UIBaseView
local UIChampionDuelDetailItem = require("UI.UIChampionDuel.Detail.Component.UIChampionDuelDetailItem")
local title_path = "Common_bg_orange/Common_img_title/titleText"
local closeBtn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local scroll_view_path = "Common_bg_orange/Common_bg_orange2/ScrollView"
local content_path = "Common_bg_orange/Common_bg_orange2/ScrollView/Viewport/content"
local item_path = "Common_bg_orange/Common_bg_orange2/Item"
local item_content_path = "Common_bg_orange/Common_bg_orange2/ScrollView/Viewport/content/itemContent"
local text_tip_path = "Common_bg_orange/Common_bg_orange2/tip_text"
local progress_bg_path = "Common_bg_orange/Common_bg_orange2/ScrollView/Viewport/content/progressBg"
local progress_img_path = "Common_bg_orange/Common_bg_orange2/ScrollView/Viewport/content/progressBg/progressImg"
local BASE_H = 172

function UIChampionDuelDetailView:OnCreate()
  base.OnCreate(self)
  local stageId, beginTime = self:GetUserData()
  if stageId then
    self.curStageId = stageId
  else
    self.curStageId = DataCenter.ChampionDuelManager:GetCurStageId()
  end
  if beginTime then
    self.beginTime = beginTime
  else
    local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
    self.beginTime = actInfo ~= nil and actInfo.beginTime or 0
  end
  self.guideList = DataCenter.ChampionDuelManager:GetTemplateGuideList()
  self.showTime = self:GetUserData()
  self:ComponentDefine()
  self:RefreshView()
  self:OnOpenJumpPos()
end

function UIChampionDuelDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelDetailView:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("champion_duel_tips1056")
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.item = self:AddComponent(UIBaseContainer, item_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.content:SetAnchoredPositionXY(0, 0)
  self.item_content = self:AddComponent(UIBaseContainer, item_content_path)
  self.text_tip = self:AddComponent(UIText, text_tip_path)
  local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
  local list = actInfo ~= nil and actInfo.serverList or nil
  local sStr = ""
  if not table.IsNullOrEmpty(list) then
    for _, v in ipairs(list) do
      if sStr == "" then
        sStr = sStr .. "#" .. v
      else
        sStr = sStr .. " , #" .. v
      end
    end
  end
  if self.showTime then
    self.text_tip:SetLocalText("")
  else
    self.text_tip:SetLocalText("champion_duel_tips1167", sStr)
  end
  self.itemList = {}
  self.item.gameObject:GameObjectCreatePool()
  self.progress_bg = self:AddComponent(UIImage, progress_bg_path)
  self.progress_img = self:AddComponent(UIImage, progress_img_path)
end

function UIChampionDuelDetailView:ComponentDestroy()
  self:ClearAllItem()
  self.title = nil
  self.close_btn = nil
  self.closeBg = nil
  self.scroll_view = nil
  self.item = nil
  self.content = nil
  self.item_content = nil
  self.text_tip = nil
  self.progress_bg = nil
  self.progress_img = nil
  self.showTime = nil
  base.OnDestroy(self)
end

function UIChampionDuelDetailView:ClearAllItem()
  self.item_content:RemoveComponents(UIChampionDuelDetailItem)
  for _, v in ipairs(self.item_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.item.gameObject:GameObjectRecycleAll()
  self.itemList = {}
end

function UIChampionDuelDetailView:GetCurIndex()
  return self.curStageId
end

function UIChampionDuelDetailView:RefreshView()
  local count = #self.guideList
  if #self.itemList ~= count then
    self:ClearAllItem()
    if 0 < count then
      for i = 1, count do
        local item = self.item.gameObject:GameObjectSpawn(self.item_content.transform)
        item.name = i
        local obj = self.item_content:AddComponent(UIChampionDuelDetailItem, item.name)
        obj:SetActive(true)
        self.itemList[i] = obj
      end
    end
  end
  local curIndex = self:GetCurIndex()
  for i = 1, count do
    self.itemList[i]:SetData(self.guideList[i], self.beginTime, curIndex)
  end
  self.progress_bg:SetAnchoredPositionXY(20, -80)
  self.progress_bg:SetSizeDeltaXY(37, BASE_H * (count - 1))
  self.progress_img:SetSizeDeltaXY(37, BASE_H * (curIndex - 1))
end

function UIChampionDuelDetailView:OnOpenJumpPos()
  local count = #self.guideList
  local itemH = BASE_H
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scroll_view.transform)
  local scrollH = self.scroll_view.rectTransform.rect.height
  local contentH = count * itemH
  local curIndex = self:GetCurIndex()
  local jumpPosY = (curIndex - 1) * itemH
  local maxJump = math.max(0, contentH - scrollH)
  if jumpPosY > maxJump then
    jumpPosY = maxJump
  end
  self.content:SetAnchoredPositionXY(0, jumpPosY)
end

function UIChampionDuelDetailView:Update1000MS()
  if self.showTime then
    local remainTime = DataCenter.ChampionDuelManager:GetChampionDuelPreviewRemainTime()
    self.text_tip:SetLocalText("champion_duel_tips1181", UITimeManager:GetInstance():SecondToFmtString(remainTime))
  end
end

return UIChampionDuelDetailView
