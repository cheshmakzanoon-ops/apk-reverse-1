local UIActMonsterTowerDiffTipsView = BaseClass("UIActMonsterTowerDiffTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen
local tip_path = "Tips"
local tips_txt_path = "Tips/TipsTitle"
local tips_boss_txt_path = "Tips/TipsTitleBoss"
local right_path = "Tips/Img_Right"
local left_path = "Tips/Img_Left"
local scroll_path = "Tips/ScrollView"
local content_path = "Tips/ScrollView/Viewport/Content"
local return_btn_path = "Panel"
local btn_choice_path = "Tips/Btn_Choice"
local txt_choice_path = "Tips/Btn_Choice/Txt_Choice"
local txt_bossName_path = "Tips/Txt_BossName"
local txt_bossDiff_path = "Tips/Txt_BossDiff"

local function OnCreate(self)
  base.OnCreate(self)
  local pos, isLeft, accumulate, cellW, activityId = self:GetUserData()
  self.pos = pos
  self.isleft = isLeft
  self.index = accumulate
  self.cellW = cellW or 0
  self.activityId = activityId or 0
  self.tip_obj = self:AddComponent(UIBaseContainer, tip_path)
  self.tips_txt = self:AddComponent(UIText, tips_txt_path)
  self.tips_boss_txt = self:AddComponent(UIText, tips_boss_txt_path)
  self.scroll_path = self:AddComponent(UIBaseContainer, scroll_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._right_img = self:AddComponent(UIImage, right_path)
  self._left_img = self:AddComponent(UIImage, left_path)
  self._choice_btn = self:AddComponent(UIButton, btn_choice_path)
  self._choice_btn:SetOnClick(function()
    self:ClickChoice()
  end)
  self._choice_txt = self:AddComponent(UIText, txt_choice_path)
  self._bossName_txt = self:AddComponent(UIText, txt_bossName_path)
  self._bossDiff_txt = self:AddComponent(UIText, txt_bossDiff_path)
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self.tip_obj = nil
  self.content = nil
  self.animator = nil
  self.return_btn = nil
  self.tips_txt = nil
  self.tips_boss_txt = nil
  self.isShowBtn = nil
  self.pos = nil
  self._right_img = nil
  self._left_img = nil
  self.cost = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self)
  local v3 = self.tip_obj.transform.position
  v3.x = self.pos.x
  v3.y = self.pos.y
  self.tip_obj.transform.position = v3
  local rectPos = self.tip_obj.rectTransform.anchoredPosition
  local rect = self.tip_obj.rectTransform.rect
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local halfScreenHeight = 375.0
  halfScreenHeight = halfScreenHeight - 30
  local width = rect.width
  local halfHeight = rect.height / 2
  local x = rectPos.x + self.cellW + width * 0.5
  local y = rectPos.y
  if not self.isleft then
    x = rectPos.x - width / 2 - self.cellW
  end
  if halfScreenHeight < y + halfHeight then
    y = halfScreenHeight - halfHeight
  end
  if y - halfHeight < -halfScreenHeight then
    y = halfHeight - halfScreenHeight
  end
  local tempAnchoredPosition = Vector2.New(x, y)
  self.tip_obj.rectTransform.anchoredPosition = tempAnchoredPosition
  self._right_img:SetActive(not self.isleft)
  self._left_img:SetActive(self.isleft)
  local template = DataCenter.ActMonsterTowerData:GetTemplateByIndex(self.index)
  self._bossDiff_txt:SetLocalText(372415)
  self.tips_boss_txt:SetLocalText(template.description)
  self.tips_txt:SetLocalText(372423)
  self._choice_txt:SetLocalText(372258)
  self._bossName_txt:SetLocalText(template.monster_des)
  self:SetAllCellDestroy()
  self.modelwelfare = {}
  local data = DataCenter.ActMonsterTowerData:GetInfoByActId(self.activityId)
  local list = data:GetDiffRewardByIndex(self.index)
  local newList = list.reward
  if newList ~= nil then
    for i = 1, table.length(newList) do
      self.modelwelfare[newList[i]] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(0.8, 0.8, 0.8)
        go.name = "itemReward" .. i
        local cell = self.content:AddComponent(UICommonResItem, go.name)
        cell:ReInit(newList[i])
      end)
    end
  end
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(UICommonResItem)
  if self.modelwelfare ~= nil then
    for k, v in pairs(self.modelwelfare) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function ClickChoice(self)
  UIUtil.ShowMessage(Localization:GetString("372426"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self.ctrl:CloseSelf()
    SFSNetwork.SendMessage(MsgDefines.ChooseChallengeActDifficulty, self.activityId, self.index)
  end, function()
  end)
end

UIActMonsterTowerDiffTipsView.OnCreate = OnCreate
UIActMonsterTowerDiffTipsView.OnDestroy = OnDestroy
UIActMonsterTowerDiffTipsView.RefreshData = RefreshData
UIActMonsterTowerDiffTipsView.OnEnable = OnEnable
UIActMonsterTowerDiffTipsView.OnDisable = OnDisable
UIActMonsterTowerDiffTipsView.ClickChoice = ClickChoice
UIActMonsterTowerDiffTipsView.SetAllCellDestroy = SetAllCellDestroy
return UIActMonsterTowerDiffTipsView
