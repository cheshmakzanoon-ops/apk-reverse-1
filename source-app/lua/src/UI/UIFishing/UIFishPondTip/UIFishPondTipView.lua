local UIFishPondTipView = BaseClass("UIFishPondTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen
local FishPondTipCell = require("UI.UIFishing.UIFishPondTip.FishPondTipCellComponent")
local CampKey = {
  "season_s6_activity_1200080_title03",
  "season_s6_activity_1200080_title04",
  "s6_fish_npc_camp_name"
}
local ArrowLength = 30

function UIFishPondTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UIFishPondTipView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFishPondTipView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTipsTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compImgRight = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compImgLeft = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.animatorAnim = self.viewSkin:AddComponent(self, UIAnimator, 5)
  self.compTips = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textSource = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compImgTop = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.compImgBottom = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.textEmpty:SetLocalText("s6_fish_limit_7")
end

function UIFishPondTipView:ComponentDestroy()
  self:ClearPondList()
  self.viewSkin = nil
  self.textTipsTitle = nil
  self.compImgRight = nil
  self.compImgLeft = nil
  self.compContent = nil
  self.animatorAnim = nil
  self.compTips = nil
  self.textEmpty = nil
  self.btnPanel = nil
  self.textSource = nil
  self.compImgTop = nil
  self.compImgBottom = nil
end

function UIFishPondTipView:DataDefine()
  local fishId = self:GetUserData()
  self.fishId = fishId
end

function UIFishPondTipView:DataDestroy()
end

function UIFishPondTipView:OnAddListener()
  base.OnAddListener(self)
end

function UIFishPondTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFishPondTipView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIFishPondTipView:Init()
  self:InitPosition()
  local meta = DataCenter.FishMetaManager:GetMeta(self.fishId)
  self.textTipsTitle:SetLocalText(meta.name)
  local fishId = self.fishId
  local sourceDic = {}
  local collectDic = DataCenter.FishMetaManager:GetCollectDic()
  for camp, levelDic in pairs(collectDic) do
    for level, idList in pairs(levelDic) do
      if 0 < level then
        for _, id in ipairs(idList) do
          if id == fishId then
            if sourceDic[camp] == nil then
              sourceDic[camp] = {}
            end
            table.insert(sourceDic[camp], level)
            break
          end
        end
      end
    end
  end
  local str = Localization:GetString("s6_fish_limit_1")
  for camp, levelList in pairs(sourceDic) do
    local campStr = Localization:GetString(CampKey[camp])
    local levelStr = table.concat(levelList, ",")
    local pondStr = Localization:GetString("s6_pond_name", levelStr)
    str = str .. campStr .. "(" .. pondStr .. ")\n"
  end
  self.textSource:SetText(str)
  local pondList = {}
  local allPondList = DataCenter.FishingDataManager:GetPondList(true)
  for _, pond in ipairs(allPondList) do
    if pond.cityTemplate == nil then
      pond.cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(pond.pondId)
    end
    local cityTemplate = pond.cityTemplate
    if cityTemplate then
      if pond.pondServerId == nil then
        pond.pondServerId = cityTemplate:GetServerIdByEnum(ServerEnum.Source)
      end
      local pondServerId = pond.pondServerId
      if pond.pondCampId == nil then
        pond.pondCampId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(pondServerId)
      end
      for camp, levelList in pairs(sourceDic) do
        if camp == pond.pondCampId then
          for _, level in ipairs(levelList) do
            if level == cityTemplate.level then
              table.insert(pondList, pond)
              break
            end
          end
        end
      end
    end
  end
  self:ClearPondList()
  for _, pond in ipairs(pondList) do
    local item = self.compContent:LoadComponentAsync(FishPondTipCell, "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/FishPondTipCell.prefab")
    item:SetData(pond)
    table.insert(self.pondItems, item)
  end
  self.textEmpty:SetActive(#pondList == 0)
end

function UIFishPondTipView:ClearPondList()
  if self.pondItems then
    for _, v in pairs(self.pondItems) do
      self.compContent:RemoveAsyncComponent(v)
    end
  end
  self.pondItems = {}
end

function UIFishPondTipView:InitPosition()
  self.compImgLeft:SetActive(false)
  self.compImgRight:SetActive(false)
  self.compImgTop:SetActive(false)
  self.compImgBottom:SetActive(false)
  local fishId, cellLTWorldX, cellLTWorldY, cellWidth, cellHeight = self:GetUserData()
  local sf = UIManager:GetInstance():GetScaleFactor()
  local v3 = self.compTips.transform.position
  v3.x = cellLTWorldX
  v3.y = cellLTWorldY
  self.compTips.transform.position = v3
  local cellLTAnchoredPosition = self.compTips.rectTransform.anchoredPosition
  local cellLTX = cellLTAnchoredPosition.x
  local cellLTY = cellLTAnchoredPosition.y
  local tipRect = self.compTips.rectTransform.rect
  local screenMaxX = Screen.width / sf / 2 - 1
  local screenMinX = -screenMaxX
  local screenMaxY = Screen.height / sf / 2 - 7
  local screenMinY = -screenMaxY
  local tipHeight = tipRect.height
  local tipWidth = tipRect.width
  local halfCellWidth = cellWidth / 2
  local halfCellHeight = cellHeight / 2
  local tipX = 0
  local tipY = 0
  local state
  if screenMaxX > cellLTX + cellWidth + tipWidth then
    state = 1
    tipX = cellLTX + cellWidth + tipWidth / 2
    tipY = cellLTY - cellHeight / 2
    self.compImgLeft:SetActive(true)
  elseif cellLTX > screenMinX + tipWidth then
    state = 2
    tipX = cellLTX - tipWidth / 2
    tipY = cellLTY - cellHeight / 2
    self.compImgRight:SetActive(true)
  elseif screenMaxX > cellLTX + halfCellWidth + tipWidth then
    state = 3
    tipX = cellLTX + halfCellWidth + tipWidth / 2
    tipY = cellLTY - cellHeight / 2
    self.compImgLeft:SetActive(true)
  elseif screenMinX + tipWidth + halfCellWidth < cellLTX + cellWidth then
    state = 4
    tipX = cellLTX + cellWidth - tipWidth / 2 - halfCellWidth
    tipY = cellLTY - cellHeight / 2
    self.compImgRight:SetActive(true)
  elseif screenMinY + tipHeight < cellLTY - cellHeight then
    state = 5
    tipX = cellLTX + cellWidth / 2
    tipY = cellLTY - cellHeight - tipHeight / 2
    self.compImgTop:SetActive(true)
  elseif screenMaxY > cellLTY + tipHeight then
    state = 6
    tipX = cellLTX + cellWidth / 2
    tipY = cellLTY + tipHeight / 2
    self.compImgBottom:SetActive(true)
  elseif cellLTY > screenMinY + tipHeight + halfCellHeight then
    state = 7
    tipX = cellLTX + cellWidth / 2
    tipY = cellLTY - halfCellHeight - tipHeight / 2
    self.compImgTop:SetActive(true)
  elseif screenMaxY > cellLTY - cellHeight + tipHeight + halfCellHeight then
    state = 8
    tipX = cellLTX + cellWidth / 2
    tipY = cellLTY - cellHeight + tipHeight / 2 + halfCellHeight
    self.compImgBottom:SetActive(true)
  else
    state = 9
  end
  tipX = Mathf.Clamp(tipX, screenMinX + tipWidth / 2, screenMaxX - tipWidth / 2)
  tipY = Mathf.Clamp(tipY, screenMinY + tipHeight / 2, screenMaxY - tipHeight / 2)
  local tempAnchoredPosition = Vector2.New(tipX, tipY)
  self.compTips.rectTransform.anchoredPosition = tempAnchoredPosition
  if state <= 4 then
    local arrowY = Mathf.Clamp(0, cellLTY - cellHeight + ArrowLength / 2 - tipY, cellLTY - ArrowLength / 2 - tipY)
    local x = self.compImgLeft:GetAnchoredPositionX(true)
    self.compImgLeft:SetAnchoredPositionXY(x, arrowY, true)
    x = self.compImgRight:GetAnchoredPositionX(true)
    self.compImgRight:SetAnchoredPositionXY(x, arrowY, true)
  elseif state <= 8 then
    local arrowX = Mathf.Clamp(0, cellLTX + ArrowLength / 2 - tipX, cellLTX + cellWidth - ArrowLength / 2 - tipX)
    local y = self.compImgTop:GetAnchoredPositionY()
    self.compImgTop:SetAnchoredPositionXY(arrowX, y, true)
    y = self.compImgBottom:GetAnchoredPositionY()
    self.compImgBottom:SetAnchoredPositionXY(arrowX, y, true)
  end
  self.animatorAnim:Play("CommonPopup_movein", 0, 0)
end

function UIFishPondTipView:RefreshSourceText()
  local fishId = self.fishId
  local sourceDic = {}
  local collectDic = DataCenter.FishMetaManager:GetCollectDic()
  for camp, levelDic in pairs(collectDic) do
    for level, idList in pairs(levelDic) do
      if 0 < level then
        for _, id in ipairs(idList) do
          if id == fishId then
            if sourceDic[camp] == nil then
              sourceDic[camp] = {}
            end
            table.insert(sourceDic[camp], level)
            break
          end
        end
      end
    end
  end
  local str = ""
  for camp, levelList in pairs(sourceDic) do
    local campStr = Localization:GetString(CampKey[camp])
    local levelStr = table.concat(levelList, ",")
    str = str .. campStr .. "(" .. levelStr .. ")\n"
  end
  self.textSource:SetText(str)
end

return UIFishPondTipView
