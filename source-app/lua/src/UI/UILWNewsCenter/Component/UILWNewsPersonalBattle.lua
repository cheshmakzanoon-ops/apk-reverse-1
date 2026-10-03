local base = require("UI.UILWNewsCenter.Component.UILWNewsBase")
local UILWNewsPersonalBattle = BaseClass("UILWNewsPersonalBattle", base)
local Localization = CS.GameEntry.Localization
local UIHead = require("UI.UILWNewsCenter.Component.UILWNewsUserCell")
local compBook = {
  {
    path = "imgBanner",
    name = "imgBanner",
    type = UIImage
  },
  {
    path = "imgBanner/imgCity",
    name = "imgCity",
    type = UIImage
  },
  {
    path = "imgBanner/txtCityInfo",
    name = "txtCityInfo",
    type = UIText
  },
  {
    path = "imgBanner/vfxBanner",
    name = "vfxBanner",
    type = UIBaseContainer
  },
  {
    path = "imgInfoBg/ChatHeadLeft",
    name = "headLeft",
    type = UIHead
  },
  {
    path = "imgInfoBg/ChatHeadRight",
    name = "headRight",
    type = UIHead
  },
  {
    path = "imgInfoBg/imgResultBg/txtWinLeft",
    name = "txtWinLeft",
    type = UIText
  },
  {
    path = "imgInfoBg/imgResultBg/txtLostLeft",
    name = "txtLostLeft",
    type = UIText
  },
  {
    path = "imgInfoBg/imgResultBg/txtWinRight",
    name = "txtWinRight",
    type = UIText
  },
  {
    path = "imgInfoBg/imgResultBg/txtLostRight",
    name = "txtLostRight",
    type = UIText
  },
  {
    path = "imgInfoBg/imgResultBg/txtNameLeft",
    name = "txtNameLeft",
    type = UIText
  },
  {
    path = "imgInfoBg/imgResultBg/txtNameRight",
    name = "txtNameRight",
    type = UIText
  },
  {
    path = "imgInfoBg/txtCasualtiesLeft",
    name = "txtCasualtiesLeft",
    type = UIText
  },
  {
    path = "imgInfoBg/txtCasualtiesRight",
    name = "txtCasualtiesRight",
    type = UIText
  },
  {
    path = "imgInfoBg/txtGroupLeft",
    name = "txtGroupLeft",
    type = UIText
  },
  {
    path = "imgInfoBg/txtGroupRight",
    name = "txtGroupRight",
    type = UIText
  },
  {
    path = "imgInfoBg/imgGroupLeft",
    name = "imgGroupLeft",
    type = UIImage
  },
  {
    path = "imgInfoBg/imgGroupRight",
    name = "imgGroupRight",
    type = UIImage
  },
  {
    path = "imgInfoBg/txtBarLeft",
    name = "txtBarLeft",
    type = UIText
  },
  {
    path = "imgInfoBg/txtBarRight",
    name = "txtBarRight",
    type = UIText
  },
  {
    path = "imgInfoBg/imgBarLeft",
    name = "imgBarLeft",
    type = UIImage
  },
  {
    path = "imgInfoBg/imgBarRight",
    name = "imgBarRight",
    type = UIImage
  },
  {
    path = "imgInfoBg/flagDL1",
    name = "flagDL1",
    type = nil
  },
  {
    path = "imgInfoBg/flagDL2",
    name = "flagDL2",
    type = nil
  },
  {
    path = "imgInfoBg/flagDL3",
    name = "flagDL3",
    type = nil
  },
  {
    path = "imgInfoBg/flagDL4",
    name = "flagDL4",
    type = nil
  },
  {
    path = "imgInfoBg/flagDL5",
    name = "flagDL5",
    type = nil
  },
  {
    path = "imgInfoBg/flagAL1",
    name = "flagAL1",
    type = nil
  },
  {
    path = "imgInfoBg/flagAL2",
    name = "flagAL2",
    type = nil
  },
  {
    path = "imgInfoBg/flagAL3",
    name = "flagAL3",
    type = nil
  },
  {
    path = "imgInfoBg/flagAL4",
    name = "flagAL4",
    type = nil
  },
  {
    path = "imgInfoBg/flagAL5",
    name = "flagAL5",
    type = nil
  },
  {
    path = "imgInfoBg/flagDR1",
    name = "flagDR1",
    type = nil
  },
  {
    path = "imgInfoBg/flagDR2",
    name = "flagDR2",
    type = nil
  },
  {
    path = "imgInfoBg/flagDR3",
    name = "flagDR3",
    type = nil
  },
  {
    path = "imgInfoBg/flagDR4",
    name = "flagDR4",
    type = nil
  },
  {
    path = "imgInfoBg/flagDR5",
    name = "flagDR5",
    type = nil
  },
  {
    path = "imgInfoBg/flagAR1",
    name = "flagAR1",
    type = nil
  },
  {
    path = "imgInfoBg/flagAR2",
    name = "flagAR2",
    type = nil
  },
  {
    path = "imgInfoBg/flagAR3",
    name = "flagAR3",
    type = nil
  },
  {
    path = "imgInfoBg/flagAR4",
    name = "flagAR4",
    type = nil
  },
  {
    path = "imgInfoBg/flagAR5",
    name = "flagAR5",
    type = nil
  },
  {
    path = "imgInfoBg/btnView",
    name = "btnView",
    type = UIButton
  },
  {
    path = "imgInfoBg/btnView/txtView",
    name = "txtView",
    type = UIText
  }
}

