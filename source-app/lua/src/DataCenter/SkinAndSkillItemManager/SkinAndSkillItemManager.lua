local SkinAndSkillItemManager = BaseClass("SkinAndSkillItemManager")
local Localization = CS.GameEntry.Localization

function SkinAndSkillItemManager:__init()
end

function SkinAndSkillItemManager:__delete()
end

function SkinAndSkillItemManager:RequestUseSkinItem(itemId)
  local param = {}
  param.itemId = itemId
  SFSNetwork.SendMessage(MsgDefines.UseSkinItemAndSkill, param)
end

return SkinAndSkillItemManager
