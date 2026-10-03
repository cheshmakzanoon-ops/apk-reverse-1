local LWUIMasterySkillUseView = BaseClass("LWUIMasterySkillUseView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIMasterySkillUseCell = require("UI.LWUIMasterySkillUse.Component.LWUIMasterySkillUseCell")
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local learned_skill_content_path = "Root/ScrollView/Viewport/Content/learnedSkillContent"
local unlearned_skill_content_path = "Root/ScrollView/Viewport/Content/unlearnedSkillContent"
local learn_content_path = "Root/ScrollView/Viewport/Content/learnedSkillContent/learnContent"
local un_learn_content_path = "Root/ScrollView/Viewport/Content/unlearnedSkillContent/unLearnContent"

function LWUIMasterySkillUseView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWUIMasterySkillUseView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUIMasterySkillUseView:ComponentDefine()
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/CloseBtn")
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.learned_skill_content = self:AddComponent(UIBaseContainer, learned_skill_content_path)
  self.unlearned_skill_content = self:AddComponent(UIBaseContainer, unlearned_skill_content_path)
  self.learn_content = self:AddComponent(UIBaseContainer, learn_content_path)
  self.un_learn_content = self:AddComponent(UIBaseContainer, un_learn_content_path)
  self.learnItems = {}
  self.unlearnItems = {}
end

function LWUIMasterySkillUseView:ComponentDestroy()
  self:ClearAllItem()
  self.return_btn = nil
  self.close_btn = nil
  self.learned_skill_content = nil
  self.unlearned_skill_content = nil
  self.learn_content = nil
  self.un_learn_content = nil
  self.learnItems = nil
  self.unlearnItems = nil
end

function LWUIMasterySkillUseView:DataDefine()
  self.homeId = nil
  self.usePos = nil
  self.learnShowData = {}
  self.unlearnShowData = {}
end

function LWUIMasterySkillUseView:DataDestroy()
  self.homeId = nil
  self.usePos = nil
  self.learnShowData = {}
  self.unlearnShowData = {}
end

function LWUIMasterySkillUseView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MasteryUseSkill, self.Refresh)
  self:AddUIListener(EventId.LWMasterySkillUp, self.RebuildView)
end

function LWUIMasterySkillUseView:OnRemoveListener()
  self:RemoveUIListener(EventId.MasteryUseSkill, self.Refresh)
  self:RemoveUIListener(EventId.LWMasterySkillUp, self.RebuildView)
  base.OnRemoveListener(self)
end

function LWUIMasterySkillUseView:ClearAllItem()
  for _, v in pairs(self.learnItems) do
    self.learn_content:RemoveAsyncComponent(v)
  end
  self.learnItems = {}
  for _, v in pairs(self.unlearnItems) do
    self.un_learn_content:RemoveAsyncComponent(v)
  end
  self.unlearnItems = {}
end

function LWUIMasterySkillUseView:ReInit()
  self:ClearAllItem()
  self:InitShowData()
  self:InitView()
  self:Refresh()
end

function LWUIMasterySkillUseView:InitShowData()
  local data = DataCenter.MasteryManager:GetData()
  if data == nil then
    return
  end
  self.homeId = data.home_id
  self.usePos = MasterySkillUsePosType.SkillView
  self.homeDict = DataCenter.MasteryManager:GetHomeDict(self.homeId)
  self.learnShowData = {}
  self.unlearnShowData = {}
  for _, masteryId in ipairs(self.homeDict) do
    local skillState, endTime, masteryTemp, skillTemp = DataCenter.MasteryManager:GetMasteryGroupSkillState(masteryId)
    if masteryTemp and skillTemp and skillState ~= MasterySkillState.Covered then
      local showData = {
        masteryTemp = masteryTemp,
        skillTemp = skillTemp,
        endTime = endTime,
        skillState = skillState,
        canntUse = not skillTemp:CheckUsePosition(self.usePos)
      }
      if skillState == MasterySkillState.Locked then
        table.insert(self.unlearnShowData, showData)
      else
        table.insert(self.learnShowData, showData)
      end
    end
  end
end

function LWUIMasterySkillUseView:InitView()
  local learnNum = #self.learnShowData
  if 0 < learnNum then
    self.learned_skill_content:SetActive(true)
    for i = 1, learnNum do
      local item = self.learn_content:LoadComponentAsync(LWUIMasterySkillUseCell, "Assets/Main/Prefabs/UI/UIMastery/MasterySkillUseItem.prefab")
      self.learnItems[i] = item
    end
  else
    self.learned_skill_content:SetActive(false)
  end
  local unlearnNum = #self.unlearnShowData
  if 0 < unlearnNum then
    self.unlearned_skill_content:SetActive(true)
    for i = 1, unlearnNum do
      local item = self.un_learn_content:LoadComponentAsync(LWUIMasterySkillUseCell, "Assets/Main/Prefabs/UI/UIMastery/MasterySkillUseItem.prefab")
      self.unlearnItems[i] = item
    end
  else
    self.unlearned_skill_content:SetActive(false)
  end
end

function LWUIMasterySkillUseView:Refresh()
  for k, v in ipairs(self.learnItems) do
    local itemShowData = self.learnShowData[k]
    local skillState, endTime, masteryTemp, skillTemp = DataCenter.MasteryManager:GetMasteryGroupSkillState(itemShowData.masteryTemp.mastery_id)
    itemShowData.endTime = endTime
    itemShowData.skillState = skillState
    v:SetData(itemShowData)
  end
  for k, v in ipairs(self.unlearnItems) do
    local itemShowData = self.unlearnShowData[k]
    v:SetData(itemShowData)
  end
end

function LWUIMasterySkillUseView:RebuildView()
  self:ReInit()
end

function LWUIMasterySkillUseView:Update1000MS()
  for k, v in ipairs(self.learnItems) do
    v:RefreshTimeView()
  end
end

return LWUIMasterySkillUseView