function UILWNewsPersonalBattle:ComponentDefine()
  base.ComponentDefine(self)
  self:DefineCompsByBook(compBook)
  self.txtTitle:SetText(Localization:GetString("800903"))
  self.btnView:SetOnClick(function()
    SFSNetwork.SendMessage(MsgDefines.CheckUserCityMove, self.info.dataObj.def.user.uid, self.info.dataObj.pointId)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWNewsCenter)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatNew_v2)
  end)
  self.txtView:SetText(Localization:GetString("800928"))
  self.flagsDL = {
    self.flagDL1,
    self.flagDL2,
    self.flagDL3,
    self.flagDL4,
    self.flagDL5
  }
  self.flagsAL = {
    self.flagAL1,
    self.flagAL2,
    self.flagAL3,
    self.flagAL4,
    self.flagAL5
  }
  self.flagsDR = {
    self.flagDR1,
    self.flagDR2,
    self.flagDR3,
    self.flagDR4,
    self.flagDR5
  }
  self.flagsAR = {
    self.flagAR1,
    self.flagAR2,
    self.flagAR3,
    self.flagAR4,
    self.flagAR5
  }
  self.vfxBanner:SetLocalScaleXYZ(CommonUtil.ArabicAutoMirrorFactor(), 1, 1)
end

function UILWNewsPersonalBattle:ComponentDestroy()
  self:ClearCompsByBook(compBook)
  base.ComponentDestroy(self)
end

function UILWNewsPersonalBattle:SetContentViewScript(chatMainView)
  self._contentViewScript = chatMainView
end

