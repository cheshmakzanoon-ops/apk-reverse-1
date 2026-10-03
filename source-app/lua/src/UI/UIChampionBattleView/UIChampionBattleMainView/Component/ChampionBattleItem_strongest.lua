local ChampionBattleItem_strongest = BaseClass("ChampionBattleItem_strongest", UIBaseContainer)
local M = ChampionBattleItem_strongest
local base = UIBaseContainer
local GroupEighthFinalsCellItem = require("UI.UIChampionBattleView.UIChampionBattleMainView.Component.GroupEighthFinalsCellItem")
local GroupHonorListCellItem = require("UI.UIChampionBattleView.UIChampionBattleMainView.Component.GroupHonorListCellItem")
local Group_strongest_path = "Group_strongest"
local EverestList_path = "Group_strongest/EverestList"
local honorListBtn_path = "Group_strongest/EverestList/honorListBtn"
local honorListBtn_text_path = "Group_strongest/EverestList/honorListBtn/toggleLabel1"
local previewBtn_path = "Group_strongest/EverestList/previewBtn"
local previewBtn_text_path = "Group_strongest/EverestList/previewBtn/toggleLabel2"
local Group_previewList_path = "Group_strongest/Group_previewList"
local Group_EighthFinalsLeft_path = "Group_strongest/Group_previewList/Group_EighthFinalsLeft"
local leftSeverTxt_path = "Group_strongest/Group_previewList/Group_EighthFinalsLeft/Image_Sever/leftSeverTxt"
local Left_First_path = "Group_strongest/Group_previewList/Group_EighthFinalsLeft/Left_First"
local Left_Second_path = "Group_strongest/Group_previewList/Group_EighthFinalsLeft/Left_Second"
local Left_Third_path = "Group_strongest/Group_previewList/Group_EighthFinalsLeft/Left_Third"
local Left_Fourth_path = "Group_strongest/Group_previewList/Group_EighthFinalsLeft/Left_Fourth"
local Group_EighthFinalsRight_path = "Group_strongest/Group_previewList/Group_EighthFinalsRight"
local rightSeverTxt_path = "Group_strongest/Group_previewList/Group_EighthFinalsRight/Image_Sever/rightSeverTxt"
local Right_First_path = "Group_strongest/Group_previewList/Group_EighthFinalsRight/Right_First"
local Right_Second_path = "Group_strongest/Group_previewList/Group_EighthFinalsRight/Right_Second"
local Right_Third_path = "Group_strongest/Group_previewList/Group_EighthFinalsRight/Right_Third"
local Right_Fourth_path = "Group_strongest/Group_previewList/Group_EighthFinalsRight/Right_Fourth"
local Group_honorList_path = "Group_strongest/Group_honorList"
local distanceCdGo_path = "Group_strongest/Group_honorList/distanceCdGo/"
local distanceCdTxt_path = "Group_strongest/Group_honorList/distanceCdGo/distanceCdTxt"
local ChampionHave_path = "Group_strongest/Group_honorList/ChampionHave"
local Battle1_path = "Group_strongest/Group_honorList/Group_Player/Battle1"
local Battle2_path = "Group_strongest/Group_honorList/Group_Player/Battle2"
local Battle3_path = "Group_strongest/Group_honorList/Group_Player/Battle3"
local Battle4_path = "Group_strongest/Group_honorList/Group_Player/Battle4"
local Battle5_path = "Group_strongest/Group_honorList/Group_Player/Battle5"
local Battle6_path = "Group_strongest/Group_honorList/Group_Player/Battle6"
local Battle7_path = "Group_strongest/Group_honorList/Group_Player/Battle7"
local Group_explain_path = "Group_explain"
local explainTxt1_path = "Group_explain/explainTxt1"
local explainTxt2_path = "Group_explain/explainTxt2"
local explainTxt3_path = "Group_explain/explainTxt3"
local quarterfinal_left_path = "Group_strongest/Group_honorList/VFX_battle_trail_blue"
local quarterfinal_left_animation_path = "Group_strongest/Group_honorList/VFX_battle_trail_blue/V_ui_battle_anim_blue"
local quarterfinal_right_path = "Group_strongest/Group_honorList/VFX_battle_trail_red"
local quarterfinal_right_animation_path = "Group_strongest/Group_honorList/VFX_battle_trail_red/V_ui_battle_anim_red"
local semifinals_path = "Group_strongest/Group_honorList/VFX_battle_trail_vs"
local semifinals_animation_path = "Group_strongest/Group_honorList/VFX_battle_trail_vs/V_ui_battle_vs_anim"
local final_animation_path = "Group_strongest/Group_honorList/Group_VS"
local final_particle_cover_path = "Group_strongest/Group_honorList/Group_VS/VFX_lmjd_vs"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:ComponentDefine()
  self.Group_strongest = self:AddComponent(UIBaseContainer, Group_strongest_path)
  self.honorListBtn = self:AddComponent(UIToggle, honorListBtn_path)
  self.honorListBtn:SetIsOn(true)
  self.honorListBtn:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.honorListBtn_text = self:AddComponent(UIText, honorListBtn_text_path)
  self.honorListBtn_text:SetLocalText(302050)
  self.previewBtn = self:AddComponent(UIToggle, previewBtn_path)
  self.previewBtn:SetIsOn(false)
  self.previewBtn:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.previewBtn_text = self:AddComponent(UIText, previewBtn_text_path)
  self.previewBtn_text:SetLocalText(302051)
  self.Group_previewList = self:AddComponent(UIBaseContainer, Group_previewList_path)
  self.Group_EighthFinalsLeft = self:AddComponent(UIBaseContainer, Group_EighthFinalsLeft_path)
  self.leftSeverTxt = self:AddComponent(UIText, leftSeverTxt_path)
  self.Left_1 = self:AddComponent(UIBaseContainer, Left_First_path)
  self.Left_2 = self:AddComponent(UIBaseContainer, Left_Second_path)
  self.Left_3 = self:AddComponent(UIBaseContainer, Left_Third_path)
  self.Left_4 = self:AddComponent(UIBaseContainer, Left_Fourth_path)
  self.Group_EighthFinalsRight = self:AddComponent(UIBaseContainer, Group_EighthFinalsRight_path)
  self.rightSeverTxt = self:AddComponent(UIText, rightSeverTxt_path)
  self.Right_1 = self:AddComponent(UIBaseContainer, Right_First_path)
  self.Right_2 = self:AddComponent(UIBaseContainer, Right_Second_path)
  self.Right_3 = self:AddComponent(UIBaseContainer, Right_Third_path)
  self.Right_4 = self:AddComponent(UIBaseContainer, Right_Fourth_path)
  self.Group_honorList = self:AddComponent(UIBaseContainer, Group_honorList_path)
  self.distanceCdGo = self:AddComponent(UIBaseContainer, distanceCdGo_path)
  self.distanceCdTxt = self:AddComponent(UIText, distanceCdTxt_path)
  self.ChampionHave = self:AddComponent(UIBaseContainer, ChampionHave_path)
  self.Battle_1 = self:AddComponent(UIBaseContainer, Battle1_path)
  self.Battle_2 = self:AddComponent(UIBaseContainer, Battle2_path)
  self.Battle_3 = self:AddComponent(UIBaseContainer, Battle3_path)
  self.Battle_4 = self:AddComponent(UIBaseContainer, Battle4_path)
  self.Battle_5 = self:AddComponent(UIBaseContainer, Battle5_path)
  self.Battle_6 = self:AddComponent(UIBaseContainer, Battle6_path)
  self.Battle_7 = self:AddComponent(UIBaseContainer, Battle7_path)
  self.Group_explain = self:AddComponent(UIBaseContainer, Group_explain_path)
  self.explainTxt1 = self:AddComponent(UIText, explainTxt1_path)
  self.explainTxt2 = self:AddComponent(UIText, explainTxt2_path)
  self.explainTxt3 = self:AddComponent(UIText, explainTxt3_path)
  self:RegisterUIEvent()
  self.quarterfinal_left = self:AddComponent(UIBaseContainer, quarterfinal_left_path)
  self.quarterfinal_left_animation = self.transform:Find(quarterfinal_left_animation_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.quarterfinal_right = self:AddComponent(UIBaseContainer, quarterfinal_right_path)
  self.quarterfinal_right_animation = self.transform:Find(quarterfinal_right_animation_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.semifinals = self:AddComponent(UIBaseContainer, semifinals_path)
  self.semifinals_animation = self.transform:Find(semifinals_animation_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.final_animation = self.transform:Find(final_animation_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.final_particle_cover = self:AddComponent(UIBaseContainer, final_particle_cover_path)
end

function M:ShowQuarterfinalEffect(show)
end

function M:ShowSemifinalsEffect(show)
end

function M:ShowFinalEffect(show)
end

function M:DataDefine()
  self.loadingResource = {}
end

function M:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function M:ComponentDestroy()
  self.Battle_1:RemoveComponents(GroupHonorListCellItem)
  self.Battle_2:RemoveComponents(GroupHonorListCellItem)
  self.Battle_3:RemoveComponents(GroupHonorListCellItem)
  self.Battle_4:RemoveComponents(GroupHonorListCellItem)
  self.Battle_5:RemoveComponents(GroupHonorListCellItem)
  self.Battle_6:RemoveComponents(GroupHonorListCellItem)
  self.Battle_7:RemoveComponents(GroupHonorListCellItem)
  self.Left_1:RemoveComponents(GroupEighthFinalsCellItem)
  self.Left_2:RemoveComponents(GroupEighthFinalsCellItem)
  self.Left_3:RemoveComponents(GroupEighthFinalsCellItem)
  self.Left_4:RemoveComponents(GroupEighthFinalsCellItem)
  self.Right_1:RemoveComponents(GroupEighthFinalsCellItem)
  self.Right_2:RemoveComponents(GroupEighthFinalsCellItem)
  self.Right_3:RemoveComponents(GroupEighthFinalsCellItem)
  self.Right_4:RemoveComponents(GroupEighthFinalsCellItem)
  if self.finalAnimationTimer ~= nil then
    self.finalAnimationTimer:Stop()
    self.finalAnimationTimer = nil
  end
  self:StopTimer()
  self:UnregisterUIEvent()
end

function M:DataDestroy()
  self.loadingResource = nil
end

function M:RegisterUIEvent()
end

function M:UnregisterUIEvent()
end

function M:SetData(info)
  self:StopTimer()
  self.championBattleInfo = info
  if self.championBattleInfo == nil then
    return
  end
  local curIndexState = self.championBattleInfo:GetCurState()
  if curIndexState >= Activity_ChampionBattle_Stage_State.Strongest then
    self.Group_strongest:SetActive(true)
    self.Group_explain:SetActive(false)
    if self.previewBtn:GetIsOn() then
      self:onClick_previewBtn()
    else
      self.previewBtn:SetIsOn(true)
    end
  else
    self:SetAuditionsOver()
    self.Group_strongest:SetActive(false)
    self.Group_explain:SetActive(true)
  end
end

function M:SetAuditionsOver()
  self:RefreshTime()
  self.explainTxt1:SetLocalText(302031)
end

function M:ToggleControlBorS()
  if self.previewBtn:GetIsOn() then
    self:onClick_previewBtn()
  elseif self.honorListBtn:GetIsOn() then
    self:onClick_honorListBtn()
  end
end

function M:onClick_previewBtn()
  self.Group_previewList:SetActive(false)
  self.Group_honorList:SetActive(true)
  self:Refresh8StrongestHonorList()
  local bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k3")
  bgUrl = "Assets/Main/TextureEx/UIActivity/" .. bgUrl
  self.view:SetBgByChild(bgUrl)
end

function M:onClick_honorListBtn()
  self.Group_previewList:SetActive(true)
  self.Group_honorList:SetActive(false)
  self:Refresh8StrongestShow()
  local bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k6")
  bgUrl = "Assets/Main/TextureEx/UIActivity/" .. bgUrl
  self.view:SetBgByChild(bgUrl)
end

function M:RefreshTime()
  self:StopTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.OnTimer, self, false, false, false)
  end
  self.timer:Start()
  self:OnTimer()
end

function M:StopTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function M:OnTimer()
  if self.Group_explain == nil or self.championBattleInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.championBattleInfo.strongestST
  if curTime < endTime then
    self.distanceCdTxt:SetText("")
    self.explainTxt2:SetLocalText(302040)
    self.explainTxt3:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(endTime - curTime))
    self.explainTxt2:SetActive(true)
    self.explainTxt3:SetActive(true)
  else
    self.explainTxt2:SetActive(false)
    self.explainTxt3:SetActive(false)
    local nextRoundST = self.championBattleInfo.strongestNextRoundST
    if curTime < nextRoundST and self.nextSTDialog ~= nil then
      self.distanceCdTxt:SetLocalText(self.nextSTDialog, UITimeManager:GetInstance():MilliSecondToFmtString(nextRoundST - curTime))
      self.distanceCdGo:SetActive(true)
    else
      self.distanceCdTxt:SetText("")
      self.distanceCdGo:SetActive(false)
    end
  end
end

function M:Refresh8StrongestShow()
  self.leftSeverTxt:SetText("#" .. self.championBattleInfo.serverId1)
  self.rightSeverTxt:SetText("#" .. self.championBattleInfo.serverId2)
  local leftCount = 0
  if self.championBattleInfo.leftMembers ~= nil then
    leftCount = #self.championBattleInfo.leftMembers
  end
  local rightCount = 0
  if self.championBattleInfo.rightMembers ~= nil then
    rightCount = #self.championBattleInfo.rightMembers
  end
  
  local function AddOneCell(left, index, data)
    local name = "Left_"
    if left == false then
      name = "Right_"
    end
    name = name .. index
    if self.loadingResource[name] ~= nil then
      return
    end
    self.loadingResource[name] = 1
    local container = self[name]
    if container ~= nil then
      if container:GetComponent(tostring(index)) then
        container:GetComponent(tostring(index)):SetData(data, index)
      else
        self:GameObjectInstantiateAsync(UIAssets.GroupEighthFinalsCell, function(request)
          if request.isError then
            return
          end
          self.loadingResource[name] = nil
          local go = request.gameObject
          go:SetActive(true)
          go.transform:SetParent(container.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local nameStr = tostring(index)
          go.name = nameStr
          local tmp = container:AddComponent(GroupEighthFinalsCellItem, nameStr)
          tmp:SetData(data, index)
          go.transform.localPosition = ResetPosition
          go.transform:SetAsLastSibling()
        end)
      end
    end
  end
  
  for i = 1, 4 do
    local playerLeft = self.championBattleInfo.leftMembers[i]
    local playerRight = self.championBattleInfo.rightMembers[i]
    AddOneCell(true, i, playerLeft)
    AddOneCell(false, i, playerRight)
  end
end

function M:Refresh8StrongestHonorList()
  self.nextSTDialog = "302052"
  self:RefreshTime()
  local topCount = 0
  if self.championBattleInfo.topEightGroup ~= nil then
    topCount = #self.championBattleInfo.topEightGroup
  end
  
  local function AddOneCell(index, data, type)
    local name = "Battle_" .. index
    local container = self[name]
    if self.loadingResource[name] ~= nil then
      return
    end
    self.loadingResource[name] = 1
    if container ~= nil then
      if container:GetComponent(tostring(index)) then
        container:GetComponent(tostring(index)):SetData(data, index, type)
      else
        self:GameObjectInstantiateAsync(UIAssets.GroupHonorListCell, function(request)
          if request.isError then
            return
          end
          self.loadingResource[name] = nil
          local go = request.gameObject
          go:SetActive(true)
          go.transform:SetParent(container.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local nameStr = tostring(index)
          go.name = nameStr
          local tmp = container:AddComponent(GroupHonorListCellItem, nameStr)
          tmp:SetData(data, index, type)
          go.transform.localPosition = ResetPosition
          go.transform:SetAsLastSibling()
        end)
      end
    end
  end
  
  for i = 1, 4 do
    if i <= topCount then
      AddOneCell(i + 3, self.championBattleInfo.topEightGroup[i], ChampionBattlePosterType.Strongest_Eight)
    else
      AddOneCell(i + 3, nil, ChampionBattlePosterType.Strongest_Eight)
    end
  end
  local fourTopCount = 0
  if self.championBattleInfo.topFourGroup ~= nil then
    fourTopCount = #self.championBattleInfo.topFourGroup
  end
  for i = 1, 2 do
    if i <= fourTopCount then
      AddOneCell(i + 1, self.championBattleInfo.topFourGroup[i], ChampionBattlePosterType.Strongest_Four)
    else
      AddOneCell(i + 1, nil, ChampionBattlePosterType.Strongest_Four)
    end
  end
  local twoTopCount = 0
  if self.championBattleInfo.topTwoGroup ~= nil then
    twoTopCount = #self.championBattleInfo.topTwoGroup
  end
  self.ChampionHave:SetActive(false)
  for i = 1, 1 do
    if i <= twoTopCount then
      AddOneCell(i, self.championBattleInfo.topTwoGroup[i], ChampionBattlePosterType.Strongest_Two)
    else
      AddOneCell(i, nil, ChampionBattlePosterType.Strongest_Two)
    end
  end
  self:ShowQuarterfinalEffect(self.championBattleInfo.strongestType == ChampionBattlePosterType.Strongest_Eight)
  self:ShowSemifinalsEffect(self.championBattleInfo.strongestType == ChampionBattlePosterType.Strongest_Four)
  self:ShowFinalEffect(self.championBattleInfo.strongestType == ChampionBattlePosterType.Strongest_Two)
end

return M
