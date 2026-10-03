local Const = {}
Const.CampType = {Player = 1, Target = 2}
Const.SkillType = {
  ATTACK = 1,
  COUNTER_ATTACK = 2,
  SHIELD_ATTACK = 3,
  SHIELD = 4,
  RECOVER_DAMAGE = 5,
  ADD_EFFECT = 6,
  USE_SKILL = 7,
  ADD_ANGER = 8
}
Const.Define = {
  BUFF = "Buff",
  SKILL = "Skill",
  NORMAL_ATK = "Normal_Atk"
}
Const.Color = {
  Red = Color32.New(255, 0, 0, 255),
  Green = Color32.New(0, 139, 69, 255),
  White = Color32.New(255, 255, 255, 255)
}
Const.AniName = {
  Idle = "ready",
  Attack = "attack01",
  Weaken = "weaken"
}
Const.WeaponType = {Gun = 1}
Const.Result = {
  NoWar = 1,
  Win = 2,
  Fail = 3
}
return Const