function UILWNewsPersonalBattle:UpdateItem(info, index)
  base.RefreshView(self, info)
  self.index = index
  local atk = self.info.dataObj.atk
  local def = self.info.dataObj.def
  local winner = self.info.dataObj.battleResult == 1 and atk or def
  self.headLeft:Refresh(atk.user.uid, atk.user.pic, atk.user.picver, atk.user.headSkinId, atk.user.headSkinET, atk.user.countryflag)
  self.headRight:Refresh(def.user.uid, def.user.pic, def.user.picver, def.user.headSkinId, def.user.headSkinET, def.user.countryflag)
  self.txtWinLeft:SetActive(winner == atk)
  self.txtWinRight:SetActive(winner == def)
  self.txtLostLeft:SetActive(winner == def)
  self.txtLostRight:SetActive(winner == atk)
  local atkAbbr = string.IsNullOrEmpty(atk.user.abbr) and " " or "[" .. atk.user.abbr .. "] "
  local defAbbr = string.IsNullOrEmpty(def.user.abbr) and " " or "[" .. def.user.abbr .. "] "
  local atkServer = LuaEntry.Player.serverId == atk.user.serverId and "" or "#" .. atk.user.serverId
  local defServer = LuaEntry.Player.serverId == def.user.serverId and "" or "#" .. def.user.serverId
  local showNameAtk = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(atk.user.uid, atk.user.name)
  local atkName = atkServer .. atkAbbr .. showNameAtk
  local showNameDef = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(def.user.uid, def.user.name)
  local defName = defServer .. defAbbr .. showNameDef
  local winnerName = winner == atk and atkName or defName
  self.txtNameLeft:SetText(atkName)
  self.txtNameRight:SetText(defName)
  local lostPowerAtk = atk.beforeBattlePower - atk.afterBattlePower
  local lostPowerDef = def.beforeBattlePower - def.afterBattlePower
  local lostSum = math.abs(lostPowerAtk + lostPowerDef)
  local lostDiff = math.abs(lostPowerAtk - lostPowerDef)
  local comment = ""
  if atk.playerNum + def.playerNum >= 4 then
    comment = Localization:GetString("800907", atk.playerNum + def.playerNum, winnerName)
  elseif atk.playerNum >= 2 and def.playerNum == 1 and winner == atk then
    comment = Localization:GetString("800908", atkName, atk.playerNum, defName)
  elseif atk.playerNum >= 2 and def.playerNum == 1 and winner == def then
    comment = Localization:GetString("800909", defName, atkName, atk.playerNum)
  elseif atk.playerNum == 1 and def.playerNum >= 2 and winner == def then
    comment = Localization:GetString("800910", defName, def.playerNum, atkName)
  elseif atk.allArmyUnitNum == 1 and 2 <= def.allArmyUnitNum and winner == atk then
    comment = Localization:GetString("800911", atkName, defName, def.allArmyUnitNum)
  elseif lostDiff < lostSum * 0.1 then
    comment = Localization:GetString("800912", winnerName)
  elseif lostDiff > lostSum * 0.5 then
    if winner == atk then
      comment = Localization:GetString("800913", atkName, defName)
    else
      comment = Localization:GetString("801343", defName, atkName)
    end
  elseif atk.rank <= 500 and winner == atk then
    comment = Localization:GetString("800914", atkName, defName)
  elseif def.rank <= 500 and winner == def then
    comment = Localization:GetString("800915", defName, atkName)
  end
  self.txtComment:SetText(comment)
  self.txtCasualtiesLeft:SetText(string.GetFormattedStr(-lostPowerAtk))
  self.txtCasualtiesRight:SetText(string.GetFormattedStr(-lostPowerDef))
  self.txtGroupLeft:SetText(atk.playerNum)
  self.txtGroupRight:SetText(def.playerNum)
  self.txtGroupLeft:SetActive(1 < atk.playerNum)
  self.txtGroupRight:SetActive(1 < def.playerNum)
  self.imgGroupLeft:SetActive(1 < atk.playerNum)
  self.imgGroupRight:SetActive(1 < def.playerNum)
  self.txtBarLeft:SetActive(false)
  self.txtBarRight:SetActive(false)
  local atkProgress = atk.beforeBattlePower > 0 and atk.afterBattlePower / atk.beforeBattlePower or 0
  local defProgress = def.beforeBattlePower > 0 and def.afterBattlePower / def.beforeBattlePower or 0
  self.imgBarLeft:SetSizeDelta(Vector2.New(346 * atkProgress, 38))
  self.imgBarRight:SetSizeDelta(Vector2.New(346 * defProgress, 38))
  for i = 1, 5 do
    self.flagsDL[i]:SetActive(false)
    self.flagsAL[i]:SetActive(false)
    self.flagsDR[i]:SetActive(false)
    self.flagsAR[i]:SetActive(false)
  end
  local lostArmy = math.max(atk.allArmyUnitNum - atk.leftArmyUnitNum, def.allArmyUnitNum - def.leftArmyUnitNum)
  if 2 <= lostArmy then
    for i = 1, atk.leftArmyUnitNum do
      if self.flagsAL[i] then
        self.flagsAL[i]:SetActive(true)
      end
    end
    for i = atk.leftArmyUnitNum + 1, atk.allArmyUnitNum do
      if self.flagsDL[i] then
        self.flagsDL[i]:SetActive(true)
      end
    end
    for i = 1, def.leftArmyUnitNum do
      if self.flagsAR[i] then
        self.flagsAR[i]:SetActive(true)
      end
    end
    for i = def.leftArmyUnitNum + 1, def.allArmyUnitNum do
      if self.flagsDR[i] then
        self.flagsDR[i]:SetActive(true)
      end
    end
  end
  if winner == atk and atk.rank <= 50 and def.rank <= 50 then
    local baseCfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, self.info.dataObj.baseLevel)
    self.imgCity:LoadSpriteAuto(baseCfg:GetBuildIconOutCity())
    self.txtCityInfo:SetText(defName)
    self.imgBanner:SetActive(true)
  else
    self.imgBanner:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  self._contentViewScript._scrollView.unity_looplistview2:OnItemSizeChanged(self.index)
end

function UILWNewsPersonalBattle.GetOVerrideHeight(info)
  local atk = info.dataObj.atk
  local def = info.dataObj.def
  local winner = info.dataObj.battleResult == 1 and atk or def
  if winner == atk and atk.rank <= 50 and def.rank <= 50 then
    return 787.41
  else
    return 511.41
  end
end

return UILWNewsPersonalBattle
