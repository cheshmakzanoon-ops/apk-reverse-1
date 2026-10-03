local base = require("UI.UILWArmedUpgrade.CityModelView.LWArmedUpgradeCityDirectorBase")
local LWArmedUpgradeZeroLevelCityDirector = BaseClass("LWArmedUpgradeZeroLevelCityDirector", base)
local actModelPath = "Assets/Main/Prefabs/LWCityEvent/ActorHero/SoliderActor1.prefab"
local actFireVfxPath = "Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_hero_AK_qiangkou_new.prefab"
local actMuzzlePath = "Model/GameObject/A_Hero_bubing02_SJ/Hero@bubing02_skin/To_unity/DeformationSystem/Root/gun"

function LWArmedUpgradeZeroLevelCityDirector:__init()
  self.directorConfig = {
    {
      Id = 1,
      PointType = BeginnerScriptPointType.SpawnCityActorHero,
      Params = {
        {
          actModelPath,
          {69, 39},
          {36, 19},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {69, 39},
          {36, 21},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {69, 39},
          {36, 23},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {69, 39},
          {36, 25},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {69, 39},
          {36, 27},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {69, 39},
          {36, 29},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {69, 39},
          {36, 52},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {69, 39},
          {36, 54},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {67, 38},
          {36, 44},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {65, 42},
          {36, 46},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {65, 42},
          {36, 48},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {67, 40},
          {36, 50},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        }
      }
    },
    {
      Id = 2,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 6},
          {row = 13, col = 10},
          {row = 15, col = 13}
        },
        {1, 4},
        {3, 6},
        0
      }
    },
    {
      Id = 3,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 20},
          {row = 13, col = 24},
          {row = 15, col = 30}
        },
        {1, 4},
        {3, 6},
        0
      }
    },
    {
      Id = 4,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 36},
          {row = 13, col = 40}
        },
        {1, 4},
        {3, 6},
        0
      }
    },
    {
      Id = 5,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 36},
          {row = 13, col = 40}
        },
        {5, 15},
        {1, 1},
        0
      }
    },
    {
      Id = 6,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 61},
          {row = 13, col = 50}
        },
        {5, 15},
        {1, 1},
        0
      }
    },
    {
      Id = 7,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 61},
          {row = 13, col = 66},
          {row = 15, col = 69}
        },
        {5, 15},
        {1, 1},
        0
      }
    },
    {
      Id = 8,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 45},
          {row = 13, col = 50},
          {row = 15, col = 54}
        },
        {2, 4},
        {3, 6},
        0
      }
    },
    {
      Id = 9,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 61},
          {row = 13, col = 66},
          {row = 15, col = 69}
        },
        {2, 4},
        {3, 9},
        0
      }
    }
  }
  self.chapterName = "ArmedUpgradeZeroLevelCityDirector"
end

function LWArmedUpgradeZeroLevelCityDirector:__delete()
  self.chapterName = nil
  self.directorConfig = nil
end

return LWArmedUpgradeZeroLevelCityDirector
